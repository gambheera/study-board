import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/auth/google_sign_in_service.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/core/supabase/supabase_client_provider.dart';
import 'package:studyboard_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:studyboard_mobile/features/auth/domain/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final studentDao = ref.watch(studentDaoProvider);
  return AuthRepositoryImpl(
    client,
    studentDao,
    const GoogleSignInServiceImpl(),
  );
}

@Riverpod(keepAlive: true)
Stream<AuthState> authStateStream(Ref ref) {
  return ref.watch(authRepositoryProvider).getSessionStream();
}
