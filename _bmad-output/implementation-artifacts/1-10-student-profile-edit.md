# Story 1.10: Student Profile Edit

Status: done

## Story

As a student,
I want to update my name, district, and school after I have completed onboarding,
So that my profile information stays accurate if my details change.

## Acceptance Criteria

1. **Given** a student navigates to their Profile screen (accessible from the `ScaffoldWithNavBar` AppBar profile icon) **When** the Profile screen opens **Then** their current name, district, and school values are pre-populated in editable fields matching the onboarding form layout

2. **Given** the student edits one or more fields **When** they tap "Save changes" **Then** the updated values are written to the `students` record in Drift atomically with a sync queue entry in the same Drift transaction, a brief `SnackBar` confirms "Profile updated"

3. **Given** the student submits an empty name field **When** validation fires on blur **Then** an inline error appears ("Name is required") and the Save button remains disabled until the field is non-empty

4. **Given** the student makes edits and then navigates away without saving **When** they leave the Profile screen **Then** no changes are persisted — edited values are discarded and the original values remain

5. **Given** the profile update while offline **When** the student saves changes **Then** the update is written to Drift immediately, a sync queue entry is enqueued, and the update syncs to Supabase when connectivity is restored — the student sees their updated name and details immediately with no error

## Tasks / Subtasks

