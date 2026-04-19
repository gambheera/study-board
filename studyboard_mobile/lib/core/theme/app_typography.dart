import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static const TextStyle display = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1,
  );
  static const TextStyle headline = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
  // Dashboard metrics — JetBrains Mono signals machine-verified data
  static const TextStyle monoData = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1,
  );
}
