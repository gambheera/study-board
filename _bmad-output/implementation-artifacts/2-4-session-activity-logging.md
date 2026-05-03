# Story 2.4: Session Activity Logging

Status: done

## Story

As a developer,
I want every app session start recorded in the `sessions` table,
So that the experiment's primary success metric (≥3 sessions per week) can be measured reliably.

## Acceptance Criteria

1. **Given** a student opens the app (cold start or foreground resume after >30 minutes in background) **When** the app becomes active **Then** a `sessions` record is inserted into Drift with `id (UUID)`, `student_id`, `started_at (ISO 8601 UTC)`, and `attributed_nudge_id = null` (attribution filled by Epic 8); a sync queue entry is enqueued in the same transaction

2. **Given** a session record is created **When** the student closes or backgrounds the app **Then** the session record is updated with `ended_at` timestamp in Drift and a sync queue entry is enqueued — session duration is computable from `started_at` and `ended_at`

3. **Given** the `students` table `last_active_at` column **When** any meaningful student interaction occurs (app open, task state change, quiz answer) **Then** `last_active_at` is updated in Drift and enqueued for sync — this field drives the FCM inactivity detection trigger in Epic 8

4. **Given** the app is offline when a session starts **When** connectivity returns **Then** the session record syncs to Supabase via the sync queue with no data loss — offline sessions are not silently dropped

5. **Given** session data in Supabase **When** queried for experiment analysis **Then** sessions are queryable by `student_id` and `started_at` to compute weekly session frequency per student against the ≥3 sessions/week success criterion

## Tasks / Subtasks

