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
