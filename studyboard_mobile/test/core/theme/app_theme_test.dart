import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';
import 'package:studyboard_mobile/core/theme/app_theme.dart';

void main() {
  group('AppTheme.light()', () {
    late ThemeData theme;

    setUp(() => theme = AppTheme.light());

    test('uses Material 3', () {
      expect(theme.useMaterial3, isTrue);
    });

    test('colorScheme primary matches seed color', () {
      final fromSeed = ColorScheme.fromSeed(
        seedColor: AppColors.calmBlue,
      );
      expect(theme.colorScheme.primary, fromSeed.primary);
    });

    test('NavigationBarTheme has Calm Blue indicator', () {
      expect(
        theme.navigationBarTheme.indicatorColor,
        AppColors.calmBlue,
      );
    });

    test('CardTheme has 12dp rounded corners', () {
      final shape = theme.cardTheme.shape! as RoundedRectangleBorder;
      final radius = shape.borderRadius
          .resolve(TextDirection.ltr)
          .topLeft;
      expect(radius.x, 12);
    });
  });

  group('AppTheme.dark()', () {
    late ThemeData theme;

    setUp(() => theme = AppTheme.dark());

    test('uses Material 3', () {
      expect(theme.useMaterial3, isTrue);
    });

    test('colorScheme brightness is dark', () {
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('colorScheme primary matches seed color', () {
      final fromSeed = ColorScheme.fromSeed(
        seedColor: AppColors.calmBlue,
        brightness: Brightness.dark,
      );
      expect(theme.colorScheme.primary, fromSeed.primary);
    });

    test('NavigationBarTheme indicator uses colorScheme.primary in dark mode',
        () {
      final expectedPrimary = ColorScheme.fromSeed(
        seedColor: AppColors.calmBlue,
        brightness: Brightness.dark,
      ).primary;
      expect(theme.navigationBarTheme.indicatorColor, expectedPrimary);
    });
  });
}
