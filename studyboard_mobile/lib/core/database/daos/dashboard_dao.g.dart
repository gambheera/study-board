// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_dao.dart';

// ignore_for_file: type=lint
mixin _$DashboardDaoMixin on DatabaseAccessor<AppDatabase> {
  $LessonTasksTableTable get lessonTasksTable =>
      attachedDatabase.lessonTasksTable;
  $QuizAttemptsTableTable get quizAttemptsTable =>
      attachedDatabase.quizAttemptsTable;
  $LessonsTableTable get lessonsTable => attachedDatabase.lessonsTable;
  $TopicsTableTable get topicsTable => attachedDatabase.topicsTable;
  $SessionsTableTable get sessionsTable => attachedDatabase.sessionsTable;
  DashboardDaoManager get managers => DashboardDaoManager(this);
}

class DashboardDaoManager {
  final _$DashboardDaoMixin _db;
  DashboardDaoManager(this._db);
  $$LessonTasksTableTableTableManager get lessonTasksTable =>
      $$LessonTasksTableTableTableManager(
        _db.attachedDatabase,
        _db.lessonTasksTable,
      );
  $$QuizAttemptsTableTableTableManager get quizAttemptsTable =>
      $$QuizAttemptsTableTableTableManager(
        _db.attachedDatabase,
        _db.quizAttemptsTable,
      );
  $$LessonsTableTableTableManager get lessonsTable =>
      $$LessonsTableTableTableManager(_db.attachedDatabase, _db.lessonsTable);
  $$TopicsTableTableTableManager get topicsTable =>
      $$TopicsTableTableTableManager(_db.attachedDatabase, _db.topicsTable);
  $$SessionsTableTableTableManager get sessionsTable =>
      $$SessionsTableTableTableManager(_db.attachedDatabase, _db.sessionsTable);
}
