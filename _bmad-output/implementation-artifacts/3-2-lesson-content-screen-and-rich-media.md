# Story 3.2: Lesson Content Screen & Rich Media

Status: done

## Story

As a student,
I want to read lesson notes and view chemical formulas and molecular diagrams inline,
So that I can study the full lesson content without any missing visuals.

## Acceptance Criteria

1. **Given** the student taps "Continue to lesson" on the CuriosityScreen **When** the `LessonContentScreen` opens **Then** the lesson title (Headline Large style), scrollable notes body (`MarkdownBody`, Body Large, 1.6× line-height), are displayed immediately from local Drift/cache — no loading spinner for returning users (NFR5: ≤ 2 seconds from cache)

2. **Given** lesson content contains chemical formula or molecular diagram images (markdown `![alt](url)` inline references) **When** the content renders **Then** images are displayed inline within the text flow using `CachedNetworkImage` — no tap-to-expand required; images render clearly at standard Android screen densities

3. **Given** the student is offline **When** the lesson content screen opens **Then** all text and pre-cached images render correctly from local storage with no network requests and no degraded mode (FR18) — `CachedNetworkImage` reads from flutter_cache_manager disk cache

4. **Given** a linear progress bar at the top of the lesson **When** the student scrolls through the content **Then** the `LinearProgressIndicator` advances proportionally to scroll position (driven by `ScrollController` + `ValueNotifier<double>`, rebuilding only the progress indicator widget — not the whole screen); if the content fits on-screen without scrolling, the progress bar shows as full (1.0)

5. **Given** a sticky "Take quiz" `FilledButton` at the bottom of the screen **When** the student views any part of the lesson **Then** the button is always visible below the scroll area — no scrolling required to access it; tapping navigates to `/quiz/:taskId` (stub route — Story 4.1 will implement)

6. **Given** the student presses the Android back gesture on the `LessonContentScreen` **When** back is pressed **Then** standard Android back navigation applies — the student returns to the Board (CuriosityScreen used `pushReplacement`, so it is not on the stack); no `AlertDialog` is shown (free back navigation, unlike CuriosityScreen)

## Tasks / Subtasks

