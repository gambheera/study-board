import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studyboard_mobile/core/auth/google_sign_in_service.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/student_dao.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/core/supabase/repository_base.dart';
import 'package:studyboard_mobile/features/auth/data/models/student_dto.dart';
import 'package:studyboard_mobile/features/auth/domain/auth_repository.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl extends RepositoryBase implements AuthRepository {
  AuthRepositoryImpl(this._client, this._studentDao, this._googleSignIn);

  final SupabaseClient _client;
  final StudentDao _studentDao;
  final GoogleSignInService _googleSignIn;

  @override
  Future<Either<Failure, Student>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    AuthResponse response;
    try {
      response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (e.statusCode == '422' ||
          msg.contains('already registered') ||
          msg.contains('already in use') ||
          msg.contains('already taken') ||
          msg.contains('email address is already')) {
        return const Left(
          AuthFailure(
            'An account with this email already exists. Try logging in.',
          ),
        );
      }
      return Left(AuthFailure(e.message));
    } on SocketException {
      return const Left(
        NetworkFailure('No internet connection. Please try again.'),
      );
    } on Object {
      return const Left(AuthFailure('Registration failed. Please try again.'));
    }

    final user = response.user;
    if (user == null) {
      return const Left(AuthFailure('Registration failed. Please try again.'));
    }

    // If session is null the Supabase project has email confirmation enabled.
    if (response.session == null) {
      return const Left(
        AuthFailure(
          'Account created! Check your email to confirm your registration.',
        ),
      );
    }

    final now = DateTime.now().toUtc().toIso8601String();

    // The students row is created by the on_auth_user_created trigger
    // (SECURITY DEFINER) — no client-side INSERT needed.
    try {
      await _studentDao.upsertStudent(
        StudentsTableCompanion.insert(
          id: user.id,
          name: name,
          email: email,
          district: '',
          school: '',
          lastActiveAt: now,
          createdAt: now,
          notificationsEnabled: const Value(true),
        ),
      );
    } on Object {
      return const Left(
        DatabaseFailure(
          'Failed to save your account locally. Please try again.',
        ),
      );
    }

    return Right(
      StudentDto.fromJson({
        'id': user.id,
        'name': name,
        'email': email,
        'district': '',
        'school': '',
        'notifications_enabled': true,
        'last_active_at': now,
        'created_at': now,
      }).toStudent(),
    );
  }

  @override
  Future<Either<Failure, Student>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    AuthResponse response;
    try {
      response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException {
      // AC: #3 — do not reveal which field is wrong.
      return const Left(AuthFailure('Incorrect email or password'));
    } on SocketException {
      return const Left(
        NetworkFailure('No internet connection. Please try again.'),
      );
    } on Object {
      return const Left(
        AuthFailure('Unable to complete sign-in. Please try again.'),
      );
    }

    final user = response.user;
    if (user == null) {
      return const Left(AuthFailure('Sign-in failed. Please try again.'));
    }
    final now = DateTime.now().toUtc().toIso8601String();

    final StudentsTableData? existing;
    try {
      existing = await _studentDao.getStudent(user.id);
    } on Object {
      try {
        await _client.auth.signOut();
      } on Object {
        // Best-effort — ignore signOut failure
      }
      return const Left(
        AuthFailure('Failed to load your profile. Please try again.'),
      );
    }

    if (existing == null) {
      // Fresh device — create a local row from Supabase auth metadata.
      try {
        await _studentDao.upsertStudent(
          StudentsTableCompanion.insert(
            id: user.id,
            name: (user.userMetadata?['name'] as String?) ?? user.email ?? '',
            email: user.email ?? '',
            district: '',
            school: '',
            lastActiveAt: now,
            createdAt: now,
            notificationsEnabled: const Value(false),
          ),
        );
      } on Object {
        try {
          await _client.auth.signOut();
        } on Object {
          // Best-effort — ignore signOut failure
        }
        return const Left(
          AuthFailure(
            'Failed to save your profile locally. Please try again.',
          ),
        );
      }
      return Right(
        StudentDto.fromJson({
          'id': user.id,
          'name': (user.userMetadata?['name'] as String?) ?? user.email ?? '',
          'email': user.email ?? '',
          'district': '',
          'school': '',
          'notifications_enabled': false,
          'last_active_at': now,
          'created_at': now,
        }).toStudent(),
      );
    }

    try {
      await _studentDao.updateLastActiveAt(user.id, now);
    } on Object {
      try {
        await _client.auth.signOut();
      } on Object {
        // Best-effort — ignore signOut failure
      }
      return const Left(
        AuthFailure(
          'Failed to update your profile locally. Please try again.',
        ),
      );
    }
    return Right(
      StudentDto.fromJson({
        'id': existing.id,
        'name': existing.name,
        'email': existing.email,
        'district': existing.district,
        'school': existing.school,
        'notifications_enabled': existing.notificationsEnabled,
        'last_active_at': now,
        'created_at': existing.createdAt,
      }).toStudent(),
    );
  }

  @override
  Future<Either<Failure, Student?>> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return const Right(null);

    return trySupabase(() async {
      final existing = await _studentDao.getStudent(user.id);
      if (existing != null) {
        return StudentDto.fromJson({
          'id': existing.id,
          'name': existing.name,
          'email': existing.email,
          'district': existing.district,
          'school': existing.school,
          'notifications_enabled': existing.notificationsEnabled,
          'last_active_at': existing.lastActiveAt,
          'created_at': existing.createdAt,
        }).toStudent();
      }
      // Valid Supabase session but no Drift row (e.g., app reinstall while
      // token is still cached) — rebuild a minimal local record.
      final now = DateTime.now().toUtc().toIso8601String();
      final name = (user.userMetadata?['name'] as String?) ?? user.email ?? '';
      final email = user.email ?? '';
      await _studentDao.upsertStudent(
        StudentsTableCompanion.insert(
          id: user.id,
          name: name,
          email: email,
          district: '',
          school: '',
          lastActiveAt: now,
          createdAt: now,
          notificationsEnabled: const Value(false),
        ),
      );
      return StudentDto.fromJson({
        'id': user.id,
        'name': name,
        'email': email,
        'district': '',
        'school': '',
        'notifications_enabled': false,
        'last_active_at': now,
        'created_at': now,
      }).toStudent();
    });
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    final userId = _client.auth.currentUser?.id;
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on SocketException {
      return const Left(
        NetworkFailure('No internet connection. Please try again.'),
      );
    } on Object {
      return const Left(AuthFailure('Sign-out failed. Please try again.'));
    }
    // Drift delete is best-effort — Supabase sign-out already succeeded.
    if (userId != null) {
      try {
        await _studentDao.deleteStudent(userId);
      } on Object {
        // Local cache clear failed; row will be overwritten on next sign-in.
      }
    }
    return const Right(unit);
  }

  @override
  Stream<AuthState> getSessionStream() => _client.auth.onAuthStateChange;

  @override
  Future<Either<Failure, Student>> updateProfile({
    required String studentId,
    required String district,
    required String school,
    required List<String> subjectNames,
  }) async {
    try {
      await _studentDao.updateProfileWithSubjects(
        studentId,
        district: district,
        school: school,
        subjectNames: subjectNames,
      );
    } on Object {
      return const Left(
        DatabaseFailure('Failed to save your profile. Please try again.'),
      );
    }

    final updated = await _studentDao.getStudent(studentId);
    if (updated == null) {
      return const Left(
        DatabaseFailure('Profile saved but could not be read back.'),
      );
    }

    return Right(
      StudentDto.fromJson({
        'id': updated.id,
        'name': updated.name,
        'email': updated.email,
        'district': updated.district,
        'school': updated.school,
        'notifications_enabled': updated.notificationsEnabled,
        'fcm_token': updated.fcmToken,
        'last_active_at': updated.lastActiveAt,
        'created_at': updated.createdAt,
      }).toStudent(),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateFcmToken(
    String studentId,
    String? token,
  ) async {
    try {
      await _studentDao.updateFcmToken(studentId, token);
      return const Right(unit);
    } on Object {
      return const Left(
        DatabaseFailure('Failed to update notification settings.'),
      );
    }
  }

  @override
  Future<Either<Failure, Student>> editProfile({
    required String studentId,
    required String name,
    required String district,
    required String school,
  }) async {
    try {
      await _studentDao.updateStudentProfile(
        studentId,
        name: name,
        district: district,
        school: school,
      );
    } on Object {
      return const Left(
        DatabaseFailure('Failed to save your profile. Please try again.'),
      );
    }

    final updated = await _studentDao.getStudent(studentId);
    if (updated == null) {
      return const Left(
        DatabaseFailure('Profile saved but could not be read back.'),
      );
    }

    return Right(
      StudentDto.fromJson({
        'id': updated.id,
        'name': updated.name,
        'email': updated.email,
        'district': updated.district,
        'school': updated.school,
        'notifications_enabled': updated.notificationsEnabled,
        'fcm_token': updated.fcmToken,
        'last_active_at': updated.lastActiveAt,
        'created_at': updated.createdAt,
      }).toStudent(),
    );
  }

  @override
  Future<Either<Failure, ({Student student, bool isNewStudent})>>
      signInWithGoogle() async {
    GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Left(AuthFailure(AuthFailure.googleSignInCancelled));
      }
      return const Left(
        AuthFailure('Google Sign-In failed. Please try again.'),
      );
    } on Object {
      return const Left(
        AuthFailure('Google Sign-In failed. Please try again.'),
      );
    }

    // v7: authentication is a synchronous getter; can throw PlatformException
    // if the token was revoked since authenticate() returned.
    final String? idToken;
    try {
      idToken = googleUser.authentication.idToken;
    } on Object {
      return const Left(
        AuthFailure('Google Sign-In failed. Please try again.'),
      );
    }
    if (idToken == null) {
      return const Left(
        AuthFailure(
          'Google authentication failed. Please check app configuration.',
        ),
      );
    }

    // Non-nullable capture: type promotion ends at closure boundary.
    final resolvedIdToken = idToken;
    return trySupabase(() async {
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: resolvedIdToken,
      );

      final user = _client.auth.currentUser;
      if (user == null) {
        throw const AuthException(
          'Sign-in failed: no user after token exchange',
        );
      }

      final now = DateTime.now().toUtc().toIso8601String();

      // Separate try/catch for DAO calls: a Drift failure after a successful
      // Supabase exchange must sign the user out to avoid an orphaned session.
      final StudentsTableData? existing;
      try {
        existing = await _studentDao.getStudent(user.id);
      } on Object {
        try {
          await _client.auth.signOut();
        } on Object {
          // Best-effort — ignore signOut failure
        }
        throw const AuthException(
          'Failed to load your local profile. Please try again.',
        );
      }

      final isNewStudent = existing == null || existing.district.isEmpty;

      if (isNewStudent) {
        final name = googleUser.displayName ?? googleUser.email;
        final email = googleUser.email;
        try {
          await _studentDao.upsertStudent(
            StudentsTableCompanion.insert(
              id: user.id,
              name: name,
              email: email,
              district: existing?.district ?? '',
              school: existing?.school ?? '',
              lastActiveAt: now,
              createdAt: existing?.createdAt ?? now,
              notificationsEnabled:
                  Value(existing?.notificationsEnabled ?? true),
            ),
          );
        } on Object {
          try {
            await _client.auth.signOut();
          } on Object {
            // Best-effort — ignore signOut failure
          }
          throw const AuthException(
            'Failed to save your account locally. Please try again.',
          );
        }
        return (
          student: StudentDto.fromJson({
            'id': user.id,
            'name': name,
            'email': email,
            'district': existing?.district ?? '',
            'school': existing?.school ?? '',
            'notifications_enabled': existing?.notificationsEnabled ?? true,
            'last_active_at': now,
            'created_at': existing?.createdAt ?? now,
          }).toStudent(),
          isNewStudent: true,
        );
      } else {
        try {
          await _studentDao.updateLastActiveAt(existing.id, now);
        } on Object {
          try {
            await _client.auth.signOut();
          } on Object {
            // Best-effort — ignore signOut failure
          }
          throw const AuthException(
            'Failed to update your profile locally. Please try again.',
          );
        }
        return (
          student: StudentDto.fromJson({
            'id': existing.id,
            'name': existing.name,
            'email': existing.email,
            'district': existing.district,
            'school': existing.school,
            'notifications_enabled': existing.notificationsEnabled,
            'last_active_at': now,
            'created_at': existing.createdAt,
          }).toStudent(),
          isNewStudent: false,
        );
      }
    });
  }
}
