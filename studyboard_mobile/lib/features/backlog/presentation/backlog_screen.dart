import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/core/content_cache/content_cache_service.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/backlog/presentation/backlog_items_provider.dart';
import 'package:studyboard_mobile/features/backlog/presentation/widgets/skeleton_task_card.dart';
import 'package:studyboard_mobile/features/backlog/presentation/widgets/task_card.dart';
import 'package:studyboard_mobile/features/board/data/board_provider.dart';

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

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {});
  }

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
            final hasContent = ref.watch(contentSeededProvider);
            return hasContent.when(
              data: (seeded) {
                if (!seeded) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Content not yet downloaded. '
                        'Connect to the internet to load your lessons.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final emptyMessage = selectedTrack == 'future_papers'
                    ? 'No Future Papers content available yet.'
                    : 'Everything is in progress or done.';
                return Center(
                  child: Text(
                    emptyMessage,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => Center(
                child: Text(
                  'Everything is in progress or done.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }
          return _AnimatedBacklogList(
            items: items,
            onTap: (item) => _showBacklogActionSheet(context, item),
          );
        },
        loading: () => ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          children: List.generate(3, (_) => const SkeletonTaskCard()),
        ),
        error: (_, _) {
          final seededAsync = ref.watch(contentSeededProvider);
          return seededAsync.maybeWhen(
            data: (seeded) => seeded
                ? Center(
                    child: Text(
                      'Failed to load tasks.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Content not yet downloaded. '
                        'Connect to the internet to load your lessons.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
            orElse: () => Center(
              child: Text(
                'Failed to load tasks.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBacklogActionSheet(BuildContext context, BacklogItem item) {
    final boardRepo = ref.read(boardRepositoryProvider);
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (sheetCtx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.lessonTitle,
                  style: Theme.of(sheetCtx).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Topic / ${item.topicTitle}',
                  style: Theme.of(sheetCtx).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(sheetCtx).colorScheme.onSurface.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.pop(sheetCtx);
                      try {
                        await boardRepo.promoteToTodo(item.taskId);
                      } on Object {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not move task to To-Do. Please try again.',
                            ),
                          ),
                        );
                      }
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
      ),
    );
  }
}

class _AnimatedBacklogList extends StatefulWidget {
  const _AnimatedBacklogList({
    required this.items,
    required this.onTap,
  });

  final List<BacklogItem> items;
  final void Function(BacklogItem item) onTap;

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
        var insertAt = 0;
        for (var j = 0; j < i; j++) {
          if (_items.any((item) => item.taskId == newItems[j].taskId)) {
            insertAt++;
          }
        }
        _items.insert(insertAt, newItems[i]);
        hasStructuralChanges = true;
        _listKey.currentState?.insertItem(
          insertAt,
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
    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      initialItemCount: _items.length,
      itemBuilder: (ctx, index, animation) => SizeTransition(
        sizeFactor: animation,
        child: TaskCard(
          item: _items[index],
          onTap: () => widget.onTap(_items[index]),
        ),
      ),
    );
  }
}
