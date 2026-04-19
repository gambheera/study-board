import 'package:drift/drift.dart';

class LessonsTable extends Table {
  @override
  String get tableName => 'lessons';

  TextColumn get id => text()();
  TextColumn get topicId => text()();
  TextColumn get title => text()();
  TextColumn get contentText => text()();
  // 'theory' | 'past_papers' | 'future_papers'
  TextColumn get contentTrack => text()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
