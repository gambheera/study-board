---
stepsCompleted: ["step-01-validate-prerequisites", "step-02-design-epics", "step-03-epic-1", "step-03-epic-2", "step-03-epic-3", "step-03-epic-4", "step-03-epic-5", "step-03-epic-6", "step-03-epic-7", "step-03-epic-8", "step-03-stories-complete", "step-04-final-validation"]
workflowStatus: complete
completedAt: "2026-04-15"
inputDocuments:
  - "_bmad-output/planning-artifacts/prd.md"
  - "_bmad-output/planning-artifacts/architecture.md"
  - "_bmad-output/planning-artifacts/ux-design-specification.md"
---

# StudyBoard - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for StudyBoard, decomposing the requirements from the PRD, UX Design Specification, and Architecture into implementable stories.

## Requirements Inventory

### Functional Requirements

**User Account Management**
- FR1: A student can register an account using email and password, or via Google Sign-In (OAuth)
- FR2: A student can log in using email and password, or via their linked Google account
- FR3: A student can link a Google account to their StudyBoard account for authentication
- FR4: A student can update their profile information (name, district, school)
- FR5: A student can deactivate their account, disabling access while retaining all data intact
- FR6: A student can request account deletion, removing their profile and progress from all student-facing views while anonymised historical logs are retained

**Syllabus & Task Board**
- FR7: A student can view the complete A/L Chemistry syllabus in a Backlog view — all tasks listed and available to be pulled into the active board
- FR8: A student can view their active tasks as a visual Kanban board with To-Do, In Progress, and Done columns, with lesson tasks displayed as movable cards
- FR9: A student can pull a task from the Backlog into the To-Do column on their active Kanban board
- FR10: A student can move a task card from To-Do to In Progress on the Kanban board
- FR11: A student can view tasks filtered by content track (Theory, Past Papers, Future Papers) across both Backlog and Kanban board views
- FR12: A student's board includes a Future Papers content track; architecturally present and visible in V1 but may contain no tasks
- FR13: A student can see the status of every lesson and sub-lesson at any time across both Backlog and Kanban board views
- FR14: The system prevents a student from moving a task to Done without passing its associated quiz

**Content & Learning Flow**
- FR15: A student is shown past paper questions from a lesson's topic before lesson content is displayed (curiosity-first flow — non-skippable)
- FR16: A student can access lesson content (notes, diagrams, rich media) for any lesson on their board
- FR17: A student can view rich media content including chemical formulas, molecular diagrams, and images within lessons and quiz questions
- FR18: A student can access lesson content and past paper questions without an internet connection
- FR19: A student's local content library updates automatically when new or updated syllabus content is available and connectivity is active

**Assessment & Progress Verification**
- FR20: A student can take a quiz for any lesson they are currently studying
- FR21: The system evaluates a student's quiz attempt and determines pass or fail based on the subject's configured threshold
- FR22: When a student fails a quiz, the lesson task re-opens to In Progress — framed neutrally as "not done yet"
- FR23: When a student passes a quiz, the lesson task is marked Done and closed
- FR24: A student can re-attempt a quiz immediately after failing, or return to it at any later time
- FR25: A student can access lesson content after a quiz failure to review before retrying
- FR26: The system records each quiz attempt's score and pass/fail outcome

**Progress Dashboard & Analytics**
- FR27: A student can view their overall syllabus coverage percentage (quiz-verified Done lessons vs. total lessons)
- FR28: A student can view their past paper completion percentage per topic
- FR29: A student can view their accuracy rate per topic across all quiz attempts
- FR30: A student can view a ranked list of their weakest topics, sorted by accuracy ascending
- FR31: The system displays a student's progress relative to the subject's configured completion threshold (Chemistry = 80%)
- FR32: A student can view their current engagement streak (consecutive days of app activity)

**Engagement & Motivation**
- FR33: The system delivers haptic feedback when a student completes a task
- FR34: The system displays a visual reward animation when a student completes a task
- FR35: The system maintains and displays a streak counter tracking consecutive days of app use
- FR36: The system resets a student's streak counter when a day is missed, without penalty or punishing UI
- FR37: A student can respond to a periodic in-app satisfaction and stress survey presented in a lightweight, fun quiz format
- FR38: The system records in-app survey responses for validation and product analysis

**Offline & Sync**
- FR39: A student can access all lesson content, quiz questions, and their task board without an internet connection
- FR40: A student can complete quizzes and update task status without an internet connection, with all changes persisted locally
- FR41: The system automatically syncs locally-stored changes to the server within 5 seconds of connectivity returning
- FR42: The system detects network state changes and triggers sync without requiring user action
- FR43: The system does not interrupt or degrade an active session when connectivity state changes

**Notifications**
- FR44: The system sends an engagement nudge notification to a student who has not opened the app for 3 or more consecutive days
- FR45: A student can grant or deny notification permission during onboarding on devices that require it
- FR46: The app provides full functionality to a student who has denied notification permission

---

### NonFunctional Requirements

**Performance** (baseline: 3-year-old mid-range Android, API 30, ~2–3GB RAM)
- NFR1: Cold start to fully interactive board ≤ 3 seconds
- NFR2: Task card interaction response (tap, move) ≤ 200ms
- NFR3: Quiz answer submission and result display ≤ 1 second
- NFR4: Dashboard metrics render (all data) ≤ 2 seconds
- NFR5: Lesson content render from local cache (offline) ≤ 2 seconds
- NFR6: Animation frame rate (transitions, rewards, haptics) 60fps sustained
- NFR7: Offline changes sync after connectivity returns ≤ 5 seconds

**Security**
- NFR8: All data in transit encrypted via HTTPS/TLS — enforced at the Supabase layer; no plain HTTP calls permitted
- NFR9: All data at rest encrypted in Supabase (Postgres encryption at rest)
- NFR10: Student progress data is accessible only to the owning student account — enforced via Supabase Row-Level Security (RLS) policies
- NFR11: Google Sign-In implemented via standard OAuth 2.0 — no Google credentials stored by the app; only OAuth tokens handled
- NFR12: Soft-deleted accounts: all PII (name, email, district, school) anonymised in retained logs immediately upon deletion request
- NFR13: No student can access another student's profile, progress, or quiz data at any point

**Reliability**
- NFR14: Zero data loss guarantee — all quiz completions and task status changes must be persisted to local storage before any sync is attempted
- NFR15: Crash resilience — locally-persisted offline data must survive app crash, force-close, or device restart
- NFR16: Idempotent sync — retrying a failed sync operation must not create duplicate records or corrupt existing state
- NFR17: Graceful sync failure — if a sync attempt fails, queued offline changes must be retained locally and retried; no silent data loss
- NFR18: No session interruption — a sync event must not interrupt or visually disrupt an in-progress study session or quiz attempt

**Integration**
- NFR19: Google Sign-In: transparent token refresh without requiring re-login
- NFR20: Supabase JWT + RLS policies enforced server-side on all data access
- NFR21: FCM graceful degradation — if FCM is unreachable, the app continues to function normally without notification delivery

---

### Additional Requirements

*(Technical requirements from Architecture that affect implementation)*

- Starter scaffold: Very Good CLI 1.0.0 — `very_good create flutter_app studyboard_mobile --org com.lahiru.studyboard --desc "A/L Chemistry study OS"` — first implementation story (noted prominently for Epic 1 Story 1)
- State management: Riverpod 3.0 (`flutter_riverpod: ^3.0.0`, `riverpod_annotation: ^3.0.0`) — compile-time safe, built-in offline persistence
- Local database: Drift (SQLite ORM, `drift: ^2.x`, `drift_flutter: ^0.2.x`) with compile-time safe migrations; local Drift state is always source of truth
- Navigation: go_router — declarative, type-safe route parameters, shell routes for bottom nav, deep-link ready
- Crash reporting: Firebase Crashlytics — same Firebase project as FCM
- Content seeding: Supabase Dashboard + SQL scripts for Chemistry syllabus V1; architecture is subject-agnostic from day one
- Offline sync: Custom Drift sync queue — `sync_queue` table records pending operations; `connectivity_plus` monitors network; each operation is an idempotent Supabase upsert; local state always source of truth
- Content pre-fetch: `flutter_cache_manager` — all lesson images pre-fetched to local cache at first sync; no mid-session network requests for content
- Repository layer pattern — Supabase client never called directly from ViewModels/Notifiers; each feature has a repository interface injected via Riverpod providers
- Error handling: `Either<Failure, T>` Result type + Riverpod `AsyncValue` — sealed `Failure` class hierarchy; repository methods never throw
- Task state machine is system-enforced — `Done` transition ONLY via `TaskRepository.markTaskComplete(taskId)`; failed quiz via `TaskRepository.resetTaskToInProgress(taskId)`
- RLS policy design: `auth.uid() = student_id` on all student data tables; content tables (subjects, topics, lessons, quiz questions) are public SELECT; soft-delete sets `deleted_at` + anonymizes PII in same transaction
- Skeleton loaders for board and dashboard initial load — never a centered spinner
- Feature-first folder structure: `lib/features/<feature>/` with `data/`, `domain/`, `presentation/` layers per feature; shared code under `lib/core/`
- APK signing for sideloading to 10-student test group; Android `POST_NOTIFICATIONS` runtime permission request at onboarding for Android 13+
- `freezed` required for all domain models and state classes
- `AnimatedList` for all task state changes on board — immediate visual feedback without loading states

---

### UX Design Requirements