- [x] Task 1: Add `updateStudentProfile()` to `StudentDao` (AC: #2, #5)
  - [x] Open `lib/core/database/daos/student_dao.dart`
  - [x] Add `updateStudentProfile(studentId, {name, district, school})` — Drift transaction: updates `name` + `district` + `school` + `last_active_at` in `studentsTable`, then inserts sync queue entry with full name/district/school payload
  - [x] No `build_runner` run required — no new `@DriftAccessor` annotations changed

- [x] Task 2: Add `editProfile()` to `AuthRepository` interface and `AuthRepositoryImpl` (AC: #2, #5)
  - [x] Open `lib/features/auth/domain/auth_repository.dart`; add `editProfile({studentId, name, district, school})` method signature below `updateFcmToken()`
  - [x] Open `lib/features/auth/data/auth_repository_impl.dart`; implement `editProfile()` — calls `_studentDao.updateStudentProfile()`, reads back updated row via `_studentDao.getStudent()`, maps via `StudentDto.fromJson(...).toStudent()`, returns `Either<Failure, Student>`

- [x] Task 3: Add `editProfile()` to `AuthNotifier` (AC: #2, #3)
  - [x] Open `lib/features/auth/presentation/auth_notifier.dart`
  - [x] Implement `editProfile({name, district, school})` — capture student ID from `state.value` BEFORE setting `loading()` state, call `authRepositoryProvider.editProfile()`, fold result into auth state update
  - [x] No `build_runner` run required — adding a method does not change `build()` signature or `@Riverpod` annotation

- [x] Task 4: Create `ProfileScreen` widget (AC: #1, #2, #3, #4)
  - [x] Create `lib/features/auth/presentation/profile_screen.dart`
  - [x] `ConsumerStatefulWidget`; pre-populate name, district, school from `ref.read(authProvider).value?.mapOrNull(authenticated: (a) => a.student)` in `initState()`
  - [x] Name: `TextFormField` with `TextEditingController` + `FocusNode`; inline error "Name is required" shown on blur when empty; error cleared on non-empty change
  - [x] District: `DropdownButtonFormField<String>` using same `_sriLankanDistricts` list as `OnboardingScreen`; initialized from student's current district
  - [x] School: `Autocomplete<String>` using same `_schoolSuggestions` as `OnboardingScreen`; `initialValue: TextEditingValue(text: _schoolValue)` to pre-populate; `onChanged` + `onSelected` both update `_schoolValue`
  - [x] `_checkDirty()` method: compares current values against `_originalName`/`_originalDistrict`/`_originalSchool` captured in `initState()`; sets `_isDirty`
  - [x] "Save changes" `FilledButton` disabled when `!_isFormValid || !_isDirty || _isSubmitting`
  - [x] `_onSave()`: validates, calls `authProvider.notifier.editProfile()`, checks `authProvider.hasError`, shows SnackBar "Profile updated" on success (stay on screen), shows error SnackBar on failure; resets `_isDirty = false` + `_originalName/District/School` on success
  - [x] `resizeToAvoidBottomInset: true`; `SafeArea`; `SingleChildScrollView`; `appBar: AppBar(title: Text('Edit profile'))`

- [x] Task 5: Add `/profile` route and profile icon navigation entry point (AC: #1)
  - [x] Open `lib/router.dart`
  - [x] Add import for `ProfileScreen`
  - [x] Add `GoRoute(path: '/profile', pageBuilder: (_, _) => const MaterialPage(child: ProfileScreen()))` as a top-level route outside the `ShellRoute` (sibling to `/login`, `/register`, `/onboarding`)
  - [x] Modify `ScaffoldWithNavBar.build()`: add `appBar: AppBar(actions: [IconButton(icon: Icon(Icons.person_outline), tooltip: 'Profile', onPressed: () => context.push('/profile'))])` — no AppBar conflict since placeholder screens have no AppBar of their own

- [x] Task 6: Tests (AC: #2–#5)
  - [x] `test/features/auth/data/auth_repository_impl_test.dart` — 2 new cases: `editProfile()` success (DAO called + reads back student with new name → `Right(Student)`), `editProfile()` DAO throws → `Left(DatabaseFailure)`
  - [x] `test/features/auth/presentation/auth_notifier_test.dart` — 2 new cases: `editProfile()` success (state transitions to `authenticated` with updated student name), `editProfile()` repository failure → `AsyncError`

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/features/auth/domain/student.dart` — `Student` freezed model; has `id`, `name`, `email`, `district`, `school`, `notificationsEnabled`, `fcmToken`, `lastActiveAt`, `createdAt`, `deactivatedAt`, `deletedAt`; no field additions needed for this story
- `lib/core/database/daos/student_dao.dart` — has `getStudent()`, `upsertStudent()`, `updateLastActiveAt()`, `updateFcmToken()`, `updateProfileFields()` (district + school only), `updateProfileWithSubjects()` (onboarding atomic method), `setEnrolledSubjects()`, `getEnrolledSubjectNames()`, `deactivate()`, `softDelete()`, `deleteStudent()` — **ADD** `updateStudentProfile()` only; do NOT modify existing methods
- `lib/features/auth/domain/auth_repository.dart` — has `signUpWithEmail()`, `getCurrentUser()`, `signOut()`, `getSessionStream()`, `signInWithEmailPassword()`, `signInWithGoogle()`, `updateProfile()` (onboarding, requires subjects list), `updateFcmToken()` — **ADD** `editProfile()` only
- `lib/features/auth/presentation/auth_notifier.dart` — has `signUpWithEmail()`, `signInWithGoogle()`, `signInWithEmailPassword()`, `signOut()`, `completeOnboarding()`, `setFcmPermission()` — **ADD** `editProfile()` only
- `lib/features/auth/presentation/onboarding_screen.dart` — copy the `_sriLankanDistricts` and `_schoolSuggestions` constant lists into `profile_screen.dart` verbatim; the district dropdown and school autocomplete patterns are identical
- `lib/router.dart` — `goRouterProvider`, `_RouterNotifier`, `ScaffoldWithNavBar` exist; `/profile` NOT yet registered; placeholder screens (`BoardScreen`, `DashboardScreen`, `BacklogScreen`) are bare `Center(child: Text(...))` widgets with NO AppBar, so adding AppBar to `ScaffoldWithNavBar` causes no conflicts

### CRITICAL: `editProfile` vs `updateProfile` — Do NOT Confuse

| Method | Purpose | Params | Subjects? |
|---|---|---|---|
| `updateProfile()` (existing, Story 1.9) | Onboarding completion | `{studentId, district, school, subjectNames}` | YES — updates `student_subjects` table |
| `editProfile()` (new, Story 1.10) | Post-onboarding profile edit | `{studentId, name, district, school}` | NO — leaves `student_subjects` untouched |

Both live on `AuthRepository`. The `AuthNotifier` has `completeOnboarding()` → `updateProfile()` and the new `editProfile()` → `editProfile()` repo method. Never mix them up.

### `StudentDao` — New Method

```dart
// lib/core/database/daos/student_dao.dart — ADD below updateProfileFields()

/// Updates name, district, and school in a single Drift transaction.
/// Enqueues a sync queue entry with the full name/district/school payload
/// for the sync consumer (Story 5.1) to push to Supabase.
Future<void> updateStudentProfile(
  String studentId, {
  required String name,
  required String district,
  required String school,
}) =>
    transaction(() async {
      final now = DateTime.now().toUtc().toIso8601String();
      await (update(studentsTable)..where((t) => t.id.equals(studentId)))
          .write(StudentsTableCompanion(
        name: Value(name),
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
          'name': name,
          'district': district,
          'school': school,
          'last_active_at': now,
        }),
        createdAt: now,
      ));
    });
```

**No `build_runner` needed** — `updateStudentProfile()` uses the same Drift table getters (`studentsTable`, `syncQueueTable`) provided by the existing `_$StudentDaoMixin`. The `@DriftAccessor` annotation and generated mixin are unchanged.

### `AuthRepository` Interface — New Method

```dart
// lib/features/auth/domain/auth_repository.dart — ADD below updateFcmToken()

/// Updates student name, district, and school in Drift + sync queue.
/// Does NOT modify subject enrollment (StudentSubjectsTable rows unchanged).
Future<Either<Failure, Student>> editProfile({
  required String studentId,
  required String name,
  required String district,
  required String school,
});
```

### `AuthRepositoryImpl` — Implementing `editProfile()`

```dart
// lib/features/auth/data/auth_repository_impl.dart — ADD

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
      'last_active_at': updated.lastActiveAt,
      'created_at': updated.createdAt,
      'fcm_token': updated.fcmToken,
    }).toStudent(),
  );
}
```

**JSON key mapping:** Use `snake_case` keys matching what `StudentDto.fromJson()` expects. See `auth_repository_impl.dart`'s existing `updateProfile()` implementation for the exact pattern — copy that JSON map structure.

**Note on Supabase sync:** `editProfile()` writes to Drift + sync queue only. No direct Supabase call is made. The AC's "both Drift and Supabase in a single operation" means the write is atomic within one Drift transaction (Drift + sync queue enqueue happen together). The Supabase push is handled asynchronously by the sync consumer (Story 5.1). This follows the established architecture write path.

### `AuthNotifier` — New `editProfile()` Method

```dart
// lib/features/auth/presentation/auth_notifier.dart — ADD

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
```

**No `build_runner` needed** — adding a method to `AuthNotifier` does not change its `build()` signature or the `@Riverpod` annotation, so `auth_notifier.g.dart` does not need regeneration.

**Router redirect safety after `editProfile()`:** Auth state transitions to `authenticated(student: updatedStudent)`. `_RouterNotifier.notifyListeners()` fires and the redirect re-evaluates for the current location `/profile`. The redirect: `isLoggedIn = true` → `needsOnboarding = student.district.isEmpty = false` (district was set and cannot be cleared via the dropdown) → `/profile` is not `/login`/`/register`/`/onboarding` → returns null. User stays on ProfileScreen. ✓

**Redirect also has `if (authValue.hasError) return null`** (added in Story 1.9 review patch P3) — so `editProfile()` failure does not boot the user to `/login`. ✓

### `ProfileScreen` — Full Widget

```dart
// lib/features/auth/presentation/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';

