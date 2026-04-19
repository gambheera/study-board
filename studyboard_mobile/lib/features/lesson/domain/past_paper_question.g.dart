// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'past_paper_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PastPaperQuestion _$PastPaperQuestionFromJson(Map<String, dynamic> json) =>
    _PastPaperQuestion(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      topicId: json['topic_id'] as String,
      questionText: json['question_text'] as String,
      orderIndex: (json['order_index'] as num).toInt(),
      year: (json['year'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PastPaperQuestionToJson(_PastPaperQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lesson_id': instance.lessonId,
      'topic_id': instance.topicId,
      'question_text': instance.questionText,
      'order_index': instance.orderIndex,
      'year': instance.year,
    };
