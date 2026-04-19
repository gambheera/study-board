// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_dao.dart';

// ignore_for_file: type=lint
mixin _$LessonDaoMixin on DatabaseAccessor<AppDatabase> {
  $LessonsTableTable get lessonsTable => attachedDatabase.lessonsTable;
  $PastPaperQuestionsTableTable get pastPaperQuestionsTable =>
      attachedDatabase.pastPaperQuestionsTable;
  $LessonTasksTableTable get lessonTasksTable =>
      attachedDatabase.lessonTasksTable;
  $SyncQueueTableTable get syncQueueTable => attachedDatabase.syncQueueTable;
  LessonDaoManager get managers => LessonDaoManager(this);
}

class LessonDaoManager {
  final _$LessonDaoMixin _db;
  LessonDaoManager(this._db);
  $$LessonsTableTableTableManager get lessonsTable =>
      $$LessonsTableTableTableManager(_db.attachedDatabase, _db.lessonsTable);
  $$PastPaperQuestionsTableTableTableManager get pastPaperQuestionsTable =>
      $$PastPaperQuestionsTableTableTableManager(
        _db.attachedDatabase,
        _db.pastPaperQuestionsTable,
      );
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
