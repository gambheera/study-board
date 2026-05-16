import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_question.dart';

part 'quiz_state.freezed.dart';

@freezed
sealed class QuizState with _$QuizState {
  const factory QuizState.active({
    required List<QuizQuestion> questions,
    required int currentIndex,
    required double passThreshold,
    required String lessonId,
    required String lessonTitle,
    @Default({}) Map<int, String> selectedAnswers,
  }) = QuizActive;

  const factory QuizState.completed({
    required double score,
    required bool passed,
    required int correctCount,
    required int totalQuestions,
    required String lessonId,
    required String lessonTitle,
    required List<QuizQuestion> questions,
    required Map<int, String> selectedAnswers,
    @Default(0) int failedAttemptCount,
  }) = QuizCompleted;
}
