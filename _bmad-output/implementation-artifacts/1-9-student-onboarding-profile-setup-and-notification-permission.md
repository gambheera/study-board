# Story 1.9: Student Onboarding, Profile Setup & Notification Permission

Status: done

## Story

As a student,
I want to complete a brief setup after registering — entering my district, school, and subjects — and be asked about notifications,
So that my board is tailored to my subjects and I can receive study reminders if I choose.

## Acceptance Criteria

1. **Given** a student who has just registered (via email or Google Sign-In for the first time) **When** account creation completes **Then** the onboarding flow is presented before the Dashboard Home and cannot be bypassed

2. **Given** the district field in the onboarding form **When** the student taps the district selector **Then** a `DropdownButtonFormField` displays all Sri Lankan districts as selectable options

3. **Given** the school field **When** a student types at least 2 characters **Then** typeahead autocomplete suggestions appear; the student may select a suggestion or type a custom school name freely — the field is not locked to a predefined list

4. **Given** the subject selection checklist (Chemistry, Physics, Combined Maths) **When** no subject is selected **Then** the "Get started" `FilledButton` is disabled; once at least one subject is selected AND district is selected AND school is non-empty, the button becomes enabled

5. **Given** the device is running Android 13+ (API 33+) **When** the student taps "Get started" and profile is saved **Then** the `POST_NOTIFICATIONS` runtime permission dialog is presented; on Android 12 and below, this step is silently skipped (Firebase Messaging returns `authorized` without a dialog)

6. **Given** the student denies notification permission **When** the onboarding continues **Then** `notifications_enabled = false` is stored in Drift, the FCM token in Drift/Supabase remains null, and the student is routed to the Dashboard Home with full app functionality

7. **Given** the student grants notification permission **When** the onboarding continues **Then** `notifications_enabled = true` is stored in Drift and the FCM token captured in Story 1.5 is saved to `students.fcm_token` in Drift and queued for Supabase sync

8. **Given** the student completes all onboarding steps and taps "Get started" **When** the form is submitted **Then** their district, school, and subject selections are saved to Drift (and queued for Supabase sync), and they are routed to the Dashboard Home

## Tasks / Subtasks