// 25 official Sri Lankan administrative districts — keep in sync with OnboardingScreen
const _sriLankanDistricts = [
  'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo',
  'Galle', 'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara',
  'Kandy', 'Kegalle', 'Kilinochchi', 'Kurunegala', 'Mannar',
  'Matale', 'Matara', 'Monaragala', 'Mullaitivu', 'Nuwara Eliya',
  'Polonnaruwa', 'Puttalam', 'Ratnapura', 'Trincomalee', 'Vavuniya',
];

// Common Sri Lankan school suggestions — keep in sync with OnboardingScreen
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
  "Mahamaya Girls' College, Kandy",
  "St. Sylvester's College, Kandy",
  'Jaffna College',
  'Hindu College, Jaffna',
  'Matara Central College',
  'Richmond College, Galle',
  'Mahinda College, Galle',
];

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  String? _selectedDistrict;
  String _schoolValue = '';
  String? _nameError;
  bool _isDirty = false;
  bool _isSubmitting = false;

  // Captured in initState for dirty detection; updated on successful save
  late String _originalName;
  late String _originalDistrict;
  late String _originalSchool;

  @override
  void initState() {
    super.initState();
    final student =
        ref.read(authProvider).value?.mapOrNull(authenticated: (a) => a.student);
    _originalName = student?.name ?? '';
    _originalDistrict = student?.district ?? '';
    _originalSchool = student?.school ?? '';

    _nameController.text = _originalName;
    _selectedDistrict = _originalDistrict.isEmpty ? null : _originalDistrict;
    _schoolValue = _originalSchool;

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus && _nameController.text.trim().isEmpty) {
        if (!mounted) return;
        setState(() => _nameError = 'Name is required');
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty && _selectedDistrict != null;

  void _checkDirty() {
    final dirty = _nameController.text.trim() != _originalName ||
        (_selectedDistrict ?? '') != _originalDistrict ||
        _schoolValue.trim() != _originalSchool;
    if (dirty != _isDirty) setState(() => _isDirty = dirty);
  }

  Future<void> _onSave() async {
    setState(() {
      _nameError =
          _nameController.text.trim().isEmpty ? 'Name is required' : null;
    });
    if (!_isFormValid || !_isDirty || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    await ref.read(authProvider.notifier).editProfile(
          name: _nameController.text.trim(),
          district: _selectedDistrict!,
          school: _schoolValue.trim(),
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

    // Success — reset dirty tracking so Save button disables again
    _originalName = _nameController.text.trim();
    _originalDistrict = _selectedDistrict ?? '';
    _originalSchool = _schoolValue.trim();
    setState(() {
      _isDirty = false;
      _isSubmitting = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Edit profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Full name',
                  errorText: _nameError,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && _nameError != null) {
                    setState(() => _nameError = null);
                  }
                  _checkDirty();
                },
              ),
              const SizedBox(height: 16),
              // District
              DropdownButtonFormField<String>(
                value: _selectedDistrict,
                decoration: InputDecoration(
                  labelText: 'District',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                items: _sriLankanDistricts
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedDistrict = value);
                  _checkDirty();
                },
              ),
              const SizedBox(height: 16),
              // School autocomplete — pre-populated via initialValue
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _schoolValue),
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.length < 2) {
                    return const Iterable.empty();
                  }
                  return _schoolSuggestions.where(
                    (s) => s.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                  );
                },
                onSelected: (selection) {
                  setState(() => _schoolValue = selection);
                  _checkDirty();
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'School',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _schoolValue = value);
                      _checkDirty();
                    },
                    onEditingComplete: onFieldSubmitted,
                  );
                },
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: (_isFormValid && _isDirty && !_isSubmitting)
                    ? _onSave
                    : null,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Note on `Autocomplete.initialValue`:** Flutter 3.3+ supports `initialValue: TextEditingValue(text: ...)` to pre-populate the `Autocomplete` field. This sets the internal `TextEditingController`'s initial text. StudyBoard uses Flutter 3.41 — this is available. The `fieldViewBuilder`'s `controller` argument already has the initial text set; do not set it again manually.