- UX-DR1: Implement Serene Scholar color token system as Flutter `ColorScheme` extension (`StudyBoardColors`) with defined semantic tokens — Calm Blue `#007BFF` (primary), Golden Yellow `#FFC107` (In Progress/accent), Soft White `#F8F9FA` (background), Muted Sage Green `#4CAF78` (Done), Warm Dusty Rose `#C4786A` (Re-opened), Cool Blue-Grey `#8896A5` (Backlog); no hardcoded hex values inside widget files
- UX-DR2: Bundle Nunito (primary) and JetBrains Mono (Regular + Medium only) as Flutter font assets; set `GoogleFonts.config.allowRuntimeFetching = false` before `runApp()`; apply full type scale (Display 32sp through Label Medium 12sp)
- UX-DR3: Implement dark mode as default on first launch — `ThemeMode` stored in `SharedPreferences`, awaited before `runApp()` to prevent first-frame flash; frictionless toggle in settings
- UX-DR4: Implement `SubjectCoverageCard` custom component — Calm Blue card with swipeable `PageView` (`viewportFraction: 0.9`), edge of next card always visible, `CoverageRing` hero, JetBrains Mono coverage %, subject name, `X of Y lessons Done` label, page indicator dots; `RepaintBoundary` around `CustomPainter`
- UX-DR5: Implement `TaskCard` custom component — 4dp left-border state color, task name, topic breadcrumb, state icon (5 states: Backlog clock, To-Do arrow-right, In Progress play, Done check-circle, Re-opened refresh); Standard (16dp) and Compact (12dp) variants; tap → `ModalBottomSheet` with contextual actions; color + icon + label (never color alone)
- UX-DR6: Implement `CuriosityScreen` full-screen component — framing copy "Here's what A/L examiners actually ask about [topic]", past paper question text (Title Medium, 1.6× line-height), "Continue to lesson" `FilledButton`; `PopScope` intercepts Android back → `AlertDialog` "Leave this lesson? [Stay] [Leave]"; question content stored offline
- UX-DR7: Implement `QuizQuestionCard` component — `LinearProgressIndicator` (question X of Y, Calm Blue fill), one question at a time, answer options A–D as full-width `OutlinedButton`, selected state → Continue `FilledButton` appears; post-answer: correct option Sage Green background, wrong student option Dusty Rose background (no strikethrough); `PopScope` with same confirmation dialog
- UX-DR8: Implement `PivotQuestionCard` component — Headline "You're one concept away." (Calm Blue, Headline style), pivot question (Body Large), correct answer (Sage Green background), student wrong answer (Dusty Rose background), two CTAs: `[Review Lesson]` FilledButton + `[Try Again Later]` OutlinedButton; 3rd+ failure variant adds Label Medium note above headline (no alert color, no icon)
- UX-DR9: Implement `TaskCompletionAnimation` — `Transform.scale` (1.0→1.04→1.0, 300ms, `Curves.easeOut`), left-border color transition Golden Yellow→Sage Green (200ms), `HapticFeedback.mediumImpact()` at peak scale, `AnimatedList` slide-out (250ms); NO confetti, NO celebration banner, NO sound; `RepaintBoundary` wraps animation; never `AnimatedOpacity` or `BackdropFilter`
- UX-DR10: Implement `CoverageRing` CustomPainter — track ring (white 20% opacity, full circle), fill arc (white, clockwise from top, proportional to coverage %), JetBrains Mono coverage % center label; Large variant 120dp / Small variant 40dp; `RepaintBoundary`; `shouldRepaint` true only when coverage % changes
- UX-DR11: Implement `AccuracyBar` CustomPainter — topic name (Label Medium, left-aligned), horizontal fill bar proportional to accuracy %, right-justified JetBrains Mono %; bar color: Calm Blue below 60% / Golden Yellow 60–79% / Sage Green 80%+; ascending sort order (worst topic first); `RepaintBoundary` per bar row
- UX-DR12: Implement Dashboard Home screen (primary tab) — `PageView` subject cards hero, task list scoped to current subject, stats row (streak / accuracy / done count); subject card context strictly scoped — no cross-subject task mixing on a single screen
- UX-DR13: Implement Board tab — `TabBar` with To-Do / In Progress / Done tabs; In Progress as default open tab; Done tab hidden until first task completion; no drag-and-drop, bottom sheet only for all state changes; `AnimatedList` insertion/removal on task state changes
- UX-DR14: Implement `NavigationBar` with 3 tabs (Board / Dashboard / Backlog) — Calm Blue active indicator; instant tab switch (no page transition animation); bottom nav hidden during study loop (nested navigator); shell route via go_router
- UX-DR15: Implement `PopScope` back gesture interception — `CuriosityScreen` and `QuizScreen` show `AlertDialog` "Leave this lesson?"; `LessonContent` allows free back navigation; study loop screens use nested navigator stack pushed over bottom nav
- UX-DR16: Implement empty states — Board In Progress empty ("Move a task to To-Do to get started" + "Go to Backlog" FilledButton); Dashboard 0% coverage shows ring at 0% with no placeholder copy; accuracy breakdown empty ("Complete your first quiz…"); Backlog all-promoted ("Everything is in progress or done.")
- UX-DR17: Implement skeleton loading states — 3 skeleton `TaskCard` placeholders for board initial load (grey shimmer, same height as real cards); shimmer on coverage ring area for dashboard initial load (white shimmer on Calm Blue); NO loading state for cached/offline data
- UX-DR18: Implement offline mode indicator — persistent `SnackBar` on connectivity loss ("You're offline. Your lessons are still available.", `inverseSurface` color, no dismiss button); text-swap to "Back online. Syncing…" on reconnect; auto-dismiss after sync completes or 3 seconds
- UX-DR19: Implement onboarding registration flow — one-screen form with name, district (`DropdownButtonFormField`), school (`TextField` with typeahead autocomplete); subject selection checklist (Chemistry / Physics / Combined Maths, at least one required); inline validation on field blur; submit `FilledButton` disabled until all required fields filled; `resizeToAvoidBottomInset: true`
- UX-DR20: Implement TalkBack/accessibility semantics — `Semantics` labels on `SubjectCoverageCard` ("Subject, X% coverage, Y of Z lessons complete"), `TaskCard` ("task name, state, double-tap to see options"); `excludeSemantics: true` on `CoverageRing` and `AccuracyBar` painters (parent carries meaning); `FocusScope` trapping in study loop screens; `ModalBottomSheet` moves focus to first actionable element on open

---

### FR Coverage Map

| FR | Epic | Summary |
|---|---|---|
| FR1 | Epic 1 | Email/password registration |
| FR2 | Epic 1 | Login (email + Google) |
| FR3 | Epic 1 | Google account linking |
| FR4 | Epic 1 | Profile update (name, district, school) |
| FR5 | Epic 8 | Account deactivation (soft-disable, data retained) |
| FR6 | Epic 8 | Account deletion (soft-delete + PII anonymization) |
| FR7 | Epic 2 | Backlog view — full Chemistry syllabus |
| FR8 | Epic 2 | Kanban board — To-Do / In Progress / Done columns |
| FR9 | Epic 2 | Pull task Backlog → To-Do |
| FR10 | Epic 2 | Move task To-Do → In Progress |
| FR11 | Epic 2 | Content track filtering (Theory, Past Papers, Future Papers) |
| FR12 | Epic 2 | Future Papers track (architecturally present, may be empty) |
| FR13 | Epic 2 | Status of every lesson visible at all times |
| FR14 | Epic 4 | System-enforced quiz gate — no Done without quiz pass |
| FR15 | Epic 3 | Curiosity-first warm-up (non-skippable) |
| FR16 | Epic 3 | Lesson content access (notes, diagrams, rich media) |
| FR17 | Epic 3 | Rich media rendering (chemical formulas, molecular diagrams) |
| FR18 | Epic 3 | Offline lesson + past paper question access |
| FR19 | Epic 3 | Background content sync when online |
| FR20 | Epic 4 | Take quiz for current lesson |
| FR21 | Epic 4 | Pass/fail evaluation (configurable threshold, Chemistry = 80%) |
| FR22 | Epic 4 | Quiz fail → task re-opens neutrally ("not done yet") |
| FR23 | Epic 4 | Quiz pass → task marked Done |
| FR24 | Epic 4 | Retry quiz immediately or return later (no cooldown) |
| FR25 | Epic 4 | Lesson access after quiz failure for review |
| FR26 | Epic 4 | Per-attempt score and pass/fail recording |
| FR27 | Epic 6 | Overall syllabus coverage % (quiz-verified) |
| FR28 | Epic 6 | Past paper completion % per topic |
| FR29 | Epic 6 | Accuracy rate per topic across all quiz attempts |
| FR30 | Epic 6 | Weakest topics ranked ascending by accuracy |
| FR31 | Epic 6 | Progress vs. configured completion threshold (80%) |
| FR32 | Epic 6 | Engagement streak counter (consecutive days of app activity) |
| FR33 | Epic 4 | Haptic feedback (HapticFeedback.mediumImpact) on task completion — atomic with quiz pass |
| FR34 | Epic 4 | Visual reward animation (TaskCompletionAnimation) on task completion — atomic with quiz pass |
| FR35 | Epic 7 | Streak counter maintained and displayed |
| FR36 | Epic 7 | Graceful streak reset when day missed (no punishment UI) |
| FR37 | Epic 7 | In-app satisfaction/stress survey (fun quiz format) |
| FR38 | Epic 7 | Survey response recording for validation |
| FR39 | Epic 5 | Full app access offline (lessons, quizzes, task board) |
| FR40 | Epic 5 | Offline quiz completion + task state changes persisted locally |
| FR41 | Epic 5 | Auto-sync within 5 seconds of connectivity return |
| FR42 | Epic 5 | Network state detection → sync trigger (no user action needed) |
| FR43 | Epic 5 | No session interruption on connectivity state change |
| FR44 | Epic 8 | Engagement nudge notification after 3+ consecutive inactive days |
| FR45 | Epic 1 | Notification permission request at onboarding (Android 13+) |
| FR46 | Epic 8 | Full app functionality without notification permission |

> **Note on FR33/FR34:** Haptics and TaskCompletionAnimation are moved from Epic 7 to Epic 4 — they are atomic with the quiz pass event and must ship with the quiz engine, not as separate polish.
> **Note on FR45:** Notification permission request at onboarding moves to Epic 1 alongside auth/onboarding flow for UX continuity.

---

## Epic List

