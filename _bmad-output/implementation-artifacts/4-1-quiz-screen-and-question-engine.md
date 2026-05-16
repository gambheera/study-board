# Story 4.1: Quiz Screen & Question Engine

Status: done

## Story

As a student,
I want to take a quiz for any lesson I am studying — one question at a time — and see immediate answer feedback,
So that I can test my understanding in a focused, low-pressure format.

## Acceptance Criteria

1. **Given** a student taps "Take quiz" on the LessonContent screen **When** the `QuizScreen` opens **Then** the first question is displayed immediately from the Drift cache with no network request — quiz entry feels instantaneous (NFR3: answer + result ≤ 1 second)

2. **Given** the `QuizQuestionCard` is displayed **When** rendered **Then** a `LinearProgressIndicator` (Calm Blue fill, `AppColors.calmBlue`) shows "question X of Y" at the top, the question stem is shown (Title Medium), and four answer options A–D are displayed as full-width `OutlinedButton` widgets — no timer is shown

3. **Given** the student taps an answer option **When** the tap registers **Then** the selected option's border highlights immediately (optimistic UI — no loading state), the correct answer shows a Sage Green background (`AppColors.taskDone`), the student's wrong answer shows a Dusty Rose background (`AppColors.taskReopened`), and a "Continue" `FilledButton` appears below the options

4. **Given** the student taps "Continue" after selecting an answer **When** the next question loads **Then** the transition is immediate from Drift — no spinner between questions; the `LinearProgressIndicator` advances proportionally

5. **Given** the student presses the Android back gesture during a quiz **When** the gesture fires **Then** a `PopScope` intercepts it and an `AlertDialog` appears: "Leave this quiz? Your progress will be lost. [Stay] [Leave]" — tapping Stay returns to the quiz at the current question; tapping Leave returns to the Board with the task still In Progress

