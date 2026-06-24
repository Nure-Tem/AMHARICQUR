import '../../core/enums/theme_mode_preference.dart';
import '../../domain/entities/app_settings.dart';

/// Key-value settings row model.
class SettingModel {
  const SettingModel({
    required this.key,
    required this.value,
    required this.updatedAt,
  });

  final String key;
  final String value;
  final int updatedAt;

  factory SettingModel.fromMap(Map<String, Object?> map) {
    return SettingModel(
      key: map['key']! as String,
      value: map['value']! as String,
      updatedAt: map['updated_at']! as int,
    );
  }

  Map<String, Object?> toMap() => {
        'key': key,
        'value': value,
        'updated_at': updatedAt,
      };
}

/// Aggregated settings parsed from key-value rows.
class AppSettingsModel {
  static const String keyThemeMode = 'theme_mode';
  static const String keyReaderFontScale = 'reader_font_scale';
  static const String keyReaderLineHeight = 'reader_line_height';
  static const String keyKeepScreenOn = 'keep_screen_on';
  static const String keyDefaultHighlightColor = 'default_highlight_color';

  static AppSettings fromRows(List<SettingModel> rows) {
    final map = {for (final r in rows) r.key: r.value};
    return AppSettings(
      themeMode: ThemeModePreference.fromStorage(map[keyThemeMode]),
      readerFontScale: double.tryParse(map[keyReaderFontScale] ?? '') ?? 1.0,
      readerLineHeight: double.tryParse(map[keyReaderLineHeight] ?? '') ?? 1.6,
      keepScreenOn: map[keyKeepScreenOn] == 'true',
      defaultHighlightColor: map[keyDefaultHighlightColor],
    );
  }

  static List<SettingModel> toRows(AppSettings settings, int updatedAt) => [
        SettingModel(
          key: keyThemeMode,
          value: settings.themeMode.storageValue,
          updatedAt: updatedAt,
        ),
        SettingModel(
          key: keyReaderFontScale,
          value: settings.readerFontScale.toString(),
          updatedAt: updatedAt,
        ),
        SettingModel(
          key: keyReaderLineHeight,
          value: settings.readerLineHeight.toString(),
          updatedAt: updatedAt,
        ),
        SettingModel(
          key: keyKeepScreenOn,
          value: settings.keepScreenOn.toString(),
          updatedAt: updatedAt,
        ),
        if (settings.defaultHighlightColor != null)
          SettingModel(
            key: keyDefaultHighlightColor,
            value: settings.defaultHighlightColor!,
            updatedAt: updatedAt,
          ),
      ];
}