### Epic 1: Project Foundation, Authentication & Experiment Infrastructure
Students can register, sign in, and set up their profile. The app shell (theme, navigation, dark mode) is in place. Firebase (Crashlytics + FCM token capture) and full Drift schema are initialized. This epic establishes all foundational infrastructure — scaffold, data schema, auth system, Firebase project — that every subsequent epic depends on.
**FRs covered:** FR1, FR2, FR3, FR4, FR45
**Architecture:** Very Good CLI 1.0.0 scaffold (Story 1.1), complete Drift schema for all 8 epics, Supabase project + RLS policies, go_router shell, Serene Scholar theme + dark mode default + font bundling, NavigationBar shell, Supabase Auth (email/password + Google OAuth), Firebase Core + Crashlytics + FCM token capture with refresh handling

### Epic 2: Chemistry Syllabus & Task Board
Students can see the full Chemistry syllabus as a task board and move tasks through Backlog → To-Do → In Progress. The board is the operational home — the "I can see the whole exam" moment. Includes Chemistry content seeding.
**FRs covered:** FR7, FR8, FR9, FR10, FR11, FR12, FR13
**Architecture:** Chemistry syllabus SQL seed scripts to Supabase, TaskCard custom component, Kanban board UI (TabBar + TabBarView), task state machine (Backlog/To-Do/In Progress), AnimatedList, Board Classic layout, skeleton loaders, empty states, Done tab hidden until first completion

### Epic 3: Lesson Content & Curiosity-First Learning
Students can study lessons with the curiosity-first warm-up (past paper question before lesson content). Rich media (chemical formulas, molecular diagrams) renders inline. Content is pre-cached for full offline access.
**FRs covered:** FR15, FR16, FR17, FR18, FR19
**Architecture:** CuriosityScreen component (PopScope back interception, curiosity completion state persisted to Drift), LessonContent screen (progress bar, sticky CTA), flutter_cache_manager eager pre-fetch (first topic) + background pre-fetch (remainder), background content sync

### Epic 4: Quiz Engine, Completion Gate & Dopamine Loop
Students can take quizzes, have tasks moved to Done on pass, and experience the haptic + animation reward. On failure, the PivotQuestion surfaces the one concept to review. This epic delivers the core "Enforced Definition of Done" trust mechanism and the dopamine completion experience as one atomic unit.
**FRs covered:** FR14, FR20, FR21, FR22, FR23, FR24, FR25, FR26, FR33, FR34
**Architecture:** Quiz state machine (In Progress → Done ONLY via `TaskRepository.markTaskComplete()`), QuizQuestionCard, PivotQuestionCard (3rd+ failure variant), TaskCompletionAnimation (Transform.scale + HapticFeedback.mediumImpact at peak — atomic with quiz pass), per-attempt score recording to Drift + sync queue

### Epic 5: Offline Reliability & Background Sync
Students have full app functionality without connectivity. Task state changes and quiz completions persist locally (Drift) and sync automatically within 5 seconds of reconnecting. Zero data loss. The sync queue consumer is activated — Epics 1–4 have been enqueueing operations; Epic 5 drains the queue.
**FRs covered:** FR39, FR40, FR41, FR42, FR43
**Architecture:** Sync queue consumer activated (connectivity_plus → sync service → idempotent Supabase upserts), retry_count logic + sync_error_log, offline SnackBar indicator (persistent, text-swaps on reconnect, auto-dismisses after sync), no session interruption guarantee

### Epic 6: Progress Dashboard & Analytics
Students can see their honest, quiz-verified progress — coverage %, per-topic accuracy, weakest topics ranked, and progress vs. the 80% Chemistry threshold. The anxiety antidote: open the app and know exactly where you stand.
**FRs covered:** FR27, FR28, FR29, FR30, FR31, FR32
**Architecture:** Dashboard Home screen (PageView swipeable SubjectCoverageCard hero), CoverageRing CustomPainter (RepaintBoundary, shouldRepaint on coverage % change only), AccuracyBar CustomPainter (ascending sort, RepaintBoundary per row), stats row (streak/accuracy/done), accuracy breakdown screen

### Epic 7: Streak Mechanics & In-App Survey
Students see their streak counter driving daily return habit. The in-app satisfaction/stress survey provides Lahiru with validation data on anxiety reduction — one of the four experiment hypotheses.
**FRs covered:** FR35, FR36, FR37, FR38
**Architecture:** StreakIndicator widget (graceful reset, no punishment UI), survey screen (fun quiz format), survey response recording to Drift + Supabase
**Cut priority:** If timeline pressure hits — cut FR37/FR38 (survey) first, then FR35/FR36 (streak). Core non-negotiables are Epics 1–5.

### Epic 8: Push Notifications & Account Lifecycle
Students receive FCM server-push engagement nudges after inactivity. The nudge hypothesis is fully instrumented for measurement. Students can deactivate or delete their account with PDPA-compliant PII anonymization.
**FRs covered:** FR44, FR46, FR5, FR6
**Architecture:** pg_cron → Supabase Edge Function → FCM HTTP v1 API, nudge_events table (student_id, sent_at, fcm_message_id, status), sessions table with attributed_nudge_id FK for hypothesis measurement, FCM server key stored as Supabase secret (never on client), account deactivation (soft-disable), account deletion (soft-delete + immediate PII anonymization in same Supabase transaction)
**Cut priority:** If timeline pressure hits — cut Epic 8 after Epic 7. Account lifecycle (FR5/FR6) should be preserved even if FCM is deferred.

---

## Epic 1: Project Foundation, Authentication & Experiment Infrastructure

Students can register, sign in, and set up their profile. The app shell (theme, navigation, dark mode) is in place. Firebase (Crashlytics + FCM token capture) and full Drift schema are initialized. This epic establishes all foundational infrastructure — scaffold, data schema, auth system, Firebase project — that every subsequent epic depends on.

**FRs covered:** FR1, FR2, FR3, FR4, FR45

### Story 1.1: Flutter Project Scaffold & Core Architecture

As a developer,
I want the Flutter project initialized with VGC scaffold, feature-first architecture, Riverpod, go_router, and Firebase Crashlytics,
So that every subsequent story has a consistent, production-ready foundation with enforced architectural patterns.

**Acceptance Criteria:**

**Given** the VGC scaffold is initialized with `very_good create flutter_app studyboard_mobile --org com.lahiru.studyboard --desc "A/L Chemistry study OS"`
**When** the app is built and run
**Then** `ProviderScope` wraps the app at the root, `MaterialApp.router` with go_router renders correctly, and the app compiles with zero lint warnings under Very Good Analysis rules

**Given** the feature-first folder structure is established
**When** a developer adds a new feature
**Then** it follows `lib/features/<feature>/data/domain/presentation/` convention and shared code lives under `lib/core/`

**Given** the sealed `Failure` class hierarchy is defined in `core/failures/failure.dart`
**When** any repository method encounters an error
**Then** it returns `Either<Failure, T>` mapping to the correct subtype (`NetworkFailure`, `DatabaseFailure`, `AuthFailure`, `ValidationFailure`, `SyncFailure`) and never throws an exception

**Given** the repository base class in `core/supabase/repository_base.dart`
**When** any feature repository is implemented
**Then** the Supabase client is accessed only within the `data/` layer and never called directly from a Notifier or Screen widget

**Given** Firebase Crashlytics is initialized in `main.dart` before `runApp()`
**When** a non-fatal error occurs anywhere in the app
**Then** it is reported to Crashlytics without crashing the app or displaying any user-facing error

**Given** the go_router shell route with `NavigationBar`
**When** the app launches
**Then** the Board tab is selected by default and the bottom `NavigationBar` renders with three tab destinations

---

### Story 1.2: App Theme, Design System & Navigation Shell

As a student,
I want the app to display with the Serene Scholar visual design — calm colors, readable fonts, and dark mode by default,
So that the app feels trustworthy and calm from the very first frame.

**Acceptance Criteria:**

**Given** the app is launched for the first time
**When** the first frame renders
**Then** the app displays in dark mode without any light-mode flash (ThemeMode awaited from SharedPreferences before `runApp()`)

**Given** a student changes their theme preference in settings
**When** the app is restarted
**Then** the chosen theme persists correctly — dark mode or light mode — via SharedPreferences

**Given** the `StudyBoardColors` extension on `ColorScheme`
**When** any widget calls `Theme.of(context).colorScheme.taskBacklog`, `.taskInProgress`, `.taskDone`, or `.taskReopened`
**Then** the correct hex values are returned: `#8896A5`, `#FFC107`, `#4CAF78`, `#C4786A` respectively — no hardcoded hex values exist inside any widget file

**Given** Nunito and JetBrains Mono are bundled as Flutter font assets and `GoogleFonts.config.allowRuntimeFetching = false` is set before `runApp()`
**When** the app renders with no internet connection
**Then** all text displays correctly using the bundled fonts with no font-load errors

**Given** the Material 3 `ThemeData` is seeded with `ColorScheme.fromSeed(seedColor: Color(0xFF007BFF))`
**When** the app renders any Material component (Card, Button, NavigationBar, Dialog)
**Then** the Serene Scholar palette overrides the default Material tonal palette and no Material You dynamic color interpolation overrides the custom tokens

**Given** the `NavigationBar` shell with three tabs (Board, Dashboard, Backlog)
**When** a student taps any tab
**Then** the tab switches instantly with no page transition animation and the active tab shows a Calm Blue filled icon indicator

---

### Story 1.3: Complete Drift Database Schema

As a developer,
I want the full Drift database schema defined in a single initial migration covering all 8 epics,
So that no mid-sprint schema migration surprises block feature development.

**Acceptance Criteria:**

**Given** the Drift `AppDatabase` is instantiated
**When** the app runs for the first time on a fresh install
**Then** migration version 1 executes successfully and all required tables exist: `students`, `subjects`, `topics`, `lessons`, `lesson_tasks`, `quiz_questions`, `quiz_attempts`, `past_paper_questions`, `sync_queue`, `sync_error_log`, `survey_responses`, `nudge_events`, `sessions`

