# Story 1.3: Complete Drift Database Schema

Status: done

## Story

As a developer,
I want the full Drift database schema defined in a single initial migration covering all 8 epics,
so that no mid-sprint schema migration surprises block feature development.

## Acceptance Criteria

1. **Given** the Drift `AppDatabase` is instantiated **When** the app runs for the first time on a fresh install **Then** migration version 1 executes successfully and all required tables exist: `students`, `subjects`, `topics`, `lessons`, `lesson_tasks`, `quiz_questions`, `quiz_attempts`, `past_paper_questions`, `sync_queue`, `sync_error_log`, `survey_responses`, `nudge_events`, `sessions`

2. **Given** the `lesson_tasks` table `task_status` column **When** a task status is written to Drift **Then** only `'backlog'`, `'todo'`, `'in_progress'`, or `'done'` are valid values; the `TaskStatus` enum and `TaskStatus.fromString()` / `toDbString()` extension are the only conversion paths — no raw string comparisons anywhere in the codebase

3. **Given** the `sync_queue` table **When** an entry is inserted **Then** it contains: `id (UUID TEXT PK)`, `entity_type TEXT NOT NULL`, `entity_id TEXT NOT NULL`, `operation TEXT NOT NULL ('upsert'|'soft_delete')`, `payload TEXT NOT NULL (JSON)`, `created_at TEXT NOT NULL (ISO 8601 UTC)`, `retry_count INTEGER DEFAULT 0`

4. **Given** the `sessions` table **When** a session row is created **Then** it contains `attributed_nudge_id TEXT` as a nullable FK referencing `nudge_events.id`, enabling nudge-to-return attribution for the FCM hypothesis

5. **Given** a Drift DAO for each feature domain (`TaskDao`, `QuizDao`, `LessonDao`, `StudentDao`, `SurveyDao`, `DashboardDao`) **When** the `AppDatabase` singleton is accessed **Then** all DAOs are accessible and all `freezed` domain models have corresponding `fromJson`/`toJson` mappings with explicit `snake_case` → `camelCase` field mapping

6. **Given** a future schema upgrade (migration v1 → v2) **When** the app is installed over an existing v1 database **Then** Drift's migration API handles the upgrade without data loss — verified by running a migration test against a v1 seed database

## Tasks / Subtasks

