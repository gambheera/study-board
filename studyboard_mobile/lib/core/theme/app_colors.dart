import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary
  static const Color calmBlue = Color(0xFF007BFF);
  // Accent / In Progress
  static const Color goldenYellow = Color(0xFFFFC107);
  // Background
  static const Color softWhite = Color(0xFFF8F9FA);
  // Task states
  static const Color sagGreen = Color(0xFF4CAF78); // Done
  static const Color dustyRose = Color(0xFFC4786A); // Re-opened
  static const Color blueGrey = Color(0xFF8896A5); // Backlog/To-Do
  // Dark surface tokens
  static const Color darkBackground = Color(0xFF1A1C1E);
  static const Color darkSurface = Color(0xFF22252A);
  static const Color darkSurfaceVar = Color(0xFF2D3136);
  static const Color darkOnSurface = Color(0xFFE3E4DC);
  // Text on yellow
  static const Color textOnYellow = Color(0xFF1A1A2E);
}

extension StudyBoardColors on ColorScheme {
  Color get taskBacklog => AppColors.blueGrey;
  Color get taskInProgress => AppColors.goldenYellow;
  Color get taskDone => AppColors.sagGreen;
  Color get taskReopened => AppColors.dustyRose;
}