**Given** the `lesson_tasks` table `task_status` column
**When** a task status is written to Drift
**Then** only `'backlog'`, `'todo'`, `'in_progress'`, or `'done'` are valid values; the `TaskStatus` enum and `TaskStatus.fromString()` / `toDbString()` extension are the only conversion paths — no raw string comparisons anywhere in the codebase

**Given** the `sync_queue` table
**When** an entry is inserted
**Then** it contains: `id (UUID TEXT PK)`, `entity_type TEXT NOT NULL`, `entity_id TEXT NOT NULL`, `operation TEXT NOT NULL ('upsert'|'soft_delete')`, `payload TEXT NOT NULL (JSON)`, `created_at TEXT NOT NULL (ISO 8601 UTC)`, `retry_count INTEGER DEFAULT 0`

**Given** the `sessions` table
**When** a session row is created
**Then** it contains `attributed_nudge_id TEXT` as a nullable FK referencing `nudge_events.id`, enabling nudge-to-return attribution for the FCM hypothesis

**Given** a Drift DAO for each feature domain (`TaskDao`, `QuizDao`, `LessonDao`, `StudentDao`, `SurveyDao`, `DashboardDao`)
**When** the `AppDatabase` singleton is accessed
**Then** all DAOs are accessible and all `freezed` domain models have corresponding `fromJson`/`toJson` mappings with explicit `snake_case` → `camelCase` field mapping

**Given** a future schema upgrade (migration v1 → v2)
**When** the app is installed over an existing v1 database
**Then** Drift's migration API handles the upgrade without data loss — verified by running a migration test against a v1 seed database

---

### Story 1.4: Supabase Project Setup & Row-Level Security

As a developer,
I want Supabase tables, RLS policies, and the soft-delete pattern configured,
So that student data is isolated and secure from the first student onboarding.

**Acceptance Criteria:**

**Given** the Supabase project is configured with all tables mirroring the Drift schema
**When** any authenticated student makes an API call
**Then** the call uses a valid Supabase JWT and the JWT refresh is handled transparently by `supabase_flutter` without interrupting the user session

**Given** RLS is enabled on all student data tables (`lesson_tasks`, `quiz_attempts`, `sessions`, `survey_responses`, `nudge_events`, `students`)
**When** Student A (authenticated as `auth.uid() = A`) attempts to SELECT rows belonging to Student B
**Then** the query returns zero rows — RLS enforces `student_id = auth.uid()` on every data operation

**Given** RLS on content tables (`subjects`, `topics`, `lessons`, `quiz_questions`, `past_paper_questions`)
**When** any authenticated student performs a SELECT
**Then** the query succeeds and returns content rows; INSERT, UPDATE, and DELETE operations are rejected with a permissions error

**Given** a student account is soft-deleted (`deleted_at` timestamp is set and PII fields anonymized)
**When** any other authenticated student queries any student data table
**Then** the soft-deleted student's rows are excluded from all results by RLS — no deleted-user data is surfaced in any student-facing query

**Given** the repository base class enforces the data-layer boundary
**When** any Riverpod Notifier or Screen widget accesses student data
**Then** it does so exclusively via a repository interface — no direct `supabase.from(...)` calls exist outside `data/` layer files

---

### Story 1.5: Firebase Initialization & FCM Token Infrastructure

As a developer,
I want Firebase fully initialized with Crashlytics and FCM token capture on first launch,
So that experiment instrumentation is clean from day one and every student's nudge data is reliable.

**Acceptance Criteria:**

**Given** `main.dart` calls `Firebase.initializeApp()`
**When** the app starts
**Then** `FirebaseCrashlytics` and `FirebaseMessaging` are both initialized before `runApp()` is called — no Firebase feature is used before initialization completes

**Given** a student's first app launch
**When** the app completes initialization
**Then** `FirebaseMessaging.instance.getToken()` is called, the FCM token is persisted to `students.fcm_token` in Supabase, and this operation completes without blocking or delaying the UI

**Given** FCM token rotation (token refresh event fires)
**When** `FirebaseMessaging.instance.onTokenRefresh` emits a new token
**Then** the new token overwrites `students.fcm_token` in Supabase within one sync cycle and the old token is no longer used

**Given** a student denies notification permission on Android 13+
**When** FCM token retrieval returns null
**Then** the app does not crash, `students.fcm_token` remains null in Supabase, `notifications_enabled` is set to `false` in Drift, and all app features work normally (FR46)

**Given** FCM is unreachable due to no connectivity on first launch
**When** token retrieval fails
**Then** the failure is logged to Crashlytics as a non-fatal event, token capture is retried on the next app foreground with active connectivity, and the user experiences no error or delay

**Given** Crashlytics is active
**When** an unhandled Flutter error or non-fatal exception occurs
**Then** it is reported to the Firebase Crashlytics dashboard with the correct stack trace and no user-facing crash dialog appears for non-fatal events

---

### Story 1.6: Student Registration (Email/Password)

As a student,
I want to create a StudyBoard account with my email and password,
So that I can securely access my personal study board and progress data.

**Acceptance Criteria:**

**Given** the registration screen is displayed
**When** a student enters a valid email, a password of at least 8 characters, and their full name
**Then** the "Create account" `FilledButton` becomes enabled

**Given** the registration form
**When** a student moves focus away from an invalid field (on blur)
**Then** an inline error message appears below that field using `colorScheme.error` styling — validation does not fire on every keystroke

**Given** a student submits valid registration details
**When** Supabase Auth creates the account
**Then** a `students` record is created in both Drift and Supabase with `student_id = auth.uid()`, the student's name and email are stored, and the student is automatically logged in and routed to the onboarding flow (Story 1.9)

**Given** a student submits registration with an email already in use
**When** Supabase returns an auth conflict error
**Then** an inline user-friendly error message is displayed ("An account with this email already exists. Try logging in.") without crashing

**Given** a student submits registration while offline
**When** the Supabase call fails due to no connectivity
**Then** a clear error message is shown ("No internet connection. Please try again.") and the form data is preserved so the student doesn't have to re-type

**Given** the RLS policies from Story 1.4
**When** the `students` record is created
**Then** `student_id` matches `auth.uid()` and RLS is immediately effective — the student can only access their own data

---

### Story 1.7: Google Sign-In & Account Linking

As a student,
I want to register or sign in using my Google account,
So that I can access StudyBoard without managing a separate password.

**Acceptance Criteria:**

**Given** the registration or login screen
**When** a student taps "Continue with Google"
**Then** the native Google Sign-In flow launches via the `google_sign_in` SDK and the student sees their Google account selection screen

**Given** the student selects a Google account and grants consent
**When** the OAuth token is received
**Then** Supabase Auth creates or retrieves the student session using the Google OAuth token, and no Google credentials are stored by the app — only the OAuth session token is handled

**Given** a new student completing Google Sign-In for the first time
**When** OAuth completes successfully
**Then** a `students` record is created in Drift and Supabase with `student_id = auth.uid()` and the student is routed to the onboarding flow (Story 1.9)

**Given** a returning student using Google Sign-In
**When** OAuth completes
**Then** the student is routed directly to the Dashboard Home — the onboarding flow is not shown again

**Given** the Android deep-link redirect is configured via `app_links` or a custom URL scheme
**When** the OAuth callback fires after Google consent
**Then** the app intercepts the redirect correctly, the sign-in completes without an "invalid redirect URI" error, and the student is never sent to a browser tab that doesn't redirect back

**Given** the student's Google OAuth token expires
**When** the token needs refresh
**Then** `google_sign_in` handles refresh transparently without prompting the student to re-authenticate

---

### Story 1.8: Student Login & Session Persistence

As a student,
I want to log in to my existing account and have my session remembered between app opens,
So that I don't have to sign in again every time I open StudyBoard.

**Acceptance Criteria:**

**Given** the login screen
**When** a student enters their registered email and password and taps "Log in"
**Then** Supabase Auth authenticates the student and they are routed to the Dashboard Home

**Given** the login screen
**When** a student taps "Continue with Google"
**Then** the Google Sign-In flow from Story 1.7 handles authentication and routes the student to the Dashboard Home

**Given** an incorrect email and password combination
**When** the student submits the login form
**Then** an inline error "Incorrect email or password" is displayed without revealing which specific field is wrong, and the form is not cleared

**Given** a valid session exists in `supabase_flutter` session storage
**When** the app is launched
**Then** the student is automatically routed to the Dashboard Home without seeing the login screen — cold start to board in ≤ 3 seconds (NFR1)

**Given** no stored session exists (first install or after logout)
**When** the app initializes
**Then** the login screen is displayed as the initial route

**Given** a student's session expires while the app is in the background
**When** they return to the app and the session refresh attempt fails
**Then** the student is routed to the login screen with a brief message ("Your session expired — please log in again") and their previous navigation state is preserved where possible

---

### Story 1.9: Student Onboarding, Profile Setup & Notification Permission

As a student,
I want to complete a brief setup after registering — entering my district, school, and subjects — and be asked about notifications,
So that my board is tailored to my subjects and I can receive study reminders if I choose.

**Acceptance Criteria:**

**Given** a student who has just registered (via email or Google Sign-In for the first time)
**When** account creation completes
**Then** the onboarding flow is presented before the Dashboard Home and cannot be bypassed

**Given** the district field in the onboarding form
**When** the student taps the district selector
**Then** a `DropdownButtonFormField` displays all Sri Lankan districts as selectable options

**Given** the school field
**When** a student types at least 2 characters
**Then** typeahead autocomplete suggestions appear; the student may select a suggestion or type a custom school name freely — the field is not locked to a predefined list

**Given** the subject selection checklist (Chemistry, Physics, Combined Maths)
**When** no subject is selected
**Then** the "Continue" `FilledButton` is disabled; once at least one subject is selected, the button becomes enabled

**Given** the device is running Android 13+ (API 33+)
**When** the student reaches the notification permission step
**Then** the `POST_NOTIFICATIONS` runtime permission dialog is presented; on Android 12 and below, this step is silently skipped

