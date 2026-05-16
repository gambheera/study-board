# Story 4.2: Quiz Pass — Task Completion Gate & Dopamine Moment

Status: done

## Story

As a student,
I want to feel the haptic pulse and see the task slide to Done when I pass a quiz,
So that I know my completion is real, verified, and earned — not just logged.

## Acceptance Criteria

1. **Given** a student's quiz score meets or exceeds the subject's configured pass threshold (Chemistry = 80%)
   **When** the result is evaluated
   **Then** `TaskDao.markTaskComplete(taskId)` is the ONLY code path that sets `task_status = 'done'` — called exclusively from `QuizNotifier.advanceOrComplete()`, no other method, notifier, or widget may write `'done'` directly

2. **Given** `markTaskComplete()` is called
   **When** the Drift write completes
   **Then** the `TaskCompletionAnimation` triggers on the pass screen: `Transform.scale` animates 1.0 → 1.04 → 1.0 over 300ms with `Curves.easeOut`, the left-border color transitions from Golden Yellow (`AppColors.goldenYellow`) to Sage Green (`AppColors.sagGreen`) over 200ms, and `HapticFeedback.mediumImpact()` fires exactly once at peak scale (not `lightImpact`, not `heavyImpact`)

3. **Given** the animation completes
   **When** the card settles
   **Then** the pass screen displays "[ Lesson title ] — complete." (no exclamation mark, no score shown), a `RepaintBoundary` isolates `TaskCompletionAnimation` from parent widget rebuilds, and a "Back to board" `FilledButton` is the sole CTA

4. **Given** the student taps "Back to board"
   **When** the Board renders
   **Then** the completed task is no longer visible in the In Progress column (stream already updated since `markTaskComplete()` ran before navigation), the Done tab is visible if this is the first completion, and the dashboard coverage ring increments silently — no modal, no banner

5. **Given** the task completion event
   **When** `markTaskComplete()` runs
   **Then** a sync queue entry is enqueued in the same Drift transaction as the status update (already implemented in `TaskDao.markTaskComplete()`) — no change needed here; and a `quiz_attempts` record is inserted in Drift with `student_id`, `lesson_id`, `score`, `passed`, `attempted_at` fields, with its own sync queue entry

6. **Given** the pass screen
   **When** a TalkBack user reaches it
   **Then** the semantics announce: "[ Lesson title ] complete. Button: Back to board."

## Tasks / Subtasks

