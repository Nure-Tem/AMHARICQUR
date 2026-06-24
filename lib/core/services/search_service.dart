import '../../domain/entities/book_content.dart';
import '../../domain/repositories/repositories.dart';

/// Full-text search across Arabic, Amharic, and titles.
abstract class SearchService {
  Future<List<SearchResult>> search(String query);
  Future<List<SearchResult>> searchDebounced(String query);
}

class SearchServiceImpl implements SearchService {
  SearchServiceImpl(this._repository);

  final SearchRepository _repository;

  @override
  Future<List<SearchResult>> search(String query) {
    if (query.trim().length < 2) return Future.value([]);
    return _repository.search(query);
  }

  @override
  Future<List<SearchResult>> searchDebounced(String query) => search(query);
}
