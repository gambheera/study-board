# Story 1.5: Firebase Initialization & FCM Token Infrastructure

Status: done

## Story

As a developer,
I want Firebase fully initialized with Crashlytics and FCM token capture on first launch,
so that experiment instrumentation is clean from day one and every student's nudge data is reliable.

## Acceptance Criteria

1. **Given** `main.dart` calls `Firebase.initializeApp()` **When** the app starts **Then** `FirebaseCrashlytics` and `FirebaseMessaging` are both initialized before `runApp()` is called — no Firebase feature is used before initialization completes

2. **Given** a student's first app launch **When** the app completes initialization **Then** `FirebaseMessaging.instance.getToken()` is called, the FCM token is persisted to `students.fcm_token` in Supabase, and this operation completes without blocking or delaying the UI

3. **Given** FCM token rotation (token refresh event fires) **When** `FirebaseMessaging.instance.onTokenRefresh` emits a new token **Then** the new token overwrites `students.fcm_token` in Supabase within one sync cycle and the old token is no longer used

4. **Given** a student denies notification permission on Android 13+ **When** FCM token retrieval returns null **Then** the app does not crash, `students.fcm_token` remains null in Supabase, `notifications_enabled` is set to `false` in Drift, and all app features work normally (FR46)

5. **Given** FCM is unreachable due to no connectivity on first launch **When** token retrieval fails **Then** the failure is logged to Crashlytics as a non-fatal event, token capture is retried on the next app foreground with active connectivity, and the user experiences no error or delay

6. **Given** Crashlytics is active **When** an unhandled Flutter error or non-fatal exception occurs **Then** it is reported to the Firebase Crashlytics dashboard with the correct stack trace and no user-facing crash dialog appears for non-fatal events

## Tasks / Subtasks

