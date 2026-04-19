import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/features/notifications/data/notification_service.dart';

class _MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class _MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  late _MockFirebaseMessaging mockMessaging;
  late _MockFirebaseCrashlytics mockCrashlytics;
  late NotificationService service;

  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
  });

  setUp(() {
    mockMessaging = _MockFirebaseMessaging();
    mockCrashlytics = _MockFirebaseCrashlytics();
    service = NotificationService(
      messaging: mockMessaging,
      crashlytics: mockCrashlytics,
    );
  });

  group('NotificationService.getFcmToken', () {
    test('returns token string on success', () async {
      when(() => mockMessaging.getToken())
          .thenAnswer((_) async => 'test-token');

      final result = await service.getFcmToken();

      expect(result, equals('test-token'));
    });

    test(
      'returns null and logs non-fatal when FirebaseException is thrown',
      () async {
        final exception = FirebaseException(
          plugin: 'messaging',
          code: 'unknown',
        );
        when(() => mockMessaging.getToken()).thenThrow(exception);
        when(
          () => mockCrashlytics.recordError(
            any<Object?>(),
            any<StackTrace?>(),
            reason: any<Object?>(named: 'reason'),
          ),
        ).thenAnswer((_) async {});

        final result = await service.getFcmToken();

        expect(result, isNull);
        verify(
          () => mockCrashlytics.recordError(
            exception,
            any<StackTrace?>(),
            reason: 'FCM token retrieval failed',
          ),
        ).called(1);
      },
    );

    test(
      'returns null without crashing when token is null (permission denied)',
      () async {
        when(() => mockMessaging.getToken()).thenAnswer((_) async => null);

        final result = await service.getFcmToken();

        expect(result, isNull);
      },
    );

    test(
      'returns null and logs non-fatal when generic Object is thrown',
      () async {
        when(() => mockMessaging.getToken())
            .thenThrow(Exception('network error'));
        when(
          () => mockCrashlytics.recordError(
            any<Object?>(),
            any<StackTrace?>(),
            reason: any<Object?>(named: 'reason'),
          ),
        ).thenAnswer((_) async {});

        final result = await service.getFcmToken();

        expect(result, isNull);
        verify(
          () => mockCrashlytics.recordError(
            any<Object?>(),
            any<StackTrace?>(),
            reason: 'FCM token retrieval failed',
          ),
        ).called(1);
      },
    );
  });

  group('NotificationService.onTokenRefresh', () {
    test('exposes FirebaseMessaging.onTokenRefresh stream', () {
      final controller = StreamController<String>.broadcast();
      when(() => mockMessaging.onTokenRefresh)
          .thenAnswer((_) => controller.stream);

      final stream = service.onTokenRefresh;

      expect(stream, isA<Stream<String>>());
      unawaited(controller.close());
    });
  });
}
