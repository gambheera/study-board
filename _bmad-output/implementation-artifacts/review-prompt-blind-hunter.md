# Code Review: Blind Hunter (No Context)

You are a cynical, jaded code reviewer. The developer is a clueless weasel and you expect to find problems. Be skeptical of everything. Look for what's missing, not just what's wrong.

## Your Task

Review the following diff with **zero project context**. You have only the code shown below. Assume the worst.

Find **at least 10 issues** to fix or improve. Be precise and professional.

---

## DIFF: Story 1.4 Implementation

### File 1: supabase/migrations/0001_initial_schema.sql

```sql
-- =============================================================================
-- StudyBoard: Initial Supabase Schema
-- Migration: 0001_initial_schema.sql
-- Mirrors Drift schema (Story 1.3) exactly.
-- All student data tables have RLS enforcing student_id = auth.uid().
-- Content tables are public SELECT (authenticated), no write.
-- Soft-delete: students SELECT policy includes AND deleted_at IS NULL.
-- =============================================================================

CREATE TABLE IF NOT EXISTS subjects (
  id TEXT NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  quiz_pass_threshold DOUBLE PRECISION NOT NULL DEFAULT 0.8,
  content_version INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS topics (
  id TEXT NOT NULL PRIMARY KEY,
  subject_id TEXT NOT NULL,
  title TEXT NOT NULL,
  order_index INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS lessons (
  id TEXT NOT NULL PRIMARY KEY,
  topic_id TEXT NOT NULL,
  title TEXT NOT NULL,
  content_text TEXT NOT NULL,
  content_track TEXT NOT NULL,
  order_index INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS quiz_questions (
  id TEXT NOT NULL PRIMARY KEY,
  lesson_id TEXT NOT NULL,
  question_text TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  correct_option TEXT NOT NULL,
  order_index INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS past_paper_questions (
  id TEXT NOT NULL PRIMARY KEY,
  lesson_id TEXT NOT NULL,
  topic_id TEXT NOT NULL,
  question_text TEXT NOT NULL,
  year INTEGER,
  order_index INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS students (
  id TEXT NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  district TEXT NOT NULL,
  school TEXT NOT NULL,
  fcm_token TEXT,
  notifications_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  deactivated_at TEXT,
  deleted_at TEXT,
  last_active_at TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS lesson_tasks (
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

CREATE TABLE IF NOT EXISTS quiz_attempts (
  id TEXT NOT NULL PRIMARY KEY,
  student_id TEXT NOT NULL,
  lesson_id TEXT NOT NULL,
  score DOUBLE PRECISION NOT NULL,
  passed BOOLEAN NOT NULL,
  attempted_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sessions (
  id TEXT NOT NULL PRIMARY KEY,
  student_id TEXT NOT NULL,
  started_at TEXT NOT NULL,
  ended_at TEXT,
  attributed_nudge_id TEXT
);

CREATE TABLE IF NOT EXISTS survey_responses (
  id TEXT NOT NULL PRIMARY KEY,
  student_id TEXT NOT NULL,
  responses TEXT NOT NULL,
  responded_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS nudge_events (
  id TEXT NOT NULL PRIMARY KEY,
  student_id TEXT NOT NULL,
  sent_at TEXT NOT NULL,
  fcm_message_id TEXT,
  status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sync_queue (
  id TEXT NOT NULL PRIMARY KEY,
  student_id TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  operation TEXT NOT NULL,
  payload TEXT NOT NULL,
  created_at TEXT NOT NULL,
  retry_count INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS sync_error_log (
  id TEXT NOT NULL PRIMARY KEY,
  student_id TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  operation TEXT NOT NULL,
  payload TEXT NOT NULL,
  error_message TEXT NOT NULL,
  failed_at TEXT NOT NULL,
  retry_count INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_topics_subject_id ON topics (subject_id);
CREATE INDEX IF NOT EXISTS idx_lessons_topic_id ON lessons (topic_id);
CREATE INDEX IF NOT EXISTS idx_lesson_tasks_student_id ON lesson_tasks (student_id);
CREATE INDEX IF NOT EXISTS idx_lesson_tasks_lesson_id ON lesson_tasks (lesson_id);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_lesson_id ON quiz_questions (lesson_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_student_id ON quiz_attempts (student_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_lesson_id ON quiz_attempts (lesson_id);
CREATE INDEX IF NOT EXISTS idx_sessions_student_id ON sessions (student_id);
CREATE INDEX IF NOT EXISTS idx_nudge_events_student_id ON nudge_events (student_id);
CREATE INDEX IF NOT EXISTS idx_past_paper_questions_lesson_id ON past_paper_questions (lesson_id);
CREATE INDEX IF NOT EXISTS idx_sync_queue_student_id ON sync_queue (student_id);

ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE past_paper_questions ENABLE ROW LEVEL SECURITY;

ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE nudge_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_error_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "subjects_select_authenticated"
  ON subjects FOR SELECT TO authenticated USING (true);

CREATE POLICY "topics_select_authenticated"
  ON topics FOR SELECT TO authenticated USING (true);

CREATE POLICY "lessons_select_authenticated"
  ON lessons FOR SELECT TO authenticated USING (true);

CREATE POLICY "quiz_questions_select_authenticated"
  ON quiz_questions FOR SELECT TO authenticated USING (true);

CREATE POLICY "past_paper_questions_select_authenticated"
  ON past_paper_questions FOR SELECT TO authenticated USING (true);

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

CREATE POLICY "lesson_tasks_own"
  ON lesson_tasks FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

CREATE POLICY "quiz_attempts_own"
  ON quiz_attempts FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

CREATE POLICY "sessions_own"
  ON sessions FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

CREATE POLICY "survey_responses_own"
  ON survey_responses FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

CREATE POLICY "nudge_events_select_own"
  ON nudge_events FOR SELECT TO authenticated
  USING (student_id = auth.uid());

CREATE POLICY "sync_queue_own"
  ON sync_queue FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

CREATE POLICY "sync_error_log_own"
  ON sync_error_log FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());
```

