import '../../../../core/constants/database_tables.dart';
import '../../../../domain/entities/bookmark.dart';
import '../../../models/bookmark_model.dart';
import '../database/app_database.dart';

abstract class BookmarkDao {
  Future<List<Bookmark>> getAllSortedByNewest();
  Future<Bookmark?> getById(String id);
  Future<void> insert(Bookmark bookmark);
  Future<void> update(Bookmark bookmark);
  Future<void> delete(String id);
}

class BookmarkDaoImpl implements BookmarkDao {
  BookmarkDaoImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<Bookmark>> getAllSortedByNewest() async {
    final rows = await _database.db.query(
      DatabaseTables.bookmarks,
      orderBy: 'created_at DESC',
    );
    return rows.map((r) => BookmarkModel.fromMap(r).toEntity()).toList();
  }

  @override
  Future<Bookmark?> getById(String id) async {
    final rows = await _database.db.query(
      DatabaseTables.bookmarks,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return BookmarkModel.fromMap(rows.first).toEntity();
  }

  @override
  Future<void> insert(Bookmark bookmark) async {
    await _database.db.insert(
      DatabaseTables.bookmarks,
      BookmarkModel.fromEntity(bookmark).toMap(),
    );
  }

  @override
  Future<void> update(Bookmark bookmark) async {
    await _database.db.update(
      DatabaseTables.bookmarks,
      BookmarkModel.fromEntity(bookmark).toMap(),
      where: 'id = ?',
      whereArgs: [bookmark.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await _database.db.delete(
      DatabaseTables.bookmarks,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