- [x] Task 1: Create `SessionDao` (AC: #1, #2, #3, #4)
  - [x] Create `lib/core/database/daos/session_dao.dart`
  - [x] Add `@DriftAccessor(tables: [SessionsTable, StudentsTable, SyncQueueTable])` — needs all three for atomic session insert + `last_active_at` update + two sync queue entries in one transaction
  - [x] Add `openSession({required String sessionId, required String studentId, required String startedAt})` → `Future<void>` — Drift transaction: insert `SessionsTableCompanion` with `id`, `studentId`, `startedAt` (endedAt and attributedNudgeId omitted → absent, nullable columns default to null); update `studentsTable` `lastActiveAt = startedAt`; enqueue sync entry for session (`entityType: 'session'`, `entityId: sessionId`, `operation: 'upsert'`, payload with session_id/student_id/started_at); enqueue sync entry for last_active_at (`entityType: 'student'`, `entityId: studentId`, `operation: 'upsert'`, payload with student_id/last_active_at)
  - [x] Add `closeSession({required String sessionId, required String endedAt})` → `Future<void>` — Drift transaction: update `sessionsTable` where `id == sessionId` setting `endedAt`; guard with `if (affected == 0) return`; enqueue sync entry (`entityType: 'session'`, `entityId: sessionId`, `operation: 'upsert'`, payload with session_id/ended_at)
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/`

- [x] Task 2: Wire `SessionDao` into `AppDatabase` (AC: #1, #2)
  - [x] Open `lib/core/database/app_database.dart`
  - [x] Add `import 'package:studyboard_mobile/core/database/daos/session_dao.dart';`
  - [x] Add `SessionDao` to the `daos:` list inside `@DriftDatabase(...)` annotation
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` — regenerates `app_database.g.dart` which exposes `.sessionDao` on `AppDatabase`

- [x] Task 3: Fix `StudentDao.updateLastActiveAt` to enqueue sync (AC: #3)
  - [x] Open `lib/core/database/daos/student_dao.dart`
  - [x] Current implementation only writes to Drift without enqueueing — `last_active_at` currently NEVER syncs to Supabase (critical gap that affects Epic 8 inactivity detection)
  - [x] Wrap the update in a `transaction()`: update `studentsTable` `lastActiveAt`, then insert sync queue entry (`entityType: 'student'`, `operation: 'upsert'`, payload: `{'student_id': studentId, 'last_active_at': isoTimestamp}`)
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 4: Update `TaskDao` mutations to update `last_active_at` (AC: #3)
  - [x] Open `lib/core/database/daos/task_dao.dart`
  - [x] Add `StudentsTable` to `@DriftAccessor` tables list (currently: `[LessonTasksTable, LessonsTable, TopicsTable, SyncQueueTable]` → add `StudentsTable`)
  - [x] In `pullToTodo(String taskId)`, `startTask(String taskId)`, and `moveToBacklog(String taskId)`: after the existing sync queue insert, resolve `studentId` via `(select(lessonTasksTable)..where((t) => t.id.equals(taskId))).getSingleOrNull()?.studentId` (already have the row from the `affected` guard pattern) then write `StudentsTableCompanion(lastActiveAt: Value(now))` — reuse the same `now` ISO string already computed in each transaction
  - [x] Do NOT add `last_active_at` to `markTaskComplete` or `resetTaskToInProgress` — those will be updated in Epic 4 when quiz interaction points are wired up
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 5: Create `SessionRepository` interface + impl + provider (AC: #1, #2)
  - [x] Create `lib/features/sessions/domain/session_repository.dart` — abstract interface with `openSession(String studentId) → Future<void>` and `closeSession() → Future<void>`
  - [x] Create `lib/features/sessions/data/session_repository_impl.dart` — `SessionRepositoryImpl implements SessionRepository`; injects `SessionDao`; tracks `_currentSessionId` as a `String?` instance variable; `openSession` generates UUID, records it in `_currentSessionId`, calls `SessionDao.openSession`; `closeSession` reads `_currentSessionId`, clears it, calls `SessionDao.closeSession` (no-op if null)
  - [x] Create `lib/features/sessions/data/session_provider.dart` — `@riverpod SessionRepository sessionRepository(Ref ref)` using `ref.watch(appDatabaseProvider).sessionDao`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 6: Create `SessionTrackerNotifier` (AC: #1, #2)
  - [x] Create `lib/features/sessions/presentation/session_tracker_notifier.dart`
  - [x] `@riverpod class SessionTrackerNotifier extends _$SessionTrackerNotifier with WidgetsBindingObserver` — uses `with` (mixin) not `implements`, so all observer methods have default no-op implementations; only `didChangeAppLifecycleState` needs overriding
  - [x] `build()` → `Future<void>`: call `WidgetsBinding.instance.removeObserver(this)` then `WidgetsBinding.instance.addObserver(this)` (removeObserver first prevents double-registration if build is called again); register `ref.onDispose(() => WidgetsBinding.instance.removeObserver(this))`; call `await _openSession()`
  - [x] `_openSession()`: extract `final studentId = ref.read(authProvider).value?.mapOrNull(authenticated: (a) => a.student.id);` — use `ref.read` not `ref.watch` (one-shot action); if null return; call `ref.read(sessionRepositoryProvider).openSession(studentId)`
  - [x] `didChangeAppLifecycleState(AppLifecycleState state)`: on `paused` → store `_backgroundedAt = DateTime.now()` and call `unawaited(ref.read(sessionRepositoryProvider).closeSession())`; on `resumed` → if `_backgroundedAt != null && DateTime.now().difference(_backgroundedAt!) > const Duration(minutes: 30)` → call `unawaited(_openSession())`; clear `_backgroundedAt = null` on resumed regardless
  - [x] `DateTime? _backgroundedAt` stored as notifier instance variable
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 7: Wire `SessionTrackerNotifier` into `ScaffoldWithNavBar` (AC: #1, #2)
  - [x] Open `lib/router.dart`
  - [x] Add import for `session_tracker_notifier.dart`
  - [x] In `ScaffoldWithNavBar.build()`, add `ref.listen(sessionTrackerNotifierProvider, (_, _) {});` immediately after the existing `ref.listen(contentSyncProvider, (_, _) {});` — identical pattern; this creates the notifier when the shell mounts and disposes it on logout/unmount

- [x] Task 8: Write tests (AC: #1, #2, #3, #4)
  - [x] Create `test/core/database/session_dao_test.dart`:
    - `openSession` inserts a session row with correct id/studentId/startedAt and null endedAt
    - `openSession` enqueues exactly 2 sync queue entries (one `session`, one `student` entity type)
    - `openSession` updates `lastActiveAt` on the students row
    - `closeSession` updates `endedAt` on the matching session row
    - `closeSession` enqueues 1 sync queue entry with ended_at in payload
    - `closeSession` is a no-op (no write, no enqueue) when session id not found
  - [x] Create `test/features/sessions/session_tracker_notifier_test.dart`:
    - Notifier calls `openSession` on build when student is authenticated
    - Notifier does NOT call `openSession` on build when student is unauthenticated
    - `didChangeAppLifecycleState(paused)` calls `closeSession`
    - `didChangeAppLifecycleState(resumed)` after >30 min gap calls `openSession`
    - `didChangeAppLifecycleState(resumed)` within 30 min gap does NOT call `openSession`

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/core/database/tables/sessions_table.dart` — `SessionsTable` with columns: `id TEXT PK`, `studentId TEXT`, `startedAt TEXT`, `endedAt TEXT?`, `attributedNudgeId TEXT?`; **DO NOT modify this table**
- `lib/core/database/app_database.dart` — `schemaVersion: 2`; `SessionsTable` is already in the `@DriftDatabase(tables: [...])` list but `SessionDao` is NOT in `daos` list yet — **ADD only** the import and `SessionDao` entry
- `lib/core/database/daos/student_dao.dart` — has `updateLastActiveAt(studentId, isoTimestamp)` that writes to Drift **but does not enqueue sync** — this is a pre-existing sync gap that this story must fix
- `lib/core/database/daos/task_dao.dart` — has `pullToTodo`, `startTask`, `moveToBacklog`, `markTaskComplete`, `resetTaskToInProgress`; add `last_active_at` update to first three only; skip `markTaskComplete`/`resetTaskToInProgress` (Epic 4 scope)
- `lib/router.dart` — `ScaffoldWithNavBar.build()` has `ref.listen(contentSyncProvider, (_, _) {})` as the established side-effect provider wiring pattern; follow exactly
- `lib/core/database/database_provider.dart` — `appDatabaseProvider` is here; access `.sessionDao` property after Task 2 completes
- `lib/features/auth/presentation/auth_notifier.dart` — `authProvider` (no `Notifier` suffix, Riverpod 4.x strips it); extract student via `ref.read(authProvider).value?.mapOrNull(authenticated: (a) => a.student)`

### SessionDao — Full Implementation Reference

```dart
// lib/core/database/daos/session_dao.dart
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/sessions_table.dart';
import 'package:studyboard_mobile/core/database/tables/students_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';
import 'package:uuid/uuid.dart';

part 'session_dao.g.dart';

const _uuid = Uuid();

@DriftAccessor(tables: [SessionsTable, StudentsTable, SyncQueueTable])
class SessionDao extends DatabaseAccessor<AppDatabase>
    with _$SessionDaoMixin {
  SessionDao(super.attachedDatabase);

  Future<void> openSession({
    required String sessionId,
    required String studentId,
    required String startedAt,
  }) =>
      transaction(() async {
        await into(sessionsTable).insert(
          SessionsTableCompanion.insert(
            id: sessionId,
            studentId: studentId,
            startedAt: startedAt,
          ),
        );
        await (update(studentsTable)..where((t) => t.id.equals(studentId)))
            .write(StudentsTableCompanion(lastActiveAt: Value(startedAt)));
        await into(syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: _uuid.v4(),
            entityType: 'session',
            entityId: sessionId,
            operation: 'upsert',
            payload: jsonEncode({
              'session_id': sessionId,
              'student_id': studentId,
              'started_at': startedAt,
            }),
            createdAt: startedAt,
          ),
        );
        await into(syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: _uuid.v4(),
            entityType: 'student',
            entityId: studentId,
            operation: 'upsert',
            payload: jsonEncode({
              'student_id': studentId,
              'last_active_at': startedAt,
            }),
            createdAt: startedAt,
          ),
        );
      });

  Future<void> closeSession({
    required String sessionId,
    required String endedAt,
  }) =>
      transaction(() async {
        final affected =
            await (update(sessionsTable)
                  ..where((t) => t.id.equals(sessionId)))
                .write(SessionsTableCompanion(endedAt: Value(endedAt)));
        if (affected == 0) return;
        await into(syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: _uuid.v4(),
            entityType: 'session',
            entityId: sessionId,
            operation: 'upsert',
            payload: jsonEncode({
              'session_id': sessionId,
              'ended_at': endedAt,
            }),
            createdAt: endedAt,
          ),
        );
      });
}
```

### SessionRepository — Interface & Impl

```dart
// lib/features/sessions/domain/session_repository.dart
abstract interface class SessionRepository {
  Future<void> openSession(String studentId);
  Future<void> closeSession();
}

// lib/features/sessions/data/session_repository_impl.dart
import 'package:uuid/uuid.dart';
import 'package:studyboard_mobile/core/database/daos/session_dao.dart';
import 'package:studyboard_mobile/features/sessions/domain/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._sessionDao);
  final SessionDao _sessionDao;

  String? _currentSessionId;
  static const _uuid = Uuid();

  @override
  Future<void> openSession(String studentId) async {
    final sessionId = _uuid.v4();
    _currentSessionId = sessionId;
    final now = DateTime.now().toUtc().toIso8601String();
    await _sessionDao.openSession(
      sessionId: sessionId,
      studentId: studentId,
      startedAt: now,
    );
  }

  @override
  Future<void> closeSession() async {
    final sessionId = _currentSessionId;
    if (sessionId == null) return;
    _currentSessionId = null;
    final now = DateTime.now().toUtc().toIso8601String();
    await _sessionDao.closeSession(sessionId: sessionId, endedAt: now);
  }
}

// lib/features/sessions/data/session_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/features/sessions/data/session_repository_impl.dart';
import 'package:studyboard_mobile/features/sessions/domain/session_repository.dart';

part 'session_provider.g.dart';

@riverpod
SessionRepository sessionRepository(Ref ref) {
  return SessionRepositoryImpl(ref.watch(appDatabaseProvider).sessionDao);
}
```

### SessionTrackerNotifier — Full Pattern

```dart
// lib/features/sessions/presentation/session_tracker_notifier.dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/sessions/data/session_provider.dart';

part 'session_tracker_notifier.g.dart';

@riverpod
class SessionTrackerNotifier extends _$SessionTrackerNotifier
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  Future<void> build() async {
    // removeObserver first prevents double-registration if Riverpod ever
    // calls build() again on the same notifier instance.
    WidgetsBinding.instance
      ..removeObserver(this)
      ..addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    await _openSession();
  }

  Future<void> _openSession() async {
    // Use ref.read — one-shot action, not reactive.
    // Extract studentId to final before async gap (Dart type promotion in closures).
    final studentId = ref
        .read(authProvider)
        .value
        ?.mapOrNull(authenticated: (a) => a.student.id);
    if (studentId == null) return;
    await ref.read(sessionRepositoryProvider).openSession(studentId);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _backgroundedAt = DateTime.now();
        unawaited(ref.read(sessionRepositoryProvider).closeSession());
      case AppLifecycleState.resumed:
        final backgrounded = _backgroundedAt;
        _backgroundedAt = null;
        if (backgrounded != null &&
            DateTime.now().difference(backgrounded) >
                const Duration(minutes: 30)) {
          unawaited(_openSession());
        }
      default:
        break;
    }
  }
}
```

### TaskDao — `last_active_at` Addition Pattern

```dart
// Update @DriftAccessor annotation in task_dao.dart:
@DriftAccessor(
  tables: [LessonTasksTable, LessonsTable, TopicsTable, SyncQueueTable, StudentsTable],
)

// Add to each of pullToTodo, startTask, moveToBacklog, after the sync queue insert:
// (The row.studentId is available from the existing getSingleOrNull guard, or resolve inline)

// Example for pullToTodo (already has affected == 0 guard via the update result):
// After the existing sync queue insert in the transaction:
await (update(studentsTable)
      ..where((t) => t.id.equals(studentId)))  // studentId resolved from task row
    .write(StudentsTableCompanion(lastActiveAt: Value(now)));
```

**Note:** `pullToTodo`, `startTask`, and `moveToBacklog` all use a pattern like:
```dart
Future<void> pullToTodo(String taskId) => transaction(() async {
  final now = DateTime.now().toUtc().toIso8601String();
  final affected = await (update(lessonTasksTable)
    ..where((t) => t.id.equals(taskId)))
    .write(...);
  if (affected == 0) return;
  // ... sync queue insert ...
});
```
To get `studentId`, add a query inside the transaction:
```dart
final taskRow = await (select(lessonTasksTable)
    ..where((t) => t.id.equals(taskId)))
  .getSingleOrNull();
if (taskRow == null) return;  // replaces the affected == 0 guard
final studentId = taskRow.studentId;
```
Then proceed with the existing update logic and add the `last_active_at` write at the end.

### StudentDao.updateLastActiveAt — Fix

```dart
// BEFORE (current — broken: Drift write only, no sync):
Future<void> updateLastActiveAt(String studentId, String isoTimestamp) =>
    (update(studentsTable)..where((t) => t.id.equals(studentId)))
        .write(StudentsTableCompanion(lastActiveAt: Value(isoTimestamp)));

// AFTER (correct):
Future<void> updateLastActiveAt(String studentId, String isoTimestamp) =>
    transaction(() async {
      await (update(studentsTable)..where((t) => t.id.equals(studentId)))
          .write(StudentsTableCompanion(lastActiveAt: Value(isoTimestamp)));
      await into(syncQueueTable).insert(
        SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'student',
          entityId: studentId,
          operation: 'upsert',
          payload: jsonEncode({
            'student_id': studentId,
            'last_active_at': isoTimestamp,
          }),
          createdAt: isoTimestamp,
        ),
      );
    });
