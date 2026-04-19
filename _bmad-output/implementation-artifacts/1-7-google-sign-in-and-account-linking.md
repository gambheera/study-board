# Story 1.7: Google Sign-In & Account Linking

Status: review

## Story

As a student,
I want to register or sign in using my Google account,
so that I can access StudyBoard without managing a separate password.

## Acceptance Criteria

1. **Given** the registration screen **When** a student taps "Continue with Google" **Then** the native Google Sign-In flow launches via the `google_sign_in` SDK and the student sees their Google account selection screen

2. **Given** the student selects a Google account and grants consent **When** the OAuth token is received **Then** Supabase Auth creates or retrieves the student session using the Google OAuth token, and no Google credentials are stored by the app — only the OAuth session token is handled

3. **Given** a new student completing Google Sign-In for the first time **When** OAuth completes successfully **Then** a `students` record is created in Drift with `student_id = auth.uid()` and the student is routed to the onboarding flow (Story 1.9 placeholder)

4. **Given** a returning student using Google Sign-In **When** OAuth completes **Then** the student is routed directly to the Board (`/board`) — the onboarding flow is not shown again (determined by non-empty `district` in Drift)

5. **Given** the Android OAuth is configured in Google Cloud Console and `google-services.json` **When** the OAuth callback fires after Google consent **Then** the app intercepts the redirect correctly and the sign-in completes without an "invalid redirect URI" error

6. **Given** the student's Google OAuth token expires **When** the token needs refresh **Then** `google_sign_in` handles refresh transparently without prompting the student to re-authenticate

## Tasks / Subtasks

