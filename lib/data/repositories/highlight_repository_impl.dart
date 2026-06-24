import '../../../domain/entities/highlight.dart';
import '../../../domain/repositories/repositories.dart';
import '../datasources/local/daos/highlight_dao.dart';

class HighlightRepositoryImpl implements HighlightRepository {
  HighlightRepositoryImpl(this._dao);

  final HighlightDao _dao;

  @override
  Future<List<Highlight>> getAll() => _dao.getAll();

  @override
  Future<List<Highlight>> getByContentBlockId(int contentBlockId) =>
      _dao.getByContentBlockId(contentBlockId);

  @override
  Future<void> add(Highlight highlight) => _dao.insert(highlight);

  @override
  Future<void> update(Highlight highlight) => _dao.update(highlight);

  @override
  Future<void> delete(String id) => _dao.delete(id);
}
