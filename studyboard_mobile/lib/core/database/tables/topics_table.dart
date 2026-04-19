import 'package:drift/drift.dart';

class TopicsTable extends Table {
  @override
  String get tableName => 'topics';

  TextColumn get id => text()();
  TextColumn get subjectId => text()();
  TextColumn get title => text()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
