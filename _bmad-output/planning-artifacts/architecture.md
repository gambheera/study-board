---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
lastStep: 8
workflowStatus: complete
completedAt: '2026-04-15'
inputDocuments:
  - "_bmad-output/planning-artifacts/prd.md"
  - "_bmad-output/planning-artifacts/product-brief-StudyBoard-distillate.md"
  - "_bmad-output/planning-artifacts/ux-design-specification.md"
workflowType: 'architecture'
project_name: 'StudyBoard'
user_name: 'Lahiru'
date: '2026-04-15'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**
46 FRs across 8 categories:
- **User Account Management (FR1–6):** Email/password + Google OAuth registration and login; profile updates; account deactivation (soft-disable, data retained); soft-delete with PII anonymization and log retention.
- **Syllabus & Task Board (FR7–14):** Full syllabus in Backlog view; Kanban board (To-Do / In Progress / Done); task pull and promotion; content track filtering (Theory, Past Papers, Future Papers); system-enforced quiz gate — task cannot move to Done without passing quiz.
- **Content & Learning Flow (FR15–19):** Non-skippable curiosity-first warm-up (past paper questions shown before lesson); lesson content with rich media (image-based formulas and diagrams); full offline access; background content update sync.
- **Assessment & Progress Verification (FR20–26):** Quiz taking, configurable pass threshold (Chemistry = 80%); fail = task re-opens neutrally; pass = task marked Done; immediate retry or return-later flow; per-attempt score recording.
- **Progress Dashboard & Analytics (FR27–32):** Quiz-verified coverage %; past paper completion % per topic; accuracy rate per topic; weakest topics ranked ascending; coverage vs. configured threshold; engagement streak counter.
- **Engagement & Motivation (FR33–38):** Haptic feedback (VIBRATE) on task completion; visual reward animation; streak counter (resets gracefully, no punishment UI); periodic in-app satisfaction survey (fun quiz format); survey response recording.
- **Offline & Sync (FR39–43):** Full offline functionality for lessons, quizzes, and task state changes; local-first persistence before any sync; auto-sync within 5s of connectivity return; network state detection; no session interruption on sync events.
- **Notifications (FR44–46):** Engagement nudge after 3 consecutive days inactive (FCM); runtime permission request on Android 13+ during onboarding; full app functionality without notification permission.

**Non-Functional Requirements:**
- **Performance (baseline: 3-year-old mid-range Android, API 30, ~2–3GB RAM):**
  - Cold start to fully interactive board: ≤3s
  - Task card interaction: ≤200ms
  - Quiz answer + result: ≤1s
  - Dashboard render: ≤2s
  - Offline content render: ≤2s
  - Animations: 60fps sustained
  - Offline changes sync on reconnect: ≤5s
- **Security:** HTTPS/TLS enforced; Supabase Postgres encryption at rest; Row-Level Security on all student data; Google OAuth 2.0 (no credentials stored); soft-delete PII anonymized immediately on request.
- **Reliability:** Zero data loss guarantee (local-first, crash-resilient); idempotent sync (no duplicate records on retry); graceful sync failure (queued offline changes retained and retried); no in-session interruption during sync events.
- **Integration:** Google Sign-In SDK (OAuth 2.0, transparent token refresh); Supabase JWT + RLS on all API calls; FCM push notifications (graceful degradation if FCM unreachable or permission denied).

**Scale & Complexity:**
- **Primary domain:** Flutter/Dart mobile application, Android-first
- **Complexity level:** Medium — offline-first sync with crash resilience, enforced state machine, dual authentication, rich media content caching, PDPA compliance, 60fps animation on constrained hardware
- **Project context:** Greenfield, V1 solo developer, 10-student test group
- **Estimated architectural components:** 9 major areas

### Technical Constraints & Dependencies

- **Framework:** Flutter (Dart), min Android API 30, no Play Store for V1 (signed APK sideload)
- **Backend:** Supabase (Postgres + Auth + Storage); all data access via RLS policies
- **Auth:** Supabase Auth (email/password) + Google Sign-In SDK (OAuth 2.0)
- **Push notifications:** Firebase Cloud Messaging (FCM)
- **Offline storage:** Local database (Drift/SQLite) as source of truth; Supabase as sync target
- **Rich media:** Image-based only (no LaTeX); images pre-cached locally at first sync
- **Conflict resolution:** Last-write-wins (single device per student, V1)
- **Multi-subject:** Schema must be subject-agnostic from day one; V1 seeds Chemistry data only
- **Distribution:** Signed APK sideload for V1; Play Store deferred to post-MVP

### Cross-Cutting Concerns Identified

1. **Offline-first state management** — every write (task status, quiz result, survey response) must persist locally before any sync attempt; sync queue must survive crash and force-close
2. **Quiz gate state machine** — task state transitions are atomic and system-enforced; Backlog → To-Do → In Progress → Done, with quiz-fail = re-open to In Progress; no client-side bypass
3. **Multi-subject data model** — all schema entities (Subject, Topic, Lesson, Task, Quiz, etc.) are subject-keyed from day one; Chemistry is a data concern, not a schema variation
4. **Rich media caching strategy** — all lesson images pre-fetched and locally cached at first sync; no mid-session network fetches for content
5. **60fps performance on constrained hardware** — `Transform` over `Opacity` in animations, no `BackdropFilter`, single `HapticFeedback.mediumImpact()` on completion, test exclusively on API 30 target device
6. **RLS + auth token lifecycle** — every Supabase API call is authenticated via JWT; token refresh is transparent and never interrupts offline sessions
7. **PII anonymization on soft-delete** — deletion request immediately anonymizes name, email, district, school in retained logs; no student-facing exposure of deleted-user data

## Starter Template Evaluation

### Primary Technology Domain

