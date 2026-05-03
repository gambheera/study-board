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

  /// Signs in with email and password.
  Future<Either<Failure, Student>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Signs in with Google OAuth.
  /// isNewStudent is true when no Drift record exists or district is empty.
  Future<Either<Failure, ({Student student, bool isNewStudent})>>
      signInWithGoogle();

  /// Updates student district, school, and subject enrollment in
  /// Drift + sync queue.
  Future<Either<Failure, Student>> updateProfile({
    required String studentId,
    required String district,
    required String school,
    required List<String> subjectNames,
  });

  /// Updates the FCM token and notifications_enabled flag in Drift.
  Future<Either<Failure, Unit>> updateFcmToken(
    String studentId,
    String? token,
  );

  /// Updates student name, district, and school in Drift + sync queue.
  /// Does NOT modify subject enrollment (StudentSubjectsTable rows unchanged).
  Future<Either<Failure, Student>> editProfile({
    required String studentId,
    required String name,
    required String district,
    required String school,
  });
}
