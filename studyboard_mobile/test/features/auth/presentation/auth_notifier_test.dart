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

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = _MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

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
      final isAuthenticated = state.requireValue.when(
        unauthenticated: () => false,
        authenticated: (_, _) => true,
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