Flutter/Dart mobile application (Android-first) — fixed by PRD.

Three open architectural choices left by `flutter create` resolved here: project scaffold, state management, and local offline database.

### Starter Options Considered

**Scaffold:**
- `flutter create` (bare) — no architecture, no test setup; high overhead for V1 solo build
- Very Good CLI 1.0.0 — opinionated feature-first structure, 100% test coverage scaffold, Flutter 3.41 templates, fail-fast testing, stable API (released Feb 2026)
- Community Supabase starters — either BLoC-mandated, auth-incomplete, or commercial

**State management:**
- Riverpod 3.0 — compile-time safe, built-in offline persistence, low boilerplate, 2026 primary recommendation
- BLoC 9.0 — enterprise/regulated; higher boilerplate; not warranted for V1 solo build

**Local database:**
- Drift (SQLite ORM) — relational, SQL, compile-time safe migrations, actively maintained
- Isar — fast object store, author abandoned (Rust core), migration risks
- Hive — key-value only, author abandoned, inappropriate for relational data model

### Selected Scaffold: Very Good CLI 1.0.0

**Rationale:** Provides production-ready project structure, test infrastructure, and Flutter 3.41 alignment without mandating a specific state management solution. Eliminates boilerplate setup cost critical for a 2-week V1 window.

**Initialization Command:**

```bash
dart pub global activate very_good_cli
very_good create flutter_app studyboard --org com.lahiru.studyboard --desc "A/L Chemistry study OS"
```

**Architectural Decisions Provided by Scaffold:**

**Language & Runtime:**
Dart, Flutter 3.41, null-safety enforced, strict analysis options

**Project Structure:**
Feature-first folder layout: `lib/features/<feature>/`, with `data/`, `domain/`, `presentation/` layers per feature; shared code under `lib/core/`

**Testing Framework:**
100% test coverage scaffold; unit, widget, and integration test directories pre-configured; fail-fast test runner; mocktail for mocking

**Code Quality:**
Very Good Analysis lint rules; strict static analysis; formatted with `dart format`

**Development Experience:**
Flutter-native hot reload; CI configuration included; MCP integration for AI-assisted dev

**Note:** Project initialization using this command is the first implementation story.

---

### Selected State Management: Riverpod 3.0

**Rationale:** Compile-time safety, built-in offline persistence, lowest boilerplate of any production-ready solution. Ideal for solo developer building offline-first app on a fast iteration cycle. BLoC's enterprise strengths are not load-bearing at V1 scale.

**Package:**
```yaml
flutter_riverpod: ^3.0.0
riverpod_annotation: ^3.0.0
```

---

### Selected Local Database: Drift (SQLite ORM)

**Rationale:** StudyBoard's data is relational (Subject → Topic → Lesson → Task → QuizAttempt). Dashboard queries (weakest topics ranked by accuracy, per-topic accuracy rates, coverage %) are SQL-native. Compile-time safe migrations are critical for a solo developer — no migration surprises on student devices. Isar (author-abandoned, Rust core) and Hive (key-value, abandoned) are inappropriate for this data model and reliability standard.

**Package:**
```yaml
drift: ^2.x
drift_flutter: ^0.2.x   # SQLite on Android
```

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
- Offline sync architecture: Custom Drift sync queue + connectivity_plus
- Navigation: go_router
- Supabase access: Repository layer pattern
- Feature folder structure established

**Important Decisions (Shape Architecture):**
- Content pre-fetch: flutter_cache_manager with explicit pre-fetch at first sync
- Error handling: Result type (`Either<Failure, T>`) + Riverpod AsyncValue
- Auth session: supabase_flutter default session storage
- RLS design: student-scoped `auth.uid() = student_id` on all data tables
- Crash reporting: Firebase Crashlytics

**Deferred Decisions (Post-MVP):**
- CI/CD automation: GitHub Actions (template included by VGC, wired post-V1)
- Admin content UI: Supabase Dashboard + SQL scripts for V1
- flutter_secure_storage: upgrade path for auth tokens post-V1 if needed

### Data Architecture

**Offline Sync: Custom Drift sync queue**
- `sync_queue` table in Drift records pending operations (entity type, entity ID, operation, payload, timestamp)
- `connectivity_plus` monitors network state; on connectivity restore, sync service processes queue
- Each operation is an idempotent Supabase upsert — safe to retry
- On successful sync, queue entry deleted; on failure, entry retained for next retry
- Local Drift state is always source of truth; Supabase is the sync target
- Rationale: full debuggability, no hidden abstractions, fits chosen Drift + Supabase stack

**Content Pre-fetch: flutter_cache_manager**
- All lesson images pre-fetched to local cache at first successful sync
- No mid-session network requests for content (FR18 compliance)
- Image URLs stored in Drift alongside lesson records; cache key = URL hash
- Rationale: only approach that guarantees full offline content access with zero edge cases

**Database Migrations: Drift compile-time safe migrations**
- All schema changes via Drift's migration API with version increment
- Tested against a fresh install and an upgrade from v(n-1) before APK distribution

### Authentication & Security

**Session Persistence: supabase_flutter default**
- Supabase Flutter SDK manages session internally via shared_preferences
- Sufficient for V1 10-student scope under PDPA; flutter_secure_storage upgrade path noted for post-V1
- Google Sign-In: google_sign_in SDK; OAuth 2.0; no credentials stored by app; token refresh transparent

**RLS Policy Design: student-scoped on all data tables**
- All student data tables: `auth.uid() = student_id` on SELECT, INSERT, UPDATE, DELETE
- Syllabus/content tables (subjects, topics, lessons, quiz questions): public SELECT, no write
- Soft-delete: sets `deleted_at` + anonymizes PII fields in the same transaction; RLS excludes soft-deleted records from all student-facing queries

