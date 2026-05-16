import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/quiz_dao.dart';
import 'package:studyboard_mobile/core/database/daos/task_dao.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/quiz/data/quiz_repository_impl.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_question.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_repository.dart';
import 'package:studyboard_mobile/features/quiz/presentation/quiz_notifier.dart';
import 'package:studyboard_mobile/features/quiz/presentation/quiz_state.dart';

class _MockQuizRepository extends Mock implements QuizRepository {}

class MockTaskDao extends Mock implements TaskDao {}

class MockQuizDao extends Mock implements QuizDao {}

class FakeAuthNotifier extends AuthNotifier {
  @override
  Future<AuthState> build() async =>
      const AuthState.authenticated(student: _fakeStudent);
}

const _fakeStudent = Student(
  id: 'student-1',
  name: 'Test Student',
  email: 'test@test.com',
  district: 'Test District',
  school: 'Test School',
  notificationsEnabled: false,
  lastActiveAt: '2026-01-01T00:00:00.000Z',
  createdAt: '2026-01-01T00:00:00.000Z',
);

List<QuizQuestion> _stubQuestions() => [
      const QuizQuestion(
        id: 'q1',
        lessonId: 'lesson-1',
        questionText: 'Q1',
        optionA: 'A1',
        optionB: 'B1',
        optionC: 'C1',
        optionD: 'D1',
        correctOption: 'a',
        orderIndex: 0,
      ),
      const QuizQuestion(
        id: 'q2',
        lessonId: 'lesson-1',
        questionText: 'Q2',
        optionA: 'A2',
        optionB: 'B2',
        optionC: 'C2',
        optionD: 'D2',
        correctOption: 'b',
        orderIndex: 1,
      ),
      const QuizQuestion(
        id: 'q3',
        lessonId: 'lesson-1',
        questionText: 'Q3',
        optionA: 'A3',
        optionB: 'B3',
        optionC: 'C3',
        optionD: 'D3',
        correctOption: 'c',
        orderIndex: 2,
      ),
      const QuizQuestion(
        id: 'q4',
        lessonId: 'lesson-1',
        questionText: 'Q4',
        optionA: 'A4',
        optionB: 'B4',
        optionC: 'C4',
        optionD: 'D4',
        correctOption: 'd',
        orderIndex: 3,
      ),
    ];

QuizData _stubQuizData() => (
      questions: _stubQuestions(),
      passThreshold: 0.8,
      lessonId: 'lesson-1',
      lessonTitle: 'Test Lesson',
    );