- [x] Task 1: Modify `AuthState` — add `isNewStudent` field (AC: #3, #4)
  - [x] Open `lib/features/auth/presentation/auth_state.dart`
  - [x] Add `@Default(false) bool isNewStudent` to `AuthState.authenticated` factory
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` to regenerate `auth_state.freezed.dart`

- [x] Task 2: Add `signInWithGoogle()` to `AuthRepository` interface (AC: #1, #2, #3, #4, #5, #6)
  - [x] Open `lib/features/auth/domain/auth_repository.dart`
  - [x] Add method: `Future<Either<Failure, ({Student student, bool isNewStudent})>> signInWithGoogle();`

- [x] Task 3: Implement `signInWithGoogle()` in `AuthRepositoryImpl` + update constructor (AC: #1, #2, #3, #4, #5, #6)
  - [x] Open `lib/features/auth/data/auth_repository_impl.dart`
  - [x] Add `GoogleSignInService _googleSignIn` as 3rd constructor parameter (adapted for google_sign_in v7 singleton API)
  - [x] Add import: `package:google_sign_in/google_sign_in.dart`
  - [x] Implement `signInWithGoogle()` — adapted for v7 API (authenticate() + sync authentication getter)
  - [x] Open `lib/features/auth/data/auth_provider.dart`
  - [x] Add `package:studyboard_mobile/core/auth/google_sign_in_service.dart` import
  - [x] Pass `const GoogleSignInServiceImpl()` as 3rd arg to `AuthRepositoryImpl`
  - [x] Create `lib/core/config/app_config.dart`
  - [x] Create `lib/core/auth/google_sign_in_service.dart` (v7 wrapper interface for testability)
  - [x] Add `GoogleSignIn.instance.initialize(serverClientId: AppConfig.googleWebClientId)` to `lib/bootstrap.dart`

- [x] Task 4: Update `AuthNotifier` — add `signInWithGoogle()`, fix `signUpWithEmail()` for `isNewStudent` (AC: #3, #4)
  - [x] Open `lib/features/auth/presentation/auth_notifier.dart`
  - [x] Update `signUpWithEmail()` state fold to set `isNewStudent: true`
  - [x] Add `signInWithGoogle()` method
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` after any annotation changes

- [x] Task 5: Create `GoogleSignInButton` widget (AC: #1)
  - [x] Create `lib/features/auth/presentation/widgets/google_sign_in_button.dart`

- [x] Task 6: Update `RegisterScreen` — add `GoogleSignInButton`, update routing (AC: #1, #3, #4)
  - [x] Open `lib/features/auth/presentation/register_screen.dart`
  - [x] Update `ref.listen` routing to use `isNewStudent` flag
  - [x] Add `GoogleSignInButton` below the "Create account" button with an "or" divider

- [x] Task 7: Android OAuth prerequisites (AC: #5)
  - [x] Verify `google-services.json` includes Web OAuth client (not only Android client) — see Dev Notes
  - [x] Set `AppConfig.googleWebClientId` to the Web application OAuth client ID
  - [x] Enable Google provider in Supabase Dashboard → Authentication → Providers → Google

- [x] Task 8: Tests (AC: #1, #2, #3, #4, #6)
  - [x] Update `test/features/auth/data/auth_repository_impl_test.dart` — add `GoogleSignInService` mock, 4 new test cases for `signInWithGoogle()`
  - [x] Update `test/features/auth/presentation/auth_notifier_test.dart` — 2 new test cases for `signInWithGoogle()`
  - [x] Run `flutter test` → all pass; `flutter analyze` → 0 issues

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/features/auth/domain/auth_repository.dart` — `AuthRepository` interface; ADD `signInWithGoogle()`, do NOT replace existing methods
- `lib/features/auth/data/auth_repository_impl.dart` — `AuthRepositoryImpl` already has `signUpWithEmail()`, `getCurrentUser()`, `signOut()`, `getSessionStream()`; ADD `signInWithGoogle()` and update constructor
- `lib/features/auth/presentation/auth_state.dart` — `AuthState` exists with `unauthenticated()` and `authenticated({required Student student})`; MODIFY to add `isNewStudent` field
- `lib/features/auth/presentation/auth_notifier.dart` — `AuthNotifier` exists with `signUpWithEmail()`; ADD `signInWithGoogle()`, update `signUpWithEmail()` fold only
- `lib/features/auth/presentation/widgets/auth_form_field.dart` — `AuthFormField` already exists; do NOT modify
- `lib/core/database/daos/student_dao.dart` — `StudentDao.getStudent(String studentId)` already exists and returns `StudentsTableData?`; use it as-is to detect new vs. returning student
- `lib/features/auth/data/auth_provider.dart` — ADD `GoogleSignIn` injection; keep `studentDaoProvider` injection as-is
- `lib/features/auth/data/models/student_dto.dart` — `StudentDto.fromJson()` and `.toStudent()` already defined; use as-is
- `google_sign_in: ^7.2.0` is already declared in `pubspec.yaml` — do NOT add it again

### `AppConfig` — Create This File First

```dart
// lib/core/config/app_config.dart
abstract final class AppConfig {
  // TODO(Story 1.7): Replace with your Web application OAuth 2.0 client ID from
  // Google Cloud Console → Credentials → OAuth 2.0 Client IDs → Web application.
  // This is NOT the Android client ID — it must be the Web client to obtain idToken.
  // Required by Supabase's signInWithIdToken(provider: OAuthProvider.google, ...).
  static const String googleWebClientId =
      'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
}
```

### `AuthState` Modification

```dart
// lib/features/auth/presentation/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated({
    required Student student,
    @Default(false) bool isNewStudent,
  }) = _Authenticated;
}
```

`isNewStudent` defaults to `false` — backward-compatible with existing `RegisterScreen` if it doesn't pass the flag. After Task 1, run `build_runner` immediately before touching anything else.

### `AuthRepository` Interface Addition

```dart
// lib/features/auth/domain/auth_repository.dart — ADD this method
/// Signs in with Google OAuth, returning the student and whether onboarding is required.
/// [isNewStudent] is true when no Drift record exists OR district is empty (onboarding not completed).
Future<Either<Failure, ({Student student, bool isNewStudent})>> signInWithGoogle();
```

### `signInWithGoogle()` Full Implementation

```dart
// lib/features/auth/data/auth_repository_impl.dart

// Updated constructor (3 params):
AuthRepositoryImpl(this._client, this._studentDao, this._googleSignIn);
final SupabaseClient _client;
final StudentDao _studentDao;
final GoogleSignIn _googleSignIn;

@override
Future<Either<Failure, ({Student student, bool isNewStudent})>>
    signInWithGoogle() async {
  // Step 1: Native Google Sign-In — opens account picker
  GoogleSignInAccount? googleUser;
  try {
    googleUser = await _googleSignIn.signIn();
  } on Object {
    return const Left(AuthFailure('Google Sign-In failed. Please try again.'));
  }

  if (googleUser == null) {
    // User dismissed the account picker
    return const Left(AuthFailure('Google Sign-In was cancelled.'));
  }

  // Step 2: Get Google auth tokens (required for Supabase token exchange)
  GoogleSignInAuthentication googleAuth;
  try {
    googleAuth = await googleUser.authentication;
  } on Object {
    return const Left(
      AuthFailure('Failed to get Google credentials. Please try again.'),
    );
  }

  final idToken = googleAuth.idToken;
  if (idToken == null) {
    // serverClientId not set correctly — idToken is null when serverClientId missing
    return const Left(
      AuthFailure(
        'Google authentication failed. Please check app configuration.',
      ),
    );
  }

  // Step 3: Exchange Google token for Supabase session
  return trySupabase(() async {
    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken, // optional but recommended for Supabase
    );

    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('Sign-in failed: no user after token exchange');
    }

    final now = DateTime.now().toUtc().toIso8601String();

    // Step 4: Detect new vs. returning student
    // New = no Drift record OR district is empty (onboarding not completed)
    final existing = await _studentDao.getStudent(user.id);
    final isNewStudent = existing == null || existing.district.isEmpty;

    if (isNewStudent) {
      // Create or refresh Drift record for new/un-onboarded student.
      // Supabase on_auth_user_created trigger handles public.students row for brand-new auth users.
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
      // Returning onboarded student — refresh lastActiveAt only
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
```

**Key design decisions:**
- `google_sign_in` → `signIn()` returns `null` on user cancellation — map to `Left(AuthFailure('cancelled'))`
- `idToken == null` happens when `serverClientId` is not set on `GoogleSignIn()` — surface a configuration error, not a silent failure
- `OAuthProvider.google` is from `package:supabase_flutter/supabase_flutter.dart` — no additional import needed (already imported as `package:supabase_flutter/supabase_flutter.dart`)
- Supabase `signInWithIdToken` handles both new and returning Google users — no separate "link" step needed for V1
- `isNewStudent` flag drives routing in `AuthNotifier` and ultimately in `RegisterScreen`'s `ref.listen`
- Token refresh (NFR19, AC6): `google_sign_in` internally refreshes Google tokens on subsequent calls to `.authentication`; `supabase_flutter` handles its own JWT refresh. No additional refresh logic needed in `signInWithGoogle()`

### `auth_provider.dart` — Updated `authRepository` Provider

```dart
// lib/features/auth/data/auth_provider.dart
import 'package:google_sign_in/google_sign_in.dart';                      // ADD
import 'package:studyboard_mobile/core/config/app_config.dart';           // ADD
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    GoogleSignIn(serverClientId: AppConfig.googleWebClientId),  // ADD
  );
}

// authStateStream provider stays unchanged
```

### `AuthNotifier` — Updated Methods

```dart
// lib/features/auth/presentation/auth_notifier.dart

// UPDATE signUpWithEmail() fold — set isNewStudent: true for registration
state = result.fold(
  (failure) => AsyncValue<AuthState>.error(failure, StackTrace.current),
  (student) => AsyncValue.data(
    AuthState.authenticated(student: student, isNewStudent: true),  // email reg = always new
  ),
);

// ADD signInWithGoogle() method
Future<void> signInWithGoogle() async {
  if (state.isLoading) return; // concurrency guard — same pattern as signUpWithEmail
  state = const AsyncValue<AuthState>.loading();
  final result = await ref.read(authRepositoryProvider).signInWithGoogle();
  state = result.fold(
    (failure) => AsyncValue<AuthState>.error(failure, StackTrace.current),
    (r) => AsyncValue.data(
      AuthState.authenticated(student: r.student, isNewStudent: r.isNewStudent),
    ),
  );
}
```

### `GoogleSignInButton` Widget

```dart
// lib/features/auth/presentation/widgets/google_sign_in_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider).isLoading;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading
            ? null
            : () => ref.read(authProvider.notifier).signInWithGoogle(),
        child: const Text('Continue with Google'),
      ),
    );
  }
}
```

**Note:** No Google logo asset is required for V1. The text label is sufficient for 10 known students. Add a Google logo image asset in a post-MVP polish pass if needed.

### `RegisterScreen` — Changes Required

Two changes only — do NOT touch the rest of `register_screen.dart`:

**Change 1: Update `ref.listen` routing to use `isNewStudent`**

Find:
```dart
authenticated: (_) => context.go('/onboarding'),
```

Replace with:
```dart
authenticated: (student, isNewStudent) =>
    context.go(isNewStudent ? '/onboarding' : '/board'),