### API & Communication Patterns

**Supabase Access: Repository layer**
- Each feature has a repository interface (e.g., `TaskRepository`, `QuizRepository`)
- Repositories are injected via Riverpod providers
- Read path: Drift first (offline source of truth); write path: Drift + enqueue to sync queue
- Supabase client is never called directly from ViewModels/Notifiers

**Error Handling: Result type + AsyncValue**
- Repository methods return `Either<Failure, T>` — all errors typed, no uncaught exceptions
- Riverpod Notifiers surface errors via `AsyncValue.error` for UI handling
- Sync failures: logged to local `sync_error_log` table, retried on next sync cycle; never silently dropped

### Flutter Architecture

**Navigation: go_router**
- Declarative route definitions; type-safe route parameters
- Deep-link ready (supports future Play Store requirements)
- Shell routes for bottom navigation bar; nested routes within features

**Feature Folder Structure:**
```
lib/
  features/
    auth/          (login, registration, profile, account management)
    board/         (kanban board, backlog view)
    lesson/        (curiosity-first flow, lesson content)
    quiz/          (quiz engine, pass/fail, failure screen, pivot question)
    dashboard/     (coverage %, accuracy, weakest topics, streak)
    notifications/ (FCM token management, notification handling)
    survey/        (in-app satisfaction survey)
  core/
    database/      (Drift database, tables, DAOs)
    sync/          (sync queue service, connectivity listener)
    supabase/      (Supabase client, repository base class)
    theme/         (Material 3 ThemeData, color tokens, typography)
```

### Infrastructure & Deployment

**Crash Reporting: Firebase Crashlytics**
- Same Firebase project as FCM; zero additional account setup
- Non-fatal errors reported for sync failures and auth edge cases

**Content Seeding (V1): Supabase Dashboard + SQL scripts**
- Chemistry syllabus data inserted via Supabase Studio and SQL insert scripts
- Architecture is subject-agnostic; V1 only loads Chemistry data
- Admin UI is a post-V1 feature

**CI/CD: Deferred (GitHub Actions template from VGC ready to activate post-V1)**

### Decision Impact Analysis

**Implementation Sequence:**
1. VGC scaffold + project structure + Drift schema + RLS policies
2. Auth (Supabase + Google Sign-In) + session persistence
3. Syllabus content seeding (SQL scripts for Chemistry)
4. Board feature: local Drift state, task state machine, kanban UI
5. Lesson + curiosity-first flow + image pre-fetch
6. Quiz engine + gate enforcement + failure screen
7. Sync queue service + connectivity_plus integration
8. Dashboard analytics (computed from Drift)
9. Engagement: haptics + animations + streak
10. FCM push notifications + in-app survey
11. Account management: deactivation + soft-delete + PII anonymization

**Cross-Component Dependencies:**
- Sync queue depends on Drift schema being finalized first
- Quiz gate state machine is a dependency of both the Board and Dashboard features
- FCM token registration happens at auth time — auth must be complete before notifications
- Dashboard queries are pure Drift SQL — no Supabase dependency after content sync

## Implementation Patterns & Consistency Rules

### Pattern Categories Defined

**Critical Conflict Points Identified:** 9 areas where AI agents could make inconsistent choices without explicit rules: database naming, Dart code naming, JSON field mapping, task state machine representation, Riverpod provider conventions, repository layer structure, sync queue format, animation/haptic implementation, and error type hierarchy.

### Naming Patterns

**Database (Supabase / Drift) Naming:**

| Entity | Convention | Example |
|---|---|---|
| Supabase table names | `snake_case`, plural | `students`, `lesson_tasks`, `quiz_attempts` |
| Column names | `snake_case` | `student_id`, `created_at`, `task_status` |
| Drift table class names | PascalCase + `Table` suffix | `LessonTasksTable`, `QuizAttemptsTable` |
| Drift DAO class names | PascalCase + `Dao` suffix | `TaskDao`, `QuizDao` |
| Primary keys | `id` (UUID, text) | `id TEXT NOT NULL PRIMARY KEY` |
| Foreign keys | `{entity}_id` | `student_id`, `lesson_id`, `subject_id` |

**Dart / Flutter Code Naming:**

| Entity | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `task_repository.dart`, `board_notifier.dart` |
| Classes | PascalCase | `TaskRepository`, `BoardNotifier` |
| Variables / parameters | camelCase | `studentId`, `taskStatus`, `lessonTitle` |
| Riverpod providers | camelCase + `Provider` | `taskRepositoryProvider`, `boardNotifierProvider` |
| Riverpod notifiers | PascalCase + `Notifier` | `BoardNotifier`, `QuizNotifier` |
| Riverpod state classes | PascalCase + `State` | `BoardState`, `QuizState` |
| Repository interfaces | PascalCase + `Repository` | `TaskRepository`, `QuizRepository` |
| Repository implementations | PascalCase + `RepositoryImpl` | `TaskRepositoryImpl` |
| Enums | PascalCase enum, camelCase values | `enum TaskStatus { backlog, todo, inProgress, done }` |

**Screen / Widget Naming:**

| Entity | Convention | Example |
|---|---|---|
| Screen widgets | PascalCase + `Screen` | `BoardScreen`, `LessonScreen`, `QuizScreen` |
| Reusable widgets | PascalCase descriptive noun | `TaskCard`, `CoverageRing`, `WeakTopicRow` |
| Screen files | `snake_case_screen.dart` | `board_screen.dart`, `quiz_screen.dart` |
| Widget files | `snake_case.dart` | `task_card.dart`, `coverage_ring.dart` |

### Structure Patterns

