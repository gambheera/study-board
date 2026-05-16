# Deferred Work

## Deferred from: code review of 4-3-quiz-failure-pivot-question-and-recovery-path (2026-05-11)

- `total == 0` inside `advanceOrComplete` causes silent UI hang — state stays `QuizActive` with Continue button tappable but inert; impossible in practice since `build()` requires at least one question to succeed (`quiz_notifier.dart`).
- Floating-point `passThreshold` could misclassify pass/fail on non-power-of-2 score fractions — theoretical only for current integer-fraction scoring against whole-number thresholds (`quiz_notifier.dart`).
- `_AnswerChip` renders blank if `correctOption` stored value is not in `{'a','b','c','d'}` — pre-existing data-quality risk; related to existing correctOption case-normalisation defer item (`quiz_fail_screen.dart`).
- `getAttemptsForLesson` called after `saveAttempt` without a wrapping transaction — a concurrent write between the two calls could inflate `failedAttemptCount` by 1, causing the 3rd-attempt note to appear one failure early; extremely rare in practice (`quiz_notifier.dart`).

## Deferred from: code review of 4-2-quiz-pass-task-completion-gate-and-dopamine-moment (2026-05-11)

- markTaskComplete and saveAttempt run in separate Drift transactions — partial failure leaves task done with no attempt record (`quiz_notifier.dart:74-90`). Spec explicitly defers Drift write error handling; "Drift writes are expected to succeed" per dev notes.
- lessonTitle silently degrades to empty string on deep-link or process restart — GoRouter `extra` is not persisted across process death; pass screen renders " — complete." with no lesson name (`router.dart:109`). GoRouter architectural limitation; not addressable without a separate lookup or re-fetch mechanism.
- `_showLeaveDialog` in QuizScreen captures outer BuildContext in the Leave dialog callback without a `context.mounted` guard (`quiz_screen.dart:_showLeaveDialog`). Very low practical risk since the dialog blocks UI; pre-existing Flutter pattern.
- `getQuizContextForTask` uses `getSingleOrNull()` which throws unguarded `StateError` (not `Exception`) if >1 `lessonTasksTable` row matches `taskId`; not caught by the `on Exception` handler in `QuizRepositoryImpl` (`quiz_dao.dart:getQuizContextForTask`). DB integrity guarantee; taskId uniqueness enforced by app data model.

## Deferred from: code review of 4-1-quiz-screen-and-question-engine (2026-05-07)

- `sagGreen` misspelling in `app_colors.dart` perpetuated into new quiz code (`quiz_answer_option.dart:64`) — rename `sagGreen` → `sageGreen` across all files in a dedicated cleanup pass.
- `toSet().toList()` in `getAllImageUrlsInTopicOrder` implicitly relies on Dart `LinkedHashSet` insertion-order preservation — replace with an explicit seen-set loop to make ordering intent explicit (`content_dao.dart:43`).
- `result.fold((_) => null, ...)` in `ContentSyncNotifier` silences all sync failures with no log, no user feedback, and no state update — intentional V1 design decision; add error surfacing when sync reliability is hardened in Epic 5.
- `QuizPassScreen`/`QuizFailScreen` extend `ConsumerWidget` without using `ref` — intentional scaffolding; Stories 4.2/4.3 will add Riverpod calls to these screens.
- `ref.listen` double-navigation micro-race: if `QuizScreen` rebuilds while `QuizCompleted` is still cached (e.g., during GoRouter transition), `context.go` fires a second time — guarded by `context.mounted`; GoRouter stack replacement disposes the auto-dispose provider; revisit if navigation flicker is reported (`quiz_screen.dart:23`).
- `correctOption` case not normalised on Supabase ingest — if Supabase returns uppercase `'A'`–`'D'`, every answer scores wrong silently; add `.toLowerCase()` in `content_repository_impl.dart` when ingest is hardened.
- `getQuizContextForTask` 4-way JOIN fetches full row data from all four tables to project only `lessonId` and `passThreshold` — consider a raw SQL projection query for performance when quiz DAO is optimised (`quiz_dao.dart:66`).
- `saveAttempt` sync-queue JSON payload omits `score` and `passed` fields — Stories 4.2/4.3 are responsible for recording quiz attempts; fix payload when that work lands (`quiz_dao.dart:44`).

