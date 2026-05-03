import 'package:studyboard_mobile/core/database/daos/lesson_dao.dart';
import 'package:studyboard_mobile/features/lesson/domain/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl(this._dao);
  final LessonDao _dao;

  @override
  Future<LessonDetails> getLessonDetails(String taskId) async {
    final task = await _dao.getTaskById(taskId);
    if (task == null) throw StateError('Task not found: $taskId');
    final lessonWithTopic = await _dao.getLessonWithTopicTitle(task.lessonId);
    if (lessonWithTopic == null) {
      throw StateError('Lesson not found: ${task.lessonId}');
    }
    final questions =
        await _dao.getPastPaperQuestionsForLesson(task.lessonId);
    return LessonDetails(
      taskId: taskId,
      lessonId: task.lessonId,
      lessonTitle: lessonWithTopic.lesson.title,
      topicTitle: lessonWithTopic.topic.title,
      questionText:
          questions.isNotEmpty ? questions.first.questionText : '',
      contentText: lessonWithTopic.lesson.contentText,
      curiosityCompleted: task.curiosityCompleted,
    );
  }

  @override
  Future<void> setCuriosityCompleted(String taskId) =>
      _dao.setCuriosityCompleted(taskId);
}
