// mocktail's `when(() => mock.method())` pattern cannot use a tearoff
// because `T Function([String])` is not assignable to `T Function()`.
// ignore_for_file: unnecessary_lambdas
import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/content_dao.dart';
import 'package:studyboard_mobile/core/database/daos/task_dao.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/board/data/content_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class _MockContentDao extends Mock implements ContentDao {}

class _MockTaskDao extends Mock implements TaskDao {}

Future<void> _returnVoid(Invocation _) async {}

final class _FakeSelectResponse extends Fake
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  _FakeSelectResponse(this._data);

  final List<Map<String, dynamic>> _data;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(List<Map<String, dynamic>>) onValue, {
    Function? onError,
  }) => Future<List<Map<String, dynamic>>>.value(_data).then(onValue);

  @override
  Future<List<Map<String, dynamic>>> catchError(
    Function onError, {
    bool Function(Object)? test,
  }) => Future.value(_data);

  @override
  Future<List<Map<String, dynamic>>> whenComplete(
    FutureOr<void> Function() action,
  ) => Future.value(_data).whenComplete(action);

  @override
  Stream<List<Map<String, dynamic>>> asStream() => Stream.value(_data);

  @override
  Future<List<Map<String, dynamic>>> timeout(
    Duration timeLimit, {
    FutureOr<List<Map<String, dynamic>>> Function()? onTimeout,
  }) => Future.value(_data);
}