- [x] Task 1: Create Drift table definitions — core content tables (AC: #1, #2)
  - [x] Create `lib/core/database/tables/students_table.dart` — fields: `id, name, email, district, school` (TEXT NOT NULL), `fcm_token TEXT nullable`, `notifications_enabled BOOL DEFAULT true`, `deactivated_at TEXT nullable`, `deleted_at TEXT nullable`, `last_active_at TEXT NOT NULL`, `created_at TEXT NOT NULL`; primaryKey: `{id}`
  - [x] Create `lib/core/database/tables/subjects_table.dart` — fields: `id, name` (TEXT NOT NULL), `quiz_pass_threshold REAL DEFAULT 0.8`, `content_version INT DEFAULT 1`; primaryKey: `{id}`
  - [x] Create `lib/core/database/tables/topics_table.dart` — fields: `id, subject_id, title` (TEXT NOT NULL), `order_index INT DEFAULT 0`; primaryKey: `{id}`
  - [x] Create `lib/core/database/tables/lessons_table.dart` — fields: `id, topic_id, title, content_text, content_track` (TEXT NOT NULL; `content_track` is `'theory'|'past_papers'|'future_papers'`), `order_index INT DEFAULT 0`; primaryKey: `{id}`
  - [x] Create `lib/core/database/tables/lesson_tasks_table.dart` — fields: `id, student_id, lesson_id` (TEXT NOT NULL), `task_status TEXT DEFAULT 'backlog'`, `curiosity_completed BOOL DEFAULT false`, `created_at TEXT NOT NULL`, `updated_at TEXT NOT NULL`; primaryKey: `{id}`; customConstraints: `["CHECK (task_status IN ('backlog', 'todo', 'in_progress', 'done'))", 'UNIQUE (student_id, lesson_id)']`
  - [x] Create `lib/core/database/tables/quiz_questions_table.dart` — fields: `id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_option` (TEXT NOT NULL), `order_index INT DEFAULT 0`; primaryKey: `{id}`
  - [x] Create `lib/core/database/tables/quiz_attempts_table.dart` — fields: `id, student_id, lesson_id` (TEXT NOT NULL), `score REAL NOT NULL` (0.0–1.0), `passed BOOL NOT NULL`, `attempted_at TEXT NOT NULL`; primaryKey: `{id}`
  - [x] Create `lib/core/database/tables/past_paper_questions_table.dart` — fields: `id, lesson_id, topic_id, question_text` (TEXT NOT NULL), `year INT nullable`, `order_index INT DEFAULT 0`; primaryKey: `{id}`

- [x] Task 2: Create Drift table definitions — event and tracking tables (AC: #1, #3, #4)
  - [x] Create `lib/core/database/tables/survey_responses_table.dart` — fields: `id, student_id, responses` (TEXT NOT NULL; JSON payload), `responded_at TEXT NOT NULL`; primaryKey: `{id}`
  - [x] Create `lib/core/database/tables/nudge_events_table.dart` — fields: `id, student_id, sent_at` (TEXT NOT NULL), `fcm_message_id TEXT nullable`, `status TEXT NOT NULL` (`'sent'|'delivered'|'failed'`); primaryKey: `{id}`
  - [x] Create `lib/core/database/tables/sessions_table.dart` — fields: `id, student_id, started_at` (TEXT NOT NULL), `ended_at TEXT nullable`, `attributed_nudge_id TEXT nullable` (logical FK → nudge_events.id); primaryKey: `{id}`
  - [x] Create `lib/core/sync/sync_queue_table.dart` — define BOTH `SyncQueueTable` AND `SyncErrorLogTable` in this single file; `SyncQueueTable` columns match AC #3 exactly; `SyncErrorLogTable` adds `error_message TEXT NOT NULL`, `failed_at TEXT NOT NULL`; both use `id TEXT` primaryKey

- [x] Task 3: Create freezed domain models for all feature domains (AC: #5)
  - [x] Create `lib/features/auth/domain/student.dart` — `@freezed abstract class Student` with fields: `id, name, email, district, school, lastActiveAt, createdAt` (String required); `fcmToken, deactivatedAt, deletedAt` (String? nullable); `notificationsEnabled` (bool required); `fromJson` factory
  - [x] Create `lib/features/board/domain/task.dart` — `@freezed abstract class Task`; import `TaskStatus` from `task_status.dart` — NEVER redeclare; fields: `id, studentId, lessonId, createdAt, updatedAt` (String); `taskStatus` (TaskStatus, use `TaskStatusConverter`); `curiosityCompleted` (bool); `fromJson` factory
  - [x] Create `lib/features/lesson/domain/lesson.dart` — `@freezed abstract class Lesson`; fields: `id, topicId, title, contentText, contentTrack` (String); `orderIndex` (int); `fromJson` factory
  - [x] Create `lib/features/lesson/domain/past_paper_question.dart` — `@freezed abstract class PastPaperQuestion`; fields: `id, lessonId, topicId, questionText` (String); `year` (int? nullable); `orderIndex` (int); `fromJson` factory
  - [x] Create `lib/features/quiz/domain/quiz_question.dart` — `@freezed abstract class QuizQuestion`; fields: `id, lessonId, questionText, optionA, optionB, optionC, optionD, correctOption` (String); `orderIndex` (int); `fromJson` factory
  - [x] Create `lib/features/quiz/domain/quiz_attempt.dart` — `@freezed abstract class QuizAttempt`; fields: `id, studentId, lessonId, attemptedAt` (String); `score` (double); `passed` (bool); `fromJson` factory
  - [x] Create `lib/features/survey/domain/survey_response.dart` — `@freezed abstract class SurveyResponse`; fields: `id, studentId, responses, respondedAt` (String); `fromJson` factory
  - [x] Create `lib/features/dashboard/domain/dashboard_stats.dart` — `@freezed abstract class WeakTopic` (fields: `topicId, topicTitle, accuracyPercent`) and `@freezed abstract class DashboardStats` (fields: `coveragePercent, overallAccuracy, streak, tasksInDone`, `weakTopics: List<WeakTopic>`); both with `fromJson` factories

- [x] Task 4: Create DAOs in `lib/core/database/daos/` (AC: #2, #5)
  - [x] Create `lib/core/database/daos/task_dao.dart` — `@DriftAccessor(tables: [LessonTasksTable, SyncQueueTable])`; named methods ONLY: `markTaskComplete(String taskId)`, `resetTaskToInProgress(String taskId)`, `pullToTodo(String taskId)`, `startTask(String taskId)`, `getTaskByLesson(String studentId, String lessonId)`; each status mutation writes the status update AND enqueues a sync_queue row in the same `transaction()`; no generic `updateStatus()` method
  - [x] Create `lib/core/database/daos/quiz_dao.dart` — `@DriftAccessor(tables: [QuizQuestionsTable, QuizAttemptsTable, SyncQueueTable])`; methods: `getQuestionsForLesson(String lessonId)`, `saveAttempt(QuizAttemptsCompanion)`, `getAttemptsForLesson(String studentId, String lessonId)`
  - [x] Create `lib/core/database/daos/lesson_dao.dart` — `@DriftAccessor(tables: [LessonsTable, PastPaperQuestionsTable, LessonTasksTable])`; methods: `getLessonById(String lessonId)`, `getPastPaperQuestionsForLesson(String lessonId)`, `setCuriosityCompleted(String taskId)`
  - [x] Create `lib/core/database/daos/student_dao.dart` — `@DriftAccessor(tables: [StudentsTable, SyncQueueTable])`; methods: `getStudent(String studentId)`, `upsertStudent(StudentsCompanion)`, `deactivate(String studentId)`, `softDelete(String studentId)` (sets `deleted_at` and nulls PII fields in same transaction), `updateLastActiveAt(String studentId, String isoTimestamp)`
  - [x] Create `lib/core/database/daos/survey_dao.dart` — `@DriftAccessor(tables: [SurveyResponsesTable, SyncQueueTable])`; method: `saveResponse(SurveyResponsesCompanion)`
  - [x] Create `lib/core/database/daos/dashboard_dao.dart` — `@DriftAccessor(tables: [LessonTasksTable, QuizAttemptsTable, LessonsTable, TopicsTable, SessionsTable])`; full SQL implementations: `getCoveragePercent`, `getWeakTopics`, `getStreak`, `getOverallAccuracy`
  - [x] Create `lib/core/database/daos/content_dao.dart` — `@DriftAccessor(tables: [LessonsTable, TopicsTable])`; method: `getAllLessons(String subjectId) → Future<List<LessonsTableData>>`

- [x] Task 5: Create `AppDatabase` class and Riverpod provider (AC: #1, #5)
  - [x] Create `lib/core/database/app_database.dart` — `@DriftDatabase` with all 13 Drift tables and all 7 DAOs; `AppDatabase()` and `AppDatabase.forTesting(super.e)` constructors; `schemaVersion => 1`; `MigrationStrategy` with `onCreate: (m) => m.createAll()`
  - [x] Create `lib/core/database/database_provider.dart` — Riverpod 4.x `@Riverpod(keepAlive: true)` with plain `Ref` (not type-specific Ref classes); `appDatabaseProvider` + all 7 DAO providers; `ref.onDispose(db.close)`

- [x] Task 6: Check and add uuid package if missing, run code generation (AC: #1, #5)
  - [x] Added `uuid: ^4.5.1` to dependencies and `json_annotation: ^4.9.0`; added `json_serializable: ^6.9.4` to dev_dependencies; ran `flutter pub get`
  - [x] From `studyboard_mobile/` ran: `dart run build_runner build --delete-conflicting-outputs`
  - [x] Verified all generated files exist: `app_database.g.dart`, `database_provider.g.dart`, all `*_dao.g.dart`, all `*.freezed.dart` + `*.g.dart` for domain models
  - [x] Fixed all code generation errors (package: imports, abstract class pattern, direct table imports in DAOs)

- [x] Task 7: Generate schema snapshot for migration testing (AC: #6)
  - [x] Created `studyboard_mobile/drift_schemas/` directory
  - [x] Ran: `dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas/` (correct command; `schema generate` with JSON arg was wrong)
  - [x] Verified `drift_schema_v1.json` contains all 13 table definitions; generated migration test helpers with `dart run drift_dev schema generate drift_schemas/ test/generated_migrations/`

- [x] Task 8: Write database tests (AC: #1, #2, #5, #6)
  - [x] Created `test/core/database/app_database_test.dart` with 5 tests: 13-table creation, CHECK constraint rejection, TaskStatus round-trip, sync_queue insert/read, sessions nullable nudge_id
  - [x] Created `test/core/database/migrations_test.dart` using `drift_dev/api/migrations_native.dart` and `SchemaVerifier(GeneratedHelper())`

- [x] Task 9: Validate and finalize (AC: all)
  - [x] `flutter analyze` → 0 issues
  - [x] `flutter test` → 48/48 tests pass (6 new database tests + 42 pre-existing)
  - [x] `dart run build_runner build` produces no conflicting output warnings

## Dev Notes

### Drift 2.22 Table Definition Pattern

All content tables live in `lib/core/database/tables/`. Each file declares one `Table` subclass. Drift auto-converts Dart camelCase field names to snake_case DB column names (`taskStatus` → `task_status`, `studentId` → `student_id`). Never call `.withColumnName()` unless a specific deviation is needed.

```dart
// lib/core/database/tables/lesson_tasks_table.dart
import 'package:drift/drift.dart';

class LessonTasksTable extends Table {
  @override
  String get tableName => 'lesson_tasks';

  TextColumn get id => text()();
  TextColumn get studentId => text()();          // → student_id
  TextColumn get lessonId => text()();           // → lesson_id
  TextColumn get taskStatus =>
      text().withDefault(const Constant('backlog'))();  // → task_status
  BoolColumn get curiosityCompleted =>
      boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (task_status IN ('backlog', 'todo', 'in_progress', 'done'))",
    'UNIQUE (student_id, lesson_id)',
  ];
}
```

> **CRITICAL**: The `TaskStatus` enum already exists in `lib/features/board/domain/task_status.dart` (created in Story 1.1). Import it everywhere — NEVER redeclare it. The `customConstraints` CHECK above enforces valid values at the DB layer; `TaskStatusX.fromString()` enforces at the Dart layer.

### Sync Table Location — Critical

The `SyncQueueTable` and `SyncErrorLogTable` go in `lib/core/sync/sync_queue_table.dart`, NOT in `lib/core/database/tables/`. The architecture places sync infrastructure separately from content/feature tables. Both table classes live in the same file.

```dart
// lib/core/sync/sync_queue_table.dart
import 'package:drift/drift.dart';

class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  TextColumn get id => text()();
  // 'task_status' | 'quiz_attempt' | 'survey_response' | 'session' | 'student'
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();   // 'upsert' | 'soft_delete'
  TextColumn get payload => text()();     // JSON string
  TextColumn get createdAt => text()();   // ISO 8601 UTC
  IntColumn get retryCount =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncErrorLogTable extends Table {
  @override
  String get tableName => 'sync_error_log';

  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  TextColumn get errorMessage => text()();
  TextColumn get failedAt => text()();
  IntColumn get retryCount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Full Table Schema Reference

| Table | PK | Key Fields | Notes |
|---|---|---|---|
| `students` | `id TEXT` | `fcm_token TEXT?`, `notifications_enabled BOOL DEFAULT true`, `deactivated_at TEXT?`, `deleted_at TEXT?`, `last_active_at TEXT NOT NULL` | PII: name/email/district/school — anonymized on soft-delete |
| `subjects` | `id TEXT` | `quiz_pass_threshold REAL DEFAULT 0.8`, `content_version INT DEFAULT 1` | Chemistry = 80% threshold, stored as a data value |
| `topics` | `id TEXT` | `subject_id TEXT`, `order_index INT DEFAULT 0` | Logical FK → subjects.id |
| `lessons` | `id TEXT` | `topic_id TEXT`, `content_track TEXT` (`'theory'`\|`'past_papers'`\|`'future_papers'`), `order_index INT DEFAULT 0` | Logical FK → topics.id |
| `lesson_tasks` | `id TEXT` | `student_id TEXT`, `lesson_id TEXT`, `task_status TEXT DEFAULT 'backlog'`, `curiosity_completed BOOL DEFAULT false` | UNIQUE(student_id, lesson_id); CHECK on task_status |
| `quiz_questions` | `id TEXT` | `lesson_id TEXT`, `option_a/b/c/d TEXT NOT NULL`, `correct_option TEXT NOT NULL` (`'a'`\|`'b'`\|`'c'`\|`'d'`) | Logical FK → lessons.id |
| `quiz_attempts` | `id TEXT` | `student_id, lesson_id`, `score REAL` (0.0–1.0), `passed BOOL`, `attempted_at TEXT` | New row per attempt — never overwritten |
| `past_paper_questions` | `id TEXT` | `lesson_id TEXT`, `topic_id TEXT`, `question_text TEXT`, `year INT?` | Used by CuriosityScreen (Epic 3) |
| `survey_responses` | `id TEXT` | `student_id TEXT`, `responses TEXT` (JSON), `responded_at TEXT` | Full JSON payload |
| `nudge_events` | `id TEXT` | `student_id TEXT`, `sent_at TEXT`, `fcm_message_id TEXT?`, `status TEXT` (`'sent'`\|`'delivered'`\|`'failed'`) | For FCM hypothesis measurement (Epic 8) |
| `sessions` | `id TEXT` | `student_id TEXT`, `started_at TEXT`, `ended_at TEXT?`, `attributed_nudge_id TEXT?` | `attributed_nudge_id` → nudge_events.id; nullable |
| `sync_queue` | `id TEXT` | `entity_type, entity_id, operation, payload, created_at, retry_count INT DEFAULT 0` | In `core/sync/`; processed in Epic 5 |
| `sync_error_log` | `id TEXT` | `entity_type, entity_id, operation, payload, error_message, failed_at, retry_count INT` | In `core/sync/`; after 3 retries |

### AppDatabase Class Pattern

```dart
// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// Content tables
import 'tables/students_table.dart';
import 'tables/subjects_table.dart';
import 'tables/topics_table.dart';
import 'tables/lessons_table.dart';
import 'tables/lesson_tasks_table.dart';
import 'tables/quiz_questions_table.dart';
import 'tables/quiz_attempts_table.dart';
import 'tables/past_paper_questions_table.dart';
import 'tables/survey_responses_table.dart';
import 'tables/nudge_events_table.dart';
import 'tables/sessions_table.dart';
// Sync tables (separate location)
import '../sync/sync_queue_table.dart';
// DAOs
import 'daos/task_dao.dart';
import 'daos/quiz_dao.dart';
import 'daos/lesson_dao.dart';
import 'daos/student_dao.dart';
import 'daos/survey_dao.dart';
import 'daos/dashboard_dao.dart';
import 'daos/content_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    StudentsTable, SubjectsTable, TopicsTable, LessonsTable,
    LessonTasksTable, QuizQuestionsTable, QuizAttemptsTable,
    PastPaperQuestionsTable, SurveyResponsesTable,
    NudgeEventsTable, SessionsTable,
    SyncQueueTable, SyncErrorLogTable,
  ],
  daos: [
    TaskDao, QuizDao, LessonDao, StudentDao,
    SurveyDao, DashboardDao, ContentDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'studyboard.db'));

  // Named constructor for tests — pass NativeDatabase.memory()
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // v1 → v2+ migrations added here in future stories
    },
  );
}
```

### Riverpod Provider Pattern (Riverpod 4.x)

```dart
// lib/core/database/database_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_database.dart';
import 'daos/task_dao.dart';
// ... other DAO imports

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
TaskDao taskDao(TaskDaoRef ref) => ref.watch(appDatabaseProvider).taskDao;

@Riverpod(keepAlive: true)
QuizDao quizDao(QuizDaoRef ref) => ref.watch(appDatabaseProvider).quizDao;

// ... same pattern for all remaining DAOs
```

> **keepAlive: true is mandatory** — the database must not be disposed during the app lifecycle. Riverpod 4.x (`riverpod_annotation: ^4.0.2`) generates `appDatabaseProvider` (lowercase). Verify the generated name after `dart run build_runner build`.

### Freezed Domain Model Pattern (Freezed 3.x)

All domain models need BOTH `part '*.freezed.dart'` AND `part '*.g.dart'` directives.

```dart
// lib/features/board/domain/task.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'task_status.dart'; // IMPORT — never redeclare TaskStatus

part 'task.freezed.dart';
part 'task.g.dart';

// Converter between TaskStatus enum and its DB string representation
class TaskStatusConverter implements JsonConverter<TaskStatus, String> {
  const TaskStatusConverter();
  @override
  TaskStatus fromJson(String json) => TaskStatusX.fromString(json);
  @override
  String toJson(TaskStatus object) => object.toDbString();
}

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String studentId,
    required String lessonId,
    @TaskStatusConverter() required TaskStatus taskStatus,
    required bool curiosityCompleted,
    required String createdAt,
    required String updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
```

> `freezed: ^3.2.5` with `freezed_annotation: ^3.1.0` are the actual installed versions. Supabase returns snake_case JSON (`task_status`, `student_id`). By default, `fromJson` maps `taskStatus` ↔ `task_status` only if `@JsonSerializable(fieldRename: FieldRename.snake)` is applied. Either add this annotation or use explicit `@JsonKey(name: 'task_status')` on each field that deviates. The explicit `@JsonKey` approach is safer across mixed-case fields.

### DAO Pattern — Named Task Methods (Architecture-Critical)

The `TaskDao` must expose only named, intentional methods for task state mutations. No generic `updateStatus(id, status)` exists anywhere.

```dart
// lib/core/database/daos/task_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [LessonTasksTable, SyncQueueTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Future<void> markTaskComplete(String taskId) => transaction(() async {
    final now = DateTime.now().toUtc().toIso8601String();
    await (update(lessonTasksTable)..where((t) => t.id.equals(taskId)))
        .write(LessonTasksTableCompanion(
          taskStatus: const Value('done'),
          updatedAt: Value(now),
        ));
    await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
      id: Value(_newUuid()),
      entityType: const Value('task_status'),
      entityId: Value(taskId),
      operation: const Value('upsert'),
      payload: Value('{"task_status":"done","task_id":"$taskId"}'),
      createdAt: Value(now),
    ));
  });

  Future<void> resetTaskToInProgress(String taskId) => transaction(() async {
    final now = DateTime.now().toUtc().toIso8601String();
    await (update(lessonTasksTable)..where((t) => t.id.equals(taskId)))
        .write(LessonTasksTableCompanion(
          taskStatus: const Value('in_progress'),
          updatedAt: Value(now),
        ));
    await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
      id: Value(_newUuid()),
      entityType: const Value('task_status'),
      entityId: Value(taskId),
      operation: const Value('upsert'),
      payload: Value('{"task_status":"in_progress","task_id":"$taskId"}'),
      createdAt: Value(now),
    ));
  });

  Future<void> pullToTodo(String taskId) => transaction(() async {
    // Same pattern — sets 'todo', enqueues sync
  });

  Future<void> startTask(String taskId) => transaction(() async {
    // Same pattern — sets 'in_progress', enqueues sync
  });

  Future<LessonTasksTableData?> getTaskByLesson(
    String studentId,
    String lessonId,
  ) =>
      (select(lessonTasksTable)
            ..where(
              (t) =>
                  t.studentId.equals(studentId) &
                  t.lessonId.equals(lessonId),
            ))
          .getSingleOrNull();
}