- [x] Task 1: Add `flutter_markdown` and `cached_network_image` to `pubspec.yaml` (AC: #1, #2, #3)
  - [x] Open `studyboard_mobile/pubspec.yaml`
  - [x] Add `flutter_markdown: ^0.7.6` under `dependencies:` (check pub.dev for latest stable)
  - [x] Add `cached_network_image: ^3.4.1` under `dependencies:` (check pub.dev for latest stable)
  - [x] Run `flutter pub get` from `studyboard_mobile/`

- [x] Task 2: Extend `LessonDetails` and `LessonState` with `contentText` (AC: #1, #2)
  - [x] Open `lib/features/lesson/domain/lesson_repository.dart`
  - [x] Add `required String contentText` field to `LessonDetails` factory constructor (after `questionText`, before `curiosityCompleted`)
  - [x] Open `lib/features/lesson/presentation/lesson_state.dart`
  - [x] Add `required String contentText` field to `LessonState` factory constructor (after `questionText`, before `curiosityCompleted`)
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/`

- [x] Task 3: Update `LessonRepositoryImpl` and `LessonNotifier` to populate `contentText` (AC: #1, #2)
  - [x] Open `lib/features/lesson/data/lesson_repository_impl.dart`
  - [x] Add `contentText: lessonWithTopic.lesson.contentText` to the `LessonDetails(...)` return in `getLessonDetails()`
  - [x] Open `lib/features/lesson/presentation/lesson_notifier.dart`
  - [x] Add `contentText: details.contentText` to the `LessonState(...)` return in `build()`

- [x] Task 4: Create `LessonContentScreen` (AC: #1, #2, #3, #4, #5, #6)
  - [x] Create `lib/features/lesson/presentation/lesson_content_screen.dart` (full implementation — see Dev Notes reference)
  - [x] `ConsumerStatefulWidget` with `ScrollController` + `ValueNotifier<double>` for progress tracking
  - [x] `ValueListenableBuilder` rebuilds only `LinearProgressIndicator` on scroll (not full screen)
  - [x] `MarkdownBody` renders `contentText` with Body Large style at 1.6× line-height
  - [x] Custom `imageBuilder` uses `CachedNetworkImage` with `CircularProgressIndicator` placeholder and `Icon(Icons.broken_image_outlined)` error widget
  - [x] Sticky `FilledButton` ("Take quiz") always visible at bottom, navigates to `context.push('/quiz/$taskId')`
  - [x] No `PopScope` — standard back navigation (no dialog)
  - [x] Skeleton loading state (grey shimmer containers — not `CircularProgressIndicator`)
  - [x] Error state with retry button (calls `ref.invalidate(lessonNotifierProvider(taskId))`)

- [x] Task 5: Update `router.dart` (AC: #5, #6)
  - [x] Open `lib/router.dart`
  - [x] Add import for `lesson_content_screen.dart`
  - [x] Replace the `/lesson/:taskId` stub with `MaterialPage(child: LessonContentScreen(taskId: taskId))`
  - [x] Add `/quiz/:taskId` stub `GoRoute` as a top-level route (BEFORE `ShellRoute`): `MaterialPage(child: Scaffold(body: Center(child: Text('Quiz coming soon'))))` — Story 4.1 will replace

- [x] Task 6: Write tests (AC: #1, #4, #5, #6)
  - [x] Create `test/features/lesson/presentation/lesson_content_screen_test.dart` (5 tests — all pass)
  - [x] Test: renders lesson title from `LessonState`
  - [x] Test: "Take quiz" `FilledButton` is always visible (not conditional on scroll)
  - [x] Test: back navigation has no `AlertDialog` (PopScope not present)
  - [x] Test: error state shows retry button and calls `ref.invalidate`
  - [x] Test: loading state shows skeleton (no `CircularProgressIndicator` at root)

### Review Findings

- [x] [Review][Decision] Lesson title style is `headlineMedium` — AC #1 specifies "Headline Large style"; accepted as intentional by owner; `headlineMedium` retained.
- [x] [Review][Decision] Hardcoded progress bar color `0xFF007BFF` — moved to `AppColors.calmBlue` reference (already defined in `app_colors.dart`); `dart:async` import added for `unawaited`.
- [x] [Review][Patch] `context.push` closure has no `mounted` guard — fixed: added `if (context.mounted)` + `unawaited()` wrapper [`lesson_content_screen.dart:77-80`]
- [x] [Review][Patch] Stale `_progressNotifier` after retry — fixed: added `ref.listen` to reset progress to 0 when provider loses its value [`lesson_content_screen.dart:51-53`]
- [x] [Review][Patch] `imageBuilder` deprecated + no URI scheme validation — fixed: switched to `sizedImageBuilder` API (`MarkdownSizedImageBuilder`), added HTTP/HTTPS scheme guard [`lesson_content_screen.dart:145-176`]
- [x] [Review][Patch] Test 4 only asserted button existence — fixed: test now taps Retry, pumps, and asserts `callCount > 1` to confirm `ref.invalidate` triggered a reload [`lesson_content_screen_test.dart:69`]
- [x] [Review][Defer] `clock: ^1.1.2` in pubspec.yaml — appears in the uncommitted diff from a prior story; not introduced by story 3-2; verify origin and move to `dev_dependencies` if test-only [`pubspec.yaml`] — deferred, pre-existing
- [x] [Review][Defer] Rapid double-tap of "Take quiz" double-pushes `/quiz/:taskId` — intentional per spec (no `PopScope`); debouncing is out of scope [`lesson_content_screen.dart:71`] — deferred, pre-existing
- [x] [Review][Defer] No `onTapLink` handler on `MarkdownBody` — hyperlinks open system browser via `url_launcher`; spec does not address links in lesson content [`lesson_content_screen.dart:119`] — deferred, pre-existing
- [x] [Review][Defer] Rapid double-tap of Retry spawns orphaned futures on autoDispose provider — Riverpod silently drops writes from disposed notifiers; no crash [`lesson_content_screen.dart:60`] — deferred, pre-existing
- [x] [Review][Defer] `completeCuriosity` `rethrow` is invisible to UI at call sites — pre-existing from story 3-1 [`lesson_notifier.dart:24`] — deferred, pre-existing
- [x] [Review][Defer] Manual `LessonDetails` → `LessonState` field mapping has no compile-time completeness guarantee — a new `LessonDetails` field silently defaults in `LessonState` [`lesson_notifier.dart:13`] — deferred, pre-existing
- [x] [Review][Defer] `MarkdownBody` re-parses full markdown AST on every parent rebuild — acceptable for V1; wrap `_LessonContent` in `RepaintBoundary` if scroll jank is reported [`lesson_content_screen.dart:119`] — deferred, pre-existing
- [x] [Review][Defer] Test helper uses `MaterialApp` not `MaterialApp.router` — any future test that taps "Take quiz" throws `GoRouter not found` [`lesson_content_screen_test.dart:23`] — deferred, pre-existing

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `lib/features/lesson/domain/lesson_repository.dart` — `LessonDetails` freezed model + `LessonRepository` interface — **EXTEND, do not recreate** (add `contentText` field)
- `lib/features/lesson/presentation/lesson_state.dart` — `LessonState` freezed model — **EXTEND, do not recreate** (add `contentText` field)
- `lib/features/lesson/presentation/lesson_notifier.dart` — `LessonNotifier` `@riverpod class` — **MODIFY only `build()` return** (add `contentText:` mapping)
- `lib/features/lesson/data/lesson_repository_impl.dart` — `LessonRepositoryImpl` — **MODIFY only `getLessonDetails()` return** (add `contentText:` mapping from `lessonWithTopic.lesson.contentText`)
- `lib/features/lesson/data/lesson_provider.dart` — Riverpod provider — **DO NOT modify**
- `lib/features/lesson/presentation/curiosity_screen.dart` — fully implemented CuriosityScreen — **DO NOT modify**
- `lib/core/database/daos/lesson_dao.dart` — all DAOs needed are present; `getLessonWithTopicTitle(lessonId)` already returns `LessonsTableData` which has `.contentText` — **NO new DAO methods needed**
- `lib/core/database/tables/lessons_table.dart` — has `contentText TextColumn` — **NO schema changes needed**
- `lib/router.dart` — `/lesson/:taskId` stub exists at line 87–94; `/curiosity/:taskId` real route at line 80–86 — **replace only the stub**
- `flutter_cache_manager: ^3.4.1` — already in pubspec; `cached_network_image` depends on it

### Schema Version — DO NOT Change

`AppDatabase.schemaVersion` stays at **2**. The `lessonsTable` already has `contentText` (TextColumn). No migrations needed in this story.

### contentText Format

`contentText` is treated as **markdown**. Chemical formulas and diagrams are referenced as inline images: `![description](https://cdn.example.com/chem-diagram.png)`. Plain text paragraphs use standard paragraph breaks. The `flutter_markdown` package renders this natively.

### `LessonDetails` Extension Reference

```dart
// lib/features/lesson/domain/lesson_repository.dart
@freezed
abstract class LessonDetails with _$LessonDetails {
  const factory LessonDetails({
    required String taskId,
    required String lessonId,
    required String lessonTitle,
    required String topicTitle,
    required String questionText,
    required String contentText,    // ← ADD THIS
    required bool curiosityCompleted,
  }) = _LessonDetails;
}
```

### `LessonState` Extension Reference

```dart
// lib/features/lesson/presentation/lesson_state.dart
@freezed
abstract class LessonState with _$LessonState {
  const factory LessonState({
    required String taskId,
    required String lessonId,
    required String lessonTitle,
    required String topicTitle,
    required String questionText,
    required String contentText,    // ← ADD THIS
    @Default(false) bool curiosityCompleted,
  }) = _LessonState;
}
```

### `LessonRepositoryImpl` — Updated `getLessonDetails` Return

```dart
return LessonDetails(
  taskId: taskId,
  lessonId: task.lessonId,
  lessonTitle: lessonWithTopic.lesson.title,
  topicTitle: lessonWithTopic.topic.title,
  questionText: questions.isNotEmpty ? questions.first.questionText : '',
  contentText: lessonWithTopic.lesson.contentText,    // ← ADD THIS
  curiosityCompleted: task.curiosityCompleted,
);
```

### `LessonNotifier` — Updated `build()` Return

```dart
return LessonState(
  taskId: details.taskId,
  lessonId: details.lessonId,
  lessonTitle: details.lessonTitle,
  topicTitle: details.topicTitle,
  questionText: details.questionText,
  contentText: details.contentText,    // ← ADD THIS
  curiosityCompleted: details.curiosityCompleted,
);
```

### `LessonContentScreen` — Full Implementation Reference

```dart
// lib/features/lesson/presentation/lesson_content_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_notifier.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_state.dart';

class LessonContentScreen extends ConsumerStatefulWidget {
  const LessonContentScreen({required this.taskId, super.key});
  final String taskId;

  @override
  ConsumerState<LessonContentScreen> createState() =>
      _LessonContentScreenState();
}

class _LessonContentScreenState extends ConsumerState<LessonContentScreen> {
  late final ScrollController _scrollController;
  final _progressNotifier = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (!pos.hasContentDimensions) return;
    final max = pos.maxScrollExtent;
    _progressNotifier.value =
        max <= 0 ? 1.0 : (pos.pixels / max).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    // ref is a field of ConsumerState — no WidgetRef parameter in build()
    final lessonAsync = ref.watch(lessonNotifierProvider(widget.taskId));
    return Scaffold(
      body: lessonAsync.when(
        loading: () => const _LessonSkeletonScreen(),
        error: (e, _) => SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Could not load lesson. Please try again.'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(lessonNotifierProvider(widget.taskId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (lesson) => _LessonContent(
          lesson: lesson,
          scrollController: _scrollController,
          progressNotifier: _progressNotifier,
          onTakeQuiz: () => context.push('/quiz/${widget.taskId}'),
        ),
      ),
    );
  }
}

class _LessonContent extends StatelessWidget {
  const _LessonContent({
    required this.lesson,
    required this.scrollController,
    required this.progressNotifier,
    required this.onTakeQuiz,
  });

  final LessonState lesson;
  final ScrollController scrollController;
  final ValueNotifier<double> progressNotifier;
  final VoidCallback onTakeQuiz;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: progressNotifier,
            builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: const Color(0xFF007BFF), // Calm Blue — never hardcode in widgets, but LinearProgressIndicator uses color not colorScheme token
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.lessonTitle,
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  MarkdownBody(
                    data: lesson.contentText,
                    softLineBreak: true,
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      Theme.of(context),
                    ).copyWith(
                      p: textTheme.bodyLarge?.copyWith(height: 1.6),
                      h1: textTheme.headlineMedium,
                      h2: textTheme.headlineSmall,
                      h3: textTheme.titleLarge,
                      h4: textTheme.titleMedium,
                      code: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                      ),
                    ),
                    imageBuilder: (uri, title, alt) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CachedNetworkImage(
                        imageUrl: uri.toString(),
                        fit: BoxFit.fitWidth,
                        placeholder: (_, __) => const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (_, __, ___) => const Row(
                          children: [
                            Icon(Icons.broken_image_outlined),
                            SizedBox(width: 8),
                            Text('Image unavailable'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onTakeQuiz,
                child: const Text('Take quiz'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonSkeletonScreen extends StatelessWidget {
  const _LessonSkeletonScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          LinearProgressIndicator(value: 0, color: Colors.transparent),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(height: 28, width: double.infinity),
                  const SizedBox(height: 24),
                  _SkeletonBox(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  _SkeletonBox(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  _SkeletonBox(height: 16, width: 280),
                  const SizedBox(height: 16),
                  _SkeletonBox(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  _SkeletonBox(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  _SkeletonBox(height: 16, width: 240),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
```

### `router.dart` — Route Changes Reference

**Replace** the `/lesson/:taskId` stub (lines 87–94) with:
```dart
GoRoute(
  path: '/lesson/:taskId',
  pageBuilder: (context, state) {
    final taskId = state.pathParameters['taskId']!;
    return MaterialPage(child: LessonContentScreen(taskId: taskId));
  },
),
```

**Add** the `/quiz/:taskId` stub BEFORE the `ShellRoute` (Story 4.1 replaces this):
```dart
GoRoute(
  path: '/quiz/:taskId',
  // Story 4.1 will replace this stub with the real QuizScreen
  pageBuilder: (_, _) => const MaterialPage(
    child: Scaffold(body: Center(child: Text('Quiz coming soon'))),
  ),
),
```

**Add** import at top of `router.dart`:
```dart
import 'package:studyboard_mobile/features/lesson/presentation/lesson_content_screen.dart';
```

### Key Architecture Constraints

- **No new DAO methods needed** — `getLessonWithTopicTitle(lessonId)` already returns `LessonsTableData` containing `.contentText`; it's already called in `getLessonDetails`
- **Reuse `LessonNotifier` across screens** — both `CuriosityScreen` and `LessonContentScreen` use `ref.watch(lessonNotifierProvider(taskId))`; shared state is not a problem since both screens are never mounted simultaneously (`pushReplacement` removed CuriosityScreen from stack)
- **`ValueNotifier` for progress** — never use `setState` for scroll-driven progress; it rebuilds the entire subtree; `ValueListenableBuilder` rebuilds only the `LinearProgressIndicator`
- **No `PopScope`** — `LessonContentScreen` intentionally has NO `PopScope`; free back navigation is the spec (AC #6); standard `Navigator.maybePop` from Android back gesture applies
- **Bottom nav hidden** — `/lesson/:taskId` is a top-level `GoRoute` OUTSIDE `ShellRoute`; `ScaffoldWithNavBar` is not in the widget tree; no bottom nav during lesson
- **Sticky CTA always visible** — the `FilledButton` is outside the `SingleChildScrollView`, in the `Column` below `Expanded`; it is always rendered regardless of scroll position
- **`context.push` for quiz** — use `context.push('/quiz/$taskId')` (not `go` or `pushReplacement`); allows back from quiz to return to lesson content
- **`JetBrainsMono` font family** — use `TextStyle(fontFamily: 'JetBrainsMono')` for code blocks; do NOT use `GoogleFonts.jetBrainsMono()`; the font is bundled as an asset with `GoogleFonts.config.allowRuntimeFetching = false` in `main.dart`
- **Image loading in offline mode** — `CachedNetworkImage` uses `flutter_cache_manager` disk cache; if Story 3.3 pre-fetch has run, images load offline; if not cached, shows `CircularProgressIndicator` then loads from network
- **`MarkdownBody`, not `Markdown`** — use `MarkdownBody` (non-scrolling) inside `SingleChildScrollView`, NOT the `Markdown` widget (which has its own scroll); using `Markdown` prevents custom scroll progress tracking
- **`sort_constructors_first` lint** — constructor before field declarations in all new classes
- **`package:` imports everywhere** — no relative imports inside `lib/`

### Anti-Patterns to Avoid

- ❌ Using `setState` in `_onScroll` — rebuilds full screen on every scroll event; use `ValueNotifier<double>` + `ValueListenableBuilder` instead
- ❌ Using `Markdown` widget (scrollable) instead of `MarkdownBody` — cannot attach custom `ScrollController` to the inner `ListView` inside `Markdown`
- ❌ Using `GoogleFonts.jetBrainsMono()` for code styling — runtime font fetching is disabled; use `TextStyle(fontFamily: 'JetBrainsMono')`
- ❌ Adding `PopScope` to `LessonContentScreen` — explicitly NOT in spec; back button should work freely
- ❌ Placing the "Take quiz" button INSIDE `SingleChildScrollView` — it would disappear when the student scrolls; must be outside the scroll area
- ❌ Using `Image.network` instead of `CachedNetworkImage` — bypasses flutter_cache_manager disk cache; fails offline
- ❌ Adding `/lesson/:taskId` INSIDE the `ShellRoute` — bottom nav would be visible during lesson; lesson must be top-level route
- ❌ Using `context.go('/quiz/$taskId')` — replaces the lesson on the stack; back from quiz would skip lesson and go to board; use `context.push` to maintain the lesson in back stack
- ❌ Running build_runner before BOTH `lesson_repository.dart` AND `lesson_state.dart` are updated — run once after both changes are saved
- ❌ Using `Image.asset` for lesson images — lesson images are Supabase URLs, not bundled assets
- ❌ Creating a new `LessonRepository` method for content — `getLessonDetails` already returns everything; just add `contentText` to the existing `LessonDetails` model

### Project Structure — Files This Story Creates/Modifies

**Create:**
```
lib/features/lesson/presentation/lesson_content_screen.dart
test/features/lesson/presentation/lesson_content_screen_test.dart
```

**Modify:**
```
pubspec.yaml                                               # Add flutter_markdown + cached_network_image
lib/features/lesson/domain/lesson_repository.dart         # Add contentText to LessonDetails
lib/features/lesson/domain/lesson_repository.freezed.dart (regenerated)
lib/features/lesson/presentation/lesson_state.dart        # Add contentText to LessonState
lib/features/lesson/presentation/lesson_state.freezed.dart (regenerated)
lib/features/lesson/data/lesson_repository_impl.dart      # Return contentText in getLessonDetails()
lib/features/lesson/presentation/lesson_notifier.dart     # Populate contentText in build()
lib/features/lesson/presentation/lesson_notifier.g.dart   (regenerated — no semantic change)
lib/router.dart                                           # Replace /lesson stub + add /quiz stub
```

**Do NOT modify:**
- `lib/features/lesson/domain/lesson.dart` — Lesson domain model is not used directly; LessonsTableData is used via DAO
- `lib/features/lesson/domain/past_paper_question.dart` — not needed in this story
- `lib/core/database/daos/lesson_dao.dart` — all required methods already exist
- `lib/core/database/app_database.dart` — no schema changes
- `lib/core/database/tables/lessons_table.dart` — `contentText` column already present
- `lib/features/lesson/data/lesson_provider.dart` — no changes needed
- `lib/features/lesson/presentation/curiosity_screen.dart` — completed in Story 3.1; do not touch

### Build Runner Order

**Step 1:** After editing `lesson_repository.dart` and `lesson_state.dart` (Task 2):
```bash
dart run build_runner build --delete-conflicting-outputs
```
From `studyboard_mobile/`. Regenerates: `lesson_repository.freezed.dart`, `lesson_state.freezed.dart`, `lesson_notifier.g.dart` (no semantic changes to notifier).

No additional build_runner run needed — `LessonContentScreen` has no code generation annotations.

### Previous Story Learnings Applied (from Stories 2.3, 2.4, 3.1)

- **`lessonNotifierProvider(taskId)`** — generated provider name for `@riverpod class LessonNotifier` with `build(String taskId)` family; NOT `lessonProvider` (Riverpod 4.x confirmed suffix stripping in Story 3.1 debug log)
- **`ref.read` for one-shot actions**, `ref.watch` for reactive subscriptions — `onTakeQuiz` callback uses `context.push`, not ref
- **Dart closure type promotion** — if accessing `state.value` before an `await` gap, extract `final current = state.value` first; not needed in this story (no async gaps in UI handlers here)
- **`package:` imports everywhere** — no relative imports in `lib/`
- **`sort_constructors_first` lint** — constructor before field declarations
- **`unawaited()`** — NOT needed here; `context.push` returns `Future<T?>` but navigation results are never used; wrap with `unawaited()` only if called from a `void` callback that the linter flags
- **`appDatabaseProvider`** — access DAOs as property `ref.watch(appDatabaseProvider).lessonDao`; not needed in this screen directly
- **Skeleton loading > spinner** — `_LessonSkeletonScreen` shows grey container boxes; never `CircularProgressIndicator` at screen root (UX-DR17); CachedNetworkImage placeholder uses small inline `CircularProgressIndicator` (correct — image-only context)
- **`ConsumerStatefulWidget` for stateful screens** — `CuriosityScreen` was `ConsumerWidget`; `LessonContentScreen` needs `ConsumerStatefulWidget` because it owns `ScrollController` and `ValueNotifier`
- **`ref.invalidate` for error retry** — `ref.invalidate(lessonNotifierProvider(taskId))` triggers `build()` re-run; consistent with CuriosityScreen's retry pattern

### UX Requirements Reference

From [Source: ux-design-specification.md#LessonContent]:
- Full-screen lesson view: notes, diagrams, rich media rendered inline
- Progress bar at top showing position in lesson (TikTok-style — `LinearProgressIndicator`)
- Sticky "Take quiz" CTA visible at end of content (AC #5 clarification: always sticky below scroll)
- Free back navigation (no `PopScope` AlertDialog — unlike CuriosityScreen)
- Full-screen immersion: bottom nav hidden during lesson view (top-level route enforces this)

From [Source: ux-design-specification.md#Typography]:
- Body Large: 16sp, Regular 400, 1.6× line-height — for lesson content body
- Headline Medium: lesson title heading

From [Source: ux-design-specification.md#LoadingStates]:
- Offline / cached content: **NO loading state** — renders immediately (AC #1, #3)
- First-load (not yet in cache): skeleton shimmer (UX-DR17) — NOT centered spinner

From [Source: epics.md#UX-DR15]:
- `LessonContent` allows free back navigation (explicitly contrasted with `CuriosityScreen` and `QuizScreen` which use `PopScope`)

### References

- [Source: epics.md#Story 3.2] — Acceptance criteria, content rendering, offline requirement (FR18), progress bar, sticky CTA, free back navigation
- [Source: epics.md#Epic 3] — "LessonContent screen (progress bar, sticky CTA)" + flutter_cache_manager pre-fetch context
- [Source: architecture.md#Content Pre-fetch] — flutter_cache_manager: image URLs in content pre-fetched; CachedNetworkImage reads from disk cache offline
- [Source: architecture.md#Feature Folder Structure] — `lib/features/lesson/presentation/lesson_content_screen.dart`
- [Source: architecture.md#Riverpod State Management] — `ConsumerStatefulWidget`, `ValueNotifier` over `setState` for scroll progress
- [Source: ux-design-specification.md#LessonContent] — Full-screen, progress bar, sticky CTA, free back
- [Source: ux-design-specification.md#Typography] — Body Large 1.6× line-height for lesson body
- [Source: ux-design-specification.md#LoadingStates] — No spinner for cached; skeleton shimmer for uncached
- [Source: 3-1-curiosity-first-warm-up-screen.md#DevNotes] — lessonNotifierProvider family name, pushReplacement nav, skeleton pattern, ConsumerWidget reference, unawaited lint pattern
- [Source: 3-1-curiosity-first-warm-up-screen.md#DevAgentRecord] — Confirmed `lessonNotifierProvider(taskId)` naming (Riverpod 4.x strips Notifier suffix)

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- `lessonProvider` is the generated provider name (not `lessonNotifierProvider`) — Riverpod 4.x strips `Notifier` suffix; confirmed by reading `lesson_notifier.g.dart`.
- Pre-existing `session_tracker_notifier_test.dart` failure (Riverpod ref.read inside onDispose) is unrelated to this story and was present before implementation.
- `flutter_markdown 0.7.7+1` resolved by pub (satisfies `^0.7.6`).

### Completion Notes List

- Added `flutter_markdown: ^0.7.6` and `cached_network_image: ^3.4.1` to `pubspec.yaml`; ran `flutter pub get`.
- Added `required String contentText` to `LessonDetails` (domain) and `LessonState` (presentation); ran `build_runner` to regenerate all `.freezed.dart` and `.g.dart` files.
- Updated `LessonRepositoryImpl.getLessonDetails()` and `LessonNotifier.build()` to pass `contentText` through from the DAO layer.
- Created `LessonContentScreen` as a `ConsumerStatefulWidget` with `ScrollController` + `ValueNotifier<double>` for scroll-driven progress tracking (rebuilds only `LinearProgressIndicator` via `ValueListenableBuilder`). Includes skeleton loading state, error state with retry, and sticky "Take quiz" `FilledButton`. No `PopScope`.
- Updated `router.dart`: replaced `/lesson/:taskId` stub with real `LessonContentScreen`; added `/quiz/:taskId` stub (Story 4.1 will replace) as top-level route before `ShellRoute`.
- Fixed `lesson_notifier_test.dart` regression: added `contentText` to `_fakeLessonDetails()` helper.
- All 14 lesson tests pass (6 repo, 3 notifier, 5 new content-screen tests). No regressions in the test suite attributable to this story.

### File List

**Created:**
- `studyboard_mobile/lib/features/lesson/presentation/lesson_content_screen.dart`
- `studyboard_mobile/test/features/lesson/presentation/lesson_content_screen_test.dart`

**Modified:**
- `studyboard_mobile/pubspec.yaml`
- `studyboard_mobile/lib/features/lesson/domain/lesson_repository.dart`
- `studyboard_mobile/lib/features/lesson/domain/lesson_repository.freezed.dart` (regenerated)
- `studyboard_mobile/lib/features/lesson/presentation/lesson_state.dart`
- `studyboard_mobile/lib/features/lesson/presentation/lesson_state.freezed.dart` (regenerated)
- `studyboard_mobile/lib/features/lesson/presentation/lesson_notifier.g.dart` (regenerated)
- `studyboard_mobile/lib/features/lesson/data/lesson_repository_impl.dart`
- `studyboard_mobile/lib/features/lesson/presentation/lesson_notifier.dart`
- `studyboard_mobile/lib/router.dart`
- `studyboard_mobile/test/features/lesson/presentation/lesson_notifier_test.dart`

### Change Log

- 2026-05-02: Implemented LessonContentScreen with markdown rendering, scroll-progress bar, sticky CTA, skeleton loading, error retry, and offline image support via CachedNetworkImage. Added /quiz/:taskId stub route. (Story 3.2)
