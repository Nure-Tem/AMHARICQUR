import '../../domain/entities/book_content.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/highlight.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/reading_position.dart';
import '../../domain/entities/app_settings.dart';

/// Book content read operations.
abstract class BookContentRepository {
  Future<ContentBlock?> getBlockById(int id);
  Future<List<ContentBlock>> getBlocksPage({
    required int startSortOrder,
    int pageSize,
  });
  Future<List<TocEntry>> getTableOfContents();
  Future<int> getTotalBlockCount();
}

/// Bookmark CRUD.
abstract class BookmarkRepository {
  Future<List<Bookmark>> getAllSortedByNewest();
  Future<Bookmark?> getById(String id);
  Future<void> add(Bookmark bookmark);
  Future<void> update(Bookmark bookmark);
  Future<void> delete(String id);
}

/// Highlight CRUD — overlays only, never mutates book text.
abstract class HighlightRepository {
  Future<List<Highlight>> getAll();
  Future<List<Highlight>> getByContentBlockId(int contentBlockId);
  Future<void> add(Highlight highlight);
  Future<void> update(Highlight highlight);
  Future<void> delete(String id);
}

/// Note CRUD.
abstract class NoteRepository {
  Future<List<Note>> getAll();
  Future<List<Note>> getByHighlightId(String highlightId);
  Future<void> add(Note note);
  Future<void> update(Note note);
  Future<void> delete(String id);
}

/// Reading position persistence.
abstract class ReadingHistoryRepository {
  Future<ReadingPosition?> getContinueReading();
  Future<List<ReadingPosition>> getRecentReading({int limit});
  Future<void> saveContinueReading(ReadingPosition position);
  Future<void> recordVisit(ReadingPosition position);
}

/// Full-text search.
abstract class SearchRepository {
  Future<List<SearchResult>> search(String query, {int? limit});
}

/// App settings persistence.
abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
}
