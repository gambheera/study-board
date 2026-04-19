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
  Future<Either<Failure, Student?>> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return const Right(null);
    return Right(StudentDto.fromSupabaseUser(user).toStudent());
  }

  @override
  Future<Either<Failure, Unit>> signOut() => trySupabase(() async {
        await _client.auth.signOut();
        return unit;
      });

  @override
  Stream<AuthState> getSessionStream() => _client.auth.onAuthStateChange;

  @override
  Future<Either<Failure, ({Student student, bool isNewStudent})>>
      signInWithGoogle() async {
    GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Left(AuthFailure('Google Sign-In was cancelled.'));
      }
      return const Left(
        AuthFailure('Google Sign-In failed. Please try again.'),
      );
    } on Object {
      return const Left(
        AuthFailure('Google Sign-In failed. Please try again.'),
      );
    }

    // v7: authentication is a synchronous getter; idToken is null when
    // serverClientId is not configured correctly.
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      return const Left(
        AuthFailure(
          'Google authentication failed. Please check app configuration.',
        ),
      );
    }

    return trySupabase(() async {
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final user = _client.auth.currentUser;
      if (user == null) {
        throw const AuthException(
          'Sign-in failed: no user after token exchange',
        );
      }

      final now = DateTime.now().toUtc().toIso8601String();
      final existing = await _studentDao.getStudent(user.id);
      final isNewStudent = existing == null || existing.district.isEmpty;

      if (isNewStudent) {
        final name = googleUser.displayName ?? googleUser.email;
        final email = googleUser.email;
        await _studentDao.upsertStudent(
          StudentsTableCompanion.insert(
            id: user.id,
            name: name,
            email: email,
            district: existing?.district ?? '',
            school: existing?.school ?? '',
            lastActiveAt: now,
            createdAt: existing?.createdAt ?? now,
            notificationsEnabled: const Value(true),
          ),
        );
        return (
          student: StudentDto.fromJson({
            'id': user.id,
            'name': name,
            'email': email,
            'district': existing?.district ?? '',
            'school': existing?.school ?? '',
            'notifications_enabled': true,
            'last_active_at': now,
            'created_at': existing?.createdAt ?? now,
          }).toStudent(),
          isNewStudent: true,
        );
      } else {
        await _studentDao.updateLastActiveAt(existing.id, now);
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
