import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/sessions_table.dart';
import 'package:studyboard_mobile/core/database/tables/students_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';
import 'package:uuid/uuid.dart';

part 'session_dao.g.dart';

const _uuid = Uuid();

@DriftAccessor(tables: [SessionsTable, StudentsTable, SyncQueueTable])
class SessionDao extends DatabaseAccessor<AppDatabase>
    with _$SessionDaoMixin {
  SessionDao(super.attachedDatabase);

  Future<void> openSession({
    required String sessionId,
    required String studentId,
    required String startedAt,
  }) =>
      transaction(() async {
        await into(sessionsTable).insert(
          SessionsTableCompanion.insert(
            id: sessionId,
            studentId: studentId,
            startedAt: startedAt,
          ),
        );
        await (update(studentsTable)..where((t) => t.id.equals(studentId)))
            .write(StudentsTableCompanion(lastActiveAt: Value(startedAt)));
        await into(syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: _uuid.v4(),
            entityType: 'session',
            entityId: sessionId,
            operation: 'upsert',
            payload: jsonEncode({
              'session_id': sessionId,
              'student_id': studentId,
              'started_at': startedAt,
            }),
            createdAt: startedAt,
          ),
        );
        await into(syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: _uuid.v4(),
            entityType: 'student',
            entityId: studentId,
            operation: 'upsert',
            payload: jsonEncode({
              'student_id': studentId,
              'last_active_at': startedAt,
            }),
            createdAt: startedAt,
          ),
        );
      });

  Future<void> closeSession({
    required String sessionId,
    required String endedAt,
  }) =>
      transaction(() async {
        final affected =
            await (update(sessionsTable)
                  ..where((t) => t.id.equals(sessionId)))
                .write(SessionsTableCompanion(endedAt: Value(endedAt)));
        if (affected == 0) return;
        await into(syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: _uuid.v4(),
            entityType: 'session',
            entityId: sessionId,
            operation: 'upsert',
            payload: jsonEncode({
              'session_id': sessionId,
              'ended_at': endedAt,
            }),
            createdAt: endedAt,
          ),
        );
      });
}
