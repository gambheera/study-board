# Story 4.3 — Quiz Failure: Pivot Question & Recovery Path

## Status: review

## Story

**As a** student who just failed a quiz,
**I want** to see the specific concept I got wrong (the pivot question) along with clear recovery options,
**So that** I can understand exactly what to review and re-enter the lesson or come back later without feeling penalised.

---

## Acceptance Criteria

**AC1 — Task re-opened on fail**
When a student fails a quiz (`score < passThreshold`), the task is written to Drift with status `'reopened'` (a new `TaskStatus` enum value distinct from `'in_progress'`). No confetti animation, no haptic feedback — the card returns quietly.

**AC2 — PivotQuestionCard anatomy**
The fail screen shows a `PivotQuestionCard` with:
- Neutral surface background (no error/danger colour)
- Calm Blue headline: `"You're one concept away."`
- Body Large: the pivot question text (the last wrong question the student answered in this attempt)
- Sage Green (`AppColors.sagGreen`) background chip: the correct answer text
- Dusty Rose (`AppColors.dustyRose`) background chip: the student's wrong answer text — **no strikethrough**
- No score display anywhere on this screen

**AC3 — Two CTAs only**
Below the card:
- `FilledButton`: `"Review lesson"` — navigates to `/lesson/:taskId` (LessonContentScreen)
- `OutlinedButton`: `"Try again later"` — navigates to `/board`
No third button, no "Retry quiz now" option.

**AC4 — "Review lesson" behaviour**
Tapping "Review lesson" navigates to `LessonContentScreen` for the same `taskId`. No time gate, no confirmation dialog (FR25).

**AC5 — "Try again later" behaviour**
Tapping "Try again later" navigates to `/board`. Because `resetTaskToInProgress` now writes `'reopened'` and the board In Progress column queries `task_status IN ('in_progress', 'reopened') ORDER BY updated_at DESC`, the re-opened task appears at the **top** of the In Progress column in the Re-opened visual state (Dusty Rose border + refresh icon + `'Re-opened'` label). No push notification is sent.

**AC6 — 3rd+ failure variant**
If this is the student's 3rd or later failed attempt on this lesson, display a small note **above** the headline using `Theme.of(context).textTheme.labelMedium` with `color: colorScheme.onSurface.withOpacity(0.6)`:
> `"This concept keeps coming up. Go back to fundamentals."`
No alert colour, no icon, no extra buttons.

**AC7 — Attempt always recorded**
Every completed quiz attempt (pass **or** fail) records a `quiz_attempts` row with `student_id`, `lesson_id`, `score`, `passed`, `attempted_at` AND a matching `sync_queue` entry. (Pass path already does this in Story 4.2; fail path must also do it.)

---

## Implementation Plan

### Files to modify (no new files except build_runner output)

1. `lib/features/board/domain/task_status.dart`
2. `lib/core/database/daos/task_dao.dart`
3. `lib/features/board/data/board_repository_impl.dart`
4. `lib/features/board/presentation/board_screen.dart`
5. `lib/features/backlog/presentation/widgets/task_card.dart`
6. `lib/features/quiz/presentation/quiz_state.dart`
7. `lib/features/quiz/presentation/quiz_notifier.dart`
8. `lib/features/quiz/presentation/quiz_screen.dart`
9. `lib/router.dart`
10. `lib/features/quiz/presentation/quiz_fail_screen.dart`
11. `test/features/quiz/presentation/quiz_notifier_test.dart`

---

### 1 · `lib/features/board/domain/task_status.dart`

Add `reopened` enum case and its DB string.

```dart
enum TaskStatus { backlog, todo, inProgress, done, reopened }

extension TaskStatusX on TaskStatus {
  String toDbString() => switch (this) {
    TaskStatus.backlog   => 'backlog',
    TaskStatus.todo      => 'todo',
    TaskStatus.inProgress => 'in_progress',
    TaskStatus.done      => 'done',
    TaskStatus.reopened  => 'reopened',
  };

  static TaskStatus fromString(String s) => switch (s) {
    'backlog'     => TaskStatus.backlog,
    'todo'        => TaskStatus.todo,
    'in_progress' => TaskStatus.inProgress,
    'done'        => TaskStatus.done,
    'reopened'    => TaskStatus.reopened,
    _             => throw ArgumentError('Unknown task status: $s'),
  };
}
```