**Feature Layer Organization:**
```
features/board/
  data/
    board_repository_impl.dart   # Supabase + Drift implementation
  domain/
    board_repository.dart        # Abstract interface
    task.dart                    # Domain model (immutable, freezed)
  presentation/
    board_screen.dart
    board_notifier.dart          # Riverpod AsyncNotifier
    board_state.dart             # State class (freezed)
    widgets/                     # Screen-specific widgets
```

**Shared Core Organization:**
```
core/
  database/
    app_database.dart            # Drift AppDatabase class
    tables/                      # One file per Drift table definition
    daos/                        # One DAO per feature domain
  sync/
    sync_queue_table.dart        # sync_queue + sync_error_log tables
    sync_service.dart            # Processes queue on connectivity restore
    connectivity_service.dart    # Wraps connectivity_plus
  supabase/
    supabase_client_provider.dart
    repository_base.dart         # Base class with error handling helpers
  theme/
    app_theme.dart               # Material 3 ThemeData
    app_colors.dart              # Color token constants
    app_typography.dart          # TextStyle definitions
  failures/
    failure.dart                 # Sealed Failure class hierarchy
```

**Test Structure (mirrors lib/):**
```
test/
  features/
    board/
      data/board_repository_impl_test.dart
      presentation/board_notifier_test.dart
  core/
    sync/sync_service_test.dart
    database/app_database_test.dart
```

### Format Patterns

**JSON / Supabase Field Mapping:**
- Supabase returns `snake_case` JSON — always map to camelCase Dart models via explicit `fromJson`/`toJson`
- Never use dynamic field access (`map['user_id']`) above the `data/` layer — always typed models
- `DateTime` fields: stored as ISO 8601 UTC string in Supabase; `DateTime` (UTC) in Dart; local timezone for display only
- All `id` fields: UUID strings (`TEXT`)

**Task Status Representation:**
- Stored in Drift and Supabase as lowercase string: `'backlog'`, `'todo'`, `'in_progress'`, `'done'`
- Dart enum: `enum TaskStatus { backlog, todo, inProgress, done }`
- Conversion: `TaskStatus.fromString(String s)` factory + `TaskStatus.toDbString()` extension — never raw string comparisons

**Null Handling:**
- No nullable fields in domain models unless absence is a meaningful state
- Never use null-assert (`!`) outside of provably non-null contexts; use `?? fallback` or explicit guards

### Communication Patterns

**Task State Machine — CRITICAL:**

The quiz gate is system-enforced. All agents must follow this exact state machine:

```
Backlog ──[student pulls]──────────→ To-Do
To-Do   ──[student starts]─────────→ In Progress
In Progress ──[quiz PASS, system]──→ Done
In Progress ──[quiz FAIL]──────────→ In Progress (stays open)
Done    ──[no valid transition in V1]
```

- The `Done` transition is **only ever triggered by `QuizNotifier` on quiz pass** — never by direct user action or any other code path
- Named repository method: `TaskRepository.markTaskComplete(taskId)` — the only legal path to `done`
- Failed quiz: `QuizNotifier` calls `TaskRepository.resetTaskToInProgress(taskId)` — a named method, not a generic status setter
- Any code that sets `task_status = 'done'` outside of `markTaskComplete()` is an architecture violation

**Riverpod State Management:**
- All async notifiers extend `AsyncNotifier<StateClass>`; sync notifiers extend `Notifier<StateClass>`
- State updates: `state = AsyncValue.data(state.value!.copyWith(...))` — never mutation
- No `StateProvider`, `StateNotifierProvider`, or `ChangeNotifier` — banned patterns
- Side effects (haptics, navigation) triggered via `ref.listen` in widgets, never inside notifiers

**Sync Queue Entry Format:**
```
sync_queue table columns:
  id           TEXT PRIMARY KEY   (UUID)
  entity_type  TEXT NOT NULL      ('task_status' | 'quiz_attempt' | 'survey_response' | 'engagement_log')
  entity_id    TEXT NOT NULL      (UUID of affected entity)
  operation    TEXT NOT NULL      ('upsert' | 'soft_delete')
  payload      TEXT NOT NULL      (JSON string)
  created_at   TEXT NOT NULL      (ISO 8601 UTC)
  retry_count  INTEGER DEFAULT 0
```
- Drift write and sync queue enqueue always in the same Drift transaction
- `retry_count` ≥ 3: entry moved to `sync_error_log`; non-blocking snackbar shown to user

### Process Patterns

**Error Handling:**
```dart
sealed class Failure {
  const Failure(this.message);
  final String message;
}
class NetworkFailure extends Failure { ... }
class DatabaseFailure extends Failure { ... }
class AuthFailure extends Failure { ... }
class ValidationFailure extends Failure { ... }
class SyncFailure extends Failure { ... }
```
- Repository methods always return `Future<Either<Failure, T>>` — no thrown exceptions from data layer
- User-facing messages mapped from `Failure` subtypes in `FailureMessageMapper` — never hardcoded in widgets
- Sync failures: non-blocking snackbar after 3 retries; never a blocking error for offline operation

**Loading States:**
- Use `AsyncValue` (Riverpod) for all async data — never a manual `isLoading` boolean
- Skeleton loaders for board and dashboard initial load — never a centered spinner
- Quiz submission: optimistic UI; answer marked instantly; no loading indicator between tap and result

**Animation & Haptic Rules:**
- Task completion: `AnimationController` + `Transform.scale` (1.0 → 1.05 → 1.0) + `Transform.translate` (card to Done), 350ms, `Curves.easeOut`
- Haptic: `HapticFeedback.mediumImpact()` once at card-settle moment — never `lightImpact` or `heavyImpact` for this event
- Failure screen entry: **no animation** — card returns quietly
- All other transitions: Material 3 defaults (200–250ms)
- **Banned everywhere:** `BackdropFilter`, `AnimatedOpacity` on completion animations

