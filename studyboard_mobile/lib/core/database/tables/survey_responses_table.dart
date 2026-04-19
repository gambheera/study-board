import 'package:drift/drift.dart';

class SurveyResponsesTable extends Table {
  @override
  String get tableName => 'survey_responses';

  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get responses => text()(); // JSON payload
  TextColumn get respondedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
