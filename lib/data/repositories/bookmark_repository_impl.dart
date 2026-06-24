import '../../../domain/entities/bookmark.dart';
import '../../../domain/repositories/repositories.dart';
import '../datasources/local/daos/bookmark_dao.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  BookmarkRepositoryImpl(this._dao);

  final BookmarkDao _dao;

  @override
  Future<List<Bookmark>> getAllSortedByNewest() => _dao.getAllSortedByNewest();

  @override
  Future<Bookmark?> getById(String id) => _dao.getById(id);

  @override
  Future<void> add(Bookmark bookmark) => _dao.insert(bookmark);

  @override
  Future<void> update(Bookmark bookmark) => _dao.update(bookmark);

  @override
  Future<void> delete(String id) => _dao.delete(id);
}
