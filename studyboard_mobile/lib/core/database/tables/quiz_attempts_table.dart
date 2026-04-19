import 'package:drift/drift.dart';

class QuizAttemptsTable extends Table {
  @override
  String get tableName => 'quiz_attempts';

  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get lessonId => text()();
  RealColumn get score => real()();
  BoolColumn get passed => boolean()();
  TextColumn get attemptedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
