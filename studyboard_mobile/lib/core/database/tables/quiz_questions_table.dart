import 'package:drift/drift.dart';

class QuizQuestionsTable extends Table {
  @override
  String get tableName => 'quiz_questions';

  TextColumn get id => text()();
  TextColumn get lessonId => text()();
  TextColumn get questionText => text()();
  TextColumn get optionA => text()();
  TextColumn get optionB => text()();
  TextColumn get optionC => text()();
  TextColumn get optionD => text()();
  TextColumn get correctOption => text()(); // 'a'|'b'|'c'|'d'
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
