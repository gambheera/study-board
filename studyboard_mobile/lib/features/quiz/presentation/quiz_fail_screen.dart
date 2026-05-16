import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';

class QuizFailScreen extends StatelessWidget {
  const QuizFailScreen({
    required this.taskId,
    required this.pivotQuestionText,
    required this.correctOptionText,
    required this.studentOptionText,
    required this.failedAttemptCount,
    required this.lessonTitle,
    super.key,
  });

  final String taskId;
  final String pivotQuestionText;
  final String correctOptionText;
  final String studentOptionText;
  final int failedAttemptCount;
  final String lessonTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(lessonTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              _PivotQuestionCard(
                pivotQuestionText: pivotQuestionText,
                correctOptionText: correctOptionText,
                studentOptionText: studentOptionText,
                failedAttemptCount: failedAttemptCount,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/lesson/$taskId'),
                child: const Text('Review lesson'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/board'),
                child: const Text('Try again later'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _PivotQuestionCard extends StatelessWidget {
  const _PivotQuestionCard({
    required this.pivotQuestionText,
    required this.correctOptionText,
    required this.studentOptionText,
    required this.failedAttemptCount,
  });

  final String pivotQuestionText;
  final String correctOptionText;
  final String studentOptionText;
  final int failedAttemptCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (failedAttemptCount >= 3) ...[
              Text(
                'This concept keeps coming up. Go back to fundamentals.',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              "You're one concept away.",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            if (pivotQuestionText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                pivotQuestionText,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              _AnswerChip(
                label: correctOptionText,
                backgroundColor:
                    AppColors.sagGreen.withValues(alpha: 0.25),
                foregroundColor: colorScheme.onSurface,
              ),
              const SizedBox(height: 8),
              _AnswerChip(
                label: studentOptionText,
                backgroundColor:
                    AppColors.dustyRose.withValues(alpha: 0.25),
                foregroundColor: colorScheme.onSurface,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnswerChip extends StatelessWidget {
  const _AnswerChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: foregroundColor,
            ),
      ),
    );
  }
}
