import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/theme/app_theme.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/board/data/board_provider.dart';
import 'package:studyboard_mobile/features/board/domain/board_repository.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';
import 'package:studyboard_mobile/features/board/presentation/board_screen.dart';

class _MockBoardRepository extends Mock implements BoardRepository {}

class _FakeAuthNotifier extends AuthNotifier {
  @override
  Future<AuthState> build() async {
    return AuthState.authenticated(student: _fakeStudent());
  }
}

Student _fakeStudent() => const Student(
  id: 'user-abc',
  name: 'Test User',
  email: 'test@example.com',
  district: '',
  school: '',
  notificationsEnabled: true,
  lastActiveAt: '2026-04-18T00:00:00.000Z',
  createdAt: '2026-04-18T00:00:00.000Z',
);

BacklogItem _makeItem({
  required String id,
  required TaskStatus status,
}) {
  return BacklogItem(
    taskId: id,
    lessonId: 'lesson-$id',
    lessonTitle: 'Lesson $id',
    topicId: 'topic-$id',
    topicTitle: 'Topic $id',
    contentTrack: 'theory',
    taskStatus: status,
    curiosityCompleted: false,
    lessonOrderIndex: 1,
    topicOrderIndex: 1,
  );
}

Widget _wrapBoard({required _MockBoardRepository boardRepo}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(_FakeAuthNotifier.new),
      boardRepositoryProvider.overrideWith((_) => boardRepo),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const BoardScreen(),
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(TaskStatus.backlog);
  });

  late _MockBoardRepository mockBoardRepo;

  setUp(() {
    mockBoardRepo = _MockBoardRepository();
    when(
      () => mockBoardRepo.watchBoardItems(any(), any()),
    ).thenAnswer((_) => Stream.value([]));
    when(
      () => mockBoardRepo.watchHasDoneTasks(any()),
    ).thenAnswer((_) => Stream.value(false));
  });

  group('BoardScreen', () {
    testWidgets(
      'shows In Progress empty state when no in_progress tasks',
      (tester) async {
        await tester.pumpWidget(_wrapBoard(boardRepo: mockBoardRepo));
        await tester.pumpAndSettle();

        expect(
          find.text('Move a task to To-Do to get started'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'empty state has Go to Backlog FilledButton',
      (tester) async {
        await tester.pumpWidget(_wrapBoard(boardRepo: mockBoardRepo));
        await tester.pumpAndSettle();

        expect(find.text('Go to Backlog'), findsOneWidget);
        expect(
          find.widgetWithText(FilledButton, 'Go to Backlog'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Done tab is not visible when no done tasks',
      (tester) async {
        await tester.pumpWidget(_wrapBoard(boardRepo: mockBoardRepo));
        await tester.pumpAndSettle();

        expect(find.text('Done'), findsNothing);
        expect(find.text('To-Do'), findsOneWidget);
        expect(find.text('In Progress'), findsOneWidget);
      },
    );

    testWidgets('adds Done tab when hasDone stream becomes true', (
      tester,
    ) async {
      final hasDoneController = StreamController<bool>();
      addTearDown(hasDoneController.close);

      when(
        () => mockBoardRepo.watchHasDoneTasks(any()),
      ).thenAnswer((_) => hasDoneController.stream);

      await tester.pumpWidget(_wrapBoard(boardRepo: mockBoardRepo));

      hasDoneController.add(false);
      await tester.pumpAndSettle();

      expect(find.text('Done'), findsNothing);

      hasDoneController.add(true);
      await tester.pumpAndSettle();

      expect(find.text('Done'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders in-progress tasks from stream data', (tester) async {
      final inProgressItem = _makeItem(id: '1', status: TaskStatus.inProgress);

      when(() => mockBoardRepo.watchBoardItems(any(), any())).thenAnswer((
        invocation,
      ) {
        final status = invocation.positionalArguments[1] as TaskStatus;
        if (status == TaskStatus.inProgress) {
          return Stream.value([inProgressItem]);
        }
        return Stream.value(<BacklogItem>[]);
      });

      await tester.pumpWidget(_wrapBoard(boardRepo: mockBoardRepo));
      await tester.pumpAndSettle();

      expect(find.text('Lesson 1'), findsOneWidget);
      expect(find.text('Move a task to To-Do to get started'), findsNothing);
    });
  });
}
