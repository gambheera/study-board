import 'package:drift/drift.dart';

class PastPaperQuestionsTable extends Table {
  @override
  String get tableName => 'past_paper_questions';

  TextColumn get id => text()();
  TextColumn get lessonId => text()();
  TextColumn get topicId => text()();
  TextColumn get questionText => text()();
  IntColumn get year => integer().nullable()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