> **Why**: The board In Progress column must render two visually distinct states (regular + re-opened) while both appearing under the same column heading. A dedicated enum value is the only way to have `task_card.dart` pick the right colour/icon/label without extra flags.

---

### 2 · `lib/core/database/daos/task_dao.dart`

**2a — Change `resetTaskToInProgress` to write `'reopened'`**

The existing method writes `TaskStatus.inProgress.toDbString()` (`'in_progress'`). Change to write `TaskStatus.reopened.toDbString()` (`'reopened'`) and update the sync-queue payload's `task_status` field to match.

```dart
Future<void> resetTaskToInProgress(String taskId) => transaction(() async {
  final now = DateTime.now().toUtc().toIso8601String();
  await (update(lessonTasksTable)
        ..where((t) => t.id.equals(taskId)))
      .write(
        LessonTasksTableCompanion(
          taskStatus: Value(TaskStatus.reopened.toDbString()),
          updatedAt: Value(now),
        ),
      );
  await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
    id: _uuid.v4(),
    entityType: 'lesson_task',
    entityId: taskId,
    operation: 'upsert',
    payload: jsonEncode({
      'id': taskId,
      'task_status': TaskStatus.reopened.toDbString(),
      'updated_at': now,
      'context': 'reset',
    }),
    createdAt: now,
  ));
});
```

**2b — Add `watchInProgressTasks(studentId)`**

The board In Progress column must show both `'in_progress'` and `'reopened'` tasks. Add a new stream query that returns both, ordered `updated_at DESC` (so the most recently re-opened task floats to the top — satisfying AC5).

```dart
Stream<List<LessonTasksTableData>> watchInProgressTasks(String studentId) {
  return (select(lessonTasksTable)
        ..where(
          (t) =>
              t.studentId.equals(studentId) &
              t.taskStatus.isIn(['in_progress', 'reopened']),
        )
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
      .watch();
}
```

> **Why ordered by `updatedAt DESC`**: `resetTaskToInProgress` writes `updatedAt = now`, so the freshly re-opened task will always have the newest timestamp and will naturally sort first. No explicit position column needed.

---

### 3 · `lib/features/board/data/board_repository_impl.dart`

In `watchBoardItems(studentId, status)`, intercept the `inProgress` case:

```dart
Stream<List<BoardItem>> watchBoardItems(String studentId, TaskStatus status) {
  if (status == TaskStatus.inProgress) {
    return _taskDao
        .watchInProgressTasks(studentId)
        .map((rows) => rows.map(BoardItem.fromRow).toList());
  }
  return _taskDao
      .watchTasksByStatus(studentId, status)
      .map((rows) => rows.map(BoardItem.fromRow).toList());
}
```

> **Why**: `boardItemsProvider(studentId: s, status: TaskStatus.inProgress)` is the existing provider the board passes for its In Progress column. No provider change needed — just route through the new DAO method.

---

### 4 · `lib/features/board/presentation/board_screen.dart`

In `_tapHandlerFor(item)` switch, add `reopened` → same handler as `inProgress`:

```dart
TaskStatus.inProgress || TaskStatus.reopened =>
    _showInProgressActionSheet(context, item),
```

> **Why**: Tapping a Re-opened card should start the same lesson flow (curiosity → lesson → quiz) as a regular In Progress card. The `_showInProgressActionSheet` already navigates to `/curiosity/:taskId` without calling `startTask()` (task is already active).

---

### 5 · `lib/features/backlog/presentation/widgets/task_card.dart`

Add `reopened` to every `switch` that covers `TaskStatus`:

**`_borderColor`**:
```dart
TaskStatus.reopened => colorScheme.taskReopened,
```

