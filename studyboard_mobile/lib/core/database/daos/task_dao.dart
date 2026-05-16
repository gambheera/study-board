import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/lesson_tasks_table.dart';
import 'package:studyboard_mobile/core/database/tables/lessons_table.dart';
import 'package:studyboard_mobile/core/database/tables/students_table.dart';
import 'package:studyboard_mobile/core/database/tables/topics_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';
import 'package:uuid/uuid.dart';

part 'task_dao.g.dart';

const _uuid = Uuid();

class BacklogRow {
  const BacklogRow({
    required this.task,
    required this.lesson,
    required this.topic,
  });

  final LessonTasksTableData task;
  final LessonsTableData lesson;
  final TopicsTableData topic;
}

@DriftAccessor(
  tables: [
    LessonTasksTable,
    SyncQueueTable,
    LessonsTable,
    TopicsTable,
    StudentsTable,
  ],
)
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.attachedDatabase);

  Future<void> markTaskComplete(String taskId) => transaction(() async {
    final now = DateTime.now().toUtc().toIso8601String();
    final affected =
        await (update(
          lessonTasksTable,
        )..where((t) => t.id.equals(taskId))).write(
          LessonTasksTableCompanion(
            taskStatus: Value(TaskStatus.done.toDbString()),
            updatedAt: Value(now),
          ),
        );
    if (affected == 0) return;
    await into(syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
        id: _uuid.v4(),
        entityType: 'task_status',
        entityId: taskId,
        operation: 'upsert',
        payload: jsonEncode({
          'task_status': TaskStatus.done.toDbString(),
          'task_id': taskId,
        }),
        createdAt: now,
      ),
    );
  });

  Future<void> resetTaskToInProgress(String taskId) => transaction(() async {
    final now = DateTime.now().toUtc().toIso8601String();
    final affected =
        await (update(
          lessonTasksTable,
        )..where((t) => t.id.equals(taskId))).write(
          LessonTasksTableCompanion(
            taskStatus: Value(TaskStatus.reopened.toDbString()),
            updatedAt: Value(now),
          ),
        );
    if (affected == 0) return;
    await into(syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
        id: _uuid.v4(),
        entityType: 'lesson_task',
        entityId: taskId,
        operation: 'upsert',
        payload: jsonEncode({
          'id': taskId,
          'task_status': TaskStatus.reopened.toDbString(),
          'updated_at': now,
          'context': 'reset',
        }),
        createdAt: now,
      ),
    );
  });

  Future<void> pullToTodo(String taskId) => transaction(() async {
    final now = DateTime.now().toUtc().toIso8601String();
    final taskRow = await (select(lessonTasksTable)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (taskRow == null) return;
    final studentId = taskRow.studentId;
    await (update(lessonTasksTable)..where((t) => t.id.equals(taskId))).write(
      LessonTasksTableCompanion(
        taskStatus: Value(TaskStatus.todo.toDbString()),
        updatedAt: Value(now),
      ),
    );
    await into(syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
        id: _uuid.v4(),
        entityType: 'task_status',
        entityId: taskId,
        operation: 'upsert',
        payload: jsonEncode({
          'task_status': TaskStatus.todo.toDbString(),
          'task_id': taskId,
        }),
        createdAt: now,
      ),
    );
    await (update(studentsTable)..where((t) => t.id.equals(studentId)))
        .write(StudentsTableCompanion(lastActiveAt: Value(now)));
    await into(syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
        id: _uuid.v4(),
        entityType: 'student',
        entityId: studentId,
        operation: 'upsert',
        payload: jsonEncode({
          'student_id': studentId,
          'last_active_at': now,
        }),
        createdAt: now,
      ),
    );
  });

  Future<void> startTask(String taskId) => transaction(() async {
    final now = DateTime.now().toUtc().toIso8601String();
    final taskRow = await (select(lessonTasksTable)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (taskRow == null) return;
    final studentId = taskRow.studentId;
    await (update(lessonTasksTable)..where((t) => t.id.equals(taskId))).write(
      LessonTasksTableCompanion(
        taskStatus: Value(TaskStatus.inProgress.toDbString()),
        updatedAt: Value(now),
      ),
    );
    await into(syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
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
      ),
    );
    await (update(studentsTable)..where((t) => t.id.equals(studentId)))
        .write(StudentsTableCompanion(lastActiveAt: Value(now)));
    await into(syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
        id: _uuid.v4(),
        entityType: 'student',
        entityId: studentId,
        operation: 'upsert',
        payload: jsonEncode({
          'student_id': studentId,
          'last_active_at': now,
        }),
        createdAt: now,
      ),
    );
  });

  Future<LessonTasksTableData?> getTaskByLesson(
    String studentId,
    String lessonId,
  ) =>
      (select(lessonTasksTable)..where(
            (t) => t.studentId.equals(studentId) & t.lessonId.equals(lessonId),
          ))
          .getSingleOrNull();

  Future<void> createLessonTasksForStudent(
    String studentId,
    List<String> lessonIds,
  ) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await batch((b) {
      for (final lessonId in lessonIds) {
        b.insert(
          lessonTasksTable,
          LessonTasksTableCompanion.insert(
            id: _uuid.v4(),
            studentId: studentId,
            lessonId: lessonId,
            taskStatus: Value(TaskStatus.backlog.toDbString()),
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  Stream<List<BacklogRow>> watchBacklogTasks(
    String studentId, {
    String? contentTrack,
  }) {
    var condition =
        lessonTasksTable.studentId.equals(studentId) &
        lessonTasksTable.taskStatus.equals(
          TaskStatus.backlog.toDbString(),
        );

    if (contentTrack != null) {
      condition = condition & lessonsTable.contentTrack.equals(contentTrack);
    }

    return (select(lessonTasksTable).join([
            innerJoin(
              lessonsTable,
              lessonsTable.id.equalsExp(lessonTasksTable.lessonId),
            ),
            innerJoin(
              topicsTable,
              topicsTable.id.equalsExp(lessonsTable.topicId),
            ),
          ])
          ..where(condition)
          ..orderBy([
            OrderingTerm.asc(topicsTable.orderIndex),
            OrderingTerm.asc(lessonsTable.orderIndex),
          ]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => BacklogRow(
                  task: r.readTable(lessonTasksTable),
                  lesson: r.readTable(lessonsTable),
                  topic: r.readTable(topicsTable),
                ),
              )
              .toList(),
        );
  }

  Stream<List<BacklogRow>> watchTasksByStatus(
    String studentId,
    TaskStatus status,
  ) {
    final condition =
        lessonTasksTable.studentId.equals(studentId) &
        lessonTasksTable.taskStatus.equals(status.toDbString());

    return (select(lessonTasksTable).join([
            innerJoin(
              lessonsTable,
              lessonsTable.id.equalsExp(lessonTasksTable.lessonId),
            ),
            innerJoin(
              topicsTable,
              topicsTable.id.equalsExp(lessonsTable.topicId),
            ),
          ])
          ..where(condition)
          ..orderBy([
            OrderingTerm.asc(topicsTable.orderIndex),
            OrderingTerm.asc(lessonsTable.orderIndex),
          ]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => BacklogRow(
                  task: r.readTable(lessonTasksTable),
                  lesson: r.readTable(lessonsTable),
                  topic: r.readTable(topicsTable),
                ),
              )
              .toList(),
        );
  }

  Stream<List<BacklogRow>> watchInProgressTasks(String studentId) {
    final condition =
        lessonTasksTable.studentId.equals(studentId) &
        lessonTasksTable.taskStatus.isIn(['in_progress', 'reopened']);

    return (select(lessonTasksTable).join([
            innerJoin(
              lessonsTable,
              lessonsTable.id.equalsExp(lessonTasksTable.lessonId),
            ),
            innerJoin(
              topicsTable,
              topicsTable.id.equalsExp(lessonsTable.topicId),
            ),
          ])
          ..where(condition)
          ..orderBy([OrderingTerm.desc(lessonTasksTable.updatedAt)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => BacklogRow(
                  task: r.readTable(lessonTasksTable),
                  lesson: r.readTable(lessonsTable),
                  topic: r.readTable(topicsTable),
                ),
              )
              .toList(),
        );
  }

  Stream<bool> watchHasDoneTasks(String studentId) {
    return (selectOnly(lessonTasksTable)
          ..addColumns([lessonTasksTable.id])
          ..where(
            lessonTasksTable.studentId.equals(studentId) &
                lessonTasksTable.taskStatus.equals(
                  TaskStatus.done.toDbString(),
                ),
          )
          ..limit(1))
        .watch()
        .map((rows) => rows.isNotEmpty);
  }

  Future<void> moveToBacklog(String taskId) => transaction(() async {
    final now = DateTime.now().toUtc().toIso8601String();
    final taskRow = await (select(lessonTasksTable)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (taskRow == null) return;
    final studentId = taskRow.studentId;
    await (update(lessonTasksTable)..where((t) => t.id.equals(taskId))).write(
      LessonTasksTableCompanion(
        taskStatus: Value(TaskStatus.backlog.toDbString()),
        updatedAt: Value(now),
      ),
    );
    await into(syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
        id: _uuid.v4(),
        entityType: 'task_status',
        entityId: taskId,
        operation: 'upsert',
        payload: jsonEncode({
          'task_status': TaskStatus.backlog.toDbString(),
          'task_id': taskId,
        }),
        createdAt: now,
      ),
    );
    await (update(studentsTable)..where((t) => t.id.equals(studentId)))
        .write(StudentsTableCompanion(lastActiveAt: Value(now)));
    await into(syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
        id: _uuid.v4(),
        entityType: 'student',
        entityId: studentId,
        operation: 'upsert',
        payload: jsonEncode({
          'student_id': studentId,
          'last_active_at': now,
        }),
        createdAt: now,
      ),
    );
  });
}
