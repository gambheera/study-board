import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/content_dao.dart';
import 'package:studyboard_mobile/core/database/daos/task_dao.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/core/supabase/repository_base.dart';
import 'package:studyboard_mobile/features/board/domain/content_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContentRepositoryImpl extends RepositoryBase
    implements ContentRepository {
  ContentRepositoryImpl(
    this._client,
    this._db,
    this._contentDao,
    this._taskDao,
  );

  final SupabaseClient _client;
  final AppDatabase _db;
  final ContentDao _contentDao;
  final TaskDao _taskDao;

  @override
  Future<Either<Failure, Unit>> syncContent(String studentId) async {
    return trySupabase(() async {
      final subjects = await _client.from('subjects').select();
      final topics = await _client.from('topics').select();
      final lessons = await _client.from('lessons').select();
      final quizQs = await _client.from('quiz_questions').select();
      final ppQs = await _client.from('past_paper_questions').select();

      final lessonIds = lessons.map((l) => l['id'] as String).toList();

      await _db.transaction(() async {
        for (final s in subjects) {
          await _contentDao.upsertSubject(
            SubjectsTableCompanion.insert(
              id: s['id'] as String,
              name: s['name'] as String,
              quizPassThreshold: Value(
                (s['quiz_pass_threshold'] as num?)?.toDouble() ?? 0.8,
              ),
              contentVersion: Value((s['content_version'] as int?) ?? 1),
            ),
          );
        }

        for (final t in topics) {
          await _contentDao.upsertTopic(
            TopicsTableCompanion.insert(
              id: t['id'] as String,
              subjectId: t['subject_id'] as String,
              title: t['title'] as String,
              orderIndex: Value((t['order_index'] as int?) ?? 0),
            ),
          );
        }

        for (final l in lessons) {
          await _contentDao.upsertLesson(
            LessonsTableCompanion.insert(
              id: l['id'] as String,
              topicId: l['topic_id'] as String,
              title: l['title'] as String,
              contentText: l['content_text'] as String,
              contentTrack: l['content_track'] as String,
              orderIndex: Value((l['order_index'] as int?) ?? 0),
            ),
          );
        }

        for (final q in quizQs) {
          await _contentDao.upsertQuizQuestion(
            QuizQuestionsTableCompanion.insert(
              id: q['id'] as String,
              lessonId: q['lesson_id'] as String,
              questionText: q['question_text'] as String,
              optionA: q['option_a'] as String,
              optionB: q['option_b'] as String,
              optionC: q['option_c'] as String,
              optionD: q['option_d'] as String,
              correctOption: q['correct_option'] as String,
              orderIndex: Value((q['order_index'] as int?) ?? 0),
            ),
          );
        }

        for (final q in ppQs) {
          await _contentDao.upsertPastPaperQuestion(
            PastPaperQuestionsTableCompanion.insert(
              id: q['id'] as String,
              lessonId: q['lesson_id'] as String,
              topicId: q['topic_id'] as String,
              questionText: q['question_text'] as String,
              year: Value(q['year'] as int?),
              orderIndex: Value((q['order_index'] as int?) ?? 0),
            ),
          );
        }

        if (lessonIds.isNotEmpty) {
          await _taskDao.createLessonTasksForStudent(studentId, lessonIds);
        }
      });

      return unit;
    });
  }
}
