import 'package:drift/drift.dart';

class StudentsTable extends Table {
  @override
  String get tableName => 'students';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get district => text()();
  TextColumn get school => text()();
  TextColumn get fcmToken => text().nullable()();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get deactivatedAt => text().nullable()();
  TextColumn get deletedAt => text().nullable()();
  TextColumn get lastActiveAt => text()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