## Deferred from: code review of 3-3-content-image-pre-fetch-and-background-sync (2026-05-03)

- Connectivity guard in `ContentSyncNotifier.build()` uses a double-negative (`!connectivity.any((r) => r != ConnectivityResult.none)`) — logic is correct but high maintenance-bug risk; extract to a named helper `_isConnected(List)` when the sync layer is hardened in Story 5.1.
- No content-version change detection — `syncContent` runs unconditionally on every app open regardless of whether the remote `content_version` has changed; explicit V1 design decision per dev notes ("unconditional sync satisfies V1 requirement"); implement version-gated sync in Story 4.x / 5.x.
- `_applyDiff` O(n²) removal and insertion passes (`newItems.any(...)` inside linear loops) — bounded by chemistry syllabus size (~300 lessons); revisit with indexed lookups if list size or stream emission frequency grows in a future subject expansion.
- Orphaned fire-and-forget `downloadFile` futures after `ContentSyncNotifier` provider disposal — `unawaited` futures have no lifecycle tie to the Riverpod container; low production impact, but causes "pending timers" warnings in widget tests; consider tracking in-flight futures with `CancelToken` if test-suite stability becomes an issue.

## Deferred from: code review of 3-2-lesson-content-screen-and-rich-media (2026-05-02)

