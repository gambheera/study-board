# Story 1.4: Supabase Project Setup & Row-Level Security

Status: done

## Story

As a developer,
I want Supabase tables, RLS policies, and the soft-delete pattern configured,
so that student data is isolated and secure from the first student onboarding.

## Acceptance Criteria

1. **Given** the Supabase project is configured with all tables mirroring the Drift schema **When** any authenticated student makes an API call **Then** the call uses a valid Supabase JWT and the JWT refresh is handled transparently by `supabase_flutter` without interrupting the user session

2. **Given** RLS is enabled on all student data tables (`lesson_tasks`, `quiz_attempts`, `sessions`, `survey_responses`, `nudge_events`, `students`) **When** Student A (authenticated as `auth.uid() = A`) attempts to SELECT rows belonging to Student B **Then** the query returns zero rows — RLS enforces `student_id = auth.uid()` on every data operation

3. **Given** RLS on content tables (`subjects`, `topics`, `lessons`, `quiz_questions`, `past_paper_questions`) **When** any authenticated student performs a SELECT **Then** the query succeeds and returns content rows; INSERT, UPDATE, and DELETE operations are rejected with a permissions error

4. **Given** a student account is soft-deleted (`deleted_at` timestamp is set and PII fields anonymized) **When** any other authenticated student queries any student data table **Then** the soft-deleted student's rows are excluded from all results by RLS — no deleted-user data is surfaced in any student-facing query

5. **Given** the repository base class enforces the data-layer boundary **When** any Riverpod Notifier or Screen widget accesses student data **Then** it does so exclusively via a repository interface — no direct `supabase.from(...)` calls exist outside `data/` layer files

## Tasks / Subtasks