**Given** the student denies notification permission
**When** the onboarding continues
**Then** `notifications_enabled = false` is stored in Drift, the FCM token in Supabase remains null, and the student proceeds to the Dashboard Home with full app functionality (FR46)

**Given** the student grants notification permission
**When** the onboarding continues
**Then** `notifications_enabled = true` is stored in Drift and the FCM token captured in Story 1.5 is confirmed active in `students.fcm_token` in Supabase

**Given** the student completes all onboarding steps and taps "Get started"
**When** the form is submitted
**Then** their district, school, and subject selections are saved to both Drift and Supabase, and they are routed to the Dashboard Home with their selected subjects available as swipeable subject cards

---

### Story 1.10: Student Profile Edit

As a student,
I want to update my name, district, and school after I have completed onboarding,
So that my profile information stays accurate if my details change.

**Acceptance Criteria:**

**Given** a student navigates to their Profile screen (accessible from the Dashboard or a settings entry point in the NavigationBar)
**When** the Profile screen opens
**Then** their current name, district, and school values are pre-populated in editable fields matching the onboarding form layout

**Given** the student edits one or more fields
**When** they tap "Save changes"
**Then** the updated values are written to the `students` record in both Drift and Supabase in a single operation, a sync queue entry is enqueued in the same Drift transaction, and a brief `SnackBar` confirms "Profile updated"

**Given** the student submits an empty name field
**When** validation fires on blur
**Then** an inline error appears ("Name is required") and the Save button remains disabled until the field is valid

**Given** the student makes edits and then navigates away without saving
**When** they leave the Profile screen
**Then** no changes are persisted — edited values are discarded and the original values remain

**Given** the profile update while offline
**When** the student saves changes
**Then** the update is written to Drift immediately, a sync queue entry is enqueued, and the update syncs to Supabase when connectivity is restored — the student sees their updated name and details immediately with no error

---

## Epic 2: Chemistry Syllabus & Task Board

Students can see the full Chemistry syllabus as a task board and move tasks through Backlog → To-Do → In Progress. The board is the operational home — Kavya's "I can see the whole exam" moment. Includes Chemistry content seeding and session activity logging for experiment measurement.

**FRs covered:** FR7, FR8, FR9, FR10, FR11, FR12, FR13

### Story 2.1: Chemistry Syllabus Content Seeding

As a developer,
I want the full A/L Chemistry syllabus seeded into Supabase with all topics, lessons, and placeholder quiz and past paper questions,
So that the app has real content for the 10-student experiment from day one.

**Acceptance Criteria:**

**Given** the SQL seed scripts are executed against the Supabase project
**When** the seeding completes
**Then** the `subjects` table contains at least one Chemistry subject record with a configurable pass threshold (default 80%)

**Given** the Chemistry subject record exists
**When** topics are seeded
**Then** all A/L Chemistry topics are present in the `topics` table, each linked to the Chemistry `subject_id`

**Given** each topic exists
**When** lessons are seeded
**Then** each lesson record in the `lessons` table contains: `id`, `topic_id`, `title`, `content_text` (lesson notes), `content_track` (`'theory'`|`'past_papers'`|`'future_papers'`), and at least one associated `past_paper_questions` record

**Given** each lesson exists
**When** quiz questions are seeded
**Then** each lesson has at least one `quiz_questions` record with `question_text`, four answer options (`option_a` through `option_d`), and `correct_option` identified — sufficient for the quiz engine in Epic 4

**Given** a student opens the app for the first time with connectivity
**When** the first Supabase sync runs
**Then** all subjects, topics, lessons, quiz questions, and past paper questions are written to the local Drift database and accessible offline

**Given** the content tables have RLS set to public SELECT (Story 1.4)
**When** any authenticated student queries content
**Then** all Chemistry syllabus content is returned — no student-scoped filtering on content tables

---

### Story 2.2: Backlog View — Full Syllabus & TaskCard Component

As a student,
I want to see the complete Chemistry syllabus as a scrollable list of task cards in my Backlog,
So that I can see the full exam as a finite, completable plan from my very first session.

**Acceptance Criteria:**

**Given** a student opens the Backlog tab
**When** the content has been synced from Supabase (Story 2.1)
**Then** every Chemistry lesson appears as a `TaskCard` in the list — no lessons are hidden, locked, or progressively unlocked

**Given** the `TaskCard` component
**When** rendered in any state
**Then** it displays: a 4dp left-border in the task state color, the lesson title (Title Medium), the topic breadcrumb (Body Medium, `onSurface` at 60% opacity), and a state icon right-aligned — color, icon, and label all present (never color alone)

**Given** the five task states (Backlog, To-Do, In Progress, Done, Re-opened)
**When** each `TaskCard` state is rendered
**Then** the correct border color and icon are shown: Backlog → Cool Blue-Grey + clock, To-Do → Cool Blue-Grey + arrow-right, In Progress → Golden Yellow + play, Done → Sage Green + check-circle, Re-opened → Dusty Rose + refresh

**Given** the content track filter (Theory, Past Papers, Future Papers)
**When** a student selects a filter tab
**Then** only lessons belonging to that content track are shown; the Future Papers tab is visible and selectable but may display an empty state if no Future Papers lessons exist (FR12)

**Given** the Backlog screen loads for the first time
**When** content is being fetched from Drift
**Then** three skeleton `TaskCard` placeholder shimmers are displayed at the same height as real cards — no centered spinner

**Given** all tasks have been promoted out of Backlog (to To-Do or beyond)
**When** the student views the Backlog tab
**Then** the empty state message "Everything is in progress or done." is displayed with no CTA

**Given** the `TaskCard` is rendered
**When** a TalkBack user focuses it
**Then** the semantics label reads: "[lesson title], [state], double-tap to see options"

---

### Story 2.3: Kanban Board & Task Promotion Flow

As a student,
I want to move tasks from Backlog to To-Do and from To-Do to In Progress on my Kanban board,
So that I can build and manage my active study plan.

**Acceptance Criteria:**

**Given** the Board tab
**When** it opens
**Then** a `TabBar` with To-Do and In Progress tabs is visible; In Progress is the default selected tab; the Done tab is hidden until at least one task has been marked Done

**Given** a student taps a `TaskCard` in the Backlog
**When** the tap registers
**Then** a `ModalBottomSheet` appears with the task name, topic breadcrumb, and a "Move to To-Do" `FilledButton` and a "Cancel" option — no drag-and-drop

**Given** the student taps "Move to To-Do" in the bottom sheet
**When** the action confirms
**Then** the task status is updated to `'todo'` in Drift, a sync queue entry is enqueued in the same Drift transaction, the card moves to the To-Do tab via `AnimatedList` removal from Backlog and insertion into To-Do, and the transition is visible within 200ms (NFR2)

**Given** a student taps a `TaskCard` in the To-Do column
**When** the bottom sheet opens
**Then** the options shown are: "Start studying" `FilledButton`, "Move back to Backlog" `OutlinedButton`, and "Cancel"

**Given** the student taps "Start studying"
**When** the action confirms
**Then** the task status is updated to `'in_progress'` in Drift, a sync queue entry is enqueued in the same Drift transaction, the card moves to In Progress via `AnimatedList`, and the Board switches to the In Progress tab automatically

**Given** the In Progress tab is empty (no tasks started yet)
**When** a new student opens the Board for the first time
**Then** the empty state displays: "Move a task to To-Do to get started" body copy and a "Go to Backlog" `FilledButton`

**Given** task state changes are written to Drift
**When** the app is offline during a state change
**Then** the change is persisted locally to Drift immediately, the UI reflects the new state, and the sync queue entry is retained for future sync (Epic 5 will drain it)

**Given** the `TaskRepository.markTaskComplete()` method
**When** any code attempts to set `task_status = 'done'`
**Then** the ONLY valid code path is via `TaskRepository.markTaskComplete(taskId)` — any direct `task_status = 'done'` assignment outside this method is a build-time or code-review violation

---

### Story 2.4: Session Activity Logging

As a developer,
I want every app session start recorded in the `sessions` table,
So that the experiment's primary success metric (≥3 sessions per week) can be measured reliably.

**Acceptance Criteria:**

**Given** a student opens the app (cold start or foreground resume after >30 minutes in background)
**When** the app becomes active
**Then** a `sessions` record is inserted into Drift with `id (UUID)`, `student_id`, `started_at (ISO 8601 UTC)`, and `attributed_nudge_id = null` (attribution filled by Epic 8); a sync queue entry is enqueued in the same transaction

**Given** a session record is created
**When** the student closes or backgrounds the app
**Then** the session record is updated with `ended_at` timestamp in Drift and a sync queue entry is enqueued — session duration is computable from `started_at` and `ended_at`

**Given** the `students` table `last_active_at` column
**When** any meaningful student interaction occurs (app open, task state change, quiz answer)
**Then** `last_active_at` is updated in Drift and enqueued for sync — this field drives the FCM inactivity detection trigger in Epic 8

**Given** the app is offline when a session starts
**When** connectivity returns
**Then** the session record syncs to Supabase via the sync queue with no data loss — offline sessions are not silently dropped

**Given** session data in Supabase
**When** queried for experiment analysis
**Then** sessions are queryable by `student_id` and `started_at` to compute weekly session frequency per student against the ≥3 sessions/week success criterion

---

## Epic 3: Lesson Content & Curiosity-First Learning

Students can study lessons with the curiosity-first warm-up — a past paper question shown before lesson content. Rich media (chemical formulas, molecular diagrams) renders inline. All content is pre-cached for full offline access. This epic delivers the curiosity-first pedagogy bet.

**FRs covered:** FR15, FR16, FR17, FR18, FR19

### Story 3.1: Curiosity-First Warm-Up Screen

As a student,
I want to see a past paper question from the lesson's topic before the lesson content opens,
So that my curiosity is activated — I study with a real question already in my mind.

**Acceptance Criteria:**