- `clock: ^1.1.2` appears in pubspec.yaml diff from uncommitted prior-story changes; not introduced by story 3-2; verify origin and move to `dev_dependencies` if test-only.
- Rapid double-tap of "Take quiz" `FilledButton` double-pushes `/quiz/:taskId` — intentional per spec (AC #6 prohibits `PopScope`); consider debouncing the button in a future story if UX complaints arise.
- No `onTapLink` handler on `MarkdownBody` — markdown hyperlinks open system browser via `url_launcher`; spec does not address hyperlinks in lesson content; add an `onTapLink` guard if content authors include links.
- Rapid double-tap of Retry on autoDispose provider spawns orphaned futures — Riverpod silently drops writes from disposed notifiers; no crash, wasted DB round trip; negligible in V1.
- `completeCuriosity` `Future<void>` rethrows on DB failure with no UI surface at call sites — pre-existing from story 3-1; wrap in `try/catch` at the `CuriosityScreen` call site if error feedback is required.
- Manual `LessonDetails` → `LessonState` field mapping in `LessonNotifier.build()` has no compile-time completeness guarantee — a new `LessonDetails` field silently defaults in `LessonState`; add a unit test assertion when new domain fields are added.
- `MarkdownBody` re-parses full markdown AST on every parent `build()` call — wrap `_LessonContent` in a `RepaintBoundary` or memoize markdown rendering if scroll jank is reported on low-end devices.
- Test helper `_wrapScreen` uses `MaterialApp` not `MaterialApp.router` — any future test tapping "Take quiz" will throw `GoRouter not found`; update to `MaterialApp.router` before adding navigation tests.

## Deferred from: code review of 3-1-curiosity-first-warm-up-screen (2026-05-02)

- Sequential DAO reads in `LessonRepositoryImpl.getLessonDetails` without a wrapping Drift transaction — two separate `select` calls; an interleaved write on a different isolate could produce a misleading "Lesson not found" error. Single-user SQLite app; risk is theoretical but grows if the DAO is ever called from a background isolate.
- `_syncTabController` in `BoardScreen` disposes `TabController` synchronously inside `build()`, violating Flutter's rule against disposing attached objects mid-frame — pre-existing from story 2.3; fix by deferring disposal to a post-frame callback.
- `_applyDiff` in `_BoardColumnState` may produce a `RangeError` if two stream emissions are processed concurrently while an AnimatedList insertion animation is in flight — pre-existing board_screen animation logic from story 2.3.
- `_items` list is populated directly in the `data` branch of `build()` (`if (_items.isEmpty && dataItems.isNotEmpty) _items.addAll(dataItems)`) bypassing `_applyDiff`, which can desync the AnimatedList internal item count from `_items` on the next structural change — pre-existing from story 2.3.
- Auth redirect emits to `/login` on `hasError` from `authProvider` (e.g., transient token-refresh network error) while user is mid-lesson on `/curiosity/:taskId`, ejecting the session stack with no recovery — pre-existing router redirect logic from story 1.8.
- `district.isEmpty` onboarding check in router redirect passes a whitespace-only district string as a completed profile, permanently bypassing the onboarding screen for a student who submitted a blank district — pre-existing from story 1.8.

## Deferred from: code review of 2-4-session-activity-logging (2026-05-01)

- `deleteStudent` has no session row cleanup or sync queue entries — deletes `studentSubjectsTable` and `studentsTable` rows but leaves orphaned `sessionsTable` rows and any pending sync-queue entries for that student; out-of-scope method added by another story, cleanup belongs to the story implementing full account deletion (Story 8.3).
- `AppLifecycleState.detached` (process kill) leaves session unclosed — `detached` falls through to `break` with no `closeSession()` call; spec explicitly accepts null `endedAt` for forced-kill / crash scenarios in V1; session frequency metric counts by `started_at` so the record is not lost, just missing duration.
- `SessionTrackerNotifier._openSession()` reads auth snapshot — uses `ref.read(authProvider)` once at build time; session silently skipped if auth hasn't resolved when the notifier first builds; router redirect guards prevent this in practice (scaffold only mounts when `authenticated` state is confirmed), but becomes a fragility if the routing logic changes.

## Deferred from: code review of 2-2-backlog-view-full-syllabus-and-taskcard-component (2026-04-28)

- `TaskStatusX.fromString` throws `ArgumentError` for unknown DB status strings — pre-existing from Story 1.1 (already tracked below); now also reachable via `BacklogRepositoryImpl.watchBacklogTasks` stream, though the DAO query filters to `backlog` status making the risk theoretical until a new status string is added.
- ~~Re-opened state in `TaskCard`~~ — **CLOSED by Story 4.3**: `TaskStatus.reopened` added, `TaskCard` renders Dusty Rose border + refresh icon + "Re-opened" label.
- `_RouterNotifier` lifecycle in GoRouter+Riverpod — `ChangeNotifier` disposed via `ref.onDispose`; `Ref` listener tied to `goRouterProvider` lifetime; theoretical risk if provider ever disposes and recreates; standard pattern for this stack.
- `BacklogRow` class lives in `task_dao.dart` (data layer) despite naming a backlog-domain concept — spec-defined placement; refactor to private impl detail if the join struct is ever reused.
- `watchBacklogTasks` single `condition` variable combines predicates on two different tables — correct SQL, readability/maintenance opinion; separate base from join filter when adding further conditions.
- No subject-enrollment guard in `watchBacklogTasks` join — correctness gated by `createLessonTasksForStudent` seeding scope; add an explicit enrollment subquery if the seeding ever becomes unbounded.
- `BacklogItem.lessonOrderIndex` / `topicOrderIndex` fields not consumed by the UI — spec-defined, intended for future client-side grouping or test assertion of sort order.
- Error state in `BacklogScreen` swallows Drift stream errors silently — "Failed to load tasks." with no logging or retry; Drift stream errors are rare; add `debugPrint` and a retry mechanism when error-recovery UX is prioritised.
- `contentSyncProvider` kept alive via no-op `ref.listen` in `ScaffoldWithNavBar` — re-sync risk if shell remounts; document intent with a named variable or `// keep-alive: triggers content sync` comment.
- Onboarding redirect checks `student.district.isEmpty` only — `school` field not validated; a partial profile (district set, school empty) bypasses onboarding; use a dedicated `onboardingComplete` flag on the student record.

## Deferred from: code review of 2-1-chemistry-syllabus-content-seeding (2026-04-27)

- AC3+AC4 cross-track question coverage — AC3 requires every lesson to have a `past_paper_questions` record; AC4 requires every lesson to have a `quiz_questions` record. Current seeding scopes each type to its matching content_track (theory → quiz, past_papers → past paper question). Seeding is for mapping purposes; decide the hard coverage rule when the lesson content model is finalized in a later story.

- No pagination on Supabase `.select()` calls — PostgREST default 1000-row limit will silently truncate once content scales beyond 1000 rows per table. Add `.range()` or `.limit()` with pagination when the experiment expands.
- Sync errors silently swallowed by `ref.listen(contentSyncProvider, (_, _) {})` — a first-sync failure leaves the student with an empty offline DB and no feedback. Wire up error state display or a retry prompt in a future story.
- All content tables fetched globally regardless of student enrollment — fetches every subject, topic, and lesson in the entire DB. Will need per-student or per-enrollment filtering once more subjects are added.
- Sequential per-row `await` upserts inside `for` loops — each row is a separate Drift write. Use a Drift `transaction` per table when upsert volume grows.
- Unsafe `as String` hard-casts on nullable Supabase columns (e.g. `l['content_text'] as String`) — null values are misreported as `NetworkFailure`. Add null-safe access and proper error handling when the data pipeline becomes less controlled.

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
- ~~`taskReopened` ColorScheme token~~ — **CLOSED by Story 4.3**: `TaskStatus.reopened` enum value added; token is now in active use.
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

## Deferred from: code review of 1-7-google-sign-in-and-account-linking round 2 (2026-04-25)

- `_explicitSignOut` race — `signedOut` stream event may arrive while `signOut()` repository call is in-flight, consuming the flag before needed. Story 1.8.
- `ref.listen(authStateStreamProvider)` inside `build()` without `ref.onDispose` — programmatic `ref.invalidate` stacks duplicate listeners. Story 1.8; `keepAlive: true` prevents in normal usage.
- `state.value` null during `AsyncLoading` in `_handleAuthStateChange` — `tokenRefreshed` event while `signInWithGoogle()` in-flight evaluates as `currentlyUnauthenticated: true`. Story 1.8.
- `signOut()` uses Supabase default `scope: local` — remote sessions on other devices persist; re-login on fresh device loses district/school data from hard-deleted Drift row. Design decision.
- `sessionExpired` snackbar in `LoginScreen.initState` missed if `getCurrentUser()` hasn't resolved at first frame. Story 1.8.
- `signOut()` retry path — `currentUser` cleared by first failed attempt; `deleteStudent` skipped on retry leaving stale Drift row. Story 1.8, low severity.
- No UI lock on protected routes during sign-out — user can interact while sign-out in-flight. Story 1.8, design choice.
- `deleteStudent` hard delete with no `transaction()` and no `syncQueueTable` entry — inconsistent with other destructive DAO ops. Story 1.8.
- `signedIn`/`tokenRefreshed` stream event paths in `_handleAuthStateChange` have zero test coverage. Story 1.8.
- `updateLastActiveAt`-throws path in `signInWithEmailPassword` not tested. Story 1.8.
- `displayName ?? email` both empty → blank `name` in Drift. Pre-existing; pre-spec-deferred.
- Stream test `Completer` timeout 5 seconds — opaque `TimeoutException` instead of assertion failure. Minor.
- `signOut()` Drift `deleteStudent` failure after successful Supabase `signOut()` — `trySupabase` returns `Left(NetworkFailure)` but session is already cleared. Story 1.8.

## Deferred from: code review of 1-8-student-login-and-session-persistence (2026-04-25)

- D1: `notificationsEnabled`/`district`/`school` fabricated as defaults on reinstall for email-auth users — no server-side source of truth for these fields via Supabase auth metadata; proper fix requires a `students` table fetch. Deferred to Epic 5 sync story.
- D2: Hard DELETE in `deleteStudent()` bypasses the `softDelete`/`deactivate` tombstone pattern used by other destructive DAO operations — acceptable for local cache clearing; revisit when Story 5-x adds the sync-queue consumer to ensure no dangling FK references.
- D3: `authStateStream` listener set up inside `build()` only after the `getCurrentUser()` await — stream events (e.g., token refresh signedOut) fired during that await window are missed. Structural limitation of async `AsyncNotifier` with stream wiring; low-impact since `getCurrentUser()` already captures correct initial state.
- D4: `GoogleSignInButton` loading spinner activates during email/password sign-in (shared `authProvider.isLoading` state) — fixing requires per-operation loading state in `AuthState`; out of scope for this story.
- D5: `signInWithEmailPassword` Supabase success + Drift fail + cleanup `signOut` fail = orphaned Supabase session — pre-existing distributed-operation limitation; partially mitigated by `getCurrentUser()` minimal-row synthesis on next cold start.

## Deferred from: code review of 1-7-google-sign-in-and-account-linking (2026-04-19)

- Race condition on rapid double-tap of `GoogleSignInButton`: a second tap can call `authenticate()` before the `isLoading` state propagates to the button widget (one microtask gap). The concurrency guard in `AuthNotifier.signInWithGoogle()` is present but the UI has no local flag. Pre-existing pattern across all notifier methods; address with a local `_isSigningIn` bool if double-tap becomes a real user issue.
- `authStateStreamProvider` uses `ref.watch(authRepositoryProvider)` instead of `ref.read` — re-subscribes on any provider rebuild. Safe in practice because `authRepositoryProvider` is `keepAlive: true`, but semantically wrong. Fix when the stream provider is refactored as part of Story 1.8's session-wiring work.
- `_studentDao.updateLastActiveAt()` return value (rowcount) is discarded — TOCTOU: if the row is deleted between `getStudent()` and the update, the update silently no-ops and the caller returns stale data. Low-severity for V1 (10 known students); add a rowcount assertion when the delete flow (Story 8.2/8.3) is implemented.
- `googleUser.displayName ?? googleUser.email` fallback can produce `name: ''` in Drift for enterprise/SSO accounts with no display name and an empty email field. Not a realistic concern for 10 known students; add a non-empty name validation at the Drift boundary when broader rollout begins.
- On iOS, if the OS terminates the Google Sign-In `SFSafariViewController` while in background, the resulting exception is not a `GoogleSignInException` — it is caught by the outer `on Object` handler and shown as "Google Sign-In failed" rather than a no-op. Revisit with platform-specific exception handling if iOS backgrounding complaints arise.

## Deferred from: code review of 1-10-student-profile-edit (2026-04-26)

- `setFcmPermission` in `AuthNotifier` is missing the `if (state.isLoading) return;` concurrency guard present on all other mutating methods — pre-existing from story 1-9; low risk since FCM token updates are fire-and-forget.
- `signOut()` in `AuthRepositoryImpl` hard-deletes the local Drift student row after Supabase sign-out — on same-device re-login (email/password path), district/school are fabricated as empty strings and the user is redirected through onboarding again; pre-existing from story 1-8, tracked as D2.
- `_handleAuthStateChange` Future is discarded via `next.whenData(...)` — if `getCurrentUser()` throws internally (not via `Either`), the exception is silently dropped; pre-existing from story 1-8.
- `ProfileScreen.initState` captures `authProvider` values during `AsyncLoading` — deep-link to `/profile` during cold-start shows empty fields; pre-existing auth-loading pattern across all feature screens.
