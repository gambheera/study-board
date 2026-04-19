# Story 1.8: Student Login & Session Persistence

Status: ready-for-dev

## Story

As a student,
I want to log in to my existing account and have my session remembered between app opens,
so that I don't have to sign in again every time I open StudyBoard.

## Acceptance Criteria

1. **Given** the login screen **When** a student enters their registered email and password and taps "Log in" **Then** Supabase Auth authenticates the student and they are routed to `/board`

2. **Given** the login screen **When** a student taps "Continue with Google" **Then** the Google Sign-In flow from Story 1.7 handles authentication and routes the student to `/board`

3. **Given** an incorrect email and password combination **When** the student submits the login form **Then** an inline error "Incorrect email or password" is displayed without revealing which specific field is wrong, and the form is not cleared

4. **Given** a valid session exists in `supabase_flutter` session storage **When** the app is launched **Then** the student is automatically routed to `/board` without seeing the login screen — cold start to board in ≤ 3 seconds (NFR1)

5. **Given** no stored session exists (first install or after logout) **When** the app initializes **Then** the login screen is displayed as the initial route

6. **Given** a student's session expires while the app is in the background **When** they return to the app and the session refresh attempt fails **Then** the student is routed to the login screen with a brief message ("Your session expired — please log in again") and their previous navigation state is preserved where possible

## Tasks / Subtasks

