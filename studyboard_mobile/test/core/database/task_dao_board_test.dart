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
    await db
        .into(db.subjectsTable)
        .insertOnConflictUpdate(
          SubjectsTableCompanion.insert(id: subjectId, name: 'A/L Chemistry'),
        );
    await db
        .into(db.topicsTable)
        .insertOnConflictUpdate(
          TopicsTableCompanion.insert(
            id: topicId,
            subjectId: subjectId,
            title: 'Topic $topicId',
            orderIndex: Value(topicOrder),
          ),
        );
    await db
        .into(db.lessonsTable)
        .insertOnConflictUpdate(
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

  group('watchTasksByStatus', () {
    test('returns only tasks with matching status and correct joins', () async {
      await seedSubjectTopicLesson();
      await taskDao.createLessonTasksForStudent('student-1', ['l1']);

      final tasks = await taskDao.watchBacklogTasks('student-1').first;
      await taskDao.pullToTodo(tasks.first.task.id);

      final rows = await taskDao
          .watchTasksByStatus('student-1', TaskStatus.todo)
          .first;

      expect(rows.length, 1);
      expect(rows.first.lesson.title, 'Lesson l1');
      expect(rows.first.topic.title, 'Topic t1');
      expect(rows.first.task.taskStatus, TaskStatus.todo.toDbString());
    });

    test('excludes tasks with different status', () async {
      await seedSubjectTopicLesson();
      await taskDao.createLessonTasksForStudent('student-1', ['l1']);

      final rows = await taskDao
          .watchTasksByStatus('student-1', TaskStatus.todo)
          .first;

      expect(rows, isEmpty);
    });

    test('emits updated list when task status changes', () async {
      await seedSubjectTopicLesson();
      await taskDao.createLessonTasksForStudent('student-1', ['l1']);

      final backlogTasks = await taskDao.watchBacklogTasks('student-1').first;
      await taskDao.pullToTodo(backlogTasks.first.task.id);

      final stream = taskDao.watchTasksByStatus('student-1', TaskStatus.todo);

      final initial = await stream.first;
      expect(initial.length, 1);

      await taskDao.startTask(initial.first.task.id);

      final updated = await stream.first;
      expect(updated, isEmpty);
    });
  });

  group('watchHasDoneTasks', () {
    test('returns false when no done tasks exist', () async {
      await seedSubjectTopicLesson();
      await taskDao.createLessonTasksForStudent('student-1', ['l1']);

      final result = await taskDao.watchHasDoneTasks('student-1').first;

      expect(result, isFalse);
    });

    test('returns true after markTaskComplete() is called', () async {
      await seedSubjectTopicLesson();
      await taskDao.createLessonTasksForStudent('student-1', ['l1']);

      final tasks = await taskDao.watchBacklogTasks('student-1').first;
      await taskDao.markTaskComplete(tasks.first.task.id);

      final result = await taskDao.watchHasDoneTasks('student-1').first;

      expect(result, isTrue);
    });
  });

  group('moveToBacklog', () {
    test(
      'writes backlog status to Drift and inserts sync queue entry',
      () async {
        await seedSubjectTopicLesson();
        await taskDao.createLessonTasksForStudent('student-1', ['l1']);

        final tasks = await taskDao.watchBacklogTasks('student-1').first;
        await taskDao.pullToTodo(tasks.first.task.id);
        final taskId = tasks.first.task.id;

        await taskDao.moveToBacklog(taskId);

        final backlog = await taskDao.watchBacklogTasks('student-1').first;
        expect(backlog.length, 1);
        expect(backlog.first.task.taskStatus, TaskStatus.backlog.toDbString());

        final syncEntries = await db.select(db.syncQueueTable).get();
        final moveEntry = syncEntries.firstWhere(
          (e) => e.entityId == taskId && e.entityType == 'task_status',
          orElse: () => throw StateError('No sync entry for moveToBacklog'),
        );
        expect(moveEntry.operation, 'upsert');
      },
    );

    test('is a no-op when taskId not found', () async {
      await taskDao.moveToBacklog('non-existent-task-id');

      final syncEntries = await db.select(db.syncQueueTable).get();
      expect(syncEntries, isEmpty);
    });
  });
}