- [x] Task 1: Extend `QuizDao.getQuizContextForTask()` to return `lessonTitle` + fix `saveAttempt()` sync payload (AC: #5)
  - [x] Open `lib/core/database/daos/quiz_dao.dart`
  - [x] Change return type of `getQuizContextForTask()` from `Future<({String lessonId, double passThreshold})?>` to `Future<({String lessonId, double passThreshold, String lessonTitle})?>`
  - [x] In `getQuizContextForTask()`, add `lessonTitle: row.readTable(lessonsTable).title` to the returned record (`LessonsTable` is already in `@DriftAccessor` and the JOIN)
  - [x] In `saveAttempt()`, add `'score': companion.score.value` and `'passed': companion.passed.value` to the sync queue JSON payload (currently those fields are missing from the payload, though the Drift insert is correct)
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` to regenerate `quiz_dao.g.dart`

- [x] Task 2: Add `lessonTitle` to `QuizData`, `QuizActive`, `QuizCompleted` (AC: #3)
  - [x] Open `lib/features/quiz/domain/quiz_repository.dart` — add `lessonTitle: String` to the `QuizData` typedef
  - [x] Open `lib/features/quiz/presentation/quiz_state.dart` — add `required String lessonTitle` field to BOTH `QuizState.active(...)` and `QuizState.completed(...)` factories (between `lessonId` and the remaining fields, after `passThreshold` for active)
  - [x] Run build_runner (combine with Task 6 build_runner run)

- [x] Task 3: Update `QuizRepositoryImpl.loadQuiz()` to pass `lessonTitle` (AC: #3)
  - [x] Open `lib/features/quiz/data/quiz_repository_impl.dart`
  - [x] In `loadQuiz()`, update the `Right(...)` return to include `lessonTitle: context.lessonTitle`

- [x] Task 4: Update `QuizNotifier` — add pass-path side effects and `lessonTitle` propagation (AC: #1, #5)
  - [x] Open `lib/features/quiz/presentation/quiz_notifier.dart`
  - [x] Add imports: `dart:async` (for `unawaited`), `package:uuid/uuid.dart`, `package:studyboard_mobile/core/database/database_provider.dart`, `package:studyboard_mobile/features/auth/presentation/auth_notifier.dart`
  - [x] Change `void advanceOrComplete()` to `Future<void> advanceOrComplete() async`
  - [x] In `build()`, add `lessonTitle: data.lessonTitle` to `QuizState.active(...)` constructor call
  - [x] In `advanceOrComplete()`, add `lessonTitle: current.lessonTitle` to the `QuizState.completed(...)` constructor call
  - [x] In `advanceOrComplete()`, after calculating `score` and `passed`, add the pass-path block
  - [x] Add imports for `QuizAttemptsTableCompanion` (from `core/database/app_database.dart` or the table file)

- [x] Task 5: Update `QuizScreen.ref.listen` to pass `lessonTitle` as GoRouter `extra` (AC: #3)
  - [x] Open `lib/features/quiz/presentation/quiz_screen.dart`
  - [x] In the `ref.listen` block, update the navigation call for `state.passed`
  - [x] Wrap the `advanceOrComplete()` callback with `unawaited()`
  - [x] Add `import 'dart:async' show unawaited;` at the top

- [x] Task 6: Update `router.dart` to pass `lessonTitle` to `QuizPassScreen` (AC: #3)
  - [x] Open `lib/router.dart`
  - [x] Find the `/quiz/:taskId/pass` nested route
  - [x] Update `pageBuilder` to extract `lessonTitle` from `state.extra`

- [x] Task 7: Create `TaskCompletionAnimation` widget (AC: #2, #3)
  - [x] Create `lib/features/board/presentation/widgets/task_completion_animation.dart`
  - [x] `StatefulWidget` with `SingleTickerProviderStateMixin`
  - [x] Constructor: `TaskCompletionAnimation({required Widget child, super.key})`
  - [x] `AnimationController` with `duration: 300ms`; `_controller.forward()` in `initState()`
  - [x] Scale animation: `TweenSequence` — 0→50%: 1.0→1.04, 50→100%: 1.04→1.0, all with `Curves.easeOut`
  - [x] Color animation: `ColorTween(begin: AppColors.goldenYellow, end: AppColors.sagGreen)` over the first 200ms (use `Interval(0.0, 200/300)` in `CurvedAnimation`)
  - [x] Haptic: add `addListener` — fire `HapticFeedback.mediumImpact()` exactly once when `_controller.value >= 0.5` (use a `bool _hapticFired = false` guard)
  - [x] `dispose()`: `_controller.dispose()`
  - [x] `build()`: return `AnimatedBuilder` → `Transform.scale(scale: _scaleAnimation.value, child: Container(decoration: BoxDecoration(border: Border(left: BorderSide(color: _colorAnimation.value ?? AppColors.sagGreen, width: 4))), child: child))`

- [x] Task 8: Replace stub `QuizPassScreen` with full implementation (AC: #3, #4, #6)
  - [x] Open `lib/features/quiz/presentation/quiz_pass_screen.dart`
  - [x] Replace entirely with `ConsumerWidget` accepting `taskId` and `lessonTitle` constructor params
  - [x] Import `TaskCompletionAnimation` from `package:studyboard_mobile/features/board/presentation/widgets/task_completion_animation.dart`
  - [x] Scaffold → SafeArea → Center → Column with `RepaintBoundary` wrapping `TaskCompletionAnimation`, `SizedBox(height: 32)`, `FilledButton`
  - [x] `Semantics(label: '$lessonTitle complete.')` wrapping `Text('$lessonTitle — complete.', style: textTheme.headlineMedium)` (no exclamation mark)
  - [x] `Semantics(label: 'Back to board', button: true)` on `FilledButton`

- [x] Task 9: Run build_runner for all generated files (Tasks 1–4 combined)
  - [x] From `studyboard_mobile/`, run: `dart run build_runner build --delete-conflicting-outputs`
  - [x] Verify these files regenerated: `quiz_dao.g.dart`, `quiz_state.freezed.dart`, `quiz_notifier.g.dart`
  - [x] Fix any compilation errors before proceeding

- [x] Task 10: Update `quiz_notifier_test.dart` to cover pass-path side effects (AC: #1, #5)
  - [x] Open `test/features/quiz/presentation/quiz_notifier_test.dart`
  - [x] Add mocks/overrides for `taskDaoProvider`, `quizDaoProvider`, `authProvider` (generated name is `authProvider`, not `authNotifierProvider`)
  - [x] Verify existing tests still pass (they don't trigger `passed == true` path yet — check stubs)
  - [x] Add test: `advanceOrComplete()` on last question with all correct answers → `markTaskComplete(taskId)` called once
  - [x] Add test: `advanceOrComplete()` on last question with all correct answers → `saveAttempt()` called once with correct `score`, `passed: true`, `lessonId`, `studentId`
  - [x] Add test: `advanceOrComplete()` on last question with score below threshold → `markTaskComplete()` NOT called (fail path is Story 4.3)
  - [x] Update existing `QuizCompleted` tests to provide `lessonTitle` in the mock quiz data

---

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `TaskDao.markTaskComplete(String taskId)` in `lib/core/database/daos/task_dao.dart:41` — **FULLY IMPLEMENTED**: sets `task_status = 'done'` + enqueues sync queue entry, all in one Drift transaction. Do NOT reimplement this logic anywhere else.
- `TaskDao.resetTaskToInProgress(String taskId)` in `task_dao.dart:68` — exists but is **Story 4.3 responsibility only**; do NOT call in Story 4.2
- `taskDaoProvider` in `lib/core/database/database_provider.dart:21` — provides `TaskDao`; use `ref.read(taskDaoProvider).markTaskComplete(taskId)` from `QuizNotifier`
- `quizDaoProvider` in `database_provider.dart:24` — provides `QuizDao`; use `ref.read(quizDaoProvider).saveAttempt(...)` from `QuizNotifier`
- `lessonDaoProvider` in `database_provider.dart` — provides `LessonDao`; **not needed in Story 4.2** (lessonTitle comes through QuizData)
- `authNotifierProvider` — `@Riverpod(keepAlive: true)` in `lib/features/auth/presentation/auth_notifier.dart`; read `.value?.mapOrNull(authenticated: (a) => a.student.id)` for student ID
- `QuizDao.saveAttempt(QuizAttemptsTableCompanion)` in `quiz_dao.dart:40` — exists; **EXTEND the sync payload** (add `score` and `passed`) but do NOT change the method signature
- `QuizAttemptsTable` schema — `id TEXT, studentId TEXT, lessonId TEXT, score REAL, passed BOOL, attemptedAt TEXT` — no changes needed
- `LessonsTable.title` — text column; already JOINed in `getQuizContextForTask()` via `lessonsTable` inner join; just read `row.readTable(lessonsTable).title`
- `QuizNotifier` in `quiz_notifier.dart` — **EXTEND** with pass-path logic; do NOT recreate the entire file
- `QuizScreen` in `quiz_screen.dart` — **MODIFY** `ref.listen` block only + `unawaited` wrapper; no other changes
- `AppColors.sagGreen` — note the **pre-existing misspelling** (`sagGreen`, not `sageGreen`); use as-is across all new code
- `colorScheme.taskDone` extension → `AppColors.sagGreen`; `colorScheme.taskInProgress` extension → `AppColors.goldenYellow`
- `QuizState.active` and `QuizState.completed` — **EXTEND** with `lessonTitle` field; the freezed union is already created and generated

### What Does NOT Exist Yet — Create These

- `lib/features/board/presentation/widgets/task_completion_animation.dart` — **CREATE** (animation widget)
- Full `QuizPassScreen` implementation — **REPLACE** the stub at `lib/features/quiz/presentation/quiz_pass_screen.dart`

### What NOT to Create in This Story

- `PivotQuestionCard` — Story 4.3 only
- `QuizFailScreen` full implementation — Story 4.3 only (stub from 4.1 remains untouched)
- `resetTaskToInProgress()` call — Story 4.3 only
- `saveAttempt()` on fail path — Story 4.3 only
- Any streak update or coverage ring logic — Story 6.x (coverage ring reads from Drift stream automatically, no Story 4.2 code needed)
- Confetti, banners, celebration modals — explicitly banned per UX spec ("no confetti, no celebration banner, no sound")
- A score display on the pass screen — AC3 says "no score shown"; the completion is the message

### Architecture Boundaries (Hard Rules)

- `quiz_notifier.dart` is the **ONLY** file that calls `TaskDao.markTaskComplete()` — this is a hard architecture rule; enforced across all stories
- `QuizNotifier` must **await** `markTaskComplete()` and `saveAttempt()` before emitting `QuizCompleted` — ensures board stream reflects Done state before user can navigate back
- `TaskCompletionAnimation` lives in `lib/features/board/presentation/widgets/` (architecture specifies this location), but is imported and used in `quiz_pass_screen.dart` — cross-feature widget import is acceptable here per the architecture (board owns the animation widget)
- `HapticFeedback.mediumImpact()` fires **exactly once** at peak scale — never `lightImpact`, never `heavyImpact` for this event
- No `AnimatedOpacity` anywhere in this story — banned per architecture; use `AnimatedBuilder` + `Transform.scale`
- `RepaintBoundary` **wraps** `TaskCompletionAnimation` in the pass screen's widget tree — prevents animation repaints from propagating to parent widgets
- Navigation (`context.go`) happens via `ref.listen` in `QuizScreen` — never inside `QuizNotifier`

### File Location Map

```
lib/features/board/presentation/widgets/
  task_completion_animation.dart    ← CREATE

lib/features/quiz/domain/
  quiz_repository.dart              ← MODIFY (add lessonTitle to QuizData)

lib/features/quiz/data/
  quiz_repository_impl.dart         ← MODIFY (pass lessonTitle)

lib/features/quiz/presentation/
  quiz_state.dart                   ← MODIFY (add lessonTitle to both states)
  quiz_state.freezed.dart           ← REGENERATED by build_runner
  quiz_notifier.dart                ← MODIFY (pass-path side effects)
  quiz_notifier.g.dart              ← REGENERATED by build_runner
  quiz_screen.dart                  ← MODIFY (extra param + unawaited)
  quiz_pass_screen.dart             ← REPLACE (full implementation)

lib/core/database/daos/
  quiz_dao.dart                     ← MODIFY (lessonTitle + payload fix)
  quiz_dao.g.dart                   ← REGENERATED by build_runner

lib/router.dart                     ← MODIFY (pass extra to QuizPassScreen)

test/features/quiz/presentation/
  quiz_notifier_test.dart           ← MODIFY (new mock overrides + tests)
```

Do NOT modify:
- `lib/core/database/daos/task_dao.dart` — `markTaskComplete()` is already complete; no changes
- `lib/features/quiz/domain/quiz_question.dart` — no changes
- `lib/features/quiz/domain/quiz_attempt.dart` — no changes (exists, used for Supabase sync in later stories)
- `lib/features/quiz/presentation/quiz_fail_screen.dart` — Story 4.3 replaces this
- `pubspec.yaml` — no new dependencies (`uuid` already present, `flutter/services.dart` for HapticFeedback is built-in)
- `lib/core/database/app_database.dart` — no schema changes; `schemaVersion` stays at **2**

### QuizDao Changes — Exact Diffs

**`getQuizContextForTask()` — extend return type:**
```dart
// BEFORE:
Future<({String lessonId, double passThreshold})?> getQuizContextForTask(String taskId) async {
  // ...
  return (
    lessonId: row.readTable(lessonTasksTable).lessonId,
    passThreshold: row.readTable(subjectsTable).quizPassThreshold,
  );
}

// AFTER:
Future<({String lessonId, double passThreshold, String lessonTitle})?> getQuizContextForTask(String taskId) async {
  // ... (query unchanged — lessonsTable is already in the JOIN)
  return (
    lessonId: row.readTable(lessonTasksTable).lessonId,
    passThreshold: row.readTable(subjectsTable).quizPassThreshold,
    lessonTitle: row.readTable(lessonsTable).title,
  );
}
```

**`saveAttempt()` — fix sync queue payload:**
```dart
// BEFORE (missing score + passed):
payload: jsonEncode({
  'quiz_attempt_id': companion.id.value,
  'student_id': companion.studentId.value,
  'lesson_id': companion.lessonId.value,
}),

// AFTER:
payload: jsonEncode({
  'quiz_attempt_id': companion.id.value,
  'student_id': companion.studentId.value,
  'lesson_id': companion.lessonId.value,
  'score': companion.score.value,
  'passed': companion.passed.value,
}),
```

### QuizData + QuizState Changes

```dart
// lib/features/quiz/domain/quiz_repository.dart
typedef QuizData = ({
  List<QuizQuestion> questions,
  double passThreshold,
  String lessonId,
  String lessonTitle,  // NEW
});

// lib/features/quiz/presentation/quiz_state.dart
const factory QuizState.active({
  required List<QuizQuestion> questions,
  required int currentIndex,
  required double passThreshold,
  required String lessonId,
  required String lessonTitle,             // NEW — add after lessonId
  @Default({}) Map<int, String> selectedAnswers,
}) = QuizActive;

const factory QuizState.completed({
  required double score,
  required bool passed,
  required int correctCount,
  required int totalQuestions,
  required String lessonId,
  required String lessonTitle,             // NEW — add after lessonId
  required List<QuizQuestion> questions,
  required Map<int, String> selectedAnswers,
}) = QuizCompleted;
```

### QuizNotifier — Full `advanceOrComplete()` Implementation

```dart
// Add at top of quiz_notifier.dart:
import 'dart:async' show unawaited;  // only needed if used here; see quiz_screen
import 'package:uuid/uuid.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';

const _uuid = Uuid();

// In QuizNotifier:
@override
Future<QuizState> build(String taskId) async {
  final result = await ref.read(quizRepositoryProvider).loadQuiz(taskId);
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (QuizData data) => QuizState.active(
      questions: data.questions,
      currentIndex: 0,
      passThreshold: data.passThreshold,
      lessonId: data.lessonId,
      lessonTitle: data.lessonTitle,   // NEW
    ),
  );
}

