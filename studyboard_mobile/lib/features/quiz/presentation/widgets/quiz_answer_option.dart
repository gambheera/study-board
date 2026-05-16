import 'package:flutter/material.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';

class QuizAnswerOption extends StatelessWidget {
  const QuizAnswerOption({
    required this.option,
    required this.optionText,
    required this.label,
    required this.correctOption,
    required this.isAnswered,
    this.selectedOption,
    this.onTap,
    super.key,
  });

  final String option;
  final String optionText;
  final String label;
  final String correctOption;
  final String? selectedOption;
  final bool isAnswered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isCorrect = correctOption == option;
    final isSelected = selectedOption == option;

    Color? backgroundColor;
    if (isAnswered) {
      if (isCorrect) {
        backgroundColor = colorScheme.taskDone.withValues(alpha: 0.2);
      } else if (isSelected) {
        backgroundColor = colorScheme.taskReopened.withValues(alpha: 0.2);
      }
    }

    final borderColor = isAnswered && (isCorrect || isSelected)
        ? (isCorrect ? colorScheme.taskDone : colorScheme.taskReopened)
        : colorScheme.outline;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isAnswered ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Text(
              '$label. ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isAnswered && isCorrect
                        ? AppColors.sagGreen
                        : isAnswered && isSelected
                            ? AppColors.dustyRose
                            : null,
                  ),
            ),
            Expanded(
              child: Text(
                optionText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
