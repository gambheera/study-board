import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  Future<void> insertStudent(String studentId) async {
    const now = '2026-01-01T00:00:00.000Z';
    await db.into(db.studentsTable).insertOnConflictUpdate(
          StudentsTableCompanion.insert(
            id: studentId,
            name: 'Test Student',
            email: 'test@example.com',
            district: 'Colombo',
            school: 'RC',
            lastActiveAt: now,
            createdAt: now,
          ),
        );
  }

  group('SessionDao.openSession', () {
    test('inserts session row with correct fields and null endedAt', () async {
      await insertStudent('stu-1');
      final dao = db.sessionDao;
      const sessionId = 'sess-abc';
      const studentId = 'stu-1';
      const startedAt = '2026-04-28T10:00:00.000Z';

      await dao.openSession(
        sessionId: sessionId,
        studentId: studentId,
        startedAt: startedAt,
      );

      final row = await db.select(db.sessionsTable).getSingle();
      expect(row.id, equals(sessionId));
      expect(row.studentId, equals(studentId));
      expect(row.startedAt, equals(startedAt));
      expect(row.endedAt, isNull);
      expect(row.attributedNudgeId, isNull);
    });

    test('enqueues exactly 2 sync queue entries', () async {
      await insertStudent('stu-1');
      final dao = db.sessionDao;

      await dao.openSession(
        sessionId: 'sess-1',
        studentId: 'stu-1',
        startedAt: '2026-04-28T10:00:00.000Z',
      );

      final entries = await db.select(db.syncQueueTable).get();
      expect(entries.length, equals(2));
      final types = entries.map((e) => e.entityType).toSet();
      expect(types, containsAll(['session', 'student']));
    });

    test('enqueues session sync entry with correct payload', () async {
      await insertStudent('stu-1');
      final dao = db.sessionDao;
      const sessionId = 'sess-2';
      const studentId = 'stu-1';
      const startedAt = '2026-04-28T11:00:00.000Z';

      await dao.openSession(
        sessionId: sessionId,
        studentId: studentId,
        startedAt: startedAt,
      );

      final entries = await db.select(db.syncQueueTable).get();
      final sessionEntry =
          entries.firstWhere((e) => e.entityType == 'session');
      final payload =
          jsonDecode(sessionEntry.payload) as Map<String, dynamic>;
      expect(payload['session_id'], equals(sessionId));
      expect(payload['student_id'], equals(studentId));
      expect(payload['started_at'], equals(startedAt));
    });

    test('updates student lastActiveAt', () async {
      await insertStudent('stu-1');
      final dao = db.sessionDao;
      const startedAt = '2026-04-28T12:00:00.000Z';

      await dao.openSession(
        sessionId: 'sess-3',
        studentId: 'stu-1',
        startedAt: startedAt,
      );

      final student = await (db.select(db.studentsTable)
            ..where((t) => t.id.equals('stu-1')))
          .getSingle();
      expect(student.lastActiveAt, equals(startedAt));
    });
  });

  group('SessionDao.closeSession', () {
    test('updates endedAt on matching session row', () async {
      await insertStudent('stu-1');
      final dao = db.sessionDao;
      const sessionId = 'sess-close-1';
      const startedAt = '2026-04-28T10:00:00.000Z';
      const endedAt = '2026-04-28T10:30:00.000Z';

      await dao.openSession(
        sessionId: sessionId,
        studentId: 'stu-1',
        startedAt: startedAt,
      );

      await db.delete(db.syncQueueTable).go();

      await dao.closeSession(sessionId: sessionId, endedAt: endedAt);

      final row = await (db.select(db.sessionsTable)
            ..where((t) => t.id.equals(sessionId)))
          .getSingle();
      expect(row.endedAt, equals(endedAt));
    });

    test('enqueues 1 sync entry with ended_at in payload', () async {
      await insertStudent('stu-1');
      final dao = db.sessionDao;
      const sessionId = 'sess-close-2';
      const endedAt = '2026-04-28T11:00:00.000Z';

      await dao.openSession(
        sessionId: sessionId,
        studentId: 'stu-1',
        startedAt: '2026-04-28T10:00:00.000Z',
      );

      await db.delete(db.syncQueueTable).go();

      await dao.closeSession(sessionId: sessionId, endedAt: endedAt);

      final entries = await db.select(db.syncQueueTable).get();
      expect(entries.length, equals(1));
      final payload =
          jsonDecode(entries.first.payload) as Map<String, dynamic>;
      expect(payload['ended_at'], equals(endedAt));
      expect(payload['session_id'], equals(sessionId));
    });

    test('is a no-op when session id not found', () async {
      final dao = db.sessionDao;

      await dao.closeSession(
        sessionId: 'nonexistent-session',
        endedAt: '2026-04-28T11:00:00.000Z',
      );

      final sessions = await db.select(db.sessionsTable).get();
      final syncEntries = await db.select(db.syncQueueTable).get();
      expect(sessions, isEmpty);
      expect(syncEntries, isEmpty);
    });
  });
}
