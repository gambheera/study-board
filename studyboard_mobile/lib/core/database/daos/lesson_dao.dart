import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/lesson_tasks_table.dart';
import 'package:studyboard_mobile/core/database/tables/lessons_table.dart';
import 'package:studyboard_mobile/core/database/tables/past_paper_questions_table.dart';
import 'package:studyboard_mobile/core/database/tables/topics_table.dart';
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
    TopicsTable,
  ],
)
class LessonDao extends DatabaseAccessor<AppDatabase> with _$LessonDaoMixin {
  LessonDao(super.attachedDatabase);

  Future<LessonsTableData?> getLessonById(String lessonId) =>
      (select(lessonsTable)..where((t) => t.id.equals(lessonId)))
          .getSingleOrNull();

  Future<LessonTasksTableData?> getTaskById(String taskId) =>
      (select(lessonTasksTable)..where((t) => t.id.equals(taskId)))
          .getSingleOrNull();

  Future<({LessonsTableData lesson, TopicsTableData topic})?>
      getLessonWithTopicTitle(String lessonId) async {
    // innerJoin: returns null (not found) if the lesson's topicId has no
    // matching topic row — treat as a data-integrity failure, not missing lesson.
    final query = select(lessonsTable).join([
      innerJoin(
        topicsTable,
        topicsTable.id.equalsExp(lessonsTable.topicId),
      ),
    ])..where(lessonsTable.id.equals(lessonId));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return (
      lesson: row.readTable(lessonsTable),
      topic: row.readTable(topicsTable),
    );
  }

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
