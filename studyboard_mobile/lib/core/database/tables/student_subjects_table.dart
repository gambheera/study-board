import 'package:drift/drift.dart';

class StudentSubjectsTable extends Table {
  @override
  String get tableName => 'student_subjects';

  TextColumn get studentId => text()();
  TextColumn get subjectName => text()();

  @override
  Set<Column> get primaryKey => {studentId, subjectName};
}
