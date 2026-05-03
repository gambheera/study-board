import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/data/auth_provider.dart';
import 'package:studyboard_mobile/features/auth/domain/auth_repository.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = _MockAuthRepository();
    // build() calls getCurrentUser() and getSessionStream() on every container
    // creation — stub both so existing tests don't throw MissingStubError.
    when(() => mockRepo.getCurrentUser())
        .thenAnswer((_) async => const Right(null));
    when(() => mockRepo.getSessionStream())
        .thenAnswer((_) => const Stream.empty());
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('AuthNotifier.build — session restore (DEF3)', () {
    test('no stored session → starts unauthenticated', () async {
      when(() => mockRepo.getCurrentUser())
          .thenAnswer((_) async => const Right(null));

      await container.read(authProvider.future);

      final state = container.read(authProvider);
      expect(state.hasValue, isTrue);
      final isUnauthenticated = state.requireValue.map(
        unauthenticated: (_) => true,
        authenticated: (_) => false,
      );
      expect(isUnauthenticated, isTrue);
    });

    test('existing session in Drift → starts authenticated', () async {
      final student = _fakeStudent();
      // Override the default stub for this test.
      when(() => mockRepo.getCurrentUser())
          .thenAnswer((_) async => Right(student));

      final localContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );
      addTearDown(localContainer.dispose);

      await localContainer.read(authProvider.future);

      final state = localContainer.read(authProvider);
      expect(state.hasValue, isTrue);
      final isAuthenticated = state.requireValue.map(
        unauthenticated: (_) => false,
        authenticated: (_) => true,
      );
      expect(isAuthenticated, isTrue);
    });
  });

  group('AuthNotifier.build — authStateStream (DEF5)', () {
    test('signedOut stream event → unauthenticated with sessionExpired: true',
        () async {
      final streamController = StreamController<supabase.AuthState>();

      // Override authStateStreamProvider directly so we control exactly what
      // the notifier's ref.listen receives — avoids mock stub timing issues.
      final localContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockRepo),
          authStateStreamProvider.overrideWith(
            (ref) => streamController.stream,
          ),
        ],
      );
      addTearDown(localContainer.dispose);

      await localContainer.read(authProvider.future);

      // Use a Completer so we wait deterministically for state to change.
      final stateChanged = Completer<void>();
      localContainer.listen<AsyncValue<AuthState>>(authProvider, (_, _) {
        if (!stateChanged.isCompleted) stateChanged.complete();
      });

      streamController.add(
        const supabase.AuthState(supabase.AuthChangeEvent.signedOut, null),
      );
      await stateChanged.future.timeout(const Duration(seconds: 5));
      await streamController.close();

      final state = localContainer.read(authProvider);
      expect(state.hasValue, isTrue);
      final isExpired = state.requireValue.map(
        unauthenticated: (s) => s.sessionExpired,
        authenticated: (_) => false,
      );
      expect(isExpired, isTrue);
    });
  });

  group('AuthNotifier.signUpWithEmail', () {
    test('success → state transitions to AuthState.authenticated', () async {
      final student = _fakeStudent();
      when(
        () => mockRepo.signUpWithEmail(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Right(student));

      await container.read(authProvider.future);

      await container
          .read(authProvider.notifier)
          .signUpWithEmail('Test User', 'test@example.com', 'password123');

      final state = container.read(authProvider);
      expect(state.hasValue, isTrue);
      final isAuthenticated = state.requireValue.map(
        unauthenticated: (_) => false,
        authenticated: (_) => true,
      );
      expect(isAuthenticated, isTrue);
    });

    test('email conflict → state is AsyncError with AuthFailure', () async {
      when(
        () => mockRepo.signUpWithEmail(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          AuthFailure(
            'An account with this email already exists. Try logging in.',
          ),
        ),
      );

      await container.read(authProvider.future);

      await container
          .read(authProvider.notifier)
          .signUpWithEmail('Test User', 'used@example.com', 'password123');

      final state = container.read(authProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<AuthFailure>());
    });

    test('offline → state is AsyncError with NetworkFailure', () async {
      when(
        () => mockRepo.signUpWithEmail(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          NetworkFailure('No internet connection. Please try again.'),
        ),
      );

      await container.read(authProvider.future);

      await container
          .read(authProvider.notifier)
          .signUpWithEmail('Test User', 'test@example.com', 'password123');

      final state = container.read(authProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<NetworkFailure>());
    });
  });

  group('AuthNotifier.signInWithEmailPassword', () {
    test('success → state transitions to authenticated', () async {
      final student = _fakeStudent();
      when(
        () => mockRepo.signInWithEmailPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Right(student));

      await container.read(authProvider.future);
      await container.read(authProvider.notifier).signInWithEmailPassword(
            email: 'test@example.com',
            password: 'pass1234',
          );

      final state = container.read(authProvider);
      expect(state.hasValue, isTrue);
      final isAuthenticated = state.requireValue.map(
        unauthenticated: (_) => false,
        authenticated: (_) => true,
      );
      expect(isAuthenticated, isTrue);
    });

    test('wrong credentials → state is AsyncError with AuthFailure', () async {
      when(
        () => mockRepo.signInWithEmailPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async =>
            const Left(AuthFailure('Incorrect email or password')),
      );

      await container.read(authProvider.future);
      await container.read(authProvider.notifier).signInWithEmailPassword(
            email: 'test@example.com',
            password: 'wrong',
          );

      final state = container.read(authProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<AuthFailure>());
    });
  });

  group('AuthNotifier.completeOnboarding', () {
    test('success → state has non-empty district', () async {
      final studentWithDistrict = _fakeStudent().copyWith(district: 'Colombo');
      when(
        () => mockRepo.updateProfile(
          studentId: any(named: 'studentId'),
          district: any(named: 'district'),
          school: any(named: 'school'),
          subjectNames: any(named: 'subjectNames'),
        ),
      ).thenAnswer((_) async => Right(studentWithDistrict));

      // Seed authenticated state with empty district so completeOnboarding runs
      final localContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );
      addTearDown(localContainer.dispose);
      await localContainer.read(authProvider.future);
      localContainer.read(authProvider.notifier).state = AsyncValue.data(
        AuthState.authenticated(student: _fakeStudent()),
      );

      await localContainer.read(authProvider.notifier).completeOnboarding(
            district: 'Colombo',
            school: 'Royal College',
            selectedSubjects: ['Chemistry'],
          );

      final state = localContainer.read(authProvider);
      expect(state.hasValue, isTrue);
      state.requireValue.mapOrNull(
        authenticated: (a) => expect(a.student.district, 'Colombo'),
      );
    });

    test('repository failure → state is AsyncError', () async {
      when(
        () => mockRepo.updateProfile(
          studentId: any(named: 'studentId'),
          district: any(named: 'district'),
          school: any(named: 'school'),
          subjectNames: any(named: 'subjectNames'),
        ),
      ).thenAnswer(
        (_) async =>
            const Left(DatabaseFailure('DB error')),
      );

      final localContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );
      addTearDown(localContainer.dispose);
      await localContainer.read(authProvider.future);
      localContainer.read(authProvider.notifier).state = AsyncValue.data(
        AuthState.authenticated(student: _fakeStudent()),
      );

      await localContainer.read(authProvider.notifier).completeOnboarding(
            district: 'Colombo',
            school: 'Royal College',
            selectedSubjects: ['Chemistry'],
          );

      expect(localContainer.read(authProvider).hasError, isTrue);
    });
  });

  group('AuthNotifier.setFcmPermission', () {
    test('granted → notificationsEnabled true and fcmToken stored', () async {
      when(() => mockRepo.updateFcmToken(any(), any()))
          .thenAnswer((_) async => const Right(unit));

      final localContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );
      addTearDown(localContainer.dispose);
      await localContainer.read(authProvider.future);
      localContainer.read(authProvider.notifier).state = AsyncValue.data(
        AuthState.authenticated(student: _fakeStudent()),
      );

      await localContainer.read(authProvider.notifier).setFcmPermission(
            granted: true,
            fcmToken: 'token-123',
          );

      final state = localContainer.read(authProvider);
      expect(state.hasValue, isTrue);
      state.requireValue.mapOrNull(
        authenticated: (a) {
          expect(a.student.notificationsEnabled, isTrue);
          expect(a.student.fcmToken, 'token-123');
        },
      );
    });

    test('DAO failure → in-memory state not updated', () async {
      when(() => mockRepo.updateFcmToken(any(), any())).thenAnswer(
        (_) async => const Left(DatabaseFailure('token write failed')),
      );

      final localContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );
      addTearDown(localContainer.dispose);
      await localContainer.read(authProvider.future);
      localContainer.read(authProvider.notifier).state = AsyncValue.data(
        AuthState.authenticated(student: _fakeStudent()),
      );

      await localContainer.read(authProvider.notifier).setFcmPermission(
            granted: true,
            fcmToken: 'token-abc',
          );

      final state = localContainer.read(authProvider);
      expect(state.hasValue, isTrue);
      // State must not have been updated — notificationsEnabled stays at
      // its original value and fcmToken remains null.
      state.requireValue.mapOrNull(
        authenticated: (a) {
          expect(a.student.notificationsEnabled, isTrue);
          expect(a.student.fcmToken, isNull);
        },
      );
    });
  });

  group('AuthNotifier.editProfile', () {
    test('success → state has updated student name', () async {
      final updatedStudent = _fakeStudent().copyWith(
        name: 'New Name',
        district: 'Colombo',
      );
      when(
        () => mockRepo.editProfile(
          studentId: any(named: 'studentId'),
          name: any(named: 'name'),
          district: any(named: 'district'),
          school: any(named: 'school'),
        ),
      ).thenAnswer((_) async => Right(updatedStudent));

      final localContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );
      addTearDown(localContainer.dispose);
      await localContainer.read(authProvider.future);
      localContainer.read(authProvider.notifier).state = AsyncValue.data(
        AuthState.authenticated(student: _fakeStudent()),
      );

      await localContainer.read(authProvider.notifier).editProfile(
            name: 'New Name',
            district: 'Colombo',
            school: 'Royal College',
          );

      final state = localContainer.read(authProvider);
      expect(state.hasValue, isTrue);
      state.requireValue.mapOrNull(
        authenticated: (a) => expect(a.student.name, 'New Name'),
      );
    });

    test('repository failure → state is AsyncError', () async {
      when(
        () => mockRepo.editProfile(
          studentId: any(named: 'studentId'),
          name: any(named: 'name'),
          district: any(named: 'district'),
          school: any(named: 'school'),
        ),
      ).thenAnswer(
        (_) async => const Left(DatabaseFailure('DB error')),
      );

      final localContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );
      addTearDown(localContainer.dispose);
      await localContainer.read(authProvider.future);
      localContainer.read(authProvider.notifier).state = AsyncValue.data(
        AuthState.authenticated(student: _fakeStudent()),
      );

      await localContainer.read(authProvider.notifier).editProfile(
            name: 'Bad Name',
            district: 'Colombo',
            school: 'Royal College',
          );

      expect(localContainer.read(authProvider).hasError, isTrue);
    });
  });

  group('AuthNotifier.signInWithGoogle', () {
    test('success, isNewStudent: true → authenticated with isNewStudent: true',
        () async {
      final student = _fakeStudent();
      when(() => mockRepo.signInWithGoogle()).thenAnswer(
        (_) async => Right((student: student, isNewStudent: true)),
      );

      await container.read(authProvider.future);
      await container.read(authProvider.notifier).signInWithGoogle();

      final state = container.read(authProvider);
      expect(state.hasValue, isTrue);
      state.requireValue.whenOrNull(
        authenticated: (_, isNewStudent) => expect(isNewStudent, isTrue),
      );
    });

    test(
        'success, isNewStudent: false → authenticated with isNewStudent: false',
        () async {
      final student = _fakeStudent();
      when(() => mockRepo.signInWithGoogle()).thenAnswer(
        (_) async => Right((student: student, isNewStudent: false)),
      );

      await container.read(authProvider.future);
      await container.read(authProvider.notifier).signInWithGoogle();

      final state = container.read(authProvider);
      expect(state.hasValue, isTrue);
      state.requireValue.whenOrNull(
        authenticated: (_, isNewStudent) => expect(isNewStudent, isFalse),
      );
    });
  });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Student _fakeStudent() => const Student(
      id: 'user-abc',
      name: 'Test User',
      email: 'test@example.com',
      district: '',
      school: '',
      notificationsEnabled: true,
      lastActiveAt: '2026-04-18T00:00:00.000Z',
      createdAt: '2026-04-18T00:00:00.000Z',
    );
