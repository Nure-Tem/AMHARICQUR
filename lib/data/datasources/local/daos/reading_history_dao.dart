import '../../../../core/constants/database_tables.dart';
import '../../../../domain/entities/reading_position.dart';
import '../../../models/reading_position_model.dart';
import '../database/app_database.dart';

abstract class ReadingHistoryDao {
  Future<ReadingPosition?> getContinueReading();
  Future<List<ReadingPosition>> getRecent({int limit = 10});
  Future<void> saveContinueReading(ReadingPosition position);
  Future<void> addRecentVisit(ReadingPosition position);
  Future<void> clearContinueReading();
}

class ReadingHistoryDaoImpl implements ReadingHistoryDao {
  ReadingHistoryDaoImpl(this._database);

  final AppDatabase _database;

  @override
  Future<ReadingPosition?> getContinueReading() async {
    final rows = await _database.db.query(
      DatabaseTables.readingHistory,
      where: 'is_continue_reading = 1',
      orderBy: 'visited_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ReadingPositionModel.fromMap(rows.first).toEntity();
  }

  @override
  Future<List<ReadingPosition>> getRecent({int limit = 10}) async {
    final rows = await _database.db.query(
      DatabaseTables.readingHistory,
      where: 'is_continue_reading = 0',
      orderBy: 'visited_at DESC',
      limit: limit,
    );
    return rows.map((r) => ReadingPositionModel.fromMap(r).toEntity()).toList();
  }

  @override
  Future<void> saveContinueReading(ReadingPosition position) async {
    final db = _database.db;
    await db.transaction((txn) async {
      await txn.update(
        DatabaseTables.readingHistory,
        {'is_continue_reading': 0},
        where: 'is_continue_reading = 1',
      );

      final model = ReadingPositionModel.fromEntity(
        ReadingPosition(
          id: position.id,
          contentBlockId: position.contentBlockId,
          scrollOffset: position.scrollOffset,
          scrollFraction: position.scrollFraction,
          charOffset: position.charOffset,
          visitedAt: position.visitedAt,
          isContinueReading: true,
          sectionTitle: position.sectionTitle,
        ),
      );

      if (position.id == 0) {
        await txn.insert(DatabaseTables.readingHistory, {
          ...model.toMap()..remove('id'),
          'is_continue_reading': 1,
        });
      } else {
        await txn.update(
          DatabaseTables.readingHistory,
          {...model.toMap(), 'is_continue_reading': 1},
          where: 'id = ?',
          whereArgs: [position.id],
        );
      }
    });
  }

  @override
  Future<void> addRecentVisit(ReadingPosition position) async {
    final model = ReadingPositionModel.fromEntity(
      ReadingPosition(
        id: position.id,
        contentBlockId: position.contentBlockId,
        scrollOffset: position.scrollOffset,
        scrollFraction: position.scrollFraction,
        charOffset: position.charOffset,
        visitedAt: position.visitedAt,
        isContinueReading: false,
        sectionTitle: position.sectionTitle,
      ),
    );
    await _database.db.insert(
      DatabaseTables.readingHistory,
      model.toMap()..remove('id'),
    );
  }

  @override
  Future<void> clearContinueReading() async {
    await _database.db.update(
      DatabaseTables.readingHistory,
      {'is_continue_reading': 0},
      where: 'is_continue_reading = 1',
    );
  }
}
