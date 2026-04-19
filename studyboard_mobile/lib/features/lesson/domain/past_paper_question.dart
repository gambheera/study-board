import 'package:freezed_annotation/freezed_annotation.dart';

part 'past_paper_question.freezed.dart';
part 'past_paper_question.g.dart';

@freezed
abstract class PastPaperQuestion with _$PastPaperQuestion {
  const factory PastPaperQuestion({
    required String id,
    @JsonKey(name: 'lesson_id') required String lessonId,
    @JsonKey(name: 'topic_id') required String topicId,
    @JsonKey(name: 'question_text') required String questionText,
    @JsonKey(name: 'order_index') required int orderIndex,
    int? year,
  }) = _PastPaperQuestion;

  factory PastPaperQuestion.fromJson(Map<String, dynamic> json) =>
      _$PastPaperQuestionFromJson(json);
}
