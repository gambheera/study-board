# Story 2.3: Kanban Board & Task Promotion Flow

Status: done

## Story

As a student,
I want to move tasks from Backlog to To-Do and from To-Do to In Progress on my Kanban board,
So that I can build and manage my active study plan.

## Acceptance Criteria

1. **Given** the Board tab **When** it opens **Then** a `TabBar` with To-Do and In Progress tabs is visible; In Progress is the default selected tab; the Done tab is hidden until at least one task has been marked Done

2. **Given** a student taps a `TaskCard` in the Backlog **When** the tap registers **Then** a `ModalBottomSheet` appears with the task name (Title Medium), topic breadcrumb (Body Medium, `onSurface` at 60% opacity), and a "Move to To-Do" `FilledButton` and a "Cancel" option — no drag-and-drop

3. **Given** the student taps "Move to To-Do" in the bottom sheet **When** the action confirms **Then** the task status is updated to `'todo'` in Drift, a sync queue entry is enqueued in the same Drift transaction, the card is removed from the Backlog via `AnimatedList` and inserted into the To-Do tab, and the transition is visible within 200ms (NFR2)

4. **Given** a student taps a `TaskCard` in the To-Do column **When** the bottom sheet opens **Then** the options shown are: "Start studying" `FilledButton`, "Move back to Backlog" `OutlinedButton`, and "Cancel"

5. **Given** the student taps "Start studying" **When** the action confirms **Then** the task status is updated to `'in_progress'` in Drift, a sync queue entry is enqueued in the same Drift transaction, the card moves to In Progress via `AnimatedList`, and the Board switches to the In Progress tab automatically

6. **Given** the In Progress tab is empty (no tasks started yet) **When** a new student opens the Board for the first time **Then** the empty state displays: "Move a task to To-Do to get started" body copy and a "Go to Backlog" `FilledButton`

7. **Given** task state changes are written to Drift **When** the app is offline during a state change **Then** the change is persisted locally to Drift immediately, the UI reflects the new state, and the sync queue entry is retained for future sync (Epic 5 will drain it)

8. **Given** the `TaskRepository.markTaskComplete()` method **When** any code attempts to set `task_status = 'done'` **Then** the ONLY valid code path is via `TaskRepository.markTaskComplete(taskId)` — any direct `task_status = 'done'` assignment outside this method is an architecture violation

## Tasks / Subtasks