Future<void> advanceOrComplete() async {          // was: void advanceOrComplete()
  final current = state.value;
  if (current is! QuizActive) return;
  if (!current.selectedAnswers.containsKey(current.currentIndex)) return;

  final isLastQuestion = current.currentIndex == current.questions.length - 1;

  if (!isLastQuestion) {
    state = AsyncData(current.copyWith(currentIndex: current.currentIndex + 1));
    return;
  }

  final total = current.questions.length;
  if (total == 0) return;
  var correctCount = 0;
  for (var i = 0; i < total; i++) {
    final selected = current.selectedAnswers[i];
    if (selected != null && selected == current.questions[i].correctOption) {
      correctCount++;
    }
  }
  final score = correctCount / total;
  final passed = score >= current.passThreshold;

  if (passed) {
    await ref.read(taskDaoProvider).markTaskComplete(taskId);
    final studentId = ref
        .read(authNotifierProvider)
        .value
        ?.mapOrNull(authenticated: (a) => a.student.id);
    if (studentId != null) {
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
    }
  }
  // Story 4.3: add else branch — resetTaskToInProgress + saveAttempt for fail path

  state = AsyncData(
    QuizState.completed(
      score: score,
      passed: passed,
      correctCount: correctCount,
      totalQuestions: total,
      lessonId: current.lessonId,
      lessonTitle: current.lessonTitle,   // NEW
      questions: current.questions,
      selectedAnswers: current.selectedAnswers,
    ),
  );
}
```

**Import note:** `QuizAttemptsTableCompanion` comes from `app_database.dart` (generated by Drift). Check the existing import in `quiz_dao.dart` for the correct path — it's `package:studyboard_mobile/core/database/app_database.dart`.

### QuizScreen — Changes Only

```dart
// lib/features/quiz/presentation/quiz_screen.dart

