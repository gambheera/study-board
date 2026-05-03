import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/task_dao.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

void main() {
  late AppDatabase db;
  late TaskDao taskDao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    taskDao = db.taskDao;
  });

  tearDown(() async => db.close());

  Future<void> seedSubjectTopicLesson({
    String subjectId = 's1',
    String topicId = 't1',
    String lessonId = 'l1',
    String contentTrack = 'theory',
    int topicOrder = 0,
    int lessonOrder = 0,
  }) async {
    await db.into(db.subjectsTable).insertOnConflictUpdate(
          SubjectsTableCompanion.insert(id: subjectId, name: 'A/L Chemistry'),
        );
    await db.into(db.topicsTable).insertOnConflictUpdate(
          TopicsTableCompanion.insert(
            id: topicId,
            subjectId: subjectId,
            title: 'Topic $topicId',
            orderIndex: Value(topicOrder),
          ),
        );
    await db.into(db.lessonsTable).insertOnConflictUpdate(
          LessonsTableCompanion.insert(
            id: lessonId,
            topicId: topicId,
            title: 'Lesson $lessonId',
            contentText: 'text',
            contentTrack: contentTrack,
            orderIndex: Value(lessonOrder),
          ),
        );
  }

  group('watchBacklogTasks', () {
    test('returns backlog tasks with correct lesson and topic joins', () async {
      await seedSubjectTopicLesson();
      await taskDao.createLessonTasksForStudent('student-1', ['l1']);

      final rows = await taskDao.watchBacklogTasks('student-1').first;

      expect(rows.length, 1);
      expect(rows.first.lesson.title, 'Lesson l1');
      expect(rows.first.topic.title, 'Topic t1');
      expect(rows.first.task.taskStatus, TaskStatus.backlog.toDbString());
    });

    test('excludes tasks not in backlog status', () async {
      await seedSubjectTopicLesson();
      await taskDao.createLessonTasksForStudent('student-1', ['l1']);

      final created = await taskDao.watchBacklogTasks('student-1').first;
      expect(created.length, 1);

      await taskDao.pullToTodo(created.first.task.id);

      final rows = await taskDao.watchBacklogTasks('student-1').first;
      expect(rows, isEmpty);
    });

    test('excludes tasks from a different student', () async {
      await seedSubjectTopicLesson();
      await taskDao.createLessonTasksForStudent('student-1', ['l1']);

      final rows = await taskDao.watchBacklogTasks('student-2').first;
      expect(rows, isEmpty);
    });

    test('filters by contentTrack when provided', () async {
      await seedSubjectTopicLesson();
      await seedSubjectTopicLesson(
        topicId: 't2',
        lessonId: 'l2',
        contentTrack: 'past_papers',
      );
      await taskDao.createLessonTasksForStudent('student-1', ['l1', 'l2']);

      final theory = await taskDao
          .watchBacklogTasks('student-1', contentTrack: 'theory')
          .first;
      expect(theory.length, 1);
      expect(theory.first.lesson.contentTrack, 'theory');

      final pastPapers = await taskDao
          .watchBacklogTasks('student-1', contentTrack: 'past_papers')
          .first;
      expect(pastPapers.length, 1);
      expect(pastPapers.first.lesson.contentTrack, 'past_papers');
    });

    test('emits updated list when task status changes', () async {
      await seedSubjectTopicLesson();
      await seedSubjectTopicLesson(
        topicId: 't2',
        lessonId: 'l2',
        topicOrder: 1,
      );
      await taskDao.createLessonTasksForStudent('student-1', ['l1', 'l2']);

      final stream = taskDao.watchBacklogTasks('student-1');

      final initial = await stream.first;
      expect(initial.length, 2);

      await taskDao.pullToTodo(initial.first.task.id);

      final updated = await stream.first;
      expect(updated.length, 1);
    });

    test('orders results by topicOrderIndex then lessonOrderIndex', () async {
      await seedSubjectTopicLesson(topicOrder: 1, lessonOrder: 2);
      await seedSubjectTopicLesson(
        lessonId: 'l2',
        topicOrder: 1,
        lessonOrder: 1,
      );
      await seedSubjectTopicLesson(topicId: 't2', lessonId: 'l3');
      await taskDao
          .createLessonTasksForStudent('student-1', ['l1', 'l2', 'l3']);

      final rows = await taskDao.watchBacklogTasks('student-1').first;
      expect(rows.length, 3);
      expect(rows[0].lesson.id, 'l3'); // topic order 0
      expect(rows[1].lesson.id, 'l2'); // topic order 1, lesson order 1
      expect(rows[2].lesson.id, 'l1'); // topic order 1, lesson order 2
    });
  });
}
