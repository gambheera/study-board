import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyboard_mobile/core/config/app_config.dart';
import 'package:studyboard_mobile/core/theme/theme_mode_notifier.dart';
import 'package:studyboard_mobile/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // MUST be first — prevents any google_fonts network fetch (AC #4)
  GoogleFonts.config.allowRuntimeFetching = false;

  // 1. Firebase MUST be first (Crashlytics + FCM depend on it).
  //    Wrapped so a failure before error hooks are registered is still logged.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stack) {
    debugPrint('[Bootstrap] Firebase.initializeApp failed: $e\n$stack');
    // In debug builds, continue without Firebase so the UI can be previewed
    // before real credentials are wired up via `flutterfire configure`.
    if (!kDebugMode) rethrow;
  }

  // 2. Crashlytics error hooks — production and profile builds only.
  //    In debug mode Flutter's default red-screen handler is preserved.
  if (!kDebugMode) {
    final previousFlutterOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      previousFlutterOnError?.call(details);
      unawaited(
        FirebaseCrashlytics.instance
            .recordFlutterFatalError(details)
            .catchError(
              (Object e) => debugPrint(
                '[Crashlytics] recordFlutterFatalError failed: $e',
              ),
            ),
      );
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(
        FirebaseCrashlytics.instance
            .recordError(error, stack)
            .catchError(
              (Object e) => debugPrint('[Crashlytics] recordError failed: $e'),
            ),
      );
      return true;
    };
  }

  // 3. Supabase initialization (non-blocking for offline support).
  //    Env vars must be supplied via --dart-define at build time.
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw StateError(
      'SUPABASE_URL and SUPABASE_ANON_KEY must be provided via --dart-define.',
    );
  }
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // 4. Google Sign-In — must be initialized before any authenticate() call.
  await GoogleSignIn.instance.initialize(
    serverClientId: AppConfig.googleWebClientId,
  );
  assert(
    !AppConfig.googleWebClientId.startsWith('YOUR_'),
    'Replace AppConfig.googleWebClientId with the real Web OAuth 2.0 client ID '
    'from Google Cloud Console before running.',
  );

  // Load persisted ThemeMode BEFORE runApp to prevent first-frame flash (AC #1)
  final prefs = await SharedPreferences.getInstance();
  final savedThemeName = prefs.getString(ThemeModeNotifier.key);
  final initialThemeMode = ThemeMode.values.firstWhere(
    (m) => m.name == savedThemeName,
    orElse: () => ThemeMode.dark,
  );

  runApp(
    ProviderScope(
      overrides: [
        initialThemeModeProvider.overrideWithValue(initialThemeMode),
      ],
      child: await builder(),
    ),
  );
}