### Enforcement Guidelines

**All agents MUST:**
- Never access Supabase client directly above the `data/` layer
- Never set `task_status = 'done'` except via `TaskRepository.markTaskComplete()`
- Always write to Drift before enqueueing sync — same Drift transaction
- Always return `Either<Failure, T>` from repository methods — no thrown exceptions
- Always use `snake_case` for Drift/Supabase fields and `camelCase` for Dart models — map explicitly
- Always use `freezed` for domain models and state classes
- Never use `AnimatedOpacity` or `BackdropFilter` in completion animations
- Always fire `HapticFeedback.mediumImpact()` for task completion — not light, not heavy

**Anti-Patterns (never do these):**
- `supabase.from('tasks').update({'status': 'done'})` from a Notifier or Screen
- `isLoading = true` / `isLoading = false` boolean state management
- `map['field']` dynamic JSON access in domain or presentation layers
- `throw Exception(...)` from repository layer
- `AnimatedOpacity` for task completion animation
- Hardcoded status strings: `if (task.status == 'done')` — use `TaskStatus` enum always

## Project Structure & Boundaries

### Requirements → Structure Mapping

| FR Category | Primary Location |
|---|---|
| FR1–6 User Account Management | `lib/features/auth/` + `core/database/daos/student_dao.dart` |
| FR7–14 Syllabus & Task Board | `lib/features/board/` + `core/database/daos/task_dao.dart` |
| FR15–19 Content & Learning Flow | `lib/features/lesson/` + `core/content_cache/` + `core/database/daos/lesson_dao.dart` |
| FR20–26 Assessment & Progress | `lib/features/quiz/` + `core/database/daos/quiz_dao.dart` |
| FR27–32 Dashboard & Analytics | `lib/features/dashboard/` + `core/database/daos/dashboard_dao.dart` |
| FR33–38 Engagement & Survey | `lib/features/board/presentation/widgets/task_completion_animation.dart` + `lib/features/survey/` + `lib/features/dashboard/widgets/streak_indicator.dart` |
| FR39–43 Offline & Sync | `lib/core/sync/` |
| FR44–46 Notifications | `lib/features/notifications/` |

### Complete Project Directory Structure

**Project root:** `studyboard-mobile/`

**Initialization:**
```bash
dart pub global activate very_good_cli
very_good create flutter_app studyboard_mobile \
  --org com.lahiru.studyboard \
  --desc "A/L Chemistry study OS" \
  --output-directory studyboard-mobile
```

