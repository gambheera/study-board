import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/features/lesson/data/lesson_provider.dart';
import 'package:studyboard_mobile/features/lesson/domain/lesson_repository.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_content_screen.dart';

class _MockLessonRepository extends Mock implements LessonRepository {}

LessonDetails _fakeLessonDetails() => const LessonDetails(
  taskId: 'task-1',
  lessonId: 'lesson-1',
  lessonTitle: 'Atomic Structure',
  topicTitle: 'Structure of Atom',
  questionText: 'What is an atom?',
  contentText: '## Overview\n\nThe atom is the basic unit of chemistry.',
  curiosityCompleted: false,
);

Widget _wrapScreen({required _MockLessonRepository repo}) {
  return ProviderScope(
    overrides: [lessonRepositoryProvider.overrideWithValue(repo)],
    child: const MaterialApp(
      home: LessonContentScreen(taskId: 'task-1'),
    ),
  );
}

void main() {
  late _MockLessonRepository mockRepo;

  setUp(() {
    mockRepo = _MockLessonRepository();
  });

  testWidgets('renders lesson title from LessonState', (tester) async {
    when(() => mockRepo.getLessonDetails('task-1'))
        .thenAnswer((_) async => _fakeLessonDetails());

    await tester.pumpWidget(_wrapScreen(repo: mockRepo));
    await tester.pumpAndSettle();

    expect(find.text('Atomic Structure'), findsOneWidget);
  });

  testWidgets('Take quiz FilledButton is always visible', (tester) async {
    when(() => mockRepo.getLessonDetails('task-1'))
        .thenAnswer((_) async => _fakeLessonDetails());

    await tester.pumpWidget(_wrapScreen(repo: mockRepo));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Take quiz'), findsOneWidget);
  });

  testWidgets('back navigation has no PopScope', (tester) async {
    when(() => mockRepo.getLessonDetails('task-1'))
        .thenAnswer((_) async => _fakeLessonDetails());

    await tester.pumpWidget(_wrapScreen(repo: mockRepo));
    await tester.pumpAndSettle();

    expect(find.byType(PopScope), findsNothing);
  });

  testWidgets('error state shows retry button; tapping retry triggers reload',
      (tester) async {
    var callCount = 0;
    when(() => mockRepo.getLessonDetails('task-1')).thenAnswer((_) {
      callCount++;
      return Future.error(StateError('Lesson not found'));
    });

    await tester.pumpWidget(_wrapScreen(repo: mockRepo));
    await tester.pumpAndSettle();

    expect(
      find.text('Could not load lesson. Please try again.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(OutlinedButton, 'Retry'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Retry'));
    await tester.pumpAndSettle();

    // ref.invalidate triggers a fresh getLessonDetails call
    expect(callCount, greaterThan(1));
  });

  testWidgets(
    'loading state shows skeleton with no root CircularProgressIndicator',
    (tester) async {
    final completer = Completer<LessonDetails>();
    when(() => mockRepo.getLessonDetails('task-1'))
        .thenAnswer((_) => completer.future);

    await tester.pumpWidget(_wrapScreen(repo: mockRepo));
    await tester.pump();

    // Skeleton renders grey container boxes, not a root-level spinner
    expect(
      find.descendant(
        of: find.byType(LessonContentScreen),
        matching: find.byType(CircularProgressIndicator),
      ),
      findsNothing,
    );
    // Confirm skeleton containers are present
    expect(find.byType(Container), findsWidgets);
  });
}
