import 'package:sqflite/sqflite.dart';

import '../../../../domain/entities/book_content.dart';
import '../../../models/content_block_model.dart';
import '../database/app_database.dart';

/// Data access for immutable book content blocks.
/// 
/// Adapts parser-generated schema (content_blocks + paragraphs) to domain entities.
abstract class BookContentDao {
  Future<ContentBlock?> getById(int id);
  Future<List<ContentBlock>> getRange({
    required int startSortOrder,
    required int limit,
  });
  Future<List<ContentBlock>> getByIds(List<int> ids);
  Future<int> getTotalBlockCount();
  Future<int?> getMinSortOrder();
  Future<List<TocEntry>> getTocEntries();
}

class BookContentDaoImpl implements BookContentDao {
  BookContentDaoImpl(this._database);

  final AppDatabase _database;

  @override
  Future<ContentBlock?> getById(int id) async {
    // Join content_blocks with paragraphs to get complete content
    final rows = await _database.db.rawQuery('''
      SELECT 
        cb.id, cb.page_id, cb.section_id, cb.type, cb.sort_order,
        cb.style_json, cb.metadata_json,
        GROUP_CONCAT(CASE WHEN p.language = 'ar' THEN p.text END, ' ') as text_ar,
        GROUP_CONCAT(CASE WHEN p.language = 'am' THEN p.text END, ' ') as text_am
      FROM content_blocks cb
      LEFT JOIN paragraphs p ON p.content_block_id = cb.id
      WHERE cb.id = ?
      GROUP BY cb.id
      LIMIT 1
    ''', [id]);
    
    if (rows.isEmpty) return null;
    return ContentBlockModel.fromMap(rows.first).toEntity();
  }

  @override
  Future<List<ContentBlock>> getRange({
    required int startSortOrder,
    required int limit,
  }) async {
    // Get blocks with their aggregated text from paragraphs
    final rows = await _database.db.rawQuery('''
      SELECT 
        cb.id, cb.page_id, cb.section_id, cb.type, cb.sort_order,
        cb.style_json, cb.metadata_json,
        GROUP_CONCAT(CASE WHEN p.language = 'ar' THEN p.text END, ' ') as text_ar,
        GROUP_CONCAT(CASE WHEN p.language = 'am' THEN p.text END, ' ') as text_am
      FROM content_blocks cb
      LEFT JOIN paragraphs p ON p.content_block_id = cb.id
      WHERE cb.sort_order >= ?
      GROUP BY cb.id
      ORDER BY cb.sort_order ASC
      LIMIT ?
    ''', [startSortOrder, limit]);
    
    return rows.map((r) => ContentBlockModel.fromMap(r).toEntity()).toList();
  }

  @override
  Future<List<ContentBlock>> getByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final placeholders = List.filled(ids.length, '?').join(',');
    final rows = await _database.db.rawQuery('''
      SELECT 
        cb.id, cb.page_id, cb.section_id, cb.type, cb.sort_order,
        cb.style_json, cb.metadata_json,
        GROUP_CONCAT(CASE WHEN p.language = 'ar' THEN p.text END, ' ') as text_ar,
        GROUP_CONCAT(CASE WHEN p.language = 'am' THEN p.text END, ' ') as text_am
      FROM content_blocks cb
      LEFT JOIN paragraphs p ON p.content_block_id = cb.id
      WHERE cb.id IN ($placeholders)
      GROUP BY cb.id
      ORDER BY cb.sort_order ASC
    ''', ids);
    
    return rows.map((r) => ContentBlockModel.fromMap(r).toEntity()).toList();
  }

  @override
  Future<int> getTotalBlockCount() async {
    final result = await _database.db.rawQuery(
      'SELECT COUNT(*) AS count FROM content_blocks',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<int?> getMinSortOrder() async {
    final result = await _database.db.rawQuery(
      'SELECT MIN(sort_order) AS min_order FROM content_blocks',
    );
    return Sqflite.firstIntValue(result);
  }

  @override
  Future<List<TocEntry>> getTocEntries() async {
    // Get heading-type blocks for table of contents
    final rows = await _database.db.rawQuery('''
      SELECT 
        cb.id, cb.type, cb.sort_order,
        GROUP_CONCAT(CASE WHEN p.language = 'ar' THEN p.text END, ' ') as text_ar,
        GROUP_CONCAT(CASE WHEN p.language = 'am' THEN p.text END, ' ') as text_am
      FROM content_blocks cb
      LEFT JOIN paragraphs p ON p.content_block_id = cb.id
      WHERE cb.type IN ('surahTitle', 'chapterTitle', 'heading')
      GROUP BY cb.id
      ORDER BY cb.sort_order ASC
    ''');

    return rows.map((row) {
      final textAr = row['text_ar'] as String?;
      final textAm = row['text_am'] as String?;
      final title = textAm ?? textAr ?? 'Untitled';
      
      return TocEntry(
        contentBlockId: row['id']! as int,
        title: title,
        sortOrder: row['sort_order']! as int,
        level: 1, // Parser doesn't set level, default to 1
      );
    }).toList();
  }
}
