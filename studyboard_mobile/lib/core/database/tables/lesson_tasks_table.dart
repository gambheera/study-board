import 'package:drift/drift.dart';

class LessonTasksTable extends Table {
  @override
  String get tableName => 'lesson_tasks';

  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get lessonId => text()();
  TextColumn get taskStatus =>
      text().withDefault(const Constant('backlog'))();
  BoolColumn get curiosityCompleted =>
      boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        "CHECK (task_status IN ('backlog', 'todo', 'in_progress', 'done'))",
        'UNIQUE (student_id, lesson_id)',
      ];
}
