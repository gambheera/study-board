import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_notifier.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_state.dart';

class CuriosityScreen extends ConsumerStatefulWidget {
  const CuriosityScreen({required this.taskId, super.key});
  final String taskId;

  @override
  ConsumerState<CuriosityScreen> createState() => _CuriosityScreenState();
}

class _CuriosityScreenState extends ConsumerState<CuriosityScreen> {
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    final lessonAsync = ref.watch(lessonProvider(widget.taskId));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showLeaveDialog();
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
                  onPressed: () =>
                      ref.invalidate(lessonProvider(widget.taskId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (lesson) => _CuriosityContent(
          lesson: lesson,
          onContinue: () => _onContinue(context),
        ),
      ),
    );
  }

  Future<void> _onContinue(BuildContext context) async {
    await ref
        .read(lessonProvider(widget.taskId).notifier)
        .completeCuriosity();
    if (!context.mounted) return;
    context.pushReplacement('/lesson/${widget.taskId}');
  }

  void _showLeaveDialog() {
    if (_isDialogShowing) return;
    _isDialogShowing = true;
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Leave this lesson?'),
          content: const Text(
            'Your progress on this warm-up will not be saved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (mounted) context.pop();
              },
              child: const Text('Leave'),
            ),
          ],
        ),
      ).whenComplete(() {
        if (mounted) setState(() => _isDialogShowing = false);
      }),
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
                "Here's what A/L examiners actually ask about "
                '${lesson.topicTitle}',
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(height: 1.6),
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
