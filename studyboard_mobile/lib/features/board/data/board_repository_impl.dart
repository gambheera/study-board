import 'package:studyboard_mobile/core/database/daos/task_dao.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/board/domain/board_repository.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

class BoardRepositoryImpl implements BoardRepository {
  const BoardRepositoryImpl(this._taskDao);

  final TaskDao _taskDao;

  @override
  Stream<List<BacklogItem>> watchBoardItems(
    String studentId,
    TaskStatus status,
  ) {
    final rows = status == TaskStatus.inProgress
        ? _taskDao.watchInProgressTasks(studentId)
        : _taskDao.watchTasksByStatus(studentId, status);
    return rows.map(
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

  @override
  Stream<bool> watchHasDoneTasks(String studentId) =>
      _taskDao.watchHasDoneTasks(studentId);

  @override
  Future<void> promoteToTodo(String taskId) => _taskDao.pullToTodo(taskId);

  @override
  Future<void> startTask(String taskId) => _taskDao.startTask(taskId);

  @override
  Future<void> moveToBacklog(String taskId) => _taskDao.moveToBacklog(taskId);
}
