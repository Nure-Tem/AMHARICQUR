import '../../../domain/entities/note.dart';
import '../../../domain/repositories/repositories.dart';
import '../datasources/local/daos/note_dao.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._dao);

  final NoteDao _dao;

  @override
  Future<List<Note>> getAll() => _dao.getAll();

  @override
  Future<List<Note>> getByHighlightId(String highlightId) =>
      _dao.getByHighlightId(highlightId);

  @override
  Future<void> add(Note note) => _dao.insert(note);

  @override
  Future<void> update(Note note) => _dao.update(note);

  @override
  Future<void> delete(String id) => _dao.delete(id);
}
