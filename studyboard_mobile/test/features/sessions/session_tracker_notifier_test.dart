import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/features/auth/data/auth_provider.dart';
import 'package:studyboard_mobile/features/auth/domain/auth_repository.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/sessions/data/session_provider.dart';
import 'package:studyboard_mobile/features/sessions/domain/session_repository.dart';
import 'package:studyboard_mobile/features/sessions/presentation/session_tracker_notifier.dart';

class _MockSessionRepository extends Mock implements SessionRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

Student _fakeStudent() => const Student(
      id: 'stu-1',
      name: 'Test Student',
      email: 'test@example.com',
      district: 'Colombo',
      school: 'RC',
      notificationsEnabled: true,
      lastActiveAt: '2026-01-01T00:00:00.000Z',
      createdAt: '2026-01-01T00:00:00.000Z',
    );

void main() {
  late _MockSessionRepository mockSessionRepo;
  late _MockAuthRepository mockAuthRepo;

  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  setUp(() {
    mockSessionRepo = _MockSessionRepository();
    mockAuthRepo = _MockAuthRepository();
    when(() => mockSessionRepo.openSession(any())).thenAnswer((_) async {});
    when(() => mockSessionRepo.closeSession()).thenAnswer((_) async {});
    when(() => mockAuthRepo.getCurrentUser())
        .thenAnswer((_) async => const Right(null));
    when(() => mockAuthRepo.getSessionStream())
        .thenAnswer((_) => const Stream.empty());
  });

  ProviderContainer makeAuthenticatedContainer() {
    when(() => mockAuthRepo.getCurrentUser())
        .thenAnswer((_) async => Right(_fakeStudent()));
    return ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => mockAuthRepo),
        sessionRepositoryProvider.overrideWithValue(mockSessionRepo),
      ],
    );
  }

  ProviderContainer makeUnauthenticatedContainer() => ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockAuthRepo),
          sessionRepositoryProvider.overrideWithValue(mockSessionRepo),
        ],
      );

  group('SessionTrackerNotifier.build', () {
    test('calls openSession when student is authenticated', () async {
      final container = makeAuthenticatedContainer();
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      await container.read(sessionTrackerProvider.future);

      verify(() => mockSessionRepo.openSession('stu-1')).called(1);
    });

    test('does NOT call openSession when student is unauthenticated', () async {
      final container = makeUnauthenticatedContainer();
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      await container.read(sessionTrackerProvider.future);

      verifyNever(() => mockSessionRepo.openSession(any()));
    });
  });

  group('SessionTrackerNotifier lifecycle', () {
    test('paused calls closeSession', () async {
      final container = makeAuthenticatedContainer();
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      final sub = container.listen<AsyncValue<void>>(
        sessionTrackerProvider,
        (_, _) {},
      );
      addTearDown(sub.close);
      await container.read(sessionTrackerProvider.future);

      final notifier = container.read(sessionTrackerProvider.notifier);
      clearInteractions(mockSessionRepo);
      when(() => mockSessionRepo.closeSession()).thenAnswer((_) async {});

      notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
      await Future<void>.delayed(Duration.zero);

      verify(() => mockSessionRepo.closeSession()).called(1);
    });

    test('resumed within 30 min does NOT call openSession again', () async {
      final container = makeAuthenticatedContainer();
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      final sub = container.listen<AsyncValue<void>>(
        sessionTrackerProvider,
        (_, _) {},
      );
      addTearDown(sub.close);
      await container.read(sessionTrackerProvider.future);

      final notifier = container.read(sessionTrackerProvider.notifier);
      clearInteractions(mockSessionRepo);
      when(() => mockSessionRepo.openSession(any())).thenAnswer((_) async {});
      when(() => mockSessionRepo.closeSession()).thenAnswer((_) async {});

      notifier.didChangeAppLifecycleState(AppLifecycleState.paused);
      notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => mockSessionRepo.openSession(any()));
    });

    // testWidgets runs in a FakeAsync zone — tester.pump() advances
    // DateTime.now(), enabling the 30-minute boundary to be tested.
    testWidgets('resumed after >30 min gap calls openSession', (tester) async {
      when(() => mockAuthRepo.getCurrentUser())
          .thenAnswer((_) async => Right(_fakeStudent()));
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockAuthRepo),
          sessionRepositoryProvider.overrideWithValue(mockSessionRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authProvider.future);

      // listen keeps the autoDispose provider alive through time advancement.
      final sub = container.listen<AsyncValue<void>>(
        sessionTrackerProvider,
        (_, _) {},
      );
      addTearDown(sub.close);
      await container.read(sessionTrackerProvider.future);

      final notifier = container.read(sessionTrackerProvider.notifier);
      clearInteractions(mockSessionRepo);
      when(() => mockSessionRepo.openSession(any())).thenAnswer((_) async {});
      when(() => mockSessionRepo.closeSession()).thenAnswer((_) async {});

      notifier.didChangeAppLifecycleState(AppLifecycleState.paused);

      await tester.pump(const Duration(minutes: 31));

      notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await tester.pump();

      verify(() => mockSessionRepo.openSession(any())).called(1);
    });
  });
}