**Given** a student taps "Start studying" on an In Progress `TaskCard`
**When** the lesson flow opens
**Then** the `CuriosityScreen` is the first screen displayed — lesson content is not accessible until the student taps "Continue to lesson"

**Given** the `CuriosityScreen` is displayed
**When** rendered
**Then** the framing copy reads "Here's what A/L examiners actually ask about [topic name]" (Body Large, muted), the past paper question text is displayed below (Title Medium, 1.6× line-height), and a "Continue to lesson" `FilledButton` appears at the bottom

**Given** the student has not yet tapped "Continue to lesson"
**When** they press the Android back gesture
**Then** a `PopScope` intercepts the gesture and an `AlertDialog` appears: "Leave this lesson? [Stay] [Leave]" — tapping Stay returns to the CuriosityScreen; tapping Leave returns to the Board

**Given** the CuriosityScreen is displayed offline
**When** the student views it
**Then** the past paper question renders correctly from the local Drift cache — no network request is made (FR18)

**Given** the student taps "Continue to lesson"
**When** the action fires
**Then** a `curiosity_completed` flag is set to `true` on the `lesson_tasks` record in Drift for this lesson, and the student is routed to the LessonContent screen (Story 3.2)

**Given** the student force-quits the app mid-CuriosityScreen and reopens
**When** they tap the same In Progress task again
**Then** the `curiosity_completed` flag in Drift is `false`, so the CuriosityScreen is shown again — the lesson content remains inaccessible until the curiosity step is completed

---

### Story 3.2: Lesson Content Screen & Rich Media

As a student,
I want to read lesson notes and view chemical formulas and molecular diagrams inline,
So that I can study the full lesson content without any missing visuals.

**Acceptance Criteria:**

**Given** the student taps "Continue to lesson" on the CuriosityScreen
**When** the `LessonScreen` opens
**Then** the lesson title (Headline style), scrollable notes body (Body Large, 1.6× line-height), and inline image placeholders are displayed immediately from the Drift/local cache — no loading spinner for returning users (NFR5: ≤ 2 seconds)

**Given** lesson content contains chemical formula or molecular diagram images
**When** the content renders
**Then** images are displayed inline within the text flow — no tap-to-expand required; images render clearly at standard Android screen densities

**Given** the student is offline
**When** the lesson content screen opens
**Then** all text and pre-cached images render correctly from local storage with no network requests and no degraded mode (FR18)

**Given** a linear progress bar at the top of the lesson
**When** the student scrolls through the content
**Then** the progress bar advances proportionally, showing the student's position within the lesson

**Given** the student reaches the end of the lesson content
**When** the bottom of the scroll is approached
**Then** a sticky "Take quiz" `FilledButton` becomes visible and remains accessible without requiring the student to scroll back up

**Given** the student presses the Android back gesture on the LessonContent screen
**When** back is pressed
**Then** standard Android back navigation applies — the student returns to the CuriosityScreen or Board without an AlertDialog (free back navigation, unlike CuriosityScreen)

---

### Story 3.3: Content Image Pre-fetch & Background Sync

As a student,
I want all lesson content images downloaded to my device during my first session,
So that I can study offline at any time without hitting a missing image.

**Acceptance Criteria:**

**Given** a student has completed onboarding and the app has connectivity
**When** the first sync completes (lessons written to Drift from Story 2.1)
**Then** `flutter_cache_manager` eagerly pre-fetches all images for the first topic's lessons immediately — this pre-fetch is non-blocking and does not delay navigation

**Given** the first topic's images are cached
**When** the app is connected and not actively in use (background or idle foreground)
**Then** `flutter_cache_manager` progressively pre-fetches images for all remaining topics in the background — the student never sees a missing image mid-session once the background fetch completes

**Given** the app is offline during a study session
**When** a student opens any lesson whose images were pre-fetched
**Then** all images render from the local cache with no network request and no placeholder or broken-image state (FR18)

**Given** new or updated lesson content is available in Supabase
**When** the app opens with connectivity and the content version has changed
**Then** updated content is synced to Drift and new image URLs are queued for pre-fetch — the sync runs in the background without interrupting any active session (FR19)

**Given** a pre-fetch fails for a specific image (network error mid-fetch)
**When** the student later opens that lesson
**Then** a `CircularProgressIndicator` (Calm Blue, centered) is shown while the image is fetched on-demand — the lesson is never completely inaccessible; only images in active view trigger on-demand fetches

**Given** the app is opened in airplane mode for the very first time (before any sync has completed)
**When** the student navigates to a lesson
**Then** a clear message "Content not yet downloaded. Connect to the internet to load your lessons." is shown — the app does not crash and the student is not stuck

---

## Epic 4: Quiz Engine, Completion Gate & Dopamine Loop

Students can take quizzes, have tasks moved to Done on pass, and experience the haptic + animation reward. On failure, the PivotQuestion surfaces the one concept to review. This epic delivers the core "Enforced Definition of Done" trust mechanism and the dopamine completion experience as one atomic unit.

**FRs covered:** FR14, FR20, FR21, FR22, FR23, FR24, FR25, FR26, FR33, FR34

### Story 4.1: Quiz Screen & Question Engine

As a student,
I want to take a quiz for any lesson I am studying — one question at a time — and see immediate answer feedback,
So that I can test my understanding in a focused, low-pressure format.

**Acceptance Criteria:**

**Given** a student taps "Take quiz" on the LessonContent screen
**When** the `QuizScreen` opens
**Then** the first question is displayed immediately from the Drift cache with no network request — quiz entry feels instantaneous (NFR3: answer + result ≤ 1 second)

**Given** the `QuizQuestionCard` is displayed
**When** rendered
**Then** a `LinearProgressIndicator` (Calm Blue fill) shows "question X of Y" at the top, the question stem is shown (Title Medium), and four answer options A–D are displayed as full-width `OutlinedButton` widgets — no timer is shown

**Given** the student taps an answer option
**When** the tap registers
**Then** the selected option's border highlights immediately (optimistic UI — no loading state), and a "Continue" `FilledButton` appears — the student confirms their answer with a deliberate second tap

**Given** the student taps "Continue" after selecting an answer
**When** the next question loads
**Then** the transition is immediate from Drift — no spinner between questions; the `LinearProgressIndicator` advances

**Given** the student presses the Android back gesture during a quiz
**When** the gesture fires
**Then** a `PopScope` intercepts it and an `AlertDialog` appears: "Leave this quiz? Your progress will be lost. [Stay] [Leave]" — tapping Stay returns to the quiz at the current question; tapping Leave returns to the Board with the task still In Progress

**Given** the student completes the final question and taps "Continue"
**When** the last answer is confirmed
**Then** the quiz result is calculated immediately from the local answer set — no server round-trip required for result computation

---

### Story 4.2: Quiz Pass — Task Completion Gate & Dopamine Moment

As a student,
I want to feel the haptic pulse and see the task slide to Done when I pass a quiz,
So that I know my completion is real, verified, and earned — not just logged.

**Acceptance Criteria:**

**Given** a student's quiz score meets or exceeds the subject's configured pass threshold (Chemistry = 80%)
**When** the result is evaluated
**Then** `TaskRepository.markTaskComplete(taskId)` is the ONLY code path that sets `task_status = 'done'` — no other method, notifier, or widget may write `'done'` directly

**Given** `markTaskComplete()` is called
**When** the Drift write completes
**Then** the `TaskCompletionAnimation` triggers: `Transform.scale` animates 1.0 → 1.04 → 1.0 over 300ms with `Curves.easeOut`, the left-border color transitions from Golden Yellow to Sage Green over 200ms, and `HapticFeedback.mediumImpact()` fires exactly once at peak scale (not `lightImpact`, not `heavyImpact`)

**Given** the animation completes
**When** the card settles
**Then** the pass screen displays "[ Lesson title ] — complete." (no exclamation mark, no score shown), a `RepaintBoundary` isolates the animation from parent widget rebuilds, and a "Back to board" `FilledButton` is the sole CTA

**Given** the student taps "Back to board"
**When** the Board renders
**Then** the completed task is no longer visible in the In Progress column, the Done tab becomes visible for the first time (if this is the first completion), and the dashboard coverage ring increments silently — no modal, no banner

**Given** the task completion event
**When** `markTaskComplete()` runs
**Then** a sync queue entry is enqueued in the same Drift transaction as the status update — the completion persists locally even if the device goes offline before sync

**Given** the pass screen
**When** a TalkBack user reaches it
**Then** the semantics announce: "[ Lesson title ] complete. Button: Back to board."

---

### Story 4.3: Quiz Failure — Pivot Question & Recovery Path

As a student,
I want to see the one concept I need to review when I fail a quiz,
So that I leave the failure screen knowing exactly what to do next — not feeling defeated.

**Acceptance Criteria:**

**Given** a student's quiz score is below the configured pass threshold
**When** the result is evaluated
**Then** `TaskRepository.resetTaskToInProgress(taskId)` is called — the task status remains `'in_progress'` in Drift, the `TaskCard` on the Board shows the Re-opened state (Dusty Rose border + refresh icon), and NO animation plays on the failure screen entry (the card returns quietly)

**Given** the `PivotQuestionCard` is displayed
**When** rendered
**Then** the neutral background color is used (not red, not error color), the headline reads "You're one concept away." (Calm Blue, Headline style), below it the single pivot question is shown (Body Large) with the correct answer highlighted in a Sage Green background, and the student's wrong answer is shown in a Dusty Rose background (no strikethrough, no shame)

**Given** the failure screen
**When** displayed
**Then** exactly two CTAs are present: "Review lesson" `FilledButton` (returns to the relevant section of LessonContent) and "Try again later" `OutlinedButton` (returns to the Board) — no third option, no score displayed

**Given** the student taps "Review lesson"
**When** the navigation fires
**Then** the student is returned to the LessonContent screen for the same lesson — full content is accessible with no time gate or cooldown (FR25)

**Given** the student taps "Try again later"
**When** navigation fires
**Then** the student is returned to the Board, the task card sits at the top of the In Progress column in Re-opened state — no push notification, no modal, no drama