```
studyboard-mobile/
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   ├── google-services.json          # Firebase config (FCM + Crashlytics)
│   │   └── src/main/
│   │       ├── AndroidManifest.xml       # INTERNET, ACCESS_NETWORK_STATE, VIBRATE, POST_NOTIFICATIONS
│   │       └── kotlin/com/lahiru/studyboard/
│   │           └── MainActivity.kt
│   └── build.gradle
├── assets/
│   └── fonts/
│       ├── Nunito/                       # Nunito family (bundled)
│       └── JetBrainsMono/               # JetBrains Mono Regular + Medium only
├── lib/
│   ├── main.dart                         # Entry: ProviderScope, Firebase.initializeApp
│   ├── app.dart                          # MaterialApp.router + ThemeData
│   ├── router.dart                       # go_router: all route definitions, ShellRoute for bottom nav
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── auth_repository_impl.dart
│   │   │   │   └── models/
│   │   │   │       └── student_dto.dart              # JSON ↔ Supabase; snake_case → camelCase
│   │   │   ├── domain/
│   │   │   │   ├── auth_repository.dart              # Abstract interface
│   │   │   │   └── student.dart                      # freezed domain model
│   │   │   └── presentation/
│   │   │       ├── login_screen.dart
│   │   │       ├── register_screen.dart
│   │   │       ├── profile_screen.dart
│   │   │       ├── account_deletion_screen.dart      # FR5–6: deactivation + soft-delete
│   │   │       ├── auth_notifier.dart                # AsyncNotifier<AuthState>
│   │   │       ├── auth_state.dart                   # freezed
│   │   │       └── widgets/
│   │   │           ├── google_sign_in_button.dart
│   │   │           └── auth_form_field.dart
│   │   ├── board/
│   │   │   ├── data/
│   │   │   │   ├── board_repository_impl.dart
│   │   │   │   └── models/
│   │   │   │       └── task_dto.dart
│   │   │   ├── domain/
│   │   │   │   ├── board_repository.dart
│   │   │   │   ├── task.dart                         # freezed; taskId, lessonId, status, etc.
│   │   │   │   └── task_status.dart                  # enum TaskStatus + fromString + toDbString
│   │   │   └── presentation/
│   │   │       ├── board_screen.dart                 # Kanban: To-Do / In Progress / Done columns
│   │   │       ├── backlog_screen.dart               # Backlog view; FR7, FR9
│   │   │       ├── board_notifier.dart               # AsyncNotifier<BoardState>
│   │   │       ├── board_state.dart                  # freezed
│   │   │       └── widgets/
│   │   │           ├── task_card.dart
│   │   │           ├── kanban_column.dart
│   │   │           ├── task_completion_animation.dart # AnimationController + Transform (FR33–34)
│   │   │           └── backlog_list_item.dart
│   │   ├── lesson/
│   │   │   ├── data/
│   │   │   │   ├── lesson_repository_impl.dart
│   │   │   │   └── models/
│   │   │   │       └── lesson_dto.dart
│   │   │   ├── domain/
│   │   │   │   ├── lesson_repository.dart
│   │   │   │   └── lesson.dart                       # freezed; lessonId, title, imageUrls, etc.
│   │   │   └── presentation/
│   │   │       ├── curiosity_warmup_screen.dart      # FR15: past paper questions before lesson
│   │   │       ├── lesson_content_screen.dart        # FR16–17: full-screen lesson content
│   │   │       ├── lesson_notifier.dart
│   │   │       ├── lesson_state.dart
│   │   │       └── widgets/
│   │   │           ├── lesson_rich_media.dart        # Image rendering (chemical formulas, diagrams)
│   │   │           └── lesson_progress_bar.dart      # TikTok-style progress indicator
│   │   ├── quiz/
│   │   │   ├── data/
│   │   │   │   ├── quiz_repository_impl.dart
│   │   │   │   └── models/
│   │   │   │       ├── quiz_question_dto.dart
│   │   │   │       └── quiz_attempt_dto.dart
│   │   │   ├── domain/
│   │   │   │   ├── quiz_repository.dart
│   │   │   │   ├── quiz_question.dart                # freezed
│   │   │   │   └── quiz_attempt.dart                 # freezed; score, passed, pivotQuestionId
│   │   │   └── presentation/
│   │   │       ├── quiz_screen.dart                  # FR20: question + answer options
│   │   │       ├── quiz_pass_screen.dart             # FR23: pass result; haptic fire point
│   │   │       ├── quiz_fail_screen.dart             # FR22: pivot question + re-entry; no animation
│   │   │       ├── quiz_notifier.dart                # ONLY caller of markTaskComplete() / resetTaskToInProgress()
│   │   │       ├── quiz_state.dart
│   │   │       └── widgets/
│   │   │           ├── quiz_answer_option.dart
│   │   │           └── pivot_question_card.dart      # FR22: single concept to review
│   │   ├── dashboard/
│   │   │   ├── data/
│   │   │   │   └── dashboard_repository_impl.dart    # Pure Drift SQL; no Supabase dependency
│   │   │   ├── domain/
│   │   │   │   ├── dashboard_repository.dart
│   │   │   │   └── dashboard_stats.dart              # freezed; coverage, accuracy, weakTopics, streak
│   │   │   └── presentation/
│   │   │       ├── dashboard_screen.dart
│   │   │       ├── dashboard_notifier.dart
│   │   │       ├── dashboard_state.dart
│   │   │       └── widgets/
│   │   │           ├── coverage_ring.dart            # CustomPainter; FR27
│   │   │           ├── accuracy_bar.dart             # CustomPainter; FR29
│   │   │           ├── weak_topic_row.dart           # FR30: ranked list
│   │   │           └── streak_indicator.dart         # FR32, FR35–36
│   │   ├── survey/
│   │   │   ├── data/
│   │   │   │   └── survey_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── survey_repository.dart
│   │   │   │   └── survey_question.dart              # freezed
│   │   │   └── presentation/
│   │   │       ├── survey_screen.dart                # FR37: in-app fun survey
│   │   │       ├── survey_notifier.dart
│   │   │       └── survey_state.dart
│   │   └── notifications/
│   │       ├── data/
│   │       │   └── notification_service.dart         # FCM token registration + message handler
│   │       └── presentation/
│   │           └── notification_permission_screen.dart  # FR45: Android 13+ onboarding step
│   └── core/
│       ├── database/
│       │   ├── app_database.dart                     # @DriftDatabase; lists all tables + DAOs
│       │   ├── tables/
│       │   │   ├── students_table.dart
│       │   │   ├── subjects_table.dart
│       │   │   ├── topics_table.dart
│       │   │   ├── lessons_table.dart
│       │   │   ├── lesson_tasks_table.dart           # Per-student task state; task_status as TEXT
│       │   │   ├── quiz_questions_table.dart
│       │   │   ├── quiz_attempts_table.dart
│       │   │   ├── past_paper_questions_table.dart
│       │   │   ├── engagement_logs_table.dart
│       │   │   └── survey_responses_table.dart
│       │   └── daos/
│       │       ├── task_dao.dart                     # markTaskComplete, resetTaskToInProgress, pullToTodo
│       │       ├── quiz_dao.dart                     # saveAttempt, getAttemptsForLesson
│       │       ├── lesson_dao.dart                   # getLessonContent, getPastPaperQuestions
│       │       ├── dashboard_dao.dart                # getCoveragePercent, getWeakTopics, getStreak
│       │       ├── content_dao.dart                  # getAllImageUrls (for pre-fetch)
│       │       └── student_dao.dart                  # softDelete (PII anonymization), deactivate
│       ├── sync/
│       │   ├── sync_queue_table.dart                 # sync_queue + sync_error_log Drift tables
│       │   ├── sync_service.dart                     # Processes queue; called by connectivity stream
│       │   └── connectivity_service.dart             # connectivity_plus StreamProvider
│       ├── supabase/
│       │   ├── supabase_client_provider.dart         # Riverpod Provider<SupabaseClient>
│       │   └── repository_base.dart                  # trySupabase() helper; maps exceptions → Failure
│       ├── content_cache/
│       │   └── content_cache_service.dart            # flutter_cache_manager; pre-fetches all image URLs at first sync
│       ├── failures/
│       │   └── failure.dart                          # Sealed: NetworkFailure, DatabaseFailure, AuthFailure, ValidationFailure, SyncFailure
│       └── theme/
│           ├── app_theme.dart                        # ThemeData (Material 3, useMaterial3: true)
│           ├── app_colors.dart                       # Serene Scholar palette tokens
│           └── app_typography.dart                   # Nunito + JetBrains Mono TextStyles
├── test/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/auth_repository_impl_test.dart
│   │   │   └── presentation/auth_notifier_test.dart
│   │   ├── board/
│   │   │   ├── data/board_repository_impl_test.dart
│   │   │   ├── domain/task_status_test.dart          # State machine: all valid + invalid transitions
│   │   │   └── presentation/board_notifier_test.dart
│   │   ├── quiz/
│   │   │   ├── data/quiz_repository_impl_test.dart
│   │   │   └── presentation/quiz_notifier_test.dart  # markTaskComplete + resetTaskToInProgress
│   │   └── dashboard/
│   │       └── data/dashboard_repository_impl_test.dart
│   └── core/
│       ├── database/app_database_test.dart           # Migration: fresh install + v(n-1) upgrade
│       ├── sync/sync_service_test.dart               # Queue process, retry, error log
│       └── failures/failure_mapper_test.dart
├── integration_test/
│   └── app_test.dart                                 # Golden path: login → pull task → study → quiz pass → Done
├── supabase/
│   └── migrations/
│       └── 0001_initial_schema.sql                   # All tables + RLS policies
├── scripts/
│   └── seed_chemistry.sql                            # V1 Chemistry syllabus seed data
├── pubspec.yaml
├── analysis_options.yaml                             # Very Good Analysis rules
├── .gitignore
└── README.md
```

