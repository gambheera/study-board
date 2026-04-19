import 'package:drift/drift.dart';

class NudgeEventsTable extends Table {
  @override
  String get tableName => 'nudge_events';

  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get sentAt => text()();
  TextColumn get fcmMessageId => text().nullable()();
  TextColumn get status => text()(); // 'sent'|'delivered'|'failed'

  @override
  Set<Column> get primaryKey => {id};
}
