import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_notifier.g.dart';

// Plain provider — overridden in bootstrap.dart with persisted value.
// Default (dark) is only reached if bootstrap override is missing.
final initialThemeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.dark);

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const key = 'theme_mode';

  @override
  ThemeMode build() => ref.watch(initialThemeModeProvider);

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, mode.name);
  }
}
