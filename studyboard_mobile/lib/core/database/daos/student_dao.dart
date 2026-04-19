import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/students_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';
import 'package:uuid/uuid.dart';

part 'student_dao.g.dart';

const _uuid = Uuid();

@DriftAccessor(tables: [StudentsTable, SyncQueueTable])
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
  StudentDao(super.attachedDatabase);

  Future<StudentsTableData?> getStudent(String studentId) =>
      (select(studentsTable)..where((t) => t.id.equals(studentId)))
          .getSingleOrNull();

  Future<void> upsertStudent(StudentsTableCompanion companion) =>
      into(studentsTable).insertOnConflictUpdate(companion);

  Future<void> deactivate(String studentId) => transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        await (update(studentsTable)..where((t) => t.id.equals(studentId)))
            .write(StudentsTableCompanion(deactivatedAt: Value(now)));
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'student',
          entityId: studentId,
          operation: 'upsert',
          payload: jsonEncode({
            'student_id': studentId,
            'deactivated_at': now,
          }),
          createdAt: now,
        ));
      });

  Future<void> softDelete(String studentId) => transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        await (update(studentsTable)..where((t) => t.id.equals(studentId)))
            .write(StudentsTableCompanion(
          name: const Value('[deleted]'),
          email: const Value('[deleted]'),
          district: const Value('[deleted]'),
          school: const Value('[deleted]'),
          fcmToken: const Value(null),
          deletedAt: Value(now),
        ));
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'student',
          entityId: studentId,
          operation: 'soft_delete',
          payload: jsonEncode({'student_id': studentId}),
          createdAt: now,
        ));
      });

  Future<void> updateLastActiveAt(
    String studentId,
    String isoTimestamp,
  ) =>
      (update(studentsTable)..where((t) => t.id.equals(studentId)))
          .write(StudentsTableCompanion(lastActiveAt: Value(isoTimestamp)));

  Future<void> updateFcmToken(String studentId, String? fcmToken) =>
      transaction(() async {
        final notificationsEnabled = fcmToken != null;
        final now = DateTime.now().toUtc().toIso8601String();

        final rowsUpdated =
            await (update(studentsTable)..where((t) => t.id.equals(studentId)))
                .write(
          StudentsTableCompanion(
            fcmToken: Value(fcmToken),
            notificationsEnabled: Value(notificationsEnabled),
          ),
        );

        if (rowsUpdated == 0) return;

        await into(syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: _uuid.v4(),
            entityType: 'student',
            entityId: studentId,
            operation: 'upsert',
            payload: jsonEncode({
              'student_id': studentId,
              'fcm_token': fcmToken,
              'notifications_enabled': notificationsEnabled,
            }),
            createdAt: now,
          ),
        );
      });
}