// Add at top:
import 'dart:async' show unawaited;

// In ref.listen block — update pass navigation:
ref.listen<AsyncValue<QuizState>>(
  quizNotifierProvider(widget.taskId),
  (_, next) {
    next.whenData((state) {
      if (state is QuizCompleted && context.mounted) {
        if (state.passed) {
          context.go('/quiz/${widget.taskId}/pass', extra: state.lessonTitle);  // CHANGED
        } else {
          context.go('/quiz/${widget.taskId}/fail');
        }
      }
    });
  },
);

// In onContinue callback — wrap with unawaited:
onContinue: () => unawaited(
  ref.read(quizNotifierProvider(widget.taskId).notifier).advanceOrComplete(),
),
```

### Router Change

```dart
// lib/router.dart — update the 'pass' sub-route only:
GoRoute(
  path: 'pass',
  pageBuilder: (context, state) {
    final taskId = state.pathParameters['taskId']!;
    final lessonTitle = (state.extra as String?) ?? '';   // NEW
    return MaterialPage(
      child: QuizPassScreen(taskId: taskId, lessonTitle: lessonTitle),  // NEW param
    );
  },
),
```

### TaskCompletionAnimation — Full Implementation

```dart
// lib/features/board/presentation/widgets/task_completion_animation.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';

