// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_attempt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizAttempt _$QuizAttemptFromJson(Map<String, dynamic> json) => _QuizAttempt(
  id: json['id'] as String,
  studentId: json['student_id'] as String,
  lessonId: json['lesson_id'] as String,
  attemptedAt: json['attempted_at'] as String,
  score: (json['score'] as num).toDouble(),
  passed: json['passed'] as bool,
);

Map<String, dynamic> _$QuizAttemptToJson(_QuizAttempt instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'lesson_id': instance.lessonId,
      'attempted_at': instance.attemptedAt,
      'score': instance.score,
      'passed': instance.passed,
    };