**Note on AC4 (navigate away without saving):** Flutter's default `Navigator.pop()` (back button) destroys the `_ProfileScreenState`, discarding all unsaved local changes. No `PopScope` / `WillPopScope` confirmation dialog is needed — discarding on back is the expected behavior and matches the AC.

**Note on district dropdown:** `DropdownButtonFormField` only allows selecting from the list or keeping the current selection — the student cannot clear the district. Since `_originalDistrict` is always set (onboarding guaranteed district is non-empty), `_selectedDistrict` starts non-null and stays non-null. The router's `needsOnboarding = student.district.isEmpty` check is safe.

### Router Changes

```dart
// lib/router.dart — ADD import
import 'package:studyboard_mobile/features/auth/presentation/profile_screen.dart';

// lib/router.dart — ADD to routes list (before the ShellRoute)
GoRoute(
  path: '/profile',
  pageBuilder: (_, _) => const MaterialPage(child: ProfileScreen()),
),

// lib/router.dart — MODIFY ScaffoldWithNavBar.build()
// Add appBar to the Scaffold in ScaffoldWithNavBar
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline),
          tooltip: 'Profile',
          onPressed: () => context.push('/profile'),
        ),
      ],
    ),
    body: child,
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex(context),
      onDestinationSelected: (index) =>
          _onDestinationSelected(context, index),
      destinations: const [
        // ... unchanged destinations
      ],
    ),
  );
}
```

