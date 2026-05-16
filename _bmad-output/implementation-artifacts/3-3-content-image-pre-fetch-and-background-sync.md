# Story 3.3: Content Image Pre-fetch & Background Sync

Status: done

## Story

As a student,
I want all lesson content images downloaded to my device during my first session,
So that I can study offline at any time without hitting a missing image.

## Acceptance Criteria

1. **Given** a student has completed onboarding and the app has connectivity **When** the first content sync completes (lessons written to Drift) **Then** `flutter_cache_manager` eagerly pre-fetches all images for the first topic's lessons immediately — pre-fetch is non-blocking and does not delay navigation

2. **Given** the first topic's images are cached **When** the app is connected and not actively in use (background or idle foreground) **Then** `flutter_cache_manager` progressively pre-fetches images for all remaining topics in the background — the student never sees a missing image mid-session once the background fetch completes

3. **Given** the app is offline during a study session **When** a student opens any lesson whose images were pre-fetched **Then** all images render from the local cache with no network request and no placeholder or broken-image state (FR18)

4. **Given** new or updated lesson content is available in Supabase **When** the app opens with connectivity and the content version has changed **Then** updated content is synced to Drift and new image URLs are queued for pre-fetch — the sync runs in the background without interrupting any active session (FR19)

5. **Given** a pre-fetch fails for a specific image (network error mid-fetch) **When** the student later opens that lesson **Then** a `CircularProgressIndicator` (inline, 24×24) is shown while the image is fetched on-demand — the lesson is never completely inaccessible; only images in active view trigger on-demand fetches

6. **Given** the app is opened in airplane mode for the very first time (before any sync has completed) **When** the student views the backlog **Then** a clear message "Content not yet downloaded. Connect to the internet to load your lessons." is shown instead of the empty backlog — the app does not crash

## Tasks / Subtasks

