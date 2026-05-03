import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/student_subjects_table.dart';
import 'package:studyboard_mobile/core/database/tables/students_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';
import 'package:uuid/uuid.dart';

part 'student_dao.g.dart';

const _uuid = Uuid();

@DriftAccessor(tables: [StudentsTable, SyncQueueTable, StudentSubjectsTable])
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

  Future<void> deleteStudent(String id) => transaction(() async {
        await (delete(studentSubjectsTable)
              ..where((t) => t.studentId.equals(id)))
            .go();
        await (delete(studentsTable)..where((s) => s.id.equals(id))).go();
      });

  Future<void> updateLastActiveAt(
    String studentId,
    String isoTimestamp,
  ) =>
      transaction(() async {
        await (update(studentsTable)..where((t) => t.id.equals(studentId)))
            .write(StudentsTableCompanion(lastActiveAt: Value(isoTimestamp)));
        await into(syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: _uuid.v4(),
            entityType: 'student',
            entityId: studentId,
            operation: 'upsert',
            payload: jsonEncode({
              'student_id': studentId,
              'last_active_at': isoTimestamp,
            }),
            createdAt: isoTimestamp,
          ),
        );
      });

  Future<void> updateProfileFields(
    String studentId, {
    required String district,
    required String school,
  }) =>
      transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        await (update(studentsTable)..where((t) => t.id.equals(studentId)))
            .write(StudentsTableCompanion(
          district: Value(district),
          school: Value(school),
          lastActiveAt: Value(now),
        ));
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'student',
          entityId: studentId,
          operation: 'upsert',
          payload: jsonEncode({
            'student_id': studentId,
            'district': district,
            'school': school,
            'last_active_at': now,
          }),
          createdAt: now,
        ));
      });

  Future<void> setEnrolledSubjects(
    String studentId,
    List<String> subjectNames,
  ) =>
      transaction(() async {
        await (delete(studentSubjectsTable)
              ..where((t) => t.studentId.equals(studentId)))
            .go();
        for (final name in subjectNames) {
          await into(studentSubjectsTable).insert(
            StudentSubjectsTableCompanion.insert(
              studentId: studentId,
              subjectName: name,
            ),
          );
        }
      });

  /// Atomically updates district/school and subject enrollment in one transaction.
  /// Enqueues a sync-queue entry for the profile fields.
  Future<void> updateProfileWithSubjects(
    String studentId, {
    required String district,
    required String school,
    required List<String> subjectNames,
  }) =>
      transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        await (update(studentsTable)..where((t) => t.id.equals(studentId)))
            .write(StudentsTableCompanion(
          district: Value(district),
          school: Value(school),
          lastActiveAt: Value(now),
        ));
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'student',
          entityId: studentId,
          operation: 'upsert',
          payload: jsonEncode({
            'student_id': studentId,
            'district': district,
            'school': school,
            'last_active_at': now,
          }),
          createdAt: now,
        ));
        await (delete(studentSubjectsTable)
              ..where((t) => t.studentId.equals(studentId)))
            .go();
        for (final name in subjectNames) {
          await into(studentSubjectsTable).insert(
            StudentSubjectsTableCompanion.insert(
              studentId: studentId,
              subjectName: name,
            ),
          );
        }
      });

  Future<void> updateStudentProfile(
    String studentId, {
    required String name,
    required String district,
    required String school,
  }) =>
      transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        await (update(studentsTable)..where((t) => t.id.equals(studentId)))
            .write(StudentsTableCompanion(
          name: Value(name),
          district: Value(district),
          school: Value(school),
          lastActiveAt: Value(now),
        ));
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'student',
          entityId: studentId,
          operation: 'upsert',
          payload: jsonEncode({
            'student_id': studentId,
            'name': name,
            'district': district,
            'school': school,
            'last_active_at': now,
          }),
          createdAt: now,
        ));
      });

  Future<List<String>> getEnrolledSubjectNames(String studentId) async {
    final rows = await (select(studentSubjectsTable)
          ..where((t) => t.studentId.equals(studentId)))
        .get();
    return rows.map((r) => r.subjectName).toList();
  }

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
