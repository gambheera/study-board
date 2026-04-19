// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dao.dart';

// ignore_for_file: type=lint
mixin _$TaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $LessonTasksTableTable get lessonTasksTable =>
      attachedDatabase.lessonTasksTable;
  $SyncQueueTableTable get syncQueueTable => attachedDatabase.syncQueueTable;
  TaskDaoManager get managers => TaskDaoManager(this);
}

class TaskDaoManager {
  final _$TaskDaoMixin _db;
  TaskDaoManager(this._db);
  $$LessonTasksTableTableTableManager get lessonTasksTable =>
      $$LessonTasksTableTableTableManager(
        _db.attachedDatabase,
        _db.lessonTasksTable,
      );
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(
        _db.attachedDatabase,
        _db.syncQueueTable,
      );
}
