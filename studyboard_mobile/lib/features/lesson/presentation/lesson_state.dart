import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_state.freezed.dart';

@freezed
abstract class LessonState with _$LessonState {
  const factory LessonState({
    required String taskId,
    required String lessonId,
    required String lessonTitle,
    required String topicTitle,
    required String questionText,
    required String contentText,
    @Default(false) bool curiosityCompleted,
  }) = _LessonState;
}
