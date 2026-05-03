# Story 2.1: Chemistry Syllabus Content Seeding

Status: review

## Story

As a developer,
I want the full A/L Chemistry syllabus seeded into Supabase with all topics, lessons, and placeholder quiz and past paper questions,
So that the app has real content for the 10-student experiment from day one.

## Acceptance Criteria

1. **Given** the SQL seed scripts are executed against the Supabase project **When** the seeding completes **Then** the `subjects` table contains at least one Chemistry subject record with `quiz_pass_threshold = 0.8`

2. **Given** the Chemistry subject record exists **When** topics are seeded **Then** all A/L Chemistry topics are present in the `topics` table, each linked to the Chemistry `subject_id`

3. **Given** each topic exists **When** lessons are seeded **Then** each lesson record in the `lessons` table contains: `id`, `topic_id`, `title`, `content_text` (lesson notes), `content_track` (`'theory'`|`'past_papers'`|`'future_papers'`), and at least one associated `past_paper_questions` record

4. **Given** each lesson exists **When** quiz questions are seeded **Then** each lesson has at least one `quiz_questions` record with `question_text`, four answer options (`option_a` through `option_d`), and `correct_option` identified

5. **Given** a student opens the app for the first time with connectivity **When** the first Supabase content sync runs **Then** all subjects, topics, lessons, quiz questions, and past paper questions are written to the local Drift database and accessible offline

6. **Given** the content tables have RLS set to public SELECT (Story 1.4) **When** any authenticated student queries content **Then** all Chemistry syllabus content is returned — no student-scoped filtering on content tables

7. **Given** the content is synced for an authenticated student **When** the sync completes **Then** a `lesson_tasks` record exists in Drift for every seeded lesson for that student, with `task_status = 'backlog'` — these records are the student's personal task list that Story 2.2 reads

## Tasks / Subtasks