```

**Change 2: Add `GoogleSignInButton` below the "Create account" `FilledButton`**

After the existing `FilledButton('Create account', ...)`, add:
```dart
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
```

Add import at the top of `register_screen.dart`:
```dart
import 'package:studyboard_mobile/features/auth/presentation/widgets/google_sign_in_button.dart';
```

### Android OAuth Prerequisites (Developer Must Do Manually)

These are one-time setup steps, not code changes:

1. **Google Cloud Console** → APIs & Services → Credentials:
   - Verify an Android OAuth 2.0 client exists for `com.lahiru.studyboard` with the debug SHA-1 fingerprint
   - Get (or create) a **Web application** OAuth 2.0 client — copy its Client ID
   - Set `AppConfig.googleWebClientId` to this web client ID (format: `xxxx.apps.googleusercontent.com`)

2. **Supabase Dashboard** → Authentication → Providers → Google:
   - Enable Google provider
   - Paste the Web application Client ID and Client Secret from step 1
   - The redirect URL shown in Supabase must be added to the Web OAuth client's "Authorized redirect URIs" in Google Cloud Console

3. **`google-services.json`** (already in `android/app/`) must include the OAuth client section for `google_sign_in` to work. When you add an Android app in the Firebase Console, it creates an Android OAuth client automatically. Open `google-services.json` and verify it has a `"client_type": 1` entry (Android client) — this enables native Sign-In.

4. **Obtain debug SHA-1** with: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`