class TaskCompletionAnimation extends StatefulWidget {
  const TaskCompletionAnimation({required this.child, super.key});

  final Widget child;

  @override
  State<TaskCompletionAnimation> createState() =>
      _TaskCompletionAnimationState();
}

class _TaskCompletionAnimationState extends State<TaskCompletionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Color?> _borderColor;
  bool _hapticFired = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.04)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.04, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _borderColor = ColorTween(
      begin: AppColors.goldenYellow,
      end: AppColors.sagGreen,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        // 200ms out of 300ms total = first 2/3 of animation
        curve: const Interval(0.0, 2 / 3, curve: Curves.linear),
      ),
    );

    _controller.addListener(() {
      if (!_hapticFired && _controller.value >= 0.5) {
        _hapticFired = true;
        HapticFeedback.mediumImpact();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _borderColor.value ?? AppColors.sagGreen,
                width: 4,
              ),
            ),
          ),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
```

**Key implementation notes:**
- `child` is passed to `AnimatedBuilder` as a constant child — this prevents `widget.child` from being rebuilt on every animation frame (performance optimization)
- `_hapticFired` bool prevents double-fire if the listener is called multiple times near 0.5
- `Interval(0.0, 2/3)` covers 0–200ms of the 300ms total animation for the color transition

### QuizPassScreen — Full Implementation

```dart
// lib/features/quiz/presentation/quiz_pass_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/features/board/presentation/widgets/task_completion_animation.dart';

class QuizPassScreen extends ConsumerWidget {
  const QuizPassScreen({
    required this.taskId,
    required this.lessonTitle,
    super.key,
  });

