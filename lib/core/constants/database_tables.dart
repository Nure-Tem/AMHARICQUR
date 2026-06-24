/// SQLite table and column name constants.
/// Matches parser-generated schema (content_blocks + paragraphs).
abstract final class DatabaseTables {
  // Parser-generated tables
  static const String books = 'books';
  static const String chapters = 'chapters';
  static const String sections = 'sections';
  static const String pages = 'pages';
  static const String contentBlocks = 'content_blocks';
  static const String paragraphs = 'paragraphs';
  static const String bookContentFts = 'book_content_fts';
  
  // Legacy name kept for backward compatibility
  static const String bookContent = 'content_blocks';
  
  // User data tables
  static const String bookmarks = 'bookmarks';
  static const String highlights = 'highlights';
  static const String notes = 'notes';
  static const String readingHistory = 'reading_history';
  static const String settings = 'settings';
}
