# Deferred Work

## Deferred from: code review of 1-1-flutter-project-scaffold-and-core-architecture (2026-04-16)

- Font files absent — `assets/fonts/Nunito/` and `assets/fonts/JetBrainsMono/` contain only `.gitkeep` placeholders. Add real font files before Story 1.2 (theme system depends on them).
- JetBrains Mono declared as directory glob in `pubspec.yaml` — spec requires "Regular + Medium only." Once font files are added, switch to explicit per-file font asset entries to enforce the constraint.
- All three flavor `main_*.dart` files (`main_development.dart`, `main_staging.dart`, `main_production.dart`) are byte-identical. Add flavor-specific Supabase URLs, Crashlytics opt-out in dev, and environment tagging when flavor config is defined.
- `google_sign_in: ^7.2.0` declared but unused. Intentional; required for Story 1.7 (Google Sign-In).
- `firebase_messaging: ^16.2.0` declared with no `requestPermission()` call or token registration. Intentional; Story 1.5 + Story 1.9 scope.
- `drift` + `supabase_flutter` both declared with no offline sync layer, conflict-resolution strategy, or write-ordering contract. Intentional; Story 5.x (Offline Reliability & Background Sync) scope.
- `_selectedIndex` in `ScaffoldWithNavBar` defaults silently to 0 (Board tab) for any unrecognised path. Safe for Story 1.1's three-route setup; revisit when deep-links or redirect routes are introduced.

## Deferred from: code review of 1-2-app-theme-design-system-and-navigation-shell (2026-04-17)

- `PlatformDispatcher.onError` always returns `true`, suppressing fatal errors from the platform OS — pre-existing from Story 1.1; revisit for crash-diagnostic compliance.
- `_selectedIndex` returns 0 for any path not starting with `/dashboard` or `/backlog` — safe for current three-route shell; becomes incorrect when deep-links or non-shell routes are introduced.
- `goRouterProvider` calls `router.dispose()` on Riverpod disposal — harmless in production (single `ProviderScope`); can cause disposed-router errors in widget tests that use nested `ProviderScope` overrides.
- `taskReopened` ColorScheme token defined without a matching `TaskStatus.reopened` enum value — intentional forward-looking design; add the enum variant when the reopened workflow is implemented.
- `TaskStatusX.fromString` throws `ArgumentError` for unrecognised DB status values and wraps them as `NetworkFailure` — pre-existing from Story 1.1; fix the error classification when the status-parsing layer is hardened.
- `AppLocalizations.of(context)!` force-unwraps in generated l10n code — pre-existing from Story 1.1; guarded in practice by `MaterialApp` delegate setup.
- `google_fonts` package retained alongside bundled fonts (needed for `allowRuntimeFetching = false`); risk of future misuse via `GoogleFonts.*()` calls instead of the registered font family.
- `app_theme_test.dart:31` force-casts `theme.cardTheme.shape! as RoundedRectangleBorder` — produces `TypeError` instead of a readable failure if shape type ever changes; replace with `isA<RoundedRectangleBorder>()` matcher.
- `debugPrint` in Crashlytics `recordError` `.catchError` callback is a no-op in release builds — pre-existing from Story 1.1; silently swallows Crashlytics self-failures in production.

## Deferred from: code review of 1-3-complete-drift-database-schema (2026-04-17)

- No foreign key constraints anywhere in the schema — logical FKs (topicId, lessonId, studentId, attributedNudgeId) use no `.references()` calls; orphaned rows accumulate silently on delete. Offline-first design choice; defer FK enforcement to Epic 5 sync layer.
- No CHECK constraint on `sync_queue.operation` and `sync_error_log.operation` columns — valid values 'upsert'/'soft_delete' are unenforced at the DB level. The sync worker is the only writer in current scope; add the constraint when the sync worker (Story 5.1) is implemented.
- No CHECK constraints on `lessons.content_track` ('theory'|'past_papers'|'future_papers'), `quiz_questions.correct_option` ('a'|'b'|'c'|'d'), `nudge_events.status` ('sent'|'delivered'|'failed'). Add when content seeding (Story 2.1) and quiz engine (Story 4.1) are implemented.
- `AppDatabase.onUpgrade` is an empty no-op handler — correct for schemaVersion=1 with no upgrade history. Add a guard `assert(from >= to, 'No migration defined for v$from → v$to')` when schemaVersion is bumped to 2.
- `getWeakTopics` HAVING clause references a SELECT alias (`accuracy_percent`) — SQLite-specific behaviour; non-portable SQL. Acceptable for current SQLite-only target; note if DB backend ever changes.
- `getWeakTopics` excludes un-attempted topics (INNER JOIN on `quiz_attempts`) — by design decision: weak topics = topics with ≥1 attempt AND accuracy < 60%; un-attempted topics handled by the backlog/kanban flow, not the weak-topics feature.