### Architectural Boundaries

**Layer Boundaries (hard rules):**

| Layer | May depend on | May NOT depend on |
|---|---|---|
| `presentation/` | `domain/` interfaces only | `data/` implementations, Drift, Supabase directly |
| `domain/` | `core/failures/` only | Flutter, Drift, Supabase imports |
| `data/` | `domain/`, `core/database/`, `core/supabase/` | `presentation/` |
| `core/sync/` | `core/database/`, `core/supabase/` | Any feature |
| `core/content_cache/` | `core/database/` (image URLs) | Any feature directly |

**Quiz Gate Boundary:**
- `quiz_notifier.dart` is the only file that calls `TaskRepository.markTaskComplete()` or `TaskRepository.resetTaskToInProgress()`
- No other file in the project may call `TaskDao.markTaskComplete()`

**Dashboard Boundary:**
- `DashboardRepositoryImpl` reads exclusively from Drift — zero Supabase calls
- Always fast, always available offline, always accurate

### Integration Points

**Data Flow — Write:**
```
Screen tap → Notifier → Repository → Drift write + sync_queue enqueue (same tx) → UI update
```

**Data Flow — Sync (background):**
```
ConnectivityService detects online → SyncService.processQueue()
  → Supabase upsert (idempotent)
  → success: delete queue row
  → failure (retry < 3): increment retry_count
  → failure (retry ≥ 3): move to sync_error_log, show SnackBar
```

**Data Flow — Read:**
```
Notifier.build() → RepositoryImpl → DriftDAO.query() → domain model stream → UI
```

**Data Flow — First Sync / Content Update:**
```
App launch (online, no local content or version mismatch)
  → ContentSyncService.sync()
    → Supabase SELECT all syllabus content → write to Drift
    → ContentCacheService.prefetchAll()
      → ContentDao.getAllImageUrls() → flutter_cache_manager.downloadFile() for each
```

**External Integration Points:**

| Service | Integration file | Direction |
|---|---|---|
| Supabase Auth | `auth_repository_impl.dart` | Auth only |
| Supabase Data | `sync_service.dart` | Write (sync queue drain) |
| Supabase Storage | `content_cache_service.dart` | Read (image pre-fetch) |
| Google Sign-In | `auth_repository_impl.dart` | OAuth token → Supabase |
| FCM | `notification_service.dart` | Token registration + message receipt |
| Firebase Crashlytics | `main.dart` (init) + `repository_base.dart` (non-fatal) | Write |

## Architecture Validation Results

### Coherence Validation ✅

All technology choices are compatible and mutually reinforcing:
- Flutter 3.41 + Riverpod 3.0 + Drift 2.x + go_router + Supabase + FCM + Crashlytics: no version conflicts
- Riverpod annotations + freezed + Drift share a single `build_runner` invocation (VGC pre-configured)
- `connectivity_plus` integrates as a Riverpod `StreamProvider` — zero friction
- Repository layer + `AsyncNotifier` + `Either<Failure, T>` is the Riverpod 3.0 canonical pattern
- Feature-first folders align with VGC scaffold; test structure mirrors `lib/` with no deviation

### Requirements Coverage Validation

All 46 FRs architecturally covered. All 7 performance NFRs addressed via local-first reads, pre-cached content, and optimistic UI. All security NFRs covered by Supabase RLS, `repository_base.dart` error mapping, and `student_dao.softDelete()` PII anonymization.

| Category | FRs | Coverage |
|---|---|---|
| User Account Management | FR1–6 | ✅ |
| Syllabus & Task Board | FR7–14 | ✅ |
| Content & Learning Flow | FR15–19 | ✅ |
| Assessment & Progress | FR20–26 | ✅ |
| Dashboard & Analytics | FR27–32 | ✅ |
| Engagement & Motivation | FR33–38 | ✅ |
| Offline & Sync | FR39–43 | ✅ |
| Notifications | FR44–46 | ✅ (gap resolved — see below) |

### Gap Analysis & Resolutions

**Gap 1 — FR44 Server-side push notification trigger (Critical, resolved)**

- `students` table: add `fcm_token TEXT` column; updated by `notification_service.dart` on token refresh
- `engagement_logs` table: `(student_id, date)` unique constraint; written on app foreground resume
- Supabase Edge Function: `notify-inactive-students`
  - Triggered by pg_cron daily at 03:30 UTC (09:00 Sri Lanka time, UTC+5:30)
  - Query: students where last `engagement_log.date < today - 3 days` AND `fcm_token IS NOT NULL`
  - Action: FCM HTTP v1 API batch send; encouraging copy per UX spec
- New file: `supabase/functions/notify-inactive-students/index.ts`

**Gap 2 — Quiz pass threshold storage (Important, resolved)**

