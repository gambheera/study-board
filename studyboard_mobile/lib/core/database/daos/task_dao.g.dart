// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dao.dart';

// ignore_for_file: type=lint
mixin _$TaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $LessonTasksTableTable get lessonTasksTable =>
      attachedDatabase.lessonTasksTable;
  $SyncQueueTableTable get syncQueueTable => attachedDatabase.syncQueueTable;
  $LessonsTableTable get lessonsTable => attachedDatabase.lessonsTable;
  $TopicsTableTable get topicsTable => attachedDatabase.topicsTable;
  $StudentsTableTable get studentsTable => attachedDatabase.studentsTable;
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
  $$LessonsTableTableTableManager get lessonsTable =>
      $$LessonsTableTableTableManager(_db.attachedDatabase, _db.lessonsTable);
  $$TopicsTableTableTableManager get topicsTable =>
      $$TopicsTableTableTableManager(_db.attachedDatabase, _db.topicsTable);
  $$StudentsTableTableTableManager get studentsTable =>
      $$StudentsTableTableTableManager(_db.attachedDatabase, _db.studentsTable);
}
