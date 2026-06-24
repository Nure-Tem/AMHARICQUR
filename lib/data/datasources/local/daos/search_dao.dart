import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/database_tables.dart';
import '../../../../domain/entities/book_content.dart';
import '../database/app_database.dart';

abstract class SearchDao {
  Future<List<SearchResult>> search(String query, {int? limit});
}

class SearchDaoImpl implements SearchDao {
  SearchDaoImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<SearchResult>> search(String query, {int? limit}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final effectiveLimit = limit ?? AppConstants.searchResultLimit;
    final ftsQuery = _buildFtsQuery(trimmed);

    // Search in FTS5 table and join with content_blocks
    final rows = await _database.db.rawQuery('''
      SELECT
        cb.id AS content_block_id,
        cb.sort_order AS sort_order,
        COALESCE(
          snippet(${DatabaseTables.bookContentFts}, 2, '<mark>', '</mark>', '...', 48),
          snippet(${DatabaseTables.bookContentFts}, 3, '<mark>', '</mark>', '...', 48),
          ''
        ) AS snippet,
        bm25(${DatabaseTables.bookContentFts}) AS rank
      FROM ${DatabaseTables.bookContentFts}
      JOIN content_blocks cb
        ON cb.id = ${DatabaseTables.bookContentFts}.content_id
      WHERE ${DatabaseTables.bookContentFts} MATCH ?
      ORDER BY rank
      LIMIT ?
    ''', [ftsQuery, effectiveLimit]);

    return rows.map((row) {
      return SearchResult(
        contentBlockId: row['content_block_id']! as int,
        snippet: row['snippet'] as String? ?? '',
        sortOrder: row['sort_order']! as int,
        rank: (row['rank'] as num?)?.toDouble(),
      );
    }).toList();
  }

  /// Wraps query terms for FTS5 prefix matching on Arabic/Amharic text.
  String _buildFtsQuery(String query) {
    final terms = query
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map((t) => '"${t.replaceAll('"', '""')}"*')
        .join(' ');
    return terms;
  }
}
