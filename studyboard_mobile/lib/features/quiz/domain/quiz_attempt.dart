import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_attempt.freezed.dart';
part 'quiz_attempt.g.dart';

@freezed
abstract class QuizAttempt with _$QuizAttempt {
  const factory QuizAttempt({
    required String id,
    @JsonKey(name: 'student_id') required String studentId,
    @JsonKey(name: 'lesson_id') required String lessonId,
    @JsonKey(name: 'attempted_at') required String attemptedAt,
    required double score,
    required bool passed,
  }) = _QuizAttempt;

  factory QuizAttempt.fromJson(Map<String, dynamic> json) =>
      _$QuizAttemptFromJson(json);
}