### File 2: lib/features/auth/domain/auth_repository.dart

```dart
import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

abstract interface class AuthRepository {
  /// Returns the currently authenticated student, or null if no active session.
  Future<Either<Failure, Student?>> getCurrentUser();

  /// Signs out the current user and clears the local session.
  Future<Either<Failure, Unit>> signOut();

  /// Stream of Supabase auth state changes (login, logout, token refresh).
  Stream<AuthState> getSessionStream();
}
```

### File 3: lib/features/auth/data/models/student_dto.dart

```dart
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

/// Maps Supabase data sources to the [Student] domain model.
///
/// Two construction paths exist:
/// - Minimal from auth.users (id + email only).
/// - Full profile from the public.students table row.
class StudentDto {
  const StudentDto({
    required this.id,
    required this.email,
    required this.lastActiveAt,
    required this.createdAt,
    this.name = '',
    this.district = '',
    this.school = '',
    this.notificationsEnabled = true,
    this.fcmToken,
    this.deactivatedAt,
    this.deletedAt,
  });

  factory StudentDto.fromSupabaseUser(User user) {
    final now = DateTime.now().toUtc().toIso8601String();
    return StudentDto(
      id: user.id,
      email: user.email ?? '',
      lastActiveAt: user.lastSignInAt ?? now,
      createdAt: user.createdAt,
    );
  }

  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: (json['name'] as String?) ?? '',
      district: (json['district'] as String?) ?? '',
      school: (json['school'] as String?) ?? '',
      notificationsEnabled: (json['notifications_enabled'] as bool?) ?? true,
      lastActiveAt: json['last_active_at'] as String,
      createdAt: json['created_at'] as String,
      fcmToken: json['fcm_token'] as String?,
      deactivatedAt: json['deactivated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  final String id;
  final String email;
  final String name;
  final String district;
  final String school;
  final bool notificationsEnabled;
  final String lastActiveAt;
  final String createdAt;
  final String? fcmToken;
  final String? deactivatedAt;
  final String? deletedAt;

  Student toStudent() => Student(
        id: id,
        email: email,
        name: name,
        district: district,
        school: school,
        notificationsEnabled: notificationsEnabled,
        lastActiveAt: lastActiveAt,
        createdAt: createdAt,
        fcmToken: fcmToken,
        deactivatedAt: deactivatedAt,
        deletedAt: deletedAt,
      );
}
```

### File 4: lib/features/auth/data/auth_repository_impl.dart

```dart
import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/core/supabase/repository_base.dart';
import 'package:studyboard_mobile/features/auth/data/models/student_dto.dart';
import 'package:studyboard_mobile/features/auth/domain/auth_repository.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
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
  Future<Either<Failure, Unit>> signOut() => trySupabase(() async {
        await _client.auth.signOut();
        return unit;
      });

  @override
  Stream<AuthState> getSessionStream() => _client.auth.onAuthStateChange;
}
```

