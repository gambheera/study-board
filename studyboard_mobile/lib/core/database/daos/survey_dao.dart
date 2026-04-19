import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/survey_responses_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';
import 'package:uuid/uuid.dart';

part 'survey_dao.g.dart';

const _uuid = Uuid();

@DriftAccessor(tables: [SurveyResponsesTable, SyncQueueTable])
class SurveyDao extends DatabaseAccessor<AppDatabase> with _$SurveyDaoMixin {
  SurveyDao(super.attachedDatabase);

  Future<void> saveResponse(SurveyResponsesTableCompanion companion) =>
      transaction(() async {
        await into(surveyResponsesTable).insert(companion);
        final now = DateTime.now().toUtc().toIso8601String();
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'survey_response',
          entityId: companion.id.value,
          operation: 'upsert',
          payload: jsonEncode({
            'survey_response_id': companion.id.value,
            'student_id': companion.studentId.value,
          }),
          createdAt: now,
        ));
      });
}