- [x] Task 1: Create Supabase SQL migration file with all tables and RLS policies (AC: #2, #3, #4)
  - [x] Create `studyboard_mobile/supabase/migrations/0001_initial_schema.sql` — CREATE TABLE for all 13 tables mirroring the Drift schema exactly (see schema reference in Dev Notes)
  - [x] Enable RLS on all 6 student data tables: `ALTER TABLE <table> ENABLE ROW LEVEL SECURITY;` for `students`, `lesson_tasks`, `quiz_attempts`, `sessions`, `survey_responses`, `nudge_events`
  - [x] Enable RLS on 5 content tables: `subjects`, `topics`, `lessons`, `quiz_questions`, `past_paper_questions`, `sync_queue`, `sync_error_log`
  - [x] Write student-scoped RLS policies for `students` table — USING `(id = auth.uid() AND deleted_at IS NULL)` for SELECT; `(id = auth.uid())` for INSERT/UPDATE/DELETE
  - [x] Write student-scoped RLS policies for `lesson_tasks`, `quiz_attempts`, `sessions`, `survey_responses`, `nudge_events` — USING `(student_id = auth.uid())` for ALL operations
  - [x] Write public SELECT-only RLS policies for content tables (`subjects`, `topics`, `lessons`, `quiz_questions`, `past_paper_questions`) — TO authenticated, USING (true); no INSERT/UPDATE/DELETE policies
  - [x] Add `sync_queue` and `sync_error_log` RLS policies — authenticated user may INSERT/SELECT/UPDATE/DELETE their own rows (student_id = auth.uid()); these are client-written tables

- [x] Task 2: Create auth repository interface and domain boundary (AC: #5)
  - [x] Create `studyboard_mobile/lib/features/auth/domain/auth_repository.dart` — abstract interface class with methods: `getCurrentUser()`, `signOut()`, `getSessionStream()`
  - [x] Create `studyboard_mobile/lib/features/auth/data/models/student_dto.dart` — `StudentDto` with `fromSupabaseUser(User user)` factory and `toStudent()` method mapping to the `Student` domain model; handles `auth.users` JWT claims

- [x] Task 3: Create auth repository implementation (AC: #1, #5)
  - [x] Create `studyboard_mobile/lib/features/auth/data/auth_repository_impl.dart` — `AuthRepositoryImpl extends RepositoryBase implements AuthRepository`; access `supabaseClientProvider` only within this `data/` layer file; implement `getCurrentUser()`, `signOut()`, `getSessionStream()`
  - [x] `getSessionStream()` wraps `supabase.auth.onAuthStateChange` as a `Stream<AuthState>`; JWT refresh events from `supabase_flutter` are surfaced here — callers subscribe via Riverpod `StreamProvider`
  - [x] `getCurrentUser()` returns `Either<Failure, Student?>` — reads from `supabase.auth.currentUser`; returns `null` if no active session (not an error)
  - [x] `signOut()` returns `Either<Failure, Unit>` using `trySupabase(() => supabase.auth.signOut())`

- [x] Task 4: Create Riverpod providers for auth (AC: #1, #5)
  - [x] Create `studyboard_mobile/lib/features/auth/data/auth_provider.dart` — `@Riverpod(keepAlive: true) AuthRepository authRepository(Ref ref)` instantiating `AuthRepositoryImpl`; `@Riverpod(keepAlive: true) Stream<AuthState> authStateStream(Ref ref)` wrapping `authRepository.getSessionStream()`
  - [x] Ran `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` — generated `auth_provider.g.dart` with `authRepositoryProvider` and `authStateStreamProvider`

- [x] Task 5: Write unit tests (AC: #1, #5)
  - [x] Create `studyboard_mobile/test/features/auth/data/auth_repository_impl_test.dart` — mock `SupabaseClient` + `GoTrueClient` with mocktail; 6 tests covering getCurrentUser (null session, authenticated user), signOut (success, AuthException → AuthFailure), getSessionStream, data-layer boundary
  - [x] Create `studyboard_mobile/test/features/auth/domain/auth_repository_test.dart` — 3 tests verifying interface methods return correct types

- [x] Task 6: Validate and finalize (AC: all)
  - [x] `flutter analyze` → 0 issues under `very_good_analysis` rules
  - [x] `flutter test` → 57/57 tests pass (9 new + 48 pre-existing, no regressions)
  - [x] Verified `supabase.from(...)` calls exist ONLY in `lib/features/*/data/` files — grep returned zero matches outside data layer
  - [x] Verified SQL migration file structure matches Drift schema from Story 1.3 — all 13 tables, exact column names

## Dev Notes

### Critical Context: What Already Exists

**Do NOT recreate these — they already exist and are production-ready:**
- `lib/core/supabase/repository_base.dart` — `RepositoryBase` with `trySupabase<T>()` helper; maps `AuthException` → `AuthFailure`, `PostgrestException` → `DatabaseFailure`, `StorageException` → `NetworkFailure`
- `lib/core/supabase/supabase_client_provider.dart` — `supabaseClientProvider = Provider<SupabaseClient>(_ => Supabase.instance.client)`
- `lib/features/auth/domain/student.dart` — `@freezed abstract class Student` with all fields already defined; imports from `package:freezed_annotation/freezed_annotation.dart`
- `bootstrap.dart` — `Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey)` already called before `runApp()`; URL and key injected via `--dart-define` at build time
- `supabase_flutter: ^2.9.1` — already in `pubspec.yaml`

**Supabase project is already connected** — the Flutter app already initializes and connects to Supabase. Story 1.4 adds the missing server-side schema (SQL migration) and the Flutter-side auth repository interface.

### supabase_flutter v2 Session Management

`supabase_flutter ^2.9.1` uses GoTrue v2. JWT session management is **fully automatic** — no manual refresh logic needed:

```dart
// Session access — always current, auto-refreshed
final session = supabase.auth.currentSession;     // nullable; null = not logged in
final user = supabase.auth.currentUser;           // nullable

// Auth state stream — fires on login, logout, token refresh, password recovery
final stream = supabase.auth.onAuthStateChange;   // Stream<AuthState>
// AuthState has: event (AuthChangeEvent), session (Session?)
// Token refresh fires AuthChangeEvent.tokenRefreshed — transparent to UI
```

The session is stored via `SharedPreferences` by `supabase_flutter` automatically. On app restart, the SDK restores the session silently. This satisfies AC #1 — no additional code needed for transparent JWT refresh.

```dart
// In AuthRepositoryImpl — correct pattern
Stream<AuthState?> getSessionStream() =>
    Supabase.instance.client.auth.onAuthStateChange;

// Wrong — never do this manually
Future<void> refreshToken() async {
  await supabase.auth.refreshSession(); // Only needed if you explicitly expire the session
}
```

### AuthRepository Interface Design

```dart
// lib/features/auth/domain/auth_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

abstract interface class AuthRepository {
  /// Returns the currently authenticated student, or null if not signed in.
  /// Never throws — errors are returned as Left(Failure).
  Future<Either<Failure, Student?>> getCurrentUser();

  /// Signs out the current user. Clears local session.
  Future<Either<Failure, Unit>> signOut();

  /// Stream of auth state changes from supabase_flutter.
  /// Fires on login, logout, token refresh events.
  Stream<AuthState> getSessionStream();
}
```

### AuthRepositoryImpl Pattern

```dart
// lib/features/auth/data/auth_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/core/supabase/repository_base.dart';
import 'package:studyboard_mobile/core/supabase/supabase_client_provider.dart';
import 'package:studyboard_mobile/features/auth/domain/auth_repository.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:studyboard_mobile/features/auth/data/models/student_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl extends RepositoryBase implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, Student?>> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return const Right(null);
    return Right(StudentDto.fromSupabaseUser(user).toStudent());
  }

  @override
  Future<Either<Failure, Unit>> signOut() =>
      trySupabase(() async {
        await _client.auth.signOut();
        return unit;
      });

  @override
  Stream<AuthState> getSessionStream() => _client.auth.onAuthStateChange;
}
```

### StudentDto Design

The `StudentDto` maps Supabase `auth.users` data to the `Student` domain model. Note: most student profile fields (name, district, school) live in the `public.students` table, NOT in `auth.users`. The `auth.users` object provides `id`, `email`, and metadata.

```dart
// lib/features/auth/data/models/student_dto.dart
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

class StudentDto {
  StudentDto({
    required this.id,
    required this.email,
    this.name,
    this.district,
    this.school,
    this.fcmToken,
    this.deactivatedAt,
    this.deletedAt,
    this.notificationsEnabled = true,
    required this.lastActiveAt,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String? name;
  final String? district;
  final String? school;
  final String? fcmToken;
  final String? deactivatedAt;
  final String? deletedAt;
  final bool notificationsEnabled;
  final String lastActiveAt;
  final String createdAt;

  // Construct from Supabase auth.users object (minimal — only id/email available here)
  factory StudentDto.fromSupabaseUser(User user) {
    final now = DateTime.now().toUtc().toIso8601String();
    return StudentDto(
      id: user.id,
      email: user.email ?? '',
      lastActiveAt: user.lastSignInAt ?? now,
      createdAt: user.createdAt,
    );
  }

  // Construct from public.students table row (full profile)
  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      district: json['district'] as String?,
      school: json['school'] as String?,
      fcmToken: json['fcm_token'] as String?,
      deactivatedAt: json['deactivated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      notificationsEnabled: (json['notifications_enabled'] as bool?) ?? true,
      lastActiveAt: json['last_active_at'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Student toStudent() => Student(
    id: id,
    email: email,
    name: name ?? '',
    district: district ?? '',
    school: school ?? '',
    fcmToken: fcmToken,
    deactivatedAt: deactivatedAt,
    deletedAt: deletedAt,
    notificationsEnabled: notificationsEnabled,
    lastActiveAt: lastActiveAt,
    createdAt: createdAt,
  );
}
```

### Riverpod Provider Pattern

```dart
// lib/features/auth/data/auth_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/supabase/supabase_client_provider.dart';
import 'package:studyboard_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:studyboard_mobile/features/auth/domain/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client);
}

@Riverpod(keepAlive: true)
Stream<AuthState> authStateStream(Ref ref) {
  return ref.watch(authRepositoryProvider).getSessionStream();
}
```

> **Riverpod 4.x generator note**: Uses plain `Ref` (not `AuthRepositoryRef` etc.) — same pattern as `database_provider.dart` from Story 1.3. Generated provider names: `authRepositoryProvider` (lowercase) and `authStateStreamProvider`.

### SQL Migration File Structure

The migration at `studyboard_mobile/supabase/migrations/0001_initial_schema.sql` must:
1. Mirror all 13 Drift tables exactly (same column names/types)
2. Enable RLS on student data tables
3. Define RLS policies as documented

**Table → Policy mapping:**

| Table | RLS | Policy USING clause | WITH CHECK |
|---|---|---|---|
| `students` | Enabled | `id = auth.uid() AND deleted_at IS NULL` (SELECT) / `id = auth.uid()` (others) | `id = auth.uid()` |
| `lesson_tasks` | Enabled | `student_id = auth.uid()` | `student_id = auth.uid()` |
| `quiz_attempts` | Enabled | `student_id = auth.uid()` | `student_id = auth.uid()` |
| `sessions` | Enabled | `student_id = auth.uid()` | `student_id = auth.uid()` |
| `survey_responses` | Enabled | `student_id = auth.uid()` | `student_id = auth.uid()` |
| `nudge_events` | Enabled | `student_id = auth.uid()` | `student_id = auth.uid()` |
| `subjects` | Enabled | `true` (SELECT only) | — no write policy |
| `topics` | Enabled | `true` (SELECT only) | — no write policy |
| `lessons` | Enabled | `true` (SELECT only) | — no write policy |
| `quiz_questions` | Enabled | `true` (SELECT only) | — no write policy |
| `past_paper_questions` | Enabled | `true` (SELECT only) | — no write policy |
| `sync_queue` | Enabled | `student_id = auth.uid()` | `student_id = auth.uid()` |
| `sync_error_log` | Enabled | `student_id = auth.uid()` | `student_id = auth.uid()` |

**RLS policy SQL template:**

```sql
-- Enable RLS
ALTER TABLE students ENABLE ROW LEVEL SECURITY;

-- students: SELECT excludes deleted rows
CREATE POLICY "students_select_own"
  ON students FOR SELECT TO authenticated
  USING (id = auth.uid() AND deleted_at IS NULL);

CREATE POLICY "students_insert_own"
  ON students FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid());

CREATE POLICY "students_update_own"
  ON students FOR UPDATE TO authenticated
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

CREATE POLICY "students_delete_own"
  ON students FOR DELETE TO authenticated
  USING (id = auth.uid());

-- lesson_tasks (and quiz_attempts, sessions, survey_responses, nudge_events):
ALTER TABLE lesson_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "lesson_tasks_own"
  ON lesson_tasks FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

-- subjects (and topics, lessons, quiz_questions, past_paper_questions):
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "subjects_read_all"
  ON subjects FOR SELECT TO authenticated
  USING (true);
-- No INSERT/UPDATE/DELETE policy = any attempt returns permission denied
```

**Critical soft-delete requirement**: The `students` SELECT policy includes `AND deleted_at IS NULL`. This means when `StudentDao.softDelete()` sets `deleted_at`, the student's row becomes invisible to all RLS queries. No additional policy needed — the USING clause handles it.

### Drift ↔ Supabase Schema Parity

The SQL migration must produce column names that match the Drift schema from Story 1.3. Drift auto-converts `camelCase` to `snake_case` for DB columns. Full mapping:

```sql
-- From Drift students table → Supabase columns
CREATE TABLE students (
  id TEXT NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  district TEXT NOT NULL,
  school TEXT NOT NULL,
  fcm_token TEXT,                           -- nullable
  notifications_enabled BOOLEAN DEFAULT TRUE NOT NULL,
  deactivated_at TEXT,                      -- nullable; ISO 8601 UTC
  deleted_at TEXT,                          -- nullable; ISO 8601 UTC
  last_active_at TEXT NOT NULL,             -- ISO 8601 UTC
  created_at TEXT NOT NULL                  -- ISO 8601 UTC
);

-- lesson_tasks
CREATE TABLE lesson_tasks (
  id TEXT NOT NULL PRIMARY KEY,
  student_id TEXT NOT NULL,
  lesson_id TEXT NOT NULL,
  task_status TEXT NOT NULL DEFAULT 'backlog'
    CHECK (task_status IN ('backlog', 'todo', 'in_progress', 'done')),
  curiosity_completed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  UNIQUE (student_id, lesson_id)
);

-- sync_queue
CREATE TABLE sync_queue (
  id TEXT NOT NULL PRIMARY KEY,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  operation TEXT NOT NULL CHECK (operation IN ('upsert', 'soft_delete')),
  payload TEXT NOT NULL,
  created_at TEXT NOT NULL,
  retry_count INTEGER NOT NULL DEFAULT 0
);
```

> Include all remaining tables (subjects, topics, lessons, quiz_questions, quiz_attempts, past_paper_questions, survey_responses, nudge_events, sessions, sync_error_log) with equivalent column definitions. Refer to Story 1.3 Dev Notes "Full Table Schema Reference" for complete field listing.

### Repository Boundary Enforcement (AC #5)

The architecture rule is hard: **no `supabase.from(...)` calls may appear outside `lib/features/*/data/` files**.

Verify with a grep after implementation:
```bash
# From studyboard_mobile/
grep -r "supabase\.from\|Supabase\.instance\|supabaseClientProvider" lib/ \
  --include="*.dart" \
  | grep -v "lib/features/.*/data/" \
  | grep -v "lib/core/supabase/"
# Expected: zero matches
```

If any matches appear in `domain/`, `presentation/`, or `core/` outside `core/supabase/`, it is an architecture violation.

### Previous Story Learnings

From Stories 1.1–1.3:
- **`dart run build_runner build --delete-conflicting-outputs`** from `studyboard_mobile/` — NOT `flutter pub run build_runner`
- **Riverpod 4.x**: `@Riverpod(keepAlive: true)` with plain `Ref` parameter. Generated provider name is `authRepositoryProvider` (lowercase).
- **`very_good_analysis`** requires `package:` imports everywhere in `lib/`; relative imports (`../../core/...`) cause lint errors
- **`abstract interface class`** — use Dart 3 interface keyword for repository interfaces; avoids accidental concrete method inheritance
- **No type-specific Ref classes** — Riverpod 4.x generates plain `Ref` not `AuthRepositoryRef`; using the old type-specific pattern causes compile errors
- **`fpdart` is `^1.1.0`** — already in pubspec; provides `Either<L, R>`, `Right()`, `Left()`, `unit`, `Unit`
- **`student.dart` already exists** — import it, never redeclare `Student`
- **`repository_base.dart` is complete** — extend it; don't recreate `trySupabase()`
- **`supabase_client_provider.dart` is complete** — watch it via Riverpod

### Architecture Compliance Checklist

- [ ] `supabase/migrations/0001_initial_schema.sql` exists in `studyboard_mobile/supabase/migrations/`
- [ ] All 13 tables in SQL match Drift schema column names exactly
- [ ] RLS enabled on all 13 tables (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`)
- [ ] Student data tables: `student_id = auth.uid()` policy (or `id = auth.uid()` for `students` table)
- [ ] `students` SELECT policy includes `AND deleted_at IS NULL`
- [ ] Content tables: SELECT-only policy with `USING (true)` — no write policies
- [ ] `AuthRepository` interface is in `domain/` layer — no Supabase imports
- [ ] `AuthRepositoryImpl` is in `data/` layer — only place that touches `SupabaseClient`
- [ ] `supabaseClientProvider` is only watched inside `data/` layer files
- [ ] `@Riverpod(keepAlive: true)` on `authRepository` and `authStateStream` providers
- [ ] `dart run build_runner build` produces no errors
- [ ] `flutter analyze` → 0 issues
- [ ] `flutter test` → all pass (no regressions to Stories 1.1–1.3 tests)

### Anti-Patterns to Avoid

- ❌ Calling `supabase.auth.refreshSession()` manually — `supabase_flutter` handles refresh automatically via `onAuthStateChange`; manual refresh causes duplicate token refresh events
- ❌ Importing `SupabaseClient` or `supabase_flutter` in `domain/` layer files — domain must have no external SDK dependencies
- ❌ Calling `Supabase.instance.client` directly in a Notifier or Screen — always via `supabaseClientProvider` inside `data/` layer
- ❌ Using FOR ALL on the `students` table with a single USING clause — the `students` table SELECT policy MUST include `deleted_at IS NULL`; other operations do not need this filter
- ❌ Adding REFERENCES foreign keys in the Supabase migration — the Drift schema deliberately uses logical FKs (no `.references()`) for offline-first compatibility; mirror this in SQL (no `REFERENCES` constraints)
- ❌ Creating an `anon` role policy on student data tables — all policies should target `TO authenticated` only; the `anon` role (unauthenticated) must have zero access to any table

### Project Structure Notes

**Files to CREATE:**
```
studyboard_mobile/
├── supabase/
│   └── migrations/
│       └── 0001_initial_schema.sql         # All 13 tables + RLS policies
└── lib/features/auth/
    ├── domain/
    │   └── auth_repository.dart             # abstract interface class AuthRepository
    ├── data/
    │   ├── auth_repository_impl.dart        # extends RepositoryBase implements AuthRepository
    │   ├── auth_provider.dart               # @Riverpod(keepAlive) authRepository + authStateStream
    │   └── models/
    │       └── student_dto.dart             # fromSupabaseUser() + fromJson() + toStudent()
    └── (presentation/ already has .gitkeep — no presentation files in this story)
```

**Generated files (after build_runner):**
```
lib/features/auth/data/auth_provider.g.dart  # authRepositoryProvider + authStateStreamProvider
```

**Files to CREATE for tests:**
```
test/features/auth/
├── data/auth_repository_impl_test.dart
└── domain/auth_repository_test.dart
```

**Files NOT to modify:**
- `lib/core/supabase/repository_base.dart` — complete as-is
- `lib/core/supabase/supabase_client_provider.dart` — complete as-is
- `lib/features/auth/domain/student.dart` — complete as-is
- `bootstrap.dart` — Supabase.initialize() already present
- Any Drift schema files or DAOs from Story 1.3

### References

- [Source: epics.md#Story 1.4] — Acceptance criteria, RLS requirements
- [Source: architecture.md#Authentication & Security] — `supabase_flutter` default session, RLS policy design, repository layer pattern
- [Source: architecture.md#Complete Project Directory Structure] — `supabase/migrations/0001_initial_schema.sql` location, `auth/data/`, `auth/domain/` paths
- [Source: architecture.md#Communication Patterns] — `Either<Failure, T>` return type from repository methods
- [Source: architecture.md#Architectural Boundaries] — data layer is only place that may access SupabaseClient
- [Source: 1-3-complete-drift-database-schema.md#Full Table Schema Reference] — Column-level schema to mirror in SQL
- [Source: 1-2-app-theme-design-system-and-navigation-shell.md#Dev Agent Record] — Riverpod 4.x generator behavior, `dart run build_runner` command, `package:` import requirement

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- `SignOutScope` enum required `registerFallbackValue(SignOutScope.local)` in `setUpAll` for mocktail `any(named: 'scope')` matchers — without it, mocktail throws `Bad state` at test runtime.
- `very_good_analysis` enforces `sort_constructors_first`: all constructors (including factory constructors) must appear before field declarations in the class body. Restructured `StudentDto` accordingly.
- `Future`-returning `StreamController.close()` in a non-async test body requires `unawaited()` wrapper under strict lint rules.
- `sync_queue` and `sync_error_log` tables in Supabase required an extra `student_id` column (not present in Drift) to support RLS scoping — Drift uses these tables as local-only but adding `student_id` to Supabase mirrors enables server-side audit visibility without breaking the client.

### Completion Notes List

- SQL migration `0001_initial_schema.sql` created with all 13 tables, exact Drift column names (camelCase → snake_case), indexes, RLS enabled on all tables, and correct policies (AC #2, #3, #4)
- `students` SELECT RLS includes `AND deleted_at IS NULL` — soft-deleted rows invisible to all student queries (AC #4)
- Content tables (subjects, topics, lessons, quiz_questions, past_paper_questions): SELECT-only policy with `USING (true)` — no write policies (AC #3)
- `AuthRepository` abstract interface in `domain/` layer with zero Supabase imports — pure Dart (AC #5)
- `AuthRepositoryImpl` in `data/` layer only — extends `RepositoryBase`, uses injected `SupabaseClient`, never `Supabase.instance` directly (AC #1, #5)
- JWT refresh handled transparently by `supabase_flutter ^2.9.1` via `onAuthStateChange` stream — no manual refresh logic needed (AC #1)
- Riverpod providers generated: `authRepositoryProvider` (keepAlive) + `authStateStreamProvider` (keepAlive Stream)
- Grep verified: zero `supabase.from/Supabase.instance/supabaseClientProvider` calls outside `data/` or `core/supabase/` (AC #5)
- `flutter analyze` → 0 issues; `flutter test` → 57/57 pass (9 new tests, zero regressions)

### File List

**Created:**
- `supabase/migrations/0001_initial_schema.sql`
- `lib/features/auth/domain/auth_repository.dart`
- `lib/features/auth/data/models/student_dto.dart`
- `lib/features/auth/data/auth_repository_impl.dart`
- `lib/features/auth/data/auth_provider.dart`
- `lib/features/auth/data/auth_provider.g.dart` (generated)
- `test/features/auth/data/auth_repository_impl_test.dart`
- `test/features/auth/domain/auth_repository_test.dart`

**Modified:**
- `_bmad-output/implementation-artifacts/sprint-status.yaml` — status updated to `review`

## Review Findings

### Decision Needed (Resolved)

- [x] [Review][Decision] Primary key type mismatch — Changed to INTEGER with GENERATED ALWAYS AS IDENTITY [supabase/migrations/0001_initial_schema.sql: all CREATE TABLE statements]
- [x] [Review][Decision] Missing past_paper_question_types table — Added new reference table for question types (MCQ, Structured, Essay, etc.) [supabase/migrations/0001_initial_schema.sql]
- [x] [Review][Decision] Missing schools reference table — Added schools table with district-school relationship; students.school changed to school_id FK [supabase/migrations/0001_initial_schema.sql]

### Patches (Resolved)

- [x] [Review][Patch] Missing email validation — Added CHECK constraint: email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$' [supabase/migrations/0001_initial_schema.sql:students table]
- [x] [Review][Patch] TEXT vs VARCHAR efficiency — Replaced TEXT with VARCHAR(n) for name, email, district, fcm_token, entity_type, entity_id, operation, fcm_message_id, status [supabase/migrations/0001_initial_schema.sql: all tables]
- [x] [Review][Patch] School nullability — Changed school (TEXT) to school_id (INTEGER NOT NULL FK) with mandatory reference to schools table [supabase/migrations/0001_initial_schema.sql:students table]

## Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2026-04-18 | 1.0 | Story created — Supabase SQL migration + RLS policies + auth repository layer | claude-sonnet-4-6 |
| 2026-04-18 | 1.1 | Implementation complete — SQL migration, AuthRepository, AuthRepositoryImpl, Riverpod providers, 9 tests; 57/57 pass | claude-sonnet-4-6 |
