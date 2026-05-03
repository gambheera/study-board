# Story 3.1: Curiosity-First Warm-Up Screen

Status: done

## Story

As a student,
I want to see a past paper question from the lesson's topic before the lesson content opens,
So that my curiosity is activated — I study with a real question already in my mind.

## Acceptance Criteria

1. **Given** a student taps "Start studying" on an In Progress `TaskCard` **When** the lesson flow opens **Then** the `CuriosityScreen` is the first screen displayed — lesson content is not accessible until the student taps "Continue to lesson"

2. **Given** the `CuriosityScreen` is displayed **When** rendered **Then** the framing copy reads "Here's what A/L examiners actually ask about [topic name]" (Body Large, muted — `onSurface` at 60% opacity), the past paper question text is displayed below (Title Medium, 1.6× line-height), and a "Continue to lesson" `FilledButton` appears at the bottom

3. **Given** the student has not yet tapped "Continue to lesson" **When** they press the Android back gesture **Then** a `PopScope` intercepts the gesture and an `AlertDialog` appears: "Leave this lesson? [Stay] [Leave]" — tapping Stay returns to the CuriosityScreen; tapping Leave pops the route stack and returns to the Board

4. **Given** the CuriosityScreen is displayed offline **When** the student views it **Then** the past paper question renders correctly from the local Drift cache — no network request is made (FR18)

5. **Given** the student taps "Continue to lesson" **When** the action fires **Then** a `curiosity_completed` flag is set to `true` on the `lesson_tasks` record in Drift for this lesson (via `LessonDao.setCuriosityCompleted`), a sync queue entry is enqueued in the same transaction, and the student is routed to `/lesson/:taskId` (stub for Story 3.2)

6. **Given** the student force-quits the app mid-CuriosityScreen and reopens **When** they tap the same In Progress task again **Then** the `curiosity_completed` flag in Drift is `false`, so the CuriosityScreen is shown again — the lesson content remains inaccessible until the curiosity step is completed

7. **Given** an In Progress `TaskCard` is tapped on the Board **When** the bottom sheet opens **Then** a "Start studying" `FilledButton` is shown — tapping it navigates to `/curiosity/:taskId` via `context.push`

## Tasks / Subtasks