String _newUuid() {
  // Requires uuid package — see UUID section below
  const uuid = Uuid();
  return uuid.v4();
}
```

### UUID Package

The `uuid` package is not in the current `pubspec.yaml`. DAOs need UUIDs for sync_queue `id` generation. Add it:

```yaml
# pubspec.yaml — add under dependencies:
uuid: ^4.5.1
```

Then import in DAOs that generate sync_queue entries:
```dart
import 'package:uuid/uuid.dart';
const _uuid = Uuid();
// Usage: _uuid.v4()
```

Alternatively, if you prefer not to add a dependency, use a simpler approach:
```dart
import 'dart:math' show Random;
String _newUuid() {
  final r = Random.secure();
  final bytes = List<int>.generate(16, (_) => r.nextInt(256));
  // Format as UUID v4
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0,8)}-${hex.substring(8,12)}-${hex.substring(12,16)}-${hex.substring(16,20)}-${hex.substring(20)}';
}
```

The `uuid` package approach is cleaner and more readable — prefer it.

### Build Runner Command

Always run from within `studyboard_mobile/`:
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Do NOT use** `flutter pub run build_runner` — this is the learned pattern from Stories 1.1 and 1.2.

**Generated files after successful run:**
- `lib/core/database/app_database.g.dart` — `_$AppDatabase` and Companion classes
- `lib/core/database/database_provider.g.dart` — Riverpod provider
- `lib/core/database/daos/task_dao.g.dart` — `_$TaskDaoMixin`
- `lib/core/database/daos/quiz_dao.g.dart`, `lesson_dao.g.dart`, `student_dao.g.dart`, `survey_dao.g.dart`, `dashboard_dao.g.dart`, `content_dao.g.dart`
- `lib/features/*/domain/*.freezed.dart` + `*.g.dart` for all domain models

### Schema Snapshot for Migration Testing

After build_runner completes successfully:
```bash
dart run drift_dev schema generate lib/core/database/app_database.dart drift_schemas/drift_schema_v1.json
```

This generates a JSON snapshot of the v1 schema. Future migration tests use this snapshot to verify v1→v2 upgrades are non-destructive.

### Database Test Pattern

```dart
// test/core/database/app_database_test.dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  test('fresh install creates all 13 required tables', () async {
    final rows = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' "
      "AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'drift_%'",
    ).get();
    final names = rows.map((r) => r.data['name'] as String).toSet();

    expect(names, containsAll([
      'students', 'subjects', 'topics', 'lessons', 'lesson_tasks',
      'quiz_questions', 'quiz_attempts', 'past_paper_questions',
      'sync_queue', 'sync_error_log', 'survey_responses',
      'nudge_events', 'sessions',
    ]));
  });

  test('task_status CHECK constraint rejects invalid values', () async {
    final now = DateTime.now().toUtc().toIso8601String();
    await expectLater(
      db.into(db.lessonTasksTable).insert(
        LessonTasksTableCompanion.insert(
          id: const Value('test-id'),
          studentId: const Value('s1'),
          lessonId: const Value('l1'),
          taskStatus: const Value('INVALID'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      ),
      throwsA(anything),
    );
  });

  test('TaskStatus enum round-trips through toDbString/fromString', () {
    for (final status in TaskStatus.values) {
      final dbStr = status.toDbString();
      expect(TaskStatusX.fromString(dbStr), equals(status));
    }
  });

  test('sessions attributed_nudge_id is nullable', () async {
    final now = DateTime.now().toUtc().toIso8601String();
    await db.into(db.sessionsTable).insert(
      SessionsTableCompanion.insert(
        id: const Value('sess-1'),
        studentId: const Value('s1'),
        startedAt: Value(now),
        // attributed_nudge_id omitted — must default to null
      ),
    );
    final row = await db.select(db.sessionsTable).getSingle();
    expect(row.attributedNudgeId, isNull);
  });
}
```

### DashboardDao SQL Queries

The `DashboardDao` methods require SQL that joins across tables. For Story 1.3, implement the SQL now so the database layer is complete:

```dart
// Coverage % = quiz-verified Done tasks / total tasks for subject
Future<double> getCoveragePercent(String studentId, String subjectId) async {
  final result = await customSelect(
    '''
    SELECT
      CAST(SUM(CASE WHEN lt.task_status = 'done' THEN 1 ELSE 0 END) AS REAL)
        / CAST(COUNT(*) AS REAL) AS coverage
    FROM lesson_tasks lt
    JOIN lessons l ON lt.lesson_id = l.id
    JOIN topics t ON l.topic_id = t.id
    WHERE lt.student_id = ? AND t.subject_id = ?
    ''',
    variables: [Variable(studentId), Variable(subjectId)],
  ).getSingleOrNull();
  return (result?.data['coverage'] as double?) ?? 0.0;
}

// Streak = consecutive calendar days with a session record
Future<int> getStreak(String studentId) async {
  final rows = await customSelect(
    '''
    SELECT DISTINCT date(started_at) AS session_date
    FROM sessions
    WHERE student_id = ?
    ORDER BY session_date DESC
    ''',
    variables: [Variable(studentId)],
  ).get();
  if (rows.isEmpty) return 0;
  var streak = 1;
  var prev = DateTime.parse(rows.first.data['session_date'] as String);
  for (var i = 1; i < rows.length; i++) {
    final curr = DateTime.parse(rows[i].data['session_date'] as String);
    if (prev.difference(curr).inDays == 1) {
      streak++;
      prev = curr;
    } else {
      break;
    }
  }
  return streak;
}
```

> If implementing the full SQL in this story proves too complex, stub with `throw UnimplementedError()` — the DashboardDao SQL is tested and fully implemented in Epic 6 stories. The key requirement for Story 1.3 is that the DAO class exists with correct method signatures and is accessible from `AppDatabase`.

### Previous Story Learnings (Critical)

- **riverpod_annotation `^4.0.2` + riverpod_generator `^4.0.3`**: Generates `appDatabaseProvider` (not `AppDatabaseProvider`). Use `@Riverpod(keepAlive: true)` annotation. Run `dart run build_runner build`, NOT `flutter pub run`.
- **freezed `^3.2.5`**: Import from `package:freezed_annotation/freezed_annotation.dart`. Requires BOTH `part '*.freezed.dart'` and `part '*.g.dart'` directives.
- **Build runner**: Always `dart run build_runner build --delete-conflicting-outputs` from the `studyboard_mobile/` directory.
- **TaskStatus enum**: Already in `lib/features/board/domain/task_status.dart`. `TaskStatusX.fromString` throws `ArgumentError` for unknown values — this is pre-existing and noted in deferred-work.md. Do NOT modify it in this story.
- **Backlog screen deviation**: The actual code has `lib/features/backlog/presentation/backlog_screen.dart` (not `lib/features/board/`). For domain models, follow the architecture's `lib/features/board/domain/` path — the presentation deviation doesn't affect the database layer.
- **dart run drift_dev**: After `build_runner`, run `dart run drift_dev schema generate ...` to produce the schema snapshot. The `drift_dev` package is already in `dev_dependencies`.

### Architecture Compliance Checklist

- [ ] All 13 tables present on fresh install (AC #1)
- [ ] `SyncQueueTable` + `SyncErrorLogTable` in `lib/core/sync/sync_queue_table.dart` (NOT in `tables/`)
- [ ] `lesson_tasks.task_status` has DB-level CHECK constraint (AC #2)
- [ ] `TaskStatusX.fromString()` / `toDbString()` are the ONLY conversion paths — no raw string comparisons
- [ ] `TaskDao.markTaskComplete()` is a named method — the ONLY valid path to `'done'` status
- [ ] `TaskDao.resetTaskToInProgress()` is a named method — no generic `setStatus()`
- [ ] `sessions.attributed_nudge_id` is nullable (AC #4)
- [ ] All domain models: `@freezed` with `fromJson`/`toJson` (AC #5)
- [ ] `AppDatabase.forTesting(QueryExecutor)` named constructor for test isolation
- [ ] `@Riverpod(keepAlive: true)` on `appDatabase` provider
- [ ] `ref.onDispose(db.close)` in `appDatabase` provider
- [ ] Schema snapshot generated at `drift_schemas/drift_schema_v1.json`
- [ ] `flutter analyze` → 0 issues
- [ ] `flutter test` → all pass

### Anti-Patterns to Avoid

- ❌ Redeclaring `TaskStatus` enum — it lives in `lib/features/board/domain/task_status.dart`
- ❌ Raw string comparisons: `if (task.taskStatus == 'done')` — always use `TaskStatus.done`
- ❌ Placing sync tables in `lib/core/database/tables/` — they belong in `lib/core/sync/`
- ❌ Using `flutter pub run build_runner` — always `dart run build_runner`
- ❌ Missing `@Riverpod(keepAlive: true)` on database provider — causes disposal mid-session
- ❌ Missing `AppDatabase.forTesting()` named constructor — tests cannot create in-memory DB
- ❌ Generic `updateStatus(String taskId, String status)` on TaskDao — only named status methods
- ❌ Adding `TaskStatus.reopened` enum value — deferred; the `taskReopened` color token already exists in theme but the enum value is not yet added (Story 1.2 deferred item)
- ❌ `supabase.from(...)` calls inside DAOs — DAOs are pure Drift; Supabase access is in `features/*/data/` repositories

### Project Structure Notes

**Files to CREATE:**
```
studyboard_mobile/
├── lib/core/database/
│   ├── app_database.dart               # @DriftDatabase singleton + .forTesting constructor
│   ├── database_provider.dart          # @Riverpod(keepAlive) for AppDatabase + all DAOs
│   ├── tables/
│   │   ├── students_table.dart
│   │   ├── subjects_table.dart
│   │   ├── topics_table.dart
│   │   ├── lessons_table.dart
│   │   ├── lesson_tasks_table.dart     # CHECK constraint + UNIQUE(student_id, lesson_id)
│   │   ├── quiz_questions_table.dart
│   │   ├── quiz_attempts_table.dart
│   │   ├── past_paper_questions_table.dart
│   │   ├── survey_responses_table.dart
│   │   ├── nudge_events_table.dart
│   │   └── sessions_table.dart         # attributed_nudge_id nullable
│   └── daos/
│       ├── task_dao.dart               # markTaskComplete, resetTaskToInProgress, pullToTodo, startTask
│       ├── quiz_dao.dart
│       ├── lesson_dao.dart
│       ├── student_dao.dart            # softDelete anonymizes PII in same transaction
│       ├── survey_dao.dart
│       ├── dashboard_dao.dart          # SQL queries for coverage%, streak, accuracy, weakTopics
│       └── content_dao.dart            # getAllLessons for image pre-fetch support
├── lib/core/sync/
│   └── sync_queue_table.dart           # SyncQueueTable + SyncErrorLogTable (same file)
├── lib/features/auth/domain/
│   └── student.dart                    # @freezed
├── lib/features/board/domain/
│   └── task.dart                       # @freezed; imports TaskStatus (never redeclares)
├── lib/features/lesson/domain/
│   ├── lesson.dart                     # @freezed
│   └── past_paper_question.dart        # @freezed
├── lib/features/quiz/domain/
│   ├── quiz_question.dart              # @freezed
│   └── quiz_attempt.dart               # @freezed
├── lib/features/survey/domain/
│   └── survey_response.dart            # @freezed
├── lib/features/dashboard/domain/
│   └── dashboard_stats.dart            # @freezed WeakTopic + DashboardStats
└── drift_schemas/
    └── drift_schema_v1.json            # GENERATED by drift_dev schema generate