**No AppBar conflict:** `BoardScreen`, `DashboardScreen`, and `BacklogScreen` are currently `Center(child: Text(...))` with no `Scaffold` of their own. The `ScaffoldWithNavBar` `Scaffold` is the sole scaffold in the widget tree for these routes. When Epic 2+ implements real screen content with AppBars, the `ScaffoldWithNavBar` AppBar should be removed and the profile icon moved to each screen's individual AppBar (see Deferred Work Note).

### Testing Patterns

```dart
// test/features/auth/data/auth_repository_impl_test.dart — 2 new cases

// editProfile() — success
when(() => mockStudentDao.updateStudentProfile(
  any(),
  name: any(named: 'name'),
  district: any(named: 'district'),
  school: any(named: 'school'),
)).thenAnswer((_) async {});
when(() => mockStudentDao.getStudent(any()))
    .thenAnswer((_) async => mockStudentsTableData); // name = 'New Name'
final result = await repo.editProfile(
  studentId: 'uid',
  name: 'New Name',
  district: 'Colombo',
  school: 'Royal College',
);
expect(result.isRight(), true);
expect(result.getOrElse((_) => throw '').name, 'New Name');
expect(result.getOrElse((_) => throw '').district, 'Colombo');

// editProfile() — DAO throws → DatabaseFailure
when(() => mockStudentDao.updateStudentProfile(
  any(),
  name: any(named: 'name'),
  district: any(named: 'district'),
  school: any(named: 'school'),
)).thenThrow(Exception('DB error'));
final result = await repo.editProfile(
  studentId: 'uid',
  name: 'New Name',
  district: 'Colombo',
  school: 'Royal College',
);
expect(result.fold((f) => f, (_) => null), isA<DatabaseFailure>());

// test/features/auth/presentation/auth_notifier_test.dart — 2 new cases

// editProfile() — updates state with new name
container.read(authProvider.notifier).state = AsyncValue.data(
  AuthState.authenticated(student: studentWithOriginalName), // name = 'Old Name'
);
when(() => mockAuthRepository.editProfile(
  studentId: any(named: 'studentId'),
  name: any(named: 'name'),
  district: any(named: 'district'),
  school: any(named: 'school'),
)).thenAnswer((_) async => Right(studentWithUpdatedName)); // name = 'New Name'
await container.read(authProvider.notifier).editProfile(
  name: 'New Name',
  district: 'Colombo',
  school: 'Royal College',
);
final state = container.read(authProvider).value!;
state.mapOrNull(authenticated: (a) {
  expect(a.student.name, 'New Name');
});

// editProfile() — failure → AsyncError
when(() => mockAuthRepository.editProfile(
  studentId: any(named: 'studentId'),
  name: any(named: 'name'),
  district: any(named: 'district'),
  school: any(named: 'school'),
)).thenAnswer((_) async => const Left(DatabaseFailure('DB error')));
await container.read(authProvider.notifier).editProfile(
  name: 'Bad Name',
  district: 'Colombo',
  school: 'Royal College',
);
expect(container.read(authProvider).hasError, true);
```