- [x] Task 1: Add `StudentSubjectsTable` to Drift schema — schema migration v1 → v2 (AC: #8)
  - [x] Create `lib/core/database/tables/student_subjects_table.dart` — table with `studentId` + `subjectName` composite PK
  - [x] Add `StudentSubjectsTable` to `AppDatabase` tables list and bump `schemaVersion` to 2
  - [x] Implement `onUpgrade` migration: `if (from < 2) await m.createTable(studentSubjectsTable)`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/`

- [x] Task 2: Add `StudentDao` methods for profile update and subject enrollment (AC: #8)
  - [x] Add `StudentSubjectsTable` to `@DriftAccessor` decorator in `student_dao.dart`
  - [x] Implement `updateProfileFields(studentId, {district, school})` — Drift transaction: update `studentsTable` + enqueue sync queue entry
  - [x] Implement `setEnrolledSubjects(studentId, subjectNames)` — Drift transaction: delete existing student_subjects rows for student + insert new rows
  - [x] Implement `getEnrolledSubjectNames(studentId)` — returns `List<String>` of enrolled subject names
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` after modifying the accessor

- [x] Task 3: Add `updateProfile()` and `updateFcmToken()` to `AuthRepository` interface + implement in `AuthRepositoryImpl` (AC: #7, #8)
  - [x] Open `lib/features/auth/domain/auth_repository.dart`; add `updateProfile()` and `updateFcmToken()` method signatures
  - [x] Open `lib/features/auth/data/auth_repository_impl.dart`; implement `updateProfile()` — calls `_studentDao.updateProfileFields()` + `_studentDao.setEnrolledSubjects()` + returns updated `Student` from Drift
  - [x] Implement `updateFcmToken()` — calls `_studentDao.updateFcmToken()` (already exists); returns `Either<Failure, Unit>`

- [x] Task 4: Add `completeOnboarding()` and `setFcmPermission()` to `AuthNotifier` (AC: #1, #6, #7, #8)
  - [x] Open `lib/features/auth/presentation/auth_notifier.dart`
  - [x] Implement `completeOnboarding({district, school, selectedSubjects})` — reads student from current state, calls `authRepositoryProvider.updateProfile()`, updates state with returned `Student` (district now non-empty → router redirect triggers `/board` navigation)
  - [x] Implement `setFcmPermission({granted, fcmToken})` — calls `authRepositoryProvider.updateFcmToken()`, updates in-memory `AuthState` with `notificationsEnabled` and `fcmToken` values
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` (notifier change requires regeneration)

- [x] Task 5: Add `requestPermission()` to `NotificationService` (AC: #5, #6, #7)
  - [x] Open `lib/features/notifications/data/notification_service.dart`
  - [x] Add `requestPermission()` — calls `_fcm.requestPermission()`, logs non-fatal failures to Crashlytics, returns `AuthorizationStatus`

- [x] Task 6: Update `goRouterProvider` redirect for onboarding routing (AC: #1)
  - [x] Open `lib/router.dart`
  - [x] Update `redirect` callback: if `isLoggedIn && student.district.isEmpty && !isGoingToOnboarding → '/onboarding'`; if `isLoggedIn && student.district.isNotEmpty && isGoingToOnboarding → '/board'`
  - [x] Replace `_OnboardingPlaceholder` usage with `OnboardingScreen` import
  - [x] Guard `/register` route: keep the existing `isGoingToRegister` logic intact

- [x] Task 7: Create `OnboardingScreen` widget (AC: #1, #2, #3, #4, #5, #6, #7, #8)
  - [x] Create `lib/features/auth/presentation/onboarding_screen.dart`
  - [x] District `DropdownButtonFormField` — all 25 Sri Lankan districts (hardcoded constant list); error on blur if none selected
  - [x] School `Autocomplete<String>` — suggestions appear after ≥2 characters typed; student may type any value (not locked to list); use `_schoolSuggestions` constant for common Sri Lankan schools
  - [x] Subject checkboxes — `CheckboxListTile` for Chemistry, Physics, Combined Maths; tracks `_selectedSubjects` as `Set<String>`
  - [x] "Get started" `FilledButton` disabled until: district != null AND school.isNotEmpty AND selectedSubjects.isNotEmpty
  - [x] `_onGetStarted()`: (1) calls `authProvider.notifier.completeOnboarding()`; (2) on success: calls `notificationServiceProvider.requestPermission()`; (3) calls `authProvider.notifier.setFcmPermission()`; (4) router redirect handles `/board` navigation automatically
  - [x] Show `SnackBar` on error from `completeOnboarding()`
  - [x] `resizeToAvoidBottomInset: true`; `SafeArea`; `SingleChildScrollView`

- [x] Task 8: Tests (AC: #1–#8)
  - [x] `test/features/auth/data/auth_repository_impl_test.dart` — 3 new cases: `updateProfile()` success (reads back updated student), `updateProfile()` DAO failure → Left(DatabaseFailure), `updateFcmToken()` delegates to studentDao
  - [x] `test/features/auth/presentation/auth_notifier_test.dart` — 3 new cases: `completeOnboarding()` updates state with non-empty district, `completeOnboarding()` propagates repository failure → AsyncError, `setFcmPermission()` updates notificationsEnabled in state

## Dev Notes

### CRITICAL: Deferred Work This Story Must Address

From `deferred-work.md`:
- `firebase_messaging: ^16.2.0` declared with no `requestPermission()` call — **Fix in Task 5:** add `requestPermission()` to `NotificationService`.

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/features/auth/domain/student.dart` — `Student` freezed model; has `district`, `school`, `notificationsEnabled`, `fcmToken`; use `student.copyWith(...)` for in-memory state updates in `setFcmPermission()`
- `lib/core/database/daos/student_dao.dart` — `getStudent()`, `upsertStudent()`, `updateLastActiveAt()`, `updateFcmToken()`, `deleteStudent()` already exist; **ADD** `updateProfileFields()`, `setEnrolledSubjects()`, `getEnrolledSubjectNames()`; do NOT remove existing methods
- `lib/features/notifications/data/notification_service.dart` — `getFcmToken()` and `onTokenRefresh` exist; **ADD** `requestPermission()` only
- `lib/features/notifications/data/notification_provider.dart` — `notificationServiceProvider` is `@Riverpod(keepAlive: true)`; use as `ref.read(notificationServiceProvider)` in the screen
- `lib/router.dart` — `_RouterNotifier`, `goRouterProvider`, `ScaffoldWithNavBar` exist; `/onboarding` route already registered with `_OnboardingPlaceholder` — **REPLACE** the placeholder with `OnboardingScreen`; **DO NOT** recreate the router from scratch
- `lib/features/auth/presentation/auth_notifier.dart` — `signUpWithEmail()`, `signInWithGoogle()`, `signInWithEmailPassword()`, `signOut()` exist; **ADD** `completeOnboarding()` and `setFcmPermission()`; do NOT modify existing methods
- `lib/features/auth/presentation/auth_state.dart` + `.freezed.dart` — unchanged; `AuthState.authenticated({student, isNewStudent})` already has `isNewStudent`; no changes needed
- `lib/features/auth/presentation/register_screen.dart` — routes to `/onboarding` when `isNewStudent: true`; leave unchanged
- `lib/features/auth/presentation/login_screen.dart` — routes to `/board` on `authenticated`; router redirect now handles the `/onboarding` case for new Google Sign-In users; leave unchanged

### Schema Migration — `StudentSubjectsTable`

**Why a new table, not a column on `students`:**
The subject selection links students to subject names before content is seeded (Story 2.1). A junction table is cleaner and avoids JSON blobs. Subject names (`"Chemistry"`, `"Physics"`, `"Combined Maths"`) are stable strings — no FK to `subjects` table since subjects may not be seeded when onboarding runs.

```dart
// lib/core/database/tables/student_subjects_table.dart
import 'package:drift/drift.dart';

class StudentSubjectsTable extends Table {
  @override
  String get tableName => 'student_subjects';

  TextColumn get studentId => text()();
  TextColumn get subjectName => text()();  // 'Chemistry' | 'Physics' | 'Combined Maths'

  @override
  Set<Column> get primaryKey => {studentId, subjectName};
}
```

**Migration in `app_database.dart`:**
```dart
@DriftDatabase(
  tables: [
    StudentsTable,
    SubjectsTable,
    TopicsTable,
    LessonsTable,
    LessonTasksTable,
    QuizQuestionsTable,
    QuizAttemptsTable,
    PastPaperQuestionsTable,
    SurveyResponsesTable,
    NudgeEventsTable,
    SessionsTable,
    SyncQueueTable,
    SyncErrorLogTable,
    StudentSubjectsTable,  // ADD
  ],
  // ... daos unchanged
)
class AppDatabase extends _$AppDatabase {
  // ...
  @override
  int get schemaVersion => 2;  // BUMP from 1 to 2

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(studentSubjectsTable);
          }
        },
      );
}
```

### `StudentDao` — New Methods

```dart
// lib/core/database/daos/student_dao.dart — UPDATE @DriftAccessor decorator
@DriftAccessor(tables: [StudentsTable, SyncQueueTable, StudentSubjectsTable])
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
```

```dart
// ADD: updateProfileFields — district + school update + sync queue in same transaction
Future<void> updateProfileFields(
  String studentId, {
  required String district,
  required String school,
}) =>
    transaction(() async {
      final now = DateTime.now().toUtc().toIso8601String();
      await (update(studentsTable)..where((t) => t.id.equals(studentId)))
          .write(StudentsTableCompanion(
        district: Value(district),
        school: Value(school),
        lastActiveAt: Value(now),
      ));
      await into(syncQueueTable).insert(SyncQueueTableCompanion.insert(
        id: _uuid.v4(),
        entityType: 'student',
        entityId: studentId,
        operation: 'upsert',
        payload: jsonEncode({
          'student_id': studentId,
          'district': district,
          'school': school,
          'last_active_at': now,
        }),
        createdAt: now,
      ));
    });

// ADD: setEnrolledSubjects — replace existing subject rows atomically
Future<void> setEnrolledSubjects(
  String studentId,
  List<String> subjectNames,
) =>
    transaction(() async {
      await (delete(studentSubjectsTable)
            ..where((t) => t.studentId.equals(studentId)))
          .go();
      for (final name in subjectNames) {
        await into(studentSubjectsTable).insert(
          StudentSubjectsTableCompanion.insert(
            studentId: studentId,
            subjectName: name,
          ),
        );
      }
    });

// ADD: getEnrolledSubjectNames
Future<List<String>> getEnrolledSubjectNames(String studentId) async {
  final rows = await (select(studentSubjectsTable)
        ..where((t) => t.studentId.equals(studentId)))
      .get();
  return rows.map((r) => r.subjectName).toList();
}
```

**After modifying `student_dao.dart`, run:**
```
dart run build_runner build --delete-conflicting-outputs
```

### `AuthRepository` Interface — New Methods

```dart
// lib/features/auth/domain/auth_repository.dart — ADD below existing methods
/// Updates student district, school, and subject enrollment in Drift + sync queue.
Future<Either<Failure, Student>> updateProfile({
  required String studentId,
  required String district,
  required String school,
  required List<String> subjectNames,
});

/// Updates the FCM token and notifications_enabled flag in Drift.
Future<Either<Failure, void>> updateFcmToken(
  String studentId,
  String? token,
);
```

### `AuthRepositoryImpl` — Implementing New Methods

```dart
// lib/features/auth/data/auth_repository_impl.dart — ADD

@override
Future<Either<Failure, Student>> updateProfile({
  required String studentId,
  required String district,
  required String school,
  required List<String> subjectNames,
}) async {
  try {
    await _studentDao.updateProfileFields(
      studentId,
      district: district,
      school: school,
    );
    await _studentDao.setEnrolledSubjects(studentId, subjectNames);
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
      'last_active_at': updated.lastActiveAt,
      'created_at': updated.createdAt,
    }).toStudent(),
  );
}

@override
Future<Either<Failure, void>> updateFcmToken(
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
```

**Note on Supabase sync:** `updateProfile()` writes to Drift + sync queue only. No direct Supabase call is made — this follows the architecture pattern (write path: Drift + sync queue). The sync consumer (Story 5.1) will push district/school to Supabase when activated. This is acceptable for V1 where the 10-student experiment primarily tracks `last_active_at` (not district/school) server-side.

### `AuthNotifier` — New Methods

```dart
// lib/features/auth/presentation/auth_notifier.dart — ADD

Future<void> completeOnboarding({
  required String district,
  required String school,
  required List<String> selectedSubjects,
}) async {
  if (state.isLoading) return;
  // Capture student before loading state clears the value
  final student = state.value?.mapOrNull(authenticated: (a) => a.student);
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
      // isNewStudent: false — onboarding complete; district now non-empty
      // → router redirect sees district.isNotEmpty → navigates to /board
      AuthState.authenticated(
        student: updatedStudent,
        isNewStudent: false,
      ),
    ),
  );
}

Future<void> setFcmPermission({
  required bool granted,
  required String? fcmToken,
}) async {
  final student = state.value?.mapOrNull(authenticated: (a) => a.student);
  if (student == null) return;

  final token = granted ? fcmToken : null;
  // Best-effort — FCM permission failure is non-critical for onboarding completion
  await ref.read(authRepositoryProvider).updateFcmToken(student.id, token);

  // Update in-memory auth state to reflect notifications flag
  final current = state.value?.mapOrNull(authenticated: (a) => a.student);
  if (current != null) {
    state = AsyncValue.data(
      AuthState.authenticated(
        student: current.copyWith(
          notificationsEnabled: token != null,
          fcmToken: token,
        ),
        isNewStudent: false,
      ),
    );
  }
}
```

**`mapOrNull` usage:** This is a freezed-generated method that returns `null` for unmatched states. `state.value?.mapOrNull(authenticated: (a) => a.student)` returns `null` when `state` is `unauthenticated`, `AsyncLoading`, or `AsyncError`.

**Run `dart run build_runner build --delete-conflicting-outputs` after changes to `auth_notifier.dart`** (the `@Riverpod` annotation requires regeneration of `auth_notifier.g.dart`).

### `NotificationService` — Add `requestPermission()`

```dart
// lib/features/notifications/data/notification_service.dart — ADD

/// Requests notification permission. Returns the resulting authorization status.
/// On Android 12 and below: returns authorized without a dialog.
/// On Android 13+: shows the OS POST_NOTIFICATIONS permission dialog.
/// Non-fatal failures are logged to Crashlytics.
Future<AuthorizationStatus> requestPermission() async {
  try {
    final settings = await _fcm.requestPermission();
    return settings.authorizationStatus;
  } on Object catch (error, stack) {
    try {
      await _crashlyticsInstance.recordError(
        error,
        stack,
        reason: 'FCM requestPermission failed',
      );
    } on Object {
      // Crashlytics unavailable
    }
    return AuthorizationStatus.denied;
  }
}
```

**Import `firebase_messaging/firebase_messaging.dart`** — `AuthorizationStatus` is in this package; it's already imported in the file.

### Router Redirect — Onboarding Guard

The current redirect only guards `/login` and `/register`. Story 1.9 requires:
- Authenticated + `student.district.isEmpty` → `/onboarding` (needs setup)
- Authenticated + `student.district.isNotEmpty` + going to `/onboarding` → `/board` (setup done)

**Updated `redirect` in `goRouterProvider`:**

```dart
redirect: (context, state) {
  final authValue = ref.read(authProvider);
  // While session is being restored, do not redirect
  if (authValue.isLoading) return null;

  final authState = authValue.value;
  final isLoggedIn = authState?.map(
        unauthenticated: (_) => false,
        authenticated: (_) => true,
      ) ??
      false;

  final isGoingToLogin = state.matchedLocation == '/login';
  final isGoingToRegister = state.matchedLocation == '/register';
  final isGoingToOnboarding = state.matchedLocation == '/onboarding';

  if (!isLoggedIn) {
    if (!isGoingToLogin) return '/login';
    return null;
  }

  // isLoggedIn = true; check onboarding completion
  final student = authState!.mapOrNull(authenticated: (a) => a.student);
  final needsOnboarding = student?.district.isEmpty ?? false;

  if (needsOnboarding) {
    if (!isGoingToOnboarding) return '/onboarding';
    return null;
  }

  // Onboarding complete — guard /login, /register, /onboarding
  if (isGoingToLogin || isGoingToRegister || isGoingToOnboarding) return '/board';
  return null;
},
```

**Route change in `routes` list:**
```dart
GoRoute(
  path: '/onboarding',
  pageBuilder: (_, _) => const MaterialPage(child: OnboardingScreen()), // WAS: _OnboardingPlaceholder
),
```

Remove the `_OnboardingPlaceholder` class entirely (it becomes dead code).

**`mapOrNull` on `GoRouterState`-level `authState`:** Since `authState` is typed as `AuthState?` from `authValue.value`, `authState!.mapOrNull(...)` is a freezed call; verify `authState!` is non-null at this point (it will be if `!isLoggedIn` guard is above this code block).

### `OnboardingScreen` — Full Widget

```dart
// lib/features/auth/presentation/onboarding_screen.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/notifications/data/notification_provider.dart';

// 25 official Sri Lankan administrative districts (alphabetical)
const _sriLankanDistricts = [
  'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo',
  'Galle', 'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara',
  'Kandy', 'Kegalle', 'Kilinochchi', 'Kurunegala', 'Mannar',
  'Matale', 'Matara', 'Monaragala', 'Mullaitivu', 'Nuwara Eliya',
  'Polonnaruwa', 'Puttalam', 'Ratnapura', 'Trincomalee', 'Vavuniya',
];

// Common Sri Lankan school suggestions (partial list; not exhaustive — student may type any value)
const _schoolSuggestions = [
  'Royal College, Colombo',
  'Ananda College, Colombo',
  'Nalanda College, Colombo',
  "D.S. Senanayake College, Colombo",
  'Isipathana College, Colombo',
  'Thurstan College, Colombo',
  'Vishaka Vidyalaya, Colombo',
  'Devi Balika Vidyalaya, Colombo',
  "Ladies' College, Colombo",
  "Bishop's College, Colombo",
  'Zahira College, Colombo',
  'Trinity College, Kandy',
  'Dharmaraja College, Kandy',
  'Mahamaya Girls\' College, Kandy',
  "St. Sylvester's College, Kandy",
  'Jaffna College',
  'Hindu College, Jaffna',
  'Matara Central College',
  'Richmond College, Galle',
  'Mahinda College, Galle',
];

const _subjects = ['Chemistry', 'Physics', 'Combined Maths'];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _selectedDistrict;
  String _schoolValue = '';
  final _schoolFocusNode = FocusNode();
  String? _districtError;
  String? _schoolError;
  final _selectedSubjects = <String>{};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _schoolFocusNode.addListener(() {
      if (!_schoolFocusNode.hasFocus && _schoolValue.trim().isEmpty) {
        if (!mounted) return;
        setState(() => _schoolError = 'School is required');
      }
    });
  }

  @override
  void dispose() {
    _schoolFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _selectedDistrict != null &&
      _schoolValue.trim().isNotEmpty &&
      _selectedSubjects.isNotEmpty;

  Future<void> _onGetStarted() async {
    setState(() {
      _districtError =
          _selectedDistrict == null ? 'Please select a district' : null;
      _schoolError =
          _schoolValue.trim().isEmpty ? 'School is required' : null;
    });
    if (!_isFormValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    // Step 1: Save profile (district, school, subjects) to Drift + sync queue
    await ref.read(authProvider.notifier).completeOnboarding(
          district: _selectedDistrict!,
          school: _schoolValue.trim(),
          selectedSubjects: _selectedSubjects.toList(),
        );

    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState.hasError) {
      final message = authState.error is Failure
          ? (authState.error as Failure).message
          : 'Something went wrong. Please try again.';
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    // Step 2: Request notification permission (Android 13+ shows OS dialog;
    //         Android 12 and below returns authorized silently)
    final permissionStatus =
        await ref.read(notificationServiceProvider).requestPermission();

    if (!mounted) return;

    final granted = permissionStatus == AuthorizationStatus.authorized ||
        permissionStatus == AuthorizationStatus.provisional;

    String? fcmToken;
    if (granted) {
      fcmToken = await ref.read(notificationServiceProvider).getFcmToken();
    }

    if (!mounted) return;

    // Step 3: Persist FCM permission result (best-effort — non-blocking)
    await ref.read(authProvider.notifier).setFcmPermission(
          granted: granted,
          fcmToken: fcmToken,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    // Step 4: Navigation is handled by the router redirect:
    //         student.district.isNotEmpty → redirect fires → /board
    // No explicit context.go('/board') needed here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Set up your profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              // District dropdown
              DropdownButtonFormField<String>(
                value: _selectedDistrict,
                decoration: InputDecoration(
                  labelText: 'District',
                  errorText: _districtError,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                items: _sriLankanDistricts
                    .map(
                      (d) => DropdownMenuItem(value: d, child: Text(d)),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  _selectedDistrict = value;
                  _districtError = null;
                }),
              ),
              const SizedBox(height: 16),
              // School autocomplete — suggestions for ≥2 chars; custom value allowed
              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.length < 2) return const Iterable.empty();
                  return _schoolSuggestions.where(
                    (s) => s.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                  );
                },
                onSelected: (selection) =>
                    setState(() => _schoolValue = selection),
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'School',
                      errorText: _schoolError,
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      _schoolValue = value;
                      if (value.isNotEmpty) _schoolError = null;
                    }),
                    onEditingComplete: onFieldSubmitted,
                  );
                },
              ),
              const SizedBox(height: 24),
              // Subject selection
              Text(
                'Subjects',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ..._subjects.map(
                (subject) => CheckboxListTile(
                  title: Text(subject),
                  value: _selectedSubjects.contains(subject),
                  onChanged: (checked) => setState(() {
                    if (checked == true) {
                      _selectedSubjects.add(subject);
                    } else {
                      _selectedSubjects.remove(subject);
                    }
                  }),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: (_isFormValid && !_isSubmitting) ? _onGetStarted : null,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Get started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Note on `Autocomplete` controller sync:** The `fieldViewBuilder` callback provides its own `TextEditingController`. Update `_schoolValue` in `onChanged` of the inner `TextFormField` (as shown above). `onSelected` fires only when a suggestion is tapped and also updates `_schoolValue`. The `setState` in `onChanged` ensures `_isFormValid` re-evaluates on each keystroke.

**Note on router-driven navigation:** After `completeOnboarding()` succeeds, `AuthNotifier.state` transitions to `authenticated(student: updatedStudent)` where `updatedStudent.district.isNotEmpty`. The `_RouterNotifier` calls `notifyListeners()`, triggering `goRouter.refresh()`. The `redirect` evaluates `needsOnboarding = false` + `isGoingToOnboarding = true` → returns `/board`. The student is navigated to `/board` without the `OnboardingScreen` calling `context.go()` explicitly.

### Testing Patterns

```dart
// updateProfile() — success
when(() => mockStudentDao.updateProfileFields(any(), district: any(named: 'district'), school: any(named: 'school')))
    .thenAnswer((_) async {});
when(() => mockStudentDao.setEnrolledSubjects(any(), any()))
    .thenAnswer((_) async {});
when(() => mockStudentDao.getStudent(any())).thenAnswer((_) async => mockStudentsTableData); // with district='Colombo'
final result = await repo.updateProfile(
  studentId: 'uid', district: 'Colombo', school: 'Royal College', subjectNames: ['Chemistry'],
);
expect(result.isRight(), true);
expect(result.getOrElse((_) => throw '').district, 'Colombo');

// updateProfile() — DAO throws
when(() => mockStudentDao.updateProfileFields(any(), district: any(named: 'district'), school: any(named: 'school')))
    .thenThrow(Exception('DB error'));
final result = await repo.updateProfile(
  studentId: 'uid', district: 'Colombo', school: 'Royal College', subjectNames: ['Chemistry'],
);
expect(result.fold((f) => f, (_) => null), isA<DatabaseFailure>());

// completeOnboarding() — updates AuthNotifier state
// Start with authenticated state, district = ''
container.read(authProvider.notifier).state = AsyncValue.data(
  AuthState.authenticated(student: studentWithEmptyDistrict),
);
when(() => mockAuthRepository.updateProfile(...)).thenAnswer((_) async => Right(studentWithDistrict));
await container.read(authProvider.notifier).completeOnboarding(
  district: 'Colombo', school: 'Royal College', selectedSubjects: ['Chemistry'],
);
final state = container.read(authProvider).value!;
state.mapOrNull(authenticated: (a) {
  expect(a.student.district, 'Colombo');
  expect(a.isNewStudent, false);
});

// completeOnboarding() — propagates repository failure
when(() => mockAuthRepository.updateProfile(...))
    .thenAnswer((_) async => const Left(DatabaseFailure('DB error')));
await container.read(authProvider.notifier).completeOnboarding(...);
expect(container.read(authProvider).hasError, true);

// setFcmPermission() — updates notificationsEnabled
when(() => mockAuthRepository.updateFcmToken(any(), any())).thenAnswer((_) async => const Right(unit));
await container.read(authProvider.notifier).setFcmPermission(granted: true, fcmToken: 'token123');
final state = container.read(authProvider).value!;
state.mapOrNull(authenticated: (a) {
  expect(a.student.notificationsEnabled, true);
  expect(a.student.fcmToken, 'token123');
});
```

### Architecture Compliance Checklist

- [ ] `StudentSubjectsTable` added to `AppDatabase` with schema migration v1 → v2
- [ ] `StudentDao.updateProfileFields()` writes to Drift + enqueues sync queue in same transaction
- [ ] `StudentDao.setEnrolledSubjects()` replaces subject rows atomically in a transaction
- [ ] `AuthRepository.updateProfile()` delegates to DAO — no direct `_client.from(...)` call
- [ ] `AuthNotifier.completeOnboarding()` reads student from state before setting `loading()` (avoids null access)
- [ ] `AuthNotifier.setFcmPermission()` is best-effort — does NOT change loading state or propagate failure as error
- [ ] Router `redirect` checks `student.district.isEmpty` for onboarding routing (not `isNewStudent`)
- [ ] `OnboardingScreen` does NOT call `context.go('/board')` explicitly — router redirect handles navigation
- [ ] `flutter analyze` → 0 issues; `flutter test` → all pass

### Anti-Patterns to Avoid

- ❌ Calling `ref.read(studentDaoProvider)` directly from `AuthNotifier` — go through `authRepositoryProvider`
- ❌ Calling `context.go('/board')` at the end of `_onGetStarted()` — router redirect handles this; explicit nav creates a race condition
- ❌ Setting `state = loading()` in `completeOnboarding()` BEFORE reading `state.value` for the student — you'd lose the student reference
- ❌ Showing the `OnboardingScreen` for returning students — router redirect's `needsOnboarding = student.district.isEmpty` check prevents this; returning students with non-empty district never reach onboarding
- ❌ Locking the school field to the suggestion list — AC #3 explicitly requires custom input
- ❌ Running `dart run build_runner build` before adding `StudentSubjectsTable` to `AppDatabase` — must update both files before generating

### Project Structure Notes

**Files to CREATE:**
```
lib/core/database/tables/student_subjects_table.dart   # New Drift table
lib/features/auth/presentation/onboarding_screen.dart   # New onboarding UI
```

**Files to MODIFY:**
```
lib/core/database/app_database.dart                      # Add table, bump schemaVersion to 2, add migration
lib/core/database/daos/student_dao.dart                  # Add accessor decorator + 3 new methods
lib/features/auth/domain/auth_repository.dart            # Add updateProfile() + updateFcmToken()
lib/features/auth/data/auth_repository_impl.dart         # Implement new methods
lib/features/auth/presentation/auth_notifier.dart        # Add completeOnboarding() + setFcmPermission()
lib/features/notifications/data/notification_service.dart # Add requestPermission()
lib/router.dart                                          # Update redirect + replace _OnboardingPlaceholder
```

**Generated after build_runner (required for each change):**
```
lib/core/database/app_database.g.dart                    # Regenerated (new table)
lib/core/database/daos/student_dao.g.dart                # Regenerated (new accessor tables)
lib/features/auth/presentation/auth_notifier.g.dart      # Regenerated if build() signature changes
```

**Test files to UPDATE:**
```
test/features/auth/data/auth_repository_impl_test.dart   # 3 new cases
test/features/auth/presentation/auth_notifier_test.dart  # 3 new cases
```

**Files NOT to modify:**
- `lib/features/auth/presentation/auth_state.dart` — no changes needed
- `lib/features/auth/domain/student.dart` — no changes needed (district/school already in model)
- `lib/features/auth/presentation/register_screen.dart` — already routes to `/onboarding` on `isNewStudent: true`
- `lib/features/auth/presentation/login_screen.dart` — router redirect handles new-student routing
- `lib/features/auth/data/auth_provider.dart` — unchanged

### Accumulated Learnings from Stories 1.1–1.8

- **`authProvider`** (not `authNotifierProvider`) — Riverpod 4.x strips `Notifier` suffix from generated provider name
- **`state.value?.mapOrNull(authenticated: (a) => a.student)`** — correct pattern to extract student; returns `null` for unauthenticated/loading/error states
- **`dart run build_runner build --delete-conflicting-outputs`** — run from `studyboard_mobile/` after any `@DriftDatabase`, `@DriftAccessor`, `@riverpod`, or `@freezed` change
- **Concurrency guard** — `if (state.isLoading) return;` at top of every `AuthNotifier` mutating method
- **`very_good_analysis`** — `package:` imports everywhere; no relative imports in `lib/`
- **`sort_constructors_first` lint** — constructors must appear before field declarations in Dart classes
- **`freezed` `copyWith`** — generated for all `@freezed` models; use `student.copyWith(...)` for partial updates
- **`mapOrNull` vs `maybeMap`** — `mapOrNull` returns `null` for unmatched patterns (no `orElse` required); useful for extracting specific union variants
- **Drift `transaction()`** — wraps multiple DAO operations atomically; use for write + sync_queue enqueue pattern
- **Router redirect re-evaluation** — fires when `refreshListenable.notifyListeners()` is called; `_RouterNotifier` listens on `authProvider`, so any auth state change triggers re-evaluation
- **`SyncQueueTableCompanion.insert()`** — requires all non-nullable fields; `payload` is a JSON string

### References

- [Source: epics.md#Story 1.9] — Acceptance criteria, district dropdown, school autocomplete, subject checklist, notification permission
- [Source: ux-design-specification.md#UX-DR19] — One-screen form layout, inline validation on blur, submit button disabled until complete
- [Source: architecture.md#Data Architecture] — Write path: Drift + sync queue enqueue in same transaction; no direct Supabase write from repository
- [Source: architecture.md#Flutter Architecture] — go_router redirect pattern; `refreshListenable: RouterNotifier(ref)`
- [Source: 1-8-student-login-and-session-persistence.md#Dev Notes] — `authProvider` name, concurrency guard, `mapOrNull` pattern, router redirect with `isLoading` guard
- [Source: deferred-work.md] — `firebase_messaging` declared without `requestPermission()` call — resolved in Task 5

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- `DropdownButtonFormField.value` deprecated in Flutter 3.33+ — replaced with `initialValue` (same semantics for our stateful widget).
- `isNewStudent: false` redundant in `AuthState.authenticated` (default is already `false`) — removed.
- Pre-build_runner IDE errors for `studentSubjectsTable` / `StudentSubjectsTableCompanion` are expected; resolved after build_runner ran.

### Completion Notes List

- Created `StudentSubjectsTable` Drift table with composite PK (`studentId`, `subjectName`); added to `AppDatabase` with schema v1→v2 migration.
- Added `updateProfileFields()`, `setEnrolledSubjects()`, `getEnrolledSubjectNames()` to `StudentDao` in atomic Drift transactions.
- Added `updateProfile()` and `updateFcmToken()` to `AuthRepository` interface and `AuthRepositoryImpl`.
- Added `completeOnboarding()` and `setFcmPermission()` to `AuthNotifier`; student captured before `loading()` state to avoid null access.
- Added `requestPermission()` to `NotificationService` (resolves deferred FCM permission work from Story 1.5).
- Updated `goRouterProvider` redirect: `student.district.isEmpty` → `/onboarding`; onboarding complete + going to onboarding → `/board`.
- Created `OnboardingScreen` with district dropdown, school autocomplete (≥2 chars), subject checkboxes, and router-driven navigation on submit.
- Removed dead `_OnboardingPlaceholder` class from `router.dart`.
- Updated `app_database_test.dart` table count from 13 to 14 (added `student_subjects`).
- All 92 tests pass; build_runner output: 95 files written.

### File List

studyboard_mobile/lib/core/database/tables/student_subjects_table.dart (created)
studyboard_mobile/lib/features/auth/presentation/onboarding_screen.dart (created)
studyboard_mobile/lib/core/database/app_database.dart (modified)
studyboard_mobile/lib/core/database/daos/student_dao.dart (modified)
studyboard_mobile/lib/features/auth/domain/auth_repository.dart (modified)
studyboard_mobile/lib/features/auth/data/auth_repository_impl.dart (modified)
studyboard_mobile/lib/features/auth/presentation/auth_notifier.dart (modified)
studyboard_mobile/lib/features/notifications/data/notification_service.dart (modified)
studyboard_mobile/lib/router.dart (modified)
studyboard_mobile/test/features/auth/data/auth_repository_impl_test.dart (modified)
studyboard_mobile/test/features/auth/presentation/auth_notifier_test.dart (modified)
studyboard_mobile/test/core/database/app_database_test.dart (modified)
studyboard_mobile/lib/core/database/app_database.g.dart (regenerated)
studyboard_mobile/lib/core/database/daos/student_dao.g.dart (regenerated)

### Review Findings

- [x] [Review][Patch] P1: `updateProfile` runs two separate Drift transactions — crash between them leaves district/school saved but subjects empty [studyboard_mobile/lib/features/auth/data/auth_repository_impl.dart:updateProfile] — fixed: added `updateProfileWithSubjects` atomic DAO method
- [x] [Review][Patch] P2: `deleteStudent` does not delete `student_subjects` rows — orphaned rows accumulate per student on every sign-out [studyboard_mobile/lib/core/database/daos/student_dao.dart:deleteStudent] — fixed: wrapped both deletes in a single transaction
- [x] [Review][Patch] P3: Router redirect treats `AsyncError` state as unauthenticated — `completeOnboarding()` failure boots user to `/login` mid-onboarding [studyboard_mobile/lib/router.dart:redirect] — fixed: added `if (authValue.hasError) return null`
- [x] [Review][Patch] P4: `setFcmPermission` updates in-memory `notificationsEnabled: true` even when `updateFcmToken` DAO call fails — in-memory/Drift diverge for the current session [studyboard_mobile/lib/features/auth/presentation/auth_notifier.dart:setFcmPermission] — fixed: state updated only on Right result
- [x] [Review][Patch] P5: No error label beneath subject checkboxes — user cannot tell why "Get started" is disabled when only subjects are missing [studyboard_mobile/lib/features/auth/presentation/onboarding_screen.dart:build] — fixed: added `_subjectError` with inline error text
- [x] [Review][Patch] P6: Missing test — `setFcmPermission` with `updateFcmToken` returning `Left(DatabaseFailure)` has zero coverage [studyboard_mobile/test/features/auth/presentation/auth_notifier_test.dart] — fixed: added DAO failure test case

## Change Log

- 2026-04-26: Story created by create-story workflow. (claude-sonnet-4-6)
- 2026-04-26: Story implemented — StudentSubjectsTable (v2 migration), DAO methods, AuthRepository updateProfile/updateFcmToken, AuthNotifier completeOnboarding/setFcmPermission, NotificationService.requestPermission, OnboardingScreen, router redirect, 6 new tests. (claude-sonnet-4-6)
- 2026-04-26: Code review — 6 patches applied: atomic updateProfileWithSubjects DAO method, deleteStudent cleans student_subjects, router AsyncError guard, setFcmPermission conditional state update, subject error label, setFcmPermission failure test. 6 dismissed. (claude-sonnet-4-6)
