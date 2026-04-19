import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

void main() {
  group('TaskStatus.toDbString', () {
    test('backlog maps to "backlog"', () {
      expect(TaskStatus.backlog.toDbString(), 'backlog');
    });

    test('todo maps to "todo"', () {
      expect(TaskStatus.todo.toDbString(), 'todo');
    });

    test('inProgress maps to "in_progress"', () {
      expect(TaskStatus.inProgress.toDbString(), 'in_progress');
    });

    test('done maps to "done"', () {
      expect(TaskStatus.done.toDbString(), 'done');
    });
  });

  group('TaskStatusX.fromString', () {
    test('"backlog" parses to backlog', () {
      expect(TaskStatusX.fromString('backlog'), TaskStatus.backlog);
    });

    test('"todo" parses to todo', () {
      expect(TaskStatusX.fromString('todo'), TaskStatus.todo);
    });

    test('"in_progress" parses to inProgress', () {
      expect(TaskStatusX.fromString('in_progress'), TaskStatus.inProgress);
    });

    test('"done" parses to done', () {
      expect(TaskStatusX.fromString('done'), TaskStatus.done);
    });

    test('unknown string throws ArgumentError', () {
      expect(
        () => TaskStatusX.fromString('invalid'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('round-trip conversion', () {
    for (final status in TaskStatus.values) {
      test('${status.name} round-trips through db string', () {
        expect(TaskStatusX.fromString(status.toDbString()), status);
      });
    }
  });
}
