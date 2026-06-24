/// Application-wide constants.
abstract final class AppConstants {
  static const String appName = 'Amharic Qur';
  static const String databaseName = 'amharic_qur.db';
  static const String bundledDatabaseAsset = 'assets/database/book.db';
  static const int databaseVersion = 1;

  /// Number of content blocks loaded per reader page/window.
  static const int readerPageSize = 50;

  /// Debounce delay before persisting scroll position (milliseconds).
  static const int scrollSaveDebounceMs = 500;

  /// FTS search result limit per query.
  static const int searchResultLimit = 100;
}
