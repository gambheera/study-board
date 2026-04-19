// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: json['id'] as String,
  topicId: json['topic_id'] as String,
  title: json['title'] as String,
  contentText: json['content_text'] as String,
  contentTrack: json['content_track'] as String,
  orderIndex: (json['order_index'] as num).toInt(),
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'topic_id': instance.topicId,
  'title': instance.title,
  'content_text': instance.contentText,
  'content_track': instance.contentTrack,
  'order_index': instance.orderIndex,
};
