import 'package:drift/drift.dart';

class SubjectsTable extends Table {
  @override
  String get tableName => 'subjects';

  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get quizPassThreshold =>
      real().withDefault(const Constant(0.8))();
  IntColumn get contentVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
