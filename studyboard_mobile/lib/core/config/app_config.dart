abstract final class AppConfig {
  // Replace with the Web application OAuth 2.0 client ID from
  // Google Cloud Console → Credentials → Web application client.
  // Must be the Web client (not Android) to receive an idToken for
  // Supabase's signInWithIdToken().
  static const String googleWebClientId =
      '719373400195-924eq6e2bqs4g1dlrpkvptedr0vv0g8u'
      '.apps.googleusercontent.com';
}
