import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/core/theme/app_theme.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/backlog/presentation/widgets/task_card.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

BacklogItem _item(TaskStatus status) => BacklogItem(
      taskId: 'tid',
      lessonId: 'lid',
      lessonTitle: 'Atomic Theory',
      topicId: 'tpid',
      topicTitle: 'Atomic Structure',
      contentTrack: 'theory',
      taskStatus: status,
      curiosityCompleted: false,
      lessonOrderIndex: 0,
      topicOrderIndex: 0,
    );

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );

void main() {
  group('TaskCard', () {
    testWidgets('renders lesson title and topic breadcrumb', (tester) async {
      await tester.pumpWidget(_wrap(TaskCard(item: _item(TaskStatus.backlog))));

      expect(find.text('Atomic Theory'), findsOneWidget);
      expect(find.text('Atomic Structure'), findsOneWidget);
    });

    testWidgets('backlog state shows clock icon and Backlog label',
        (tester) async {
      await tester.pumpWidget(_wrap(TaskCard(item: _item(TaskStatus.backlog))));

      expect(find.byIcon(Icons.access_time), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
    });

    testWidgets('todo state shows arrow-forward icon and To-Do label',
        (tester) async {
      await tester.pumpWidget(_wrap(TaskCard(item: _item(TaskStatus.todo))));

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('To-Do'), findsOneWidget);
    });

    testWidgets('inProgress state shows play icon and In Progress label',
        (tester) async {
      await tester
          .pumpWidget(_wrap(TaskCard(item: _item(TaskStatus.inProgress))));

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
    });

    testWidgets('done state shows check-circle icon and Done label',
        (tester) async {
      await tester.pumpWidget(_wrap(TaskCard(item: _item(TaskStatus.done))));

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('semantics label is title and state without action hint',
        (tester) async {
      await tester.pumpWidget(_wrap(TaskCard(item: _item(TaskStatus.backlog))));

      expect(
        find.bySemanticsLabel('Atomic Theory, Backlog'),
        findsOneWidget,
      );
    });

    testWidgets('card contains a 4dp left border decoration', (tester) async {
      await tester.pumpWidget(_wrap(TaskCard(item: _item(TaskStatus.backlog))));

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TaskCard),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration?;
      final border = decoration?.border as Border?;
      expect(border, isNotNull);
      expect(border!.left.width, 4.0);
      expect(border.left.color, isNot(equals(Colors.transparent)));
    });
  });
}