- [x] Task 1: Add `getAllImageUrlsInTopicOrder()` and `hasAnyLessons()` to `ContentDao` (AC: #1, #2, #3, #6)
  - [x] Open `lib/core/database/daos/content_dao.dart`
  - [x] Add `getAllImageUrlsInTopicOrder()`: JOIN lessonsTable + topicsTable ORDER BY topicsTable.orderIndex ASC; extract image URLs from each `contentText` using regex `RegExp(r'!\[.*?\]\((https?://[^\)]+)\)')` — returns `Future<List<String>>` (empty list if no markdown images)
  - [x] Add `hasAnyLessons()`: `(select(lessonsTable)..limit(1)).get()` returns non-empty → `Future<bool>`
  - [x] No build_runner needed — these are regular Dart methods using existing `_$ContentDaoMixin` table accessors (`lessonsTable`, `topicsTable` already in `@DriftAccessor(tables: [...])`)

- [x] Task 2: Create `ContentCacheService` in `lib/core/content_cache/` (AC: #1, #2, #3, #5, #6)
  - [x] Create directory `lib/core/content_cache/` (new)
  - [x] Create `lib/core/content_cache/content_cache_service.dart` with:
    - `ContentCacheService(ContentDao _dao, BaseCacheManager _cacheManager)` constructor
    - `Future<void> prefetchAll()` — calls `_dao.getAllImageUrlsInTopicOrder()`, then `unawaited(_cacheManager.downloadFile(url).catchError((_) {}))` for each URL (fire-and-forget per URL; no await; topic-ordered so first topic images download first)
    - `Future<bool> hasContentSeeded()` — delegates to `_dao.hasAnyLessons()`
    - `@Riverpod(keepAlive: true)` top-level function provider: `ContentCacheService contentCacheService(Ref ref)` returning `ContentCacheService(ref.watch(contentDaoProvider), DefaultCacheManager())`
    - `part 'content_cache_service.g.dart';` import
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` from `studyboard_mobile/`
  - [x] Verify `content_cache_service.g.dart` is generated

- [x] Task 3: Modify `ContentSyncNotifier` to call `prefetchAll()` after sync (AC: #1, #2, #4)
  - [x] Open `lib/features/board/presentation/content_sync_notifier.dart`
  - [x] Add import: `package:connectivity_plus/connectivity_plus.dart`
  - [x] Add import: `package:studyboard_mobile/core/content_cache/content_cache_service.dart`
  - [x] In `build()`: before network calls, check `(await Connectivity().checkConnectivity()).any((r) => r != ConnectivityResult.none)`; if offline, return early (do NOT error — offline is expected)
  - [x] After successful `syncContent()`, fire pre-fetch: `unawaited(ref.read(contentCacheServiceProvider).prefetchAll().catchError((_) {}))` — non-blocking, errors silently ignored per URL
  - [x] Build signature (`Future<void> build()`) does NOT change → no build_runner re-run needed for this file

- [x] Task 4: Add "Content not yet downloaded" message to `BacklogScreen` (AC: #6)
  - [x] Open `lib/features/backlog/presentation/backlog_screen.dart`
  - [x] Add import: `package:studyboard_mobile/core/content_cache/content_cache_service.dart`
  - [x] In the `items.isEmpty` branch: call `await ref.read(contentCacheServiceProvider).hasContentSeeded()` (use `ref.read` — one-shot check, not reactive)
  - [x] If `!hasSeeded`: show `Center(child: Text('Content not yet downloaded. Connect to the internet to load your lessons.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center))` — exact wording per AC
  - [x] If `hasSeeded`: show existing empty message ("Everything is in progress or done." / "No Future Papers content available yet.") — no change to existing behavior
  - [x] The `hasContentSeeded()` call is async inside a sync `data:` callback — use a `FutureBuilder` widget or hoist to a separate `AsyncValue` provider; recommended: use a `@riverpod Future<bool> contentSeeded(Ref ref)` functional provider in `content_cache_service.dart` and `ref.watch` it from backlog

- [x] Task 5: Write tests (AC: #1, #2, #5)
  - [x] Create `test/core/content_cache/content_cache_service_test.dart`
  - [x] Test: `prefetchAll()` calls `downloadFile()` for each URL returned by `getAllImageUrlsInTopicOrder()` — mock `ContentDao` and `BaseCacheManager`
  - [x] Test: `prefetchAll()` with empty URL list does nothing (no exception, no downloads)
  - [x] Test: `prefetchAll()` silently ignores per-URL download errors (error in `downloadFile()` does not propagate)
  - [x] Test: `hasContentSeeded()` returns true when DAO returns true, false when DAO returns false
  - [x] Test: URL regex extracts correct URLs from markdown `![alt](https://example.com/img.png)` — test directly on `ContentDao.getAllImageUrlsInTopicOrder()` or extract regex logic into testable function

## Dev Notes

### CRITICAL: What Already Exists — Do NOT Recreate

- `flutter_cache_manager: ^3.4.1` — already in `pubspec.yaml` (added in Story 3.2) — **DO NOT add again**
- `connectivity_plus: ^7.1.1` — already in `pubspec.yaml` — **DO NOT add again**
- `ContentDao` in `lib/core/database/daos/content_dao.dart` — **EXTEND with new methods; do not recreate**
- `ContentRepositoryImpl.syncContent()` in `lib/features/board/data/content_repository_impl.dart` — already syncs all Supabase content to Drift; `content_version` is already upserted per subject — **DO NOT modify**; the existing unconditional sync satisfies AC4 for V1
- `ContentSyncNotifier` in `lib/features/board/presentation/content_sync_notifier.dart` — already triggers `syncContent()` on startup — **MODIFY only `build()` body**
- `contentSyncProvider` (generated name from `@riverpod class ContentSyncNotifier`) — already `.listen`-ed in `router.dart` at line 137 to keep it alive
- `contentDaoProvider` — in `lib/core/database/database_provider.dart` line 40; use `ref.watch(contentDaoProvider)` to inject `ContentDao`

### What Does NOT Exist Yet — Create These

- `lib/core/content_cache/` directory — **CREATE**
- `lib/core/content_cache/content_cache_service.dart` — **CREATE** (primary deliverable)
- `ContentCacheService` class and `@riverpod` provider — **CREATE**
- `ContentDao.getAllImageUrlsInTopicOrder()` — **ADD to existing DAO**
- `ContentDao.hasAnyLessons()` — **ADD to existing DAO**

### What NOT to Create in This Story

- `lib/core/sync/sync_service.dart` — **Story 5.1 only** (sync queue consumer)
- `lib/core/sync/connectivity_service.dart` — **Story 5.1 only** (full connectivity StreamProvider)
- No WorkManager / android background jobs — V1 "background" means fire-and-forget non-blocking in foreground
- No new Supabase calls — content_cache_service.dart reads only from Drift (image URLs) and downloads from CDN URLs already in `contentText`

### Architecture Boundaries (Hard Rules)

```
core/content_cache/    May depend on: core/database/ (ContentDao)
                       May NOT depend on: any feature/, presentation/
presentation/          May NOT depend on: data/ implementations, Drift, DAOs directly
```

**Important:** `BacklogScreen` must NOT call `contentDaoProvider` or `ContentDao` directly. Use `contentCacheServiceProvider.hasContentSeeded()` (through a Riverpod `FutureProvider` or `ref.watch(contentSeededProvider)`) to keep the layer boundary clean.

### File Location for ContentCacheService

Per architecture `lib/` tree (architecture.md line 657-658):
```
lib/core/
  content_cache/
    └── content_cache_service.dart   # flutter_cache_manager; pre-fetches all image URLs at first sync
```
NOT in `lib/features/board/data/` — this is core infrastructure, not a feature.

### ContentDao — New Methods (No Build Runner Needed)

The `@DriftAccessor(tables: [SubjectsTable, TopicsTable, LessonsTable, ...])` already includes both `lessonsTable` and `topicsTable` in the generated mixin. New query methods are plain Dart — no annotation changes, no rebuild:

```dart
// Add to ContentDao:
static final _imageRegex = RegExp(r'!\[.*?\]\((https?://[^\)]+)\)');

Future<List<String>> getAllImageUrlsInTopicOrder() async {
  final query = select(lessonsTable).join([
    innerJoin(topicsTable, topicsTable.id.equalsExp(lessonsTable.topicId)),
  ])..orderBy([OrderingTerm.asc(topicsTable.orderIndex), OrderingTerm.asc(lessonsTable.orderIndex)]);

  final rows = await query.get();
  final urls = <String>[];
  for (final row in rows) {
    final lesson = row.readTable(lessonsTable);
    for (final match in _imageRegex.allMatches(lesson.contentText)) {
      final url = match.group(1);
      if (url != null) urls.add(url);
    }
  }
  return urls;
}

Future<bool> hasAnyLessons() async {
  final rows = await (select(lessonsTable)..limit(1)).get();
  return rows.isNotEmpty;
}
```

### ContentCacheService — Full Implementation Reference

```dart
// lib/core/content_cache/content_cache_service.dart
import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';

part 'content_cache_service.g.dart';

class ContentCacheService {
  const ContentCacheService(this._dao, this._cacheManager);

  final ContentDao _dao;
  final BaseCacheManager _cacheManager;

  Future<void> prefetchAll() async {
    final urls = await _dao.getAllImageUrlsInTopicOrder();
    for (final url in urls) {
      unawaited(_cacheManager.downloadFile(url).catchError((_) {}));
    }
  }

  Future<bool> hasContentSeeded() => _dao.hasAnyLessons();
}

@Riverpod(keepAlive: true)
ContentCacheService contentCacheService(Ref ref) {
  return ContentCacheService(
    ref.watch(contentDaoProvider),
    DefaultCacheManager(),
  );
}

@Riverpod(keepAlive: true)
Future<bool> contentSeeded(Ref ref) =>
    ref.watch(contentCacheServiceProvider).hasContentSeeded();
```

**Note:** `ContentCacheService` is a plain class (not a Notifier). The `@Riverpod` provider is a functional provider (top-level function). The `contentSeeded` FutureProvider is for `BacklogScreen` to `ref.watch`.

### ContentSyncNotifier — Updated `build()` Reference

```dart
// lib/features/board/presentation/content_sync_notifier.dart
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/content_cache/content_cache_service.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/board/data/content_provider.dart';

part 'content_sync_notifier.g.dart';

@riverpod
class ContentSyncNotifier extends _$ContentSyncNotifier {
  @override
  Future<void> build() async {
    final authValue = ref.read(authProvider);
    final student = authValue.value?.mapOrNull(authenticated: (a) => a.student);
    if (student == null) return;

    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.any((r) => r != ConnectivityResult.none)) return;

    await ref.read(contentRepositoryProvider).syncContent(student.id);

    unawaited(
      ref.read(contentCacheServiceProvider).prefetchAll().catchError((_) {}),
    );
  }
}
```

**Important:** `build()` signature does NOT change (still `Future<void>`) → `content_sync_notifier.g.dart` does NOT need regeneration for this change.

### BacklogScreen — Empty State with Content Check

```dart
// In BacklogScreen's data: callback, replace the items.isEmpty branch:
if (items.isEmpty) {
  final hasContent = ref.watch(contentSeededProvider);
  return hasContent.when(
    data: (seeded) {
      if (!seeded) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Content not yet downloaded. Connect to the internet to load your lessons.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      final emptyMessage = selectedTrack == 'future_papers'
          ? 'No Future Papers content available yet.'
          : 'Everything is in progress or done.';
      return Center(child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyMedium));
    },
    loading: () => const SizedBox.shrink(),
    error: (_, _) => Center(
      child: Text('Everything is in progress or done.', style: Theme.of(context).textTheme.bodyMedium),
    ),
  );
}
```

### Schema Version — DO NOT Change

`AppDatabase.schemaVersion` stays at **2**. No new columns, no migrations.

`subjects_table.dart` already has `contentVersion` column. `ContentRepositoryImpl.syncContent()` already upserts `contentVersion` from Supabase. Version-mismatch-triggered re-sync is implicitly handled by the unconditional sync on startup (sufficient for V1 10-student scope).

### Build Runner Instructions

**Run once** after creating `content_cache_service.dart` with `@Riverpod` annotations:
```bash
dart run build_runner build --delete-conflicting-outputs
```
From `studyboard_mobile/`. Generates: `content_cache_service.g.dart`.

**No other build_runner runs needed:**
- `ContentDao` new methods → no annotations added → no regeneration
- `ContentSyncNotifier.build()` body change → no signature change → no regeneration
- `BacklogScreen` → no annotations

### Previous Story Learnings Applied (Stories 3.1, 3.2)

- **Generated provider name pattern (Riverpod 4.x):** `@riverpod class FooNotifier` generates `fooProvider` (NOT `fooNotifierProvider`); top-level `@riverpod Foo foo(Ref ref)` generates `fooProvider`
- **`unawaited()` + `catchError((_) {})`** — use for fire-and-forget async that should never throw; `unawaited()` suppresses lint; `catchError` prevents unhandled future errors
- **`package:` imports everywhere** — no relative imports inside `lib/`
- **`sort_constructors_first` lint** — constructor before fields in all new classes
- **`ref.read` for one-shot service calls** (like `prefetchAll()`), `ref.watch` for reactive/kept-alive providers
- **`ConsumerWidget` over `StatefulWidget`** when only Riverpod is needed (no `ScrollController` etc.)
- **`DefaultCacheManager()`** — singleton per Flutter process; calling it multiple times returns the same instance; no need to inject it as a singleton separately
- **`BaseCacheManager`** as constructor parameter type (not `DefaultCacheManager`) — enables mocking in tests

### Key Architecture Constraints

- **`prefetchAll()` is fire-and-forget** — do NOT `await` the full loop; each `downloadFile()` call is individually unawaited; the caller returns immediately after queuing all downloads
- **Topic order matters** — URLs for `topicId` with lowest `orderIndex` are queued first → those images start downloading first (satisfies AC1 eager-first-topic behavior)
- **`flutter_cache_manager` is idempotent** — calling `downloadFile(url)` on an already-cached URL returns the cached file immediately; no re-download; safe to call on every app startup
- **No mid-session interruption** — `ContentSyncNotifier.build()` fires once on app startup (Riverpod `AsyncNotifier` semantics); does NOT fire during active study sessions
- **`CachedNetworkImage` in `LessonContentScreen`** (Story 3.2) already reads from `DefaultCacheManager` disk cache — if pre-fetch ran before lesson is opened, images appear instantly from cache (AC3)
- **Connectivity check in `ContentSyncNotifier`** — returns early (not error) when offline; `AsyncValue.data(null)` (not error) is emitted, keeping the router's `.listen` callback happy
- **`contentSeededProvider`** — use `keepAlive: true` to avoid repeated DB queries on backlog rebuilds

### Anti-Patterns to Avoid

- ❌ `await prefetchAll()` in `ContentSyncNotifier.build()` — blocks startup until ALL images downloaded; spec says non-blocking
- ❌ Creating `sync_service.dart` or `connectivity_service.dart` in this story — those are Story 5.1
- ❌ Using `WorkManager` or platform background services — V1 only needs foreground non-blocking fetch
- ❌ Placing `ContentCacheService` in `lib/features/board/data/` — it's core infrastructure, not a feature
- ❌ Calling `contentDaoProvider` directly from `BacklogScreen` — violates layer boundary; use `contentSeededProvider`
- ❌ Catching errors in `prefetchAll()` at the loop level — catch must be per-URL (`.catchError` on each `downloadFile()` call); a single catch around the loop would swallow ALL errors including the URL list fetch
- ❌ Using `DefaultCacheManager` as the constructor parameter type — use `BaseCacheManager` for testability
- ❌ Adding `connectivity_plus` to `pubspec.yaml` — it's already there at `^7.1.1`

### Project Structure — Files This Story Creates/Modifies

**Create:**
```
lib/core/content_cache/content_cache_service.dart
lib/core/content_cache/content_cache_service.g.dart   (generated)
test/core/content_cache/content_cache_service_test.dart
```

**Modify:**
```
lib/core/database/daos/content_dao.dart                 # Add getAllImageUrlsInTopicOrder(), hasAnyLessons()
lib/features/board/presentation/content_sync_notifier.dart  # Add prefetchAll() call + connectivity guard
lib/features/backlog/presentation/backlog_screen.dart   # Add contentSeededProvider empty-state check
```

**Do NOT modify:**
- `lib/core/database/app_database.dart` — no schema changes
- `lib/core/database/daos/content_dao.g.dart` — not regenerated (no annotation changes)
- `lib/features/board/data/content_repository_impl.dart` — syncContent() already handles version upsert
- `lib/features/board/presentation/content_sync_notifier.g.dart` — build() signature unchanged
- `lib/features/lesson/presentation/lesson_content_screen.dart` — CachedNetworkImage already reads from cache (AC3, AC5 handled automatically)
- `pubspec.yaml` — no new dependencies
- `lib/core/sync/` — story 5.1 territory

### References

- [Source: epics.md#Story 3.3] — All 6 ACs, FR18, FR19
- [Source: epics.md#Epic 3] — "flutter_cache_manager eager pre-fetch (first topic) + background pre-fetch (remainder)"
- [Source: architecture.md#Content Pre-fetch] — flutter_cache_manager strategy; `ContentDao.getAllImageUrls`; `ContentCacheService.prefetchAll()` data flow
- [Source: architecture.md#Feature Folder Structure line 657-658] — `lib/core/content_cache/content_cache_service.dart`
- [Source: architecture.md#Architectural Boundaries] — `core/content_cache/` may only depend on `core/database/`
- [Source: architecture.md#Data Flow First Sync] — `syncContent() → ContentCacheService.prefetchAll() → getAllImageUrls() → downloadFile()`
- [Source: architecture.md#Gap 3] — `content_version` tracking; `subjects_table` already has column; unconditional sync satisfies V1 requirement
- [Source: 3-2-lesson-content-screen-and-rich-media.md#DevNotes] — `flutter_cache_manager: ^3.4.1` already in pubspec; `CachedNetworkImage` reads from disk cache; `unawaited()` + `catchError` lint pattern
- [Source: architecture.md#Key Packages] — `connectivity_plus: ^latest` (resolved to `^7.1.1`)

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

- All 5 tasks implemented and verified. New `ContentCacheService` created as core infrastructure with `prefetchAll()` (fire-and-forget, topic-ordered) and `hasContentSeeded()`. `ContentDao` extended with `getAllImageUrlsInTopicOrder()` (regex-based markdown image URL extraction with JOIN+ORDER) and `hasAnyLessons()`. `ContentSyncNotifier` updated with offline guard + post-sync prefetch trigger. `BacklogScreen` empty state now shows "Content not yet downloaded" when DB has no lessons, using `contentSeededProvider`. 10 new tests all pass; pre-existing `session_tracker_notifier_test` failures are unrelated (broken before this story). `prefetchAll()` uses `.then<void>((_) {}).catchError((_) {})` chain instead of raw `catchError` to satisfy Dart null-safety type constraints on `Future<FileInfo>`.

### File List

**Created:**
- studyboard_mobile/lib/core/content_cache/content_cache_service.dart
- studyboard_mobile/lib/core/content_cache/content_cache_service.g.dart
- studyboard_mobile/test/core/content_cache/content_cache_service_test.dart

**Modified:**
- studyboard_mobile/lib/core/database/daos/content_dao.dart
- studyboard_mobile/lib/features/board/presentation/content_sync_notifier.dart
- studyboard_mobile/lib/features/backlog/presentation/backlog_screen.dart

### Review Findings

- [x] [Review][Decision] ContentSyncNotifier is auto-dispose — fixed: changed to `@Riverpod(keepAlive: true)`, updated generated file
- [x] [Review][Decision] `prefetchAll` fires all downloads concurrently — fixed: changed to sequential `await` per URL with `on Object catch`
- [x] [Review][Patch] Duplicate test name and missing second test body — dismissed: false positive from truncated diff; test file is clean
- [x] [Review][Patch] `DefaultCacheManager()` should use `DefaultCacheManager.instance` — dismissed: `DefaultCacheManager()` is already a factory singleton
- [x] [Review][Patch] `syncContent` `Either` result discarded — fixed: fold result; prefetch only fires on success
- [x] [Review][Patch] `contentSeededProvider` never invalidated after sync — fixed: `ref.invalidate(contentSeededProvider)` on sync success
- [x] [Review][Patch] `_applyDiff` index calculation wrong after in-place removals — fixed: compute `insertAt` from surviving items
- [x] [Review][Patch] `_applyDiff` null `AnimatedListState` causes invisible state divergence — dismissed: existing fallback is correct; no desync possible when list isn't mounted
- [x] [Review][Patch] `boardRepo` captured via `ref.read` in `build()` — fixed: moved to point of use inside `_showBacklogActionSheet`
- [x] [Review][Patch] Outer `context` used in sheet builder for `Theme.of` — fixed: all sheet styles now use `Theme.of(sheetCtx)`
- [x] [Review][Patch] `getAllImageUrlsInTopicOrder` returns duplicate URLs — fixed: `.toSet().toList()` before return
- [x] [Review][Patch] `prefetchAll` test assertions unreliable — fixed by sequential prefetchAll; `await prefetchAll()` now completes all downloads before returning
- [x] [Review][Patch] AC6 "Content not yet downloaded" message unreachable via stream error path — fixed: error arm now watches `contentSeededProvider`
- [x] [Review][Defer] Connectivity check double-negative — logic correct, future maintenance hazard [lib/features/board/presentation/content_sync_notifier.dart:21] — deferred, pre-existing
- [x] [Review][Defer] No content-version change detection — unconditional sync is explicit V1 design decision — deferred, pre-existing
- [x] [Review][Defer] `_applyDiff` O(n²) scan with live Drift stream — bounded list, performance not correctness — deferred, pre-existing
- [x] [Review][Defer] Orphaned fire-and-forget downloads after provider disposal — test suite pollution, low prod impact — deferred, pre-existing

## Change Log

- Implemented ContentCacheService, extended ContentDao, updated ContentSyncNotifier and BacklogScreen for image pre-fetch and offline empty state (Date: 2026-05-03)
