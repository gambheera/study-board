# Story 1.2: App Theme, Design System & Navigation Shell

Status: done

## Story

As a student,
I want the app to display with the Serene Scholar visual design — calm colors, readable fonts, and dark mode by default,
so that the app feels trustworthy and calm from the very first frame.

## Acceptance Criteria

1. **Given** the app is launched for the first time **When** the first frame renders **Then** the app displays in dark mode without any light-mode flash (`ThemeMode` awaited from `SharedPreferences` before `runApp()`)

2. **Given** a student changes their theme preference in settings **When** the app is restarted **Then** the chosen theme persists correctly — dark mode or light mode — via `SharedPreferences`

3. **Given** the `StudyBoardColors` extension on `ColorScheme` **When** any widget calls `Theme.of(context).colorScheme.taskBacklog`, `.taskInProgress`, `.taskDone`, or `.taskReopened` **Then** the correct hex values are returned: `#8896A5`, `#FFC107`, `#4CAF78`, `#C4786A` respectively — no hardcoded hex values exist inside any widget file

4. **Given** Nunito and JetBrains Mono are bundled as Flutter font assets and `GoogleFonts.config.allowRuntimeFetching = false` is set before `runApp()` **When** the app renders with no internet connection **Then** all text displays correctly using the bundled fonts with no font-load errors

5. **Given** the Material 3 `ThemeData` is seeded with `ColorScheme.fromSeed(seedColor: Color(0xFF007BFF))` **When** the app renders any Material component (Card, Button, NavigationBar, Dialog) **Then** the Serene Scholar palette overrides the default Material tonal palette and no Material You dynamic color interpolation overrides the custom tokens

6. **Given** the `NavigationBar` shell with three tabs (Board, Dashboard, Backlog) **When** a student taps any tab **Then** the tab switches instantly with no page transition animation and the active tab shows a Calm Blue filled icon indicator

## Tasks / Subtasks

