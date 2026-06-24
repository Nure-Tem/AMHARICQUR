import '../../domain/entities/bookmark.dart';
import '../../domain/entities/highlight.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/repositories.dart';

/// Bookmark business operations.
abstract class BookmarkService {
  Future<List<Bookmark>> getAllSortedByNewest();
  Future<void> create(Bookmark bookmark);
  Future<void> rename(String id, String newName);
  Future<void> remove(String id);
}

class BookmarkServiceImpl implements BookmarkService {
  BookmarkServiceImpl(this._repository);

  final BookmarkRepository _repository;

  @override
  Future<List<Bookmark>> getAllSortedByNewest() =>
      _repository.getAllSortedByNewest();

  @override
  Future<void> create(Bookmark bookmark) => _repository.add(bookmark);

  @override
  Future<void> rename(String id, String newName) async {
    final existing = await _repository.getById(id);
    if (existing == null) return;
    await _repository.update(
      Bookmark(
        id: existing.id,
        contentBlockId: existing.contentBlockId,
        customName: newName,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
        charOffset: existing.charOffset,
        previewText: existing.previewText,
      ),
    );
  }

  @override
  Future<void> remove(String id) => _repository.delete(id);
}

/// Highlight overlay operations — never modifies book text.
abstract class HighlightService {
  Future<List<Highlight>> getAll();
  Future<List<Highlight>> getForBlock(int contentBlockId);
  Future<void> create(Highlight highlight);
  Future<void> remove(String id);
}

class HighlightServiceImpl implements HighlightService {
  HighlightServiceImpl(this._repository);

  final HighlightRepository _repository;

  @override
  Future<List<Highlight>> getAll() => _repository.getAll();

  @override
  Future<List<Highlight>> getForBlock(int contentBlockId) =>
      _repository.getByContentBlockId(contentBlockId);

  @override
  Future<void> create(Highlight highlight) => _repository.add(highlight);

  @override
  Future<void> remove(String id) => _repository.delete(id);
}

/// Note operations linked to highlights or content blocks.
abstract class NoteService {
  Future<List<Note>> getAll();
  Future<List<Note>> getForHighlight(String highlightId);
  Future<void> create(Note note);
  Future<void> update(Note note);
  Future<void> remove(String id);
}

class NoteServiceImpl implements NoteService {
  NoteServiceImpl(this._repository);

  final NoteRepository _repository;

  @override
  Future<List<Note>> getAll() => _repository.getAll();

  @override
  Future<List<Note>> getForHighlight(String highlightId) =>
      _repository.getByHighlightId(highlightId);

  @override
  Future<void> create(Note note) => _repository.add(note);

  @override
  Future<void> update(Note note) => _repository.update(note);

  @override
  Future<void> remove(String id) => _repository.delete(id);
}
