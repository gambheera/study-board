import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/lesson_dao.dart';
import 'package:studyboard_mobile/features/lesson/data/lesson_repository_impl.dart';

class _MockLessonDao extends Mock implements LessonDao {}

void main() {
  late _MockLessonDao mockDao;
  late LessonRepositoryImpl repository;

  setUp(() {
    mockDao = _MockLessonDao();
    repository = LessonRepositoryImpl(mockDao);
  });

  LessonTasksTableData _fakeTask({bool curiosityCompleted = false}) =>
      LessonTasksTableData(
        id: 'task-1',
        studentId: 'stu-1',
        lessonId: 'lesson-1',
        taskStatus: 'in_progress',
        curiosityCompleted: curiosityCompleted,
        createdAt: '2026-01-01T00:00:00.000Z',
        updatedAt: '2026-01-01T00:00:00.000Z',
      );

  LessonsTableData _fakeLesson() => LessonsTableData(
        id: 'lesson-1',
        topicId: 'topic-1',
        title: 'Atomic Structure',
        contentText: 'Content here',
        contentTrack: 'theory',
        orderIndex: 0,
      );

  TopicsTableData _fakeTopic() => TopicsTableData(
        id: 'topic-1',
        subjectId: 'subj-1',
        title: 'Structure of Atom',
        orderIndex: 0,
      );

  PastPaperQuestionsTableData _fakeQuestion({int orderIndex = 0}) =>
      PastPaperQuestionsTableData(
        id: 'q-$orderIndex',
        lessonId: 'lesson-1',
        topicId: 'topic-1',
        questionText: 'What is the atomic number of Carbon?',
        year: 2023,
        orderIndex: orderIndex,
      );

  group('LessonRepositoryImpl.getLessonDetails', () {
    test('returns LessonDetails with correct fields from Drift', () async {
      when(() => mockDao.getTaskById('task-1'))
          .thenAnswer((_) async => _fakeTask());
      when(() => mockDao.getLessonWithTopicTitle('lesson-1')).thenAnswer(
        (_) async => (lesson: _fakeLesson(), topic: _fakeTopic()),
      );
      when(() => mockDao.getPastPaperQuestionsForLesson('lesson-1'))
          .thenAnswer((_) async => [_fakeQuestion()]);

      final result = await repository.getLessonDetails('task-1');

      expect(result.taskId, equals('task-1'));
      expect(result.lessonId, equals('lesson-1'));
      expect(result.lessonTitle, equals('Atomic Structure'));
      expect(result.topicTitle, equals('Structure of Atom'));
      expect(
        result.questionText,
        equals('What is the atomic number of Carbon?'),
      );
      expect(result.curiosityCompleted, isFalse);
    });

    test('uses first past paper question as questionText', () async {
      when(() => mockDao.getTaskById('task-1'))
          .thenAnswer((_) async => _fakeTask());
      when(() => mockDao.getLessonWithTopicTitle('lesson-1')).thenAnswer(
        (_) async => (lesson: _fakeLesson(), topic: _fakeTopic()),
      );
      when(() => mockDao.getPastPaperQuestionsForLesson('lesson-1'))
          .thenAnswer(
        (_) async => [
          _fakeQuestion(orderIndex: 0),
          PastPaperQuestionsTableData(
            id: 'q-1',
            lessonId: 'lesson-1',
            topicId: 'topic-1',
            questionText: 'Second question — should not be used',
            year: 2022,
            orderIndex: 1,
          ),
        ],
      );

      final result = await repository.getLessonDetails('task-1');

      expect(
        result.questionText,
        equals('What is the atomic number of Carbon?'),
      );
    });

    test('throws StateError when task not found', () async {
      when(() => mockDao.getTaskById('missing-task'))
          .thenAnswer((_) async => null);

      await expectLater(
        repository.getLessonDetails('missing-task'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when lesson not found for task', () async {
      when(() => mockDao.getTaskById('task-1'))
          .thenAnswer((_) async => _fakeTask());
      when(() => mockDao.getLessonWithTopicTitle('lesson-1'))
          .thenAnswer((_) async => null);

      await expectLater(
        repository.getLessonDetails('task-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('returns empty questionText when no past paper questions exist',
        () async {
      when(() => mockDao.getTaskById('task-1'))
          .thenAnswer((_) async => _fakeTask());
      when(() => mockDao.getLessonWithTopicTitle('lesson-1')).thenAnswer(
        (_) async => (lesson: _fakeLesson(), topic: _fakeTopic()),
      );
      when(() => mockDao.getPastPaperQuestionsForLesson('lesson-1'))
          .thenAnswer((_) async => []);

      final result = await repository.getLessonDetails('task-1');

      expect(result.questionText, equals(''));
    });
  });

  group('LessonRepositoryImpl.setCuriosityCompleted', () {
    test('delegates to dao.setCuriosityCompleted', () async {
      when(() => mockDao.setCuriosityCompleted('task-1'))
          .thenAnswer((_) async {});

      await repository.setCuriosityCompleted('task-1');

      verify(() => mockDao.setCuriosityCompleted('task-1')).called(1);
    });
  });
}
