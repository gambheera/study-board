// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_dao.dart';

// ignore_for_file: type=lint
mixin _$QuizDaoMixin on DatabaseAccessor<AppDatabase> {
  $QuizQuestionsTableTable get quizQuestionsTable =>
      attachedDatabase.quizQuestionsTable;
  $QuizAttemptsTableTable get quizAttemptsTable =>
      attachedDatabase.quizAttemptsTable;
  $SyncQueueTableTable get syncQueueTable => attachedDatabase.syncQueueTable;
  $LessonTasksTableTable get lessonTasksTable =>
      attachedDatabase.lessonTasksTable;
  $LessonsTableTable get lessonsTable => attachedDatabase.lessonsTable;
  $TopicsTableTable get topicsTable => attachedDatabase.topicsTable;
  $SubjectsTableTable get subjectsTable => attachedDatabase.subjectsTable;
  QuizDaoManager get managers => QuizDaoManager(this);
}

class QuizDaoManager {
  final _$QuizDaoMixin _db;
  QuizDaoManager(this._db);
  $$QuizQuestionsTableTableTableManager get quizQuestionsTable =>
      $$QuizQuestionsTableTableTableManager(
        _db.attachedDatabase,
        _db.quizQuestionsTable,
      );
  $$QuizAttemptsTableTableTableManager get quizAttemptsTable =>
      $$QuizAttemptsTableTableTableManager(
        _db.attachedDatabase,
        _db.quizAttemptsTable,
      );
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(
        _db.attachedDatabase,
        _db.syncQueueTable,
      );
  $$LessonTasksTableTableTableManager get lessonTasksTable =>
      $$LessonTasksTableTableTableManager(
        _db.attachedDatabase,
        _db.lessonTasksTable,
      );
  $$LessonsTableTableTableManager get lessonsTable =>
      $$LessonsTableTableTableManager(_db.attachedDatabase, _db.lessonsTable);
  $$TopicsTableTableTableManager get topicsTable =>
      $$TopicsTableTableTableManager(_db.attachedDatabase, _db.topicsTable);
  $$SubjectsTableTableTableManager get subjectsTable =>
      $$SubjectsTableTableTableManager(_db.attachedDatabase, _db.subjectsTable);
}