6. **Given** the student completes the final question and taps "Continue" **When** the last answer is confirmed **Then** the quiz result is calculated immediately from the local answer set — no server round-trip required for result computation; the score and pass/fail determination (score ≥ subject's `quiz_pass_threshold` in Drift) are computed locally

## Tasks / Subtasks

- [x] Task 1: Extend `QuizDao` with `getQuizContextForTask()` (AC: #1, #6)
  - [x] Open `lib/core/database/daos/quiz_dao.dart`
  - [x] Add `LessonTasksTable`, `LessonsTable`, `TopicsTable`, `SubjectsTable` to `@DriftAccessor(tables: [...])`
  - [x] Add import statements for each new table file
  - [x] Add method `Future<({String lessonId, double passThreshold})?> getQuizContextForTask(String taskId)` — JOIN: lesson_tasks → lessons → topics → subjects using `innerJoin` on each FK, filter by `lessonTasksTable.id.equals(taskId)`, return `(lessonId, passThreshold)` tuple
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` to regenerate `quiz_dao.g.dart`

- [x] Task 2: Create `QuizRepository` interface and implementation (AC: #1, #6)
  - [x] Create `lib/features/quiz/domain/quiz_repository.dart` with abstract `QuizRepository` interface and `QuizData` record type
  - [x] Create `lib/features/quiz/data/quiz_repository_impl.dart` with `QuizRepositoryImpl` and `@riverpod QuizRepository quizRepository(Ref ref)` provider

- [x] Task 3: Create `QuizState` (AC: #1, #2, #3, #4, #6)
  - [x] Create `lib/features/quiz/presentation/quiz_state.dart` — sealed `@freezed` union: `QuizActive` (questions, currentIndex, selectedAnswers) and `QuizCompleted` (score, passed, questions, selectedAnswers, lessonId)
  - [x] Run build_runner after creating (combine with Task 4's build_runner run)

- [x] Task 4: Create `QuizNotifier` (AC: #1, #2, #3, #4, #6)
  - [x] Create `lib/features/quiz/presentation/quiz_notifier.dart` — `@riverpod class QuizNotifier extends _$QuizNotifier` with `Future<QuizState> build(String taskId)`
  - [x] Implement `selectAnswer(String option)` method — sets `selectedAnswers[currentIndex]` and emits updated `QuizActive` state
  - [x] Implement `advanceOrComplete()` method — if `currentIndex < questions.length - 1`: increment index and emit new `QuizActive`; if last question: calculate score, determine pass/fail, emit `QuizCompleted`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/`

- [x] Task 5: Create `quiz_answer_option.dart` widget (AC: #2, #3)
  - [x] Create `lib/features/quiz/presentation/widgets/quiz_answer_option.dart` — stateless widget that renders a full-width `OutlinedButton` for a single answer option (A/B/C/D)
  - [x] Show neutral style when not selected, Sage Green background when this is the correct answer AND `isAnswered` is true, Dusty Rose background when this is the student's wrong selected answer AND `isAnswered` is true, no background change when this is the correct option AND student also got it right (Sage Green)
  - [x] Constructor params: `option` (String — 'a'/'b'/'c'/'d'), `optionText` (String), `label` (String — 'A'/'B'/'C'/'D'), `correctOption` (String), `selectedOption` (String?), `isAnswered` (bool), `onTap` (VoidCallback?)

- [x] Task 6: Create `QuizScreen` (AC: #1, #2, #3, #4, #5)
  - [x] Create `lib/features/quiz/presentation/quiz_screen.dart` — `ConsumerStatefulWidget` (needs `PopScope`)
  - [x] Use `ref.watch(quizProvider(taskId))` to get the `AsyncValue<QuizState>`
  - [x] Show skeleton/loading while `AsyncValue.loading`; show error retry on `AsyncValue.error`
  - [x] On `QuizActive` state: render `LinearProgressIndicator`, question text, four `QuizAnswerOption` widgets
  - [x] On answer selected: show Continue `FilledButton` — tapping calls `ref.read(quizProvider(taskId).notifier).advanceOrComplete()`
  - [x] On `QuizCompleted` state: use `ref.listen` to navigate to stub result screen (see routing section)
  - [x] Wrap with `PopScope(canPop: false, onPopInvokedWithResult: ...)` — show `AlertDialog` with [Stay]/[Leave]; Leave calls `context.go('/board')`

- [x] Task 7: Create stub result screens (AC: #6)
  - [x] Create `lib/features/quiz/presentation/quiz_pass_screen.dart` — minimal `ConsumerWidget` accepting `taskId`; shows "Lesson complete." title, a "Back to board" `FilledButton` that calls `context.go('/board')`; **Story 4.2 will replace with full implementation**
  - [x] Create `lib/features/quiz/presentation/quiz_fail_screen.dart` — minimal `ConsumerWidget` accepting `taskId`; shows "Not done yet." title, two buttons: "Review lesson" (navigates to `/lesson/$taskId`) and "Try again later" (navigates to `/board`); **Story 4.3 will replace with full implementation**

- [x] Task 8: Update router.dart (AC: #1)
  - [x] Open `lib/router.dart`
  - [x] Replace the existing `/quiz/:taskId` stub route with a real route that pushes `QuizScreen(taskId: taskId)`
  - [x] Add `/quiz/:taskId/pass` route → `QuizPassScreen(taskId: taskId)`
  - [x] Add `/quiz/:taskId/fail` route → `QuizFailScreen(taskId: taskId)`

- [x] Task 9: Write tests (AC: #1, #3, #4, #6)
  - [x] Create `test/features/quiz/presentation/quiz_notifier_test.dart`
  - [x] Test: `build(taskId)` loads questions and returns `QuizActive` with `currentIndex == 0` and empty `selectedAnswers`
  - [x] Test: `selectAnswer()` sets `selectedAnswers[currentIndex]` and does NOT advance to next question
  - [x] Test: `advanceOrComplete()` after selecting answer on non-last question increments `currentIndex`
  - [x] Test: `advanceOrComplete()` on last question emits `QuizCompleted` with correct `score` and `passed`
  - [x] Test: `passed == true` when score ≥ passThreshold; `passed == false` when score < passThreshold
  - [x] Test: `score` is correct count / total questions (e.g., 2 correct out of 4 = 0.5)

### Review Findings

- [x] [Review][Decision] `prefetchAll` parallelism changed from fire-and-forget to sequential `await` — fixed with `Future.wait` parallel + per-URL `on Exception` guard [content_cache_service.dart:14]
- [x] [Review][Patch] `_showLeaveDialog` uses outer `BuildContext` for `Navigator.of()` — fixed: now uses `dialogCtx` from builder [quiz_screen.dart:88]
- [x] [Review][Patch] `on Object catch (_) {}` in `prefetchAll` catches fatal VM errors — fixed: changed to `on Exception catch (_) {}` [content_cache_service.dart:16]
- [x] [Review][Patch] Dead `.catchError` on `prefetchAll()` call in `ContentSyncNotifier` — fixed: removed [content_sync_notifier.dart:33]
- [x] [Review][Patch] No zero-length guard before score division in `advanceOrComplete()` — fixed: early return when `total == 0` [quiz_notifier.dart:62]
- [x] [Review][Patch] Test gap — `QuizCompleted` test only asserts type, not payload — fixed: added assertions for `totalQuestions`, `lessonId`, `questions.length`, `selectedAnswers.length` [quiz_notifier_test.dart]
- [x] [Review][Patch] Test gap — No test for `build()` error path when `loadQuiz` returns `Left(Failure)` — fixed: added test verifying `AsyncError<QuizState>` state [quiz_notifier_test.dart]
- [ ] [Review][Patch] `_AnimatedBacklogList` insertion index wrong when multiple items inserted in one diff cycle — skipped (re-analysis shows current implementation is correct; mutating `_items` before computing next `insertAt` gives the right position) [backlog_screen.dart:286]
- [ ] [Review][Patch] `contentSeededProvider` watched inside `error:` callback — skipped (Riverpod only registers the watch when the error branch is actually taken; no spurious rebuilds in non-error state) [backlog_screen.dart:135]
- [x] [Review][Defer] `sagGreen` misspelling perpetuated in new quiz code — pre-existing typo in `app_colors.dart`; fix with a rename refactor across all files [quiz_answer_option.dart:64] — deferred, pre-existing
- [x] [Review][Defer] `toSet().toList()` ordering implicitly relies on `LinkedHashSet` insertion-order behaviour — correct today but an implementation detail; use an explicit seen-set loop for clarity [content_dao.dart:43] — deferred, pre-existing
- [x] [Review][Defer] `result.fold((_) => null, ...)` silences all sync failures in `ContentSyncNotifier` — no log, no user feedback, no state update on failure [content_sync_notifier.dart:24] — deferred, design decision
- [x] [Review][Defer] `QuizPassScreen`/`QuizFailScreen` extend `ConsumerWidget` but never use `ref` — intentional scaffolding for Stories 4.2/4.3 which will add Riverpod usage [quiz_pass_screen.dart, quiz_fail_screen.dart] — deferred, pre-existing
- [x] [Review][Defer] `ref.listen` double-navigation micro-race when `QuizScreen` rebuilds with `QuizCompleted` still cached — guarded by `context.mounted`; GoRouter replaces stack on `context.go`, disposing the provider [quiz_screen.dart:23] — deferred, pre-existing
- [x] [Review][Defer] `correctOption` case not normalised on Supabase ingest — uppercase value from server scores every answer wrong silently [content_repository_impl.dart] — deferred, pre-existing
- [x] [Review][Defer] `getQuizContextForTask` 4-way JOIN fetches full rows to project only 2 columns — optimisation opportunity [quiz_dao.dart:66] — deferred, pre-existing
- [x] [Review][Defer] `saveAttempt` sync-queue payload omits `score`/`passed` fields — Story 4.2/4.3 responsibility [quiz_dao.dart:44] — deferred, pre-existing

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `QuizQuestion` domain model in `lib/features/quiz/domain/quiz_question.dart` — **DO NOT RECREATE**; already has all fields: `id`, `lessonId`, `questionText`, `optionA–D`, `correctOption`, `orderIndex`
- `QuizAttempt` domain model in `lib/features/quiz/domain/quiz_attempt.dart` — **DO NOT RECREATE**; has `id`, `studentId`, `lessonId`, `score`, `passed`, `attemptedAt`; used by Stories 4.2/4.3 for recording attempts
- `QuizDao` in `lib/core/database/daos/quiz_dao.dart` — **EXTEND with new method and tables**; already has `getQuestionsForLesson(lessonId)`, `saveAttempt()`, `getAttemptsForLesson()`
- `quiz_questions_table.dart` and `quiz_attempts_table.dart` — **already in Drift schema from Story 1.3**
- `SubjectsTable.quizPassThreshold` — `RealColumn` already exists with `DEFAULT 0.8` (Chemistry = 0.8 = 80%)
- `LessonContentScreen` "Take quiz" button — **already navigates to `/quiz/${widget.taskId}`** (`context.push('/quiz/${widget.taskId}')`) — DO NOT modify
- `/quiz/:taskId` route stub in `router.dart` — **REPLACE the stub's `pageBuilder`** with real `QuizScreen`; DO NOT add a new route entry
- `quizDaoProvider` in `database_provider.dart` (line 24) — use `ref.watch(quizDaoProvider)` to inject `QuizDao`
- `TaskDao.markTaskComplete()` and `TaskDao.resetTaskToInProgress()` — **EXIST but are NOT called in Story 4.1**; those are Story 4.2/4.3 responsibilities only

### What Does NOT Exist Yet — Create These

- `lib/features/quiz/domain/quiz_repository.dart` — **CREATE** abstract interface
- `lib/features/quiz/data/quiz_repository_impl.dart` — **CREATE** implementation + Riverpod provider
- `lib/features/quiz/presentation/quiz_state.dart` — **CREATE** freezed sealed union
- `lib/features/quiz/presentation/quiz_notifier.dart` — **CREATE** AsyncNotifier
- `lib/features/quiz/presentation/quiz_screen.dart` — **CREATE** main quiz UI
- `lib/features/quiz/presentation/widgets/quiz_answer_option.dart` — **CREATE** option widget
- `lib/features/quiz/presentation/quiz_pass_screen.dart` — **CREATE** minimal stub (Story 4.2 replaces)
- `lib/features/quiz/presentation/quiz_fail_screen.dart` — **CREATE** minimal stub (Story 4.3 replaces)

### What NOT to Create in This Story

- `TaskCompletionAnimation` widget — **Story 4.2 only**
- `PivotQuestionCard` widget — **Story 4.3 only**
- `quiz_attempts` recording (`QuizDao.saveAttempt()`) — **Story 4.3 only** (attempt is recorded after pass/fail is actioned, not during quiz)
- `TaskRepository.markTaskComplete()` call — **Story 4.2 only**
- `TaskRepository.resetTaskToInProgress()` call — **Story 4.3 only**
- Full `QuizPassScreen` UI (animation, haptic, "Back to board" flow) — **Story 4.2**
- Full `QuizFailScreen` UI (pivot question, 3rd+ failure variant) — **Story 4.3**
- Any retry flow or attempt history display — **Story 4.4**
- `DashboardDao` coverage update — **Story 6.1** (coverage ring reads from Drift automatically)

### Architecture Boundaries (Hard Rules)

```
presentation/ → domain/ (QuizRepository interface) only — NOT data/ implementations
domain/       → core/failures/ only — no Flutter, Drift, Supabase
data/         → domain/, core/database/, core/supabase/ — NOT presentation/
```

**Critical:** `quiz_notifier.dart` is the ONLY file in the entire project that will eventually call `TaskDao.markTaskComplete()` and `TaskDao.resetTaskToInProgress()`. These calls happen in Stories 4.2 and 4.3 respectively, added to the SAME `quiz_notifier.dart` file. No other screen, widget, or provider may call these methods.

**No Supabase calls in Story 4.1** — all quiz data reads are from local Drift. The quiz question answers are evaluated entirely locally.

### File Location Map

Per `architecture.md` Feature Folder Structure:
```
lib/features/quiz/
  domain/
    quiz_question.dart         ✅ EXISTS — DO NOT TOUCH
    quiz_attempt.dart          ✅ EXISTS — DO NOT TOUCH
    quiz_repository.dart       ← CREATE (abstract interface)
  data/
    quiz_repository_impl.dart  ← CREATE (implementation + @riverpod provider)
  presentation/
    quiz_screen.dart           ← CREATE
    quiz_state.dart            ← CREATE
    quiz_notifier.dart         ← CREATE
    quiz_pass_screen.dart      ← CREATE (stub)
    quiz_fail_screen.dart      ← CREATE (stub)
    widgets/
      quiz_answer_option.dart  ← CREATE

lib/core/database/daos/
  quiz_dao.dart                ✅ EXISTS — EXTEND (add tables + getQuizContextForTask)
```

### QuizDao — New Method and Tables

Add 4 tables to `@DriftAccessor` and one new method:

```dart
// lib/core/database/daos/quiz_dao.dart
import 'package:studyboard_mobile/core/database/tables/lesson_tasks_table.dart';
import 'package:studyboard_mobile/core/database/tables/lessons_table.dart';
import 'package:studyboard_mobile/core/database/tables/topics_table.dart';
import 'package:studyboard_mobile/core/database/tables/subjects_table.dart';

@DriftAccessor(
  tables: [
    QuizQuestionsTable,
    QuizAttemptsTable,
    SyncQueueTable,
    LessonTasksTable,  // NEW
    LessonsTable,      // NEW
    TopicsTable,       // NEW
    SubjectsTable,     // NEW
  ],
)
class QuizDao extends DatabaseAccessor<AppDatabase> with _$QuizDaoMixin {
  // ... existing methods unchanged ...

  // NEW: resolves taskId → (lessonId, passThreshold) via 4-way JOIN
  Future<({String lessonId, double passThreshold})?> getQuizContextForTask(
    String taskId,
  ) async {
    final query = select(lessonTasksTable).join([
      innerJoin(
        lessonsTable,
        lessonsTable.id.equalsExp(lessonTasksTable.lessonId),
      ),
      innerJoin(
        topicsTable,
        topicsTable.id.equalsExp(lessonsTable.topicId),
      ),
      innerJoin(
        subjectsTable,
        subjectsTable.id.equalsExp(topicsTable.subjectId),
      ),
    ])
      ..where(lessonTasksTable.id.equals(taskId));

    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return (
      lessonId: row.readTable(lessonTasksTable).lessonId,
      passThreshold: row.readTable(subjectsTable).quizPassThreshold,
    );
  }
}
```

**After modifying quiz_dao.dart**, run build_runner to regenerate `quiz_dao.g.dart`.

### QuizRepository Interface & QuizData

```dart
// lib/features/quiz/domain/quiz_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_question.dart';

typedef QuizData = ({
  List<QuizQuestion> questions,
  double passThreshold,
  String lessonId,
});

abstract interface class QuizRepository {
  Future<Either<Failure, QuizData>> loadQuiz(String taskId);
}
```

### QuizRepositoryImpl

```dart
// lib/features/quiz/data/quiz_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_question.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_repository.dart';

part 'quiz_repository_impl.g.dart';

@Riverpod(keepAlive: true)
QuizRepository quizRepository(Ref ref) =>
    QuizRepositoryImpl(ref.watch(quizDaoProvider));

class QuizRepositoryImpl implements QuizRepository {
  const QuizRepositoryImpl(this._dao);

  final QuizDao _dao;

  @override
  Future<Either<Failure, QuizData>> loadQuiz(String taskId) async {
    try {
      final context = await _dao.getQuizContextForTask(taskId);
      if (context == null) {
        return const Left(DatabaseFailure('Task not found'));
      }

      final rows = await _dao.getQuestionsForLesson(context.lessonId);
      if (rows.isEmpty) {
        return const Left(DatabaseFailure('No quiz questions found for this lesson'));
      }

      final questions = rows
          .map(
            (r) => QuizQuestion(
              id: r.id,
              lessonId: r.lessonId,
              questionText: r.questionText,
              optionA: r.optionA,
              optionB: r.optionB,
              optionC: r.optionC,
              optionD: r.optionD,
              correctOption: r.correctOption,
              orderIndex: r.orderIndex,
            ),
          )
          .toList();

      return Right((
        questions: questions,
        passThreshold: context.passThreshold,
        lessonId: context.lessonId,
      ));
    } on Exception catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
```

### QuizState — Freezed Sealed Union

```dart
// lib/features/quiz/presentation/quiz_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_question.dart';

part 'quiz_state.freezed.dart';

@freezed
sealed class QuizState with _$QuizState {
  const factory QuizState.active({
    required List<QuizQuestion> questions,
    required int currentIndex,
    required double passThreshold,
    required String lessonId,
    @Default({}) Map<int, String> selectedAnswers, // index → 'a'|'b'|'c'|'d'
  }) = QuizActive;

  const factory QuizState.completed({
    required double score,      // 0.0–1.0
    required bool passed,
    required int correctCount,
    required int totalQuestions,
    required String lessonId,
    required List<QuizQuestion> questions,
    required Map<int, String> selectedAnswers,
  }) = QuizCompleted;
}
```

**Note:** `@Default({})` on `selectedAnswers` is a valid freezed default for an empty map. The `Map<int, String>` is not JSON-serializable by default — do NOT add `fromJson`/`toJson` to this state class; it is presentation-layer only.

### QuizNotifier — AsyncNotifier with taskId Parameter

```dart
// lib/features/quiz/presentation/quiz_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/quiz/data/quiz_repository_impl.dart';
import 'package:studyboard_mobile/features/quiz/presentation/quiz_state.dart';

part 'quiz_notifier.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  @override
  Future<QuizState> build(String taskId) async {
    final result = await ref.read(quizRepositoryProvider).loadQuiz(taskId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => QuizState.active(
        questions: data.questions,
        currentIndex: 0,
        passThreshold: data.passThreshold,
        lessonId: data.lessonId,
      ),
    );
  }

  void selectAnswer(String option) {
    final current = state.value;
    if (current is! QuizActive) return;
    if (current.selectedAnswers.containsKey(current.currentIndex)) return; // already answered

    state = AsyncData(
      current.copyWith(
        selectedAnswers: {
          ...current.selectedAnswers,
          current.currentIndex: option,
        },
      ),
    );
  }

  void advanceOrComplete() {
    final current = state.value;
    if (current is! QuizActive) return;
    if (!current.selectedAnswers.containsKey(current.currentIndex)) return; // nothing selected yet

    final isLastQuestion = current.currentIndex == current.questions.length - 1;

    if (!isLastQuestion) {
      state = AsyncData(
        current.copyWith(currentIndex: current.currentIndex + 1),
      );
      return;
    }

    // Calculate result
    int correctCount = 0;
    for (var i = 0; i < current.questions.length; i++) {
      final selected = current.selectedAnswers[i];
      if (selected != null &&
          selected == current.questions[i].correctOption) {
        correctCount++;
      }
    }
    final score = correctCount / current.questions.length;

    state = AsyncData(
      QuizState.completed(
        score: score,
        passed: score >= current.passThreshold,
        correctCount: correctCount,
        totalQuestions: current.questions.length,
        lessonId: current.lessonId,
        questions: current.questions,
        selectedAnswers: current.selectedAnswers,
      ),
    );
  }
}
```

**Generated provider name:** `@riverpod class QuizNotifier` → generates `quizNotifierProvider` (parameterized: `quizNotifierProvider(taskId)`). This follows the same naming as `lessonNotifierProvider(taskId)` from Story 3.x.

**Side effects (navigation) must NOT be inside the notifier** — use `ref.listen` in `QuizScreen` to react to `QuizCompleted` state.

### QuizScreen — Key Implementation Details

```dart
// lib/features/quiz/presentation/quiz_screen.dart

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({required this.taskId, super.key});
  final String taskId;
  // ...
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    // ref.listen for navigation — MUST be in build(), not initState()
    ref.listen<AsyncValue<QuizState>>(
      quizNotifierProvider(widget.taskId),
      (_, next) {
        next.whenData((state) {
          if (state is QuizCompleted && context.mounted) {
            if (state.passed) {
              context.go('/quiz/${widget.taskId}/pass');
            } else {
              context.go('/quiz/${widget.taskId}/fail');
            }
          }
        });
      },
    );

    final quizAsync = ref.watch(quizNotifierProvider(widget.taskId));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => _showLeaveDialog(context),
      child: Scaffold(
        body: quizAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => /* error + retry */,
          data: (state) => switch (state) {
            QuizActive() => _QuizActiveBody(
                state: state,
                taskId: widget.taskId,
                onSelectAnswer: (option) => ref
                    .read(quizNotifierProvider(widget.taskId).notifier)
                    .selectAnswer(option),
                onContinue: () => ref
                    .read(quizNotifierProvider(widget.taskId).notifier)
                    .advanceOrComplete(),
              ),
            QuizCompleted() => const SizedBox.shrink(), // navigation handled by ref.listen
          },
        ),
      ),
    );
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave this quiz?'),
        content: const Text('Your progress will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Stay')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/board');
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
```

### QuizAnswerOption — Color Rules (CRITICAL)

The `correctOption` stored in Drift is **lowercase**: `'a'`, `'b'`, `'c'`, `'d'`. The `option` parameter to `QuizAnswerOption` must also be lowercase when compared.

**Display labels** are uppercase: "A", "B", "C", "D" (for UI only).

**Post-answer color reveal happens immediately when the student taps an option** (AC3, UX-DR7):
- The correct option ALWAYS shows `AppColors.taskDone` (Sage Green) background once any answer is selected
- The student's wrong answer shows `AppColors.taskReopened` (Dusty Rose) background
- If the student selected the correct answer, that option shows Sage Green only
- No strikethrough text on wrong answers (UX-DR7 explicit requirement)

```dart
// Color logic in QuizAnswerOption
bool isSelected = selectedOption == option; // this option was chosen
bool isCorrect = correctOption == option;   // this is the right answer
bool isAnswered = selectedOption != null;   // student has selected something

Color? backgroundColor;
if (isAnswered) {
  if (isCorrect) {
    backgroundColor = AppColors.taskDone.withValues(alpha: 0.2); // Sage Green
  } else if (isSelected) {
    backgroundColor = AppColors.taskReopened.withValues(alpha: 0.2); // Dusty Rose
  }
}
```

### QuizScreen — LinearProgressIndicator

Progress shows current question position, not scroll position:

```dart
// X of Y indicator above the question
LinearProgressIndicator(
  value: (currentIndex + 1) / questions.length,
  backgroundColor: colorScheme.surfaceContainerHighest,
  color: AppColors.calmBlue,
)
Text(
  'Question ${currentIndex + 1} of ${questions.length}',
  style: textTheme.labelMedium,
)
```

### Router Update

```dart
// lib/router.dart — REPLACE existing stub, ADD two new sub-routes

GoRoute(
  path: '/quiz/:taskId',
  pageBuilder: (context, state) {
    final taskId = state.pathParameters['taskId']!;
    return MaterialPage(child: QuizScreen(taskId: taskId));
  },
  routes: [
    GoRoute(
      path: 'pass',
      pageBuilder: (context, state) {
        final taskId = state.pathParameters['taskId']!;
        return MaterialPage(child: QuizPassScreen(taskId: taskId));
      },
    ),
    GoRoute(
      path: 'fail',
      pageBuilder: (context, state) {
        final taskId = state.pathParameters['taskId']!;
        return MaterialPage(child: QuizFailScreen(taskId: taskId));
      },
    ),
  ],
),
```

**Route paths:** `/quiz/:taskId/pass` and `/quiz/:taskId/fail` — sub-routes of `/quiz/:taskId`.

### Stub Pass/Fail Screens

```dart
// lib/features/quiz/presentation/quiz_pass_screen.dart
// Story 4.2 will replace this with full TaskCompletionAnimation implementation
class QuizPassScreen extends ConsumerWidget {
  const QuizPassScreen({required this.taskId, super.key});
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lesson complete.', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/board'),
                child: const Text('Back to board'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

```dart
// lib/features/quiz/presentation/quiz_fail_screen.dart
// Story 4.3 will replace this with PivotQuestionCard and full failure UX
class QuizFailScreen extends ConsumerWidget {
  const QuizFailScreen({required this.taskId, super.key});
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Not done yet.', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.push('/lesson/$taskId'),
                child: const Text('Review lesson'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/board'),
                child: const Text('Try again later'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Build Runner Instructions

**Run ONCE after all code-generated files are created:**
```bash
dart run build_runner build --delete-conflicting-outputs
```
From `studyboard_mobile/`. This generates:
- `quiz_dao.g.dart` (regenerated — new tables added)
- `quiz_state.freezed.dart` (new)
- `quiz_notifier.g.dart` (new)
- `quiz_repository_impl.g.dart` (new)

**No other build_runner work needed** — domain models (`QuizQuestion`, `QuizAttempt`) already have generated files.

### Testing Requirements

```dart
// test/features/quiz/presentation/quiz_notifier_test.dart
// Use mocktail to mock QuizRepository

void main() {
  // Test 1: build() returns QuizActive with first question
  // Test 2: selectAnswer() sets selectedAnswers[0] for first question
  // Test 3: selectAnswer() on already-answered question does nothing (idempotent)
  // Test 4: advanceOrComplete() with non-last question increments currentIndex
  // Test 5: advanceOrComplete() with last question emits QuizCompleted
  // Test 6: score calculation — 2 correct of 4 = score 0.5
  // Test 7: passed = true when score >= passThreshold (0.8), false when below
  // Test 8: passed = true for exact threshold (0.8 >= 0.8)
  // Test 9: advanceOrComplete() without selection does nothing
}
```

**Mock QuizRepository**: override with `MockQuizRepository()` that returns `Right(quizData)` with 4 stub questions and `passThreshold: 0.8`.

### Previous Story Learnings Applied (Stories 3.1–3.3)

- **Provider naming (Riverpod code-gen):** `@riverpod class QuizNotifier extends _$QuizNotifier` → generates `quizNotifierProvider`; parameterized: `quizNotifierProvider(taskId)` — NOT `quizProvider`; confirmed via `lessonNotifierProvider` pattern in `lesson_notifier.dart`
- **`ref.listen` for navigation** — use in `build()` method, never inside the notifier; same pattern as other notifiers
- **`package:` imports everywhere** — no relative imports inside `lib/`; `package:studyboard_mobile/...`
- **`sort_constructors_first` lint** — constructor before fields in all new classes
- **`ConsumerStatefulWidget`** for `QuizScreen` (needs `PopScope` + controller lifecycle) vs `ConsumerWidget` for stateless screens
- **`ref.read(provider.notifier).method()`** for one-shot calls from UI; `ref.watch(provider)` for reactive state
- **`freezed` with `sealed`** — use `switch (state) { QuizActive() => ..., QuizCompleted() => ... }` for exhaustive matching (Dart 3.x)
- **Error handling** — repository returns `Either<Failure, T>`; notifier throws on Left to surface `AsyncValue.error`; widgets handle `.error` state

### Key Architecture Constraints

- **QuizNotifier is the SOLE future caller of `markTaskComplete`/`resetTaskToInProgress`** — Story 4.1 does NOT call these; they are added in Stories 4.2/4.3 to this same notifier file
- **No quiz_attempts recording in Story 4.1** — `QuizDao.saveAttempt()` is called in Story 4.3 when the failure is processed; Story 4.2 calls it on pass
- **Immediate answer reveal (AC3, UX-DR7)** — correct/wrong colors show as soon as the student taps an option, not after Continue; this is optimistic UI per UX spec
- **`correctOption` is lowercase in DB** — `'a'`, `'b'`, `'c'`, `'d'`; comparison: `selectedOption == question.correctOption` works because `selectAnswer()` stores lowercase
- **NFR3 compliance** — all question data is in Drift (loaded at quiz start in `build()`); `advanceOrComplete()` only manipulates in-memory state; no Drift reads during question transitions
- **No `AnimatedOpacity` anywhere in quiz screens** — banned per architecture; use `AnimatedContainer` for color transitions if needed
- **`PopScope` canPop: false** — prevents hardware back from exiting quiz without dialog

### Anti-Patterns to Avoid

- ❌ Calling Supabase directly from QuizNotifier or QuizScreen — all reads are local Drift
- ❌ Setting `task_status = 'done'` in this story — only Story 4.2 via `markTaskComplete()`
- ❌ Recording `quiz_attempts` in this story — Story 4.3 responsibility
- ❌ Hardcoding pass threshold as `0.8` — always read from `SubjectsTable.quizPassThreshold` via `getQuizContextForTask()`
- ❌ Making network calls between questions — violates NFR3 (≤1s) and offline requirement (FR39)
- ❌ Storing `selectedAnswers` as `Map<int, String>` with uppercase 'A'/'B'/'C'/'D' — must use lowercase to match `correctOption` in DB
- ❌ Using `AnimatedOpacity` for any animation in quiz screens — banned per architecture
- ❌ Calling `advanceOrComplete()` when no answer is selected — guard with `selectedAnswers.containsKey(currentIndex)` check
- ❌ Navigation inside QuizNotifier — use `ref.listen` in QuizScreen; notifiers have no `BuildContext`
- ❌ Using `GoRoute` without nested sub-routes for pass/fail — use nested `routes: [...]` inside the `/quiz/:taskId` route

### Project Structure — Files This Story Creates/Modifies

**Create:**
```
lib/features/quiz/domain/quiz_repository.dart
lib/features/quiz/data/quiz_repository_impl.dart
lib/features/quiz/data/quiz_repository_impl.g.dart         (generated)
lib/features/quiz/presentation/quiz_state.dart
lib/features/quiz/presentation/quiz_state.freezed.dart     (generated)
lib/features/quiz/presentation/quiz_notifier.dart
lib/features/quiz/presentation/quiz_notifier.g.dart        (generated)
lib/features/quiz/presentation/quiz_screen.dart
lib/features/quiz/presentation/quiz_pass_screen.dart       (stub — Story 4.2 replaces)
lib/features/quiz/presentation/quiz_fail_screen.dart       (stub — Story 4.3 replaces)
lib/features/quiz/presentation/widgets/quiz_answer_option.dart
test/features/quiz/presentation/quiz_notifier_test.dart
```

**Modify:**
```
lib/core/database/daos/quiz_dao.dart           # Add 4 tables to @DriftAccessor + getQuizContextForTask()
lib/core/database/daos/quiz_dao.g.dart         # Regenerated by build_runner
lib/router.dart                                # Replace stub, add nested pass/fail routes
```

**Do NOT modify:**
- `lib/features/quiz/domain/quiz_question.dart` — already complete
- `lib/features/quiz/domain/quiz_attempt.dart` — already complete (used by 4.2/4.3)
- `lib/features/lesson/presentation/lesson_content_screen.dart` — already navigates to `/quiz/:taskId`
- `lib/core/database/database_provider.dart` — `quizDaoProvider` already exists
- `pubspec.yaml` — no new dependencies
- `lib/core/database/app_database.dart` — no schema changes; `schemaVersion` stays at **2**
- `lib/features/board/domain/task_status.dart` — existing enum, no changes
- Any `lesson_tasks_table.dart`, `subjects_table.dart`, etc. — added to QuizDao accessor only, no table changes

### References

- [Source: epics.md#Story 4.1] — All 6 ACs, NFR3
- [Source: epics.md#Epic 4] — "Quiz state machine (In Progress → Done ONLY via `TaskRepository.markTaskComplete()`)", "QuizQuestionCard, PivotQuestionCard"
- [Source: architecture.md#Communication Patterns — Task State Machine] — `quiz_notifier.dart` is the only caller of `markTaskComplete()` / `resetTaskToInProgress()`
- [Source: architecture.md#Flutter Architecture — Feature Folder Structure] — `lib/features/quiz/` layout
- [Source: architecture.md#Quiz Gate Boundary] — `quiz_notifier.dart` ONLY file to call `TaskDao.markTaskComplete()`
- [Source: architecture.md#Process Patterns — Animation & Haptic Rules] — no `AnimatedOpacity`, `HapticFeedback.mediumImpact()` fires in Story 4.2 (not 4.1)
- [Source: architecture.md#Gap 2] — `subjects.quiz_pass_threshold REAL DEFAULT 0.8`; `QuizRepositoryImpl.evaluateAttempt()` reads from local Drift subjects table
- [Source: ux-design-specification.md#UX-DR7] — `QuizQuestionCard`: LinearProgressIndicator, A–D OutlinedButton, Continue FilledButton, post-answer Sage Green/Dusty Rose, no strikethrough, PopScope dialog
- [Source: ux-design-specification.md#UX-DR8] — `PivotQuestionCard` (Story 4.3 scope)
- [Source: ux-design-specification.md#UX-DR9] — `TaskCompletionAnimation` (Story 4.2 scope)
- [Source: router.dart#line 96-100] — existing `/quiz/:taskId` stub with comment "Story 4.1 will replace this stub with the real QuizScreen"
- [Source: lesson_content_screen.dart#line 79] — `context.push('/quiz/${widget.taskId}')` — already wired; do not modify
- [Source: 3-3-content-image-pre-fetch-and-background-sync.md#Dev Notes] — provider naming, `ref.read` vs `ref.watch`, `package:` import rule, `sort_constructors_first` lint

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- Riverpod codegen strips "Notifier" suffix: `QuizNotifier` → `quizProvider` (not `quizNotifierProvider`). Same pattern as `LessonNotifier` → `lessonProvider`. All provider references updated accordingly.
- Pre-existing 5 failures in `session_tracker_notifier_test.dart` confirmed via git stash — unrelated to this story, not introduced by these changes.

### Completion Notes List

- Extended `QuizDao` with 4-way JOIN (`lesson_tasks → lessons → topics → subjects`) via `getQuizContextForTask()`. Regenerated `quiz_dao.g.dart`.
- Created `QuizRepository` interface with `QuizData` record typedef; `QuizRepositoryImpl` maps `QuizQuestionsTableData` rows to `QuizQuestion` domain objects and returns `Either<Failure, QuizData>`.
- Created `QuizState` as a `@freezed sealed` union with `QuizActive` (holds in-progress quiz state) and `QuizCompleted` (holds score, passed, correctCount).
- Created `QuizNotifier` (`@riverpod`, generates `quizProvider`): `build()` loads from Drift via repository; `selectAnswer()` is idempotent (guards re-selection); `advanceOrComplete()` guards no-selection; score computed locally from `Map<int,String> selectedAnswers`.
- Created `QuizAnswerOption` widget: Sage Green (`colorScheme.taskDone`) on correct, Dusty Rose (`colorScheme.taskReopened`) on wrong — both at `withValues(alpha: 0.2)`. No answer state changes colour immediately on tap (AC3).
- Created `QuizScreen` (`ConsumerStatefulWidget`): `PopScope(canPop: false)` intercepts back gesture and shows Stay/Leave dialog (AC5). `ref.listen` drives navigation to `/quiz/:taskId/pass` or `/quiz/:taskId/fail` on `QuizCompleted` (AC6).
- Created stub `QuizPassScreen` and `QuizFailScreen` — Story 4.2/4.3 will replace.
- Updated `router.dart`: replaced stub with real `QuizScreen` route + nested `pass`/`fail` sub-routes.
- All 10 `quiz_notifier_test.dart` tests pass; full suite passes except 5 pre-existing session test failures.

### File List

**Created:**
- `lib/features/quiz/domain/quiz_repository.dart`
- `lib/features/quiz/data/quiz_repository_impl.dart`
- `lib/features/quiz/data/quiz_repository_impl.g.dart` (generated)
- `lib/features/quiz/presentation/quiz_state.dart`
- `lib/features/quiz/presentation/quiz_state.freezed.dart` (generated)
- `lib/features/quiz/presentation/quiz_notifier.dart`
- `lib/features/quiz/presentation/quiz_notifier.g.dart` (generated)
- `lib/features/quiz/presentation/quiz_screen.dart`
- `lib/features/quiz/presentation/quiz_pass_screen.dart`
- `lib/features/quiz/presentation/quiz_fail_screen.dart`
- `lib/features/quiz/presentation/widgets/quiz_answer_option.dart`
- `test/features/quiz/presentation/quiz_notifier_test.dart`

**Modified:**
- `lib/core/database/daos/quiz_dao.dart`
- `lib/core/database/daos/quiz_dao.g.dart` (regenerated)
- `lib/router.dart`

## Change Log

- 2026-05-07: Implemented full quiz engine — QuizDao extended, QuizRepository, QuizState, QuizNotifier, QuizScreen, QuizAnswerOption, stub pass/fail screens, router updated. 10 tests added and passing.