void main() {
  late _MockQuizRepository mockRepo;
  late MockTaskDao mockTaskDao;
  late MockQuizDao mockQuizDao;

  setUpAll(() {
    registerFallbackValue(
      QuizAttemptsTableCompanion.insert(
        id: '',
        studentId: '',
        lessonId: '',
        score: 0,
        passed: false,
        attemptedAt: '',
      ),
    );
  });

  setUp(() {
    mockRepo = _MockQuizRepository();
    mockTaskDao = MockTaskDao();
    mockQuizDao = MockQuizDao();

    when(() => mockTaskDao.markTaskComplete(any()))
        .thenAnswer((_) async {});
    when(() => mockTaskDao.resetTaskToInProgress(any()))
        .thenAnswer((_) async {});
    when(() => mockQuizDao.saveAttempt(any())).thenAnswer((_) async {});
    when(() => mockQuizDao.getAttemptsForLesson(any(), any()))
        .thenAnswer((_) async => []);
  });

  ProviderContainer makeContainer() => ProviderContainer(
        overrides: [
          quizRepositoryProvider.overrideWithValue(mockRepo),
          taskDaoProvider.overrideWithValue(mockTaskDao),
          quizDaoProvider.overrideWithValue(mockQuizDao),
          authProvider.overrideWith(FakeAuthNotifier.new),
        ],
        // Disable Riverpod 3.x's default exponential-backoff retry so that
        // async build failures settle immediately into AsyncError in tests.
        retry: (_, _) => null,
      );

  group('QuizNotifier.build', () {
    test(
      'loads quiz and returns QuizActive with currentIndex 0 and '
      'empty selectedAnswers',
      () async {
        when(() => mockRepo.loadQuiz('task-1'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        final state = await container.read(quizProvider('task-1').future);

        expect(state, isA<QuizActive>());
        final active = state as QuizActive;
        expect(active.currentIndex, equals(0));
        expect(active.selectedAnswers, isEmpty);
        expect(active.questions.length, equals(4));
        expect(active.passThreshold, equals(0.8));
        expect(active.lessonId, equals('lesson-1'));
        expect(active.lessonTitle, equals('Test Lesson'));
      },
    );

    test('throws Exception when loadQuiz returns Left(Failure)', () async {
      when(() => mockRepo.loadQuiz('task-err'))
          .thenAnswer((_) async => const Left(DatabaseFailure('not found')));

      final container = makeContainer();
      addTearDown(container.dispose);

      // Keep the autoDispose provider alive while the future is awaited.
      final sub = container.listen(quizProvider('task-err'), (_, _) {});
      addTearDown(sub.close);

      await expectLater(
        container.read(quizProvider('task-err').future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('QuizNotifier.selectAnswer', () {
    test(
      'sets selectedAnswers[0] for first question without advancing index',
      () async {
        when(() => mockRepo.loadQuiz('task-1'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(quizProvider('task-1').future);
        container.read(quizProvider('task-1').notifier).selectAnswer('a');

        final state = container.read(quizProvider('task-1')).value;
        expect(state, isA<QuizActive>());
        final active = state! as QuizActive;
        expect(active.selectedAnswers[0], equals('a'));
        expect(active.currentIndex, equals(0));
      },
    );

    test(
      'is idempotent — second call on already-answered question does nothing',
      () async {
        when(() => mockRepo.loadQuiz('task-1'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(quizProvider('task-1').future);
        container.read(quizProvider('task-1').notifier).selectAnswer('a');
        container.read(quizProvider('task-1').notifier).selectAnswer('b');

        final state = container.read(quizProvider('task-1')).value;
        final active = state! as QuizActive;
        expect(active.selectedAnswers[0], equals('a'));
      },
    );
  });

  group('QuizNotifier.advanceOrComplete', () {
    test('does nothing when no answer is selected', () async {
      when(() => mockRepo.loadQuiz('task-1'))
          .thenAnswer((_) async => Right(_stubQuizData()));

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(quizProvider('task-1').future);
      unawaited(
        container.read(quizProvider('task-1').notifier).advanceOrComplete(),
      );

      final state = container.read(quizProvider('task-1')).value;
      final active = state! as QuizActive;
      expect(active.currentIndex, equals(0));
    });

    test(
      'increments currentIndex when answer selected and not last question',
      () async {
        when(() => mockRepo.loadQuiz('task-1'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(quizProvider('task-1').future);
        container.read(quizProvider('task-1').notifier).selectAnswer('a');
        unawaited(
          container
              .read(quizProvider('task-1').notifier)
              .advanceOrComplete(),
        );

        final state = container.read(quizProvider('task-1')).value;
        final active = state! as QuizActive;
        expect(active.currentIndex, equals(1));
      },
    );

    test(
      'emits QuizCompleted when answer selected on last question',
      () async {
        when(() => mockRepo.loadQuiz('task-1'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(authProvider.future);
        await container.read(quizProvider('task-1').future);

        // Answer all 4 questions and advance through them
        // Correct: a,b,c,d — answer all 'a' → score=1/4=0.25 < 0.8 → not passed
        for (var i = 0; i < 3; i++) {
          container.read(quizProvider('task-1').notifier).selectAnswer('a');
          unawaited(
            container
                .read(quizProvider('task-1').notifier)
                .advanceOrComplete(),
          );
        }
        container.read(quizProvider('task-1').notifier).selectAnswer('a');
        await container
            .read(quizProvider('task-1').notifier)
            .advanceOrComplete();

        final state = container.read(quizProvider('task-1')).value;
        expect(state, isA<QuizCompleted>());
        final completed = state! as QuizCompleted;
        expect(completed.totalQuestions, equals(4));
        expect(completed.lessonId, equals('lesson-1'));
        expect(completed.lessonTitle, equals('Test Lesson'));
        expect(completed.questions.length, equals(4));
        expect(completed.selectedAnswers.length, equals(4));
      },
    );

    test(
      'score is correct count / total questions (2 of 4 = 0.5)',
      () async {
        when(() => mockRepo.loadQuiz('task-1'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(authProvider.future);
        await container.read(quizProvider('task-1').future);

        // Correct options: a, b, c, d
        // Answer a(correct), b(correct), a(wrong), a(wrong) → 2 correct
        container.read(quizProvider('task-1').notifier).selectAnswer('a');
        unawaited(
          container.read(quizProvider('task-1').notifier).advanceOrComplete(),
        );
        container.read(quizProvider('task-1').notifier).selectAnswer('b');
        unawaited(
          container.read(quizProvider('task-1').notifier).advanceOrComplete(),
        );
        container.read(quizProvider('task-1').notifier).selectAnswer('a');
        unawaited(
          container.read(quizProvider('task-1').notifier).advanceOrComplete(),
        );
        container.read(quizProvider('task-1').notifier).selectAnswer('a');
        await container
            .read(quizProvider('task-1').notifier)
            .advanceOrComplete();

        final state = container.read(quizProvider('task-1')).value;
        final completed = state! as QuizCompleted;
        expect(completed.correctCount, equals(2));
        expect(completed.totalQuestions, equals(4));
        expect(completed.score, equals(0.5));
      },
    );

    test('passed is true when score >= passThreshold (0.8)', () async {
      when(() => mockRepo.loadQuiz('task-1'))
          .thenAnswer((_) async => Right(_stubQuizData()));

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      await container.read(quizProvider('task-1').future);

      // Answer all 4 correctly → score = 1.0 >= 0.8 → passed
      final corrects = ['a', 'b', 'c', 'd'];
      for (var i = 0; i < 3; i++) {
        container
            .read(quizProvider('task-1').notifier)
            .selectAnswer(corrects[i]);
        unawaited(
          container
              .read(quizProvider('task-1').notifier)
              .advanceOrComplete(),
        );
      }
      container
          .read(quizProvider('task-1').notifier)
          .selectAnswer(corrects[3]);
      await container
          .read(quizProvider('task-1').notifier)
          .advanceOrComplete();

      final state = container.read(quizProvider('task-1')).value;
      final completed = state! as QuizCompleted;
      expect(completed.passed, isTrue);
      expect(completed.score, equals(1.0));
    });

    test(
      'passed is false when score < passThreshold (0.5 < 0.8)',
      () async {
        when(() => mockRepo.loadQuiz('task-1'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(authProvider.future);
        await container.read(quizProvider('task-1').future);

        // Answer 2 correctly → score = 0.5 < 0.8 → failed
        container.read(quizProvider('task-1').notifier).selectAnswer('a');
        unawaited(
          container.read(quizProvider('task-1').notifier).advanceOrComplete(),
        );
        container.read(quizProvider('task-1').notifier).selectAnswer('b');
        unawaited(
          container.read(quizProvider('task-1').notifier).advanceOrComplete(),
        );
        container.read(quizProvider('task-1').notifier).selectAnswer('a');
        unawaited(
          container.read(quizProvider('task-1').notifier).advanceOrComplete(),
        );
        container.read(quizProvider('task-1').notifier).selectAnswer('a');
        await container
            .read(quizProvider('task-1').notifier)
            .advanceOrComplete();

        final state = container.read(quizProvider('task-1')).value;
        final completed = state! as QuizCompleted;
        expect(completed.passed, isFalse);
      },
    );

    test('passed is true for exact threshold (0.8 >= 0.8)', () async {
      when(() => mockRepo.loadQuiz('task-1'))
          .thenAnswer((_) async => Right(_stubQuizData()));

      // Use passThreshold = 0.5, answer exactly 2/4 correctly
      when(() => mockRepo.loadQuiz('task-2')).thenAnswer(
        (_) async => Right((
          questions: _stubQuestions(),
          passThreshold: 0.5,
          lessonId: 'lesson-1',
          lessonTitle: 'Test Lesson',
        )),
      );

      final boundaryContainer = ProviderContainer(
        overrides: [
          quizRepositoryProvider.overrideWithValue(mockRepo),
          taskDaoProvider.overrideWithValue(mockTaskDao),
          quizDaoProvider.overrideWithValue(mockQuizDao),
          authProvider.overrideWith(FakeAuthNotifier.new),
        ],
        retry: (_, _) => null,
      );
      addTearDown(boundaryContainer.dispose);

      await boundaryContainer.read(authProvider.future);
      await boundaryContainer.read(quizProvider('task-2').future);
      boundaryContainer
          .read(quizProvider('task-2').notifier)
          .selectAnswer('a'); // correct (q1=a)
      unawaited(
        boundaryContainer
            .read(quizProvider('task-2').notifier)
            .advanceOrComplete(),
      );
      boundaryContainer
          .read(quizProvider('task-2').notifier)
          .selectAnswer('b'); // correct (q2=b)
      unawaited(
        boundaryContainer
            .read(quizProvider('task-2').notifier)
            .advanceOrComplete(),
      );
      boundaryContainer
          .read(quizProvider('task-2').notifier)
          .selectAnswer('a'); // wrong
      unawaited(
        boundaryContainer
            .read(quizProvider('task-2').notifier)
            .advanceOrComplete(),
      );
      boundaryContainer
          .read(quizProvider('task-2').notifier)
          .selectAnswer('a'); // wrong
      await boundaryContainer
          .read(quizProvider('task-2').notifier)
          .advanceOrComplete();

      final state = boundaryContainer.read(quizProvider('task-2')).value;
      final completed = state! as QuizCompleted;
      expect(completed.score, equals(0.5));
      expect(completed.passed, isTrue); // 0.5 >= 0.5
    });

    // --- Pass-path side-effect tests (Story 4.2) ---

    test(
      'advanceOrComplete() on last correct answer calls markTaskComplete once',
      () async {
        when(() => mockRepo.loadQuiz('task-pass'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(quizProvider('task-pass').future);

        final corrects = ['a', 'b', 'c', 'd'];
        for (var i = 0; i < 3; i++) {
          container
              .read(quizProvider('task-pass').notifier)
              .selectAnswer(corrects[i]);
          unawaited(
            container
                .read(quizProvider('task-pass').notifier)
                .advanceOrComplete(),
          );
        }
        container
            .read(quizProvider('task-pass').notifier)
            .selectAnswer(corrects[3]);
        await container
            .read(quizProvider('task-pass').notifier)
            .advanceOrComplete();

        verify(() => mockTaskDao.markTaskComplete('task-pass')).called(1);
      },
    );

    test(
      'advanceOrComplete() on pass calls saveAttempt with correct payload',
      () async {
        when(() => mockRepo.loadQuiz('task-pass'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        // Pre-warm authProvider so .value is set before advanceOrComplete.
        await container.read(authProvider.future);
        await container.read(quizProvider('task-pass').future);

        final corrects = ['a', 'b', 'c', 'd'];
        for (var i = 0; i < 3; i++) {
          container
              .read(quizProvider('task-pass').notifier)
              .selectAnswer(corrects[i]);
          unawaited(
            container
                .read(quizProvider('task-pass').notifier)
                .advanceOrComplete(),
          );
        }
        container
            .read(quizProvider('task-pass').notifier)
            .selectAnswer(corrects[3]);
        await container
            .read(quizProvider('task-pass').notifier)
            .advanceOrComplete();

        final captured =
            verify(() => mockQuizDao.saveAttempt(captureAny())).captured;
        expect(captured.length, equals(1));
        final attempt = captured.first as QuizAttemptsTableCompanion;
        expect(attempt.score.value, equals(1.0));
        expect(attempt.passed.value, isTrue);
        expect(attempt.lessonId.value, equals('lesson-1'));
        expect(attempt.studentId.value, equals('student-1'));
      },
    );

    test(
      'advanceOrComplete() on fail does not call markTaskComplete',
      () async {
        when(() => mockRepo.loadQuiz('task-fail'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(quizProvider('task-fail').future);

        // Answer all wrong (correct: a,b,c,d) → score = 0/4 < 0.8
        for (var i = 0; i < 3; i++) {
          container
              .read(quizProvider('task-fail').notifier)
              .selectAnswer('d'); // wrong for q1,q2,q3
          unawaited(
            container
                .read(quizProvider('task-fail').notifier)
                .advanceOrComplete(),
          );
        }
        container
            .read(quizProvider('task-fail').notifier)
            .selectAnswer('a'); // wrong for q4 (correct: d)
        await container
            .read(quizProvider('task-fail').notifier)
            .advanceOrComplete();

        verifyNever(() => mockTaskDao.markTaskComplete(any()));
      },
    );

    // --- Fail-path side-effect tests (Story 4.3) ---

    test(
      'advanceOrComplete() on fail calls resetTaskToInProgress, not markTaskComplete',
      () async {
        when(() => mockRepo.loadQuiz('task-fail-reset'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(authProvider.future);
        await container.read(quizProvider('task-fail-reset').future);

        // Answer all wrong → score = 0/4 < 0.8 → fail
        for (var i = 0; i < 3; i++) {
          container
              .read(quizProvider('task-fail-reset').notifier)
              .selectAnswer('d');
          unawaited(
            container
                .read(quizProvider('task-fail-reset').notifier)
                .advanceOrComplete(),
          );
        }
        container
            .read(quizProvider('task-fail-reset').notifier)
            .selectAnswer('a');
        await container
            .read(quizProvider('task-fail-reset').notifier)
            .advanceOrComplete();

        verify(
          () => mockTaskDao.resetTaskToInProgress('task-fail-reset'),
        ).called(1);
        verifyNever(() => mockTaskDao.markTaskComplete(any()));
      },
    );

    test(
      'advanceOrComplete() on fail saves attempt with passed=false',
      () async {
        when(() => mockRepo.loadQuiz('task-fail-attempt'))
            .thenAnswer((_) async => Right(_stubQuizData()));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(authProvider.future);
        await container.read(quizProvider('task-fail-attempt').future);

        // Answer all wrong → fail
        for (var i = 0; i < 3; i++) {
          container
              .read(quizProvider('task-fail-attempt').notifier)
              .selectAnswer('d');
          unawaited(
            container
                .read(quizProvider('task-fail-attempt').notifier)
                .advanceOrComplete(),
          );
        }
        container
            .read(quizProvider('task-fail-attempt').notifier)
            .selectAnswer('a');
        await container
            .read(quizProvider('task-fail-attempt').notifier)
            .advanceOrComplete();

        final captured =
            verify(() => mockQuizDao.saveAttempt(captureAny())).captured;
        final companion = captured.last as QuizAttemptsTableCompanion;
        expect(companion.passed.value, isFalse);
        expect(companion.studentId.value, equals('student-1'));
      },
    );
  });
}