- [x] Task 1: Add `shared_preferences` dependency (AC: #1, #2)
  - [x] Add `shared_preferences: ^2.3.0` (or latest stable) to `pubspec.yaml` under `dependencies`
  - [x] Run `flutter pub get` to resolve

- [x] Task 2: Download and bundle font files (AC: #4)
  - [x] Download Nunito from Google Fonts: Regular (400), Medium (500), SemiBold (600), Bold (700) weights — https://fonts.google.com/specimen/Nunito
  - [x] Place files in `assets/fonts/Nunito/` as: `Nunito-Regular.ttf`, `Nunito-Medium.ttf`, `Nunito-SemiBold.ttf`, `Nunito-Bold.ttf`
  - [x] Download JetBrains Mono Regular (400) and Medium (500) ONLY — https://fonts.google.com/specimen/JetBrains+Mono
  - [x] Place files in `assets/fonts/JetBrainsMono/` as: `JetBrainsMono-Regular.ttf`, `JetBrainsMono-Medium.ttf`
  - [x] Add `flutter.fonts:` section to `pubspec.yaml` (see Dev Notes for exact YAML)

- [x] Task 3: Create `lib/core/theme/app_colors.dart` (AC: #3, #5)
  - [x] Define `AppColors` class with all static `Color` constants (raw `Color(0xFFxxxxxx)` values — no hex strings)
  - [x] Define `StudyBoardColors` extension on `ColorScheme` with semantic accessors: `taskBacklog`, `taskInProgress`, `taskDone`, `taskReopened`
  - [x] Verify: no hardcoded hex values in this extension beyond `Color(0xFF...)` constants that delegate to `AppColors`

- [x] Task 4: Create `lib/core/theme/app_typography.dart` (AC: #4)
  - [x] Define `AppTextStyles` class with all static `TextStyle` constants
  - [x] Implement full type scale: Display (32sp/700), Headline (24sp/600), TitleLarge (20sp/600), TitleMedium (16sp/500), BodyLarge (16sp/400), BodyMedium (14sp/400), LabelLarge (14sp/500), LabelMedium (12sp/500), MonoData (28sp/400)
  - [x] Nunito styles use `fontFamily: 'Nunito'` (registered via pubspec)
  - [x] MonoData style uses `fontFamily: 'JetBrainsMono'` (registered via pubspec)
  - [x] Lesson content styles set `height: 1.6` (1.6× line height); UI label styles set `height: 1.2`; mono styles set `height: 1.0`

- [x] Task 5: Create `lib/core/theme/app_theme.dart` (AC: #5, #6)
  - [x] Implement `AppTheme.light()` — `ThemeData` with `useMaterial3: true`, seeded from `Color(0xFF007BFF)`, Nunito `textTheme`, `NavigationBarThemeData` with `indicatorColor: AppColors.calmBlue`
  - [x] Implement `AppTheme.dark()` — same seed, same overrides, `Brightness.dark` surface tokens (see Dev Notes for dark surface table)
  - [x] Apply `NavigationBarThemeData` to both themes: `indicatorColor: AppColors.calmBlue`, `backgroundColor` from surface token
  - [x] Apply `CardTheme`: `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))` — Material 3 medium shape
  - [x] No hardcoded hex strings inside `app_theme.dart` — all colors via `AppColors.*`

- [x] Task 6: Create `lib/core/theme/theme_mode_notifier.dart` (AC: #1, #2)
  - [x] Define `initialThemeModeProvider` — plain `Provider<ThemeMode>((ref) => ThemeMode.dark)` (not `@riverpod`, used as override target)
  - [x] Define `@riverpod class ThemeModeNotifier extends _$ThemeModeNotifier` with:
    - `build()` returns `ref.watch(initialThemeModeProvider)`
    - `setMode(ThemeMode mode)` — updates `state`, writes `mode.name` to SharedPreferences key `'theme_mode'`
  - [x] Run `flutter pub run build_runner build` after creating the notifier to generate `theme_mode_notifier.g.dart`
  - [x] Write unit tests in `test/core/theme/theme_mode_notifier_test.dart` (mock SharedPreferences via `mocktail`)

- [x] Task 7: Update `lib/bootstrap.dart` (AC: #1, #4)
  - [x] Add `google_fonts` import; call `GoogleFonts.config.allowRuntimeFetching = false` as the FIRST line after `WidgetsFlutterBinding.ensureInitialized()`
  - [x] After Supabase init, add: `final prefs = await SharedPreferences.getInstance();` then load theme key and resolve `ThemeMode`
  - [x] Change `runApp(ProviderScope(...))` to include `overrides: [initialThemeModeProvider.overrideWithValue(initialThemeMode)]`
  - [x] Verify existing Firebase + Crashlytics init order is preserved (Firebase first, always)

- [x] Task 8: Update `lib/app.dart` (AC: #1, #2, #3, #4, #5)
  - [x] Watch `themeModeNotifierProvider` via `ref.watch`
  - [x] Pass `theme: AppTheme.light()`, `darkTheme: AppTheme.dark()`, `themeMode: currentMode` to `MaterialApp.router`
  - [x] Keep `localizationsDelegates` and `supportedLocales` from Story 1.1

- [x] Task 9: Update `lib/router.dart` — instant tab transitions (AC: #6)
  - [x] Change `GoRoute.builder` to `GoRoute.pageBuilder` using `NoTransitionPage` for all three shell routes (`/board`, `/dashboard`, `/backlog`)
  - [x] Verify `ScaffoldWithNavBar` still works correctly
  - [x] Update `NavigationDestination` icons/labels to match design: Board = `Icons.view_kanban_outlined` / `Icons.view_kanban`, Dashboard = `Icons.bar_chart_outlined` / `Icons.bar_chart`, Backlog = `Icons.list_alt_outlined` / `Icons.list_alt`
  - [x] NavigationBar styling comes from ThemeData (no per-widget overrides needed)

- [x] Task 10: Write tests (AC: all)
  - [x] `test/core/theme/app_colors_test.dart` — verify `StudyBoardColors` extension returns correct `Color` values for all four semantic tokens
  - [x] `test/core/theme/app_theme_test.dart` — verify `AppTheme.light()` has `useMaterial3: true`, correct `colorScheme.primary` matches seed, `NavigationBarTheme` has Calm Blue indicator; same checks for `AppTheme.dark()`
  - [x] `test/core/theme/theme_mode_notifier_test.dart` — test `build()` returns value from `initialThemeModeProvider`; test `setMode(ThemeMode.light)` updates state and writes to SharedPreferences

- [x] Task 11: Verify build + analyze (AC: all)
  - [x] `flutter analyze` → 0 issues
  - [x] `flutter test` → all tests pass (existing 26 + new tests)

## Dev Notes

### Critical Bootstrap Sequence — No Flash Dark Mode (AC #1)

The `SharedPreferences` read MUST complete before `runApp()`. Modify `bootstrap.dart` as follows:

```dart
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // MUST be first — prevents any google_fonts network fetch (AC #4)
  GoogleFonts.config.allowRuntimeFetching = false;

  // Firebase init (unchanged from Story 1.1)
  try { await Firebase.initializeApp(...); } catch (e, s) { ... }
  // Crashlytics hooks (unchanged)
  if (!kDebugMode) { ... }
  // Supabase init (unchanged)
  await Supabase.initialize(...);

  // Load persisted ThemeMode BEFORE runApp to prevent first-frame flash
  const _themeModeKey = 'theme_mode';
  final prefs = await SharedPreferences.getInstance();
  final savedThemeName = prefs.getString(_themeModeKey);
  final initialThemeMode = ThemeMode.values.firstWhere(
    (m) => m.name == savedThemeName,
    orElse: () => ThemeMode.dark, // Default: dark (UX-DR3)
  );

  runApp(
    ProviderScope(
      overrides: [
        initialThemeModeProvider.overrideWithValue(initialThemeMode),
      ],
      child: await builder(),
    ),
  );
}
```

> **NEVER** move the `SharedPreferences` read after `runApp()` — this causes a 1-frame light mode flash on dark-mode-first users.

### pubspec.yaml Font Registration

Add this `fonts:` block under the `flutter:` key in `pubspec.yaml`. The `assets:` block already declares the directories; `fonts:` registers them with the Flutter engine.

```yaml
flutter:
  generate: true
  uses-material-design: true
  assets:
    - assets/fonts/Nunito/
    - assets/fonts/JetBrainsMono/
  fonts:
    - family: Nunito
      fonts:
        - asset: assets/fonts/Nunito/Nunito-Regular.ttf
          weight: 400
        - asset: assets/fonts/Nunito/Nunito-Medium.ttf
          weight: 500
        - asset: assets/fonts/Nunito/Nunito-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Nunito/Nunito-Bold.ttf
          weight: 700
    - family: JetBrainsMono
      fonts:
        - asset: assets/fonts/JetBrainsMono/JetBrainsMono-Regular.ttf
          weight: 400
        - asset: assets/fonts/JetBrainsMono/JetBrainsMono-Medium.ttf
          weight: 500
```

> **JetBrains Mono ONLY Regular + Medium.** Do NOT add other weights (Bold, Italic, etc.). APK impact from these two fonts combined: ~300KB. Architecture requires Medium and Regular only.

### Font File Download

The font files must be downloaded and placed in the asset directories before running the build. Use one of these methods:

**Method A — Via curl (recommended for dev agent):**
```bash
# Nunito
cd studyboard_mobile/assets/fonts/Nunito
curl -L "https://github.com/googlefonts/nunito/raw/main/fonts/variable/Nunito%5Bwght%5D.ttf" -o Nunito-Variable.ttf
# For specific weights — prefer static fonts from google_fonts cache:
# ~/.pub-cache/hosted/pub.dev/google_fonts-8.x.x/lib/asset_cache/Nunito-Regular.ttf
# Copy those to the assets/fonts/Nunito/ directory

# JetBrains Mono
cd studyboard_mobile/assets/fonts/JetBrainsMono
curl -L "https://github.com/JetBrains/JetBrainsMono/raw/master/fonts/ttf/JetBrainsMono-Regular.ttf" -o JetBrainsMono-Regular.ttf
curl -L "https://github.com/JetBrains/JetBrainsMono/raw/master/fonts/ttf/JetBrainsMono-Medium.ttf" -o JetBrainsMono-Medium.ttf
```

**Method B — From google_fonts cache (if fonts previously downloaded by the package):**
```bash
# Find cached fonts (google_fonts package caches to pub cache on first network access)
find ~/.pub-cache -name "Nunito-*.ttf" 2>/dev/null
# Copy to assets/fonts/Nunito/
```

> The exact file names in `assets/fonts/` must match the `asset:` paths declared in `pubspec.yaml`. Case-sensitive on Linux/macOS.

### app_colors.dart — Color Tokens

```dart
// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary
  static const Color calmBlue       = Color(0xFF007BFF);
  // Accent / In Progress
  static const Color goldenYellow   = Color(0xFFFFC107);
  // Background
  static const Color softWhite      = Color(0xFFF8F9FA);
  // Task states
  static const Color sagGreen       = Color(0xFF4CAF78); // Done
  static const Color dustyRose      = Color(0xFFC4786A); // Re-opened
  static const Color blueGrey       = Color(0xFF8896A5); // Backlog/To-Do
  // Dark surface tokens
  static const Color darkBackground = Color(0xFF1A1C1E);
  static const Color darkSurface    = Color(0xFF22252A);
  static const Color darkSurfaceVar = Color(0xFF2D3136);
  static const Color darkOnSurface  = Color(0xFFE3E4DC);
  // Text on yellow
  static const Color textOnYellow   = Color(0xFF1A1A2E);
}

extension StudyBoardColors on ColorScheme {
  Color get taskBacklog    => AppColors.blueGrey;
  Color get taskInProgress => AppColors.goldenYellow;
  Color get taskDone       => AppColors.sagGreen;
  Color get taskReopened   => AppColors.dustyRose;
}
```

> **Constraint:** Widget files MUST NOT contain `Color(0xFF...)` literals for semantic task state colors. Always use `Theme.of(context).colorScheme.taskDone` etc.

### app_typography.dart — Type Scale

```dart
// lib/core/theme/app_typography.dart
import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static const TextStyle display = TextStyle(
    fontFamily: 'JetBrainsMono', fontSize: 32, fontWeight: FontWeight.w700, height: 1.0,
  );
  static const TextStyle headline = TextStyle(
    fontFamily: 'Nunito', fontSize: 24, fontWeight: FontWeight.w600, height: 1.2,
  );
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w600, height: 1.2,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w500, height: 1.2,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w400, height: 1.6, // lesson content
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w400, height: 1.6,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w500, height: 1.2,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500, height: 1.2,
  );
  // Dashboard metrics — JetBrains Mono, signals machine-verified data
  static const TextStyle monoData = TextStyle(
    fontFamily: 'JetBrainsMono', fontSize: 28, fontWeight: FontWeight.w400, height: 1.0,
  );
}
```

### app_theme.dart — Material 3 ThemeData

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() => _buildTheme(brightness: Brightness.light);
  static ThemeData dark()  => _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.calmBlue,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // Force Nunito as the base text theme
      textTheme: Typography.material2021().black.apply(fontFamily: 'Nunito'),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.calmBlue,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      cardTheme: const CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
```

> **Material You override:** `ColorScheme.fromSeed` with a fixed seed and no `dynamicColorSupport: true` means the palette is deterministic. The seed color controls the primary slot, but custom task-state semantic tokens live in the `StudyBoardColors` extension — they are completely outside Material's tonal system.

### theme_mode_notifier.dart — Riverpod ThemeMode Persistence

```dart
// lib/core/theme/theme_mode_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_notifier.g.dart';

// Plain provider — overridden in bootstrap.dart with persisted value.
// Default value (dark) is only reached if bootstrap override is missing.
final initialThemeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.dark);

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() => ref.watch(initialThemeModeProvider);

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}
```

After creating this file, run:
```bash
cd studyboard_mobile
dart run build_runner build --delete-conflicting-outputs
```

This generates `theme_mode_notifier.g.dart`.

### router.dart — Instant Tab Switching (NoTransitionPage)

Replace `builder:` with `pageBuilder:` for the three shell child routes:

```dart
GoRoute(
  path: '/board',
  pageBuilder: (_, __) => const NoTransitionPage(child: BoardScreen()),
),
GoRoute(
  path: '/dashboard',
  pageBuilder: (_, __) => const NoTransitionPage(child: DashboardScreen()),
),
GoRoute(
  path: '/backlog',
  pageBuilder: (_, __) => const NoTransitionPage(child: BacklogScreen()),
),
```

> `NoTransitionPage` is in `go_router` — no additional import needed. This eliminates the slide/fade animation between tabs, achieving the "instant switch" required by UX-DR14 and AC #6.

### app.dart — ThemeMode Integration

```dart
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    return MaterialApp.router(
      title: 'StudyBoard',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
```

### Layer / File Boundary Compliance

| File | Layer | May import |
|------|-------|-----------|
| `app_colors.dart` | `core/theme` | `flutter/material.dart` only |
| `app_typography.dart` | `core/theme` | `flutter/material.dart` only |
| `app_theme.dart` | `core/theme` | `app_colors.dart`, `flutter/material.dart` |
| `theme_mode_notifier.dart` | `core/theme` | `shared_preferences`, `riverpod_annotation`, `flutter_riverpod` |

> No feature code (`features/`) is imported in any `core/theme/` file.

### NavigationBar Color — Architecture Note

The `NavigationBar` active indicator color is set via `NavigationBarThemeData.indicatorColor` in `AppTheme`. No per-widget styling is needed in `ScaffoldWithNavBar`. The NavigationBar automatically picks up the theme's `indicatorColor`. If the indicator still shows Material's teal/purple tonal color, verify that `ThemeData.navigationBarTheme` is correctly set in `AppTheme._buildTheme()`.

### Testing Patterns

**ThemeModeNotifier test (Riverpod 3.0 pattern):**
```dart
test('build() returns value from initialThemeModeProvider', () {
  final container = ProviderContainer(
    overrides: [
      initialThemeModeProvider.overrideWithValue(ThemeMode.light),
    ],
  );
  addTearDown(container.dispose);
  expect(container.read(themeModeNotifierProvider), ThemeMode.light);
});

test('setMode writes to SharedPreferences', () async {
  final mockPrefs = MockSharedPreferences();
  when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
  // ... wire mock via SharedPreferences.setMockInitialValues({}) or mocktail
  final container = ProviderContainer();
  addTearDown(container.dispose);
  await container.read(themeModeNotifierProvider.notifier).setMode(ThemeMode.light);
  expect(container.read(themeModeNotifierProvider), ThemeMode.light);
});
```

**StudyBoardColors test:**
```dart
test('taskDone returns sage green', () {
  const scheme = ColorScheme.light(primary: Color(0xFF007BFF));
  expect(scheme.taskDone, const Color(0xFF4CAF78));
});
```

### Previous Story Learnings (from Story 1.1)

- **riverpod_generator**: Actual installed version is `4.0.3` (not `^2.6.5`). The annotation package is `riverpod_annotation: ^4.0.2`. Use `dart run build_runner build` (not `flutter pub run`).
- **freezed**: Actual installed version is `freezed: ^3.2.5` and `freezed_annotation: ^3.1.0`. If any freezed model is added, ensure correct imports.
- **bootstrap.dart pattern**: The `builder` parameter is `FutureOr<Widget> Function()` — `await builder()` is already inside `runApp(ProviderScope(..., child: await builder()))`. The `ProviderScope` override must be set BEFORE `runApp` is called.
- **firebase_options.dart**: Contains `REPLACE_WITH_*` placeholder values. Build will fail with a real Firebase project. This is acceptable for testing — `flutter test` doesn't call Firebase.
- **APK build blocked**: Android SDK not in this dev environment. Use `flutter analyze` + `flutter test` to verify correctness.

### Dark Surface Token Reference

| Token | Light | Dark |
|-------|-------|------|
| Background | `#F8F9FA` | `#1A1C1E` |
| Surface | `#FFFFFF` | `#22252A` |
| Surface variant | `#EEF2FF` | `#2D3136` |
| On-surface | `#1A1A2E` | `#E3E4DC` |

### Architecture Compliance Checklist

- [ ] No `Color(0xFF...)` literals inside any feature widget file (only in `app_colors.dart`)
- [ ] `StudyBoardColors` extension is the only path for semantic task state colors
- [ ] `GoogleFonts.config.allowRuntimeFetching = false` called before `runApp()`
- [ ] `SharedPreferences` read completed before `runApp()` — no first-frame flash
- [ ] `AppTheme.light()` / `AppTheme.dark()` are pure functions — no side effects
- [ ] `ThemeModeNotifier.build()` reads `initialThemeModeProvider` — not hardcoded
- [ ] `ProviderScope` override in `bootstrap.dart` uses `initialThemeModeProvider`
- [ ] `NoTransitionPage` used for all three shell child routes — instant tab switch
- [ ] `flutter analyze` → 0 issues after changes

### Anti-Patterns (Never Do)

- ❌ `Color(0xFF4CAF78)` inside a widget — use `colorScheme.taskDone`
- ❌ `ThemeMode.dark` hardcoded in `App.build()` — must watch `themeModeNotifierProvider`
- ❌ Reading SharedPreferences inside a widget build — reads happen only in bootstrap and notifier
- ❌ `GoogleFonts.nunito()` called anywhere — use `fontFamily: 'Nunito'` directly (fonts are registered natively)
- ❌ Animated transition between tabs — use `NoTransitionPage` (instant switch required)
- ❌ `NavigationBarThemeData` set per-widget — set once in `AppTheme._buildTheme()`

### Project Structure Notes

Files to CREATE in this story:
```
studyboard_mobile/
├── lib/core/theme/
│   ├── app_colors.dart           # NEW: Color constants + StudyBoardColors extension
│   ├── app_typography.dart       # NEW: TextStyle type scale
│   ├── app_theme.dart            # NEW: ThemeData light + dark
│   └── theme_mode_notifier.dart  # NEW: ThemeModeNotifier + initialThemeModeProvider
│   └── theme_mode_notifier.g.dart # GENERATED by build_runner
├── assets/fonts/Nunito/
│   ├── Nunito-Regular.ttf        # DOWNLOAD
│   ├── Nunito-Medium.ttf         # DOWNLOAD
│   ├── Nunito-SemiBold.ttf       # DOWNLOAD
│   └── Nunito-Bold.ttf           # DOWNLOAD
└── assets/fonts/JetBrainsMono/
    ├── JetBrainsMono-Regular.ttf # DOWNLOAD
    └── JetBrainsMono-Medium.ttf  # DOWNLOAD (ONLY these two)
```

Files to MODIFY:
```
studyboard_mobile/pubspec.yaml              # Add shared_preferences + flutter.fonts: section
studyboard_mobile/lib/bootstrap.dart        # Add GoogleFonts.config + SharedPreferences + override
studyboard_mobile/lib/app.dart              # Watch ThemeModeNotifier, apply ThemeData
studyboard_mobile/lib/router.dart           # NoTransitionPage + icon updates
```

Files to CREATE for tests:
```
studyboard_mobile/test/core/theme/
├── app_colors_test.dart
├── app_theme_test.dart
└── theme_mode_notifier_test.dart
```

### References

- [Source: epics.md#Story 1.2] — Acceptance criteria
- [Source: ux-design-specification.md#Design System Foundation] — Serene Scholar palette, typography scale
- [Source: ux-design-specification.md#Component Strategy] — NavigationBar behavior, tab switching
- [Source: ux-design-specification.md#UX Consistency Patterns] — Color tokens by name
- [Source: architecture.md#Flutter Architecture] — Theme, color, typography file paths under `lib/core/theme/`
- [Source: architecture.md#Implementation Patterns] — No hardcoded hex in widgets, anti-patterns
- [Source: 1-1-flutter-project-scaffold-and-core-architecture.md#Dev Agent Record] — riverpod_generator 4.x, freezed 3.x actual versions, bootstrap.dart pattern
- [Source: architecture.md#Key Packages] — `shared_preferences` not in original list; add explicitly

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- Riverpod 4.x generates provider as `themeModeProvider` (not `themeModeNotifierProvider`) — updated all references in app.dart and tests accordingly.
- `package:flutter/widgets.dart` import removed from bootstrap.dart (redundant with `material.dart`).
- `height: 1.0` replaced with `height: 1` in app_typography.dart to satisfy `avoid_redundant_argument_values` lint.
- `(_, __)` replaced with `(_, _)` in router.dart pageBuilder lambdas per Dart 3 wildcard pattern lint.
- Font files were already present in `assets/fonts/` from prior setup — Task 2 required only pubspec registration.

### Completion Notes List

- Implemented Serene Scholar design system: `AppColors`, `AppTextStyles`, `AppTheme` (light + dark), `StudyBoardColors` extension.
- `ThemeModeNotifier` persists theme choice to SharedPreferences; `initialThemeModeProvider` overridden in bootstrap before `runApp()` to prevent first-frame flash.
- `GoogleFonts.config.allowRuntimeFetching = false` set as first action in bootstrap (before Firebase init).
- All three shell routes switched to `NoTransitionPage` for instant tab switching.
- NavigationDestination icons updated to design spec (view_kanban, bar_chart, list_alt variants).
- 16 new tests added across 3 files; all 42 tests pass, `flutter analyze` → 0 issues.

### File List

- `studyboard_mobile/pubspec.yaml` (modified — added shared_preferences dependency + fonts registration)
- `studyboard_mobile/lib/bootstrap.dart` (modified — GoogleFonts config, SharedPreferences load, ProviderScope override)
- `studyboard_mobile/lib/app.dart` (modified — theme/darkTheme/themeMode wired to AppTheme + ThemeModeNotifier)
- `studyboard_mobile/lib/router.dart` (modified — NoTransitionPage, updated NavigationDestination icons)
- `studyboard_mobile/lib/core/theme/app_colors.dart` (new)
- `studyboard_mobile/lib/core/theme/app_typography.dart` (new)
- `studyboard_mobile/lib/core/theme/app_theme.dart` (new)
- `studyboard_mobile/lib/core/theme/theme_mode_notifier.dart` (new)
- `studyboard_mobile/lib/core/theme/theme_mode_notifier.g.dart` (generated)
- `studyboard_mobile/test/core/theme/app_colors_test.dart` (new)
- `studyboard_mobile/test/core/theme/app_theme_test.dart` (new)
- `studyboard_mobile/test/core/theme/theme_mode_notifier_test.dart` (new)

### Change Log

- 2026-04-17: Implemented Story 1.2 — App Theme, Design System & Navigation Shell. Added Serene Scholar color tokens, type scale, Material 3 ThemeData (light/dark), persisted ThemeMode via SharedPreferences, NoTransitionPage tab routing, bundled Nunito + JetBrains Mono fonts. 16 new tests added, all 42 tests pass.
- 2026-04-17: Code review — fixed 8 issues: brightness-adaptive typography and NavBar indicator color, Supabase assert → throw, Crashlytics catchError, ThemeModeNotifier.key deduplication, keepAlive: true on ThemeModeNotifier, NavBar label height: 1.2, JetBrains Mono Bold font asset added. All 42 tests pass, flutter analyze → 0 issues.

### Review Findings

- [x] [Review][Decision] NavigationBar `calmBlue` indicator fails WCAG AA contrast in dark theme — resolved: dark mode now uses `colorScheme.primary` (M3 brightness-adaptive); light mode retains `AppColors.calmBlue`.
- [x] [Review][Decision] JetBrains Mono w700 unavailable at runtime for `AppTextStyles.display` — resolved: added `JetBrainsMono-Bold.ttf` asset and registered at weight 700 in pubspec.yaml.
- [x] [Review][Patch] Dark theme textTheme uses `Typography.material2021().black` — fixed: `_buildTheme` now branches on brightness to select `.white` or `.black` [lib/core/theme/app_theme.dart:16]
- [x] [Review][Patch] Supabase credential `assert` stripped in release builds — fixed: replaced with explicit `if...throw StateError` [lib/bootstrap.dart:55]
- [x] [Review][Patch] `unawaited(recordFlutterFatalError)` missing `.catchError` on the `FlutterError.onError` path — fixed: `.catchError` added [lib/bootstrap.dart:37]
- [x] [Review][Patch] Duplicate `'theme_mode'` key string in bootstrap.dart and theme_mode_notifier.dart — fixed: `_key` made public as `ThemeModeNotifier.key`; bootstrap uses it directly [lib/bootstrap.dart, lib/core/theme/theme_mode_notifier.dart]
- [x] [Review][Patch] `ThemeModeNotifier` generated as `autoDispose` — fixed: annotation changed to `@Riverpod(keepAlive: true)`; regenerated [lib/core/theme/theme_mode_notifier.dart:12]
- [x] [Review][Patch] NavigationBar label `TextStyle` missing `height: 1.2` — fixed [lib/core/theme/app_theme.dart:21]
- [x] [Review][Defer] `PlatformDispatcher.onError` always returns `true`, suppressing fatal errors from the platform [lib/bootstrap.dart:37] — deferred, pre-existing from Story 1.1
- [x] [Review][Defer] `_selectedIndex` silently returns 0 for any unrecognised path — misleads nav bar state for future deep-link routes [lib/router.dart:73] — deferred, pre-existing / future-route concern
- [x] [Review][Defer] `goRouterProvider` disposes `GoRouter` when a nested `ProviderScope` is disposed — affects widget tests [lib/router.dart:8] — deferred, pre-existing
- [x] [Review][Defer] `taskReopened` ColorScheme token defined ahead of matching `TaskStatus.reopened` enum variant [lib/core/theme/app_colors.dart:21] — deferred, intentional forward-looking design
- [x] [Review][Defer] `TaskStatusX.fromString` wraps unknown DB status values as `NetworkFailure` instead of a parse error — deferred, pre-existing from Story 1.1
- [x] [Review][Defer] `AppLocalizations.of(context)!` force-unwrap in generated l10n code — deferred, pre-existing from Story 1.1
- [x] [Review][Defer] `google_fonts` retained as a dependency alongside bundled fonts — risk of future `GoogleFonts.*()` misuse — deferred, pre-existing
- [x] [Review][Defer] `app_theme_test.dart:31` force-casts `shape!` without a type-safe matcher — deferred, minor test quality
- [x] [Review][Defer] `debugPrint` in Crashlytics `catchError` is a no-op in release — deferred, pre-existing from Story 1.1
