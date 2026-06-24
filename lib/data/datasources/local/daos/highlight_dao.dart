import '../../../../core/constants/database_tables.dart';
import '../../../../domain/entities/highlight.dart';
import '../../../models/highlight_model.dart';
import '../database/app_database.dart';

abstract class HighlightDao {
  Future<List<Highlight>> getAll();
  Future<List<Highlight>> getByContentBlockId(int contentBlockId);
  Future<Highlight?> getById(String id);
  Future<void> insert(Highlight highlight);
  Future<void> update(Highlight highlight);
  Future<void> delete(String id);
}

class HighlightDaoImpl implements HighlightDao {
  HighlightDaoImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<Highlight>> getAll() async {
    final rows = await _database.db.query(
      DatabaseTables.highlights,
      orderBy: 'created_at DESC',
    );
    return rows.map((r) => HighlightModel.fromMap(r).toEntity()).toList();
  }

  @override
  Future<List<Highlight>> getByContentBlockId(int contentBlockId) async {
    final rows = await _database.db.query(
      DatabaseTables.highlights,
      where: 'content_block_id = ?',
      whereArgs: [contentBlockId],
      orderBy: 'char_offset_start ASC',
    );
    return rows.map((r) => HighlightModel.fromMap(r).toEntity()).toList();
  }

  @override
  Future<Highlight?> getById(String id) async {
    final rows = await _database.db.query(
      DatabaseTables.highlights,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return HighlightModel.fromMap(rows.first).toEntity();
  }

  @override
  Future<void> insert(Highlight highlight) async {
    await _database.db.insert(
      DatabaseTables.highlights,
      HighlightModel.fromEntity(highlight).toMap(),
    );
  }

  @override
  Future<void> update(Highlight highlight) async {
    await _database.db.update(
      DatabaseTables.highlights,
      HighlightModel.fromEntity(highlight).toMap(),
      where: 'id = ?',
      whereArgs: [highlight.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await _database.db.delete(
      DatabaseTables.highlights,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