### Architecture Compliance Checklist

- [ ] `StudentDao.updateStudentProfile()` writes name + district + school + last_active_at AND sync queue entry in a single `transaction()` call
- [ ] Sync queue `payload` JSON includes `name` field — the sync consumer (Story 5.1) needs all changed fields to construct the Supabase upsert
- [ ] `AuthRepositoryImpl.editProfile()` calls DAO only — no direct `_client.from(...)` Supabase call
- [ ] `AuthNotifier.editProfile()` reads `state.value` for the student ID **before** setting `state = AsyncValue.loading()`
- [ ] Router redirect returns null for `/profile` when user is authenticated and onboarded — no accidental redirect after save
- [ ] `ProfileScreen` reads initial values from `authProvider` state in `initState()` (not a direct Drift DAO call)
- [ ] `ProfileScreen` does NOT call `context.go('/board')` after save — user stays on ProfileScreen
- [ ] `flutter analyze` → 0 issues; `flutter test` → all pass

### Anti-Patterns to Avoid

- ❌ Modifying `updateProfileFields()` to add name — it's the onboarding-specific method and has its own sync payload without name; add `updateStudentProfile()` separately
- ❌ Calling `updateProfile()` / `completeOnboarding()` from the profile edit flow — those are onboarding methods that also touch `student_subjects` table; profile edit must not touch subject enrollment
- ❌ Calling `build_runner` — no `@DriftAccessor`, `@riverpod`, or `@freezed` annotation changed; regeneration is unnecessary
- ❌ Using `ref.watch(authProvider)` inside `initState()` — use `ref.read()` in `initState()`; `ref.watch()` is only valid inside `build()`
- ❌ Calling `_checkDirty()` without wrapping in `setState()` implications — `_checkDirty()` already calls `setState()` internally when `_isDirty` changes, so callers don't need to wrap
- ❌ Forgetting to update `_originalName`/`_originalDistrict`/`_originalSchool` on successful save — if not reset, `_isDirty` immediately flips back to true after a successful save since the comparison still uses old originals
- ❌ Adding subject selection (checkboxes) to `ProfileScreen` — AC for Story 1.10 only covers name, district, school; subjects are managed via a different flow
- ❌ Adding a confirmation dialog on back-navigation for ProfileScreen — AC4 explicitly states "navigate away without saving → changes discarded" with no mention of a dialog; no `PopScope` is needed

### Project Structure Notes

**Files to CREATE:**
```
lib/features/auth/presentation/profile_screen.dart    # New profile edit UI
```

**Files to MODIFY:**
```
lib/core/database/daos/student_dao.dart               # Add updateStudentProfile()
lib/features/auth/domain/auth_repository.dart         # Add editProfile() signature
lib/features/auth/data/auth_repository_impl.dart      # Implement editProfile()
lib/features/auth/presentation/auth_notifier.dart     # Add editProfile()
lib/router.dart                                        # Add /profile route + AppBar to ScaffoldWithNavBar
```