## Deferred from: code review of 1-5-firebase-initialization-and-fcm-token-infrastructure (2026-04-18)

- `onTokenRefresh` exposes raw stream with no error guard — callers should add `.handleError`; caller responsibility by design (thin FCM wrapper pattern).
- Concurrent `updateFcmToken` calls can produce duplicate sync-queue entries for the same student — no idempotency key on `(entityType, entityId, operation)` in the sync queue; deduplication is an Epic 5 sync-worker concern.

## Deferred from: code review of 1-6-student-registration-emailpassword (2026-04-19)

- DEF1: `getCurrentUser()` reconstructs Student from Supabase auth user only — ignores Drift cache entirely, so `district`, `school`, and `notificationsEnabled` are never returned. Pre-existing design; address when session restore (Story 1.8) reads user from Drift.
- DEF2: `signOut()` calls `auth.signOut()` but does not delete the local Drift student row — next session (or another user on the same device) can read the previous user's cached profile. Outside Story 1.6 scope; fix in Story 1.8 (signOut flow).
- DEF3: `AuthNotifier.build()` always initializes to `AuthState.unauthenticated()` — no session check on cold start. Intentional Story 1.8 placeholder; `getCurrentUser()` call needed in `build()`.
- DEF4: Router has no auth guard — `/board`, `/dashboard`, `/backlog` accessible without authentication. Intentional; Story 1.8 adds `redirect` callback driven by `authStateStreamProvider`.
- DEF5: `authStateStream` provider is `keepAlive: true` but its session-change events (logout, token refresh) never propagate to `AuthNotifier.state`. Story 1.8 must wire this stream into the notifier.
- DEF6: `on_auth_user_created` trigger timing — the Drift local record is written immediately after `signUp()` returns, but the Postgres trigger may not have completed yet. The local Drift row may exist while the remote `students` row is absent for a brief window. Architectural; acceptable for V1 (10 known students, fast trigger); revisit if sync layer (Epic 5) needs row existence guarantee.
- DEF7: `getSessionStream()` on `AuthRepository` interface returns Supabase's own `AuthState` type (from `package:supabase_flutter`) — leaks a third-party type through the domain boundary. Pre-existing leaky abstraction; wrap in an app-owned `AuthEvent` type when the domain is hardened.

## Deferred from: code review of 1-6-student-registration-emailpassword round 2 (2026-04-19)

- DEF8: Race between Supabase `signedIn` stream event and Drift upsert — when Story 1.8 wires `authStateStream` into `AuthNotifier.build()`, the session-change event fires before `upsertStudent` completes, potentially navigating the user into the app with no local student row. Story 1.8 must ensure the stream listener only triggers navigation after the Drift write has completed (or check for row existence before navigating).
- DEF9: `response.session == null` guard returns `AuthFailure` with a success-flavoured message ("Account created! Check your email…"). If Supabase email confirmation is ever re-enabled, this message displays in red via the error widget, giving contradictory UX. Should be a distinct state (e.g. `AuthState.pendingEmailConfirmation`) or at minimum a non-error `Failure` subtype. Deferred — dead code path in V1 (email confirmation disabled).

## Deferred from: code review of 1-7-google-sign-in-and-account-linking (2026-04-19)

- Race condition on rapid double-tap of `GoogleSignInButton`: a second tap can call `authenticate()` before the `isLoading` state propagates to the button widget (one microtask gap). The concurrency guard in `AuthNotifier.signInWithGoogle()` is present but the UI has no local flag. Pre-existing pattern across all notifier methods; address with a local `_isSigningIn` bool if double-tap becomes a real user issue.
- `authStateStreamProvider` uses `ref.watch(authRepositoryProvider)` instead of `ref.read` — re-subscribes on any provider rebuild. Safe in practice because `authRepositoryProvider` is `keepAlive: true`, but semantically wrong. Fix when the stream provider is refactored as part of Story 1.8's session-wiring work.
- `_studentDao.updateLastActiveAt()` return value (rowcount) is discarded — TOCTOU: if the row is deleted between `getStudent()` and the update, the update silently no-ops and the caller returns stale data. Low-severity for V1 (10 known students); add a rowcount assertion when the delete flow (Story 8.2/8.3) is implemented.
- `googleUser.displayName ?? googleUser.email` fallback can produce `name: ''` in Drift for enterprise/SSO accounts with no display name and an empty email field. Not a realistic concern for 10 known students; add a non-empty name validation at the Drift boundary when broader rollout begins.
- On iOS, if the OS terminates the Google Sign-In `SFSafariViewController` while in background, the resulting exception is not a `GoogleSignInException` — it is caught by the outer `on Object` handler and shown as "Google Sign-In failed" rather than a no-op. Revisit with platform-specific exception handling if iOS backgrounding complaints arise.
