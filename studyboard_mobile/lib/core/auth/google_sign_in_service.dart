import 'package:google_sign_in/google_sign_in.dart';

// Single-method interface is intentional: required for mocktail injection
// in tests.
// ignore: one_member_abstracts
abstract interface class GoogleSignInService {
  Future<GoogleSignInAccount> authenticate();
}

class GoogleSignInServiceImpl implements GoogleSignInService {
  const GoogleSignInServiceImpl();

  @override
  Future<GoogleSignInAccount> authenticate() =>
      GoogleSignIn.instance.authenticate();
}
