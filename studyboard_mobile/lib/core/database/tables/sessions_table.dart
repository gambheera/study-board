import 'package:drift/drift.dart';

class SessionsTable extends Table {
  @override
  String get tableName => 'sessions';

  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get startedAt => text()();
  TextColumn get endedAt => text().nullable()();
  TextColumn get attributedNudgeId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