  final String taskId;
  final String lessonTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RepaintBoundary(
                child: TaskCompletionAnimation(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Semantics(
                      label: '$lessonTitle complete.',
                      child: Text(
                        '$lessonTitle — complete.',
                        style: textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Semantics(
                button: true,
                label: 'Back to board',
                child: FilledButton(
                  onPressed: () => context.go('/board'),
                  child: const Text('Back to board'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Notes:**
- `RepaintBoundary` wraps `TaskCompletionAnimation` — AC3 explicit requirement; prevents animation repaints from propagating up the tree
- `lessonTitle` comes from constructor (passed via GoRouter `extra`) — avoids provider lifecycle race condition that would occur if reading `quizNotifierProvider` here
- `Semantics(label: '$lessonTitle complete.')` on the text + `Semantics(button: true, label: 'Back to board')` on the button fulfils AC6 (TalkBack announces "[ Lesson title ] complete. Button: Back to board.")
- `ConsumerWidget` is kept (was in the stub) for potential Story 4.x additions, but `ref` is not used in this story
- No score display anywhere — AC3 explicit requirement

### Testing Requirements

```dart
// test/features/quiz/presentation/quiz_notifier_test.dart
// Add to existing test file — do NOT delete the 10 existing tests

// New mocks needed:
class MockTaskDao extends Mock implements TaskDao {}
class MockQuizDao extends Mock implements QuizDao {}
// AuthNotifier mock: override authNotifierProvider with ProviderOverride
// that returns an AsyncValue.data(AuthState.authenticated(student: fakeStudent))

// New provider overrides for tests that trigger advanceOrComplete() on last question:
final container = ProviderContainer(
  overrides: [
    quizRepositoryProvider.overrideWith((_) => MockQuizRepository()),
    taskDaoProvider.overrideWith((_) => mockTaskDao),
    quizDaoProvider.overrideWith((_) => mockQuizDao),
    authNotifierProvider.overrideWith(() => FakeAuthNotifier()),
  ],
);

// New test: markTaskComplete called on pass
test('advanceOrComplete() on last correct answer calls markTaskComplete once', () async {
  // Arrange: 1-question quiz, score = 1.0 >= threshold 0.8 → passed = true
  // Act: selectAnswer(correctOption) + advanceOrComplete()
  // Assert: verify(mockTaskDao.markTaskComplete(taskId)).called(1)
});

// New test: saveAttempt called on pass
test('advanceOrComplete() on pass calls saveAttempt with correct payload', () async {
  // Assert: verify(mockQuizDao.saveAttempt(any)).called(1)
  // Capture argument and check: score == 1.0, passed == true, lessonId == expected
});

// New test: markTaskComplete NOT called on fail
test('advanceOrComplete() on fail does not call markTaskComplete', () async {
  // Arrange: 1-question quiz with wrong answer (score < threshold)
  // Assert: verifyNever(mockTaskDao.markTaskComplete(any))
});

// Update existing QuizCompleted tests:
// Provide lessonTitle in QuizData mock: '..., lessonTitle: 'Test Lesson''
// Assert QuizCompleted.lessonTitle == 'Test Lesson'
```

**Note on `authNotifierProvider` override:** `AuthNotifier` is a `keepAlive: true` notifier. Override it in tests using:
```dart
class FakeAuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async =>
      AuthState.authenticated(student: fakeStudent);
}
// Override: authNotifierProvider.overrideWith(FakeAuthNotifier.new)
```

### Build Runner Instructions

Run ONCE after all code changes are complete (Tasks 1–4 modify generated inputs):
```
dart run build_runner build --delete-conflicting-outputs
```
From `studyboard_mobile/`. This regenerates:
- `quiz_dao.g.dart` — new return type for `getQuizContextForTask()`
- `quiz_state.freezed.dart` — `lessonTitle` field in both states
- `quiz_notifier.g.dart` — signature change for `advanceOrComplete()`

### Previous Story Learnings Applied (Stories 4.1)

- **Riverpod codegen provider name:** `@riverpod class QuizNotifier` → generates `quizNotifierProvider` (parameterized). Confirmed via Dev Agent Record in 4.1: "Riverpod codegen strips 'Notifier' suffix: `QuizNotifier` → `quizProvider`". Use `quizNotifierProvider` — **wait, this conflicts with the Debug Log**: "Riverpod codegen strips 'Notifier' suffix: `QuizNotifier` → `quizProvider` (not `quizNotifierProvider`)". This means the generated provider is `quizProvider(taskId)`, NOT `quizNotifierProvider(taskId)`. Verify in `quiz_notifier.g.dart` before using.
- **`package:` imports everywhere** — no relative imports inside `lib/`
- **`sort_constructors_first` lint** — constructor before fields in all new classes  
- **`unawaited_futures` lint (VGA)** — VGA enforces this; wrap fire-and-forget async calls with `unawaited()` from `dart:async`
- **`correctOption` is lowercase in DB** — `'a'`, `'b'`, `'c'`, `'d'`; no change for Story 4.2
- **`AppColors.sagGreen`** — pre-existing misspelling; do NOT "fix" to `sageGreen`; it would be a breaking rename across all quiz widgets

### Anti-Patterns to Avoid

- ❌ Calling `task_dao.dart`'s `markTaskComplete()` from anywhere except `quiz_notifier.dart` — architecture violation
- ❌ Emitting `QuizCompleted` before `markTaskComplete()` awaits — board stream won't reflect Done state yet when user taps "Back to board"
- ❌ Hardcoding the pass threshold in `advanceOrComplete()` — always use `current.passThreshold` (read from `SubjectsTable.quizPassThreshold` via `getQuizContextForTask()`)
- ❌ Showing score on the pass screen — AC3 explicitly prohibits it
- ❌ Using `HapticFeedback.lightImpact()` or `HapticFeedback.heavyImpact()` — must be `mediumImpact()` exactly
- ❌ Using `AnimatedOpacity` in `TaskCompletionAnimation` — banned per architecture
- ❌ Placing `RepaintBoundary` inside `TaskCompletionAnimation` — it must wrap the widget from outside (in `QuizPassScreen`), not inside the animation widget
- ❌ Reading `quizNotifierProvider` in `QuizPassScreen` to get `lessonTitle` — provider may be disposed by the time `QuizPassScreen` renders (use constructor param via GoRouter `extra` instead)
- ❌ Calling `resetTaskToInProgress()` in Story 4.2 — Story 4.3 responsibility
- ❌ Calling `saveAttempt()` on the fail path in Story 4.2 — Story 4.3 responsibility
- ❌ Adding confetti, banners, or any celebration beyond the scale pulse + color + haptic — explicitly prohibited by UX spec

### Deferred Items (Do Not Address in This Story)

- `sagGreen` misspelling in `app_colors.dart` — pre-existing; deferred rename refactor
- `TaskCard` `AnimatedList` slide-out on the board when task moves to Done — happens automatically via `watchTasksByStatus` stream update; no explicit Story 4.2 code needed
- Dashboard coverage ring increment — reads from Drift stream automatically; no Story 4.2 code needed
- Error handling for `markTaskComplete()` failure — Drift writes are expected to succeed; deferred

### References

- [Source: epics.md#Story 4.2] — All 6 ACs
- [Source: architecture.md#Task State Machine] — "`quiz_notifier.dart` is the only file that calls `TaskRepository.markTaskComplete()`"
- [Source: architecture.md#Animation & Haptic Rules] — "Transform.scale (1.0 → 1.05 → 1.0), 350ms" (note: epic ACs override with 1.04, 300ms — use epic ACs as canonical)
- [Source: architecture.md#Anti-Patterns] — "`AnimatedOpacity` for task completion animation" is banned
- [Source: ux-design-specification.md#TaskCompletionAnimation] — anatomy of the animation widget
- [Source: ux-design-specification.md#Pass screen] — "'[Lesson title] — complete.' No exclamation mark. No score."
- [Source: 4-1-quiz-screen-and-question-engine.md#Dev Agent Record] — provider name is `quizProvider(taskId)` not `quizNotifierProvider(taskId)`; verify in generated file
- [Source: 4-1-quiz-screen-and-question-engine.md#Review Findings] — `saveAttempt` sync payload omits `score`/`passed` — Story 4.2 responsibility to fix
- [Source: task_dao.dart:41] — `markTaskComplete()` fully implemented; do NOT reimplement
- [Source: quiz_dao.dart:40] — `saveAttempt()` has correct Drift insert but incomplete payload
- [Source: database_provider.dart:21,24] — `taskDaoProvider` and `quizDaoProvider`
- [Source: app_colors.dart:11] — `AppColors.sagGreen` (misspelling is canonical)

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Completion Notes List

- Generated provider name is `authProvider` (not `authNotifierProvider`) — Riverpod codegen strips `Notifier` suffix from `AuthNotifier`. Used `whenOrNull(authenticated: (student, _) => student.id)` instead of `mapOrNull` to avoid inference failure on the private `_Authenticated` type.
- `Tween(begin: 1, end: 1.04)` infers `Tween<num>` mixing int/double literals — fixed by using `Tween<double>(begin: 1, end: 1.04)`.
- `_controller.forward()` in initState must be wrapped with `unawaited(...)` (not `..forward()` cascade) to satisfy `unawaited_futures` lint without triggering the `unnecessary_cascade` lint.
- **Riverpod 3.x default retry**: `ProviderContainer.defaultRetry` retries `Exception`s up to 10 times with exponential backoff (200ms → 6400ms). Test containers must set `retry: (_, _) => null` to disable this; without it, error-path tests hang for 30+ seconds because the provider cycles between `AsyncLoading(retrying)` and failure indefinitely, and `.future` is continuously replaced with new pending futures on each retry attempt.
- `FakeAuthNotifier extends AuthNotifier` (not `_$AuthNotifier`) — the generated base class is library-private and cannot be extended from test files.
- `await container.read(authProvider.future)` required before `advanceOrComplete()` in the saveAttempt test — `FakeAuthNotifier.build()` is async; without pre-warming, `.value` is null when read synchronously inside `advanceOrComplete()`.
- `dart:async` imported as `import 'dart:async';` (full import) rather than `show unawaited` to support the `Completer` type in tests.

### File List

**Create:**
- `lib/features/board/presentation/widgets/task_completion_animation.dart`

**Modify:**
- `lib/core/database/daos/quiz_dao.dart`
- `lib/core/database/daos/quiz_dao.g.dart` (regenerated)
- `lib/features/quiz/domain/quiz_repository.dart`
- `lib/features/quiz/data/quiz_repository_impl.dart`
- `lib/features/quiz/presentation/quiz_state.dart`
- `lib/features/quiz/presentation/quiz_state.freezed.dart` (regenerated)
- `lib/features/quiz/presentation/quiz_notifier.dart`
- `lib/features/quiz/presentation/quiz_notifier.g.dart` (regenerated)
- `lib/features/quiz/presentation/quiz_screen.dart`
- `lib/features/quiz/presentation/quiz_pass_screen.dart` (replaced)
- `lib/router.dart`
- `test/features/quiz/presentation/quiz_notifier_test.dart`

## Review Findings

- [x] [Review][Decision] saveAttempt silently skipped when studentId is null — resolved: set `state = AsyncError(Exception('Cannot record attempt: not authenticated'), ...)` and return when `studentId == null` [quiz_notifier.dart:86-92]
- [x] [Review][Decision] TalkBack semantics — two sibling `Semantics` nodes accepted as standard Flutter accessibility pattern; sequential focus stops match spec intent [quiz_pass_screen.dart:32-50]
- [x] [Review][Patch] saveAttempt sync queue payload missing `attempted_at` field — added `'attempted_at': companion.attemptedAt.value` to payload [quiz_dao.dart:saveAttempt]
- [x] [Review][Patch] `state.extra as String?` throws TypeError if extra is non-null but not a String — fixed with local variable + `is String` type check [router.dart:pass pageBuilder]
- [x] [Review][Patch] AsyncError from `advanceOrComplete()` silently swallowed by `unawaited()` — wrapped DB operations in `try/on Object catch (e, st) { state = AsyncError(e, st); }` [quiz_notifier.dart:66-123]
- [x] [Review][Patch] Double-tap race condition on last question — added `_isProcessing` bool guard with `finally` reset [quiz_notifier.dart:63-64, 122]
- [x] [Review][Defer] markTaskComplete and saveAttempt run in separate Drift transactions — partial failure leaves task done with no attempt record [quiz_notifier.dart:74-90] — deferred, spec explicitly defers Drift write error handling; "Drift writes are expected to succeed" per dev notes
- [x] [Review][Defer] lessonTitle silently degrades to empty string on deep-link or process restart — GoRouter `extra` is not persisted; pass screen renders " — complete." with no lesson name [router.dart:109] — deferred, GoRouter architectural limitation; not addressable without a separate lookup mechanism
- [x] [Review][Defer] `_showLeaveDialog` captures outer BuildContext without `context.mounted` guard in Leave callback [quiz_screen.dart:_showLeaveDialog] — deferred, pre-existing Flutter pattern; very low practical risk since dialog blocks UI
- [x] [Review][Defer] `getQuizContextForTask` uses `getSingleOrNull()` — throws unguarded `StateError` (not `Exception`) if >1 `lessonTasksTable` row matches `taskId`; not caught by `on Exception` in repository [quiz_dao.dart:getQuizContextForTask] — deferred, DB integrity guarantee; taskId uniqueness enforced by app data model

## Change Log

- 2026-05-08: Story created — quiz pass gate, TaskCompletionAnimation, haptic, lessonTitle propagation, saveAttempt payload fix.
- 2026-05-09: Story implemented — all 10 tasks complete, 14 tests passing, `dart analyze` exits 0 (19 pre-existing infos, none in Story 4.2 files). Status → review.
- 2026-05-11: Code review complete — 2 decision-needed, 4 patch, 4 deferred, 10 dismissed.