### File 5: lib/features/auth/data/auth_provider.dart

```dart
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

### File 6: test/features/auth/data/auth_repository_impl_test.dart

```dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockUser extends Mock implements User {}

void main() {
  setUpAll(() {
    registerFallbackValue(SignOutScope.local);
  });

  late _MockSupabaseClient mockClient;
  late _MockGoTrueClient mockAuth;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockClient = _MockSupabaseClient();
    mockAuth = _MockGoTrueClient();
    when(() => mockClient.auth).thenReturn(mockAuth);
    repository = AuthRepositoryImpl(mockClient);
  });

  group('AuthRepositoryImpl.getCurrentUser', () {
    test('returns Right(null) when no session exists', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final result = await repository.getCurrentUser();

      expect(result, const Right<Failure, Student?>(null));
    });

    test('returns Right(Student) when user is authenticated', () async {
      final fakeUser = _mockUser();
      when(() => mockAuth.currentUser).thenReturn(fakeUser);

      final result = await repository.getCurrentUser();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (student) {
          expect(student, isNotNull);
          expect(student!.id, equals('user-123'));
          expect(student.email, equals('test@example.com'));
        },
      );
    });
  });

  group('AuthRepositoryImpl.signOut', () {
    test('calls auth.signOut and returns Right(unit)', () async {
      when(() => mockAuth.signOut(scope: any(named: 'scope')))
          .thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => mockAuth.signOut(scope: any(named: 'scope'))).called(1);
    });

    test('returns Left(AuthFailure) when signOut throws AuthException',
        () async {
      when(() => mockAuth.signOut(scope: any(named: 'scope')))
          .thenThrow(const AuthException('session expired'));

      final result = await repository.signOut();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('AuthRepositoryImpl.getSessionStream', () {
    test('returns the onAuthStateChange stream', () {
      final controller = StreamController<AuthState>.broadcast();
      when(() => mockAuth.onAuthStateChange)
          .thenAnswer((_) => controller.stream);

      final stream = repository.getSessionStream();

      expect(stream, isA<Stream<AuthState>>());
      unawaited(controller.close());
    });
  });

  group('data-layer boundary', () {
    test('uses only the injected client, never Supabase.instance', () {
      final otherClient = _MockSupabaseClient();
      final otherAuth = _MockGoTrueClient();
      when(() => otherClient.auth).thenReturn(otherAuth);
      when(() => otherAuth.currentUser).thenReturn(null);

      AuthRepositoryImpl(otherClient);

      verifyNever(() => mockAuth.currentUser);
    });
  });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

User _mockUser() {
  final user = _MockUser();
  when(() => user.id).thenReturn('user-123');
  when(() => user.email).thenReturn('test@example.com');
  when(() => user.lastSignInAt).thenReturn('2026-04-18T00:00:00.000Z');
  when(() => user.createdAt).thenReturn('2026-04-18T00:00:00.000Z');
  return user;
}
```

### File 7: test/features/auth/domain/auth_repository_test.dart

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/domain/auth_repository.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() {
    repository = _MockAuthRepository();
  });

  group('AuthRepository interface', () {
    test('getCurrentUser returns Either<Failure, Student?>', () async {
      when(() => repository.getCurrentUser())
          .thenAnswer((_) async => const Right(null));

      final result = await repository.getCurrentUser();

      expect(result, isA<Either<Failure, Student?>>());
    });

    test('signOut returns Either<Failure, Unit>', () async {
      when(() => repository.signOut())
          .thenAnswer((_) async => const Right(unit));

      final result = await repository.signOut();

      expect(result, isA<Either<Failure, Unit>>());
    });

    test('getSessionStream returns Stream<AuthState>', () {
      when(() => repository.getSessionStream())
          .thenAnswer((_) => const Stream.empty());

      final stream = repository.getSessionStream();

      expect(stream, isA<Stream<AuthState>>());
    });
  });
}
```

---

## Instructions

1. Review all 7 files above
2. Find **at least 10 issues** (missing validations, logic gaps, risky patterns, etc.)
3. Return your findings as a **Markdown list** with:
   - Issue title
   - Location (file + line/section)
   - Evidence or explanation
   - Suggested fix (if applicable)

**Be cynical. Assume the worst. Look for what's missing, not just what's wrong.**
