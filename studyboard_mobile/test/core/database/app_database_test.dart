import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  test('fresh install creates all 13 required tables', () async {
    final rows = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' "
          "AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'drift_%'",
        )
        .get();
    final names = rows.map((r) => r.data['name'] as String).toSet();

    expect(
      names,
      containsAll([
        'students',
        'subjects',
        'topics',
        'lessons',
        'lesson_tasks',
        'quiz_questions',
        'quiz_attempts',
        'past_paper_questions',
        'sync_queue',
        'sync_error_log',
        'survey_responses',
        'nudge_events',
        'sessions',
      ]),
    );
  });

  test('task_status CHECK constraint rejects invalid values', () async {
    final now = DateTime.now().toUtc().toIso8601String();
    await expectLater(
      db.into(db.lessonTasksTable).insert(
            LessonTasksTableCompanion.insert(
              id: 'test-id',
              studentId: 's1',
              lessonId: 'l1',
              taskStatus: const Value('INVALID'),
              createdAt: now,
              updatedAt: now,
            ),
          ),
      throwsA(anything),
    );
  });

  test('TaskStatus enum round-trips through toDbString/fromString', () {
    for (final status in TaskStatus.values) {
      final dbStr = status.toDbString();
      expect(TaskStatusX.fromString(dbStr), equals(status));
    }
  });

  test('sync_queue row can be inserted with all required fields', () async {
    final now = DateTime.now().toUtc().toIso8601String();
    await db.into(db.syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: 'sq-1',
            entityType: 'task_status',
            entityId: 'task-abc',
            operation: 'upsert',
            payload: '{"task_status":"done"}',
            createdAt: now,
          ),
        );
    final row = await db.select(db.syncQueueTable).getSingle();
    expect(row.id, equals('sq-1'));
    expect(row.entityType, equals('task_status'));
    expect(row.entityId, equals('task-abc'));
    expect(row.operation, equals('upsert'));
    expect(row.payload, equals('{"task_status":"done"}'));
    expect(row.retryCount, equals(0));
  });

  test('sessions attributed_nudge_id is nullable', () async {
    final now = DateTime.now().toUtc().toIso8601String();
    await db.into(db.sessionsTable).insert(
          SessionsTableCompanion.insert(
            id: 'sess-1',
            studentId: 's1',
            startedAt: now,
          ),
        );
    final row = await db.select(db.sessionsTable).getSingle();
    expect(row.attributedNudgeId, isNull);
  });
}
