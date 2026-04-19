// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_dao.dart';

// ignore_for_file: type=lint
mixin _$SurveyDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurveyResponsesTableTable get surveyResponsesTable =>
      attachedDatabase.surveyResponsesTable;
  $SyncQueueTableTable get syncQueueTable => attachedDatabase.syncQueueTable;
  SurveyDaoManager get managers => SurveyDaoManager(this);
}

class SurveyDaoManager {
  final _$SurveyDaoMixin _db;
  SurveyDaoManager(this._db);
  $$SurveyResponsesTableTableTableManager get surveyResponsesTable =>
      $$SurveyResponsesTableTableTableManager(
        _db.attachedDatabase,
        _db.surveyResponsesTable,
      );
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(
        _db.attachedDatabase,
        _db.syncQueueTable,
      );
}