- [ ] Task 1: Add `signInWithEmailPassword()` to `AuthRepository` interface (AC: #1, #3)
  - [ ] Open `lib/features/auth/domain/auth_repository.dart`
  - [ ] Add method: `Future<Either<Failure, Student>> signInWithEmailPassword({required String email, required String password});`

- [ ] Task 2: Implement `signInWithEmailPassword()` in `AuthRepositoryImpl` + fix `getCurrentUser()` (DEF1) + fix `signOut()` (DEF2) (AC: #1, #3, #4, #5)
  - [ ] Open `lib/features/auth/data/auth_repository_impl.dart`
  - [ ] Implement `signInWithEmailPassword()` — calls `_client.auth.signInWithPassword()` inside `trySupabase()`; reads student from Drift after auth; see Dev Notes for full impl
  - [ ] Fix `getCurrentUser()` — replace body to read from `_studentDao.getStudent(user.id)` first instead of reconstructing from auth user only (DEF1)
  - [ ] Fix `signOut()` — call `_studentDao.deleteStudent(userId)` after `auth.signOut()` (DEF2); if `deleteStudent()` does not exist on `StudentDao`, add it — see Dev Notes
  - [ ] Ensure Supabase error "Invalid login credentials" is NEVER passed through to UI — always map to `AuthFailure('Incorrect email or password')`

- [ ] Task 3: Add `signInWithEmailPassword()`, fix `build()` + stream wiring in `AuthNotifier` (AC: #1, #3, #4, #5, #6, DEF3, DEF5, DEF8)
  - [ ] Open `lib/features/auth/presentation/auth_notifier.dart`
  - [ ] Add `signInWithEmailPassword()` method — same concurrency guard + Either fold pattern as `signInWithGoogle()`; always emits `isNewStudent: false`
  - [ ] Fix `AuthNotifier.build()` — add `_restoreSession()` call for cold-start session check (DEF3); see Dev Notes for implementation
  - [ ] Wire `authStateStream` via `ref.listen(authStateStreamProvider, ...)` inside `build()` to handle `signedIn`/`signedOut`/`tokenRefreshed` events (DEF5); see Dev Notes for DEF8 race mitigation and session-expired message
  - [ ] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` — `build()` now returns `Future<AuthState>` which changes the generated code

- [ ] Task 4: Add `sessionExpired` field to `AuthState.unauthenticated` (AC: #6)
  - [ ] Open `lib/features/auth/presentation/auth_state.dart`
  - [ ] Add `@Default(false) bool sessionExpired` to `AuthState.unauthenticated()` factory
  - [ ] Run `dart run build_runner build --delete-conflicting-outputs` after this change
  - [ ] In `AuthNotifier._handleAuthStateChange()`, emit `AuthState.unauthenticated(sessionExpired: true)` when stream emits `signedOut` via token expiry (not from explicit `signOut()` call); set a `bool _explicitSignOut = false` flag that `signOut()` sets to `true` before calling `auth.signOut()`

- [ ] Task 5: Create `LoginScreen` widget (AC: #1, #2, #3, #5, #6)
  - [ ] Create `lib/features/auth/presentation/login_screen.dart`
  - [ ] Email `AuthFormField` + password `AuthFormField` (obscured) + "Log in" `FilledButton` + divider + `GoogleSignInButton`
  - [ ] Validation fires on blur only (same pattern as `RegisterScreen`) — `_emailTouched`, `_passwordTouched` flags
  - [ ] `ref.listen(authProvider, ...)` drives routing: authenticated → `context.go('/board')`; error → SnackBar with Failure message
  - [ ] On first render, if `authProvider.value` is `AuthState.unauthenticated(sessionExpired: true)`, show SnackBar "Your session expired — please log in again" using `WidgetsBinding.instance.addPostFrameCallback`
  - [ ] See Dev Notes for full widget code

- [ ] Task 6: Add `/login` route + auth guard `redirect` to go_router (AC: #4, #5, DEF4)
  - [ ] Open the file containing `goRouterProvider` (check `lib/core/routing/` or `lib/app/` — locate via `grep -r "GoRouter(" lib/`)
  - [ ] Add `GoRoute(path: '/login', builder: (_, __) => const LoginScreen())` to the routes list
  - [ ] Add `redirect` callback: unauthenticated + non-`/login` destination → `/login`; authenticated + `/login` destination → `/board`
  - [ ] Add `refreshListenable: RouterNotifier(ref)` (or extend existing notifier) so the router re-evaluates `redirect` on every `authProvider` state change; see Dev Notes for `RouterNotifier` implementation
  - [ ] Update initial location to `/login` (router will redirect to `/board` if session exists)

- [ ] Task 7: Tests (AC: #1, #2, #3, #4, #5, #6)
  - [ ] Update `test/features/auth/data/auth_repository_impl_test.dart` — add 3 test cases for `signInWithEmailPassword()` (success, wrong credentials, Drift row absent), 1 for fixed `getCurrentUser()` (verifies Drift read), 1 for fixed `signOut()` (verifies Drift delete)
  - [ ] Update `test/features/auth/presentation/auth_notifier_test.dart` — 2 test cases for `signInWithEmailPassword()`, 1 for session restore in `build()`, 1 for stream `signedOut` → unauthenticated transition
  - [ ] Run `flutter test` → all pass; `flutter analyze` → 0 issues

## Dev Notes

### CRITICAL: Deferred Work This Story MUST Resolve

From `_bmad-output/implementation-artifacts/deferred-work.md`:

- **DEF1** `getCurrentUser()` reconstructs Student from Supabase auth user only — ignores Drift cache; `district`, `school`, `notificationsEnabled` are never returned. **Fix in Task 2:** read from `_studentDao.getStudent(user.id)` first; if Drift row absent, return `null` (treat as unauthenticated).
- **DEF2** `signOut()` does not clear the local Drift student row — next user on the same device reads the previous user's cached profile. **Fix in Task 2:** call `_studentDao.deleteStudent(userId)` after `auth.signOut()`.
- **DEF3** `AuthNotifier.build()` always returns `AuthState.unauthenticated()` with no session check. **Fix in Task 3:** call `getCurrentUser()` in `build()` and emit `authenticated` if a valid session + Drift row exist.
- **DEF4** Router has no auth guard — `/board`, `/dashboard`, `/backlog` are accessible without authentication. **Fix in Task 6:** add `redirect` callback to `goRouterProvider`.
- **DEF5** `authStateStream` events never propagate to `AuthNotifier.state`. **Fix in Task 3:** wire `ref.listen(authStateStreamProvider, ...)` inside `build()`.
- **DEF8** Race between Supabase `signedIn` stream event and Drift upsert (from registration) — stream may fire before `upsertStudent` completes, causing navigation into the app with no Drift row. **Fix in Task 3:** in the stream `signedIn` handler, call `getCurrentUser()` (fixed DEF1) — if Drift row absent, stay `unauthenticated`; do not navigate until the row is confirmed.

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/features/auth/domain/auth_repository.dart` — interface with `signUpWithEmail()`, `signInWithGoogle()`, `getCurrentUser()`, `signOut()`, `getSessionStream()`; **ADD** `signInWithEmailPassword()`, **FIX** `getCurrentUser()` and `signOut()`; do NOT remove existing methods
- `lib/features/auth/data/auth_repository_impl.dart` — full implementation; ADD new method + fix DEF1/DEF2 bodies only
- `lib/features/auth/presentation/auth_notifier.dart` — exists with `signUpWithEmail()`, `signInWithGoogle()`; ADD `signInWithEmailPassword()`, fix `build()`
- `lib/features/auth/presentation/auth_state.dart` — `AuthState.authenticated(student, isNewStudent)` from Story 1.7; ADD `sessionExpired` to `unauthenticated` only
- `lib/features/auth/presentation/widgets/auth_form_field.dart` — `AuthFormField` complete; use as-is
- `lib/features/auth/presentation/widgets/google_sign_in_button.dart` — `GoogleSignInButton` from Story 1.7; import and reuse in `LoginScreen`; do NOT modify
- `lib/features/auth/presentation/register_screen.dart` — unchanged; routing via `isNewStudent` from Story 1.7 still correct
- `lib/core/database/daos/student_dao.dart` — `getStudent(String studentId)`, `upsertStudent()`, `updateLastActiveAt()` already exist; check if `deleteStudent()` exists before adding it
- `lib/core/supabase/repository_base.dart` — `trySupabase()` unchanged
- `lib/core/config/app_config.dart` — `googleWebClientId` from Story 1.7; no changes

### `signInWithEmailPassword()` — Full Implementation

```dart
// lib/features/auth/domain/auth_repository.dart — ADD
Future<Either<Failure, Student>> signInWithEmailPassword({
  required String email,
  required String password,
});
```

```dart
// lib/features/auth/data/auth_repository_impl.dart — ADD
@override
Future<Either<Failure, Student>> signInWithEmailPassword({
  required String email,
  required String password,
}) async {
  return trySupabase(() async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) {
      throw const AuthException('Login failed: no user returned');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    await _studentDao.updateLastActiveAt(user.id, now);

    final existing = await _studentDao.getStudent(user.id);
    if (existing == null) {
      // Drift row absent (e.g. stale token on fresh install) — return minimal student
      return StudentDto.fromJson({
        'id': user.id,
        'name': user.userMetadata?['name'] ?? user.email ?? '',
        'email': user.email ?? '',
        'district': '',
        'school': '',
        'notifications_enabled': false,
        'last_active_at': now,
        'created_at': now,
      }).toStudent();
    }
    return StudentDto.fromJson({
      'id': existing.id,
      'name': existing.name,
      'email': existing.email,
      'district': existing.district,
      'school': existing.school,
      'notifications_enabled': existing.notificationsEnabled,
      'last_active_at': now,
      'created_at': existing.createdAt,
    }).toStudent();
  });
}
```

**Critical:** `trySupabase()` catches `AuthException` from Supabase (message: "Invalid login credentials") and maps it to `Left(AuthFailure(...))`. The caller must **never** pass the Supabase error message to the UI. The `signInWithEmailPassword()` method in `AuthRepositoryImpl` relies on `trySupabase()` for this mapping — verify `trySupabase()` maps `AuthException` to `AuthFailure`; if it maps to `NetworkFailure` instead, explicitly catch `AuthException` before the `trySupabase()` call and return `Left(const AuthFailure('Incorrect email or password'))`.

### Fixed `getCurrentUser()` (DEF1)

```dart
// lib/features/auth/data/auth_repository_impl.dart — REPLACE getCurrentUser() body
@override
Future<Either<Failure, Student?>> getCurrentUser() async {
  final user = _client.auth.currentUser;
  if (user == null) return const Right(null);

  return trySupabase(() async {
    final existing = await _studentDao.getStudent(user.id);
    if (existing == null) return null; // Drift row absent — treat as unauthenticated
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
  });
}
```

### Fixed `signOut()` (DEF2)

```dart
// lib/features/auth/data/auth_repository_impl.dart — REPLACE signOut() body
@override
Future<Either<Failure, void>> signOut() async {
  return trySupabase(() async {
    final userId = _client.auth.currentUser?.id;
    await _client.auth.signOut(); // sign out Supabase first
    if (userId != null) {
      await _studentDao.deleteStudent(userId); // then clear Drift cache
    }
  });
}
```

If `StudentDao.deleteStudent()` does not exist, add to `lib/core/database/daos/student_dao.dart`:
```dart
Future<void> deleteStudent(String id) =>
    (delete(studentsTable)..where((s) => s.id.equals(id))).go();
```

### `AuthState.unauthenticated` — Add `sessionExpired` (Task 4)

```dart
// lib/features/auth/presentation/auth_state.dart — MODIFY unauthenticated factory only
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.unauthenticated({
    @Default(false) bool sessionExpired,
  }) = _Unauthenticated;
  const factory AuthState.authenticated({
    required Student student,
    @Default(false) bool isNewStudent,
  }) = _Authenticated;
}
```

Run `dart run build_runner build --delete-conflicting-outputs` after this change. The existing `AuthState.unauthenticated()` call sites (no args) remain valid because `sessionExpired` defaults to `false`.

### `AuthNotifier` — `build()` + Stream Wiring + `signInWithEmailPassword()` (Task 3)

```dart
// lib/features/auth/presentation/auth_notifier.dart

bool _explicitSignOut = false; // tracks whether signOut() initiated the sign-out

@override
Future<AuthState> build() async {
  // Step 1: Restore session on cold start (DEF3)
  final sessionResult = await ref.read(authRepositoryProvider).getCurrentUser();
  final initialState = sessionResult.fold(
    (_) => const AuthState.unauthenticated(),
    (student) => student != null
        ? AuthState.authenticated(student: student, isNewStudent: false)
        : const AuthState.unauthenticated(),
  );

  // Step 2: Wire authStateStream for runtime session changes (DEF5)
  ref.listen(authStateStreamProvider, (_, next) {
    next.whenData(_handleAuthStateChange);
  });

  return initialState;
}

Future<void> _handleAuthStateChange(supabase.AuthState authEvent) async {
  switch (authEvent.event) {
    case supabase.AuthChangeEvent.signedIn:
    case supabase.AuthChangeEvent.tokenRefreshed:
      // DEF8 mitigation: verify Drift row exists before emitting authenticated
      final result = await ref.read(authRepositoryProvider).getCurrentUser();
      result.fold(
        (_) {}, // failure — stay in current state (auth notifier methods will set error)
        (student) {
          if (student != null) {
            // Only update if currently unauthenticated — don't clobber isNewStudent
            // from registration/Google sign-in flows that already set authenticated
            final currentlyUnauthenticated = state.value?.map(
                  unauthenticated: (_) => true,
                  authenticated: (_) => false,
                ) ??
                true;
            if (currentlyUnauthenticated) {
              state = AsyncValue.data(
                AuthState.authenticated(student: student, isNewStudent: false),
              );
            }
          }
        },
      );
    case supabase.AuthChangeEvent.signedOut:
    case supabase.AuthChangeEvent.userDeleted:
      final wasExplicit = _explicitSignOut;
      _explicitSignOut = false;
      state = AsyncValue.data(
        AuthState.unauthenticated(sessionExpired: !wasExplicit),
      );
    default:
      break;
  }
}

Future<void> signInWithEmailPassword({
  required String email,
  required String password,
}) async {
  if (state.isLoading) return; // concurrency guard
  state = const AsyncValue<AuthState>.loading();
  final result = await ref
      .read(authRepositoryProvider)
      .signInWithEmailPassword(email: email, password: password);
  state = result.fold(
    (failure) => AsyncValue<AuthState>.error(failure, StackTrace.current),
    (student) => AsyncValue.data(
      AuthState.authenticated(student: student, isNewStudent: false),
    ),
  );
}

// UPDATE signOut() to set _explicitSignOut flag BEFORE calling Supabase
Future<void> signOut() async {
  if (state.isLoading) return;
  _explicitSignOut = true; // mark as intentional before stream fires
  state = const AsyncValue<AuthState>.loading();
  final result = await ref.read(authRepositoryProvider).signOut();
  state = result.fold(
    (failure) {
      _explicitSignOut = false; // reset if signOut failed
      return AsyncValue<AuthState>.error(failure, StackTrace.current);
    },
    (_) => const AsyncValue.data(AuthState.unauthenticated()),
  );
}
```

**Import alias required:** `authStateStreamProvider` returns Supabase's `AuthState` type which conflicts with the app's `AuthState`. The existing `auth_provider.dart` already uses a prefixed import — match that pattern:
```dart
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
```

**`build()` returns `Future<AuthState>`:** This is a valid `AsyncNotifier` signature — the framework emits `AsyncLoading` while `build()` is running. Ensure `build()` is annotated with `@override` only; the `@riverpod` annotation is on the class. Run `build_runner` after any change to `build()` signature.

### `LoginScreen` — Full Widget (Task 5)

```dart
// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:studyboard_mobile/features/auth/presentation/widgets/google_sign_in_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailTouched = false;
  bool _passwordTouched = false;

  @override
  void initState() {
    super.initState();
    // Show session-expired message on first frame if applicable (AC: #6)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider).value;
      final isExpired = authState?.map(
            unauthenticated: (s) => s.sessionExpired,
            authenticated: (_) => false,
          ) ??
          false;
      if (isExpired && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your session expired — please log in again'),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthState>>(authProvider, (_, next) {
      next.when(
        data: (authState) => authState.map(
          unauthenticated: (_) {}, // stay on login screen
          authenticated: (_) => context.go('/board'),
        ),
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        loading: () {},
      );
    });

    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Log in')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                onBlur: () => setState(() => _emailTouched = true),
                errorText: _emailTouched && _emailController.text.isEmpty
                    ? 'Email is required'
                    : null,
              ),
              const SizedBox(height: 16),
              AuthFormField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                onBlur: () => setState(() => _passwordTouched = true),
                errorText: _passwordTouched && _passwordController.text.isEmpty
                    ? 'Password is required'
                    : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isLoading ? null : _onLogIn,
                child: const Text('Log in'),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('or'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              const GoogleSignInButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogIn() {
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
    });
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    ref.read(authProvider.notifier).signInWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }
}
```

**Note on `AuthFormField` API:** Verify that `AuthFormField` accepts `onBlur`, `obscureText`, and `errorText` parameters — these were used in `RegisterScreen`. Check `auth_form_field.dart` and adapt parameter names if they differ.

### Router Auth Guard (DEF4) — Task 6

First, locate `goRouterProvider`:
```bash
grep -r "GoRouter\|goRouterProvider" lib/ --include="*.dart" -l
```

Then apply these changes:

```dart
// Wherever GoRouter is constructed — ADD /login route + redirect + refreshListenable

// 1. Add RouterNotifier (check if one already exists before creating):
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

// 2. In goRouterProvider — add to routes list:
GoRoute(
  path: '/login',
  builder: (_, __) => const LoginScreen(),
),

// 3. Add redirect callback (inside GoRouter constructor):
redirect: (BuildContext context, GoRouterState state) {
  final authValue = ref.read(authProvider);
  // While authProvider is loading (session restore in progress), do not redirect
  if (authValue.isLoading) return null;

  final isLoggedIn = authValue.value?.map(
        unauthenticated: (_) => false,
        authenticated: (_) => true,
      ) ??
      false;
  final isGoingToLogin = state.matchedLocation == '/login';

  if (!isLoggedIn && !isGoingToLogin) return '/login';
  if (isLoggedIn && isGoingToLogin) return '/board';
  return null;
},

// 4. Add refreshListenable:
refreshListenable: RouterNotifier(ref),

// 5. Set initial location to '/login' (redirect sends authenticated users to /board):
initialLocation: '/login',
```

**Why `authValue.isLoading` guard:** During cold start, `AuthNotifier.build()` is async (checking session). While it's loading, `redirect` must return `null` to avoid a premature redirect to `/login` before the session check completes. The `RouterNotifier` calls `notifyListeners()` when the loading state resolves, triggering a re-evaluation of `redirect` with the final state.

**If `RouterNotifier` already exists:** extend it to also listen on `authProvider` instead of creating a new class.

### Accumulated Learnings from Stories 1.1–1.7

- **`authProvider`** (not `authNotifierProvider`) — Riverpod 4.x strips `Notifier` suffix from generated provider name
- **`dart run build_runner build --delete-conflicting-outputs`** — run from `studyboard_mobile/` after modifying any `@riverpod` annotation, `@freezed` class, or `build()` signature
- **`very_good_analysis`** — `package:` imports everywhere; no relative imports in `lib/`
- **`sort_constructors_first` lint** — constructors must appear before field declarations
- **Concurrency guard** — `if (state.isLoading) return;` at top of every `AuthNotifier` mutating method; prevents parallel state updates on rapid double-tap
- **`trySupabase()`** — wraps all Supabase + Drift calls in data layer; check whether it maps `AuthException` to `AuthFailure` or `NetworkFailure` — handle accordingly in `signInWithEmailPassword()`
- **Import alias** — `import 'package:supabase_flutter/supabase_flutter.dart' as supabase;` to avoid `AuthState` class name collision
- **`AuthException` constructor** — positional `String message`: `const AuthException('...')`
- **`StudentsTableCompanion.insert()`** — `district` and `school` are required `String` (not nullable); use `''` for empty strings
- **`AsyncNotifier.build()` returning `Future<T>`** — framework emits `AsyncLoading` until the future resolves; `ref.listen` must be set up inside `build()` (not in `initState` equivalent)
- **`state` setter in `AsyncNotifier`** — synchronous; safe to call from async callbacks; the notifier stays alive for its provider's entire lifetime

### Testing Patterns

```dart
// signInWithEmailPassword — success (Drift row exists)
when(() => mockClient.auth.signInWithPassword(email: any(named: 'email'), password: any(named: 'password')))
    .thenAnswer((_) async => AuthResponse(session: mockSession, user: mockUser));
when(() => mockStudentDao.getStudent(any())).thenAnswer((_) async => mockStudentsTableData);
final result = await repo.signInWithEmailPassword(email: 'a@b.com', password: 'pass1234');
expect(result.isRight(), true);
expect(result.getOrElse((_) => throw '').district, isNotEmpty);

// signInWithEmailPassword — wrong credentials → AuthFailure
when(() => mockClient.auth.signInWithPassword(...))
    .thenThrow(const AuthException('Invalid login credentials'));
final result = await repo.signInWithEmailPassword(email: 'a@b.com', password: 'wrong');
expect(result.fold((f) => f, (_) => null), isA<AuthFailure>());

// getCurrentUser() — reads from Drift (DEF1 fix verified)
when(() => mockClient.auth.currentUser).thenReturn(mockUser);
when(() => mockStudentDao.getStudent(any())).thenAnswer((_) async => mockStudentsTableData);
await repo.getCurrentUser();
verify(() => mockStudentDao.getStudent(mockUser.id)).called(1);

// getCurrentUser() — Drift row absent → Right(null)
when(() => mockStudentDao.getStudent(any())).thenAnswer((_) async => null);
final result = await repo.getCurrentUser();
expect(result, const Right(null));

// signOut() — clears Drift (DEF2 fix verified)
when(() => mockStudentDao.deleteStudent(any())).thenAnswer((_) async {});
when(() => mockClient.auth.signOut()).thenAnswer((_) async {});
await repo.signOut();
verify(() => mockStudentDao.deleteStudent(any())).called(1);
```

### Architecture Compliance Checklist

- [ ] `signInWithEmailPassword()` in `auth_repository.dart` (interface) and `auth_repository_impl.dart` (impl)
- [ ] `getCurrentUser()` reads from `_studentDao.getStudent()` first — not from `_client.auth.currentUser` metadata (DEF1)
- [ ] `signOut()` calls `_studentDao.deleteStudent()` after `auth.signOut()` (DEF2)
- [ ] `AuthNotifier.build()` performs session restore via `getCurrentUser()` (DEF3)
- [ ] `authStateStream` wired via `ref.listen` in `build()` (DEF5)
- [ ] Stream `signedIn` handler calls `getCurrentUser()` and only emits `authenticated` when Drift row confirmed (DEF8)
- [ ] Router `redirect` guards all non-`/login` routes; `isLoading` guard prevents premature redirect (DEF4)
- [ ] Supabase "Invalid login credentials" message NEVER surfaces in UI — always mapped to `AuthFailure('Incorrect email or password')`
- [ ] No direct `supabase.from(...)` calls outside `data/` layer
- [ ] `flutter analyze` → 0 issues; `flutter test` → all pass

### Anti-Patterns to Avoid

- ❌ Passing Supabase's raw `AuthException` message to the user — always display "Incorrect email or password" (security: don't reveal which field is wrong)
- ❌ Clearing the form on login failure — preserve email and password so the student can correct and retry (AC: #3 explicitly)
- ❌ Emitting `authenticated` in the stream `signedIn` handler before `getCurrentUser()` confirms the Drift row — this is the DEF8 race condition
- ❌ Using `ref.watch` inside `AsyncNotifier.build()` for the auth stream — use `ref.listen`; `watch` would cause `build()` to re-run on every stream event
- ❌ Routing `LoginScreen`'s `ref.listen` to `/onboarding` — login is only for returning students; `isNewStudent` is always `false` on `signInWithEmailPassword()`
- ❌ Creating a new `GoRouter` instance — locate and modify the existing `goRouterProvider`; do not duplicate
- ❌ Calling `_studentDao.deleteStudent()` before `auth.signOut()` — sign out Supabase first; if signOut fails, Drift row should be retained
- ❌ Redirecting to `/login` while `authProvider.isLoading` — causes flash of login screen during session restore; guard with `if (authValue.isLoading) return null`

### Project Structure Notes

**Files to MODIFY:**
```
lib/features/auth/domain/auth_repository.dart          # Add signInWithEmailPassword()
lib/features/auth/data/auth_repository_impl.dart       # Implement + fix getCurrentUser() + signOut()
lib/features/auth/presentation/auth_notifier.dart      # Add signInWithEmailPassword(), fix build(), add signOut() flag
lib/features/auth/presentation/auth_state.dart         # Add sessionExpired to unauthenticated()
lib/core/routing/app_router.dart (or equivalent)       # Add /login route + redirect + refreshListenable
lib/core/database/daos/student_dao.dart                # Add deleteStudent() if absent
```

**Files to CREATE:**
```
lib/features/auth/presentation/login_screen.dart       # New login screen
```

**Generated after build_runner (required — both auth_state and auth_notifier change):**
```
lib/features/auth/presentation/auth_state.freezed.dart  # regenerated (unauthenticated factory changed)
lib/features/auth/presentation/auth_notifier.g.dart     # regenerated (build() signature changed)
```

**Files NOT to modify:**
- `lib/features/auth/domain/student.dart` — complete as-is
- `lib/features/auth/data/models/student_dto.dart` — complete as-is
- `lib/features/auth/data/auth_provider.dart` — no changes needed (GoogleSignIn injection from Story 1.7 unchanged)
- `lib/features/auth/presentation/widgets/google_sign_in_button.dart` — reuse as-is
- `lib/features/auth/presentation/widgets/auth_form_field.dart` — reuse as-is
- `lib/features/auth/presentation/register_screen.dart` — unchanged
- `lib/core/supabase/repository_base.dart` — unchanged

**Test files to UPDATE:**
```
test/features/auth/data/auth_repository_impl_test.dart  # 5 new test cases
test/features/auth/presentation/auth_notifier_test.dart  # 4 new test cases
```

### References

- [Source: epics.md#Story 1.8] — Acceptance criteria, session expiry routing, NFR1 cold start ≤ 3s
- [Source: epics.md#Additional Requirements] — NFR8 (HTTPS/TLS), NFR11 (no Google credentials stored)
- [Source: deferred-work.md#1-6-student-registration-emailpassword round 2] — DEF1–DEF8 full definitions
- [Source: architecture.md#Authentication & Security] — supabase_flutter session persistence, transparent JWT refresh
- [Source: architecture.md#Flutter Architecture] — go_router `redirect`, shell route structure, `authStateStreamProvider`
- [Source: architecture.md#Communication Patterns] — Riverpod `AsyncNotifier` conventions, no thrown exceptions, `Either<Failure, T>`
- [Source: 1-7-google-sign-in-and-account-linking.md#Dev Notes] — `authProvider` name, concurrency guard, `trySupabase()`, import alias, `AuthException` constructor, `StudentsTableCompanion.insert()` required fields

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