**Test files to UPDATE:**
```
test/features/auth/data/auth_repository_impl_test.dart    # 2 new cases
test/features/auth/presentation/auth_notifier_test.dart   # 2 new cases
```

**NO `build_runner` run required** — no changes to `@DriftDatabase`, `@DriftAccessor`, `@riverpod`, or `@freezed` annotations. `student_dao.g.dart` and `auth_notifier.g.dart` do not need regeneration.

**Files NOT to modify:**
- `lib/core/database/app_database.dart` — schema unchanged (no new tables or columns)
- `lib/core/database/daos/student_dao.g.dart` — not regenerated
- `lib/features/auth/presentation/auth_notifier.g.dart` — not regenerated
- `lib/features/auth/presentation/auth_state.dart` — no changes needed
- `lib/features/auth/domain/student.dart` — no changes needed (name field already present)
- `lib/features/auth/presentation/onboarding_screen.dart` — leave unchanged
- `lib/features/auth/data/models/student_dto.dart` — no changes needed

### Deferred Work Note

When Epic 2+ implements `BoardScreen`, `DashboardScreen`, and `BacklogScreen` with real UI and AppBars:
- Remove the AppBar from `ScaffoldWithNavBar.build()` (to avoid double-AppBar)
- Move the profile `IconButton` to the relevant screen's AppBar `actions` list
- Or add a dedicated Settings tab to the `NavigationBar`

Add this to `deferred-work.md` after implementation.

### Accumulated Learnings from Stories 1.1–1.9

- **`authProvider`** (not `authNotifierProvider`) — Riverpod 4.x strips `Notifier` suffix from generated provider name
- **`state.value?.mapOrNull(authenticated: (a) => a.student)`** — correct pattern to extract student; returns `null` for unauthenticated/loading/error states; must read **before** setting `state = AsyncValue.loading()`
- **Concurrency guard** — `if (state.isLoading) return;` at top of every `AuthNotifier` mutating method
- **`very_good_analysis`** — `package:` imports everywhere; no relative imports in `lib/`
- **`sort_constructors_first` lint** — constructors must appear before field declarations in Dart classes
- **`freezed` `copyWith`** — generated for all `@freezed` models; `student.copyWith(...)` for partial updates
- **`mapOrNull` vs `maybeMap`** — `mapOrNull` returns `null` for unmatched patterns (no `orElse` required)
- **Drift `transaction()`** — wraps multiple DAO operations atomically; use for write + sync_queue enqueue pattern
- **`SyncQueueTableCompanion.insert()`** — requires all non-nullable fields; `payload` is a JSON string (use `jsonEncode({...})`)
- **Router redirect re-evaluation** — fires when `_RouterNotifier.notifyListeners()` is called; `authProvider` state change always triggers this
- **Story 1.9 review P3** — Router redirect has `if (authValue.hasError) return null` — `editProfile()` failure does NOT boot the user to `/login`
- **No `build_runner` for method additions** — only changes to `@DriftAccessor`, `@riverpod`, or `@freezed` annotations require regeneration; adding a plain method does not
- **`ref.read()` in `initState()`** — always use `ref.read()` (not `ref.watch()`) in `initState()`

### References