**Given** this is the student's 3rd or later failed attempt on the same lesson
**When** the `PivotQuestionCard` renders
**Then** a small note appears above the headline in Label Medium, `onSurface` at 60% opacity: "This concept keeps coming up. Go back to fundamentals." — no alert color, no icon

**Given** each quiz attempt (pass or fail)
**When** the result is recorded
**Then** a `quiz_attempts` record is inserted into Drift with `student_id`, `lesson_id`, `score`, `pass_fail`, `attempted_at`, and a sync queue entry is enqueued in the same transaction (FR26)

---

### Story 4.4: Quiz Retry Flow & Attempt History

As a student,
I want to retry a failed quiz immediately or return to it later at any time,
So that I control my own pace — the system never locks me out or pressures me with a timer.

**Acceptance Criteria:**

**Given** the student is on the `PivotQuestionCard` screen
**When** they tap "Try again later" and later return to the In Progress task on the Board
**Then** tapping the task card shows the bottom sheet with "Start studying" as the primary CTA — the full study loop (CuriosityScreen → LessonContent → Quiz) is available with no cooldown

**Given** the student taps "Start studying" on a previously failed task
**When** the lesson flow opens
**Then** the `CuriosityScreen` is shown again (curiosity_completed resets on each new attempt cycle), the lesson content is fully accessible, and the quiz is available at the end

**Given** the student has multiple prior quiz attempts on a lesson
**When** the student takes the quiz again
**Then** a new `quiz_attempts` record is created in Drift for this attempt — prior attempts are not overwritten; the full attempt history is preserved for accuracy analytics (FR29)

**Given** the student passes the quiz on a retry attempt
**When** the pass is evaluated
**Then** the same `TaskRepository.markTaskComplete()` path fires — the haptic, animation, and Done state are identical to a first-attempt pass; the emotional weight is carried by context, not by a different animation

**Given** the quiz is attempted offline
**When** the student submits answers
**Then** the result is computed locally from the Drift-stored quiz questions and correct answers — no network request is required for quiz evaluation (FR40)

---

## Epic 5: Offline Reliability & Background Sync

Students have full app functionality without connectivity. Task state changes and quiz completions persist locally and sync automatically within 5 seconds of reconnecting. Zero data loss. This epic activates the sync queue consumer that Epics 1–4 have been building up.

**FRs covered:** FR39, FR40, FR41, FR42, FR43

### Story 5.1: Sync Queue Consumer & Connectivity Service

As a student,
I want my task state changes and quiz completions to sync to the server automatically when I reconnect,
So that my progress is never lost even when I study offline.

**Acceptance Criteria:**

**Given** the `connectivity_plus` package is integrated and a `ConnectivityService` wraps it
**When** the device transitions from offline to online
**Then** the `SyncService` is notified within 1 second of the connectivity change — no manual user action required (FR42)

**Given** the `SyncService` is triggered on connectivity restore
**When** it processes the `sync_queue`
**Then** it dequeues entries in `created_at` order, executes idempotent Supabase upserts for each entry, and completes all pending operations within 5 seconds of connectivity returning (FR41)

**Given** a Supabase upsert succeeds for a sync queue entry
**When** the operation completes
**Then** the entry is deleted from `sync_queue` in Drift — no duplicate records are created on retry (NFR16)

**Given** a Supabase upsert fails (server unavailable or transient error)
**When** the operation fails
**Then** the `retry_count` on the sync queue entry is incremented, the entry is retained in `sync_queue` for the next sync cycle, and the failure is logged to `sync_error_log` — no silent data loss (NFR17)

**Given** a sync queue entry reaches `retry_count ≥ 3`
**When** the 3rd retry fails
**Then** the entry is moved to `sync_error_log` with the failure reason, a non-blocking `SnackBar` is shown to the student ("Some changes couldn't sync. We'll keep trying."), and the app continues to function normally

**Given** a sync event is in progress
**When** the student is mid-quiz or mid-lesson
**Then** the sync runs entirely in the background — no UI interruption, no loading overlay, no navigation disruption (FR43, NFR18)

---

### Story 5.2: Offline Mode Indicator & Reconnection Feedback

As a student,
I want to know when I'm offline and see confirmation when my changes sync after reconnecting,
So that I always understand the state of my data without feeling anxious about it.

**Acceptance Criteria:**

**Given** the device loses connectivity while the app is open
**When** `ConnectivityService` detects the transition
**Then** a persistent `SnackBar` appears at the bottom of the screen: "You're offline. Your lessons are still available." — displayed in `inverseSurface`/`onInverseSurface` neutral colors (not error red), with no dismiss button

**Given** the offline `SnackBar` is showing
**When** the device reconnects
**Then** the SnackBar text updates in-place to "Back online. Syncing…" without dismissing and re-appearing — same bar, text swap only

**Given** the sync completes within 3 seconds of reconnect
**When** all pending sync_queue entries are processed
**Then** the SnackBar auto-dismisses after a 2-second hold — no confirmation modal, no user action required

**Given** the sync takes longer than 3 seconds
**When** sync finally completes
**Then** a brief "Synced" SnackBar appears for 2 seconds and then dismisses

**Given** the app is opened while offline (cold start offline)
**When** the Board and Dashboard screens load
**Then** all previously cached content renders immediately from Drift with no loading spinner — returning users never see a spinner for data that is in the local cache (FR39)

**Given** the student is offline and updates task state or completes a quiz
**When** these actions occur
**Then** the student never sees a "can't do this offline" error — all state changes persist locally and the UI reflects the updated state immediately (FR40)

---

### Story 5.3: Crash Resilience & Data Integrity Verification

As a student,
I want my offline progress to survive app crashes and device restarts,
So that a forced close never means lost study data.

**Acceptance Criteria:**

**Given** a student completes a quiz and the result is written to Drift
**When** the app is force-closed immediately after the Drift write (before any sync)
**Then** on next app open, the `quiz_attempts` record exists in Drift and the `lesson_tasks` status is correct — no data was lost (NFR14, NFR15)

**Given** a task state change is written to Drift and enqueued in the same transaction
**When** the device restarts before sync completes
**Then** on next app open with connectivity, the `SyncService` finds the pending `sync_queue` entry and syncs it to Supabase — the change is not lost (NFR15)

**Given** a sync operation is interrupted mid-flight (app killed during Supabase upsert)
**When** the app reopens and the sync service processes the queue
**Then** the same upsert is retried and succeeds — idempotent upserts ensure no duplicate records are created in Supabase (NFR16)

**Given** the Drift database is the source of truth
**When** any conflict exists between Drift state and Supabase state (e.g., delayed sync)
**Then** the Drift local state takes precedence in all UI rendering — Supabase is the sync target, not the source of truth for the client

---

## Epic 6: Progress Dashboard & Analytics

Students can see their honest, quiz-verified progress — coverage %, per-topic accuracy, weakest topics ranked, and progress vs. the 80% Chemistry threshold. This is the anxiety antidote: open the app and know exactly where you stand.

**FRs covered:** FR27, FR28, FR29, FR30, FR31, FR32

### Story 6.1: Subject Coverage Card & Coverage Ring

As a student,
I want to see my overall Chemistry coverage percentage as a visual ring on the Dashboard Home,
So that I know at a glance how much of the syllabus I have genuinely completed.

**Acceptance Criteria:**

**Given** the student opens the Dashboard tab
**When** the screen renders
**Then** a swipeable `PageView` of `SubjectCoverageCard` widgets appears as the hero element — one card per enrolled subject, with `viewportFraction: 0.9` so the edge of the next card is always visible (signalling swipeability)

**Given** the `SubjectCoverageCard` for Chemistry
**When** rendered
**Then** it displays: Calm Blue (`#007BFF`) filled background, the subject name (Title Large, white), a `CoverageRing` CustomPainter centered on the card, the coverage percentage in JetBrains Mono below the ring, and "X of Y lessons Done" (Label Medium, white 70% opacity)

**Given** the `CoverageRing` CustomPainter
**When** the coverage percentage changes
**Then** `shouldRepaint` returns `true` only when the coverage value changes — not on parent widget rebuilds; a `RepaintBoundary` wraps every `CoverageRing` instance

**Given** the coverage percentage is calculated
**When** displayed
**Then** it reflects only quiz-verified Done lessons (`task_status = 'done'`) divided by total lessons — never rounded up, never self-reported completion (FR27)

**Given** the student has no completed lessons yet
**When** the Dashboard Home opens for the first time
**Then** the `CoverageRing` shows 0% with the arc at zero — no placeholder copy, no encouragement inflation; this honest start is the design intent

**Given** the `SubjectCoverageCard`
**When** a TalkBack user focuses it
**Then** the semantics label reads: "[Subject name], [X]% coverage, [Y] of [Z] lessons complete"

---

### Story 6.2: Per-Topic Accuracy & Weakest Topics Screen

As a student,
I want to see my accuracy rate per topic and my weakest topics ranked at the top,
So that I know exactly which areas need the most attention — no hiding from the truth.

**Acceptance Criteria:**

**Given** the student taps the stats row on the Dashboard Home
**When** the accuracy breakdown screen opens
**Then** an `AccuracyBar` CustomPainter row is shown for each Chemistry topic the student has attempted at least one quiz on

**Given** the `AccuracyBar` for a topic
**When** rendered
**Then** it displays: topic name (Label Medium, left-aligned), a horizontal fill bar proportional to accuracy %, and the accuracy % right-justified in JetBrains Mono Regular

**Given** the fill bar color
**When** accuracy is calculated
**Then** the bar color is: Calm Blue (`#007BFF`) for accuracy below 60%, Golden Yellow (`#FFC107`) for 60–79%, Sage Green (`#4CAF78`) for 80% and above

**Given** the accuracy breakdown screen
**When** topics are sorted
**Then** they are sorted ascending by accuracy — the weakest topic appears first; the student sees the gap before the wins (FR30)

