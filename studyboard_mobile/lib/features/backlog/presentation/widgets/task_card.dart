import 'package:flutter/material.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.item, this.onTap, super.key});

  final VoidCallback? onTap;
  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = _borderColor(colorScheme, item.taskStatus);
    final icon = _stateIcon(item.taskStatus);
    final label = _stateLabel(item.taskStatus);

    return Semantics(
      label: onTap != null
          ? '${item.lessonTitle}, $label, double-tap to see options'
          : '${item.lessonTitle}, $label',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
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
                          color: colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
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
      TaskStatus.reopened => colorScheme.taskReopened,
    };
  }

  IconData _stateIcon(TaskStatus status) {
    return switch (status) {
      TaskStatus.backlog => Icons.access_time,
      TaskStatus.todo => Icons.arrow_forward,
      TaskStatus.inProgress => Icons.play_arrow,
      TaskStatus.done => Icons.check_circle,
      TaskStatus.reopened => Icons.refresh,
    };
  }

  String _stateLabel(TaskStatus status) {
    return switch (status) {
      TaskStatus.backlog => 'Backlog',
      TaskStatus.todo => 'To-Do',
      TaskStatus.inProgress => 'In Progress',
      TaskStatus.done => 'Done',
      TaskStatus.reopened => 'Re-opened',
    };
  }
}