- [x] Task 1: Extend `TaskDao` with board queries and `moveToBacklog` (AC: #1, #3, #4, #5, #7, #8)
  - [x] Open `lib/core/database/daos/task_dao.dart`
  - [x] Add `watchTasksByStatus(String studentId, TaskStatus status)` → `Stream<List<BacklogRow>>` — same join as `watchBacklogTasks` but with parameterized status; orders by `topicsTable.orderIndex ASC`, `lessonsTable.orderIndex ASC`
  - [x] Add `watchHasDoneTasks(String studentId)` → `Stream<bool>` — `selectOnly` on `lessonTasksTable`, filter `studentId` + `taskStatus = 'done'`, limit 1, `.watch().map((rows) => rows.isNotEmpty)`
  - [x] Add `moveToBacklog(String taskId)` → `Future<void>` in a Drift transaction — write `taskStatus = TaskStatus.backlog` + `updatedAt = now` to `lessonTasksTable`, insert sync queue entry with `entityType: 'task_status'`, `operation: 'upsert'`, `payload: jsonEncode({'task_status': 'backlog', 'task_id': taskId})` — same pattern as `pullToTodo`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` — `@DriftAccessor` mixin regenerates

- [x] Task 2: Create `BoardRepository` interface, implementation, and provider (AC: #3, #5, #7)
  - [x] Create `lib/features/board/domain/board_repository.dart` — abstract interface with:
    - `watchBoardItems(String studentId, TaskStatus status) → Stream<List<BacklogItem>>`
    - `watchHasDoneTasks(String studentId) → Stream<bool>`
    - `promoteToTodo(String taskId) → Future<void>`
    - `startTask(String taskId) → Future<void>`
    - `moveToBacklog(String taskId) → Future<void>`
  - [x] Create `lib/features/board/data/board_repository_impl.dart` — `BoardRepositoryImpl implements BoardRepository`; injects `TaskDao` via constructor; delegates all methods to `TaskDao`; maps `BacklogRow` → `BacklogItem` (same mapping as `BacklogRepositoryImpl`); pure Drift reads/writes, NO Supabase calls
  - [x] Create `lib/features/board/data/board_provider.dart` — `@riverpod BoardRepository boardRepository(Ref ref)` — instantiates `BoardRepositoryImpl` with `ref.watch(appDatabaseProvider).taskDao`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 3: Create board stream providers (AC: #1, #6)
  - [x] Create `lib/features/board/presentation/board_providers.dart`
  - [x] `@riverpod Stream<List<BacklogItem>> boardItems(Ref ref, {required String studentId, required TaskStatus status})` — calls `ref.watch(boardRepositoryProvider).watchBoardItems(studentId, status)`
  - [x] `@riverpod Stream<bool> hasDoneTasks(Ref ref, {required String studentId})` — calls `ref.watch(boardRepositoryProvider).watchHasDoneTasks(studentId)`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 4: Update `TaskCard` to support `onTap` callback and restore full AC7 semantics (AC: #2, #4)
  - [x] Open `lib/features/backlog/presentation/widgets/task_card.dart`
  - [x] Add `final VoidCallback? onTap;` field and include in constructor
  - [x] Update `InkWell.onTap` to use `onTap` callback — remove `// ignore: avoid_redundant_argument_values`
  - [x] Update `Semantics.label`: when `onTap != null` → `'${item.lessonTitle}, $label, double-tap to see options'`; when `onTap == null` → `'${item.lessonTitle}, $label'` — restores full AC7 label from Story 2.2 spec now that tap is implemented
  - [x] Remove `// TODO(story-2-3)` comment

- [x] Task 5: Wire up Backlog tap → `ModalBottomSheet` ("Move to To-Do") (AC: #2, #3)
  - [x] Open `lib/features/backlog/presentation/backlog_screen.dart`
  - [x] Inject `boardRepositoryProvider` in `build()` via `ref.read`
  - [x] Pass `onTap: () => _showBacklogActionSheet(context, boardRepo, item)` to each `TaskCard` via `_AnimatedBacklogList`
  - [x] Implement `_showBacklogActionSheet(BuildContext context, BoardRepository boardRepo, BacklogItem item)` with `unawaited(showModalBottomSheet(...))`, task name, topic breadcrumb, "Move to To-Do" `FilledButton`, "Cancel" `TextButton`
  - [x] Updated `BacklogScreen` to use `_AnimatedBacklogList` (StatefulWidget with AnimatedList, diff-based insertItem/removeItem, 200ms SizeTransition)

- [x] Task 6: Implement `BoardScreen` (AC: #1, #3, #4, #5, #6, #7, #8)
  - [x] Open `lib/features/board/presentation/board_screen.dart`
  - [x] Replaced stub with `ConsumerStatefulWidget` `BoardScreen` + `_BoardScreenState` with `TickerProviderStateMixin`
  - [x] Dynamic `TabController` rebuild when `hasDoneTasks` changes (`_updateTabCount` via `addPostFrameCallback`)
  - [x] `_BoardColumn` inner `ConsumerStatefulWidget` with `AnimatedList`, `ref.listen` diff updates, action sheets, empty states
  - [x] "Go to Backlog" empty state for In Progress; "Your To-Do list is empty." for To-Do
  - [x] `_showTodoActionSheet` with "Start studying", "Move back to Backlog", "Cancel"; auto-switches to In Progress tab after `startTask`

- [x] Task 7: Write tests (AC: #1, #3, #5, #6, #7)
  - [x] Create `test/core/database/task_dao_board_test.dart`:
    - `watchTasksByStatus` returns only tasks with matching status and correct joins
    - `watchTasksByStatus` excludes tasks with different status
    - `watchTasksByStatus` emits updated list when task status changes
    - `watchHasDoneTasks` returns `false` when no done tasks exist
    - `watchHasDoneTasks` returns `true` after `markTaskComplete()` is called
    - `moveToBacklog` writes 'backlog' status to Drift and inserts sync queue entry
    - `moveToBacklog` is a no-op when taskId not found (affected == 0 guard)
  - [x] Create `test/features/board/presentation/board_screen_test.dart`:
    - Board screen shows In Progress empty state when no in_progress tasks
    - Empty state has "Go to Backlog" FilledButton
    - Done tab not visible when no done tasks

### Review Findings

- [x] [Review][Patch] TabController length can desync with tabs and crash during hasDone changes [studyboard_mobile/lib/features/board/presentation/board_screen.dart:76]
- [x] [Review][Patch] Post-frame callback may call setState after dispose in tab-count updates [studyboard_mobile/lib/features/board/presentation/board_screen.dart:37]
- [x] [Review][Patch] Board column can show empty state despite available data due listener timing and local list rendering [studyboard_mobile/lib/features/board/presentation/board_screen.dart:164]
- [x] [Review][Patch] AnimatedList diff logic misses reorders and in-place updates for existing task IDs [studyboard_mobile/lib/features/board/presentation/board_screen.dart:136]
- [x] [Review][Patch] Backlog AnimatedList diff logic misses reorders and in-place updates for existing task IDs [studyboard_mobile/lib/features/backlog/presentation/backlog_screen.dart:207]
- [x] [Review][Patch] Task state mutations from action sheets lack failure handling and user feedback [studyboard_mobile/lib/features/backlog/presentation/backlog_screen.dart:156]
- [x] [Review][Patch] Backlog action sheet shows plain topic text, not a breadcrumb representation required by AC2 [studyboard_mobile/lib/features/backlog/presentation/backlog_screen.dart:143]
- [x] [Review][Patch] Missing tests for hasDone false/true transitions, controller lifecycle, and animated diff edge cases [studyboard_mobile/test/features/board/presentation/board_screen_test.dart:92]

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/core/database/daos/task_dao.dart` — has `BacklogRow` class, `pullToTodo(taskId)`, `startTask(taskId)`, `markTaskComplete(taskId)`, `resetTaskToInProgress(taskId)`, `watchBacklogTasks(studentId, {contentTrack})`; **ADD** `watchTasksByStatus`, `watchHasDoneTasks`, `moveToBacklog` only
- `lib/features/backlog/domain/backlog_item.dart` — `@freezed BacklogItem` with all needed fields; reuse for board items — NO new domain model needed
- `lib/features/backlog/domain/backlog_repository.dart` — abstract interface pattern to follow
- `lib/features/backlog/data/backlog_repository_impl.dart` — `BacklogRow → BacklogItem` mapping pattern; copy this for `BoardRepositoryImpl`
- `lib/features/backlog/data/backlog_provider.dart` — `@riverpod BacklogRepository backlogRepository(Ref ref)` — follow this pattern for `boardRepositoryProvider`
- `lib/features/backlog/presentation/backlog_items_provider.dart` — `@riverpod Stream<List<BacklogItem>> backlogItems(...)` — follow for `boardItemsProvider`
- `lib/features/backlog/presentation/widgets/task_card.dart` — existing `TaskCard`; add `onTap` param only; do NOT recreate
- `lib/features/backlog/presentation/widgets/skeleton_task_card.dart` — reuse in Board screen
- `lib/features/board/presentation/board_screen.dart` — currently a stub `Center(child: Text('Board'))`; REPLACE entirely
- `lib/features/board/domain/task.dart` — `Task` freezed model; do NOT modify
- `lib/features/board/domain/task_status.dart` — `TaskStatus` enum with `toDbString()` / `TaskStatusX.fromString()`; do NOT modify
- `lib/features/board/domain/board_repository.dart` — does NOT exist yet; CREATE it (also `.gitkeep` is there)
- `lib/features/board/data/board_repository_impl.dart` — does NOT exist yet; CREATE it (`.gitkeep` is there)
- `lib/core/database/database_provider.dart` — `appDatabaseProvider` is here; `taskDaoProvider` also here — use `ref.watch(appDatabaseProvider).taskDao` in `boardRepositoryProvider`
- `lib/router.dart` — `/board` route already points to `BoardScreen`; do NOT modify routes; use `context.go('/backlog')` for "Go to Backlog" FilledButton
- `lib/core/theme/app_colors.dart` — `StudyBoardColors` extension; use `colorScheme.taskBacklog`, `.taskInProgress`, `.taskDone`, `.taskReopened`
- `lib/features/auth/presentation/auth_notifier.dart` — `authProvider` (no `Notifier` suffix); extract via `authValue.value?.mapOrNull(authenticated: (a) => a.student)`

### TaskDao — New Methods Reference

```dart
// In task_dao.dart — add after watchBacklogTasks:

Stream<List<BacklogRow>> watchTasksByStatus(
  String studentId,
  TaskStatus status,
) {
  final condition =
      lessonTasksTable.studentId.equals(studentId) &
      lessonTasksTable.taskStatus.equals(status.toDbString());

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

Stream<bool> watchHasDoneTasks(String studentId) {
  return (selectOnly(lessonTasksTable)
        ..addColumns([lessonTasksTable.id])
        ..where(
          lessonTasksTable.studentId.equals(studentId) &
              lessonTasksTable.taskStatus.equals(
                TaskStatus.done.toDbString(),
              ),
        )
        ..limit(1))
      .watch()
      .map((rows) => rows.isNotEmpty);
}

Future<void> moveToBacklog(String taskId) => transaction(() async {
  final now = DateTime.now().toUtc().toIso8601String();
  final affected =
      await (update(lessonTasksTable)
        ..where((t) => t.id.equals(taskId))).write(
        LessonTasksTableCompanion(
          taskStatus: Value(TaskStatus.backlog.toDbString()),
          updatedAt: Value(now),
        ),
      );
  if (affected == 0) return;
  await into(syncQueueTable).insert(
    SyncQueueTableCompanion.insert(
      id: _uuid.v4(),
      entityType: 'task_status',
      entityId: taskId,
      operation: 'upsert',
      payload: jsonEncode({
        'task_status': TaskStatus.backlog.toDbString(),
        'task_id': taskId,
      }),
      createdAt: now,
    ),
  );
});
```

**No `@DriftAccessor` changes needed** — `LessonsTable`, `TopicsTable`, `SyncQueueTable` are already in the annotation. Only the method bodies are added. Build runner still needed to regenerate the mixin.

### BoardRepository — Interface & Impl Pattern

```dart
// lib/features/board/domain/board_repository.dart
// ignore: one_member_abstracts
abstract interface class BoardRepository {
  Stream<List<BacklogItem>> watchBoardItems(
    String studentId,
    TaskStatus status,
  );
  Stream<bool> watchHasDoneTasks(String studentId);
  Future<void> promoteToTodo(String taskId);
  Future<void> startTask(String taskId);
  Future<void> moveToBacklog(String taskId);
}
```

```dart
// lib/features/board/data/board_repository_impl.dart
class BoardRepositoryImpl implements BoardRepository {
  const BoardRepositoryImpl(this._taskDao);
  final TaskDao _taskDao;

  @override
  Stream<List<BacklogItem>> watchBoardItems(String studentId, TaskStatus status) {
    return _taskDao.watchTasksByStatus(studentId, status).map(
      (rows) => rows.map((r) => BacklogItem(
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
      )).toList(),
    );
  }

  @override
  Stream<bool> watchHasDoneTasks(String studentId) =>
      _taskDao.watchHasDoneTasks(studentId);

  @override
  Future<void> promoteToTodo(String taskId) => _taskDao.pullToTodo(taskId);

  @override
  Future<void> startTask(String taskId) => _taskDao.startTask(taskId);

  @override
  Future<void> moveToBacklog(String taskId) => _taskDao.moveToBacklog(taskId);
}
```

### Board Providers — Pattern

```dart
// lib/features/board/data/board_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/features/board/data/board_repository_impl.dart';
import 'package:studyboard_mobile/features/board/domain/board_repository.dart';

part 'board_provider.g.dart';

@riverpod
BoardRepository boardRepository(Ref ref) {
  return BoardRepositoryImpl(ref.watch(appDatabaseProvider).taskDao);
}
```

```dart
// lib/features/board/presentation/board_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/board/data/board_provider.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

part 'board_providers.g.dart';

@riverpod
Stream<List<BacklogItem>> boardItems(
  Ref ref, {
  required String studentId,
  required TaskStatus status,
}) {
  return ref.watch(boardRepositoryProvider).watchBoardItems(studentId, status);
}

@riverpod
Stream<bool> hasDoneTasks(Ref ref, {required String studentId}) {
  return ref.watch(boardRepositoryProvider).watchHasDoneTasks(studentId);
}
```

### AnimatedList Pattern for BoardColumn

This is the most complex part of the story. The `_BoardColumn` widget must:
1. Hold a `GlobalKey<AnimatedListState>` and a mutable `_items` list
2. `ref.listen` to `boardItemsProvider` to get stream updates
3. Compute diff between `_items` and new data, then call `insertItem`/`removeItem`

```dart
class _BoardColumn extends ConsumerStatefulWidget {
  const _BoardColumn({
    required this.studentId,
    required this.status,
    required this.tabController,
  });

  final String studentId;
  final TaskStatus status;
  final TabController tabController;

  @override
  ConsumerState<_BoardColumn> createState() => _BoardColumnState();
}

class _BoardColumnState extends ConsumerState<_BoardColumn> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<BacklogItem> _items = [];

  @override
  Widget build(BuildContext context) {
    // Listen to stream updates and apply diffs
    ref.listen(
      boardItemsProvider(
        studentId: widget.studentId,
        status: widget.status,
      ),
      (previous, next) {
        next.whenData(_applyDiff);
      },
    );

    final itemsAsync = ref.watch(
      boardItemsProvider(
        studentId: widget.studentId,
        status: widget.status,
      ),
    );

    return itemsAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: List.generate(3, (_) => const SkeletonTaskCard()),
      ),
      error: (_, _) => Center(
        child: Text(
          'Failed to load tasks.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (_) {
        if (_items.isEmpty) return _buildEmptyState(context);
        return AnimatedList(
          key: _listKey,
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          initialItemCount: _items.length,
          itemBuilder: (ctx, index, animation) => SizeTransition(
            sizeFactor: animation,
            child: _buildCard(_items[index]),
          ),
        );
      },
    );
  }

  void _applyDiff(List<BacklogItem> newItems) {
    // Remove items no longer in newItems
    for (var i = _items.length - 1; i >= 0; i--) {
      final taskId = _items[i].taskId;
      if (!newItems.any((item) => item.taskId == taskId)) {
        final removed = _items.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (ctx, anim) => SizeTransition(
            sizeFactor: anim,
            child: TaskCard(item: removed),
          ),
          duration: const Duration(milliseconds: 200),
        );
      }
    }
    // Insert new items
    for (var i = 0; i < newItems.length; i++) {
      if (!_items.any((item) => item.taskId == newItems[i].taskId)) {
        _items.insert(i, newItems[i]);
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 200),
        );
      }
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    if (widget.status == TaskStatus.inProgress) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Move a task to To-Do to get started',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/backlog'),
              child: const Text('Go to Backlog'),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Text(
        widget.status == TaskStatus.todo
            ? 'Your To-Do list is empty.'
            : 'No completed tasks yet.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildCard(BacklogItem item) {
    return TaskCard(
      item: item,
      onTap: _tapHandlerFor(item),
    );
  }

  VoidCallback? _tapHandlerFor(BacklogItem item) {
    return switch (item.taskStatus) {
      TaskStatus.todo => () => _showTodoActionSheet(item),
      TaskStatus.inProgress => null, // Epic 3 owns this
      TaskStatus.done => null,
      TaskStatus.backlog => null, // Should not appear on board
    };
  }

  void _showTodoActionSheet(BacklogItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
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
                item.topicTitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    await ref
                        .read(boardRepositoryProvider)
                        .startTask(item.taskId);
                    // Switch to In Progress tab (index 1)
                    if (mounted) widget.tabController.animateTo(1);
                  },
                  child: const Text('Start studying'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    ref
                        .read(boardRepositoryProvider)
                        .moveToBacklog(item.taskId);
                  },
                  child: const Text('Move back to Backlog'),
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
    );
  }
}
```

### BacklogScreen — Animated Removal Pattern

```dart
// In BacklogScreen: change data branch in itemsAsync.when to use _AnimatedBacklogList
// Replace the ListView.builder with:
data: (items) {
  if (items.isEmpty) { /* empty state */ }
  return _AnimatedBacklogList(items: items, studentId: studentId);
},