- `subjects` table: add `quiz_pass_threshold REAL NOT NULL DEFAULT 0.8`
- `QuizRepositoryImpl.evaluateAttempt()` reads threshold from local Drift `subjects` table
- Threshold synced as part of subjects content sync at first launch

**Gap 3 — Content version tracking for FR19 (Important, resolved)**

- `subjects` table (Supabase + Drift): add `content_version INTEGER NOT NULL DEFAULT 1`
- `ContentSyncService.sync()` on launch (online):
  1. Fetch subjects from Supabase; compare `content_version` with local Drift value
  2. If mismatch: re-sync all content + re-run `ContentCacheService.prefetchAll()`
  3. Update local `content_version` to match Supabase

**Gap 4 — Engagement log write trigger (Important, resolved)**

- `app.dart` implements `WidgetsBindingObserver`
- On `AppLifecycleState.resumed`: write one `engagement_log` for `{student_id, date: today}` if none exists today
- Idempotent: `(student_id, date)` unique constraint prevents duplicates
- Entry enqueued to sync_queue in same Drift transaction

**Note — Supabase Postgres schema DDL** (deferred to implementation)

The `supabase/migrations/0001_initial_schema.sql` file is defined in the project structure but the full DDL (CREATE TABLE statements, RLS policies, indexes, pg_cron setup) is deferred to the implementation phase. The Drift table definitions in `core/database/tables/` serve as the schema source of truth for local state; the Supabase migration must mirror them exactly.

### Key Packages (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  # State management
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0
  # Local database
  drift: ^2.x
  drift_flutter: ^0.2.x
  # Routing
  go_router: ^latest
  # Backend
  supabase_flutter: ^latest
  # Auth
  google_sign_in: ^latest
  # Offline sync
  connectivity_plus: ^latest
  # Content caching
  flutter_cache_manager: ^latest
  # Functional error handling
  fpdart: ^latest
  # Push notifications + crash reporting
  firebase_messaging: ^latest
  firebase_crashlytics: ^latest
  # Immutable models + code generation
  freezed_annotation: ^latest
  google_fonts: ^latest

dev_dependencies:
  build_runner: ^latest
  riverpod_generator: ^latest
  freezed: ^latest
  drift_dev: ^latest
  mocktail: ^latest
  very_good_analysis: ^latest
```

### Updated Project Structure (gap additions)

```
studyboard-mobile/
  supabase/
    functions/
      notify-inactive-students/
        index.ts              # Edge Function: pg_cron daily trigger → FCM batch send
    migrations/
      0001_initial_schema.sql
```

### Architecture Completeness Checklist

**✅ Requirements Analysis**
- [x] All 46 FRs mapped to architectural components
- [x] All 7 performance NFRs addressed via local-first reads
- [x] All security NFRs covered (RLS, OAuth, PDPA soft-delete)
- [x] All reliability NFRs covered (Drift-first, idempotent sync, crash resilience)
- [x] Cross-cutting concerns fully mapped

**✅ Architectural Decisions**
- [x] Complete technology stack specified with versions
- [x] Scaffold, state management, and local DB decided with rationale
- [x] All integration patterns defined (Supabase, Google Sign-In, FCM, Crashlytics)
- [x] Offline sync architecture fully specified (custom Drift queue)

**✅ Implementation Patterns**
- [x] Naming conventions for DB, Dart code, screens, widgets
- [x] Layer boundaries hard-defined with enforcement rules
- [x] Task state machine fully specified with named methods only
- [x] Animation and haptic rules specified to parameter level
- [x] Error handling hierarchy with sealed Failure class
- [x] Anti-patterns explicitly documented

**✅ Project Structure**
- [x] Complete `studyboard-mobile/` directory tree with all files
- [x] All FR categories mapped to specific files
- [x] Integration points and data flows documented
- [x] 4 validation gaps identified and resolved

### Architecture Readiness Assessment

**Overall Status: READY FOR IMPLEMENTATION**

**Confidence Level: High**

**Key Strengths:**
- Offline-first architecture is watertight: Drift-first writes + crash-resilient sync queue cover all data loss scenarios
- Quiz gate is architecturally enforced via named methods only — impossible to bypass without explicit pattern violation
- Dashboard has zero Supabase dependency post-sync — always fast, always accurate, always available offline
- Performance constraints directly addressed: no network calls on cold start, pre-cached content, local SQL for all reads
- Multi-subject schema from day one: Chemistry is a data concern, not a structural one — scales without code changes

**Areas for Future Enhancement:**
- CI/CD (GitHub Actions template from VGC ready, activate post-V1)
- Postgres schema DDL (deferred to implementation phase)
- Admin content UI (Supabase Studio for V1; thin Flutter admin post-V1)
- `flutter_secure_storage` upgrade for auth tokens (post-V1 if compliance requirements increase)
- Multi-device sync conflict resolution beyond last-write-wins (post-V1)

### Implementation Handoff

**AI Agent Guidelines:**
- Follow all architectural decisions exactly as documented
- Use implementation patterns consistently — naming, layer boundaries, state machine methods
- Never call Supabase directly above the `data/` layer
- Never set `task_status = 'done'` except via `TaskRepository.markTaskComplete()`
- Always write to Drift before enqueueing sync — same Drift transaction
- Test on API 30 target hardware before reporting any UI feature complete

**First Implementation Story:**
```bash
dart pub global activate very_good_cli
very_good create flutter_app studyboard_mobile \
  --org com.lahiru.studyboard \
  --desc "A/L Chemistry study OS" \
  --output-directory studyboard-mobile
```
Then follow implementation sequence: Drift schema → RLS migrations → Auth → Content seeding → Board → Lesson → Quiz → Sync → Dashboard → Engagement → Notifications → Account management
