import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_notifier.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_state.dart';

class LessonContentScreen extends ConsumerStatefulWidget {
  const LessonContentScreen({required this.taskId, super.key});

  final String taskId;

  @override
  ConsumerState<LessonContentScreen> createState() =>
      _LessonContentScreenState();
}

class _LessonContentScreenState extends ConsumerState<LessonContentScreen> {
  late final ScrollController _scrollController;
  final _progressNotifier = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (!pos.hasContentDimensions) return;
    final max = pos.maxScrollExtent;
    _progressNotifier.value =
        max <= 0 ? 1.0 : (pos.pixels / max).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final lessonAsync = ref.watch(lessonProvider(widget.taskId));
    ref.listen(lessonProvider(widget.taskId), (_, next) {
      if (!next.hasValue) _progressNotifier.value = 0;
    });
    return Scaffold(
      body: lessonAsync.when(
        loading: () => const _LessonSkeletonScreen(),
        error: (e, _) => SafeArea(
          child: Center(
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
        data: (lesson) => _LessonContent(
          lesson: lesson,
          scrollController: _scrollController,
          progressNotifier: _progressNotifier,
          onTakeQuiz: () {
            if (context.mounted) {
              unawaited(context.push('/quiz/${widget.taskId}'));
            }
          },
        ),
      ),
    );
  }
}

class _LessonContent extends StatelessWidget {
  const _LessonContent({
    required this.lesson,
    required this.scrollController,
    required this.progressNotifier,
    required this.onTakeQuiz,
  });

  final LessonState lesson;
  final ScrollController scrollController;
  final ValueNotifier<double> progressNotifier;
  final VoidCallback onTakeQuiz;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: progressNotifier,
            builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: AppColors.calmBlue,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.lessonTitle,
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  MarkdownBody(
                    data: lesson.contentText,
                    softLineBreak: true,
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      Theme.of(context),
                    ).copyWith(
                      p: textTheme.bodyLarge?.copyWith(height: 1.6),
                      h1: textTheme.headlineMedium,
                      h2: textTheme.headlineSmall,
                      h3: textTheme.titleLarge,
                      h4: textTheme.titleMedium,
                      code: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                      ),
                    ),
                    sizedImageBuilder: (config) {
                      if (config.uri.scheme != 'http' &&
                          config.uri.scheme != 'https') {
                        return const Row(
                          children: [
                            Icon(Icons.broken_image_outlined),
                            SizedBox(width: 8),
                            Text('Image unavailable'),
                          ],
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CachedNetworkImage(
                          imageUrl: config.uri.toString(),
                          fit: BoxFit.fitWidth,
                          placeholder: (_, _) => const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (_, _, _) => const Row(
                            children: [
                              Icon(Icons.broken_image_outlined),
                              SizedBox(width: 8),
                              Text('Image unavailable'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onTakeQuiz,
                child: const Text('Take quiz'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonSkeletonScreen extends StatelessWidget {
  const _LessonSkeletonScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const LinearProgressIndicator(value: 0, color: Colors.transparent),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SkeletonBox(height: 28, width: double.infinity),
                  const SizedBox(height: 24),
                  const _SkeletonBox(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  const _SkeletonBox(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  const _SkeletonBox(height: 16, width: 280),
                  const SizedBox(height: 16),
                  const _SkeletonBox(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  const _SkeletonBox(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  const _SkeletonBox(height: 16, width: 240),
                ],
              ),
            ),
          ),
        ],
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
