import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/auth/google_sign_in_service.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/student_dao.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockUser extends Mock implements User {}

class _MockSession extends Mock implements Session {}

class _MockStudentDao extends Mock implements StudentDao {}

class _MockGoogleSignInService extends Mock implements GoogleSignInService {}

class _MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class _MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

/// Fake that satisfies the [Future] protocol so `await insert({...})` resolves.
/// Satisfies the [Future] protocol so `await queryBuilder.insert({...})`
/// resolves immediately without making real HTTP calls.
class _FakeFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  @override
  Future<R> then<R>(
    FutureOr<R> Function(dynamic) onValue, {
    Function? onError,
  }) =>
      Future<dynamic>.value().then(onValue);

  @override
  Future<dynamic> catchError(Function onError,
          {bool Function(Object)? test}) =>
      Future<dynamic>.value();

  @override
  Future<dynamic> whenComplete(FutureOr<void> Function() action) =>
      Future<dynamic>.value().whenComplete(action);

  @override
  Stream<dynamic> asStream() => Stream.value(null);

  @override
  Future<dynamic> timeout(
    Duration timeLimit, {
    FutureOr<dynamic> Function()? onTimeout,
  }) =>
      Future<dynamic>.value();
}

void main() {
  setUpAll(() {
    // mocktail requires fallback values for non-nullable complex parameters.
    registerFallbackValue(SignOutScope.local);
    registerFallbackValue(OAuthProvider.google);
    registerFallbackValue(const StudentsTableCompanion());
  });

  late _MockSupabaseClient mockClient;
  late _MockGoTrueClient mockAuth;
  late _MockStudentDao mockStudentDao;
  late _MockGoogleSignInService mockGoogleSignIn;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockClient = _MockSupabaseClient();
    mockAuth = _MockGoTrueClient();
    mockStudentDao = _MockStudentDao();
    mockGoogleSignIn = _MockGoogleSignInService();
    when(() => mockClient.auth).thenReturn(mockAuth);
    repository = AuthRepositoryImpl(
      mockClient,
      mockStudentDao,
      mockGoogleSignIn,
    );
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

  group('AuthRepositoryImpl.signUpWithEmail', () {
    late _MockSupabaseQueryBuilder mockQueryBuilder;

    setUp(() {
      mockQueryBuilder = _MockSupabaseQueryBuilder();
      when(() => mockClient.from(any())).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.insert(any()))
          .thenAnswer((_) => _FakeFilterBuilder());
    });

    test('success → Right(Student) and Drift upsert called', () async {
      final mockUser = _mockUser();
      when(
        () => mockAuth.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => AuthResponse(user: mockUser, session: _MockSession()),
      );
      when(() => mockStudentDao.upsertStudent(any()))
          .thenAnswer((_) async {});

      final result = await repository.signUpWithEmail(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (student) {
          expect(student.id, equals('user-123'));
          expect(student.name, equals('Test User'));
          expect(student.email, equals('test@example.com'));
        },
      );
      verify(() => mockStudentDao.upsertStudent(any())).called(1);
    });

    test('duplicate email → Left(AuthFailure) with user-friendly message',
        () async {
      when(
        () => mockAuth.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          data: any(named: 'data'),
        ),
      ).thenThrow(const AuthException('User already registered'));

      final result = await repository.signUpWithEmail(
        name: 'Test User',
        email: 'used@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) {
          expect(f, isA<AuthFailure>());
          expect(
            f.message,
            equals(
              'An account with this email already exists. Try logging in.',
            ),
          );
        },
        (_) => fail('Expected Left'),
      );
      verifyNever(() => mockStudentDao.upsertStudent(any()));
    });

    test('offline → Left(NetworkFailure)', () async {
      when(
        () => mockAuth.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          data: any(named: 'data'),
        ),
      ).thenThrow(const SocketException('No internet'));

      final result = await repository.signUpWithEmail(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => mockStudentDao.upsertStudent(any()));
    });
  });

  group('data-layer boundary', () {
    test('uses only the injected client, never Supabase.instance', () {
      final otherClient = _MockSupabaseClient();
      final otherAuth = _MockGoTrueClient();
      when(() => otherClient.auth).thenReturn(otherAuth);
      when(() => otherAuth.currentUser).thenReturn(null);

      AuthRepositoryImpl(
        otherClient,
        _MockStudentDao(),
        _MockGoogleSignInService(),
      );

      verifyNever(() => mockAuth.currentUser);
    });
  });

  group('AuthRepositoryImpl.signInWithGoogle', () {
    late _MockGoogleSignInAccount mockAccount;

    setUp(() {
      mockAccount = _MockGoogleSignInAccount();
      // Pre-create to avoid calling when() inside a thenAnswer callback.
      final stubUser = _mockUser();
      when(() => mockAccount.displayName).thenReturn('Test User');
      when(() => mockAccount.email).thenReturn('test@example.com');
      when(() => mockAccount.authentication).thenReturn(
        const GoogleSignInAuthentication(idToken: 'fake-id-token'),
      );
      when(
        () => mockAuth.signInWithIdToken(
          provider: any(named: 'provider'),
          idToken: any(named: 'idToken'),
        ),
      ).thenAnswer(
        (_) async => AuthResponse(user: stubUser, session: _MockSession()),
      );
    });

    test('success, new student → Right with isNewStudent: true', () async {
      // Pre-create mock user before any when() call to avoid mocktail
      // "cannot call when within a stub response" error.
      final mockUser = _mockUser();
      when(() => mockGoogleSignIn.authenticate())
          .thenAnswer((_) async => mockAccount);
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockStudentDao.getStudent(any()))
          .thenAnswer((_) async => null);
      when(() => mockStudentDao.upsertStudent(any()))
          .thenAnswer((_) async {});

      final result = await repository.signInWithGoogle();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (r) {
          expect(r.isNewStudent, isTrue);
          expect(r.student.email, equals('test@example.com'));
        },
      );
      verify(() => mockStudentDao.upsertStudent(any())).called(1);
    });

    test('success, returning student → Right with isNewStudent: false',
        () async {
      final mockUser = _mockUser();
      when(() => mockGoogleSignIn.authenticate())
          .thenAnswer((_) async => mockAccount);
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockStudentDao.getStudent(any()))
          .thenAnswer((_) async => _fakeStudentsTableData());
      when(() => mockStudentDao.updateLastActiveAt(any(), any()))
          .thenAnswer((_) async {});

      final result = await repository.signInWithGoogle();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (r) => expect(r.isNewStudent, isFalse),
      );
      verifyNever(() => mockStudentDao.upsertStudent(any()));
      verify(() => mockStudentDao.updateLastActiveAt(any(), any())).called(1);
    });

    test('user cancels → Left(AuthFailure)', () async {
      when(() => mockGoogleSignIn.authenticate()).thenThrow(
        const GoogleSignInException(
          code: GoogleSignInExceptionCode.canceled,
          description: 'Cancelled by user',
        ),
      );

      final result = await repository.signInWithGoogle();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('signInWithIdToken throws → Left(NetworkFailure)', () async {
      when(() => mockGoogleSignIn.authenticate())
          .thenAnswer((_) async => mockAccount);
      when(
        () => mockAuth.signInWithIdToken(
          provider: any(named: 'provider'),
          idToken: any(named: 'idToken'),
        ),
      ).thenThrow(Exception('network error'));

      final result = await repository.signInWithGoogle();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
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

StudentsTableData _fakeStudentsTableData() => const StudentsTableData(
      id: 'user-123',
      name: 'Test User',
      email: 'test@example.com',
      district: 'Colombo',
      school: 'Test School',
      notificationsEnabled: true,
      lastActiveAt: '2026-04-18T00:00:00.000Z',
      createdAt: '2026-04-18T00:00:00.000Z',
    );
