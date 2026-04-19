import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  const NotificationService({
    FirebaseMessaging? messaging,
    FirebaseCrashlytics? crashlytics,
  })  : _messaging = messaging,
        _crashlytics = crashlytics;

  final FirebaseMessaging? _messaging;
  final FirebaseCrashlytics? _crashlytics;

  FirebaseMessaging get _fcm => _messaging ?? FirebaseMessaging.instance;
  FirebaseCrashlytics get _crashlyticsInstance =>
      _crashlytics ?? FirebaseCrashlytics.instance;

  /// Returns the FCM registration token, or null on permission denial or
  /// network failure. Non-fatal failures are logged to Crashlytics.
  Future<String?> getFcmToken() async {
    try {
      return await _fcm.getToken();
    } on Object catch (error, stack) {
      try {
        await _crashlyticsInstance.recordError(
          error,
          stack,
          reason: 'FCM token retrieval failed',
        );
      } on Object catch (_) {
        // Crashlytics unavailable (e.g. debug mode without Firebase init)
      }
      return null;
    }
  }

  /// Stream of FCM token refreshes. Callers subscribe once per session and
  /// persist each new token via StudentDao.updateFcmToken().
  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;
}