- [x] Task 1: Extend `LessonDao` with task and topic query methods (AC: #1, #4, #6)
  - [x] Add `TopicsTable` to `@DriftAccessor` tables list in `lib/core/database/daos/lesson_dao.dart`
  - [x] Add `getTaskById(String taskId) → Future<LessonTasksTableData?>` — `(select(lessonTasksTable)..where((t) => t.id.equals(taskId))).getSingleOrNull()`
  - [x] Add `getLessonWithTopicTitle(String lessonId) → Future<({LessonsTableData lesson, TopicsTableData topic})?>` — use a join: `select(lessonsTable).join([innerJoin(topicsTable, topicsTable.id.equalsExp(lessonsTable.topicId))])..where(lessonsTable.id.equals(lessonId))`, return null if no row found
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/`

- [x] Task 2: Create `LessonRepository` interface and implementation (AC: #1, #4, #5)
  - [x] Create `lib/features/lesson/domain/lesson_repository.dart` — abstract interface with:
    - `getLessonDetails(String taskId) → Future<LessonDetails>` where `LessonDetails` is a `@freezed` class in the same file containing: `taskId`, `lessonId`, `lessonTitle`, `topicTitle`, `questionText`, `curiosityCompleted`
    - `setCuriosityCompleted(String taskId) → Future<void>`
  - [x] Create `lib/features/lesson/data/lesson_repository_impl.dart` — `LessonRepositoryImpl implements LessonRepository`:
    - `getLessonDetails`: call `_dao.getTaskById(taskId)` (null → throw `StateError`), then `_dao.getLessonWithTopicTitle(task.lessonId)` (null → throw `StateError`), then `_dao.getPastPaperQuestionsForLesson(task.lessonId)`, return `LessonDetails` with `questionText: questions.isNotEmpty ? questions.first.questionText : ''`
    - `setCuriosityCompleted`: delegates to `_dao.setCuriosityCompleted(taskId)`
  - [x] Create `lib/features/lesson/data/lesson_provider.dart` — `@riverpod LessonRepository lessonRepository(Ref ref)` using `LessonRepositoryImpl(ref.watch(appDatabaseProvider).lessonDao)`

- [x] Task 3: Create `LessonState` and `LessonNotifier` (AC: #1, #5, #6)
  - [x] Create `lib/features/lesson/presentation/lesson_state.dart`
  - [x] Create `lib/features/lesson/presentation/lesson_notifier.dart`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 4: Create `CuriosityScreen` (AC: #1, #2, #3, #4, #5)
  - [x] Create `lib/features/lesson/presentation/curiosity_screen.dart`

- [x] Task 5: Add routes to `router.dart` (AC: #1, #5, #7)
  - [x] Open `lib/router.dart`
  - [x] Add import for `curiosity_screen.dart`
  - [x] Add `/curiosity/:taskId` route as a **top-level** `GoRoute` (outside the `ShellRoute`)
  - [x] Add `/lesson/:taskId` stub route (Story 3.2 will replace this)
  - [x] Both routes go BEFORE the `ShellRoute` in the routes list

- [x] Task 6: Update `board_screen.dart` — wire up In Progress card actions (AC: #7)
  - [x] Update `_tapHandlerFor` to handle `TaskStatus.inProgress`
  - [x] Add `_showInProgressActionSheet(BacklogItem item)` method
  - [x] Verify `import 'package:go_router/go_router.dart';` is present

- [x] Task 7: Write tests (AC: #1, #4, #5, #6)
  - [x] Create `test/features/lesson/data/lesson_repository_impl_test.dart` (5 tests — all pass)
  - [x] Create `test/features/lesson/presentation/lesson_notifier_test.dart` (3 tests — all pass)

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/features/lesson/domain/lesson.dart` — `Lesson` freezed model (`id`, `topicId`, `title`, `contentText`, `contentTrack`, `orderIndex`) — **DO NOT modify or duplicate**
- `lib/features/lesson/domain/past_paper_question.dart` — `PastPaperQuestion` freezed model — **DO NOT modify**
- `lib/core/database/daos/lesson_dao.dart` — already has:
  - `getLessonById(String lessonId)` — exists but NOT used in this story flow (use new `getLessonWithTopicTitle` instead)
  - `getPastPaperQuestionsForLesson(String lessonId)` ✅ reuse
  - `setCuriosityCompleted(String taskId)` ✅ reuse — already sets flag + enqueues sync in one transaction
- `lib/core/database/tables/lesson_tasks_table.dart` — `curiosityCompleted` boolean column already exists with `DEFAULT false` — **NO schema changes needed**
- `lib/features/backlog/domain/backlog_item.dart` — `BacklogItem.curiosityCompleted` field is already present (will be available in the board tap handler)
- `lib/core/database/app_database.dart` — `LessonDao` is already in the `daos:` list AND `TopicsTable` is in `tables:` — **just add `TopicsTable` import to lesson_dao.dart itself**
- `lib/router.dart` — `ScaffoldWithNavBar` uses `ref.listen(contentSyncProvider, (_, _) {})` and `ref.listen(sessionTrackerProvider, (_, _) {})` pattern — do NOT disturb these
- `lib/core/database/database_provider.dart` — `appDatabaseProvider` exposed `.lessonDao` after Story 1.3's build_runner — access as `ref.watch(appDatabaseProvider).lessonDao`

### Schema Version — DO NOT Change

`AppDatabase.schemaVersion` stays at **2**. All required columns (`curiosityCompleted`, etc.) already exist in schema v1/v2. No migrations needed in this story.

### LessonDao — Full Additions Reference

```dart
// Add to @DriftAccessor tables in lesson_dao.dart:
@DriftAccessor(
  tables: [
    LessonsTable,
    PastPaperQuestionsTable,
    LessonTasksTable,
    SyncQueueTable,
    TopicsTable,   // ← ADD THIS
  ],
)

// New method — get task by taskId (needed to extract lessonId):
Future<LessonTasksTableData?> getTaskById(String taskId) =>
    (select(lessonTasksTable)..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();

// New method — lesson joined with its topic (for topic title):
Future<({LessonsTableData lesson, TopicsTableData topic})?>
    getLessonWithTopicTitle(String lessonId) async {
  final query = select(lessonsTable).join([
    innerJoin(
      topicsTable,
      topicsTable.id.equalsExp(lessonsTable.topicId),
    ),
  ])..where(lessonsTable.id.equals(lessonId));
  final row = await query.getSingleOrNull();
  if (row == null) return null;
  return (
    lesson: row.readTable(lessonsTable),
    topic: row.readTable(topicsTable),
  );
}
```

Add to `lesson_dao.dart` imports:
```dart
import 'package:studyboard_mobile/core/database/tables/topics_table.dart';
```

### LessonRepository Interface + Impl Reference

```dart
// lib/features/lesson/domain/lesson_repository.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'lesson_repository.freezed.dart';

@freezed
abstract class LessonDetails with _$LessonDetails {
  const factory LessonDetails({
    required String taskId,
    required String lessonId,
    required String lessonTitle,
    required String topicTitle,
    required String questionText,
    required bool curiosityCompleted,
  }) = _LessonDetails;
}

abstract interface class LessonRepository {
  Future<LessonDetails> getLessonDetails(String taskId);
  Future<void> setCuriosityCompleted(String taskId);
}
```

```dart
// lib/features/lesson/data/lesson_repository_impl.dart
import 'package:studyboard_mobile/core/database/daos/lesson_dao.dart';
import 'package:studyboard_mobile/features/lesson/domain/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl(this._dao);
  final LessonDao _dao;

  @override
  Future<LessonDetails> getLessonDetails(String taskId) async {
    final task = await _dao.getTaskById(taskId);
    if (task == null) throw StateError('Task not found: $taskId');
    final lessonWithTopic = await _dao.getLessonWithTopicTitle(task.lessonId);
    if (lessonWithTopic == null) {
      throw StateError('Lesson not found: ${task.lessonId}');
    }
    final questions = await _dao.getPastPaperQuestionsForLesson(task.lessonId);
    return LessonDetails(
      taskId: taskId,
      lessonId: task.lessonId,
      lessonTitle: lessonWithTopic.lesson.title,
      topicTitle: lessonWithTopic.topic.title,
      questionText: questions.isNotEmpty ? questions.first.questionText : '',
      curiosityCompleted: task.curiosityCompleted,
    );
  }

  @override
  Future<void> setCuriosityCompleted(String taskId) =>
      _dao.setCuriosityCompleted(taskId);
}
```

```dart
// lib/features/lesson/data/lesson_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/features/lesson/data/lesson_repository_impl.dart';
import 'package:studyboard_mobile/features/lesson/domain/lesson_repository.dart';
part 'lesson_provider.g.dart';

@riverpod
LessonRepository lessonRepository(Ref ref) =>
    LessonRepositoryImpl(ref.watch(appDatabaseProvider).lessonDao);
```

### LessonNotifier Reference

```dart
// lib/features/lesson/presentation/lesson_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/lesson/data/lesson_provider.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_state.dart';
part 'lesson_notifier.g.dart';

@riverpod
class LessonNotifier extends _$LessonNotifier {
  @override
  Future<LessonState> build(String taskId) async {
    final details = await ref.read(lessonRepositoryProvider).getLessonDetails(taskId);
    return LessonState(
      taskId: details.taskId,
      lessonId: details.lessonId,
      lessonTitle: details.lessonTitle,
      topicTitle: details.topicTitle,
      questionText: details.questionText,
      curiosityCompleted: details.curiosityCompleted,
    );
  }

  Future<void> completeCuriosity() async {
    final current = state.value;
    if (current == null) return;
    // Use ref.read for one-shot action — not ref.watch
    await ref.read(lessonRepositoryProvider).setCuriosityCompleted(current.taskId);
    state = AsyncData(current.copyWith(curiosityCompleted: true));
  }
}
```

### CuriosityScreen — Full Reference

```dart
// lib/features/lesson/presentation/curiosity_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_notifier.dart';

class CuriosityScreen extends ConsumerWidget {
  const CuriosityScreen({required this.taskId, super.key});
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(lessonNotifierProvider(taskId));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showLeaveDialog(context);
      },
      child: lessonAsync.when(
        loading: () => const _CuriositySkeletonScreen(),
        error: (e, _) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Could not load lesson. Please try again.'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(lessonNotifierProvider(taskId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (lesson) => _CuriosityContent(
          lesson: lesson,
          onContinue: () => _onContinue(context, ref),
        ),
      ),
    );
  }

  Future<void> _onContinue(BuildContext context, WidgetRef ref) async {
    await ref.read(lessonNotifierProvider(taskId).notifier).completeCuriosity();
    if (!context.mounted) return;
    context.pushReplacement('/lesson/$taskId');
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Leave this lesson?'),
        content: const Text('Your progress on this warm-up will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pop();
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}

class _CuriosityContent extends StatelessWidget {
  const _CuriosityContent({required this.lesson, required this.onContinue});
  final LessonState lesson;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Here's what A/L examiners actually ask about ${lesson.topicTitle}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: lesson.questionText.isEmpty
                      ? Text(
                          'No past paper question available for this topic.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : Text(
                          lesson.questionText,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(height: 1.6),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onContinue,
                  child: const Text('Continue to lesson'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CuriositySkeletonScreen extends StatelessWidget {
  const _CuriositySkeletonScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonBox(height: 20, width: double.infinity),
              SizedBox(height: 8),
              _SkeletonBox(height: 20, width: 200),
              SizedBox(height: 24),
              _SkeletonBox(height: 18, width: double.infinity),
              SizedBox(height: 8),
              _SkeletonBox(height: 18, width: double.infinity),
              SizedBox(height: 8),
              _SkeletonBox(height: 18, width: 280),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
```

### board_screen.dart — In Progress Action Sheet Addition

Add `_showInProgressActionSheet` method to `_BoardColumnState`:

```dart
void _showInProgressActionSheet(BacklogItem item) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  unawaited(
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.lessonTitle, style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Topic / ${item.topicTitle}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.push('/curiosity/${item.taskId}');
                  },
                  child: const Text('Start studying'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
```

Then update `_tapHandlerFor`:
```dart
VoidCallback? _tapHandlerFor(BacklogItem item) {
  return switch (item.taskStatus) {
    TaskStatus.todo => () => _showTodoActionSheet(item),
    TaskStatus.inProgress => () => _showInProgressActionSheet(item),  // ADD
    TaskStatus.done => null,
    TaskStatus.backlog => null,
  };
}
```

### router.dart — Route Additions

Add these two routes to `GoRouter.routes` list BEFORE the `ShellRoute` block:

```dart
GoRoute(
  path: '/curiosity/:taskId',
  pageBuilder: (context, state) {
    final taskId = state.pathParameters['taskId']!;
    return MaterialPage(child: CuriosityScreen(taskId: taskId));
  },
),
GoRoute(
  path: '/lesson/:taskId',
  // Story 3.2 will replace this stub with the real LessonContentScreen
  pageBuilder: (context, state) => const MaterialPage(
    child: Scaffold(body: Center(child: Text('Lesson content coming soon'))),
  ),
),
```

### Key Architecture Constraints

- **Drift write on curiosity completion** — `setCuriosityCompleted` in `LessonDao` already handles the transaction + sync enqueue — do NOT add a second sync enqueue
- **`ref.read` for one-shot actions** — `completeCuriosity()` uses `ref.read(lessonNotifierProvider(taskId).notifier)` and `ref.read(lessonRepositoryProvider)` — never `ref.watch` inside actions
- **`context.mounted` guard** — always check `if (!context.mounted) return;` after any `await` before navigating
- **`PopScope` pattern** — `canPop: false` + `onPopInvokedWithResult` callback; do NOT use deprecated `onPopInvoked`
- **No Supabase calls** — `LessonRepositoryImpl` is pure Drift; all data comes from local cache; no network requests in this story
- **Bottom nav hidden** — `/curiosity/:taskId` is top-level (NOT inside `ShellRoute`), so `ScaffoldWithNavBar` is not shown; no bottom nav during study loop
- **`context.push` not `context.go`** — use `push` to add CuriosityScreen to the stack (can `context.pop()` back to Board); `go` would replace the stack
- **`unawaited()` for bottom sheet** — `showModalBottomSheet` returns a Future; wrap with `unawaited()` from `dart:async` (already imported in board_screen.dart)
- **`freezed_annotation` import** — `LessonDetails` and `LessonState` need `freezed_annotation` and `part` directives; run build_runner after all files are created
- **`sort_constructors_first` lint** — constructor before field declarations in all new classes

### Anti-Patterns to Avoid

- ❌ Calling `getLessonById` from `LessonDao` directly in the notifier — use `getLessonDetails` from the repository interface
- ❌ Using `ref.watch` inside `completeCuriosity()` action — use `ref.read`
- ❌ Calling `setCuriosityCompleted` from outside the repository — all DAO calls go through the repository layer
- ❌ Adding the `/curiosity` route INSIDE the `ShellRoute` — that would keep the bottom nav visible
- ❌ Using `context.go('/lesson/$taskId')` from CuriosityScreen — use `context.pushReplacement` so pressing back from LessonContent doesn't return to CuriosityScreen (it returns to Board)
- ❌ Forgetting `context.mounted` check after `await completeCuriosity()` — async gap before navigation
- ❌ Running build_runner before all `@freezed` and `@riverpod` annotated files are saved — batch all annotation changes then run once
- ❌ Adding a `CircularProgressIndicator` loading state — use skeleton shimmer boxes (grey containers) per UX-DR17

### Project Structure — Files This Story Creates/Modifies

**Create:**
```
lib/features/lesson/domain/lesson_repository.dart            # LessonDetails + LessonRepository interface
lib/features/lesson/domain/lesson_repository.freezed.dart    (generated)
lib/features/lesson/data/lesson_repository_impl.dart
lib/features/lesson/data/lesson_provider.dart
lib/features/lesson/data/lesson_provider.g.dart              (generated)
lib/features/lesson/presentation/lesson_state.dart
lib/features/lesson/presentation/lesson_state.freezed.dart   (generated)
lib/features/lesson/presentation/lesson_notifier.dart
lib/features/lesson/presentation/lesson_notifier.g.dart      (generated)
lib/features/lesson/presentation/curiosity_screen.dart
test/features/lesson/data/lesson_repository_impl_test.dart
test/features/lesson/presentation/lesson_notifier_test.dart
```

**Modify:**
```
lib/core/database/daos/lesson_dao.dart        # Add TopicsTable + getTaskById + getLessonWithTopicTitle
lib/core/database/daos/lesson_dao.g.dart      (regenerated)
lib/router.dart                               # Add /curiosity/:taskId + /lesson/:taskId routes
lib/features/board/presentation/board_screen.dart  # Add _showInProgressActionSheet + update _tapHandlerFor
```

**Do NOT modify:**
- `lib/features/lesson/domain/lesson.dart` — not used directly in this story's flow
- `lib/features/lesson/domain/past_paper_question.dart` — not used directly
- `lib/core/database/app_database.dart` — LessonDao already in daos; no changes needed
- `lib/core/database/tables/lesson_tasks_table.dart` — schema correct as-is
- `lib/core/database/daos/task_dao.dart` — no changes; `markTaskComplete`/`resetTaskToInProgress` are Epic 4 scope
- `lib/features/board/presentation/board_screen.dart` `_showTodoActionSheet` — "Start studying" there moves task to In Progress but does NOT navigate to CuriosityScreen; Story 3.1 uses the **In Progress** card's action sheet for lesson entry

### Build Runner Order

Run once after all annotation files are created (Tasks 1, 2, 3):
```bash
dart run build_runner build --delete-conflicting-outputs
```
From `studyboard_mobile/`. Covers: `LessonDao` mixin, `lesson_repository.freezed.dart`, `lesson_provider.g.dart`, `lesson_state.freezed.dart`, `lesson_notifier.g.dart`.

### Previous Story Learnings Applied (from Stories 2.3, 2.4)

- **`authProvider`** not `authNotifierProvider` — Riverpod 4.x strips `Notifier` suffix from generated provider names
- **`ref.read` for one-shot actions**, `ref.watch` for reactive subscriptions
- **Dart closure type promotion** — extract `final current = state.value` before `await` gap; avoid accessing `.value` after async gap inside same closure
- **`package:` imports everywhere** — no relative imports in `lib/`
- **`sort_constructors_first` lint** — constructor before field declarations
- **`unawaited()`** from `dart:async` for fire-and-forget `Future<void>` in void callbacks
- **`discarded_futures` lint** — `showModalBottomSheet` returns a Future; wrap with `unawaited()`
- **`appDatabaseProvider`** — access DAOs as property: `ref.watch(appDatabaseProvider).lessonDao`
- **`mapOrNull`** generated into extension class in `.freezed.dart` files — import the freezed file or the base class
- **Riverpod family notifier** — `@riverpod class LessonNotifier extends _$LessonNotifier` with `build(String taskId)` — generated provider is `lessonNotifierProvider(taskId)`
- **`clock` package** — not needed here (no time-based tests); use `DateTime.now()` directly

### UX Requirements Reference

From [Source: ux-design-specification.md#CuriosityScreen]:
- `UX-DR6`: Full-screen, framing copy "Here's what A/L examiners actually ask about [topic]" (Body Large, muted), question text (Title Medium, 1.6× line-height), "Continue to lesson" FilledButton
- `UX-DR15`: `PopScope` intercepts Android back → `AlertDialog` "Leave this lesson? [Stay] [Leave]"
- Background: default surface color (no special background — Calm Blue is for board cards, not full-screen lesson screens)
- No loading spinner — use skeleton shimmer for loading state (UX-DR17)
- Curiosity screen content is offline-capable — loaded from Drift cache only

From [Source: ux-design-specification.md#Component Strategy]:
- `CuriosityScreen` receives content as constructor argument — never fetches data itself; data loaded at notifier build time

### References

- [Source: epics.md#Story 3.1] — Acceptance criteria, curiosity_completed flag, CuriosityScreen spec, FR15, FR18
- [Source: epics.md#Epic 3] — "CuriosityScreen component (PopScope back interception, curiosity completion state persisted to Drift)"
- [Source: architecture.md#Flutter Architecture] — feature-first folder structure, repository layer pattern, go_router shell route vs top-level route
- [Source: architecture.md#Communication Patterns] — Riverpod AsyncNotifier pattern, ref.read for one-shot actions
- [Source: architecture.md#Implementation Patterns] — `package:` imports, sort_constructors_first, unawaited() for discarded_futures
- [Source: ux-design-specification.md#CuriosityScreen] — UX-DR6 full spec, UX-DR15 PopScope + AlertDialog, UX-DR17 skeleton loading
- [Source: ux-design-specification.md#User Journey Flows] — Flow 2: Core Study Loop — CuriosityScreen is first screen after tapping In Progress card
- [Source: 2-4-session-activity-logging.md#Dev Notes] — authProvider pattern, ref.read vs ref.watch, Dart closure type promotion, package imports, appDatabaseProvider access, unawaited() lint fix
- [Source: 2-3-kanban-board-and-task-promotion-flow.md#Dev Notes] — board_screen.dart patterns, showModalBottomSheet wrapping, _tapHandlerFor structure

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- Riverpod 4.x strips `Notifier` suffix: generated provider is `lessonProvider` (not `lessonNotifierProvider`). Fixed in `curiosity_screen.dart` and `lesson_notifier_test.dart` after build_runner run confirmed the generated name.

### Completion Notes List

- Task 1: Added `TopicsTable` import and to `@DriftAccessor` tables in `lesson_dao.dart`. Added `getTaskById` (single task lookup) and `getLessonWithTopicTitle` (inner join returning named record). Ran build_runner — `topicsTable` getter confirmed in generated mixin.
- Task 2: Created `LessonDetails` freezed model + `LessonRepository` interface (`lesson_repository.dart`). Created `LessonRepositoryImpl` — pure Drift, no Supabase calls. Created `lesson_provider.dart` with `@riverpod` provider exposing `LessonRepositoryImpl` via `appDatabaseProvider.lessonDao`.
- Task 3: Created `LessonState` freezed class and `LessonNotifier` (async family notifier keyed by `taskId`). `completeCuriosity` uses `ref.read` (not `ref.watch`) and extracts `state.value` before `await` gap per Dart closure type-promotion pattern.
- Task 4: Created `CuriosityScreen` — `ConsumerWidget` with `PopScope(canPop: false)`, skeleton shimmer loading state (3 grey containers, no spinner), `AlertDialog` leave confirmation, `unawaited(showDialog(...))` for discarded-future lint compliance. `_onContinue` guards with `context.mounted` before navigation.
- Task 5: Added `/curiosity/:taskId` and `/lesson/:taskId` as top-level `GoRoute`s before `ShellRoute` in `router.dart` — bottom nav hidden during study loop.
- Task 6: Updated `_tapHandlerFor` to route `inProgress` taps to `_showInProgressActionSheet`. Sheet has "Start studying" FilledButton → `context.push('/curiosity/${item.taskId}')` wrapped in `unawaited()`.
- Task 7: 5 `LessonRepositoryImpl` tests + 3 `LessonNotifier` tests written. All 8 pass. No regressions introduced (153 pre-existing tests pass; 5 pre-existing failures in `session_tracker_notifier_test.dart` are unrelated to this story).

### File List

**Created:**
- `studyboard_mobile/lib/features/lesson/domain/lesson_repository.dart`
- `studyboard_mobile/lib/features/lesson/domain/lesson_repository.freezed.dart` (generated)
- `studyboard_mobile/lib/features/lesson/data/lesson_repository_impl.dart`
- `studyboard_mobile/lib/features/lesson/data/lesson_provider.dart`
- `studyboard_mobile/lib/features/lesson/data/lesson_provider.g.dart` (generated)
- `studyboard_mobile/lib/features/lesson/presentation/lesson_state.dart`
- `studyboard_mobile/lib/features/lesson/presentation/lesson_state.freezed.dart` (generated)
- `studyboard_mobile/lib/features/lesson/presentation/lesson_notifier.dart`
- `studyboard_mobile/lib/features/lesson/presentation/lesson_notifier.g.dart` (generated)
- `studyboard_mobile/lib/features/lesson/presentation/curiosity_screen.dart`
- `studyboard_mobile/test/features/lesson/data/lesson_repository_impl_test.dart`
- `studyboard_mobile/test/features/lesson/presentation/lesson_notifier_test.dart`

**Modified:**
- `studyboard_mobile/lib/core/database/daos/lesson_dao.dart`
- `studyboard_mobile/lib/core/database/daos/lesson_dao.g.dart` (regenerated)
- `studyboard_mobile/lib/router.dart`
- `studyboard_mobile/lib/features/board/presentation/board_screen.dart`

## Tasks / Subtasks — Review Findings

### Review Findings

- [x] [Review][Patch] Rapid back-gesture stacks multiple AlertDialogs — no re-entrancy guard in `onPopInvokedWithResult`; rapid back swipes call `_showLeaveDialog` before the prior dialog is dismissed, stacking multiple `AlertDialog`s [curiosity_screen.dart:onPopInvokedWithResult]
- [x] [Review][Patch] Missing test: `getLessonWithTopicTitle` → null path untested — `StateError('Lesson not found')` branch has zero test coverage [lesson_repository_impl_test.dart]
- [x] [Review][Patch] No double-tap guard on "Continue to lesson" — `_onContinue` fires twice on rapid taps; two `setCuriosityCompleted` DB writes race, producing two sync-queue entries for the same event [curiosity_screen.dart:_onContinue]
- [x] [Review][Patch] Missing `context.mounted` check before `context.push` in board sheet — `context.push('/curiosity/...')` is called after `Navigator.pop(sheetContext)` with no mounted guard; if `BoardScreen` is unmounted while sheet is open the push hits a dead context [board_screen.dart:_showInProgressActionSheet]
- [x] [Review][Patch] `context.pop()` in leave dialog may use stale outer context — if a router redirect (e.g. auth error) disposes `CuriosityScreen` while the `AlertDialog` is open, `context.pop()` in the "Leave" handler throws `"Looking up a deactivated widget's ancestor"` [curiosity_screen.dart:_showLeaveDialog]
- [x] [Review][Patch] `innerJoin` on `topicsTable` silently treats broken FK as "lesson not found" — if a lesson's `topicId` has no matching row, `innerJoin` returns null and `getLessonWithTopicTitle` throws the misleading `StateError('Lesson not found')` rather than a FK integrity error [lesson_dao.dart:getLessonWithTopicTitle]
- [x] [Review][Defer] Sequential DAO reads in `getLessonDetails` without transaction [lesson_repository_impl.dart:getLessonDetails] — deferred, pre-existing
- [x] [Review][Defer] `_syncTabController` disposes `TabController` mid-frame during `build()` [board_screen.dart:_syncTabController] — deferred, pre-existing (story 2.3)
- [x] [Review][Defer] `_applyDiff` AnimatedList index desync on concurrent stream emissions [board_screen.dart:_applyDiff] — deferred, pre-existing (story 2.3)
- [x] [Review][Defer] `_items` populated outside `_applyDiff` on initial build bypasses AnimatedList [board_screen.dart:_BoardColumnState.build] — deferred, pre-existing (story 2.3)
- [x] [Review][Defer] Auth redirect on `hasError` sends user to `/login` mid-lesson [router.dart:redirect] — deferred, pre-existing (story 1.8)
- [x] [Review][Defer] `district.isEmpty` passes whitespace-only district as valid onboarding [router.dart:redirect] — deferred, pre-existing (story 1.8)

## Change Log

- 2026-05-02: Implemented Story 3.1 — CuriosityScreen warm-up flow. Added LessonDao query methods (getTaskById, getLessonWithTopicTitle), LessonRepository layer, LessonNotifier (async family), CuriosityScreen (PopScope back interception, skeleton loading, leave dialog), /curiosity/:taskId and /lesson/:taskId routes, In Progress action sheet on BoardScreen. 8 new tests added, all pass.
