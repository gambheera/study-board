import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

abstract interface class BoardRepository {
  Stream<List<BacklogItem>> watchBoardItems(
    String studentId,
    TaskStatus status,
  );

  Stream<bool> watchHasDoneTasks(String studentId);

  Future<void> promoteToTodo(String taskId);

  Future<void> startTask(String taskId);

  Future<void> moveToBacklog(String taskId);
}