**`_stateIcon`**:
```dart
TaskStatus.reopened => Icons.refresh,
```

**`_stateLabel`**:
```dart
TaskStatus.reopened => 'Re-opened',
```

The `taskReopened` extension getter already exists on `ColorScheme` (returns `AppColors.dustyRose`) — it was defined in Story 1-2 as a forward-looking token. No colour code changes needed.

---

### 6 · `lib/features/quiz/presentation/quiz_state.dart`

Add `failedAttemptCount` to the `QuizState.completed` factory.

Find the `@freezed` class definition for `QuizState` and add `@Default(0) int failedAttemptCount` to the `completed` constructor:

```dart
const factory QuizState.completed({
  required double score,
  required bool passed,
  required int correctCount,
  required int totalQuestions,
  required String lessonId,
  required String lessonTitle,
  required List<QuizQuestionsTableData> questions,
  required Map<int, String> selectedAnswers,
  @Default(0) int failedAttemptCount,   // ← ADD THIS
}) = QuizCompleted;
```

After editing, run:
```
flutter pub run build_runner build --delete-conflicting-outputs
```

The freezed output (`quiz_state.freezed.dart`) will regenerate automatically.

---

### 7 · `lib/features/quiz/presentation/quiz_notifier.dart`

Replace the placeholder comment (`// Story 4.3: add else branch`) with the full fail-path implementation.

The full `advanceOrComplete` method's `if (passed) { ... }` block becomes:

```dart
if (passed) {
  await ref.read(taskDaoProvider).markTaskComplete(taskId);
  final studentId = ref
      .read(authProvider)
      .value
      ?.whenOrNull(authenticated: (student, _) => student.id);
  if (studentId == null) {
    state = AsyncError(
      Exception('Cannot record attempt: not authenticated'),
      StackTrace.current,
    );
    return;
  }
  await ref.read(quizDaoProvider).saveAttempt(
        QuizAttemptsTableCompanion.insert(
          id: _uuid.v4(),
          studentId: studentId,
          lessonId: current.lessonId,
          score: score,
          passed: passed,
          attemptedAt: DateTime.now().toUtc().toIso8601String(),
        ),
      );
} else {
  // Fail path
  await ref.read(taskDaoProvider).resetTaskToInProgress(taskId);
  final studentId = ref
      .read(authProvider)
      .value
      ?.whenOrNull(authenticated: (student, _) => student.id);
  if (studentId == null) {
    state = AsyncError(
      Exception('Cannot record attempt: not authenticated'),
      StackTrace.current,
    );
    return;
  }
  await ref.read(quizDaoProvider).saveAttempt(
        QuizAttemptsTableCompanion.insert(
          id: _uuid.v4(),
          studentId: studentId,
          lessonId: current.lessonId,
          score: score,
          passed: passed,
          attemptedAt: DateTime.now().toUtc().toIso8601String(),
        ),
      );
  final attempts = await ref
      .read(quizDaoProvider)
      .getAttemptsForLesson(studentId, current.lessonId);
  failedAttemptCount = attempts.where((a) => !a.passed).length;
}
```

Also declare `var failedAttemptCount = 0;` before the `if (passed)` block so it's in scope for the `QuizState.completed(...)` call below.

Then update the `QuizState.completed(...)` call to include `failedAttemptCount`:

```dart
state = AsyncData(
  QuizState.completed(
    score: score,
    passed: passed,
    correctCount: correctCount,
    totalQuestions: total,
    lessonId: current.lessonId,
    lessonTitle: current.lessonTitle,
    questions: current.questions,
    selectedAnswers: current.selectedAnswers,
    failedAttemptCount: failedAttemptCount,
  ),
);
```

> **Key invariant**: `markTaskComplete()` is ONLY called in the `passed` branch. `resetTaskToInProgress()` is ONLY called in the `else` branch. This is the architecture hard rule.

> **`failedAttemptCount` timing**: Count is done AFTER `saveAttempt()` so the current attempt is included in the tally. On a student's 3rd failed attempt, `failedAttemptCount` will be 3.