```

### Key Architecture Constraints

- `SessionDao` and `SessionRepositoryImpl` are pure Drift — NO Supabase calls
- `sessionRepositoryProvider` uses `ref.watch(appDatabaseProvider).sessionDao` — established pattern
- `SessionTrackerNotifier` uses `ref.read(authProvider)` not `ref.watch` — one-shot, not reactive
- Dart type promotion: extract `final studentId = ...` before any `await` calls
- `AppDatabase.schemaVersion` stays at **2** — `SessionsTable` already exists in the schema from Story 1.3; zero schema changes in this story
- `sort_constructors_first` lint: constructor before field declarations in all new classes
- All imports use `package:` prefix — no relative imports in `lib/`
- Sync queue entity types used: `'session'` (new), `'student'` (already used by StudentDao)
- `unawaited()` from `dart:async` required for fire-and-forget Futures in void lifecycle callbacks

### Build Runner Order

After Tasks 1–6, run a single `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/`. Changes span multiple `@DriftAccessor` and `@riverpod` annotations — batching is safe since they don't depend on each other's generated output.

### Project Structure — Files This Story Creates/Modifies

**Create:**
```
lib/core/database/daos/session_dao.dart
lib/core/database/daos/session_dao.g.dart                        (generated)
lib/features/sessions/domain/session_repository.dart
lib/features/sessions/data/session_repository_impl.dart
lib/features/sessions/data/session_provider.dart
lib/features/sessions/data/session_provider.g.dart               (generated)
lib/features/sessions/presentation/session_tracker_notifier.dart
lib/features/sessions/presentation/session_tracker_notifier.g.dart (generated)
test/core/database/session_dao_test.dart
test/features/sessions/session_tracker_notifier_test.dart
```

**Modify:**
```
lib/core/database/app_database.dart          # Add SessionDao to daos list
lib/core/database/app_database.g.dart        # Regenerated
lib/core/database/daos/student_dao.dart      # Fix updateLastActiveAt to enqueue sync
lib/core/database/daos/student_dao.g.dart    # Regenerated
lib/core/database/daos/task_dao.dart         # Add StudentsTable + last_active_at updates
lib/core/database/daos/task_dao.g.dart       # Regenerated
lib/router.dart                              # Add ref.listen(sessionTrackerNotifierProvider)
```

**Do NOT modify:**
- `lib/core/database/tables/sessions_table.dart` — table schema is correct as-is
- `lib/core/database/app_database.dart` schema version — stays at **2**
- `lib/features/board/` or `lib/features/backlog/` presentation files — no UI changes
- `lib/core/database/daos/task_dao.dart` `markTaskComplete`/`resetTaskToInProgress` — Epic 4 scope

### 30-Minute Gap — Boundary Conditions

- **Exactly 30 minutes**: uses `>` not `>=` — resuming after exactly 30:00 does NOT open a new session; only after 30:00+ does
- **Cold start (app killed and restarted)**: always opens a new session — `build()` fires on creation regardless of any prior `_backgroundedAt`
- **Rapid background/foreground (< 30 min)**: `_backgroundedAt` is cleared on resume but no new session opened; the existing session (with `endedAt` already written) continues to be the current session in memory — this means `closeSession` was already called on pause and the session technically ended, but no new one opens; acceptable for V1 (session frequency metric still counts correctly)
- **App crash before `closeSession`**: `ended_at` stays null in Drift; session is not lost, just has no end time; session frequency queries still work since they count by `started_at`; Epic 5 does not fix this — it is acceptable for V1

### Anti-Patterns to Avoid

- ❌ Calling `Supabase.instance.client` from `SessionRepositoryImpl` — pure Drift only
- ❌ Using `ref.watch(authProvider)` inside `_openSession` — use `ref.read` (one-shot)
- ❌ Adding `sessionTrackerNotifierProvider` as `ref.watch` in a widget `build` — must be `ref.listen` to avoid spurious rebuilds
- ❌ Forgetting `removeObserver(this)` before `addObserver(this)` in `build()` — causes double lifecycle callbacks if build is re-invoked
- ❌ Implementing `WidgetsBindingObserver` via `implements` — use `with WidgetsBindingObserver` (it's a mixin) so all methods have default no-op implementations
- ❌ Storing `_currentSessionId` in Riverpod state — it's internal `SessionRepositoryImpl` state, not observable UI state
- ❌ Adding `attributed_nudge_id` logic in this story — FK attribution is Epic 8's responsibility; always insert with `attributed_nudge_id = null` here
- ❌ Modifying `schemaVersion` — no schema changes needed

### Story 2.3 Learnings Applied

- **`authProvider`** (not `authNotifierProvider`) — Riverpod 4.x strips `Notifier` suffix from generated provider names
- **Dart closure type promotion** — extract `final studentId = student.id` to a `final` before any `async` gap
- **`package:` imports everywhere** — no relative imports in `lib/`
- **`sort_constructors_first` lint** — constructor before field declarations in all classes
- **`ref.read` for one-shot actions**, `ref.watch` for reactive stream subscriptions
- **`appDatabaseProvider`** — access DAO via `.sessionDao` property, not a separate `sessionDaoProvider`
- **`unawaited()`** from `dart:async` for fire-and-forget `Future<void>` calls in void functions
- **`discarded_futures` lint** — lifecycle observer methods are `void`; wrap async calls with `unawaited()`

### References

- [Source: epics.md#Story 2.4] — Acceptance criteria, session table fields, 30-minute gap rule, last_active_at scope, attributed_nudge_id deferred to Epic 8
- [Source: epics.md#Epic 2] — "session activity logging for experiment measurement; ≥3 sessions/week success criterion"
- [Source: architecture.md#Sync Queue Entry Format] — entity_type/entity_id/operation/payload/created_at schema; Drift write and sync queue enqueue always in same transaction
- [Source: architecture.md#Communication Patterns] — Drift + sync queue in same transaction rule; task state machine context
- [Source: architecture.md#Riverpod State Management] — AsyncNotifier pattern; ref.read for one-shot actions
- [Source: architecture.md#Feature Folder Structure] — `lib/features/sessions/` follows `data/domain/presentation/` convention
- [Source: 2-3-kanban-board-and-task-promotion-flow.md#Dev Notes] — authProvider pattern, Dart closure type promotion, package imports, appDatabaseProvider access, unawaited() lint fix
- [Source: 1-3-complete-drift-database-schema.md] — SessionsTable columns confirmed: id/studentId/startedAt/endedAt(nullable)/attributedNudgeId(nullable); schema v1 includes sessions table; schemaVersion is 2 as of Story 2.2

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

None — all issues resolved during implementation.

### Completion Notes List

1. **`mapOrNull` not in scope**: `mapOrNull` is generated into extension `AuthStatePatterns` in `auth_state.freezed.dart`. Required adding `import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';` to `session_tracker_notifier.dart`.

