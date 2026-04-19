abstract final class AppConfig {
  // Replace with the Web application OAuth 2.0 client ID from
  // Google Cloud Console → Credentials → Web application client.
  // Must be the Web client (not Android) to receive an idToken for
  // Supabase's signInWithIdToken().
  static const String googleWebClientId =
      'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
}
