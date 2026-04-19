import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/auth/data/auth_provider.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    // Story 1.8 adds session persistence check here.
    return const AuthState.unauthenticated();
  }

  Future<void> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    if (state.isLoading) return;
    state = const AsyncValue<AuthState>.loading();
    final result = await ref.read(authRepositoryProvider).signUpWithEmail(
          name: name,
          email: email,
          password: password,
        );
    state = result.fold(
      (failure) => AsyncValue<AuthState>.error(failure, StackTrace.current),
      (student) => AsyncValue.data(
        AuthState.authenticated(student: student, isNewStudent: true),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;
    state = const AsyncValue<AuthState>.loading();
    final result =
        await ref.read(authRepositoryProvider).signInWithGoogle();
    state = result.fold(
      (failure) => AsyncValue<AuthState>.error(failure, StackTrace.current),
      (r) => AsyncValue.data(
        AuthState.authenticated(
          student: r.student,
          isNewStudent: r.isNewStudent,
        ),
      ),
    );
  }
}
