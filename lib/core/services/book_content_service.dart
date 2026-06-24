import '../../core/constants/app_constants.dart';
import '../../domain/entities/book_content.dart';
import '../../domain/repositories/repositories.dart';

/// Orchestrates lazy-loaded reader content windows.
abstract class BookContentService {
  Future<ContentBlock?> getBlock(int id);
  Future<ReaderPage> loadPage({required int startSortOrder});
  Future<List<TocEntry>> getTableOfContents();
  Future<int> getTotalBlocks();
}

/// A window of content blocks for the reader list.
class ReaderPage {
  const ReaderPage({
    required this.blocks,
    required this.startSortOrder,
    required this.hasMore,
  });

  final List<ContentBlock> blocks;
  final int startSortOrder;
  final bool hasMore;
}

class BookContentServiceImpl implements BookContentService {
  BookContentServiceImpl(this._repository);

  final BookContentRepository _repository;

  @override
  Future<ContentBlock?> getBlock(int id) => _repository.getBlockById(id);

  @override
  Future<ReaderPage> loadPage({required int startSortOrder}) async {
    final blocks = await _repository.getBlocksPage(
      startSortOrder: startSortOrder,
      pageSize: AppConstants.readerPageSize,
    );

    final total = await _repository.getTotalBlockCount();
    final loadedCount = blocks.length;
    final lastSortOrder = blocks.isNotEmpty ? blocks.last.sortOrder : startSortOrder;

    return ReaderPage(
      blocks: blocks,
      startSortOrder: startSortOrder,
      hasMore: loadedCount >= AppConstants.readerPageSize && lastSortOrder < total,
    );
  }

  @override
  Future<List<TocEntry>> getTableOfContents() =>
      _repository.getTableOfContents();

  @override
  Future<int> getTotalBlocks() => _repository.getTotalBlockCount();
}
