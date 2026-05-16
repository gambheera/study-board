import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_question.dart';
import 'package:studyboard_mobile/features/quiz/presentation/quiz_notifier.dart';
import 'package:studyboard_mobile/features/quiz/presentation/quiz_state.dart';
import 'package:studyboard_mobile/features/quiz/presentation/widgets/quiz_answer_option.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({required this.taskId, super.key});

  final String taskId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<QuizState>>(
      quizProvider(widget.taskId),
      (_, next) {
        next.whenData((quizState) {
          if (quizState is QuizCompleted && context.mounted) {
            if (quizState.passed) {
              context.go(
                '/quiz/${widget.taskId}/pass',
                extra: quizState.lessonTitle,
              );
            } else {
              QuizQuestion? pivotQuestion;
              String? studentOptionKey;
              for (var i = quizState.questions.length - 1; i >= 0; i--) {
                final selected = quizState.selectedAnswers[i];
                if (selected != null &&
                    selected != quizState.questions[i].correctOption) {
                  pivotQuestion = quizState.questions[i];
                  studentOptionKey = selected;
                  break;
                }
              }
              final extra = {
                'pivotQuestionText': pivotQuestion?.questionText ?? '',
                'correctOptionText': pivotQuestion != null
                    ? _optionText(pivotQuestion, pivotQuestion.correctOption)
                    : '',
                'studentOptionText':
                    (pivotQuestion != null && studentOptionKey != null)
                        ? _optionText(pivotQuestion, studentOptionKey)
                        : '',
                'failedAttemptCount': quizState.failedAttemptCount,
                'lessonTitle': quizState.lessonTitle,
              };
              context.go('/quiz/${widget.taskId}/fail', extra: extra);
            }
          }
        });
      },
    );

    final quizAsync = ref.watch(quizProvider(widget.taskId));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => _showLeaveDialog(context),
      child: Scaffold(
        body: SafeArea(
          child: quizAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load quiz',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => ref.invalidate(
                      quizProvider(widget.taskId),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (quizState) => switch (quizState) {
              QuizActive() => _QuizActiveBody(
                  state: quizState,
                  onSelectAnswer: (option) => ref
                      .read(quizProvider(widget.taskId).notifier)
                      .selectAnswer(option),
                  onContinue: () => unawaited(
                    ref
                        .read(quizProvider(widget.taskId).notifier)
                        .advanceOrComplete(),
                  ),
                ),
              QuizCompleted() => const SizedBox.shrink(),
            },
          ),
        ),
      ),
    );
  }

  void _showLeaveDialog(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Text('Leave this quiz?'),
          content: const Text('Your progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                context.go('/board');
              },
              child: const Text('Leave'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizActiveBody extends StatelessWidget {
  const _QuizActiveBody({
    required this.state,
    required this.onSelectAnswer,
    required this.onContinue,
  });

  final QuizActive state;
  final void Function(String option) onSelectAnswer;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = state.questions[state.currentIndex];
    final selectedOption = state.selectedAnswers[state.currentIndex];
    final isAnswered = selectedOption != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (state.currentIndex + 1) / state.questions.length,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: AppColors.calmBlue,
          ),
          const SizedBox(height: 8),
          Text(
            'Question ${state.currentIndex + 1} of ${state.questions.length}',
            style: theme.textTheme.labelMedium,
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 24),
          Text(
            question.questionText,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          QuizAnswerOption(
            option: 'a',
            optionText: question.optionA,
            label: 'A',
            correctOption: question.correctOption,
            selectedOption: selectedOption,
            isAnswered: isAnswered,
            onTap: () => onSelectAnswer('a'),
          ),
          const SizedBox(height: 10),
          QuizAnswerOption(
            option: 'b',
            optionText: question.optionB,
            label: 'B',
            correctOption: question.correctOption,
            selectedOption: selectedOption,
            isAnswered: isAnswered,
            onTap: () => onSelectAnswer('b'),
          ),
          const SizedBox(height: 10),
          QuizAnswerOption(
            option: 'c',
            optionText: question.optionC,
            label: 'C',
            correctOption: question.correctOption,
            selectedOption: selectedOption,
            isAnswered: isAnswered,
            onTap: () => onSelectAnswer('c'),
          ),
          const SizedBox(height: 10),
          QuizAnswerOption(
            option: 'd',
            optionText: question.optionD,
            label: 'D',
            correctOption: question.correctOption,
            selectedOption: selectedOption,
            isAnswered: isAnswered,
            onTap: () => onSelectAnswer('d'),
          ),
          const Spacer(),
          if (isAnswered)
            FilledButton(
              onPressed: onContinue,
              child: const Text('Continue'),
            ),
        ],
      ),
    );
  }
}

String _optionText(QuizQuestion q, String optionKey) {
  return switch (optionKey) {
    'a' => q.optionA,
    'b' => q.optionB,
    'c' => q.optionC,
    'd' => q.optionD,
    _ => optionKey,
  };
}