> **V1 note**: The `on_auth_user_created` Postgres trigger fires for brand-new Google auth users (same as email registration). Trigger timing (DEF6 from Story 1.6) is the same known-accepted risk. The `upsertStudent()` call writes to Drift regardless — if the trigger is slow, Drift is the source of truth.

### `StudentDao` — No Changes Needed

`StudentDao.getStudent(String studentId)` already exists (line 17 of `student_dao.dart`) and returns `StudentsTableData?`. No modifications required.

`StudentsTableData` fields available: `id`, `name`, `email`, `district`, `school`, `lastActiveAt`, `createdAt`, `notificationsEnabled`, `fcmToken`, `deactivatedAt`, `deletedAt`.

### Testing Patterns

```dart
// Mocking GoogleSignIn in tests:
class _MockGoogleSignIn extends Mock implements GoogleSignIn {}
class _MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class _MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

// Auth repository test setup:
final mockGoogleSignIn = _MockGoogleSignIn();
final repo = AuthRepositoryImpl(mockClient, mockStudentDao, mockGoogleSignIn);

// Test cases to cover:
// 1. signInWithGoogle() — success, new student (getStudent returns null)
// 2. signInWithGoogle() — success, returning student (getStudent returns row with district set)
// 3. signInWithGoogle() — user cancels (signIn() returns null) → Left(AuthFailure)
// 4. signInWithGoogle() — network failure (signInWithIdToken throws) → Left(NetworkFailure)

// AuthNotifier tests:
// 5. signInWithGoogle() — success, isNewStudent: true → AuthState.authenticated with isNewStudent: true
// 6. signInWithGoogle() — success, isNewStudent: false → AuthState.authenticated with isNewStudent: false
```

### Accumulated Story Learnings (1.1–1.6, relevant to 1.7)

- **`dart run build_runner build --delete-conflicting-outputs`** from `studyboard_mobile/` — required after modifying `@freezed` class (`AuthState`)
- **Riverpod 4.x generated provider**: `authProvider` (not `authNotifierProvider`) — the `Notifier` suffix is stripped
- **`very_good_analysis`**: `package:` imports required everywhere; no relative imports in `lib/`
- **`sort_constructors_first` lint**: constructors before field declarations
- **Concurrency guard**: `if (state.isLoading) return;` at the top of every `AuthNotifier` method — prevents parallel state updates on rapid double-tap
- **`trySupabase()` wraps**: only Supabase/Drift calls after auth succeeds; errors that occur before (like cancellation) are caught explicitly
- **`OAuthProvider.google`**: imported from `package:supabase_flutter/supabase_flutter.dart` — no separate `supabase` package import
- **`AuthException` constructor**: takes a positional `String message` — use `const AuthException('...')` 
- **`StudentsTableCompanion.insert()`**: `district` and `school` are required `String` fields (not nullable); use `''` for empty

