import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_question.freezed.dart';
part 'quiz_question.g.dart';

@freezed
abstract class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    @JsonKey(name: 'lesson_id') required String lessonId,
    @JsonKey(name: 'question_text') required String questionText,
    @JsonKey(name: 'option_a') required String optionA,
    @JsonKey(name: 'option_b') required String optionB,
    @JsonKey(name: 'option_c') required String optionC,
    @JsonKey(name: 'option_d') required String optionD,
    @JsonKey(name: 'correct_option') required String correctOption,
    @JsonKey(name: 'order_index') required int orderIndex,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}