- [Source: epics.md#Story 1.10] — Acceptance criteria: profile fields (name, district, school), SnackBar "Profile updated", discard on back, offline behavior
- [Source: epics.md#FR4] — "A student can update their profile information (name, district, school)"
- [Source: architecture.md#Flutter Architecture] — `lib/features/auth/presentation/profile_screen.dart` is in the defined directory structure
- [Source: architecture.md#Data Architecture] — Write path: Drift + sync queue enqueue in same transaction; no direct Supabase write from repository
- [Source: 1-9-student-onboarding-profile-setup-and-notification-permission.md#Dev Notes] — `_sriLankanDistricts` constant list, `_schoolSuggestions` list, `Autocomplete` `fieldViewBuilder` pattern, `updateProfileFields()` DAO pattern, router redirect behavior after auth state update
- [Source: 1-9-student-onboarding-profile-setup-and-notification-permission.md#Review Findings] — P3: Router `AsyncError` guard already in place; confirms `/profile` route is safe

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- Used `initialValue:` on `DropdownButtonFormField` (matching OnboardingScreen pattern) instead of `value:` which is deprecated in Flutter 3.33+
- Added `import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart'` to bring `AuthStatePatterns` extension (`mapOrNull`) into scope in `ProfileScreen`

### Completion Notes List

- Added `StudentDao.updateStudentProfile()`: single Drift transaction writing name/district/school/last_active_at + sync queue entry
- Added `AuthRepository.editProfile()` interface method and `AuthRepositoryImpl` implementation: calls DAO, reads back updated row, maps to `Student` domain object
- Added `AuthNotifier.editProfile()`: captures student ID before setting loading state, folds result into auth state
- Created `ProfileScreen` (`ConsumerStatefulWidget`): name TextFormField + district DropdownButtonFormField + school Autocomplete, dirty tracking, inline name validation, SnackBar feedback
- Added `/profile` GoRoute (top-level, outside ShellRoute) in `router.dart`
- Added profile `IconButton` to `ScaffoldWithNavBar` AppBar
- 4 new tests added (2 repository, 2 notifier); all 41 tests pass; `flutter analyze` → 0 issues

### File List

- `lib/core/database/daos/student_dao.dart` (modified — added `updateStudentProfile()`)
- `lib/features/auth/domain/auth_repository.dart` (modified — added `editProfile()` signature)
- `lib/features/auth/data/auth_repository_impl.dart` (modified — implemented `editProfile()`)
- `lib/features/auth/presentation/auth_notifier.dart` (modified — added `editProfile()`)
- `lib/features/auth/presentation/profile_screen.dart` (created)
- `lib/router.dart` (modified — added `/profile` route + AppBar to `ScaffoldWithNavBar`)
- `test/features/auth/data/auth_repository_impl_test.dart` (modified — 2 new `editProfile` test cases)
- `test/features/auth/presentation/auth_notifier_test.dart` (modified — 2 new `editProfile` test cases)

### Review Findings

- [x] [Review][Patch] Trim whitespace from `_originalName` and `_originalSchool` in `initState` — if Drift stores a trailing space, any field interaction falsely marks the form dirty [profile_screen.dart:295-296]
- [x] [Review][Patch] `editProfile()` repository success test mocks `getStudent()` returning `name: 'Test User'` but claims to verify "updated name" — fix by having the mock return `name: 'New Name'` so the assertion actually validates the name round-trip [auth_repository_impl_test.dart, editProfile success group]
- [x] [Review][Defer] `setFcmPermission` missing `if (state.isLoading) return;` concurrency guard [auth_notifier.dart] — deferred, pre-existing (story 1-9)
- [x] [Review][Defer] `signOut()` hard-deletes local Drift row — on same-device re-login after reinstall, district/school may need re-onboarding [auth_repository_impl.dart] — deferred, pre-existing (story 1-8)
- [x] [Review][Defer] `_handleAuthStateChange` Future discarded via `whenData` — unhandled exception silently dropped if `getCurrentUser()` throws internally [auth_notifier.dart] — deferred, pre-existing (story 1-8)
- [x] [Review][Defer] Profile screen `initState` captures empty values during brief `authProvider` AsyncLoading window — empty fields shown if user deep-links to `/profile` during cold-start [profile_screen.dart:292] — deferred, pre-existing auth-loading pattern

## Change Log

- 2026-04-26: Story created by create-story workflow. (claude-sonnet-4-6)
- 2026-04-26: Story implemented — all 6 tasks complete. ProfileScreen created, editProfile() added to DAO/Repository/Notifier, /profile route registered, profile icon added to ScaffoldWithNavBar AppBar, 4 new tests added. (claude-sonnet-4-6)
