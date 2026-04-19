import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/quiz_attempts_table.dart';
import 'package:studyboard_mobile/core/database/tables/quiz_questions_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';
import 'package:uuid/uuid.dart';

part 'quiz_dao.g.dart';

const _uuid = Uuid();

@DriftAccessor(tables: [QuizQuestionsTable, QuizAttemptsTable, SyncQueueTable])
class QuizDao extends DatabaseAccessor<AppDatabase> with _$QuizDaoMixin {
  QuizDao(super.attachedDatabase);

  Future<List<QuizQuestionsTableData>> getQuestionsForLesson(
    String lessonId,
  ) =>
      (select(quizQuestionsTable)
            ..where((t) => t.lessonId.equals(lessonId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .get();

  Future<void> saveAttempt(QuizAttemptsTableCompanion companion) =>
      transaction(() async {
        await into(quizAttemptsTable).insert(companion);
        final now = DateTime.now().toUtc().toIso8601String();
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'quiz_attempt',
          entityId: companion.id.value,
          operation: 'upsert',
          payload: jsonEncode({
            'quiz_attempt_id': companion.id.value,
            'student_id': companion.studentId.value,
            'lesson_id': companion.lessonId.value,
          }),
          createdAt: now,
        ));
      });

  Future<List<QuizAttemptsTableData>> getAttemptsForLesson(
    String studentId,
    String lessonId,
  ) =>
      (select(quizAttemptsTable)
            ..where(
              (t) =>
                  t.studentId.equals(studentId) & t.lessonId.equals(lessonId),
            ))
          .get();
}
