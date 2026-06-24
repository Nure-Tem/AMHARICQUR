import 'package:equatable/equatable.dart';

import '../../core/enums/theme_mode_preference.dart';

/// Application settings persisted in SQLite.
class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeModePreference.system,
    this.readerFontScale = 1.0,
    this.readerLineHeight = 1.6,
    this.keepScreenOn = false,
    this.defaultHighlightColor,
  });

  final ThemeModePreference themeMode;
  final double readerFontScale;
  final double readerLineHeight;
  final bool keepScreenOn;
  final String? defaultHighlightColor;

  AppSettings copyWith({
    ThemeModePreference? themeMode,
    double? readerFontScale,
    double? readerLineHeight,
    bool? keepScreenOn,
    String? defaultHighlightColor,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      readerFontScale: readerFontScale ?? this.readerFontScale,
      readerLineHeight: readerLineHeight ?? this.readerLineHeight,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      defaultHighlightColor:
          defaultHighlightColor ?? this.defaultHighlightColor,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        readerFontScale,
        readerLineHeight,
        keepScreenOn,
        defaultHighlightColor,
      ];
}
