import 'package:flutter/material.dart';

/// Book-inspired color palette for light and dark themes.
abstract final class AppColors {
  // Light — warm parchment tones
  static const Color lightBackground = Color(0xFFFAF6F0);
  static const Color lightSurface = Color(0xFFFFFDF8);
  static const Color lightPrimary = Color(0xFF1B5E4B);
  static const Color lightSecondary = Color(0xFF8B6914);
  static const Color lightArabicText = Color(0xFF1A1A1A);
  static const Color lightAmharicText = Color(0xFF2C2C2C);
  static const Color lightTafsirText = Color(0xFF4A4A4A);
  static const Color lightDivider = Color(0xFFE8E0D4);

  // Dark — deep reading mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFF4DB6A0);
  static const Color darkSecondary = Color(0xFFD4A84B);
  static const Color darkArabicText = Color(0xFFE8E8E8);
  static const Color darkAmharicText = Color(0xFFD0D0D0);
  static const Color darkTafsirText = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF333333);
}

abstract final class AppTypography {
  static const String arabicFontFamily = 'NotoNaskhArabic';
  static const String amharicFontFamily = 'NotoEthiopic';
  static const String titleFontFamily = 'Amiri';
}
