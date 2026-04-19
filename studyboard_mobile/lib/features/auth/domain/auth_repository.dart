import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

abstract interface class AuthRepository {
  /// Creates a new student account with email and password.
  Future<Either<Failure, Student>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  /// Returns the currently authenticated student, or null if no active session.
  Future<Either<Failure, Student?>> getCurrentUser();

  /// Signs out the current user and clears the local session.
  Future<Either<Failure, Unit>> signOut();

  /// Stream of Supabase auth state changes (login, logout, token refresh).
  Stream<AuthState> getSessionStream();

  /// Signs in with Google OAuth.
  /// isNewStudent is true when no Drift record exists or district is empty.
  Future<Either<Failure, ({Student student, bool isNewStudent})>>
      signInWithGoogle();
}