2. **`DateTime.now()` not fakeable in `testWidgets`**: Dart's built-in `DateTime.now()` returns real wall-clock time even inside a `FakeAsync` zone. Switched to `clock.now()` from `package:clock` (added as direct dependency). `fake_async` injects the fake clock into the zone under the `#clock` key, which `package:clock` reads — `tester.pump(Duration)` then correctly advances `clock.now()`.

3. **Auto-dispose breaking the >30-min test**: `@riverpod` (autoDispose) providers are disposed when there are no active listeners. During `tester.pump(31 min)`, the Riverpod internal microtask fires and disposes `sessionTrackerProvider`, clearing `_backgroundedAt`. Fixed by calling `container.listen<AsyncValue<void>>(sessionTrackerProvider, (_, _) {})` before the pump to hold a subscription, then `addTearDown(sub.close)`.

4. **`fakeAsync` top-level not re-exported**: `flutter_test` in Flutter ≥3.41.0 does not re-export the `fakeAsync()` top-level function. Used `testWidgets` (which runs in its own `FakeAsync` zone) plus `tester.pump(Duration)` instead.

5. **TaskDao `affected == 0` guard replaced**: The `pullToTodo`/`startTask`/`moveToBacklog` methods needed the task's `studentId` to update `last_active_at`. Replaced the `update-then-check-affected` pattern with `select().getSingleOrNull()` first, which provides both the early-exit guard and `studentId` in one step.

