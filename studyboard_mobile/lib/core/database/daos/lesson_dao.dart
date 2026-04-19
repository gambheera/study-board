import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/lesson_tasks_table.dart';
import 'package:studyboard_mobile/core/database/tables/lessons_table.dart';
import 'package:studyboard_mobile/core/database/tables/past_paper_questions_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';
import 'package:uuid/uuid.dart';

part 'lesson_dao.g.dart';

const _uuid = Uuid();

@DriftAccessor(
  tables: [
    LessonsTable,
    PastPaperQuestionsTable,
    LessonTasksTable,
    SyncQueueTable,
  ],
)
class LessonDao extends DatabaseAccessor<AppDatabase> with _$LessonDaoMixin {
  LessonDao(super.attachedDatabase);

  Future<LessonsTableData?> getLessonById(String lessonId) =>
      (select(lessonsTable)..where((t) => t.id.equals(lessonId)))
          .getSingleOrNull();

  Future<List<PastPaperQuestionsTableData>> getPastPaperQuestionsForLesson(
    String lessonId,
  ) =>
      (select(pastPaperQuestionsTable)
            ..where((t) => t.lessonId.equals(lessonId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .get();

  Future<void> setCuriosityCompleted(String taskId) => transaction(() async {
        final now = DateTime.now().toUtc().toIso8601String();
        await (update(lessonTasksTable)..where((t) => t.id.equals(taskId)))
            .write(LessonTasksTableCompanion(
          curiosityCompleted: const Value(true),
          updatedAt: Value(now),
        ));
        await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'task_status',
          entityId: taskId,
          operation: 'upsert',
          payload: jsonEncode({
            'curiosity_completed': true,
            'task_id': taskId,
          }),
          createdAt: now,
        ));
      });
}