```

**Files to CREATE for tests:**
```
studyboard_mobile/test/core/database/
├── app_database_test.dart              # Table existence, CHECK constraint, round-trip tests
└── migrations_test.dart                # SchemaVerifier against v1 snapshot
```

**Files to MODIFY:**
```
studyboard_mobile/pubspec.yaml          # Add uuid: ^4.5.1 if adopting uuid package
```

**Files NOT to modify:**
- `lib/features/board/domain/task_status.dart` — complete as-is; do NOT add `reopened` value
- `lib/core/failures/failure.dart` — complete as-is
- `lib/core/supabase/repository_base.dart` — complete as-is
- Any theme files from Story 1.2

### References

- [Source: epics.md#Story 1.3] — Acceptance criteria, required table list (13 tables)
- [Source: architecture.md#Data Architecture] — sync_queue format, Drift migration approach, offline-first write contract
- [Source: architecture.md#Complete Project Directory Structure] — exact file paths for tables, DAOs, sync folder
- [Source: architecture.md#Communication Patterns] — Task state machine; named methods `markTaskComplete` + `resetTaskToInProgress`; sync queue entry format
- [Source: architecture.md#Format Patterns] — snake_case DB ↔ camelCase Dart; TaskStatus enum; UUID as TEXT
- [Source: architecture.md#Gap Analysis] — `quiz_pass_threshold` on subjects, `content_version`, `students.last_active_at`, `fcm_token`
- [Source: 1-2-app-theme-design-system-and-navigation-shell.md#Dev Agent Record] — riverpod_generator 4.x actual behavior, `dart run build_runner` command, keepAlive annotation fix
- [Source: 1-1-flutter-project-scaffold-and-core-architecture.md#Dev Agent Record] — freezed actual versions, bootstrap pattern, TaskStatus existing location
- [Source: deferred-work.md] — `TaskStatus.fromString` throws `ArgumentError` (pre-existing, do NOT fix); `taskReopened` token exists without matching enum value (do NOT add enum value yet)

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- Freezed 3.x + Dart 3.x requires `abstract class X with _$X` — plain `class` causes compile error (`non_abstract_class_inherits_abstract_member`). All 8 domain models updated.
- Riverpod 4.x generates providers using plain `Ref`, not type-specific `AppDatabaseRef`/`TaskDaoRef` etc. Fixed `database_provider.dart` accordingly.
- DAOs must import table files directly (in addition to `app_database.dart`) for Drift code generator to produce correct table accessors in DAO mixins — otherwise mixins are empty.
- `AppDatabase.forTesting` must use `super.e` (matching the generated `_$AppDatabase(QueryExecutor e)` param name).
- `drift_dev schema dump` is the correct command for generating JSON snapshot (not `schema generate` with a JSON arg).
- Migration test helpers generated via `dart run drift_dev schema generate drift_schemas/ test/generated_migrations/`; uses `drift_dev/api/migrations_native.dart` + `SchemaVerifier(GeneratedHelper())`.
- `import 'package:drift/drift.dart' hide isNull` needed in tests to resolve ambiguity with `flutter_test`.
- `very_good_analysis` requires `package:` imports everywhere in `lib/`; `sort_pub_dependencies` requires alphabetical pubspec ordering.

### Completion Notes List

- All 13 tables created and verified present on fresh install (AC #1)
- `lesson_tasks.task_status` has DB-level CHECK constraint enforcing valid values (AC #2)
- `TaskStatusX.fromString()` / `toDbString()` are the only conversion paths — no raw string comparisons (AC #2)
- `sync_queue` table matches AC #3 exactly: id UUID TEXT PK, entity_type, entity_id, operation, payload, created_at, retry_count INT DEFAULT 0
- `sessions.attributed_nudge_id` is nullable TEXT (AC #4)
- All 7 DAOs accessible from `AppDatabase`; all 8 freezed domain models have `fromJson`/`toJson` with explicit snake_case→camelCase `@JsonKey` mappings (AC #5)
- Schema snapshot at `drift_schemas/drift_schema_v1.json`; migration test passes via `SchemaVerifier` (AC #6)
- `flutter analyze` → 0 issues; `flutter test` → 48/48 pass

### File List

**Created:**
- `lib/core/database/tables/students_table.dart`
- `lib/core/database/tables/subjects_table.dart`
- `lib/core/database/tables/topics_table.dart`
- `lib/core/database/tables/lessons_table.dart`
- `lib/core/database/tables/lesson_tasks_table.dart`
- `lib/core/database/tables/quiz_questions_table.dart`
- `lib/core/database/tables/quiz_attempts_table.dart`
- `lib/core/database/tables/past_paper_questions_table.dart`
- `lib/core/database/tables/survey_responses_table.dart`
- `lib/core/database/tables/nudge_events_table.dart`
- `lib/core/database/tables/sessions_table.dart`
- `lib/core/sync/sync_queue_table.dart`
- `lib/core/database/daos/task_dao.dart`
- `lib/core/database/daos/quiz_dao.dart`
- `lib/core/database/daos/lesson_dao.dart`
- `lib/core/database/daos/student_dao.dart`
- `lib/core/database/daos/survey_dao.dart`
- `lib/core/database/daos/dashboard_dao.dart`
- `lib/core/database/daos/content_dao.dart`
- `lib/core/database/app_database.dart`
- `lib/core/database/database_provider.dart`
- `lib/features/auth/domain/student.dart`
- `lib/features/board/domain/task.dart`
- `lib/features/lesson/domain/lesson.dart`
- `lib/features/lesson/domain/past_paper_question.dart`
- `lib/features/quiz/domain/quiz_question.dart`
- `lib/features/quiz/domain/quiz_attempt.dart`
- `lib/features/survey/domain/survey_response.dart`
- `lib/features/dashboard/domain/dashboard_stats.dart`
- `drift_schemas/drift_schema_v1.json`
- `test/generated_migrations/schema.dart`
- `test/generated_migrations/schema_v1.dart`
- `test/core/database/app_database_test.dart`
- `test/core/database/migrations_test.dart`

**Modified:**
- `pubspec.yaml` — added `uuid: ^4.5.1`, `json_annotation: ^4.9.0` (dependencies); `json_serializable: ^6.9.4` (dev_dependencies)
- `analysis_options.yaml` — added `non_abstract_class_inherits_abstract_member: ignore` under errors; excluded `test/generated_migrations/**` from analyzer

## Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2026-04-17 | 1.0 | Complete Drift database schema — 13 tables, 7 DAOs, 8 freezed domain models, schema snapshot, migration test | claude-sonnet-4-6 |

### Review Findings

Reviewed: 2026-04-17 | Layers: Blind Hunter, Edge Case Hunter, Acceptance Auditor | Dismissed: 14

#### Decision-Needed

- [x] [Review][Decision→Patch] getStreak timezone — resolved: convert in query; pass UTC offset variable and apply `datetime(started_at, '+X hours')` before bucketing with `date()` [`lib/core/database/daos/dashboard_dao.dart:getStreak`]
- [x] [Review][Decision→Defer] getWeakTopics un-attempted topics — resolved: keep INNER JOIN; weak topics = only topics with ≥1 attempt AND accuracy < 60%; un-attempted topics are managed by the backlog/kanban flow — deferred by design
- [x] [Review][Decision→Patch] startTask vs resetTaskToInProgress identical payloads — resolved: add `"context"` field to distinguish; startTask enqueues `{"task_status":"in_progress","context":"start","task_id":"..."}`, resetTaskToInProgress enqueues `{"task_status":"in_progress","context":"reset","task_id":"..."}` [`lib/core/database/daos/task_dao.dart`]

#### Patch

- [x] [Review][Patch] TaskDao writes raw string literals ('done', 'in_progress', 'todo') instead of using TaskStatus.toDbString() — violates AC #2 which forbids raw string comparisons; fix by using `TaskStatus.done.toDbString()` etc. in all four mutation methods [`lib/core/database/daos/task_dao.dart`]
- [x] [Review][Patch] JSON payload injection via string interpolation — `'{"task_id":"$taskId"}'` and `'{"student_id":"$studentId"}'` produce malformed JSON if IDs contain quotes or backslashes; replace with `jsonEncode({'task_id': taskId})` pattern [`lib/core/database/daos/task_dao.dart`, `lib/core/database/daos/student_dao.dart`]
- [x] [Review][Patch] SurveyDao.saveResponse never enqueues sync_queue — survey responses are local-only; offline data is silently lost; SyncQueueTable is declared in @DriftAccessor but unused; wrap in transaction and enqueue sync entry [`lib/core/database/daos/survey_dao.dart`]
- [x] [Review][Patch] setCuriosityCompleted doesn't update updatedAt and doesn't enqueue sync — curiosity completion never propagates to server; multi-device users will see it reset on reinstall [`lib/core/database/daos/lesson_dao.dart:setCuriosityCompleted`]
- [x] [Review][Patch] QuizDao.saveAttempt doesn't enqueue sync — quiz results are written locally but never reach the server; SyncQueueTable is declared in @DriftAccessor but unused [`lib/core/database/daos/quiz_dao.dart:saveAttempt`]
- [x] [Review][Patch] getStreak returns stale streak for inactive students — streak loop starts from most-recent session without checking if it is today or yesterday; a student who last studied 30 days ago is reported streak = 1 [`lib/core/database/daos/dashboard_dao.dart:getStreak`]
- [x] [Review][Patch] softDelete uses two separate UPDATE calls — PII fields and deleted_at are written in separate statements; merge into one write() call to eliminate the inconsistent-state window [`lib/core/database/daos/student_dao.dart:softDelete`]
- [x] [Review][Patch] softDelete doesn't clear fcmToken — fcmToken is PII and must be nulled alongside name/email/district/school in the anonymisation write [`lib/core/database/daos/student_dao.dart:softDelete`]
- [x] [Review][Patch] SyncErrorLogTable.retryCount has no default — `integer()()` with no `.withDefault(const Constant(0))`; inserting without an explicit value leaves retryCount as NULL, breaking any numeric comparison [`lib/core/sync/sync_queue_table.dart:SyncErrorLogTable`]
- [x] [Review][Patch] Student.fromJson missing @JsonKey on notificationsEnabled, lastActiveAt, createdAt — json_serializable defaults to camelCase keys; Supabase/DB payloads use snake_case; add `@JsonKey(name: 'notifications_enabled')`, `@JsonKey(name: 'last_active_at')`, `@JsonKey(name: 'created_at')` [`lib/features/auth/domain/student.dart`]

#### Deferred

- [x] [Review][Defer] No foreign key constraints anywhere — logical FKs (topicId, lessonId, studentId, attributedNudgeId) have no `references()` calls; orphaned rows accumulate silently — deferred, offline-first design choice; FK enforcement deferred to Epic 5 sync layer
- [x] [Review][Defer] No CHECK constraint on sync_queue.operation and sync_error_log.operation columns — valid values 'upsert'/'soft_delete' are unenforced at DB level — deferred, sync worker is the only writer in current scope
- [x] [Review][Defer] No CHECK constraints on contentTrack ('theory'|'past_papers'|'future_papers'), correctOption ('a'|'b'|'c'|'d'), nudge_events.status ('sent'|'delivered'|'failed') — deferred, add CHECK constraints when content seeding (Story 2.1) and quiz engine (Story 4.1) are implemented
- [x] [Review][Defer] AppDatabase.onUpgrade is an empty handler — correct for schemaVersion=1 with no upgrade history; becomes dangerous when schemaVersion is bumped without adding a migration branch — deferred, add a guard assert when v2 schema is introduced
- [x] [Review][Defer] getWeakTopics HAVING references SELECT alias (accuracy_percent) — SQLite-specific behaviour; non-portable to other SQL engines — deferred, app targets SQLite only; acceptable for current scope
- [x] [Review][Defer] getWeakTopics un-attempted topics (by design decision) — INNER JOIN excludes topics with zero quiz attempts; handled by backlog/kanban flow — deferred by design

#### Re-Review Findings (2026-04-18) — dismissed: 9

- [x] [Review][Patch] TaskDao mutation methods enqueue sync even when UPDATE affects 0 rows — all four methods (`markTaskComplete`, `resetTaskToInProgress`, `pullToTodo`, `startTask`) insert a sync_queue row regardless of whether the UPDATE matched a task; check `affected == 0` and return early [`lib/core/database/daos/task_dao.dart`]
- [x] [Review][Patch] getCoveragePercent SQL uses raw string literal `'done'` — AC #2 violation; replace with parameterised variable `Variable(TaskStatus.done.toDbString())` in the CASE WHEN clause [`lib/core/database/daos/dashboard_dao.dart:getCoveragePercent`]
- [x] [Review][Patch] getStreak todayStr/yesterdayStr computed from `DateTime.now()` (device local) instead of UTC+utcOffsetMinutes — if caller passes an offset that differs from the device timezone, the today/yesterday guard silently fails; derive local "today" from `DateTime.now().toUtc().add(Duration(minutes: utcOffsetMinutes))` [`lib/core/database/daos/dashboard_dao.dart:getStreak`]
- [x] [Review][Patch] LessonDao uses `attachedDatabase.syncQueueTable` — mixin accessor `syncQueueTable` now exists after build_runner regeneration; use it directly for consistency with all other DAOs [`lib/core/database/daos/lesson_dao.dart:setCuriosityCompleted`]
- [x] [Review][Patch] StudentDao.deactivate has no transaction boundary and no sync enqueue — unlike softDelete, deactivation is a local-only write with no corresponding sync_queue entry; wrap in `transaction()` and enqueue [`lib/core/database/daos/student_dao.dart:deactivate`]
- [x] [Review][Defer] DashboardStats.tasksInDone has no backing DAO method — `DashboardDao` contains no `getTasksInDone` query; field cannot be populated from the DB layer — pre-existing gap, Epic 6 scope
