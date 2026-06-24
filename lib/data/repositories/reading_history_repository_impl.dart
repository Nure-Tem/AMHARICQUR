import '../../../domain/entities/reading_position.dart';
import '../../../domain/repositories/repositories.dart';
import '../datasources/local/daos/reading_history_dao.dart';

class ReadingHistoryRepositoryImpl implements ReadingHistoryRepository {
  ReadingHistoryRepositoryImpl(this._dao);

  final ReadingHistoryDao _dao;

  @override
  Future<ReadingPosition?> getContinueReading() => _dao.getContinueReading();

  @override
  Future<List<ReadingPosition>> getRecentReading({int limit = 10}) =>
      _dao.getRecent(limit: limit);

  @override
  Future<void> saveContinueReading(ReadingPosition position) =>
      _dao.saveContinueReading(position);

  @override
  Future<void> recordVisit(ReadingPosition position) =>
      _dao.addRecentVisit(position);
}
