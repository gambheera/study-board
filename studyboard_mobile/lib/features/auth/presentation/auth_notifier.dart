import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/auth/data/auth_provider.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  bool _explicitSignOut = false;

  @override
  Future<AuthState> build() async {
    final sessionResult =
        await ref.read(authRepositoryProvider).getCurrentUser();
    final initialState = sessionResult.fold(
      (_) => const AuthState.unauthenticated(),
      (student) => student != null
          ? AuthState.authenticated(student: student)
          : const AuthState.unauthenticated(),
    );

    ref.listen(authStateStreamProvider, (_, next) {
      next.whenData(_handleAuthStateChange);
    });

    return initialState;
  }

  Future<void> _handleAuthStateChange(supabase.AuthState authEvent) async {
    switch (authEvent.event) {
      case supabase.AuthChangeEvent.signedIn:
      case supabase.AuthChangeEvent.tokenRefreshed:
        final result = await ref.read(authRepositoryProvider).getCurrentUser();
        result.fold(
          (failure) {
            final isAuthenticated = state.value?.map(
                  unauthenticated: (_) => false,
                  authenticated: (_) => true,
                ) ??
                false;
            if (!isAuthenticated) {
              state = AsyncValue.error(failure, StackTrace.current);
            }
          },
          (student) {
            if (student != null) {
              // Only transition when explicitly unauthenticated — do not
              // override AsyncLoading (in-flight sign-in) or AsyncError.
              final currentlyUnauthenticated = state.value?.map(
                    unauthenticated: (_) => true,
                    authenticated: (_) => false,
                  ) ??
                  false;
              if (currentlyUnauthenticated) {
                state = AsyncValue.data(
                  AuthState.authenticated(student: student),
                );
              }
            }
          },
        );
      case supabase.AuthChangeEvent.signedOut:
        final wasExplicit = _explicitSignOut;
        _explicitSignOut = false;
        state = AsyncValue.data(
          AuthState.unauthenticated(sessionExpired: !wasExplicit),
        );
      case _:
        break;
    }
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

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (state.isLoading) return;
    state = const AsyncValue<AuthState>.loading();
    final result = await ref
        .read(authRepositoryProvider)
        .signInWithEmailPassword(email: email, password: password);
    state = result.fold(
      (failure) => AsyncValue<AuthState>.error(failure, StackTrace.current),
      (student) => AsyncValue.data(
        AuthState.authenticated(student: student),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;
    state = const AsyncValue<AuthState>.loading();
    final result = await ref.read(authRepositoryProvider).signInWithGoogle();
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

  Future<void> completeOnboarding({
    required String district,
    required String school,
    required List<String> selectedSubjects,
  }) async {
    if (state.isLoading) return;
    final student =
        state.value?.mapOrNull(authenticated: (a) => a.student);
    if (student == null) return;

    state = const AsyncValue<AuthState>.loading();
    final result = await ref.read(authRepositoryProvider).updateProfile(
          studentId: student.id,
          district: district,
          school: school,
          subjectNames: selectedSubjects,
        );
    state = result.fold(
      (failure) => AsyncValue<AuthState>.error(failure, StackTrace.current),
      (updatedStudent) => AsyncValue.data(
        AuthState.authenticated(student: updatedStudent),
      ),
    );
  }

  Future<void> setFcmPermission({
    required bool granted,
    required String? fcmToken,
  }) async {
    final student =
        state.value?.mapOrNull(authenticated: (a) => a.student);
    if (student == null) return;

    final token = granted ? fcmToken : null;
    final result = await ref
        .read(authRepositoryProvider)
        .updateFcmToken(student.id, token);

    result.fold(
      (_) => null,
      (_) {
        final current =
            state.value?.mapOrNull(authenticated: (a) => a.student);
        if (current != null) {
          state = AsyncValue.data(
            AuthState.authenticated(
              student: current.copyWith(
                notificationsEnabled: token != null,
                fcmToken: token,
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> editProfile({
    required String name,
    required String district,
    required String school,
  }) async {
    if (state.isLoading) return;
    // Capture student BEFORE loading state clears state.value
    final student = state.value?.mapOrNull(authenticated: (a) => a.student);
    if (student == null) return;

    state = const AsyncValue<AuthState>.loading();
    final result = await ref.read(authRepositoryProvider).editProfile(
          studentId: student.id,
          name: name,
          district: district,
          school: school,
        );
    state = result.fold(
      (failure) => AsyncValue<AuthState>.error(failure, StackTrace.current),
      (updatedStudent) => AsyncValue.data(
        AuthState.authenticated(student: updatedStudent),
      ),
    );
  }

  Future<void> signOut() async {
    if (state.isLoading) return;
    _explicitSignOut = true;
    state = const AsyncValue<AuthState>.loading();
    final result = await ref.read(authRepositoryProvider).signOut();
    state = result.fold(
      (failure) {
        _explicitSignOut = false;
        return AsyncValue<AuthState>.error(failure, StackTrace.current);
      },
      (_) => const AsyncValue.data(AuthState.unauthenticated()),
    );
  }
}