void main() {
  late AppDatabase db;
  late _MockSupabaseClient mockClient;
  late _MockContentDao mockContentDao;
  late _MockTaskDao mockTaskDao;
  late ContentRepositoryImpl repo;

  final subjectData = [
    {
      'id': 'sub-1',
      'name': 'A/L Chemistry',
      'quiz_pass_threshold': 0.8,
      'content_version': 1,
    },
  ];
  final topicData = [
    {
      'id': 'topic-1',
      'subject_id': 'sub-1',
      'title': 'Atomic Structure',
      'order_index': 1,
    },
  ];
  final lessonData = [
    {
      'id': 'lesson-a',
      'topic_id': 'topic-1',
      'title': 'Atomic Theory',
      'content_text': 'Atoms have nuclei.',
      'content_track': 'theory',
      'order_index': 1,
    },
    {
      'id': 'lesson-b',
      'topic_id': 'topic-1',
      'title': 'Atomic Past Papers',
      'content_text': 'Past paper questions.',
      'content_track': 'past_papers',
      'order_index': 2,
    },
  ];
  final quizData = [
    {
      'id': 'q-1',
      'lesson_id': 'lesson-a',
      'question_text': 'Q?',
      'option_a': 'A',
      'option_b': 'B',
      'option_c': 'C',
      'option_d': 'D',
      'correct_option': 'b',
      'order_index': 1,
    },
  ];
  final ppData = [
    {
      'id': 'pp-1',
      'lesson_id': 'lesson-b',
      'topic_id': 'topic-1',
      'question_text': 'Explain atomic radius.',
      'year': 2019,
      'order_index': 1,
    },
  ];

  void stubSuccessfulCalls({
    List<Map<String, dynamic>>? subjects,
    List<Map<String, dynamic>>? topics,
    List<Map<String, dynamic>>? lessons,
    List<Map<String, dynamic>>? quizQuestions,
    List<Map<String, dynamic>>? pastPaperQuestions,
  }) {
    final sqb = _MockSupabaseQueryBuilder();
    final tqb = _MockSupabaseQueryBuilder();
    final lqb = _MockSupabaseQueryBuilder();
    final qqb = _MockSupabaseQueryBuilder();
    final pqb = _MockSupabaseQueryBuilder();

    when(() => mockClient.from('subjects')).thenAnswer((_) => sqb);
    when(() => mockClient.from('topics')).thenAnswer((_) => tqb);
    when(() => mockClient.from('lessons')).thenAnswer((_) => lqb);
    when(() => mockClient.from('quiz_questions')).thenAnswer((_) => qqb);
    when(() => mockClient.from('past_paper_questions')).thenAnswer((_) => pqb);

    final sData = subjects ?? subjectData;
    final tData = topics ?? topicData;
    final lData = lessons ?? lessonData;
    final qData = quizQuestions ?? quizData;
    final pData = pastPaperQuestions ?? ppData;

    when(() => sqb.select()).thenAnswer((_) => _FakeSelectResponse(sData));
    when(() => tqb.select()).thenAnswer((_) => _FakeSelectResponse(tData));
    when(() => lqb.select()).thenAnswer((_) => _FakeSelectResponse(lData));
    when(() => qqb.select()).thenAnswer((_) => _FakeSelectResponse(qData));
    when(() => pqb.select()).thenAnswer((_) => _FakeSelectResponse(pData));
  }

  setUpAll(() {
    registerFallbackValue(const SubjectsTableCompanion());
    registerFallbackValue(const TopicsTableCompanion());
    registerFallbackValue(const LessonsTableCompanion());
    registerFallbackValue(const QuizQuestionsTableCompanion());
    registerFallbackValue(const PastPaperQuestionsTableCompanion());
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    mockClient = _MockSupabaseClient();
    mockContentDao = _MockContentDao();
    mockTaskDao = _MockTaskDao();
    repo = ContentRepositoryImpl(mockClient, db, mockContentDao, mockTaskDao);

    when(
      () => mockContentDao.upsertSubject(any()),
    ).thenAnswer(_returnVoid);
    when(() => mockContentDao.upsertTopic(any())).thenAnswer(_returnVoid);
    when(() => mockContentDao.upsertLesson(any())).thenAnswer(_returnVoid);
    when(
      () => mockContentDao.upsertQuizQuestion(any()),
    ).thenAnswer(_returnVoid);
    when(
      () => mockContentDao.upsertPastPaperQuestion(any()),
    ).thenAnswer(_returnVoid);
    when(
      () => mockTaskDao.createLessonTasksForStudent(any(), any()),
    ).thenAnswer(_returnVoid);
  });

  tearDown(() async => db.close());

  group('ContentRepositoryImpl.syncContent — success path', () {
    test('returns Right(unit) when all Supabase calls succeed', () async {
      stubSuccessfulCalls();

      final result = await repo.syncContent('student-1');

      expect(result, const Right<Failure, Unit>(unit));
    });

    test(
      'calls createLessonTasksForStudent with correct student ID and '
      'lesson IDs from the Supabase lessons response',
      () async {
        stubSuccessfulCalls();

        await repo.syncContent('student-1');

        verify(
          () => mockTaskDao.createLessonTasksForStudent(
            'student-1',
            ['lesson-a', 'lesson-b'],
          ),
        ).called(1);
      },
    );

    test('upserts each content type to Drift once per row', () async {
      stubSuccessfulCalls();

      await repo.syncContent('student-1');

      verify(() => mockContentDao.upsertSubject(any())).called(1);
      verify(() => mockContentDao.upsertTopic(any())).called(1);
      verify(() => mockContentDao.upsertLesson(any())).called(2);
      verify(() => mockContentDao.upsertQuizQuestion(any())).called(1);
      verify(() => mockContentDao.upsertPastPaperQuestion(any())).called(1);
    });

    test(
      'skips createLessonTasksForStudent when lessons list is empty',
      () async {
        stubSuccessfulCalls(lessons: []);

        await repo.syncContent('student-1');

        verifyNever(
          () => mockTaskDao.createLessonTasksForStudent(any(), any()),
        );
      },
    );
  });

  group('ContentRepositoryImpl.syncContent — failure path', () {
    test(
      'returns Left(DatabaseFailure) when Supabase throws '
      'PostgrestException',
      () async {
        when(() => mockClient.from(any())).thenThrow(
          const PostgrestException(message: 'connection error'),
        );

        final result = await repo.syncContent('student-1');

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f, isA<DatabaseFailure>()),
          (_) => fail('Expected Left(DatabaseFailure)'),
        );
      },
    );

    test(
      'returns Left(NetworkFailure) when Supabase throws a generic exception',
      () async {
        when(() => mockClient.from(any())).thenThrow(
          Exception('network error'),
        );

        final result = await repo.syncContent('student-1');

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f, isA<NetworkFailure>()),
          (_) => fail('Expected Left(NetworkFailure)'),
        );
      },
    );
  });
}