### File List

**Created:**
- `lib/core/database/daos/session_dao.dart`
- `lib/core/database/daos/session_dao.g.dart` (generated)
- `lib/features/sessions/domain/session_repository.dart`
- `lib/features/sessions/data/session_repository_impl.dart`
- `lib/features/sessions/data/session_provider.dart`
- `lib/features/sessions/data/session_provider.g.dart` (generated)
- `lib/features/sessions/presentation/session_tracker_notifier.dart`
- `lib/features/sessions/presentation/session_tracker_notifier.g.dart` (generated)
- `test/core/database/session_dao_test.dart`
- `test/features/sessions/session_tracker_notifier_test.dart`

**Modified:**
- `lib/core/database/app_database.dart` — added `SessionDao` to `daos:` list
- `lib/core/database/app_database.g.dart` — regenerated
- `lib/core/database/daos/student_dao.dart` — `updateLastActiveAt` now enqueues sync entry
- `lib/core/database/daos/student_dao.g.dart` — regenerated
- `lib/core/database/daos/task_dao.dart` — added `StudentsTable` + `last_active_at` updates in `pullToTodo`/`startTask`/`moveToBacklog`
- `lib/core/database/daos/task_dao.g.dart` — regenerated
- `lib/router.dart` — added `ref.listen(sessionTrackerProvider, (_, _) {})` in `ScaffoldWithNavBar`
- `pubspec.yaml` — added `clock: ^1.1.2` dependency

