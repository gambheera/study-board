# Story 2.2: Backlog View — Full Syllabus & TaskCard Component

Status: done

## Story

As a student,
I want to see the complete Chemistry syllabus as a scrollable list of task cards in my Backlog,
So that I can see the full exam as a finite, completable plan from my very first session.

## Acceptance Criteria

1. **Given** a student opens the Backlog tab **When** the content has been synced from Supabase (Story 2.1) **Then** every Chemistry lesson with `task_status = 'backlog'` appears as a `TaskCard` in the list — no lessons are hidden, locked, or progressively unlocked

2. **Given** the `TaskCard` component **When** rendered in any state **Then** it displays: a 4dp left-border in the task state color, the lesson title (Title Medium), the topic breadcrumb (Body Medium, `onSurface` at 60% opacity), and a state icon right-aligned — color, icon, and label all present (never color alone)

3. **Given** the five task states (Backlog, To-Do, In Progress, Done, Re-opened) **When** each `TaskCard` state is rendered **Then** the correct border color and icon are shown: Backlog → Cool Blue-Grey `#8896A5` + clock, To-Do → Cool Blue-Grey `#8896A5` + arrow-right, In Progress → Golden Yellow `#FFC107` + play, Done → Sage Green `#4CAF78` + check-circle, Re-opened → Dusty Rose `#C4786A` + refresh

4. **Given** the content track filter (Theory, Past Papers, Future Papers) **When** a student selects a filter tab **Then** only lessons belonging to that content track are shown; the Future Papers tab is visible and selectable but displays the empty-content state if no Future Papers lessons exist (FR12)

5. **Given** the Backlog screen loads for the first time **When** content is being fetched from Drift **Then** three skeleton `TaskCard` placeholder shimmers are displayed at the same height as real cards — no centered spinner

6. **Given** all tasks have been promoted out of Backlog status (to To-Do or beyond) **When** the student views the Backlog tab **Then** the empty state message "Everything is in progress or done." is displayed with no CTA

7. **Given** the `TaskCard` is rendered **When** a TalkBack user focuses it **Then** the semantics label reads: "[lesson title], [state], double-tap to see options"

## Tasks / Subtasks