- [x] Task 1: Create SQL seed scripts for Supabase (AC: #1–#4)
  - [x] Create directory `supabase/seed/` in project root
  - [x] Create `supabase/seed/01_chemistry_subject.sql` — INSERT subject record
  - [x] Create `supabase/seed/02_chemistry_topics.sql` — INSERT all A/L Chemistry topics
  - [x] Create `supabase/seed/03_chemistry_lessons.sql` — INSERT lessons (theory + past_papers tracks) per topic with `content_text` placeholder notes
  - [x] Create `supabase/seed/04_chemistry_quiz_questions.sql` — INSERT at least 1 MCQ per lesson
  - [x] Create `supabase/seed/05_chemistry_past_paper_questions.sql` — INSERT at least 1 past paper question per lesson
  - [x] Run all scripts in order in Supabase Studio SQL editor; verify row counts match expectations

- [x] Task 2: Expand `ContentDao` to support content upsert (AC: #5)
  - [x] Open `lib/core/database/daos/content_dao.dart`
  - [x] Change `@DriftAccessor(tables: [...])` to include `SubjectsTable`, `QuizQuestionsTable`, `PastPaperQuestionsTable` (in addition to existing `LessonsTable`, `TopicsTable`)
  - [x] Add `upsertSubject(SubjectsTableCompanion c)` → `into(subjectsTable).insertOnConflictUpdate(c)`
  - [x] Add `upsertTopic(TopicsTableCompanion c)` → `into(topicsTable).insertOnConflictUpdate(c)`
  - [x] Add `upsertLesson(LessonsTableCompanion c)` → `into(lessonsTable).insertOnConflictUpdate(c)`
  - [x] Add `upsertQuizQuestion(QuizQuestionsTableCompanion c)` → `into(quizQuestionsTable).insertOnConflictUpdate(c)`
  - [x] Add `upsertPastPaperQuestion(PastPaperQuestionsTableCompanion c)` → `into(pastPaperQuestionsTable).insertOnConflictUpdate(c)`
  - [x] Add `getSubjects()` → `select(subjectsTable).get()`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/` — `@DriftAccessor` changed, regeneration required

- [x] Task 3: Add `createLessonTasksForStudent()` to `TaskDao` (AC: #7)
  - [x] Open `lib/core/database/daos/task_dao.dart`
  - [x] Add `createLessonTasksForStudent(String studentId, List<String> lessonIds)` — batch-inserts `lesson_tasks` records with `task_status = 'backlog'` using `InsertMode.insertOrIgnore` so existing task progress is never overwritten
  - [x] No `build_runner` run required — no change to `@DriftAccessor` annotation; adding a plain method does not require regeneration

- [x] Task 4: Create `ContentRepository` interface and implementation (AC: #5, #6)
  - [x] Create `lib/features/board/domain/content_repository.dart` — define `ContentRepository` abstract class with `syncContent(String studentId) → Future<Either<Failure, Unit>>`
  - [x] Create `lib/features/board/data/content_repository_impl.dart` — extends `RepositoryBase`, injects `SupabaseClient` (via `supabaseClientProvider`) and `ContentDao` + `TaskDao` (via `appDatabaseProvider`)
  - [x] Implement `syncContent()`: fetch all content tables from Supabase in order (subjects → topics → lessons → quiz_questions → past_paper_questions), upsert each batch to Drift via `ContentDao`, then call `TaskDao.createLessonTasksForStudent()` with all lesson IDs
  - [x] Create `lib/features/board/data/content_provider.dart` — Riverpod `@riverpod` provider for `ContentRepository`
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` — new `@riverpod` annotation requires code generation

- [x] Task 5: Trigger content sync after authentication (AC: #5)
  - [x] Create `lib/features/board/presentation/content_sync_notifier.dart` — `@riverpod` `AsyncNotifier<void>` that calls `contentRepositoryProvider.syncContent()` in its `build()` method
  - [x] `build()` reads `authProvider` state: if `authenticated`, reads enrolled `studentId` and triggers `syncContent(studentId)`; if not authenticated, returns immediately (no-op)
  - [x] Open `lib/router.dart` — in `ScaffoldWithNavBar.build()`, add `ref.listen(contentSyncProvider, (_, state) {})` so the notifier is activated when the shell route is rendered; the listen callback is intentionally empty (fire-and-forget)
  - [x] Run `dart run build_runner build --delete-conflicting-outputs`

- [x] Task 6: Tests (AC: #2–#5, #7)
  - [x] `test/core/database/content_dao_test.dart` — test `upsertSubject`, `upsertTopic`, `upsertLesson`, `upsertQuizQuestion`, `upsertPastPaperQuestion` against in-memory Drift db (pattern: `AppDatabase.forTesting(NativeDatabase.memory())`)
  - [x] `test/features/board/data/content_repository_impl_test.dart` — mock `SupabaseClient`, mock `ContentDao` + `TaskDao`; test `syncContent()` success path (fetches all tables, upserts to Drift, creates lesson_tasks); test `syncContent()` failure path (Supabase throws → `Left(NetworkFailure)`)
  - [x] Verify all tests pass: `flutter test`; `flutter analyze` → 0 issues

### Review Findings

- [x] [Review][Defer] AC3+AC4 vs content_track split design — AC3/AC4 require cross-track question coverage per lesson, but current seeding scopes each question type to its matching track. Deferred: seeding is for mapping purposes; hard coverage rules to be decided in a later story when the lesson content model is finalized.

- [x] [Review][Patch] `createLessonTasksForStudent` does not explicitly set `taskStatus = 'backlog'` — relies on implicit Drift column default; AC7 postcondition should be explicit in the code [task_dao.dart:~129]

- [x] [Review][Patch] `ContentSyncNotifier.build()` uses `ref.watch(authProvider)` — re-triggers a full Supabase sync on every auth state change (e.g. profile edits, token refresh) while the user is authenticated [content_sync_notifier.dart:11]

- [x] [Review][Patch] No Drift transaction wraps the multi-table upsert sequence in `syncContent` — a crash between upsert stages leaves the local DB in a partially-synced state with no rollback [content_repository_impl.dart:20]

- [x] [Review][Defer] No pagination on Supabase `.select()` calls — PostgREST default 1000-row limit silently truncates on large datasets [content_repository_impl.dart] — deferred, pre-existing pattern; not relevant at current experiment scale

- [x] [Review][Defer] Sync errors silently swallowed by `ref.listen(contentSyncProvider, (_, _) {})` — no user feedback, logging, or retry path if first sync fails [router.dart] — deferred, error-handling UX not in scope for this story

- [x] [Review][Defer] All content tables fetched globally regardless of student enrollment — scales poorly beyond single-subject experiment [content_repository_impl.dart] — deferred, by design for single-subject 10-student experiment

- [x] [Review][Defer] Sequential per-row `await` upserts inside `for` loops — O(n) Drift round-trips per table; a `transaction` per table would be faster [content_repository_impl.dart] — deferred, performance acceptable at current data volume

- [x] [Review][Defer] Unsafe `as String` hard-casts on nullable Supabase columns (e.g. `l['content_text'] as String`) — any null value is caught by `trySupabase` and misreported as `NetworkFailure` [content_repository_impl.dart] — deferred, acceptable for controlled seed dataset

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/core/database/daos/content_dao.dart` — exists with `getAllLessons(String subjectId)` and `@DriftAccessor(tables: [LessonsTable, TopicsTable])`; **ADD** new tables to `@DriftAccessor` and new methods; do NOT remove `getAllLessons()`
- `lib/core/database/daos/task_dao.dart` — has `markTaskComplete`, `resetTaskToInProgress`, `pullToTodo`, `startTask`, `getTaskByLesson`; **ADD** `createLessonTasksForStudent()` only
- `lib/core/database/daos/lesson_dao.dart` — has `getLessonById`, `getPastPaperQuestionsForLesson`, `setCuriosityCompleted`; do NOT modify for this story
- `lib/features/board/domain/task_status.dart` — `TaskStatus` enum with `backlog`, `todo`, `inProgress`, `done`; `TaskStatusX.fromString()` and `.toDbString()`; do NOT modify
- `lib/features/board/domain/task.dart` — `Task` freezed model; do NOT modify
- `lib/core/supabase/repository_base.dart` — `RepositoryBase` with `trySupabase<T>()` helper; `ContentRepositoryImpl` must extend this
- `lib/core/supabase/supabase_client_provider.dart` — provides `SupabaseClient`; use `supabaseClientProvider` not `Supabase.instance.client`
- `lib/features/auth/data/auth_provider.dart` — `authProvider` (Riverpod 4.x, no `Notifier` suffix); use `ref.read(authProvider)` to get `AuthState`; use `state.value?.mapOrNull(authenticated: (a) => a.student)` to extract student
- Drift schema version is **2** (Story 1.9 added `student_subjects` in v2 migration); do NOT bump version for this story — no schema changes needed, only DAO changes

### Drift `insertOnConflictUpdate` vs `insertOrIgnore`

For content tables (subjects, topics, lessons, quiz_questions, past_paper_questions): use `insertOnConflictUpdate` — content updates from Supabase should overwrite local stale data.

For `lesson_tasks` records: use `InsertMode.insertOrIgnore` — a student's existing task progress (e.g., `'todo'` or `'in_progress'`) must NEVER be overwritten by a re-sync. The UNIQUE constraint on `(student_id, lesson_id)` in `LessonTasksTable` ensures only one task record per student per lesson.

```dart
// ContentDao — content tables: overwrite on conflict (upsert)
Future<void> upsertLesson(LessonsTableCompanion c) =>
    into(lessonsTable).insertOnConflictUpdate(c);

// TaskDao — lesson_tasks: ignore on conflict (preserve student progress)
Future<void> createLessonTasksForStudent(
  String studentId,
  List<String> lessonIds,
) async {
  final now = DateTime.now().toUtc().toIso8601String();
  await batch((b) {
    for (final lessonId in lessonIds) {
      b.insert(
        lessonTasksTable,
        LessonTasksTableCompanion.insert(
          id: _uuid.v4(),
          studentId: studentId,
          lessonId: lessonId,
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });
}
```

### `ContentRepositoryImpl` — Implementation Skeleton

```dart
// lib/features/board/data/content_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/database/daos/content_dao.dart';
import 'package:studyboard_mobile/core/database/daos/task_dao.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/core/supabase/repository_base.dart';
import 'package:studyboard_mobile/features/board/domain/content_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContentRepositoryImpl extends RepositoryBase implements ContentRepository {
  ContentRepositoryImpl(this._client, this._contentDao, this._taskDao);

  final SupabaseClient _client;
  final ContentDao _contentDao;
  final TaskDao _taskDao;

  @override
  Future<Either<Failure, Unit>> syncContent(String studentId) async {
    return trySupabase(() async {
      // 1. Subjects
      final subjects = await _client.from('subjects').select();
      for (final s in subjects) {
        await _contentDao.upsertSubject(SubjectsTableCompanion.insert(
          id: s['id'] as String,
          name: s['name'] as String,
          quizPassThreshold: Value((s['quiz_pass_threshold'] as num?)?.toDouble() ?? 0.8),
          contentVersion: Value((s['content_version'] as int?) ?? 1),
        ));
      }

      // 2. Topics
      final topics = await _client.from('topics').select();
      for (final t in topics) {
        await _contentDao.upsertTopic(TopicsTableCompanion.insert(
          id: t['id'] as String,
          subjectId: t['subject_id'] as String,
          title: t['title'] as String,
          orderIndex: Value((t['order_index'] as int?) ?? 0),
        ));
      }

      // 3. Lessons
      final lessons = await _client.from('lessons').select();
      final lessonIds = <String>[];
      for (final l in lessons) {
        final id = l['id'] as String;
        lessonIds.add(id);
        await _contentDao.upsertLesson(LessonsTableCompanion.insert(
          id: id,
          topicId: l['topic_id'] as String,
          title: l['title'] as String,
          contentText: l['content_text'] as String,
          contentTrack: l['content_track'] as String,
          orderIndex: Value((l['order_index'] as int?) ?? 0),
        ));
      }

      // 4. Quiz questions
      final quizQs = await _client.from('quiz_questions').select();
      for (final q in quizQs) {
        await _contentDao.upsertQuizQuestion(QuizQuestionsTableCompanion.insert(
          id: q['id'] as String,
          lessonId: q['lesson_id'] as String,
          questionText: q['question_text'] as String,
          optionA: q['option_a'] as String,
          optionB: q['option_b'] as String,
          optionC: q['option_c'] as String,
          optionD: q['option_d'] as String,
          correctOption: q['correct_option'] as String,
          orderIndex: Value((q['order_index'] as int?) ?? 0),
        ));
      }

      // 5. Past paper questions
      final ppQs = await _client.from('past_paper_questions').select();
      for (final q in ppQs) {
        await _contentDao.upsertPastPaperQuestion(
          PastPaperQuestionsTableCompanion.insert(
            id: q['id'] as String,
            lessonId: q['lesson_id'] as String,
            topicId: q['topic_id'] as String,
            questionText: q['question_text'] as String,
            year: Value(q['year'] as int?),
            orderIndex: Value((q['order_index'] as int?) ?? 0),
          ),
        );
      }

      // 6. Create lesson_tasks records for student (INSERT OR IGNORE)
      if (lessonIds.isNotEmpty) {
        await _taskDao.createLessonTasksForStudent(studentId, lessonIds);
      }

      return unit;
    });
  }
}
```

**JSON field mapping:** Supabase returns `snake_case` JSON. Use exact `snake_case` keys: `'quiz_pass_threshold'`, `'content_text'`, `'content_track'`, `'order_index'`, `'lesson_id'`, `'topic_id'`, `'subject_id'`, `'question_text'`, `'option_a'`–`'option_d'`, `'correct_option'`.

### `ContentSyncNotifier` — Build Pattern

```dart
// lib/features/board/presentation/content_sync_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/board/data/content_provider.dart';

part 'content_sync_notifier.g.dart';

@riverpod
class ContentSyncNotifier extends _$ContentSyncNotifier {
  @override
  Future<void> build() async {
    final authValue = ref.watch(authProvider);
    final student = authValue.value?.mapOrNull(authenticated: (a) => a.student);
    if (student == null) return;

    await ref.read(contentRepositoryProvider).syncContent(student.id);
  }
}
```

**Key pattern:** `ref.watch(authProvider)` inside `build()` makes the notifier re-run automatically when auth state changes (e.g., login, logout). When `student == null` (not authenticated), the sync does nothing. This is idiomatic Riverpod for reactive initialization.

**Riverpod 4.x provider name:** The generated provider will be `contentSyncNotifierProvider` (PascalCase class with `Provider` suffix, `Notifier` preserved).

### SQL Seed Script Structure

```sql
-- supabase/seed/01_chemistry_subject.sql
INSERT INTO subjects (id, name, quiz_pass_threshold, content_version)
VALUES (
  'chem-subject-001',
  'A/L Chemistry',
  0.8,
  1
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  quiz_pass_threshold = EXCLUDED.quiz_pass_threshold,
  content_version = EXCLUDED.content_version;

-- supabase/seed/02_chemistry_topics.sql
INSERT INTO topics (id, subject_id, title, order_index)
VALUES
  ('chem-topic-01', 'chem-subject-001', 'Atomic Structure', 1),
  ('chem-topic-02', 'chem-subject-001', 'Chemical Bonding', 2),
  ('chem-topic-03', 'chem-subject-001', 'Stoichiometry', 3),
  ('chem-topic-04', 'chem-subject-001', 'States of Matter', 4),
  ('chem-topic-05', 'chem-subject-001', 'Thermodynamics and Energetics', 5),
  ('chem-topic-06', 'chem-subject-001', 'Chemical Equilibrium', 6),
  ('chem-topic-07', 'chem-subject-001', 'Chemical Kinetics', 7),
  ('chem-topic-08', 'chem-subject-001', 'Acids, Bases and Salts', 8),
  ('chem-topic-09', 'chem-subject-001', 'Electrochemistry', 9),
  ('chem-topic-10', 'chem-subject-001', 'Chemistry of s-Block Elements', 10),
  ('chem-topic-11', 'chem-subject-001', 'Chemistry of p-Block Elements', 11),
  ('chem-topic-12', 'chem-subject-001', 'Chemistry of d-Block Elements', 12),
  ('chem-topic-13', 'chem-subject-001', 'Organic Chemistry — Introduction', 13),
  ('chem-topic-14', 'chem-subject-001', 'Hydrocarbons', 14),
  ('chem-topic-15', 'chem-subject-001', 'Haloalkanes', 15),
  ('chem-topic-16', 'chem-subject-001', 'Alcohols and Phenols', 16),
  ('chem-topic-17', 'chem-subject-001', 'Carbonyl Compounds', 17),
  ('chem-topic-18', 'chem-subject-001', 'Carboxylic Acids and Derivatives', 18),
  ('chem-topic-19', 'chem-subject-001', 'Amines', 19),
  ('chem-topic-20', 'chem-subject-001', 'Polymers and Biomolecules', 20)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  order_index = EXCLUDED.order_index;
```

**Lesson template (repeat for each topic):**
```sql
-- supabase/seed/03_chemistry_lessons.sql
-- Each topic needs at least: 1 theory lesson + 1 past_papers lesson
INSERT INTO lessons (id, topic_id, title, content_text, content_track, order_index)
VALUES
  ('chem-lesson-atomic-01', 'chem-topic-01',
   'Atomic Structure — Theory',
   'The atom consists of a nucleus (protons and neutrons) surrounded by electrons...',
   'theory', 1),
  ('chem-lesson-atomic-02', 'chem-topic-01',
   'Atomic Structure — Past Papers',
   'Past paper questions on atomic structure from A/L examinations.',
   'past_papers', 2)
-- ... repeat for each topic ...
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content_text = EXCLUDED.content_text,
  content_track = EXCLUDED.content_track,
  order_index = EXCLUDED.order_index;
```

**Quiz question template:**
```sql
-- supabase/seed/04_chemistry_quiz_questions.sql
INSERT INTO quiz_questions
  (id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_option, order_index)
VALUES
  ('chem-q-atomic-01', 'chem-lesson-atomic-01',
   'The number of protons in an atom is equal to its:',
   'Mass number', 'Atomic number', 'Neutron number', 'Electron shells',
   'b', 1)
-- ... repeat for each lesson ...
ON CONFLICT (id) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  option_a = EXCLUDED.option_a, option_b = EXCLUDED.option_b,
  option_c = EXCLUDED.option_c, option_d = EXCLUDED.option_d,
  correct_option = EXCLUDED.correct_option,
  order_index = EXCLUDED.order_index;
```

**Past paper question template:**
```sql
-- supabase/seed/05_chemistry_past_paper_questions.sql
INSERT INTO past_paper_questions
  (id, lesson_id, topic_id, question_text, year, order_index)
VALUES
  ('chem-pp-atomic-01', 'chem-lesson-atomic-01', 'chem-topic-01',
   'State and explain the trend in atomic radius across Period 3 of the Periodic Table.',
   2019, 1)
-- ... repeat for each lesson ...
ON CONFLICT (id) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  year = EXCLUDED.year,
  order_index = EXCLUDED.order_index;
```

### `@DriftAccessor` expansion — build_runner required

When modifying `@DriftAccessor(tables: [...])` in `content_dao.dart`, the `content_dao.g.dart` file must be regenerated. Run from `studyboard_mobile/`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This is required because the `@DriftAccessor` annotation controls what table getters (`subjectsTable`, `quizQuestionsTable`, etc.) are available inside the DAO. Without regeneration, the DAO cannot access those tables.

### Supabase Column Name Reference

Drift Dart field → Supabase column (via `tableName` override):
- `SubjectsTable.quizPassThreshold` → `quiz_pass_threshold`
- `SubjectsTable.contentVersion` → `content_version`  
- `TopicsTable.subjectId` → `subject_id`
- `TopicsTable.orderIndex` → `order_index`
- `LessonsTable.topicId` → `topic_id`
- `LessonsTable.contentText` → `content_text`
- `LessonsTable.contentTrack` → `content_track`
- `LessonsTable.orderIndex` → `order_index`
- `QuizQuestionsTable.lessonId` → `lesson_id`
- `QuizQuestionsTable.questionText` → `question_text`
- `QuizQuestionsTable.optionA` → `option_a` (etc.)
- `QuizQuestionsTable.correctOption` → `correct_option`
- `PastPaperQuestionsTable.lessonId` → `lesson_id`
- `PastPaperQuestionsTable.topicId` → `topic_id`
- `PastPaperQuestionsTable.questionText` → `question_text`

Supabase auto-converts camelCase Dart column names to snake_case — but always supply explicit JSON keys when reading response maps to avoid mismatches.

### Error Handling

`ContentRepositoryImpl.syncContent()` uses `trySupabase()` from `RepositoryBase`. Any `PostgrestException` (e.g., Supabase auth error), `AuthException`, or network error returns `Left(NetworkFailure(...))`. The `ContentSyncNotifier` treats an error as a warning: the UI should NOT crash if sync fails. Story 2.2 handles the empty-content state ("Content not yet downloaded").

Do NOT show a blocking error to the user on sync failure. Fire-and-forget sync — the board shows empty states if content is missing.

### Testing Patterns

```dart
// test/core/database/content_dao_test.dart
void main() {
  late AppDatabase db;
  late ContentDao contentDao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    contentDao = db.contentDao;
  });
  tearDown(() async => db.close());

  test('upsertSubject writes to subjects table', () async {
    await contentDao.upsertSubject(SubjectsTableCompanion.insert(
      id: 'sub-1',
      name: 'A/L Chemistry',
    ));
    final subjects = await contentDao.getSubjects();
    expect(subjects.length, 1);
    expect(subjects.first.name, 'A/L Chemistry');
  });

  test('upsertLesson on conflict updates content_text', () async {
    final companion = LessonsTableCompanion.insert(
      id: 'l-1', topicId: 't-1', title: 'Atomic Structure',
      contentText: 'original text', contentTrack: 'theory',
    );
    await contentDao.upsertLesson(companion);
    await contentDao.upsertLesson(
      companion.copyWith(contentText: const Value('updated text')),
    );
    final lesson = await db.contentDao.getAllLessons('sub-1'); // use existing method as base
    // verify upsert worked — query directly if needed
  });
}

// test/features/board/data/content_repository_impl_test.dart
// Use mocktail; mock SupabaseClient, mock ContentDao and TaskDao
// Test: syncContent() calls all 5 Supabase fetches and all DAO upserts
// Test: syncContent() Supabase throws → Left(NetworkFailure)
// Test: syncContent() calls createLessonTasksForStudent with correct lessonIds
```

### Architecture Compliance Checklist

- [ ] `ContentRepositoryImpl` extends `RepositoryBase` — uses `trySupabase()` wrapper
- [ ] `ContentRepositoryImpl` injects `SupabaseClient` via `supabaseClientProvider`, not `Supabase.instance.client`
- [ ] `ContentRepositoryImpl` accesses Supabase ONLY inside the `data/` layer — no Supabase calls in Notifier or Screen
- [ ] `TaskDao.createLessonTasksForStudent()` uses `InsertMode.insertOrIgnore` — student task progress is NEVER overwritten by re-sync
- [ ] `ContentDao` upsert methods use `insertOnConflictUpdate` — content updates from Supabase overwrite stale local data
- [ ] `build_runner` is run after any `@DriftAccessor` or `@riverpod` annotation change
- [ ] `ContentSyncNotifier.build()` reads `authProvider` state before calling sync — never syncs for unauthenticated users
- [ ] `flutter analyze` → 0 issues; `flutter test` → all pass

### Anti-Patterns to Avoid

- ❌ Calling `Supabase.instance.client` directly from `ContentSyncNotifier` or screen — Supabase client belongs in `data/` layer only
- ❌ Using `insertOnConflictUpdate` for `lesson_tasks` — this would overwrite a student's task progress ('todo', 'in_progress') on re-sync
- ❌ Using `InsertMode.insertOrIgnore` for content tables — new content from Supabase would not update stale Drift records
- ❌ Running `build_runner` before AND after modifying the `@DriftAccessor` tables list — run ONCE after all changes are made
- ❌ Fetching content inside `ContentSyncNotifier.build()` directly from Supabase — all Supabase access must be through the repository
- ❌ Not handling the case where the student has no enrolled subjects — `syncContent()` syncs ALL content (subjects are public) regardless of enrollment; `lesson_tasks` are created for all lessons, enrollment is filtered in the UI (Story 2.2)
- ❌ Adding a migration or bumping `schemaVersion` — no schema changes are needed for this story; only DAO code changes

### Project Structure Notes

**Files to CREATE:**
```
supabase/seed/01_chemistry_subject.sql
supabase/seed/02_chemistry_topics.sql
supabase/seed/03_chemistry_lessons.sql
supabase/seed/04_chemistry_quiz_questions.sql
supabase/seed/05_chemistry_past_paper_questions.sql
lib/features/board/domain/content_repository.dart
lib/features/board/data/content_repository_impl.dart
lib/features/board/data/content_provider.dart
lib/features/board/presentation/content_sync_notifier.dart
lib/features/board/presentation/content_sync_notifier.g.dart  (generated)
test/core/database/content_dao_test.dart
test/features/board/data/content_repository_impl_test.dart
```

**Files to MODIFY:**
```
lib/core/database/daos/content_dao.dart        # Add tables to @DriftAccessor + upsert methods
lib/core/database/daos/content_dao.g.dart      # Regenerated by build_runner
lib/core/database/daos/task_dao.dart           # Add createLessonTasksForStudent()
lib/router.dart                                # Add ref.listen(contentSyncNotifierProvider, ...)
                                               # in ScaffoldWithNavBar.build()
```

**Files NOT to modify:**
- `lib/core/database/app_database.dart` — schema version stays at 2; no new tables
- `lib/core/database/daos/lesson_dao.dart` — no changes needed
- `lib/core/database/daos/task_dao.dart` — ONLY add `createLessonTasksForStudent()`; do not modify existing methods
- `lib/features/board/domain/task.dart` or `task_status.dart` — no changes
- Any `*.freezed.dart` or `*.g.dart` file (except those regenerated by build_runner)

### Deferred Work Note

After Story 2.1 is implemented:
- Content sync is fire-and-forget (no retry on failure) — Epic 5 (Story 5.1) activates the full sync queue consumer for student data; content re-sync logic (comparing `content_version` between Supabase and Drift) can be added as part of Epic 3 or 5
- Incremental content updates (only sync changed content) deferred to Epic 5
- `ContentSyncNotifier` re-runs every time auth state changes (including token refresh) — the `insertOnConflictUpdate` semantics make re-runs safe but potentially slow; optimization deferred to Epic 5

### Epic 1 Accumulated Learnings (Carry Forward)

- **`authProvider`** (not `authNotifierProvider`) — Riverpod 4.x strips `Notifier` suffix from generated provider name
- **`state.value?.mapOrNull(authenticated: (a) => a.student)`** — correct pattern to extract student; returns `null` for unauthenticated/loading/error states
- **`very_good_analysis`** — `package:` imports everywhere; no relative imports in `lib/`
- **`sort_constructors_first` lint** — constructors must appear before field declarations
- **`dart run build_runner build --delete-conflicting-outputs`** — run from `studyboard_mobile/`; not from project root; not `flutter pub run`
- **Dart closure type promotion** — if using `final studentId = student.id;` before an async call, type is promoted to non-nullable in closure
- **`transaction()`** — not needed for `ContentDao` upserts (they are independent rows); IS needed for `TaskDao.createLessonTasksForStudent()` batch if atomicity is required
- **`ref.watch()` in notifier `build()`** — watching `authProvider` in `ContentSyncNotifier.build()` makes the notifier reactive to auth state changes; this is the correct Riverpod pattern for reactive initialization
- **Concurrency guard** — `ContentSyncNotifier` does not need a manual guard since Riverpod serializes `build()` calls; but the `insertOrIgnore` on `lesson_tasks` provides idempotency for re-runs

### References

- [Source: epics.md#Story 2.1] — Acceptance criteria, SQL seed structure, content table schemas
- [Source: epics.md#Epic 2] — "Chemistry syllabus SQL seed scripts to Supabase"
- [Source: architecture.md#Content Seeding] — "Supabase Dashboard + SQL scripts for Chemistry syllabus V1"
- [Source: architecture.md#Data Architecture] — "Local Drift state is always source of truth; Supabase is the sync target" — for content sync this inverts: Supabase content is pulled INTO Drift
- [Source: architecture.md#Feature Folder Structure] — board feature at `lib/features/board/`; `ContentRepository` belongs here
- [Source: architecture.md#Naming Patterns] — `ContentRepository` interface, `ContentRepositoryImpl` implementation, `contentRepositoryProvider`
- [Source: architecture.md#RLS Policy Design] — "Syllabus/content tables: public SELECT, no write" — confirms no RLS barrier for content queries
- [Source: 1-10-student-profile-edit.md#Dev Notes] — `insertOnConflictUpdate` usage pattern in `StudentDao`; `authProvider` state extraction pattern
- [Source: epic-1-retro-2026-04-26.md#Technical Debt] — T1: Remove AppBar from `ScaffoldWithNavBar` (defer to Story 2.2); do NOT do this in Story 2.1

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

- Seeded full A/L Chemistry syllabus (20 topics, 40 lessons, 40 quiz questions, 40 past paper questions) into Supabase via 5 SQL seed scripts with `ON CONFLICT DO UPDATE` idempotency.
- Expanded `ContentDao` `@DriftAccessor` to include all 5 content tables; added `upsertSubject/Topic/Lesson/QuizQuestion/PastPaperQuestion` (insertOnConflictUpdate) and `getSubjects()`.
- Added `TaskDao.createLessonTasksForStudent()` using batch `InsertMode.insertOrIgnore` to preserve existing student task progress on re-sync.
- Created `ContentRepository` interface (`abstract interface class`, one_member suppressed per project pattern) and `ContentRepositoryImpl` extending `RepositoryBase` with `trySupabase()` error wrapping.
- Created `contentRepositoryProvider` via Riverpod `@riverpod` annotation; created `ContentSyncNotifier` (`@riverpod AsyncNotifier<void>`) that watches `authProvider` and fire-and-forgets `syncContent` on login.
- Wired `contentSyncProvider` into `ScaffoldWithNavBar.build()` via `ref.listen`.
- Fixed analyze issues: added missing `auth_state.dart` import to notifier, corrected provider reference (`contentSyncProvider` not `contentSyncNotifierProvider`), added `document_ignores`-compliant comment to `one_member_abstracts` suppression.
- `flutter test`: 113/113 pass. `flutter analyze`: 0 issues.

### File List

**Created:**
- supabase/seed/01_chemistry_subject.sql
- supabase/seed/02_chemistry_topics.sql
- supabase/seed/03_chemistry_lessons.sql
- supabase/seed/04_chemistry_quiz_questions.sql
- supabase/seed/05_chemistry_past_paper_questions.sql
- supabase/seed/seed_all.sql
- studyboard_mobile/lib/features/board/domain/content_repository.dart
- studyboard_mobile/lib/features/board/data/content_repository_impl.dart
- studyboard_mobile/lib/features/board/data/content_provider.dart
- studyboard_mobile/lib/features/board/data/content_provider.g.dart
- studyboard_mobile/lib/features/board/presentation/content_sync_notifier.dart
- studyboard_mobile/lib/features/board/presentation/content_sync_notifier.g.dart
- studyboard_mobile/test/core/database/content_dao_test.dart
- studyboard_mobile/test/features/board/data/content_repository_impl_test.dart

**Modified:**
- studyboard_mobile/lib/core/database/daos/content_dao.dart
- studyboard_mobile/lib/core/database/daos/content_dao.g.dart
- studyboard_mobile/lib/core/database/daos/task_dao.dart
- studyboard_mobile/lib/router.dart

### Change Log

- 2026-04-27: Implemented story 2-1 — Chemistry syllabus SQL seeding, ContentDao upsert methods, TaskDao.createLessonTasksForStudent, ContentRepository interface + impl, contentRepositoryProvider, ContentSyncNotifier, router wiring; 113 tests pass, 0 analyze issues.
