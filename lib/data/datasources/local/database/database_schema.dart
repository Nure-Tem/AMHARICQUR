import '../../../../core/constants/database_tables.dart';

/// SQLite schema definitions and migration scripts.
///
/// See [DATABASE.md] at project root for full design documentation.
abstract final class DatabaseSchema {
  static const int version = 1;

  /// Creates user-data tables (bookmarks, highlights, notes, history, settings).
  /// Book content tables are already created by the parser-generated database.
  static const List<String> createUserTables = [
    _createBookmarks,
    _createHighlights,
    _createNotes,
    _createReadingHistory,
    _createSettings,
    _createIndexes,
  ];

  /// Schema for book content - NOT USED since parser creates these tables.
  /// Kept for reference only.
  static const List<String> createBookContentTables = [];

  static const String _createBookmarks = '''
CREATE TABLE IF NOT EXISTS ${DatabaseTables.bookmarks} (
  id TEXT PRIMARY KEY,
  content_block_id INTEGER NOT NULL,
  char_offset INTEGER,
  custom_name TEXT NOT NULL,
  preview_text TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY (content_block_id) REFERENCES content_blocks(id)
);
''';

  static const String _createHighlights = '''
CREATE TABLE IF NOT EXISTS ${DatabaseTables.highlights} (
  id TEXT PRIMARY KEY,
  content_block_id INTEGER NOT NULL,
  char_offset_start INTEGER NOT NULL,
  char_offset_end INTEGER NOT NULL,
  color TEXT NOT NULL,
  selected_text TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY (content_block_id) REFERENCES content_blocks(id)
);
''';

  static const String _createNotes = '''
CREATE TABLE IF NOT EXISTS ${DatabaseTables.notes} (
  id TEXT PRIMARY KEY,
  highlight_id TEXT,
  content_block_id INTEGER NOT NULL,
  char_offset_start INTEGER,
  char_offset_end INTEGER,
  note_text TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY (highlight_id) REFERENCES ${DatabaseTables.highlights}(id) ON DELETE SET NULL,
  FOREIGN KEY (content_block_id) REFERENCES content_blocks(id)
);
''';

  static const String _createReadingHistory = '''
CREATE TABLE IF NOT EXISTS ${DatabaseTables.readingHistory} (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  content_block_id INTEGER NOT NULL,
  scroll_offset REAL NOT NULL DEFAULT 0,
  scroll_fraction REAL NOT NULL DEFAULT 0,
  char_offset INTEGER,
  section_title TEXT,
  visited_at INTEGER NOT NULL,
  is_continue_reading INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (content_block_id) REFERENCES content_blocks(id)
);
''';

  static const String _createSettings = '''
CREATE TABLE IF NOT EXISTS ${DatabaseTables.settings} (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at INTEGER NOT NULL
);
''';

  static const String _createIndexes = '''
CREATE INDEX IF NOT EXISTS idx_bookmarks_created_at
  ON ${DatabaseTables.bookmarks}(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_highlights_content_block
  ON ${DatabaseTables.highlights}(content_block_id);

CREATE INDEX IF NOT EXISTS idx_notes_highlight_id
  ON ${DatabaseTables.notes}(highlight_id);

CREATE INDEX IF NOT EXISTS idx_reading_history_visited_at
  ON ${DatabaseTables.readingHistory}(visited_at DESC);

CREATE INDEX IF NOT EXISTS idx_reading_history_continue
  ON ${DatabaseTables.readingHistory}(is_continue_reading);
''';
}
