# Code Review: Acceptance Auditor

You are an Acceptance Auditor. Your task is to review code changes against a specification and context docs. Check for violations of acceptance criteria, deviations from spec intent, missing implementation of specified behavior, and contradictions between spec constraints and actual code.

## Specification: Story 1.4

**Story:** Supabase Project Setup & Row-Level Security

**Acceptance Criteria:**

1. **JWT Transparency (AC #1)**
   - Given the Supabase project is configured with all tables mirroring the Drift schema
   - When any authenticated student makes an API call
   - Then the call uses a valid Supabase JWT and the JWT refresh is handled transparently by `supabase_flutter` without interrupting the user session

2. **RLS on Student Data Tables (AC #2)**
   - Given RLS is enabled on all student data tables (`lesson_tasks`, `quiz_attempts`, `sessions`, `survey_responses`, `nudge_events`, `students`)
   - When Student A (authenticated as `auth.uid() = A`) attempts to SELECT rows belonging to Student B
   - Then the query returns zero rows — RLS enforces `student_id = auth.uid()` on every data operation

3. **Content Table RLS (AC #3)**
   - Given RLS on content tables (`subjects`, `topics`, `lessons`, `quiz_questions`, `past_paper_questions`)
   - When any authenticated student performs a SELECT
   - Then the query succeeds and returns content rows; INSERT, UPDATE, and DELETE operations are rejected with a permissions error

4. **Soft-Delete Pattern (AC #4)**
   - Given a student account is soft-deleted (`deleted_at` timestamp is set and PII fields anonymized)
   - When any other authenticated student queries any student data table
   - Then the soft-deleted student's rows are excluded from all results by RLS — no deleted-user data is surfaced in any student-facing query

5. **Repository Boundary Enforcement (AC #5)**
   - Given the repository base class enforces the data-layer boundary
   - When any Riverpod Notifier or Screen widget accesses student data
   - Then it does so exclusively via a repository interface — no direct `supabase.from(...)` calls exist outside `data/` layer files

---

## Implementation Files to Review

### File 1: supabase/migrations/0001_initial_schema.sql

```sql
-- [Full SQL migration with 13 tables and RLS policies]
-- Content tables: subjects, topics, lessons, quiz_questions, past_paper_questions
-- Student data tables: students, lesson_tasks, quiz_attempts, sessions, survey_responses, nudge_events
-- Sync tables: sync_queue, sync_error_log
-- Indexes on FK columns
-- RLS enabled on all tables
-- Policies for content tables: SELECT-only (true)
-- Policies for student tables: student_id = auth.uid() or id = auth.uid()
-- Students table SELECT includes: AND deleted_at IS NULL
```

### File 2: lib/features/auth/domain/auth_repository.dart

```dart
abstract interface class AuthRepository {
  Future<Either<Failure, Student?>> getCurrentUser();
  Future<Either<Failure, Unit>> signOut();
  Stream<AuthState> getSessionStream();
}
```

### File 3: lib/features/auth/data/models/student_dto.dart

```dart
class StudentDto {
  factory StudentDto.fromSupabaseUser(User user) { ... }
  factory StudentDto.fromJson(Map<String, dynamic> json) { ... }
  Student toStudent() => Student(...);
}
```

### File 4: lib/features/auth/data/auth_repository_impl.dart

```dart
class AuthRepositoryImpl extends RepositoryBase implements AuthRepository {
  Future<Either<Failure, Student?>> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return const Right(null);
    return Right(StudentDto.fromSupabaseUser(user).toStudent());
  }

  Future<Either<Failure, Unit>> signOut() => trySupabase(() async {
    await _client.auth.signOut();
    return unit;
  });

  Stream<AuthState> getSessionStream() => _client.auth.onAuthStateChange;
}
```

### File 5: lib/features/auth/data/auth_provider.dart

```dart
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

### File 6: test/features/auth/data/auth_repository_impl_test.dart

```dart
// 6 test groups: getCurrentUser, signOut, getSessionStream, data-layer boundary
// Tests cover: null session, authenticated user, success/failure scenarios
// Data-layer boundary test: proves injection pattern, not global singleton
```

### File 7: test/features/auth/domain/auth_repository_test.dart

```dart
// 3 tests verifying interface contract return types
```

---

## Context: Project Knowns

- **Drift Schema (Story 1.3):** All 13 tables already defined locally in SQLite with compile-time safety
- **supabase_flutter ^2.9.1:** GoTrueClient handles JWT refresh automatically; no manual refresh method needed
- **Repository Pattern:** RepositoryBase provides `trySupabase<T>()` helper for error mapping (AuthException → AuthFailure, PostgrestException → DatabaseFailure, etc.)
- **Riverpod 4.x:** keepAlive: true prevents disposal; generated providers available
- **Error Handling:** Either<Failure, T> functional pattern via fpdart
- **Existing Code:** supabaseClientProvider, RepositoryBase, Student domain model, bootstrap.dart all pre-implemented

---

## Your Task

Review the diff against the specification and context. Output findings as a **Markdown list**. Each finding should have:

1. **AC/Constraint Violated** — which acceptance criterion or constraint is violated
2. **Evidence from Diff** — specific lines or patterns that show the issue
3. **Deviation from Spec Intent** — what the spec intended vs. what the code does
4. **Suggested Fix (if applicable)**

Examples of violations to look for:
- RLS policies missing from tables specified in AC #2 or #3
- Soft-delete pattern not enforced in SELECT policies
- Direct Supabase calls outside the data/ layer
- JWT refresh handled manually (violates AC #1 intent of transparency)
- Missing tests for acceptance criteria
- Schema divergence from Drift (Story 1.3)
- Repository interface leaking implementation details (supabase_flutter types)

**Be precise. Output only verified violations. If all acceptance criteria are met, state that clearly.**
