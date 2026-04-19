import 'package:flutter/material.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() => _buildTheme(brightness: Brightness.light);
  static ThemeData dark() => _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.calmBlue,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: (brightness == Brightness.dark
              ? Typography.material2021().white
              : Typography.material2021().black)
          .apply(fontFamily: 'Nunito'),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: brightness == Brightness.dark
            ? colorScheme.primary
            : AppColors.calmBlue,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
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
