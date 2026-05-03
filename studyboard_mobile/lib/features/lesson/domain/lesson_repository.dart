import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_repository.freezed.dart';

@freezed
abstract class LessonDetails with _$LessonDetails {
  const factory LessonDetails({
    required String taskId,
    required String lessonId,
    required String lessonTitle,
    required String topicTitle,
    required String questionText,
    required String contentText,
    required bool curiosityCompleted,
  }) = _LessonDetails;
}

abstract interface class LessonRepository {
  Future<LessonDetails> getLessonDetails(String taskId);
  Future<void> setCuriosityCompleted(String taskId);
}
