// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_dao.dart';

// ignore_for_file: type=lint
mixin _$ContentDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubjectsTableTable get subjectsTable => attachedDatabase.subjectsTable;
  $TopicsTableTable get topicsTable => attachedDatabase.topicsTable;
  $LessonsTableTable get lessonsTable => attachedDatabase.lessonsTable;
  $QuizQuestionsTableTable get quizQuestionsTable =>
      attachedDatabase.quizQuestionsTable;
  $PastPaperQuestionsTableTable get pastPaperQuestionsTable =>
      attachedDatabase.pastPaperQuestionsTable;
  ContentDaoManager get managers => ContentDaoManager(this);
}

class ContentDaoManager {
  final _$ContentDaoMixin _db;
  ContentDaoManager(this._db);
  $$SubjectsTableTableTableManager get subjectsTable =>
      $$SubjectsTableTableTableManager(_db.attachedDatabase, _db.subjectsTable);
  $$TopicsTableTableTableManager get topicsTable =>
      $$TopicsTableTableTableManager(_db.attachedDatabase, _db.topicsTable);
  $$LessonsTableTableTableManager get lessonsTable =>
      $$LessonsTableTableTableManager(_db.attachedDatabase, _db.lessonsTable);
  $$QuizQuestionsTableTableTableManager get quizQuestionsTable =>
      $$QuizQuestionsTableTableTableManager(
        _db.attachedDatabase,
        _db.quizQuestionsTable,
      );
  $$PastPaperQuestionsTableTableTableManager get pastPaperQuestionsTable =>
      $$PastPaperQuestionsTableTableTableManager(
        _db.attachedDatabase,
        _db.pastPaperQuestionsTable,
      );
}