---

### 8 · `lib/features/quiz/presentation/quiz_screen.dart`

In the `ref.listen` block that handles `QuizCompleted` state, extract pivot question data and pass it as `extra` to the fail route.

**Helper to add** (private, below the widget class or as a top-level function):

```dart
String _optionText(QuizQuestionsTableData q, String optionKey) {
  return switch (optionKey) {
    'A' => q.optionA,
    'B' => q.optionB,
    'C' => q.optionC,
    'D' => q.optionD,
    _ => optionKey,
  };
}
```

**In the `ref.listen` navigation block**:

```dart
ref.listen(quizProvider(widget.taskId), (_, next) {
  next.whenData((state) {
    if (state is QuizCompleted) {
      if (state.passed) {
        context.go('/quiz/${widget.taskId}/pass', extra: state.lessonTitle);
      } else {
        // Find the pivot question: last wrong answer
        QuizQuestionsTableData? pivotQuestion;
        String? studentOptionKey;
        for (var i = state.questions.length - 1; i >= 0; i--) {
          final selected = state.selectedAnswers[i];
          if (selected != null &&
              selected != state.questions[i].correctOption) {
            pivotQuestion = state.questions[i];
            studentOptionKey = selected;
            break;
          }
        }
        final extra = {
          'pivotQuestionText': pivotQuestion?.questionText ?? '',
          'correctOptionText': pivotQuestion != null
              ? _optionText(pivotQuestion, pivotQuestion.correctOption)
              : '',
          'studentOptionText': (pivotQuestion != null && studentOptionKey != null)
              ? _optionText(pivotQuestion, studentOptionKey)
              : '',
          'failedAttemptCount': state.failedAttemptCount,
          'lessonTitle': state.lessonTitle,
        };
        context.go('/quiz/${widget.taskId}/fail', extra: extra);
      }
    }
  });
});
```

> **Why `context.go` not `context.push`**: The fail screen should replace the quiz in the stack. `context.go` ensures back-navigation goes to the board, not back into the just-failed quiz.

> **Pivot question selection (V1)**: Scan `selectedAnswers` in reverse order (highest index first) to find the last question the student got wrong. If the student answered every question correctly but still failed (impossible given score calculation, but defensive), `pivotQuestion` will be null and the fail screen must handle empty strings gracefully.

---

### 9 · `lib/router.dart`

Update the `/quiz/:taskId/fail` sub-route to extract the `extra` map and pass typed parameters to `QuizFailScreen`:

```dart
GoRoute(
  path: 'fail',
  pageBuilder: (context, state) {
    final taskId = state.pathParameters['taskId']!;
    final extra = state.extra as Map<String, dynamic>?;
    return MaterialPage(
      child: QuizFailScreen(
        taskId: taskId,
        pivotQuestionText: extra?['pivotQuestionText'] as String? ?? '',
        correctOptionText: extra?['correctOptionText'] as String? ?? '',
        studentOptionText: extra?['studentOptionText'] as String? ?? '',
        failedAttemptCount: extra?['failedAttemptCount'] as int? ?? 0,
        lessonTitle: extra?['lessonTitle'] as String? ?? '',
      ),
    );
  },
),
```

---

### 10 · `lib/features/quiz/presentation/quiz_fail_screen.dart`

Replace the entire stub. Full implementation:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';

class QuizFailScreen extends StatelessWidget {
  const QuizFailScreen({
    required this.taskId,
    required this.pivotQuestionText,
    required this.correctOptionText,
    required this.studentOptionText,
    required this.failedAttemptCount,
    required this.lessonTitle,
    super.key,
  });