### Architecture Compliance Checklist

- [ ] `signInWithGoogle()` is in `auth_repository.dart` (domain interface) and `auth_repository_impl.dart` (data impl)
- [ ] `GoogleSignIn` instance injected via `authRepositoryProvider` — never constructed inside a Notifier or Screen
- [ ] `isNewStudent` detection uses `StudentDao.getStudent()` from `data/` layer only — not in Notifier or Screen
- [ ] No `supabase.from('students')` call in `signInWithGoogle()` — Drift write only; trigger handles Supabase row for new users
- [ ] `GoogleSignInButton` triggers `authProvider.notifier.signInWithGoogle()` — no direct Supabase/GoogleSignIn calls in widget
- [ ] `AuthState.authenticated(isNewStudent: true/false)` drives all routing — never hardcoded path strings in the notifier
- [ ] `flutter analyze` → 0 issues; `flutter test` → all pass

### Anti-Patterns to Avoid

- ❌ Calling `GoogleSignIn()` directly inside `AuthNotifier.signInWithGoogle()` — it must be injected through the repository
- ❌ Calling `_client.auth.signInWithIdToken()` without first getting `idToken` from `googleUser.authentication` — `accessToken` alone is insufficient
- ❌ Using `serverClientId` set to the Android client ID — it must be the **Web application** client ID to receive an `idToken`
- ❌ Checking `isNewStudent` based on `response.user.createdAt` — Supabase returns the same user for returning Google users; check Drift record instead
- ❌ Calling `_studentDao.upsertStudent()` for returning students with `district.isNotEmpty` — `updateLastActiveAt()` is sufficient
- ❌ Adding a `signInWithGoogle()` route — the Google Sign-In button lives on `RegisterScreen` for Story 1.7; `LoginScreen` (Story 1.8) will reuse `GoogleSignInButton`
- ❌ Routing to `/board` vs `/dashboard` inconsistency — use `/board` for returning students; Story 1.8 adds auth-aware redirect

### Project Structure Notes

**Files to MODIFY:**
```
lib/features/auth/domain/auth_repository.dart          # Add signInWithGoogle() method
lib/features/auth/data/auth_repository_impl.dart       # Implement + add GoogleSignIn param
lib/features/auth/data/auth_provider.dart              # Inject GoogleSignIn
lib/features/auth/presentation/auth_state.dart         # Add isNewStudent to authenticated
lib/features/auth/presentation/auth_notifier.dart      # Add signInWithGoogle(), update signUpWithEmail()
lib/features/auth/presentation/register_screen.dart    # Add GoogleSignInButton, update routing
```

**Files to CREATE:**
```
lib/core/config/app_config.dart                                # googleWebClientId constant
lib/features/auth/presentation/widgets/google_sign_in_button.dart  # new widget
```

**Generated after build_runner:**
```
lib/features/auth/presentation/auth_state.freezed.dart  # regenerated (AuthState changed)
lib/features/auth/data/auth_provider.g.dart             # regenerated if provider sig changes
```

**Test files to UPDATE:**
```
test/features/auth/data/auth_repository_impl_test.dart   # Add MockGoogleSignIn + 4 tests
test/features/auth/presentation/auth_notifier_test.dart  # Add 2 tests
```

**Files NOT to modify:**
- `lib/features/auth/domain/student.dart` — complete as-is
- `lib/features/auth/data/models/student_dto.dart` — complete as-is
- `lib/core/database/daos/student_dao.dart` — `getStudent()` already exists
- `lib/core/supabase/repository_base.dart` — `trySupabase()` unchanged
- `lib/features/auth/presentation/widgets/auth_form_field.dart` — unchanged

### References