**Given** accuracy is calculated per topic
**When** a student has multiple quiz attempts on the same lesson
**Then** accuracy is computed as: (total correct answers across all attempts for lessons in that topic) / (total questions answered across all attempts for that topic) — not just the most recent attempt (FR29)

**Given** the student has not yet attempted any quiz
**When** the accuracy breakdown screen opens
**Then** the empty state displays: "Complete your first quiz to see your accuracy here." (Label Large, centred) — no illustration, no distraction

**Given** each `AccuracyBar` CustomPainter
**When** rendered
**Then** a `RepaintBoundary` wraps each row and `shouldRepaint` returns `true` only when that row's accuracy value changes

---

### Story 6.3: Dashboard Stats Row, Streak Counter & Threshold Progress

As a student,
I want to see my past paper completion, streak, and progress vs. the 80% target in a single glance,
So that I have all the information I need to understand where I stand without hunting for it.

**Acceptance Criteria:**

**Given** the Dashboard Home below the subject cards
**When** rendered
**Then** a stats row shows three values side by side: current engagement streak (consecutive days of app activity), overall accuracy % across all topics, and total tasks in Done state (FR32)

**Given** the coverage % shown on the `SubjectCoverageCard`
**When** it is displayed
**Then** a visual indicator or label shows the student's progress relative to the 80% Chemistry completion threshold (e.g., a threshold marker on the ring or a "Target: 80%" label below the %) (FR31)

**Given** the past paper completion percentage per topic (FR28)
**When** displayed on the accuracy breakdown screen or Dashboard Home
**Then** it is calculated as: (lessons with `content_track = 'past_papers'` and `task_status = 'done'`) / (total lessons with `content_track = 'past_papers'`) per topic — separately from theory coverage

**Given** a task is marked Done (via `markTaskComplete()` in Epic 4)
**When** the Board returns
**Then** the Dashboard Home coverage ring increments silently — no modal, no celebration banner; the board looking different is the reward

**Given** the Dashboard renders with all metrics
**When** opened on a 3-year-old mid-range Android
**Then** all metrics render within 2 seconds (NFR4) and `CustomPainter` frame time stays below 16ms — verified via Flutter DevTools profiling

---

## Epic 7: Streak Mechanics & In-App Survey

Students see their streak counter driving daily return habit. The in-app satisfaction/stress survey provides Lahiru with validation data on anxiety reduction — one of the four experiment hypotheses. Cut FR37/FR38 first if timeline pressure hits, then FR35/FR36.

**FRs covered:** FR35, FR36, FR37, FR38

### Story 7.1: Streak Indicator & Graceful Reset

As a student,
I want to see my consecutive-days streak displayed without pressure or punishment when I miss a day,
So that the streak feels like momentum, not an obligation.

**Acceptance Criteria:**

**Given** a student opens the app on a new calendar day
**When** `last_active_at` in Drift is from the previous calendar day (yesterday)
**Then** the streak counter in Drift increments by 1 and the updated count is displayed in the Dashboard stats row

**Given** a student misses one or more days (gap between `last_active_at` and today > 1 calendar day)
**When** the app is opened
**Then** the streak counter resets to 1 (today counts as day 1 of a new streak) — no punishment UI, no "you broke your streak" message, no animation drawing attention to the reset (FR36)

**Given** the `StreakIndicator` widget in the Dashboard stats row
**When** rendered
**Then** it displays the current streak count as a number with a low-visual-weight flame or calendar icon — the widget does not dominate the stats row; it is one of three equal stats

**Given** a student fails a quiz on a day they were active
**When** streak is calculated
**Then** the quiz failure does NOT break the streak — daily app activity (not quiz pass) is the streak criterion (FR36)

**Given** streak data is updated
**When** the app is offline
**Then** the streak count is computed from `last_active_at` in local Drift and displayed correctly — no network required for streak display

---

### Story 7.2: In-App Satisfaction Survey

As a student,
I want to occasionally respond to a short, fun survey about my study stress and satisfaction,
So that I can reflect on how my study experience is changing over the 6-month experiment.

**Acceptance Criteria:**

**Given** the survey trigger logic (configurable interval — default every 4 weeks)
**When** the trigger fires and the student opens the app
**Then** a survey prompt appears as a `ModalBottomSheet` or dedicated screen — it does not interrupt a study session or quiz in progress

**Given** the survey is presented
**When** rendered
**Then** it is styled as a fun, lightweight quiz — emoji-style or illustrated answer options — not a formal questionnaire with a progress bar and numbered questions

**Given** the student responds to all survey questions
**When** the submission is confirmed
**Then** a `survey_responses` record is created in Drift with `student_id`, `responded_at`, and the responses as a JSON payload, and a sync queue entry is enqueued for Supabase sync (FR38)

**Given** the student dismisses the survey without responding
**When** they close it
**Then** no `survey_responses` record is created, no error occurs, and the next trigger fires at the next scheduled interval — the student is never guilt-tripped for skipping

**Given** the app is offline when a survey is submitted
**When** connectivity returns
**Then** the survey response syncs to Supabase via the sync queue with no data loss

**Given** survey responses in Supabase
**When** queried for experiment analysis
**Then** responses are queryable by `student_id` and `responded_at` to track stress/satisfaction trends over the 6-month experiment period

---

## Epic 8: Push Notifications & Account Lifecycle

Students receive FCM server-push engagement nudges after inactivity. The nudge hypothesis is fully instrumented. Students can deactivate or permanently delete their account with PDPA-compliant PII anonymization.

**FRs covered:** FR44, FR46, FR5, FR6

### Story 8.1: FCM Engagement Nudge & Hypothesis Instrumentation

As a student,
I want to receive an encouraging reminder when I haven't studied in 3 or more days,
So that I get a nudge back to my board when life gets busy.

**Acceptance Criteria:**

**Given** a `pg_cron` scheduled job runs daily (e.g., 08:00 local time) in Supabase
**When** it fires
**Then** it invokes a Supabase Edge Function that queries: `SELECT student_id, fcm_token FROM students WHERE last_active_at < now() - interval '3 days' AND fcm_token IS NOT NULL AND notifications_enabled = true`

**Given** the Edge Function identifies eligible students
**When** it processes each student
**Then** it calls the FCM HTTP v1 API with an encouraging, factual message (e.g., "Your board is waiting — pick up where you left off"), inserts a row into `nudge_events` (`student_id`, `sent_at`, `fcm_message_id`, `status = 'sent'`), and the FCM server key is accessed only from Supabase secrets — never from the Flutter client

**Given** a student receives the FCM notification and taps it
**When** `FirebaseMessaging.onMessageOpenedApp` fires on the Flutter client
**Then** the app opens, a `sessions` record is created with `attributed_nudge_id` set to the matching `nudge_events.id` (within a 72-hour attribution window), and the student is routed to the Board

**Given** a student's FCM token is stale or delivery fails
**When** the FCM API returns a delivery failure
**Then** the `nudge_events` record status is updated to `'failed'` — failed deliveries are excluded from the hypothesis conversion rate calculation

**Given** a student has `notifications_enabled = false` (denied permission at onboarding)
**When** the cron job runs
**Then** that student is excluded from the query — no nudge is sent, no error occurs, full app functionality is unaffected (FR46)

**Given** nudge and session data in Supabase after 6 months
**When** queried for experiment analysis
**Then** the nudge-to-return conversion rate is computable as: `(sessions with attributed_nudge_id) / (nudge_events with status = 'delivered')` within the 72-hour attribution window

---

### Story 8.2: Account Deactivation

As a student,
I want to deactivate my account when I need a break,
So that I can stop using the app without losing my study data.

**Acceptance Criteria:**

**Given** the student navigates to Profile → Account settings
**When** they tap "Deactivate account"
**Then** an `AlertDialog` confirmation appears: "Deactivate account? You can reactivate by logging in again. Your progress is saved. [Cancel] [Deactivate]" — tapping outside or back dismisses the dialog (no accidental deactivation)

**Given** the student confirms deactivation
**When** the action is processed
**Then** the student's Supabase Auth session is invalidated, `students.deactivated_at` is set in Supabase, and the student is routed to the login screen

**Given** a deactivated student attempts to log in
**When** authentication succeeds
**Then** the account is automatically reactivated (`deactivated_at` cleared), and the student is routed to the Dashboard Home with all their data intact (FR5)

**Given** a deactivated account in Supabase
**When** any student-facing query runs
**Then** RLS excludes deactivated accounts from any cross-student queries — no deactivated student data surfaces to other users

---

### Story 8.3: Account Deletion & PDPA-Compliant PII Anonymization

As a student,
I want to permanently delete my account and have my personal information removed,
So that my data is handled according to my rights under Sri Lanka's PDPA.

**Acceptance Criteria:**

**Given** the student navigates to Profile → Account settings
**When** they tap "Delete account"
**Then** an `AlertDialog` confirmation with a destructive `OutlinedButton` (Dusty Rose border) appears: "Delete account? This cannot be undone. Your personal data will be removed. [Cancel] [Delete account]" — tapping outside does NOT dismiss this dialog (destructive confirmation only via explicit button tap)

**Given** the student confirms deletion
**When** the deletion transaction executes in Supabase
**Then** in a single atomic transaction: `students.deleted_at` is set, AND `students.name`, `students.email`, `students.district`, `students.school` are immediately set to null/anonymized values — PII anonymization and soft-delete happen together, never separately (FR6, NFR12)

**Given** the deletion transaction completes
**When** any student-facing SELECT query runs
**Then** RLS excludes soft-deleted records (`deleted_at IS NOT NULL`) — no deleted student's data appears in any student-facing view

**Given** historical records in `quiz_attempts`, `sessions`, `nudge_events`, `survey_responses`
**When** the account is deleted
**Then** these records are retained in Supabase for product analytics with `student_id` intact but the student's PII fields anonymized — historical logs are preserved without exposing personal data

**Given** the deletion completes
**When** the student is notified
**Then** a confirmation screen states "Your account has been deleted. Thank you for using StudyBoard." and the student is routed to the login screen — they cannot log back in with the deleted credentials
