import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Material 3 light theme tuned for book reading.
ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.lightPrimary,
    brightness: Brightness.light,
    surface: AppColors.lightSurface,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme.copyWith(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    dividerColor: AppColors.lightDivider,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightPrimary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.lightDivider),
      ),
    ),
    textTheme: _buildTextTheme(
      arabicColor: AppColors.lightArabicText,
      amharicColor: AppColors.lightAmharicText,
      tafsirColor: AppColors.lightTafsirText,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      indicatorColor: AppColors.lightPrimary.withValues(alpha: 0.12),
    ),
  );
}

/// Material 3 dark theme for low-light reading.
ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.darkPrimary,
    brightness: Brightness.dark,
    surface: AppColors.darkSurface,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme.copyWith(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    dividerColor: AppColors.darkDivider,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkPrimary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.darkDivider),
      ),
    ),
    textTheme: _buildTextTheme(
      arabicColor: AppColors.darkArabicText,
      amharicColor: AppColors.darkAmharicText,
      tafsirColor: AppColors.darkTafsirText,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      indicatorColor: AppColors.darkPrimary.withValues(alpha: 0.2),
    ),
  );
}

TextTheme _buildTextTheme({
  required Color arabicColor,
  required Color amharicColor,
  required Color tafsirColor,
}) {
  return TextTheme(
    headlineLarge: TextStyle(
      fontFamily: AppTypography.titleFontFamily,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: arabicColor,
      height: 1.4,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppTypography.titleFontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: arabicColor,
      height: 1.4,
    ),
    titleLarge: TextStyle(
      fontFamily: AppTypography.arabicFontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: arabicColor,
      height: 1.8,
    ),
    bodyLarge: TextStyle(
      fontFamily: AppTypography.arabicFontFamily,
      fontSize: 22,
      color: arabicColor,
      height: 2.0,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppTypography.amharicFontFamily,
      fontSize: 16,
      color: amharicColor,
      height: 1.7,
    ),
    bodySmall: TextStyle(
      fontFamily: AppTypography.amharicFontFamily,
      fontSize: 14,
      color: tafsirColor,
      height: 1.6,
    ),
    labelLarge: TextStyle(
      fontFamily: AppTypography.amharicFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}
