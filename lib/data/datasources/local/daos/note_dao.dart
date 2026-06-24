import '../../../../core/constants/database_tables.dart';
import '../../../../domain/entities/note.dart';
import '../../../models/note_model.dart';
import '../database/app_database.dart';

abstract class NoteDao {
  Future<List<Note>> getAll();
  Future<List<Note>> getByHighlightId(String highlightId);
  Future<List<Note>> getByContentBlockId(int contentBlockId);
  Future<Note?> getById(String id);
  Future<void> insert(Note note);
  Future<void> update(Note note);
  Future<void> delete(String id);
}

class NoteDaoImpl implements NoteDao {
  NoteDaoImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<Note>> getAll() async {
    final rows = await _database.db.query(
      DatabaseTables.notes,
      orderBy: 'updated_at DESC',
    );
    return rows.map((r) => NoteModel.fromMap(r).toEntity()).toList();
  }

  @override
  Future<List<Note>> getByHighlightId(String highlightId) async {
    final rows = await _database.db.query(
      DatabaseTables.notes,
      where: 'highlight_id = ?',
      whereArgs: [highlightId],
      orderBy: 'updated_at DESC',
    );
    return rows.map((r) => NoteModel.fromMap(r).toEntity()).toList();
  }

  @override
  Future<List<Note>> getByContentBlockId(int contentBlockId) async {
    final rows = await _database.db.query(
      DatabaseTables.notes,
      where: 'content_block_id = ?',
      whereArgs: [contentBlockId],
      orderBy: 'updated_at DESC',
    );
    return rows.map((r) => NoteModel.fromMap(r).toEntity()).toList();
  }

  @override
  Future<Note?> getById(String id) async {
    final rows = await _database.db.query(
      DatabaseTables.notes,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return NoteModel.fromMap(rows.first).toEntity();
  }

  @override
  Future<void> insert(Note note) async {
    await _database.db.insert(
      DatabaseTables.notes,
      NoteModel.fromEntity(note).toMap(),
    );
  }

  @override
  Future<void> update(Note note) async {
    await _database.db.update(
      DatabaseTables.notes,
      NoteModel.fromEntity(note).toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await _database.db.delete(
      DatabaseTables.notes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