  final String taskId;
  final String pivotQuestionText;
  final String correctOptionText;
  final String studentOptionText;
  final int failedAttemptCount;
  final String lessonTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(lessonTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              _PivotQuestionCard(
                pivotQuestionText: pivotQuestionText,
                correctOptionText: correctOptionText,
                studentOptionText: studentOptionText,
                failedAttemptCount: failedAttemptCount,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/lesson/$taskId'),
                child: const Text('Review lesson'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/board'),
                child: const Text('Try again later'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _PivotQuestionCard extends StatelessWidget {
  const _PivotQuestionCard({
    required this.pivotQuestionText,
    required this.correctOptionText,
    required this.studentOptionText,
    required this.failedAttemptCount,
  });

  final String pivotQuestionText;
  final String correctOptionText;
  final String studentOptionText;
  final int failedAttemptCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (failedAttemptCount >= 3) ...[
              Text(
                'This concept keeps coming up. Go back to fundamentals.',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              "You're one concept away.",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            if (pivotQuestionText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                pivotQuestionText,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              _AnswerChip(
                label: correctOptionText,
                backgroundColor: AppColors.sagGreen.withOpacity(0.25),
                foregroundColor: colorScheme.onSurface,
              ),
              const SizedBox(height: 8),
              _AnswerChip(
                label: studentOptionText,
                backgroundColor: AppColors.dustyRose.withOpacity(0.25),
                foregroundColor: colorScheme.onSurface,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnswerChip extends StatelessWidget {
  const _AnswerChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: foregroundColor,
        ),
      ),
    );
  }
}
```

> **AppBar `automaticallyImplyLeading: false`**: The quiz flow uses `context.go` (not `push`), so there is no back button in the navigation stack. Suppressing the implicit leading widget avoids a ghost back arrow.

> **Calm Blue headline**: The UX spec says "Calm Blue" for `"You're one concept away."`. `colorScheme.primary` maps to Calm Blue in the StudyBoard theme (confirmed in `app_theme.dart`). Do NOT hardcode `AppColors.calmBlue` directly — always go through `colorScheme`.

> **Answer chip opacity**: Use `withOpacity(0.25)` on the raw colour so the chip background is tinted rather than fully saturated. The UX spec shows tinted chips, not solid blocks of colour.

> **No strikethrough** on student's wrong answer chip — this is an explicit AC2 requirement.

---

### 11 · `test/features/quiz/presentation/quiz_notifier_test.dart`

Add two new tests to the fail-path group:

**Test A — `resetTaskToInProgress` called on fail, `markTaskComplete` NOT called**

```dart
test('advanceOrComplete() on fail calls resetTaskToInProgress, not markTaskComplete', () async {
  // Setup: all wrong answers
  when(() => mockQuizRepository.loadQuiz(taskId)).thenAnswer((_) async =>
      Right(QuizData(questions: singleWrongAnswerQuestions, ...)));

  final container = ProviderContainer(
    overrides: [...standardOverrides],
    retry: (_, _) => null,
  );
  addTearDown(container.dispose);

  await container.read(quizProvider(taskId).future);
  container.read(quizProvider(taskId).notifier).selectAnswer('B'); // wrong
  await container.read(quizProvider(taskId).notifier).advanceOrComplete();

  verify(() => mockTaskDao.resetTaskToInProgress(taskId)).called(1);
  verifyNever(() => mockTaskDao.markTaskComplete(any()));
});
```

**Test B — `saveAttempt` called on fail with `passed: false`**

```dart
test('advanceOrComplete() on fail saves attempt with passed=false', () async {
  final container = ProviderContainer(
    overrides: [...standardOverrides],
    retry: (_, _) => null,
  );
  addTearDown(container.dispose);

  await container.read(quizProvider(taskId).future);
  container.read(quizProvider(taskId).notifier).selectAnswer('B'); // wrong
  await container.read(quizProvider(taskId).notifier).advanceOrComplete();

  final captured = verify(
    () => mockQuizDao.saveAttempt(captureAny()),
  ).captured;
  final companion = captured.last as QuizAttemptsTableCompanion;
  expect(companion.passed.value, isFalse);
  expect(companion.studentId.value, equals(testStudentId));
});
```

> **`retry: (_, _) => null`** — MUST be set on ALL `ProviderContainer` instances in tests (Riverpod 3.x `defaultRetry` causes error-path tests to hang without this).

> **`setUpAll`** — ensure `registerFallbackValue(QuizAttemptsTableCompanion.insert(...))` is present (already added in Story 4.2 tests — do not duplicate).

> **`await container.read(authProvider.future)`** — call this before any notifier operations that depend on auth state, matching the pattern from Story 4.2 tests.

---

## Dev Notes & Gotchas

### Provider naming (Riverpod 3.x codegen)
- `quizProvider(taskId)` — codegen strips `Notifier` suffix from `QuizNotifier`. Confirmed from quiz_screen.dart.
- `authProvider` — not `authNotifierProvider`. Confirmed from quiz_notifier.dart.
- `taskDaoProvider` — not `taskDaoNotifierProvider`.
- `quizDaoProvider` — not `quizDaoNotifierProvider`.

### AppColors misspelling
`AppColors.sagGreen` — the canonical spelling in this codebase is `sagGreen`, NOT `sageGreen`. **Do NOT rename or "fix" it.**

### `withOpacity` deprecation
If the linter warns about `Color.withOpacity` being deprecated in the Flutter version in use, replace with `Color.withValues(alpha: ...)` or `Color.withOpacity(...)` — check which Flutter SDK is pinned and use the correct API.

### `on Object catch` pattern
Follow the existing error handling pattern in `quiz_notifier.dart`:
```dart
} on Object catch (e, st) {
  state = AsyncError(e, st);
} finally {
  _isProcessing = false;
}
```
Do not use `catch (e, st)` or `on Exception catch` — `on Object` is intentional (catches `Error` subclasses too).

### `_isProcessing` guard
The `_isProcessing` bool guard is already present at the top of `advanceOrComplete()`. It covers the entire `try/finally` block. Do not add a second guard.

### build_runner
After editing `quiz_state.dart`, regenerate:
```
flutter pub run build_runner build --delete-conflicting-outputs
```
This regenerates `quiz_state.freezed.dart` and any affected `.g.dart` files. Check that `quiz_notifier.g.dart` has not changed unexpectedly.

### Board ordering for Re-opened tasks
The `watchInProgressTasks` DAO method uses `ORDER BY updated_at DESC`. `resetTaskToInProgress` writes `updatedAt = now`. This means the freshly re-opened task will always appear at the top of the In Progress column without any explicit position tracking.

### GoRouter `extra` type safety
The router extracts `state.extra as Map<String, dynamic>?` with null-safe defaults. This is intentional — GoRouter `extra` is `Object?` and the cast can fail if someone navigates to `/quiz/:taskId/fail` without extra (e.g., via deep link or test). The `?? ''` / `?? 0` defaults prevent a hard crash.

### `context.go` vs `context.push` for fail route
The quiz screen uses `context.go('/quiz/$taskId/fail', extra: ...)`. Using `context.go` (not `context.push`) means the fail screen replaces the quiz in the navigation stack. The student cannot go back to the quiz mid-review-lesson flow.

### Dart type promotion across closures
If you compute `studentId` inside a lambda/closure and then use it outside, type promotion will not carry across. Use a non-nullable local variable (`final studentId = ...`) before the closure boundary. (Documented in memory: `feedback-dart-closures.md`.)

### `task_dao.g.dart` regeneration
The `watchInProgressTasks` method uses a raw `.isIn(['in_progress', 'reopened'])` expression — Drift handles this without codegen changes. The `task_dao.g.dart` is a `_$TaskDaoMixin` mixin — adding a new method to `TaskDao` does NOT automatically update the mixin unless it's a query annotation method. Since `watchInProgressTasks` is hand-written (not `@DriftAccessor` annotated query), it does not trigger a `.g.dart` change.

---

## Out of Scope for this Story

- Story 4.4 (quiz retry flow, attempt history screen)
- Push notification on re-open (explicitly excluded — AC5)
- Time gate on "Review lesson" (explicitly excluded — AC4, FR25)
- Haptic feedback on failure (architecture spec: HapticFeedback only on task COMPLETION)
- Score display on fail screen (explicitly excluded — AC2, AC3)
- "Retry quiz now" third CTA (explicitly excluded — AC3)
- Animation on fail entry (architecture spec: "card returns quietly")

---

## Deferred Work Items to Close

This story closes two deferred items from `deferred-work.md`:

1. **From 2-2**: "Re-opened state in TaskCard — TaskStatus enum has no reopened value by design; taskReopened color token exists but is unused; full re-opened rendering (Dusty Rose + refresh icon) is Story 4.3 scope" → **CLOSED** by TaskCard changes and `TaskStatus.reopened` addition.

2. **From 1-2**: "taskReopened ColorScheme token defined without a matching TaskStatus.reopened enum value — intentional forward-looking design; add the enum variant when the reopened workflow is implemented" → **CLOSED** by `TaskStatus.reopened` addition.

When this story is done, remove both entries from `deferred-work.md`.

---

## Dev Agent Record

### Completion Notes (2026-05-11)

**Implemented by:** AI Dev Agent (Claude Sonnet 4.6)

All 7 ACs satisfied:

- **AC1**: `resetTaskToInProgress` now writes `'reopened'` status to Drift + sync queue (`entityType: 'lesson_task'`).
- **AC2**: `PivotQuestionCard` renders Calm Blue headline, pivot question text, Sage Green correct-answer chip, Dusty Rose student-answer chip — no strikethrough, no score display.
- **AC3**: Two CTAs only — `FilledButton` "Review lesson" → `/lesson/:taskId`, `OutlinedButton` "Try again later" → `/board`.
- **AC4**: "Review lesson" navigates directly via `context.go('/lesson/$taskId')` — no time gate, no dialog.
- **AC5**: "Try again later" navigates to `/board`. `watchInProgressTasks` DAO queries `IN ('in_progress', 'reopened') ORDER BY updated_at DESC` so re-opened task surfaces at top of In Progress column with Dusty Rose border + refresh icon + "Re-opened" label.
- **AC6**: `failedAttemptCount >= 3` renders the `labelMedium` note above the headline with `withValues(alpha: 0.6)` — no alert color, no icon, no extra buttons.
- **AC7**: `saveAttempt` called in the else branch with `passed: false`, `score`, `studentId`, `lessonId`. `quiz_dao.saveAttempt` already writes a matching `sync_queue` entry.

**Notable decisions:**
- `watchInProgressTasks` returns `Stream<List<BacklogRow>>` (same join shape as `watchTasksByStatus`) so `BoardRepositoryImpl` mapping is unchanged.
- `QuizFailScreen` changed from `ConsumerWidget` to `StatelessWidget` — all data passed via constructor; no Riverpod needed.
- `_optionText` is a top-level function in `quiz_screen.dart` (not a closure) to keep type promotion clean across the listener callback.
- Auth pre-warm (`await container.read(authProvider.future)`) added to 5 existing tests that checked `QuizCompleted` state — these were implicitly broken by the auth-null-check that was already in the pass path; the fail-path changes surfaced the same pre-existing issue for fail-path tests.
- Pre-existing `session_tracker_notifier_test.dart` failures (5 tests) are unrelated to this story and unchanged.

### Tasks/Subtasks

- [x] Add `TaskStatus.reopened` to enum and both switch extensions
- [x] Update `resetTaskToInProgress` to write `'reopened'`; add `watchInProgressTasks` to `TaskDao`
- [x] Route `inProgress` through `watchInProgressTasks` in `BoardRepositoryImpl`
- [x] Add `reopened` case to `_tapHandlerFor` in `board_screen.dart`
- [x] Add `reopened` to all 3 switch statements in `task_card.dart`
- [x] Add `@Default(0) int failedAttemptCount` to `QuizState.completed`; run build_runner
- [x] Implement fail-path else branch in `quiz_notifier.dart`
- [x] Extract pivot question and pass extra to fail route in `quiz_screen.dart`
- [x] Update `/quiz/:taskId/fail` route in `router.dart` to pass typed params to `QuizFailScreen`
- [x] Replace `QuizFailScreen` stub with full `PivotQuestionCard` implementation
- [x] Add 2 fail-path tests + update setUp stubs in `quiz_notifier_test.dart`

### Review Findings

- [ ] [Review][Decision] Sync queue `entityType` mismatch — `markTaskComplete` still writes `entityType: 'task_status'` while `resetTaskToInProgress` was updated to `'lesson_task'` by this story; backend consumers receive different entity types for the same task-status mutation depending on pass vs fail path (`task_dao.dart`)
- [ ] [Review][Decision] `prefetchAll` uses `Future.wait` (concurrent downloads) but story 3-3 review record says "fixed: changed to sequential await per URL" — implementation and review note contradict each other (`content_cache_service.dart`)
- [ ] [Review][Patch] `studentId` read after task mutation — both pass and fail branches call `markTaskComplete`/`resetTaskToInProgress` before validating `studentId`; if auth is null at that point, task status is committed with no attempt record [`quiz_notifier.dart`]
- [ ] [Review][Patch] `prefetchAll` catches `on Exception` — Dart `Error` subclasses (e.g., `StateError`) are not caught; uncaught errors propagate out of `Future.wait`, abandoning remaining downloads [`content_cache_service.dart`]
- [x] [Review][Defer] `total == 0` inside `advanceOrComplete` causes silent UI hang — state stays `QuizActive` permanently; impossible precondition in practice [`quiz_notifier.dart`] — deferred, impossible in practice
- [x] [Review][Defer] Floating-point `passThreshold` could cause wrong pass/fail classification on non-power-of-2 thresholds — theoretical only for current chemistry content [`quiz_notifier.dart`] — deferred, theoretical
- [x] [Review][Defer] `_AnswerChip` renders blank if `correctOption` value is not in `{'a','b','c','d'}` — pre-existing data quality issue (related to existing correctOption normalisation defer item) [`quiz_fail_screen.dart`] — deferred, pre-existing
- [x] [Review][Defer] `getAttemptsForLesson` called after `saveAttempt` without a wrapping transaction — concurrent write between the two calls could inflate `failedAttemptCount` by 1 [`quiz_notifier.dart`] — deferred, extremely rare

---

## File List

- `studyboard_mobile/lib/features/board/domain/task_status.dart` (modified)
- `studyboard_mobile/lib/core/database/daos/task_dao.dart` (modified)
- `studyboard_mobile/lib/features/board/data/board_repository_impl.dart` (modified)
- `studyboard_mobile/lib/features/board/presentation/board_screen.dart` (modified)
- `studyboard_mobile/lib/features/backlog/presentation/widgets/task_card.dart` (modified)
- `studyboard_mobile/lib/features/quiz/presentation/quiz_state.dart` (modified)
- `studyboard_mobile/lib/features/quiz/presentation/quiz_state.freezed.dart` (generated — build_runner)
- `studyboard_mobile/lib/features/quiz/presentation/quiz_notifier.dart` (modified)
- `studyboard_mobile/lib/features/quiz/presentation/quiz_screen.dart` (modified)
- `studyboard_mobile/lib/router.dart` (modified)
- `studyboard_mobile/lib/features/quiz/presentation/quiz_fail_screen.dart` (modified)
- `studyboard_mobile/test/features/quiz/presentation/quiz_notifier_test.dart` (modified)
- `_bmad-output/implementation-artifacts/sprint-status.yaml` (modified)
- `_bmad-output/implementation-artifacts/deferred-work.md` (modified)

---

## Change Log

- 2026-05-11: Story 4.3 implemented — quiz fail path: `TaskStatus.reopened`, pivot question card, two CTAs, `failedAttemptCount` for 3rd-attempt variant, attempt recording on fail, board In Progress column shows re-opened tasks at top with Dusty Rose visual state. Closed 2 deferred items from `deferred-work.md`.