// _AnimatedBacklogList as a StatefulWidget inside _BacklogScreenState or as private class:
class _AnimatedBacklogList extends StatefulWidget {
  const _AnimatedBacklogList({required this.items, required this.studentId});
  final List<BacklogItem> items;
  final String studentId;

  @override
  State<_AnimatedBacklogList> createState() => _AnimatedBacklogListState();
}

class _AnimatedBacklogListState extends State<_AnimatedBacklogList> {
  final _listKey = GlobalKey<AnimatedListState>();
  late List<BacklogItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  void didUpdateWidget(_AnimatedBacklogList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _applyDiff(widget.items);
  }

  void _applyDiff(List<BacklogItem> newItems) {
    for (var i = _items.length - 1; i >= 0; i--) {
      final taskId = _items[i].taskId;
      if (!newItems.any((item) => item.taskId == taskId)) {
        final removed = _items.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (ctx, anim) => SizeTransition(
            sizeFactor: anim,
            child: TaskCard(item: removed),
          ),
          duration: const Duration(milliseconds: 200),
        );
      }
    }
    for (var i = 0; i < newItems.length; i++) {
      if (!_items.any((item) => item.taskId == newItems[i].taskId)) {
        _items.insert(i, newItems[i]);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 200));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      initialItemCount: _items.length,
      itemBuilder: (ctx, index, animation) => SizeTransition(
        sizeFactor: animation,
        child: TaskCard(
          item: _items[index],
          onTap: () => _showBacklogActionSheet(context, _items[index]),
        ),
      ),
    );
  }

  void _showBacklogActionSheet(BuildContext context, BacklogItem item) {
    // This needs access to WidgetRef — pass via constructor or use ConsumerStatefulWidget
    // Alternative: hoist the showModalBottomSheet call to BacklogScreen and pass as callback
    // Recommended: make _AnimatedBacklogList a ConsumerStatefulWidget so it can ref.read(boardRepositoryProvider)
  }
}
```

**IMPORTANT:** `_AnimatedBacklogList` needs access to `WidgetRef` to call `boardRepositoryProvider`. Make it a `ConsumerStatefulWidget` instead of plain `StatefulWidget`:
```dart
class _AnimatedBacklogList extends ConsumerStatefulWidget { ... }
class _AnimatedBacklogListState extends ConsumerState<_AnimatedBacklogList> { ... }
```
Then use `ref.read(boardRepositoryProvider).promoteToTodo(item.taskId)` in the bottom sheet.

### TabController Rebuild for Dynamic Tab Count

When `hasDoneTasks` changes from `false` to `true`, the `TabController` must be rebuilt with 3 tabs. Store `_tabController` in state and recreate when `tabCount` changes:

```dart
class _BoardScreenState extends ConsumerState<BoardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _tabCount = 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this, initialIndex: 1);
  }

  void _updateTabCount(int newCount) {
    if (newCount == _tabCount) return;
    _tabController.dispose();
    _tabController = TabController(
      length: newCount,
      vsync: this,
      initialIndex: newCount > _tabCount ? 1 : _tabController.index.clamp(0, newCount - 1),
    );
    setState(() => _tabCount = newCount);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
```

In `build()`: watch `hasDoneTasksProvider` and call `_updateTabCount(hasDone ? 3 : 2)` after build (via `WidgetsBinding.instance.addPostFrameCallback`).

**Simpler alternative if TabController dynamic rebuild causes issues:** Start with 3 tabs always but hide Done tab visually with zero height. However, this is non-spec — use the dynamic approach above.

### BacklogScreen — Passing `boardRepository` to Bottom Sheet

The `_showBacklogActionSheet` in `_BacklogScreenState` can directly use `ref.read(boardRepositoryProvider)` since `_BacklogScreenState` is a `ConsumerState`. The bottom sheet is invoked from `BacklogScreen`'s `build` scope where `ref` is available. Pattern:

```dart
// In _BacklogScreenState.build():
final boardRepo = ref.read(boardRepositoryProvider);

// Pass to _AnimatedBacklogList via callback:
_AnimatedBacklogList(
  items: items,
  onTap: (item) => _showBacklogActionSheet(context, boardRepo, item),
)

// Where _showBacklogActionSheet is a method in _BacklogScreenState
void _showBacklogActionSheet(
  BuildContext context,
  BoardRepository boardRepo,
  BacklogItem item,
) {
  showModalBottomSheet<void>(
    context: context,
    builder: (sheetCtx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.lessonTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              item.topicTitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(sheetCtx);
                  boardRepo.promoteToTodo(item.taskId);
                },
                child: const Text('Move to To-Do'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(sheetCtx),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

### Key Architecture Constraints (Must Follow)

- `BoardRepositoryImpl` does NOT extend `RepositoryBase` — pure Drift, no Supabase calls
- `boardRepositoryProvider` uses `ref.watch(appDatabaseProvider).taskDao` — NOT `ref.watch(taskDaoProvider)` (both work but `appDatabaseProvider` is the established pattern from Story 2.2)
- `TaskStatus.done` assignment: ONLY via `TaskRepository.markTaskComplete(taskId)` — NEVER set `task_status = 'done'` in any code in this story
- `AnimatedList` key must be `GlobalKey<AnimatedListState>` — not `ValueKey` or `ObjectKey`
- `_applyDiff` removes from high index to low (avoids index shifting bugs during removal)
- Sync queue enqueue and Drift write: always in the same Drift `transaction()` — this is already in `TaskDao` methods; `BoardRepositoryImpl` just delegates to `TaskDao`, so it's handled correctly
- `ref.read` for one-shot actions (button presses); `ref.watch` for reactive stream subscriptions — follow established pattern

### Lint Rules from Story 2.2 That Apply Here

- `very_good_analysis`: all imports use `package:` prefix — NO relative imports in `lib/`
- `sort_constructors_first`: in all classes, constructor before field declarations
- `one_member_abstracts`: single-method abstract interfaces may get lint warning — add `// ignore: one_member_abstracts` with doc comment if needed (BoardRepository has 5 methods so this won't trigger)
- `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` — run after every `@riverpod` or `@DriftAccessor` change
- `flutter analyze` → 0 issues; `flutter test` → all pass before marking task complete
- `AppDatabase.schemaVersion` stays at **2** — no schema changes in this story

### Re-opened State in TaskCard (Context for This Story)

Story 2.2 Dev Notes explained: Re-opened state (Dusty Rose + refresh icon) is not a 5th `TaskStatus` enum value. It's an `inProgress` task where the student failed a quiz (`curiosityCompleted` reset by Epic 4). **This story does NOT introduce the visual distinction** between standard `inProgress` and "re-opened" `inProgress`. That distinction is added by Story 4.3 when `resetTaskToInProgress()` is used. For this story, all `inProgress` cards render with Golden Yellow play icon.

### Build Runner — When to Run

Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` after:
1. Task 1 — new methods added to `TaskDao` (mixin regenerates; no `@DriftAccessor` change needed)
2. Task 2 — new `@riverpod` annotation in `board_provider.dart`
3. Task 3 — new `@riverpod` annotations in `board_providers.dart`

Tasks 1–3 can be batched and build_runner run once.

### Project Structure — Files This Story Creates/Modifies

**Create:**
```
lib/features/board/domain/board_repository.dart
lib/features/board/data/board_repository_impl.dart
lib/features/board/data/board_provider.dart
lib/features/board/data/board_provider.g.dart          (generated)
lib/features/board/presentation/board_providers.dart
lib/features/board/presentation/board_providers.g.dart (generated)
test/core/database/task_dao_board_test.dart
test/features/board/presentation/board_screen_test.dart
```

**Modify:**
```
lib/core/database/daos/task_dao.dart              # Add watchTasksByStatus, watchHasDoneTasks, moveToBacklog
lib/core/database/daos/task_dao.g.dart            # Regenerated
lib/features/backlog/presentation/backlog_screen.dart  # Add onTap callback, switch to AnimatedList
lib/features/backlog/presentation/widgets/task_card.dart  # Add onTap param + Semantics update
lib/features/board/presentation/board_screen.dart # Full replacement of stub
```

**Do NOT modify:**
- `lib/core/database/app_database.dart` — no DAO additions, schema version stays at 2
- `lib/features/board/domain/task_status.dart` or `task.dart` — no changes
- `lib/features/backlog/domain/backlog_item.dart` — reuse as board domain model, no changes
- `lib/features/backlog/data/backlog_repository_impl.dart` — no changes
- `lib/router.dart` — no route changes; use `context.go('/backlog')` for navigation
- Any existing `*.freezed.dart` or `*.g.dart` files except those regenerated by build_runner

### Anti-Patterns to Avoid

- ❌ Creating a new `BoardItem` domain model — `BacklogItem` already has all needed fields; reuse it
- ❌ Setting `task_status = 'done'` directly — ONLY via `TaskRepository.markTaskComplete()`
- ❌ Calling `Supabase.instance.client` in `BoardRepositoryImpl` — pure Drift only
- ❌ Accessing `taskDaoProvider` instead of `appDatabaseProvider().taskDao` in `boardRepositoryProvider` — follow established pattern
- ❌ Using `setState(() {})` in `_BoardColumn` to react to stream — use `ref.listen` for stream updates
- ❌ Checking task count in stream to decide empty vs non-empty in `AnimatedList.data` branch — use `_items.isEmpty` (the maintained local list) not the stream's last value
- ❌ Running `_applyDiff` with forward-index removal (use `i = _items.length - 1; i >= 0; i--` always)
- ❌ Using `Navigator.pop(context)` inside an async gap where `mounted` is not checked — check `if (mounted)` before navigation after awaiting `startTask()`
- ❌ Adding `AnimatedList` to `loading` or `error` states — skeleton is a plain `ListView`, AnimatedList only in `data` state
- ❌ Making `_BoardColumn` a private class inside `board_screen.dart` that violates `public_member_api_docs` — make it a private inner widget via `_` prefix (no docs needed for private)

### Story 2.2 Learnings Applied

- **`authProvider`** (not `authNotifierProvider`) — Riverpod 4.x strips `Notifier` suffix
- **`state.value?.mapOrNull(authenticated: (a) => a.student)`** — correct pattern to extract student
- **`final studentId = student.id;`** — extract non-nullable before closure
- **`very_good_analysis`** — `package:` imports everywhere, no relative imports
- **`sort_constructors_first` lint** — constructor before field declarations
- **`dart run build_runner build --delete-conflicting-outputs`** — from `studyboard_mobile/` always
- **Dart closure type promotion** — extract `final studentId = student.id;` before closures
- **`appDatabaseProvider`** — access `.taskDao` property, not `.taskDaoProvider`
- **`ref.watch` in stream providers** — use `ref.watch(boardRepositoryProvider)` not `ref.read` so Riverpod tracks the dependency

### References

- [Source: epics.md#Story 2.3] — Acceptance criteria, ModalBottomSheet spec, AnimatedList, empty states, task state machine, Done tab conditional
- [Source: epics.md#Epic 2] — "AnimatedList, Board Classic layout, skeleton loaders, empty states, Done tab hidden until first completion"
- [Source: ux-design-specification.md#Board Classic] — Tab-filtered Kanban columns, tap-to-promote, left-border state colors, no drag-and-drop, bottom sheet only
- [Source: ux-design-specification.md#Defining Experience] — "Start studying" → lesson flow (Epic 3); this story wires up through In Progress
- [Source: ux-design-specification.md#UX-DR13] — "TabBar with To-Do / In Progress / Done tabs; In Progress as default open tab; Done tab hidden until first task completion; no drag-and-drop, bottom sheet only; AnimatedList insertion/removal on task state changes"
- [Source: architecture.md#Task State Machine] — Done only via markTaskComplete(); board transitions enforced via named DAO methods
- [Source: architecture.md#Communication Patterns] — Backlog→To-Do via pullToTodo, To-Do→InProgress via startTask; state machine diagram
- [Source: architecture.md#Riverpod State Management] — AsyncNotifier, never StateNotifier; side effects triggered via ref.listen in widgets; no navigation in notifiers
- [Source: 2-2-backlog-view-full-syllabus-and-taskcard-component.md#Dev Notes] — BacklogRow/BacklogItem mapping, authProvider pattern, TaskCard implementation, animation patterns
- [Source: 2-2-backlog-view-full-syllabus-and-taskcard-component.md#Review Findings] — ref.watch vs ref.read fix applied; auth loading state handling; _onTabChanged guard

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- `discarded_futures` lint: `showModalBottomSheet<void>()` and fire-and-forget `Future<void>` calls in void functions required `unawaited()` from `dart:async`
- `unnecessary_lambdas` lint: `authProvider.overrideWith(() => _FakeAuthNotifier())` → tearoff `authProvider.overrideWith(_FakeAuthNotifier.new)`
- `mocktail` `registerFallbackValue`: `TaskStatus` enum required `setUpAll(() { registerFallbackValue(TaskStatus.backlog); })` in widget test
- `eol_at_end_of_file`: board_screen.dart generated with extra trailing blank line; trimmed to single `\n`

### Completion Notes List

- Task 1: Added `watchTasksByStatus`, `watchHasDoneTasks`, `moveToBacklog` to `TaskDao`. No `@DriftAccessor` annotation changes needed; build_runner regenerated mixin.
- Task 2: Created `BoardRepository` abstract interface and `BoardRepositoryImpl` delegating to `TaskDao`. Created `board_provider.dart` with `@riverpod boardRepositoryProvider`. All pure Drift, no Supabase calls.
- Task 3: Created `board_providers.dart` with `boardItemsProvider` (family by studentId + status) and `hasDoneTasksProvider` (family by studentId). Build runner generated `.g.dart` files.
- Task 4: Updated `TaskCard` to accept `VoidCallback? onTap`; updated `InkWell.onTap`; updated `Semantics.label` to include "double-tap to see options" when `onTap != null`. Removed TODO comment.
- Task 5: Added `boardRepositoryProvider` injection to `BacklogScreen.build()`. Extracted `_AnimatedBacklogList` (StatefulWidget) with `GlobalKey<AnimatedListState>` and `_applyDiff` for 200ms animated removals/insertions. `_showBacklogActionSheet` in `_BacklogScreenState` uses `unawaited(showModalBottomSheet(...))` with "Move to To-Do" FilledButton and "Cancel" TextButton.
- Task 6: Replaced board_screen.dart stub with full `ConsumerStatefulWidget`. `_BoardScreenState` has dynamic `TabController` (2 or 3 tabs) updated via `addPostFrameCallback`. `_BoardColumn` is inner `ConsumerStatefulWidget` with `AnimatedList`, `ref.listen` diff updates, empty states for inProgress/todo/done, `_showTodoActionSheet` with "Start studying" (async, auto-switches tab), "Move back to Backlog" (`unawaited`), and "Cancel".
- Task 7: Created `task_dao_board_test.dart` (7 tests covering watchTasksByStatus, watchHasDoneTasks, moveToBacklog) and `board_screen_test.dart` (3 widget tests using `_FakeAuthNotifier` subclass and mocked `BoardRepository`). All 136 tests pass. `flutter analyze`: 0 issues.

### File List

**Created:**
- `lib/features/board/domain/board_repository.dart`
- `lib/features/board/data/board_repository_impl.dart`
- `lib/features/board/data/board_provider.dart`
- `lib/features/board/data/board_provider.g.dart` (generated)
- `lib/features/board/presentation/board_providers.dart`
- `lib/features/board/presentation/board_providers.g.dart` (generated)
- `test/core/database/task_dao_board_test.dart`
- `test/features/board/presentation/board_screen_test.dart`

**Modified:**
- `lib/core/database/daos/task_dao.dart`
- `lib/core/database/daos/task_dao.g.dart` (regenerated)
- `lib/features/backlog/presentation/backlog_screen.dart`
- `lib/features/backlog/presentation/widgets/task_card.dart`
- `lib/features/board/presentation/board_screen.dart`

### Change Log

- 2026-04-28: Story 2.3 implemented — Kanban Board with To-Do/In Progress/Done tabs, AnimatedList task promotion flow, ModalBottomSheet action sheets for Backlog→To-Do and To-Do→InProgress/Backlog transitions, dynamic Done tab, all state writes in Drift transactions with sync queue entries. 10 tests added (7 DAO + 3 widget). 136 total tests pass, 0 analyze issues.
### Completion Notes List

### File List