### Review Findings

- [x] [Review][Patch] TaskDao `pullToTodo`/`startTask`/`moveToBacklog` write `lastActiveAt` to Drift without enqueueing a student sync entry — AC3 requires sync enqueue for task interactions [`lib/core/database/daos/task_dao.dart`]
- [x] [Review][Patch] `sessionRepositoryProvider` is autoDispose — `_currentSessionId` lost between lifecycle events, leaving DB sessions permanently unclosed [`lib/features/sessions/data/session_provider.dart:9`]
- [x] [Review][Patch] `SessionTrackerNotifier` onDispose doesn't call `closeSession()` — logout/unmount leaves open session with null `endedAt` [`lib/features/sessions/presentation/session_tracker_notifier.dart:20-23`]
- [x] [Review][Defer] `deleteStudent` has no session row cleanup or sync queue entries — out-of-scope method from another story [`lib/core/database/daos/student_dao.dart:63-68`] — deferred, pre-existing
- [x] [Review][Defer] `AppLifecycleState.detached` leaves session unclosed — spec explicitly accepts null `endedAt` for V1 forced-kill scenarios [`lib/features/sessions/presentation/session_tracker_notifier.dart:49-51`] — deferred, pre-existing
- [x] [Review][Defer] `SessionTrackerNotifier._openSession()` reads auth snapshot — session silently skipped if auth hasn't resolved when notifier builds; router guards prevent this in practice [`lib/features/sessions/presentation/session_tracker_notifier.dart:27-31`] — deferred, pre-existing
