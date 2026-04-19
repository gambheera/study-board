import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/lesson_tasks_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';
import 'package:uuid/uuid.dart';

part 'task_dao.g.dart';

const _uuid = Uuid();

@DriftAccessor(tables: [LessonTasksTable, SyncQueueTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.attachedDatabase);

  Future<void> markTaskComplete(String taskId) => transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        final affected =
            await (update(lessonTasksTable)..where((t) => t.id.equals(taskId)))
                .write(LessonTasksTableCompanion(
          taskStatus: Value(TaskStatus.done.toDbString()),
          updatedAt: Value(now),
        ));
        if (affected == 0) return;
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'task_status',
          entityId: taskId,
          operation: 'upsert',
          payload: jsonEncode({
            'task_status': TaskStatus.done.toDbString(),
            'task_id': taskId,
          }),
          createdAt: now,
        ));
      });

  Future<void> resetTaskToInProgress(String taskId) => transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        final affected =
            await (update(lessonTasksTable)..where((t) => t.id.equals(taskId)))
                .write(LessonTasksTableCompanion(
          taskStatus: Value(TaskStatus.inProgress.toDbString()),
          updatedAt: Value(now),
        ));
        if (affected == 0) return;
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'task_status',
          entityId: taskId,
          operation: 'upsert',
          payload: jsonEncode({
            'task_status': TaskStatus.inProgress.toDbString(),
            'context': 'reset',
            'task_id': taskId,
          }),
          createdAt: now,
        ));
      });

  Future<void> pullToTodo(String taskId) => transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        final affected =
            await (update(lessonTasksTable)..where((t) => t.id.equals(taskId)))
                .write(LessonTasksTableCompanion(
          taskStatus: Value(TaskStatus.todo.toDbString()),
          updatedAt: Value(now),
        ));
        if (affected == 0) return;
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'task_status',
          entityId: taskId,
          operation: 'upsert',
          payload: jsonEncode({
            'task_status': TaskStatus.todo.toDbString(),
            'task_id': taskId,
          }),
          createdAt: now,
        ));
      });

  Future<void> startTask(String taskId) => transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        final affected =
            await (update(lessonTasksTable)..where((t) => t.id.equals(taskId)))
                .write(LessonTasksTableCompanion(
          taskStatus: Value(TaskStatus.inProgress.toDbString()),
          updatedAt: Value(now),
        ));
        if (affected == 0) return;
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'task_status',
          entityId: taskId,
          operation: 'upsert',
          payload: jsonEncode({
            'task_status': TaskStatus.inProgress.toDbString(),
            'context': 'start',
            'task_id': taskId,
          }),
          createdAt: now,
        ));
      });

  Future<LessonTasksTableData?> getTaskByLesson(
    String studentId,
    String lessonId,
  ) =>
      (select(lessonTasksTable)
            ..where(
              (t) =>
                  t.studentId.equals(studentId) & t.lessonId.equals(lessonId),
            ))
          .getSingleOrNull();
}
