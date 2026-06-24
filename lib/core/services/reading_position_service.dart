import '../../domain/entities/reading_position.dart';
import '../../domain/repositories/repositories.dart';

/// Auto-saves and restores reading position (continue + recent).
abstract class ReadingPositionService {
  Future<ReadingPosition?> getContinueReading();
  Future<List<ReadingPosition>> getRecentReading({int limit});
  Future<void> savePosition(ReadingPosition position, {bool asContinue = true});
  Future<void> recordVisit(ReadingPosition position);
}

class ReadingPositionServiceImpl implements ReadingPositionService {
  ReadingPositionServiceImpl(this._repository);

  final ReadingHistoryRepository _repository;

  @override
  Future<ReadingPosition?> getContinueReading() =>
      _repository.getContinueReading();

  @override
  Future<List<ReadingPosition>> getRecentReading({int limit = 10}) =>
      _repository.getRecentReading(limit: limit);

  @override
  Future<void> savePosition(
    ReadingPosition position, {
    bool asContinue = true,
  }) async {
    if (asContinue) {
      await _repository.saveContinueReading(position);
    } else {
      await _repository.recordVisit(position);
    }
  }

  @override
  Future<void> recordVisit(ReadingPosition position) =>
      _repository.recordVisit(position);
}
