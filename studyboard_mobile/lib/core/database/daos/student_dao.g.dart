// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_dao.dart';

// ignore_for_file: type=lint
mixin _$StudentDaoMixin on DatabaseAccessor<AppDatabase> {
  $StudentsTableTable get studentsTable => attachedDatabase.studentsTable;
  $SyncQueueTableTable get syncQueueTable => attachedDatabase.syncQueueTable;
  $StudentSubjectsTableTable get studentSubjectsTable =>
      attachedDatabase.studentSubjectsTable;
  StudentDaoManager get managers => StudentDaoManager(this);
}

class StudentDaoManager {
  final _$StudentDaoMixin _db;
  StudentDaoManager(this._db);
  $$StudentsTableTableTableManager get studentsTable =>
      $$StudentsTableTableTableManager(_db.attachedDatabase, _db.studentsTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(
        _db.attachedDatabase,
        _db.syncQueueTable,
      );
  $$StudentSubjectsTableTableTableManager get studentSubjectsTable =>
      $$StudentSubjectsTableTableTableManager(
        _db.attachedDatabase,
        _db.studentSubjectsTable,
      );
}
