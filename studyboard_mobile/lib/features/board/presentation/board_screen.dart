import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/backlog/presentation/widgets/skeleton_task_card.dart';
import 'package:studyboard_mobile/features/backlog/presentation/widgets/task_card.dart';
import 'package:studyboard_mobile/features/board/data/board_provider.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';
import 'package:studyboard_mobile/features/board/presentation/board_providers.dart';

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key});

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _tabCount = 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: 1,
    );
  }

  void _syncTabController(int desiredCount) {
    if (desiredCount == _tabCount) return;
    final prevIndex = _tabController.index;
    _tabController.dispose();
    _tabController = TabController(
      length: desiredCount,
      vsync: this,
      initialIndex: prevIndex.clamp(0, desiredCount - 1),
    );
    _tabCount = desiredCount;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authValue = ref.watch(authProvider);

    if (authValue.isLoading) {
      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          children: List.generate(3, (_) => const SkeletonTaskCard()),
        ),
      );
    }

    final student = authValue.value?.mapOrNull(authenticated: (a) => a.student);
    if (student == null) return const SizedBox.shrink();

    final studentId = student.id;

    final hasDoneAsync = ref.watch(hasDoneTasksProvider(studentId: studentId));
    final hasDone = hasDoneAsync.value ?? false;
    final desiredTabCount = hasDone ? 3 : 2;
    _syncTabController(desiredTabCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Board'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: 'To-Do'),
            const Tab(text: 'In Progress'),
            if (hasDone) const Tab(text: 'Done'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BoardColumn(
            studentId: studentId,
            status: TaskStatus.todo,
            tabController: _tabController,
          ),
          _BoardColumn(
            studentId: studentId,
            status: TaskStatus.inProgress,
            tabController: _tabController,
          ),
          if (hasDone)
            _BoardColumn(
              studentId: studentId,
              status: TaskStatus.done,
              tabController: _tabController,
            ),
        ],
      ),
    );
  }
}

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

  void _applyDiff(List<BacklogItem> newItems) {
    if (_listKey.currentState == null) {
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(newItems);
      });
      return;
    }

    var hasStructuralChanges = false;
    for (var i = _items.length - 1; i >= 0; i--) {
      final taskId = _items[i].taskId;
      if (!newItems.any((item) => item.taskId == taskId)) {
        final removed = _items.removeAt(i);
        hasStructuralChanges = true;
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
        hasStructuralChanges = true;
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 200),
        );
      }
    }

    final hasOrderOrContentChanges =
        _items.length == newItems.length &&
        _items.asMap().entries.any((entry) {
          final index = entry.key;
          final current = entry.value;
          final incoming = newItems[index];
          return current.taskId != incoming.taskId || current != incoming;
        });

    if (hasOrderOrContentChanges) {
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(newItems);
      });
      return;
    }

    if (hasStructuralChanges && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
      data: (dataItems) {
        if (_items.isEmpty && dataItems.isNotEmpty) {
          _items.addAll(dataItems);
        }
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
      TaskStatus.inProgress || TaskStatus.reopened =>
        () => _showInProgressActionSheet(item),
      TaskStatus.done => null,
      TaskStatus.backlog => null,
    };
  }

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
                      if (context.mounted) {
                        unawaited(context.push('/curiosity/${item.taskId}'));
                      }
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

  void _showTodoActionSheet(BacklogItem item) {
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
                    onPressed: () async {
                      Navigator.pop(sheetContext);
                      try {
                        await ref
                            .read(boardRepositoryProvider)
                            .startTask(item.taskId);
                        if (mounted) widget.tabController.animateTo(1);
                      } on Object {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not start studying. Please try again.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Start studying'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.pop(sheetContext);
                      try {
                        await ref
                            .read(boardRepositoryProvider)
                            .moveToBacklog(item.taskId);
                      } on Object {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not move task to backlog. '
                              'Please try again.',
                            ),
                          ),
                        );
                      }
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
      ),
    );
  }
}