- [x] Task 1: Verify Firebase is fully initialized (AC: #1, #6)
  - [x] Confirm `bootstrap.dart` already calls `Firebase.initializeApp()` with `DefaultFirebaseOptions.currentPlatform` before `runApp()` — DO NOT recreate this
  - [x] Confirm `FlutterError.onError` and `PlatformDispatcher.instance.onError` already forward to `FirebaseCrashlytics.instance.recordFlutterFatalError` / `recordError` in `bootstrap.dart` — DO NOT recreate this
  - [x] Note in dev record: `firebase_options.dart` is a placeholder — developer must run `flutterfire configure --project=<studyboard-firebase-project>` to populate real credentials; the placeholder intentionally causes `Firebase.initializeApp()` to throw in non-debug builds, which is caught by the existing `try/catch` in `bootstrap.dart`

- [x] Task 2: Create `NotificationService` (AC: #2, #3, #4, #5)
  - [x] Create `studyboard_mobile/lib/features/notifications/data/notification_service.dart`
  - [x] Implement `NotificationService` class (NOT a Riverpod notifier — just a plain service class):
    - `Future<String?> getFcmToken()`: calls `FirebaseMessaging.instance.getToken()`, wraps in try/catch — on `FirebaseException` or any error, calls `FirebaseCrashlytics.instance.recordError(error, stack, fatal: false, reason: 'FCM token retrieval failed')` and returns `null`; returns `null` naturally when permission is denied (token is null without throwing)
    - `Stream<String> get onTokenRefresh`: returns `FirebaseMessaging.instance.onTokenRefresh` directly
  - [x] Do NOT call `FirebaseMessaging.requestPermission()` in this service — permission is handled in Story 1.9 (onboarding flow)
  - [x] Do NOT call `StudentDao` from within `NotificationService` — the service is a thin FCM wrapper; persistence is wired by callers (Stories 1.6/1.8/1.9)

- [x] Task 3: Add `updateFcmToken()` to `StudentDao` (AC: #2, #3, #4)
  - [x] Open `studyboard_mobile/lib/core/database/daos/student_dao.dart`
  - [x] Add method `Future<void> updateFcmToken(String studentId, String? fcmToken)` as a Drift transaction:
    - Derives `notificationsEnabled = fcmToken != null`
    - Writes `fcmToken` and `notificationsEnabled` to `studentsTable` WHERE `id == studentId` using `StudentsTableCompanion(fcmToken: Value(fcmToken), notificationsEnabled: Value(notificationsEnabled))`
    - Enqueues a `sync_queue` entry in the SAME transaction: `entity_type: 'student'`, `entity_id: studentId`, `operation: 'upsert'`, `payload: jsonEncode({'student_id': studentId, 'fcm_token': fcmToken, 'notifications_enabled': notificationsEnabled})`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` to regenerate `student_dao.g.dart`

- [x] Task 4: Create Riverpod provider for `NotificationService` (AC: #2, #3)
  - [x] Create `studyboard_mobile/lib/features/notifications/data/notification_provider.dart`
  - [x] Add `@Riverpod(keepAlive: true) NotificationService notificationService(Ref ref)` returning `NotificationService()`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` to generate `notification_provider.g.dart`

- [x] Task 5: Write unit tests (AC: #2, #4, #5)
  - [x] Create `studyboard_mobile/test/features/notifications/data/notification_service_test.dart`
  - [x] Mock `FirebaseMessaging` using mocktail — use `@GenerateMocks` or `registerFallbackValue` as needed
  - [x] Test cases:
    - `getFcmToken returns token string on success`
    - `getFcmToken returns null when FirebaseException is thrown` (verifies Crashlytics.recordError is called)
    - `getFcmToken returns null when token is null (permission denied)` — no exception, no crash
    - `onTokenRefresh exposes FirebaseMessaging.instance.onTokenRefresh stream`

- [x] Task 6: Validate and finalize (AC: all)
  - [x] `flutter analyze` → 0 issues under `very_good_analysis` rules
  - [x] `flutter test` → all existing tests still pass (no regressions to Stories 1.1–1.4); new tests pass
  - [x] Verify `FirebaseMessaging` is NOT called from any file outside `lib/features/notifications/data/` (grep check)

### Review Findings

- [x] [Review][Patch] Rename `_analytics` getter to `_crashlyticsInstance` — misleads maintainers searching for analytics instrumentation [notification_service.dart:15-16]
- [x] [Review][Patch] Guard `recordError` call with nested try/catch — if Crashlytics throws (e.g. Firebase not init in debug), original FCM error is swallowed and caller receives an exception instead of `null` [notification_service.dart:23-30]
- [x] [Review][Patch] Verify row-affected count before inserting sync queue entry in `updateFcmToken` — Drift `update()` silently no-ops on unknown `studentId` but the transaction still enqueues a phantom sync payload [student_dao.dart:74-95]
- [x] [Review][Patch] Add test case for non-`FirebaseException` generic `Object` error in `getFcmToken` — `on Object catch` is tested only for `FirebaseException`; a generic throw is untested [notification_service_test.dart]
- [x] [Review][Defer] `onTokenRefresh` exposes raw stream with no error guard — caller responsibility; callers should add `.handleError` [notification_service.dart:35] — deferred, caller responsibility
- [x] [Review][Defer] Concurrent `updateFcmToken` calls produce duplicate sync-queue entries — no idempotency on `(entityType, entityId, operation)`; deduplication is an Epic 5 concern [student_dao.dart:70-96] — deferred, Epic 5 scope

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

**All of the following already exist and are production-ready:**

- `bootstrap.dart` — `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` is already called before `runApp()`, wrapped in try/catch (AC #1 ✅)
- `bootstrap.dart` — `FlutterError.onError` and `PlatformDispatcher.instance.onError` already forward errors to `FirebaseCrashlytics.instance` in non-debug builds (AC #6 ✅)
- `lib/firebase_options.dart` — placeholder file already present; DO NOT modify — developer populates it with `flutterfire configure`
- `pubspec.yaml` — `firebase_core: ^4.7.0`, `firebase_crashlytics: ^5.2.0`, `firebase_messaging: ^16.2.0` already declared ✅
- `students` table in Drift — has `fcm_token TEXT nullable` and `notifications_enabled BOOLEAN DEFAULT true` columns already ✅
- `StudentDao` — has `upsertStudent()`, `deactivate()`, `softDelete()`, `updateLastActiveAt()` — extend it, don't replace it
- `repository_base.dart` — `trySupabase<T>()` helper exists; `NotificationService` does NOT extend `RepositoryBase` (it's a service, not a Supabase repository)

**AC #1 and AC #6 are fully satisfied by existing `bootstrap.dart`.** This story's implementation work covers ACs #2–#5.

### firebase_options.dart — Placeholder Pattern

`lib/firebase_options.dart` currently contains `REPLACE_WITH_*` placeholder strings. The `bootstrap.dart` try/catch handles the `Firebase.initializeApp()` failure gracefully in debug mode — the app can run and be UI-tested before real Firebase credentials are wired up. In release builds, `if (!kDebugMode) rethrow` ensures the failure surfaces during staging/production testing.

To populate real credentials:
```bash
# From studyboard-mobile/ (project root)
dart pub global activate flutterfire_cli
flutterfire configure --project=<studyboard-firebase-project-id>
# This overwrites firebase_options.dart + generates android/app/google-services.json
```

Do NOT commit `google-services.json` with real credentials to public repos.

### `NotificationService` Design

```dart
// lib/features/notifications/data/notification_service.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  const NotificationService();

  /// Returns the FCM registration token for this device, or null if:
  /// - Permission was denied (Android 13+)
  /// - FCM is unreachable (no connectivity on first launch)
  ///
  /// On failure, logs a non-fatal event to Crashlytics and returns null.
  /// Never throws.
  Future<String?> getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (error, stack) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: false,
        reason: 'FCM token retrieval failed',
      );
      return null;
    }
  }

  /// Stream of FCM token refreshes. Callers subscribe once per authenticated
  /// session and call StudentDao.updateFcmToken() on each new token.
  Stream<String> get onTokenRefresh => FirebaseMessaging.instance.onTokenRefresh;
}
```

**Key design decisions:**
- `const` constructor — stateless service, safe to instantiate multiple times
- Returns `null` on ANY token failure — no distinction between permission denied vs. network error from the caller's perspective; both result in null token + `notifications_enabled = false`
- Non-fatal Crashlytics logging happens INSIDE `getFcmToken()` — callers don't need to know about it
- `onTokenRefresh` delegated directly — no buffering or state

### `StudentDao.updateFcmToken()` Pattern

```dart
// Add to lib/core/database/daos/student_dao.dart

Future<void> updateFcmToken(String studentId, String? fcmToken) =>
    transaction(() async {
      final notificationsEnabled = fcmToken != null;
      final now = DateTime.now().toUtc().toIso8601String();

      await (update(studentsTable)..where((t) => t.id.equals(studentId))).write(
        StudentsTableCompanion(
          fcmToken: Value(fcmToken),
          notificationsEnabled: Value(notificationsEnabled),
        ),
      );

      await into(syncQueueTable).insert(
        SyncQueueTableCompanion.insert(
          id: _uuid.v4(),
          entityType: 'student',
          entityId: studentId,
          operation: 'upsert',
          payload: jsonEncode({
            'student_id': studentId,
            'fcm_token': fcmToken,
            'notifications_enabled': notificationsEnabled,
          }),
          createdAt: now,
        ),
      );
    });
```

**Why in a Drift transaction:** FCM token update and sync queue enqueue must be atomic — if the Drift write succeeds but the sync queue enqueue doesn't, the Supabase token will be stale. Same pattern as `deactivate()` and `softDelete()` in the same DAO.

**`notificationsEnabled = fcmToken != null`:** If token is null (permission denied), `notifications_enabled = false` is set. When token arrives later (permission granted, retry succeeds), `notifications_enabled = true` is set automatically. No separate boolean parameter needed.

### Riverpod Provider Pattern

```dart
// lib/features/notifications/data/notification_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/notifications/data/notification_service.dart';

part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return const NotificationService();
}
```

`keepAlive: true` — notification service must persist for the full app lifetime to maintain the `onTokenRefresh` subscription.

### How FCM Token Persistence Connects to Auth Flow

**Story 1.5 establishes the infrastructure.** The wiring to the auth flow happens in Stories 1.6/1.8/1.9. The calling pattern for those stories:

```dart
// In auth notifier (Story 1.6/1.8) — AFTER successful registration or login
final notificationService = ref.read(notificationServiceProvider);
final studentDao = ref.read(databaseProvider).studentDao;

// Non-blocking — token fetch must not delay navigation (AC #2)
unawaited(() async {
  final token = await notificationService.getFcmToken();
  await studentDao.updateFcmToken(studentId, token);
}());

// Set up token refresh listener — persists for auth session
notificationService.onTokenRefresh.listen((newToken) {
  unawaited(studentDao.updateFcmToken(studentId, newToken));
});
```

Story 1.9 (onboarding) calls `FirebaseMessaging.requestPermission()` for Android 13+, then calls `notificationService.getFcmToken()` + `studentDao.updateFcmToken()` to persist the result after the permission response.

### Testing Firebase Messaging with Mocktail

`FirebaseMessaging.instance` is a singleton. Mocking requires setting up the `FirebaseApp` or using dependency injection. For unit tests, use constructor injection:

```dart
// Alternative: make NotificationService accept an optional FirebaseMessaging instance
class NotificationService {
  const NotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging;  // defaults to instance when null

  final FirebaseMessaging? _messaging;
  FirebaseMessaging get _fcm => _messaging ?? FirebaseMessaging.instance;
  
  Future<String?> getFcmToken() async {
    try {
      return await _fcm.getToken();
    } catch (error, stack) { ... }
  }
  
  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;
}
```

In tests, inject a `MockFirebaseMessaging()` via the constructor. The production provider passes `const NotificationService()` (null → uses `FirebaseMessaging.instance`).

> Note: `FirebaseMessaging` from `firebase_messaging: ^16.2.0` can be mocked with mocktail. If `FirebaseMessaging` requires `registerFallbackValue`, add it in `setUpAll` (same pattern as `SignOutScope` in Story 1.4 tests).

### Previous Story Learnings (Accumulated 1.1–1.4)

- **`dart run build_runner build --delete-conflicting-outputs`** from `studyboard_mobile/` — NOT `flutter pub run build_runner`; after adding `updateFcmToken()` to `StudentDao`, regenerate `student_dao.g.dart`
- **Riverpod 4.x**: `@Riverpod(keepAlive: true)` with plain `Ref` (not `NotificationServiceRef`); generated provider name is lowercase: `notificationServiceProvider`
- **`very_good_analysis`** requires `package:` imports everywhere in `lib/`; no relative imports
- **`sort_constructors_first` lint rule**: constructors (including factory) must come before field declarations in the class body — apply to `NotificationService` if it has fields
- **`unawaited()`** wrapper required for `Future`-returning calls in non-async contexts under strict lint rules (e.g., test tearDown that returns a Future)
- **`abstract interface class`** — NOT needed for `NotificationService` (it's a concrete class, not a repository interface); the architecture doc has no `notifications/domain/` layer
- **`student.dart` already exists** — never redefine `Student`; `StudentDto` is in `auth/data/models/student_dto.dart`
- **`repository_base.dart` is complete** — `NotificationService` does NOT extend it (it's not a Supabase repository)
- **`sync_queue` and `sync_error_log` tables have `student_id` column in Supabase** (added in Story 1.4 review) — mirror this if adding new sync_queue entries

### Architecture Compliance Checklist

- [ ] `notification_service.dart` is in `lib/features/notifications/data/` only — no domain layer needed
- [ ] `NotificationService` does NOT import `supabase_flutter` or call Supabase directly — it is FCM only
- [ ] `FirebaseMessaging` is accessed ONLY from `notification_service.dart` — nowhere else in the codebase
- [ ] `updateFcmToken()` uses a Drift transaction (Drift write + sync queue enqueue in same tx)
- [ ] `notificationsEnabled = fcmToken != null` — derived, not passed as parameter
- [ ] `@Riverpod(keepAlive: true)` on `notificationServiceProvider`
- [ ] NO call to `Firebase.initializeApp()` in this story — already in bootstrap.dart
- [ ] NO recreation of `FlutterError.onError` or `PlatformDispatcher.instance.onError` — already in bootstrap.dart
- [ ] `dart run build_runner build --delete-conflicting-outputs` run after adding DAO method
- [ ] `flutter analyze` → 0 issues
- [ ] `flutter test` → all pass (no regressions to Stories 1.1–1.4 tests)

### Anti-Patterns to Avoid

- ❌ Calling `Firebase.initializeApp()` again — already in `bootstrap.dart`; a second call throws a duplicate app error
- ❌ Re-setting `FlutterError.onError` — already configured in `bootstrap.dart`; overwriting it breaks existing Crashlytics hooks
- ❌ Calling `FirebaseMessaging.requestPermission()` in `NotificationService` — permission dialog is Story 1.9 (onboarding flow); this story only captures the token
- ❌ `NotificationService extends RepositoryBase` — it's not a Supabase repository; no `trySupabase()` needed
- ❌ Calling `StudentDao.updateFcmToken()` directly from `NotificationService` — the service is a thin FCM wrapper; the auth layer wires the persistence
- ❌ Importing `notification_service.dart` from `domain/` or `presentation/` files outside notifications feature — callers use `notificationServiceProvider`
- ❌ Using `firebase_messaging: ^16.x` `requestNotificationPermissions()` (iOS only, deprecated) — use `requestPermission()` in Story 1.9
- ❌ Setting `notifications_enabled` separately from FCM token — always derive it from `fcmToken != null` in `updateFcmToken()`

### Project Structure Notes

**Files to CREATE:**
```
studyboard_mobile/
└── lib/features/notifications/
    └── data/
        ├── notification_service.dart        # NotificationService class
        └── notification_provider.dart       # @Riverpod(keepAlive: true) notificationServiceProvider
```

**Generated files (after build_runner):**
```
lib/features/notifications/data/notification_provider.g.dart  # notificationServiceProvider
lib/core/database/daos/student_dao.g.dart                     # REGENERATED with updateFcmToken()
```

**Files to MODIFY:**
```
lib/core/database/daos/student_dao.dart  # Add updateFcmToken() method
```

**Files to CREATE for tests:**
```
test/features/notifications/data/notification_service_test.dart
```

**Files NOT to modify:**
- `lib/bootstrap.dart` — Firebase init and Crashlytics hooks already complete
- `lib/firebase_options.dart` — placeholder; developer populates via `flutterfire configure`
- `lib/core/supabase/repository_base.dart` — complete as-is
- Any Drift schema table files from Story 1.3
- Any auth files from Story 1.4

### References

- [Source: epics.md#Story 1.5] — Acceptance criteria, FCM token capture requirements
- [Source: architecture.md#Flutter Architecture] — `features/notifications/data/notification_service.dart` location
- [Source: architecture.md#Infrastructure & Deployment] — Firebase Crashlytics same project as FCM
- [Source: architecture.md#Communication Patterns] — Drift-first + sync queue enqueue in same transaction
- [Source: 1-4-supabase-project-setup-and-row-level-security.md#Previous Story Learnings] — build_runner, Riverpod 4.x, `package:` imports, lint rules
- [Source: 1-4-supabase-project-setup-and-row-level-security.md#Dev Agent Record] — SignOutScope registerFallbackValue pattern for mocktail tests
- [Source: bootstrap.dart] — Firebase already initialized; Crashlytics already wired

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- Task 2: `NotificationService` uses constructor injection for both `FirebaseMessaging` and `FirebaseCrashlytics` (optional nullable params) instead of a single-field design — this enables unit testing via mocktail without needing to set `FirebaseCrashlytics.instance` (which has no setter). Production code passes `const NotificationService()` (null defaults → singletons used); tests inject mocks via constructor.
- Task 2: `on Object catch` used instead of bare `catch` to satisfy `very_good_analysis` lint rule `avoid_catches_without_on_clauses`.
- Task 2: `fatal: false` removed from `recordError` call — it is the default value and `very_good_analysis` flags redundant arguments.
- Task 5: `registerFallbackValue(StackTrace.empty)` added in `setUpAll` so mocktail can match `any<StackTrace?>()` arguments in `recordError` stubs and verifications.
- Task 5: `FirebaseException` imported from `package:firebase_core/firebase_core.dart`.

### Completion Notes List

- **AC #1 / #6**: Confirmed satisfied by existing `bootstrap.dart` — `Firebase.initializeApp()` called before `runApp()`, `FlutterError.onError` and `PlatformDispatcher.instance.onError` wired to Crashlytics. No changes made.
- **AC #2 / #3**: `NotificationService.getFcmToken()` and `onTokenRefresh` created. `StudentDao.updateFcmToken()` added as a Drift transaction (Drift write + sync queue enqueue atomic). `notificationsEnabled` derived from `fcmToken != null`.
- **AC #4**: `getFcmToken()` returns null (no throw) when `getToken()` returns null (permission denied). `notificationsEnabled = false` set automatically via `updateFcmToken(studentId, null)` by callers.
- **AC #5**: `getFcmToken()` catches all errors via `on Object catch`, logs non-fatal to Crashlytics, returns null. Callers (Stories 1.6/1.8/1.9) retry on next foreground.
- `@Riverpod(keepAlive: true)` applied — service persists for full app lifetime to keep `onTokenRefresh` subscription active.
- `flutter analyze`: 0 issues. `flutter test`: 61/61 pass (4 new, 57 existing, no regressions).
- `FirebaseMessaging` confined to `lib/features/notifications/data/notification_service.dart` only (grep verified).

### File List

**Created:**
- `studyboard_mobile/lib/features/notifications/data/notification_service.dart`
- `studyboard_mobile/lib/features/notifications/data/notification_provider.dart`
- `studyboard_mobile/lib/features/notifications/data/notification_provider.g.dart`
- `studyboard_mobile/test/features/notifications/data/notification_service_test.dart`

**Modified:**
- `studyboard_mobile/lib/core/database/daos/student_dao.dart` — added `updateFcmToken()` method

## Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2026-04-18 | 1.0 | Story created — Firebase/FCM token infrastructure | claude-sonnet-4-6 |
| 2026-04-18 | 1.1 | Implemented NotificationService, updateFcmToken(), Riverpod provider, unit tests; flutter analyze 0 issues, 61/61 tests pass | claude-sonnet-4-6 |
