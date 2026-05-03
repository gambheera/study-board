import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/features/lesson/data/lesson_provider.dart';
import 'package:studyboard_mobile/features/lesson/domain/lesson_repository.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_notifier.dart';

class _MockLessonRepository extends Mock implements LessonRepository {}

LessonDetails _fakeLessonDetails({bool curiosityCompleted = false}) =>
    LessonDetails(
      taskId: 'task-1',
      lessonId: 'lesson-1',
      lessonTitle: 'Atomic Structure',
      topicTitle: 'Structure of Atom',
      questionText: 'What is the atomic number of Carbon?',
      contentText: '## Overview\n\nThe atom is the basic unit of chemistry.',
      curiosityCompleted: curiosityCompleted,
    );

void main() {
  late _MockLessonRepository mockRepo;

  setUp(() {
    mockRepo = _MockLessonRepository();
  });

  ProviderContainer makeContainer() => ProviderContainer(
        overrides: [
          lessonRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

  group('LessonNotifier.build', () {
    test('loads LessonDetails and maps to LessonState correctly', () async {
      when(() => mockRepo.getLessonDetails('task-1'))
          .thenAnswer((_) async => _fakeLessonDetails());

      final container = makeContainer();
      addTearDown(container.dispose);

      final state =
          await container.read(lessonProvider('task-1').future);

      expect(state.taskId, equals('task-1'));
      expect(state.lessonId, equals('lesson-1'));
      expect(state.lessonTitle, equals('Atomic Structure'));
      expect(state.topicTitle, equals('Structure of Atom'));
      expect(
        state.questionText,
        equals('What is the atomic number of Carbon?'),
      );
      expect(state.curiosityCompleted, isFalse);
    });
  });

  group('LessonNotifier.completeCuriosity', () {
    test('calls setCuriosityCompleted on repository and updates state',
        () async {
      when(() => mockRepo.getLessonDetails('task-1'))
          .thenAnswer((_) async => _fakeLessonDetails());
      when(() => mockRepo.setCuriosityCompleted('task-1'))
          .thenAnswer((_) async {});

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(lessonProvider('task-1').future);

      await container
          .read(lessonProvider('task-1').notifier)
          .completeCuriosity();

      final updatedState =
          container.read(lessonProvider('task-1')).value;
      expect(updatedState?.curiosityCompleted, isTrue);
      verify(() => mockRepo.setCuriosityCompleted('task-1')).called(1);
    });

    test('does not call setCuriosityCompleted when state is error', () async {
      when(() => mockRepo.getLessonDetails('task-1'))
          .thenThrow(StateError('Task not found'));

      final container = makeContainer();
      addTearDown(container.dispose);

      try {
        await container.read(lessonProvider('task-1').future);
      } on Object {
        // expected — notifier build threw
      }

      await container
          .read(lessonProvider('task-1').notifier)
          .completeCuriosity();

      verifyNever(() => mockRepo.setCuriosityCompleted(any()));
    });
  });
}
