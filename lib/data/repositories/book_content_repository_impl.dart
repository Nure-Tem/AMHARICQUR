import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/book_content.dart';
import '../../../domain/repositories/repositories.dart';
import '../datasources/local/daos/book_content_dao.dart';

class BookContentRepositoryImpl implements BookContentRepository {
  BookContentRepositoryImpl(this._dao);

  final BookContentDao _dao;

  @override
  Future<ContentBlock?> getBlockById(int id) => _dao.getById(id);

  @override
  Future<List<ContentBlock>> getBlocksPage({
    required int startSortOrder,
    int pageSize = AppConstants.readerPageSize,
  }) =>
      _dao.getRange(startSortOrder: startSortOrder, limit: pageSize);

  @override
  Future<List<TocEntry>> getTableOfContents() => _dao.getTocEntries();

  @override
  Future<int> getTotalBlockCount() => _dao.getTotalBlockCount();
}