- [x] Task 1: Add join query to `TaskDao` (AC: #1, #4, #5, #6)
  - [x] Open `lib/core/database/daos/task_dao.dart`
  - [x] Add `LessonsTable` and `TopicsTable` to `@DriftAccessor(tables: [...])` annotation — required for join access
  - [x] Add `BacklogRow` plain Dart class (NOT a generated type) with fields: `task: LessonTasksTableData`, `lesson: LessonsTableData`, `topic: TopicsTableData`
  - [x] Add `watchBacklogTasks(String studentId, {String? contentTrack})` — returns `Stream<List<BacklogRow>>`; joins `lessonTasksTable` → `lessonsTable` → `topicsTable`; filters `studentId` + `taskStatus = 'backlog'`; conditionally adds `contentTrack` filter; orders by `topicsTable.orderIndex` ASC then `lessonsTable.orderIndex` ASC
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` — `@DriftAccessor` annotation changed

- [x] Task 2: Create `BacklogItem` domain model (AC: #1, #2, #3)
  - [x] Create `lib/features/backlog/domain/backlog_item.dart`
  - [x] `@freezed abstract class BacklogItem` with fields: `taskId`, `lessonId`, `lessonTitle`, `topicId`, `topicTitle`, `contentTrack`, `taskStatus (TaskStatus)`, `curiosityCompleted (bool)`, `lessonOrderIndex (int)`, `topicOrderIndex (int)`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 3: Create `BacklogRepository` interface and implementation (AC: #1, #4)
  - [x] Create `lib/features/backlog/domain/backlog_repository.dart` — abstract interface with `watchBacklogTasks(String studentId, {String? contentTrack}) → Stream<List<BacklogItem>>`
  - [x] Create `lib/features/backlog/data/backlog_repository_impl.dart` — extends nothing (pure Drift read), injects `TaskDao` via `appDatabaseProvider`; maps `BacklogRow` → `BacklogItem` using `TaskStatusX.fromString()`
  - [x] Create `lib/features/backlog/data/backlog_provider.dart` — `@riverpod BacklogRepository backlogRepository(Ref ref)` — instantiates `BacklogRepositoryImpl` with `ref.watch(appDatabaseProvider).taskDao`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` — new `@riverpod` annotation

- [x] Task 4: Create `backlogItemsProvider` stream provider (AC: #1, #4)
  - [x] Create `lib/features/backlog/presentation/backlog_items_provider.dart`
  - [x] `@riverpod Stream<List<BacklogItem>> backlogItems(Ref ref, {required String studentId, String? contentTrack})` — calls `ref.read(backlogRepositoryProvider).watchBacklogTasks(studentId, contentTrack: contentTrack)`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 5: Create `TaskCard` widget (AC: #2, #3, #7)
  - [x] Create `lib/features/backlog/presentation/widgets/task_card.dart`
  - [x] `TaskCard` is a `StatelessWidget` with `required BacklogItem item` parameter
  - [x] Left 4dp border: `Container` with `BoxDecoration(border: Border(left: BorderSide(color: _borderColor(context, item.taskStatus), width: 4)))` inside a `Card`
  - [x] Lesson title: `Text(item.lessonTitle, style: Theme.of(context).textTheme.titleMedium)`
  - [x] Topic breadcrumb: `Text(item.topicTitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)))`
  - [x] State icon: right-aligned via `Row` → `Expanded` (title + breadcrumb) + `Icon(_stateIcon(item.taskStatus))`
  - [x] State label: small `Text` below icon or alongside, `Label Medium`, same color as border — never color alone
  - [x] Wrap entire card in `Semantics(label: '${item.lessonTitle}, ${_stateLabel(item.taskStatus)}, double-tap to see options')`
  - [x] `_borderColor()`: uses `Theme.of(context).colorScheme` with `StudyBoardColors` extension — `.taskBacklog`, `.taskInProgress`, `.taskDone`, `.taskReopened`
  - [x] `_stateIcon()`: returns `Icons.access_time` (backlog), `Icons.arrow_forward` (todo), `Icons.play_arrow` (inProgress), `Icons.check_circle` (done)
  - [x] `_stateLabel()`: returns readable label: "Backlog", "To-Do", "In Progress", "Done"
  - [x] Card tap: DO NOT implement bottom sheet in this story — tap is a no-op; `// TODO(story-2-3): implement tap → bottom sheet`
  - [x] Touch target: wrap in `InkWell` so 48dp minimum is honored even without action

- [x] Task 6: Create `SkeletonTaskCard` shimmer placeholder (AC: #5)
  - [x] Create `lib/features/backlog/presentation/widgets/skeleton_task_card.dart`
  - [x] `SkeletonTaskCard` is a `StatefulWidget` with `SingleTickerProviderStateMixin`
  - [x] `AnimationController` with `Duration(milliseconds: 1200)` repeating reverse; `Tween<double>(begin: 0.3, end: 0.7)` with `Curves.easeInOut`
  - [x] `AnimatedBuilder` renders a `Container` with `height: 72`, `margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4)`, corner radius 12dp, color `colorScheme.surfaceContainerHighest.withValues(alpha: animation.value)`
  - [x] No text, no icon — pure shimmer shape

- [x] Task 7: Implement `BacklogScreen` (AC: #1, #4, #5, #6)
  - [x] Open `lib/features/backlog/presentation/backlog_screen.dart`
  - [x] Change to `ConsumerStatefulWidget` with `SingleTickerProviderStateMixin` for `TabController`
  - [x] `TabController` with `length: 3` for Theory / Past Papers / Future Papers
  - [x] `_contentTracks = const ['theory', 'past_papers', 'future_papers']`
  - [x] `Scaffold(appBar: AppBar(title: Text('Backlog'), actions: [profile icon], bottom: TabBar(...)), body: ...)`
  - [x] Profile icon in actions; `TabController.addListener` triggers `setState(() {})` on tab switch
  - [x] Loading state: 3 `SkeletonTaskCard` widgets; empty state: "Everything is in progress or done."; list: `ListView.builder` with `TaskCard`; error: minimal message

- [x] Task 8: Remove `AppBar` from `ScaffoldWithNavBar` in `router.dart` (Epic 1 tech debt, high priority)
  - [x] Open `lib/router.dart`
  - [x] In `ScaffoldWithNavBar.build()`: removed `appBar: AppBar(actions: [...])` block entirely

- [x] Task 9: Tests (AC: #1, #2, #5, #6)
  - [x] Create `test/core/database/task_dao_backlog_test.dart`
    - [x] Test `watchBacklogTasks(studentId)` returns only `task_status = 'backlog'` rows with correct lesson + topic joins
    - [x] Test `watchBacklogTasks(studentId, contentTrack: 'theory')` filters by content track correctly
    - [x] Test `watchBacklogTasks` emits updated stream when a task status changes (promotes to 'todo')
    - [x] Use `AppDatabase.forTesting(NativeDatabase.memory())` — in-memory Drift DB
    - [x] Seed subject → topic → lesson → lesson_task in each test setUp
  - [x] Create `test/features/backlog/presentation/widgets/task_card_test.dart`
    - [x] Widget test for `TaskCard` rendering each of the 4 task states
    - [x] Verify semantics label matches spec
    - [x] Verify border decoration presence
  - [x] `flutter test` → 126 pass; `flutter analyze` → 0 issues

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/features/backlog/presentation/backlog_screen.dart` — exists as a stub `Center(child: Text('Backlog'))`; REPLACE entirely; file already imported in router
- `lib/features/board/domain/task_status.dart` — `TaskStatus` enum + `TaskStatusX` extension; import this — do NOT redefine
- `lib/features/board/domain/task.dart` — `Task` freezed model (task_status, curiosity_completed, etc.); do NOT modify
- `lib/core/database/daos/task_dao.dart` — `TaskDao` with `markTaskComplete`, `resetTaskToInProgress`, `pullToTodo`, `startTask`, `getTaskByLesson`, `createLessonTasksForStudent`; **ADD** new tables to `@DriftAccessor` + `watchBacklogTasks()`; do NOT modify existing methods
- `lib/core/database/tables/lessons_table.dart` — `LessonsTable` with `id`, `topicId`, `title`, `contentText`, `contentTrack`, `orderIndex`
- `lib/core/database/tables/topics_table.dart` — `TopicsTable` with `id`, `subjectId`, `title`, `orderIndex`
- `lib/core/database/tables/lesson_tasks_table.dart` — `LessonTasksTable` with `id`, `studentId`, `lessonId`, `taskStatus`, `curiosityCompleted`, `createdAt`, `updatedAt`
- `lib/router.dart` — `ScaffoldWithNavBar` currently has `appBar: AppBar(actions: [profile icon])` — REMOVE this in Task 8; `/backlog` route already wired
- `lib/features/auth/presentation/auth_notifier.dart` — `authProvider` (Riverpod 4.x, no `Notifier` suffix); extract student via `authValue.value?.mapOrNull(authenticated: (a) => a.student)`
- `lib/core/supabase/supabase_client_provider.dart` — `supabaseClientProvider`; NOT needed for this story (pure Drift read)
- `lib/core/theme/app_colors.dart` — `StudyBoardColors` extension on `ColorScheme` with `.taskBacklog`, `.taskInProgress`, `.taskDone`, `.taskReopened`; import from here — never hardcode hex
- `lib/core/database/app_database.dart` — `AppDatabase` with `appDatabaseProvider`; schema v2; do NOT bump version
- Drift schema version is **2** (Story 1.9 added `student_subjects` in v2); no schema changes in this story

### TaskDao Join Query — Implementation Reference

```dart
// lib/core/database/daos/task_dao.dart

// Add to @DriftAccessor annotation:
@DriftAccessor(tables: [LessonTasksTable, SyncQueueTable, LessonsTable, TopicsTable])

// Plain Dart class — not generated, placed at top of file before TaskDao:
class BacklogRow {
  const BacklogRow({
    required this.task,
    required this.lesson,
    required this.topic,
  });

  final LessonTasksTableData task;
  final LessonsTableData lesson;
  final TopicsTableData topic;
}

// In TaskDao class — add after createLessonTasksForStudent:
Stream<List<BacklogRow>> watchBacklogTasks(
  String studentId, {
  String? contentTrack,
}) {
  Expression<bool> condition =
      lessonTasksTable.studentId.equals(studentId) &
      lessonTasksTable.taskStatus.equals(TaskStatus.backlog.toDbString());

  if (contentTrack != null) {
    condition = condition & lessonsTable.contentTrack.equals(contentTrack);
  }

  return (select(lessonTasksTable)
        .join([
          innerJoin(
            lessonsTable,
            lessonsTable.id.equalsExp(lessonTasksTable.lessonId),
          ),
          innerJoin(
            topicsTable,
            topicsTable.id.equalsExp(lessonsTable.topicId),
          ),
        ])
        ..where(condition)
        ..orderBy([
          OrderingTerm.asc(topicsTable.orderIndex),
          OrderingTerm.asc(lessonsTable.orderIndex),
        ]))
      .watch()
      .map(
        (rows) => rows
            .map(
              (r) => BacklogRow(
                task: r.readTable(lessonTasksTable),
                lesson: r.readTable(lessonsTable),
                topic: r.readTable(topicsTable),
              ),
            )
            .toList(),
      );
}
```

**IMPORTANT:** `LessonsTable` and `TopicsTable` must be added to the `import` block in `task_dao.dart`. After modifying `@DriftAccessor`, run `build_runner` — the `_$TaskDaoMixin` will include generated getters for the new tables.

### BacklogRepositoryImpl — Mapping Pattern

```dart
// lib/features/backlog/data/backlog_repository_impl.dart
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/task_dao.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_repository.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

class BacklogRepositoryImpl implements BacklogRepository {
  const BacklogRepositoryImpl(this._taskDao);

  final TaskDao _taskDao;

  @override
  Stream<List<BacklogItem>> watchBacklogTasks(
    String studentId, {
    String? contentTrack,
  }) {
    return _taskDao
        .watchBacklogTasks(studentId, contentTrack: contentTrack)
        .map(
          (rows) => rows
              .map(
                (r) => BacklogItem(
                  taskId: r.task.id,
                  lessonId: r.task.lessonId,
                  lessonTitle: r.lesson.title,
                  topicId: r.lesson.topicId,
                  topicTitle: r.topic.title,
                  contentTrack: r.lesson.contentTrack,
                  taskStatus: TaskStatusX.fromString(r.task.taskStatus),
                  curiosityCompleted: r.task.curiosityCompleted,
                  lessonOrderIndex: r.lesson.orderIndex,
                  topicOrderIndex: r.topic.orderIndex,
                ),
              )
              .toList(),
        );
  }
}
```

### `backlogRepositoryProvider` — Riverpod Pattern

```dart
// lib/features/backlog/data/backlog_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/features/backlog/data/backlog_repository_impl.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_repository.dart';

part 'backlog_provider.g.dart';

@riverpod
BacklogRepository backlogRepository(Ref ref) {
  return BacklogRepositoryImpl(ref.watch(appDatabaseProvider).taskDao);
}
```

**Riverpod 4.x note:** Generated provider name for `backlogRepository` function = `backlogRepositoryProvider`. No `Notifier` in the name (functions, not classes).

### `backlogItemsProvider` — Stream Provider with Params

```dart
// lib/features/backlog/presentation/backlog_items_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/backlog/data/backlog_provider.dart';

part 'backlog_items_provider.g.dart';

@riverpod
Stream<List<BacklogItem>> backlogItems(
  Ref ref, {
  required String studentId,
  String? contentTrack,
}) {
  return ref
      .read(backlogRepositoryProvider)
      .watchBacklogTasks(studentId, contentTrack: contentTrack);
}
```

**Generated provider usage in widget:**
```dart
final itemsAsync = ref.watch(
  backlogItemsProvider(studentId: studentId, contentTrack: _selectedTrack),
);
```

Note: In Riverpod 4.0 codegen, named params in a provider function create a family provider. The generated `backlogItemsProvider` takes named params `({required String studentId, String? contentTrack})`.

### `TaskCard` — Full Implementation Reference

```dart
// lib/features/backlog/presentation/widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.item, super.key});

  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = _borderColor(colorScheme, item.taskStatus);
    final icon = _stateIcon(item.taskStatus);
    final label = _stateLabel(item.taskStatus);

    return Semantics(
      label: '${item.lessonTitle}, $label, double-tap to see options',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          // TODO(story-2-3): implement tap → ModalBottomSheet with contextual actions
          onTap: null,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: borderColor, width: 4),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.lessonTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.topicTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: borderColor, size: 20),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: borderColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _borderColor(ColorScheme colorScheme, TaskStatus status) {
    return switch (status) {
      TaskStatus.backlog => colorScheme.taskBacklog,
      TaskStatus.todo => colorScheme.taskBacklog,
      TaskStatus.inProgress => colorScheme.taskInProgress,
      TaskStatus.done => colorScheme.taskDone,
    };
    // Note: Re-opened state maps from inProgress with a different icon — 
    // the TaskStatus enum does not have a 'reopened' value; 
    // re-opened is an inProgress task that failed a quiz (curiosityCompleted=false reset)
    // Story 2.3 will handle this rendering distinction
  }

  IconData _stateIcon(TaskStatus status) {
    return switch (status) {
      TaskStatus.backlog => Icons.access_time,
      TaskStatus.todo => Icons.arrow_forward,
      TaskStatus.inProgress => Icons.play_arrow,
      TaskStatus.done => Icons.check_circle,
    };
  }

  String _stateLabel(TaskStatus status) {
    return switch (status) {
      TaskStatus.backlog => 'Backlog',
      TaskStatus.todo => 'To-Do',
      TaskStatus.inProgress => 'In Progress',
      TaskStatus.done => 'Done',
    };
  }
}
```

**IMPORTANT NOTE on Re-opened state:** The UX spec defines 5 states including "Re-opened" (Dusty Rose + refresh icon). However, the `TaskStatus` enum has only 4 values: `backlog`, `todo`, `inProgress`, `done`. The "Re-opened" state is visually `inProgress` with a special rendering when `curiosityCompleted` was reset (by a failed quiz in Epic 4). For Story 2.2, render `inProgress` with the standard Golden Yellow play icon. Story 4.3 (quiz failure) introduces the "Re-opened" rendering logic using `task.curiosityCompleted` as a signal. Do NOT introduce a 5th enum value for this story.

### `BacklogScreen` — Implementation Reference

```dart
// lib/features/backlog/presentation/backlog_screen.dart
class BacklogScreen extends ConsumerStatefulWidget {
  const BacklogScreen({super.key});

  @override
  ConsumerState<BacklogScreen> createState() => _BacklogScreenState();
}

class _BacklogScreenState extends ConsumerState<BacklogScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _contentTracks = ['theory', 'past_papers', 'future_papers'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() => setState(() {});

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authValue = ref.watch(authProvider);
    final student = authValue.value?.mapOrNull(authenticated: (a) => a.student);

    if (student == null) return const SizedBox.shrink();

    final studentId = student.id;
    final selectedTrack = _contentTracks[_tabController.index];
    final itemsAsync = ref.watch(
      backlogItemsProvider(studentId: studentId, contentTrack: selectedTrack),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backlog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () => context.push('/profile'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Theory'),
            Tab(text: 'Past Papers'),
            Tab(text: 'Future Papers'),
          ],
        ),
      ),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                'Everything is in progress or done.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: items.length,
            itemBuilder: (_, index) => TaskCard(item: items[index]),
          );
        },
        loading: () => Column(
          children: List.generate(3, (_) => const SkeletonTaskCard()),
        ),
        error: (_, __) => Center(
          child: Text(
            'Failed to load tasks.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
```

### `appDatabaseProvider` — Access Pattern

```dart
// How to access TaskDao via appDatabaseProvider:
final taskDao = ref.watch(appDatabaseProvider).taskDao;
```

`appDatabaseProvider` is a `@Riverpod(keepAlive: true)` provider defined in `lib/core/database/app_database.dart` (or a database provider file). It provides the singleton `AppDatabase` instance. Access individual DAOs via their property accessors.

### `StudyBoardColors` — Color Token Usage

```dart
// In TaskCard._borderColor():
import 'package:studyboard_mobile/core/theme/app_colors.dart';

// Usage:
colorScheme.taskBacklog    // #8896A5 — Backlog + To-Do border
colorScheme.taskInProgress // #FFC107 — In Progress border
colorScheme.taskDone       // #4CAF78 — Done border
colorScheme.taskReopened   // #C4786A — Re-opened border (Story 4.3)
```

Never hardcode hex values inside widget files. Always use the `StudyBoardColors` extension.

### `router.dart` — AppBar Removal (Task 8)

Remove this block from `ScaffoldWithNavBar.build()`:
```dart
// REMOVE THIS:
appBar: AppBar(
  actions: [
    IconButton(
      icon: const Icon(Icons.person_outline),
      tooltip: 'Profile',
      onPressed: () => context.push('/profile'),
    ),
  ],
),
```

After removal, `ScaffoldWithNavBar.build()` returns a `Scaffold` with only `body: child` and `bottomNavigationBar: NavigationBar(...)`. Each tab screen owns its own AppBar.

### Build Runner — When to Run

Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` directory (not project root) after:
1. Task 1 — `@DriftAccessor` annotation changed on `TaskDao`
2. Task 2 — new `@freezed` annotation on `BacklogItem`
3. Task 3 — new `@riverpod` annotation on `backlogRepository`
4. Task 4 — new `@riverpod` annotation on `backlogItems`

You can batch all changes and run `build_runner` once at the end of Tasks 1–4.

### Testing Patterns

```dart
// test/core/database/task_dao_backlog_test.dart
void main() {
  late AppDatabase db;
  late TaskDao taskDao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    taskDao = db.taskDao;
  });
  tearDown(() async => db.close());

  group('watchBacklogTasks', () {
    test('returns only backlog-status tasks with lesson and topic joins', () async {
      // Seed: subject → topic → lesson → lesson_task(backlog)
      await db.into(db.subjectsTable).insert(
        SubjectsTableCompanion.insert(id: 's1', name: 'A/L Chemistry'),
      );
      await db.into(db.topicsTable).insert(
        TopicsTableCompanion.insert(id: 't1', subjectId: 's1', title: 'Atomic Structure'),
      );
      await db.into(db.lessonsTable).insert(
        LessonsTableCompanion.insert(
          id: 'l1', topicId: 't1', title: 'Atomic Theory',
          contentText: 'text', contentTrack: 'theory',
        ),
      );
      await taskDao.createLessonTasksForStudent('student-1', ['l1']);

      final rows = await taskDao.watchBacklogTasks('student-1').first;
      expect(rows.length, 1);
      expect(rows.first.lesson.title, 'Atomic Theory');
      expect(rows.first.topic.title, 'Atomic Structure');
    });

    test('excludes tasks not in backlog status', () async {
      // Seed and promote task to todo
      // ... (setup) ...
      await taskDao.pullToTodo(taskId);
      final rows = await taskDao.watchBacklogTasks('student-1').first;
      expect(rows, isEmpty);
    });

    test('filters by contentTrack when provided', () async {
      // Seed theory + past_papers lessons
      // Watch theory only → only theory tasks returned
      final rows = await taskDao
          .watchBacklogTasks('student-1', contentTrack: 'theory')
          .first;
      // verify only theory lessons returned
    });

    test('emits new list when task status changes', () async {
      // Setup with 2 backlog tasks
      // Pull first to todo
      // Verify stream emits updated list with 1 item
    });
  });
}

// test/features/backlog/presentation/widgets/task_card_test.dart
void main() {
  testWidgets('renders backlog state correctly', (tester) async {
    final item = BacklogItem(
      taskId: 'tid', lessonId: 'lid', lessonTitle: 'Atomic Theory',
      topicId: 'tpid', topicTitle: 'Atomic Structure',
      contentTrack: 'theory', taskStatus: TaskStatus.backlog,
      curiosityCompleted: false, lessonOrderIndex: 1, topicOrderIndex: 1,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme, // or your theme builder
        home: Scaffold(body: TaskCard(item: item)),
      ),
    );
    expect(find.text('Atomic Theory'), findsOneWidget);
    expect(find.text('Atomic Structure'), findsOneWidget);
    expect(find.byIcon(Icons.access_time), findsOneWidget);
    expect(find.text('Backlog'), findsOneWidget);
  });
}
```

### Architecture Compliance Checklist

- [ ] `BacklogRepositoryImpl` does NOT extend `RepositoryBase` — this is a pure Drift read with no Supabase calls; `RepositoryBase` is for Supabase-backed repos only
- [ ] `TaskDao.watchBacklogTasks()` — reads from Drift only; NO Supabase calls inside DAOs
- [ ] `backlogRepositoryProvider` — registered via `@riverpod` annotation; uses `ref.watch(appDatabaseProvider)` not `ref.watch(appDatabaseProvider.notifier)`
- [ ] `StudyBoardColors` extension used for ALL color values in `TaskCard` — no hardcoded hex values
- [ ] `TaskStatus` enum used for ALL status comparisons — no raw string comparisons (`== 'backlog'`)
- [ ] `TaskStatusX.fromString()` used to convert Drift string → enum in repository
- [ ] `very_good_analysis`: all imports use `package:` prefix — no relative imports in `lib/`
- [ ] `sort_constructors_first` lint: in `BacklogItem`, constructor before field declarations
- [ ] `build_runner` run after EVERY `@DriftAccessor`, `@freezed`, or `@riverpod` annotation change
- [ ] `flutter analyze` → 0 issues; `flutter test` → all pass before marking done
- [ ] `AppDatabase.schemaVersion` stays at **2** — no schema changes in this story

### Anti-Patterns to Avoid

- ❌ Importing `LessonsTable` or `TopicsTable` in `task_dao.dart` without adding them to `@DriftAccessor` — Drift accessors only expose tables listed in the annotation
- ❌ Using `db.contentDao.getAllLessons()` + separate task lookup instead of the join query — O(n) round-trips; use the single `watchBacklogTasks()` join
- ❌ Calling `Supabase.instance.client` anywhere in this story — all data is from Drift local cache
- ❌ Centered `CircularProgressIndicator` for loading state — use 3 `SkeletonTaskCard` widgets instead
- ❌ Hardcoded hex color strings (`Color(0xFF8896A5)`) inside `task_card.dart` — always use `colorScheme.taskBacklog`
- ❌ Adding a 5th `TaskStatus` enum value for "Re-opened" — handle with `curiosityCompleted` flag in Epic 4 (Story 4.3)
- ❌ Using `insertOnConflictUpdate` for `LessonTasksTable` in any new code — existing `createLessonTasksForStudent` uses `insertOrIgnore` (correct); preserve this pattern
- ❌ Removing the `NavigationBar` from `ScaffoldWithNavBar` — only the `AppBar` is removed in Task 8
- ❌ Adding navigation logic (`pullToTodo`) in TaskCard tap — that is Story 2.3's scope
- ❌ Using `relative imports` (`../domain/backlog_item.dart`) — use `package:studyboard_mobile/features/backlog/domain/backlog_item.dart`

### Project Structure — Files This Story Creates

**Create:**
```
lib/features/backlog/domain/backlog_item.dart
lib/features/backlog/domain/backlog_item.freezed.dart  (generated)
lib/features/backlog/domain/backlog_item.g.dart        (generated)
lib/features/backlog/domain/backlog_repository.dart
lib/features/backlog/data/backlog_repository_impl.dart
lib/features/backlog/data/backlog_provider.dart
lib/features/backlog/data/backlog_provider.g.dart      (generated)
lib/features/backlog/presentation/backlog_items_provider.dart
lib/features/backlog/presentation/backlog_items_provider.g.dart  (generated)
lib/features/backlog/presentation/widgets/task_card.dart
lib/features/backlog/presentation/widgets/skeleton_task_card.dart
test/core/database/task_dao_backlog_test.dart
test/features/backlog/presentation/widgets/task_card_test.dart
```

**Modify:**
```
lib/core/database/daos/task_dao.dart          # Add LessonsTable/TopicsTable to @DriftAccessor + watchBacklogTasks
lib/core/database/daos/task_dao.g.dart        # Regenerated
lib/features/backlog/presentation/backlog_screen.dart  # Full implementation (was stub)
lib/router.dart                                # Remove AppBar from ScaffoldWithNavBar
```

**Do NOT modify:**
- `lib/core/database/app_database.dart` — no new DAOs, schema version stays at 2
- `lib/features/board/domain/task_status.dart` or `task.dart` — no changes
- `lib/core/database/daos/content_dao.dart` — no changes
- Any existing `*.freezed.dart` or `*.g.dart` files (except those regenerated by build_runner)
- `lib/features/board/presentation/content_sync_notifier.dart` — no changes
- `lib/router.dart` ShellRoute or GoRoute entries — only the `appBar` inside `ScaffoldWithNavBar.build()` is removed

### Story 2.1 Learnings Carried Forward

- **`authProvider`** (not `authNotifierProvider`) — Riverpod 4.x strips `Notifier` suffix
- **`state.value?.mapOrNull(authenticated: (a) => a.student)`** — correct pattern to extract student
- **`very_good_analysis`** — `package:` imports everywhere, no relative imports
- **`sort_constructors_first` lint** — constructors before field declarations
- **`dart run build_runner build --delete-conflicting-outputs`** — from `studyboard_mobile/` always
- **Dart closure type promotion** — extract `final studentId = student.id;` before closures to get non-nullable type
- **`one_member_abstracts` lint** — single-method abstract interfaces may need `// ignore: one_member_abstracts` with a doc comment
- **`contentSyncProvider`** (not `contentSyncNotifierProvider`) — class `ContentSyncNotifier` → provider `contentSyncProvider`
- **`appDatabaseProvider`** — access `ref.watch(appDatabaseProvider).taskDao` (not `.taskDaoProvider`)

### Epic 1 Retro Carry-Forward (Addressed in This Story)

- **T1: Remove AppBar from `ScaffoldWithNavBar`** — HIGH priority, addressed in Task 8. Epic 2 screens own their AppBars.

### References

- [Source: epics.md#Story 2.2] — Acceptance criteria, TaskCard five states, content track filter, skeleton/empty states
- [Source: epics.md#Epic 2] — "TaskCard custom component, Kanban board UI, skeleton loaders, empty states"
- [Source: ux-design-specification.md#TaskCard] — Anatomy, states, Compact/Standard variants, semantics spec
- [Source: ux-design-specification.md#Color System] — Serene Scholar palette tokens for task states
- [Source: ux-design-specification.md#Empty States] — "Everything is in progress or done." (no CTA)
- [Source: ux-design-specification.md#Loading States] — "3 skeleton TaskCard placeholders, grey shimmer, same height"
- [Source: ux-design-specification.md#UX-DR5] — TaskCard left-border, breadcrumb, icon+color+label requirement
- [Source: ux-design-specification.md#UX-DR17] — Skeleton loading spec
- [Source: architecture.md#Feature Folder Structure] — `features/board/presentation/widgets/task_card.dart` noted in architecture; this story places it under `features/backlog/` for pragmatic ownership; Story 2.3 imports from there
- [Source: architecture.md#Naming Patterns] — `BacklogRepository`, `BacklogRepositoryImpl`, `backlogRepositoryProvider`
- [Source: epic-1-retro-2026-04-26.md#Technical Debt] — T1: Remove AppBar from ScaffoldWithNavBar (high priority, due this story)
- [Source: 2-1-chemistry-syllabus-content-seeding.md#Dev Notes] — `authProvider` pattern, `appDatabaseProvider`, build_runner commands, `very_good_analysis` rules

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- `backlog_screen.dart` needed `auth_state.dart` import for `mapOrNull` to resolve — same pattern as `profile_screen.dart`
- `SkeletonTaskCard.initState()` — `AnimationController.repeat()` returns a Future; used `unawaited()` from `dart:async` to satisfy the lint
- `TaskCard.onTap: null` — `avoid_redundant_argument_values` suppressed with inline ignore; null is intentional placeholder for Story 2.3

### Completion Notes List

- ✅ Task 1: `BacklogRow` class + `watchBacklogTasks()` join query added to `TaskDao`; `LessonsTable`/`TopicsTable` added to `@DriftAccessor`
- ✅ Task 2: `BacklogItem` freezed domain model created (no JSON serialization — pure Drift read)
- ✅ Task 3: `BacklogRepository` interface, `BacklogRepositoryImpl`, and `backlogRepositoryProvider` created
- ✅ Task 4: `backlogItemsProvider` family stream provider created
- ✅ Build runner run once for all Tasks 1–4 codegen (108 outputs)
- ✅ Task 5: `TaskCard` widget with 4dp left border, title, topic breadcrumb, state icon+label, semantics, InkWell touch target
- ✅ Task 6: `SkeletonTaskCard` shimmer with 72dp height, animated opacity 0.3→0.7
- ✅ Task 7: `BacklogScreen` full implementation — `ConsumerStatefulWidget`, `TabController` (3 tabs), stream watch, loading/empty/error states
- ✅ Task 8: Removed `AppBar` from `ScaffoldWithNavBar` in `router.dart` (Epic 1 tech debt)
- ✅ Task 9: 6 DAO tests (join, filter, stream reactivity, ordering) + 7 widget tests (all 4 states, semantics, border)
- ✅ `flutter test` → 126/126 pass; `flutter analyze` → No issues found

### File List

**Created:**
- `lib/features/backlog/domain/backlog_item.dart`
- `lib/features/backlog/domain/backlog_item.freezed.dart` (generated)
- `lib/features/backlog/domain/backlog_repository.dart`
- `lib/features/backlog/data/backlog_repository_impl.dart`
- `lib/features/backlog/data/backlog_provider.dart`
- `lib/features/backlog/data/backlog_provider.g.dart` (generated)
- `lib/features/backlog/presentation/backlog_items_provider.dart`
- `lib/features/backlog/presentation/backlog_items_provider.g.dart` (generated)
- `lib/features/backlog/presentation/widgets/task_card.dart`
- `lib/features/backlog/presentation/widgets/skeleton_task_card.dart`
- `test/core/database/task_dao_backlog_test.dart`
- `test/features/backlog/presentation/widgets/task_card_test.dart`

**Modified:**
- `lib/core/database/daos/task_dao.dart` — `BacklogRow` class + `watchBacklogTasks()`; `LessonsTable`/`TopicsTable` added to `@DriftAccessor`
- `lib/core/database/daos/task_dao.g.dart` (regenerated)
- `lib/features/backlog/presentation/backlog_screen.dart` — full replacement of stub
- `lib/router.dart` — removed `AppBar` from `ScaffoldWithNavBar`

### Change Log

- 2026-04-28: Story 2.2 implemented — Backlog screen with full syllabus display, TaskCard component (4 states, left-border, semantics), SkeletonTaskCard shimmer, content track tab filter, empty state. Removed AppBar from ScaffoldWithNavBar (Epic 1 tech debt). 126 tests pass, 0 analyzer issues.

### Review Findings

- [x] [Review][Patch] Semantics label: drop "double-tap to see options" while `onTap` is null — change to `"[lessonTitle], [label]"`; restore full AC7 label in Story 2.3 when bottom sheet is implemented [`task_card.dart:19`]
- [x] [Review][Patch] `ref.read` → `ref.watch` in `backlogItemsProvider` — `ref.read` snapshots the repository once and never resubscribes; breaks reactivity if `backlogRepositoryProvider` is invalidated (auth change, test override) [`backlog_items_provider.dart:13`]
- [x] [Review][Patch] Auth error state returns `null` in router redirect — user remains on a protected route when `authValue.hasError` instead of being redirected to `/login` [`router.dart:29`]
- [x] [Review][Patch] Empty state message wrong for Future Papers with no content — shows "Everything is in progress or done." when the track simply has no lessons seeded; AC4 requires a distinct empty-content state for this case [`backlog_screen.dart:74`]
- [x] [Review][Patch] Auth loading shows blank `SizedBox.shrink()` — when `authProvider` briefly enters `AsyncLoading`, `student == null` triggers invisible blank screen instead of a loading indicator [`backlog_screen.dart:44`]
- [x] [Review][Patch] Tab listener fires on every animation tick — `_onTabChanged` calls `setState` unconditionally during swipe animations; guard with `if (_tabController.indexIsChanging) return;` [`backlog_screen.dart:29`]
- [x] [Review][Patch] Loading skeleton `Column` can overflow on small screens — not scrollable; `data` branch uses `ListView.builder` but `loading` branch uses a plain `Column` [`backlog_screen.dart:88`]
- [x] [Review][Patch] Border test only asserts `border isNotNull` — does not verify 4dp width or color correctness; AC2 requires both [`task_card_test.dart:79`]
- [x] [Review][Defer] `TaskStatusX.fromString` throws `ArgumentError` for unknown status strings — pre-existing from Story 1.1, already tracked in deferred-work.md; not triggered by this story's query (filters to `backlog` only) [`task_status.dart`] — deferred, pre-existing
- [x] [Review][Defer] Re-opened state in `TaskCard` — Story 4.3 explicit scope; `TaskStatus` enum intentionally has no `reopened` value per story spec [`task_card.dart`] — deferred, pre-existing
- [x] [Review][Defer] `_RouterNotifier` lifecycle depends on `goRouterProvider` never being disposed — theoretical risk; standard GoRouter+Riverpod pattern, mitigated by `ref.onDispose(notifier.dispose)` [`router.dart:15`] — deferred, pre-existing
- [x] [Review][Defer] `BacklogRow` public struct in `task_dao.dart` — spec-defined placement; data/domain boundary opinion, not a bug [`task_dao.dart:14`] — deferred, pre-existing
- [x] [Review][Defer] `watchBacklogTasks` condition variable mixes `lessonTasksTable` and `lessonsTable` columns in one `var condition` — correct SQL, maintenance readability opinion [`task_dao.dart:180`] — deferred, pre-existing
- [x] [Review][Defer] No subject-enrollment guard in `watchBacklogTasks` join query — gates on `createLessonTasksForStudent` seeding; out of scope for this story, Story 2.1 data concern [`task_dao.dart:185`] — deferred, pre-existing
- [x] [Review][Defer] `BacklogItem.lessonOrderIndex` and `topicOrderIndex` fields not consumed by UI — spec-defined, present for future client-side sort or testing; not dead weight [`backlog_item.dart`] — deferred, pre-existing
- [x] [Review][Defer] Error state silently swallows Drift stream errors — no logging, no retry; Drift stream errors are rare; error recovery out of scope [`backlog_screen.dart:94`] — deferred, pre-existing
- [x] [Review][Defer] `contentSyncProvider` no-op `ref.listen` can trigger re-sync on `ScaffoldWithNavBar` remount — established pattern from prior story; shell rarely unmounts mid-session [`router.dart:112`] — deferred, pre-existing
- [x] [Review][Defer] Onboarding redirect checks `district.isEmpty` only — fragile proxy; `school` not checked; out of scope for Story 2.2 [`router.dart:49`] — deferred, pre-existing