- [Source: epics.md#Story 1.7] — Acceptance criteria, new vs. returning routing, deep-link requirement
- [Source: epics.md#Additional Requirements] — NFR11 (Google OAuth 2.0, no credentials stored), NFR19 (transparent token refresh)
- [Source: architecture.md#Authentication & Security] — `google_sign_in` SDK, OAuth token → Supabase flow
- [Source: architecture.md#Flutter Architecture] — `google_sign_in_button.dart` location, `auth_repository_impl.dart` as only Google auth integration file
- [Source: architecture.md#Key Packages] — `google_sign_in: ^latest` in pubspec
- [Source: deferred-work.md#1-1] — `google_sign_in: ^7.2.0` declared but unused; Story 1.7 activates it
- [Source: 1-6-student-registration-emailpassword.md#Dev Notes] — `signUpWithEmail()` pattern, `trySupabase()` usage, trigger timing, `StudentDto.fromJson()` usage, `AuthNotifier` concurrency guard, Riverpod 4.x generated provider name

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- google_sign_in v7 breaking API change: `GoogleSignIn` is now a singleton (`GoogleSignIn.instance`), constructor is private. `signIn()` replaced by `authenticate()` which throws `GoogleSignInException` instead of returning null on cancel. `authentication` is now a sync getter (not Future). `GoogleSignInAuthentication` no longer has `accessToken` — only `idToken`. Adapted implementation with a `GoogleSignInService` interface wrapper for testability.
- `GoogleSignIn.instance.initialize(serverClientId: ...)` must be called at app startup; added to `bootstrap.dart` after Supabase init.
- Mocktail "cannot call when within a stub response": `_mockUser()` (which calls `when()`) must not be called inside `thenAnswer` callbacks or as arguments after a `when()` call has started recording. Fixed by pre-creating mock users before any `when()` calls in each test.

### Completion Notes List

- Implemented `signInWithGoogle()` adapted for google_sign_in v7 API (singleton, `authenticate()`, sync `authentication` getter, no `accessToken`).
- Created `lib/core/auth/google_sign_in_service.dart` — thin interface wrapping `GoogleSignIn.instance.authenticate()` for dependency injection and testability via mocktail.
- Created `lib/core/config/app_config.dart` — `googleWebClientId` placeholder; developer must replace with actual Web OAuth 2.0 client ID.
- Added `GoogleSignIn.instance.initialize(serverClientId: AppConfig.googleWebClientId)` to `bootstrap.dart`.
- Task 7 (Android OAuth prerequisites) requires manual developer steps: configure Google Cloud Console, set real `googleWebClientId` in `AppConfig`, enable Google provider in Supabase Dashboard.
- All 74 tests pass; `flutter analyze` → 0 issues.

### File List

lib/core/auth/google_sign_in_service.dart (created)
lib/core/config/app_config.dart (created)
lib/bootstrap.dart (modified)
lib/features/auth/domain/auth_repository.dart (modified)
lib/features/auth/data/auth_repository_impl.dart (modified)
lib/features/auth/data/auth_provider.dart (modified)
lib/features/auth/presentation/auth_state.dart (modified)
lib/features/auth/presentation/auth_state.freezed.dart (regenerated)
lib/features/auth/presentation/auth_notifier.dart (modified)
lib/features/auth/presentation/widgets/google_sign_in_button.dart (created)
lib/features/auth/presentation/register_screen.dart (modified)
test/features/auth/data/auth_repository_impl_test.dart (modified)
test/features/auth/presentation/auth_notifier_test.dart (modified)

## Change Log

- Implemented Story 1.7 Google Sign-In & Account Linking — adapted for google_sign_in v7 singleton API; added GoogleSignInService interface, AppConfig, bootstrap initialization, AuthState.isNewStudent, GoogleSignInButton widget, routing fix in RegisterScreen, 6 new tests (Date: 2026-04-19)

### Review Findings

- [ ] [Review][Decision] `google-services.json` is from wrong Firebase project ("nursing-log-app") with no Android OAuth client (`client_type: 1`) — blocks native Google Sign-In on Android (AC5). Only a web client (`client_type: 3`) and an iOS client are present. Fix: run `flutterfire configure` for the StudyBoard Firebase project to regenerate this file with the correct project and Android SHA-1 entry. [android/app/google-services.json]
- [ ] [Review][Patch] Add startup assertion for placeholder `googleWebClientId` to fail fast in debug builds [lib/core/config/app_config.dart]
- [ ] [Review][Patch] Wrap `googleUser.authentication.idToken` access in try/catch — it is a synchronous getter that can throw a `PlatformException` (e.g. revoked token), currently called outside any guard [lib/features/auth/data/auth_repository_impl.dart:148]
- [ ] [Review][Patch] `notificationsEnabled: const Value(true)` in `upsertStudent` hardcodes `true`, silently overwriting existing preference for partial-record students (`existing != null && district.isEmpty`). Use `existing?.notificationsEnabled ?? true` [lib/features/auth/data/auth_repository_impl.dart:183]
- [ ] [Review][Patch] Drift write failure after successful Supabase sign-in leaves user with a live remote session but no local row. Separate `upsertStudent`/`updateLastActiveAt` DAO calls into their own try/catch (returning `DatabaseFailure`) outside `trySupabase`, matching the pattern used in `signUpWithEmail` [lib/features/auth/data/auth_repository_impl.dart:157]
- [ ] [Review][Patch] User cancellation (`AuthFailure('Google Sign-In was cancelled.')`) surfaces as a visible error banner on `RegisterScreen` via `ref.listen`. Filter in the error branch: treat cancellation message as a no-op instead of showing it to the user [lib/features/auth/presentation/register_screen.dart:125]
- [ ] [Review][Patch] Remove unused `import 'dart:io'` — breaks Web/WASM targets and is dead code [lib/features/auth/data/auth_repository_impl.dart:1]
- [ ] [Review][Patch] Add test case: `getStudent()` returns a row with `district: ''` → `isNewStudent: true`, `upsertStudent()` called, student routed to onboarding. The current test only covers `getStudent()` returning `null` [test/features/auth/data/auth_repository_impl_test.dart]
- [ ] [Review][Patch] `GoogleSignInButton` disables on load but shows no spinner — inconsistent with the `FilledButton` on the same screen which shows a `CircularProgressIndicator`. Add visual loading feedback [lib/features/auth/presentation/widgets/google_sign_in_button.dart]
- [ ] [Review][Patch] `_errorMessage` is not cleared when a new Google sign-in attempt begins — stale error from a prior failed attempt stays visible during the loading phase. Clear `_errorMessage` in the `AsyncLoading` branch of `ref.listen` (or call `setState` in the button's `onPressed`) [lib/features/auth/presentation/register_screen.dart]
- [ ] [Review][Patch] Add test case: when `googleUser.authentication.idToken` is `null`, `signInWithGoogle()` returns `Left(AuthFailure('Google authentication failed...'))` [test/features/auth/data/auth_repository_impl_test.dart]
- [x] [Review][Defer] Race condition on rapid double-tap: second tap can call `authenticate()` before `isLoading` state propagates to the button — guard exists in notifier but UI rebuild lags one microtask [lib/features/auth/presentation/auth_notifier.dart:36] — deferred, pre-existing pattern across all notifier methods
- [x] [Review][Defer] `AuthNotifier.build()` always returns `unauthenticated()` — no session restore on cold start — deferred, pre-existing (Story 1.8 scope, tracked as DEF3)
- [x] [Review][Defer] `authStateStreamProvider` uses `ref.watch` on a `keepAlive` repository — safe in practice but could re-subscribe on provider rebuild; prefer `ref.read` inside stream provider [lib/features/auth/data/auth_provider.dart:23] — deferred, pre-existing
- [x] [Review][Defer] `updateLastActiveAt` return value (rowcount) discarded — silent no-op if row was deleted between `getStudent()` and the update call (TOCTOU) [lib/features/auth/data/auth_repository_impl.dart:203] — deferred, low-severity
- [x] [Review][Defer] `googleUser.displayName ?? googleUser.email` fallback — enterprise/SSO accounts can have empty display name AND empty email, producing a Drift row with `name: ''` [lib/features/auth/data/auth_repository_impl.dart:175] — deferred, extremely unlikely with 10 known students
- [x] [Review][Defer] On iOS, OS-terminated `SFSafariViewController` throws a non-`GoogleSignInException` that is caught by `on Object` and shown as a generic error instead of a no-op [lib/features/auth/data/auth_repository_impl.dart:141] — deferred, iOS-specific edge case
