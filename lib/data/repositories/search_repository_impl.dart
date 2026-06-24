import '../../../domain/entities/book_content.dart';
import '../../../domain/repositories/repositories.dart';
import '../datasources/local/daos/search_dao.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._dao);

  final SearchDao _dao;

  @override
  Future<List<SearchResult>> search(String query, {int? limit}) =>
      _dao.search(query, limit: limit);
}
