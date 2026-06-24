/// User theme preference stored in settings.
enum ThemeModePreference {
  system,
  light,
  dark;

  String get storageValue => name;

  static ThemeModePreference fromStorage(String? value) {
    if (value == null) return ThemeModePreference.system;
    return ThemeModePreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeModePreference.system,
    );
  }
}
