import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    @JsonKey(name: 'topic_id') required String topicId,
    required String title,
    @JsonKey(name: 'content_text') required String contentText,
    @JsonKey(name: 'content_track') required String contentTrack,
    @JsonKey(name: 'order_index') required int orderIndex,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
