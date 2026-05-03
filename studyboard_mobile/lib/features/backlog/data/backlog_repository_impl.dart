import 'package:studyboard_mobile/core/database/daos/task_dao.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_repository.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

class BacklogRepositoryImpl implements BacklogRepository {
  const BacklogRepositoryImpl(this._taskDao);

  final TaskDao _taskDao;

  @override
  Stream<List<BacklogItem>> watchBacklogTasks(
    String studentId, {
    String? contentTrack,
  }) {
    return _taskDao
        .watchBacklogTasks(studentId, contentTrack: contentTrack)
        .map(
          (rows) => rows
              .map(
                (r) => BacklogItem(
                  taskId: r.task.id,
                  lessonId: r.task.lessonId,
                  lessonTitle: r.lesson.title,
                  topicId: r.lesson.topicId,
                  topicTitle: r.topic.title,
                  contentTrack: r.lesson.contentTrack,
                  taskStatus: TaskStatusX.fromString(r.task.taskStatus),
                  curiosityCompleted: r.task.curiosityCompleted,
                  lessonOrderIndex: r.lesson.orderIndex,
                  topicOrderIndex: r.topic.orderIndex,
                ),
              )
              .toList(),
        );
  }
}
