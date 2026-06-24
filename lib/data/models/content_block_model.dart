import 'dart:convert';

import '../../core/enums/content_block_type.dart';
import '../../core/enums/text_direction_hint.dart';
import '../../domain/entities/book_content.dart';

/// SQLite row model for parser-generated [content_blocks] table.
/// Aggregates text from [paragraphs] join.
class ContentBlockModel {
  const ContentBlockModel({
    required this.id,
    this.pageId,
    this.sectionId,
    required this.type,
    required this.sortOrder,
    this.level,
    this.textAr,
    this.textAm,
    this.styleJson,
    this.metadataJson,
  });

  final int id;
  final int? pageId;
  final int? sectionId;
  final String type;
  final int sortOrder;
  final int? level;
  final String? textAr;
  final String? textAm;
  final String? styleJson;
  final String? metadataJson;

  factory ContentBlockModel.fromMap(Map<String, Object?> map) {
    return ContentBlockModel(
      id: map['id']! as int,
      pageId: map['page_id'] as int?,
      sectionId: map['section_id'] as int?,
      type: map['type']! as String,
      sortOrder: map['sort_order']! as int,
      level: map['level'] as int?,
      textAr: map['text_ar'] as String?,
      textAm: map['text_am'] as String?,
      styleJson: map['style_json'] as String?,
      metadataJson: map['metadata_json'] as String?,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'page_id': pageId,
        'section_id': sectionId,
        'type': type,
        'sort_order': sortOrder,
        'level': level,
        'text_ar': textAr,
        'text_am': textAm,
        'style_json': styleJson,
        'metadata_json': metadataJson,
      };

  ContentBlock toEntity() {
    final styleMap = styleJson != null
        ? jsonDecode(styleJson!) as Map<String, dynamic>
        : <String, dynamic>{};
    final metaMap = metadataJson != null
        ? jsonDecode(metadataJson!) as Map<String, dynamic>
        : <String, dynamic>{};

    // Parse color from hex string (parser uses "#RRGGBB" format)
    int? parseColor(String? hexColor) {
      if (hexColor == null || hexColor.isEmpty) return null;
      final hex = hexColor.replaceFirst('#', '');
      if (hex.length == 6) {
        return int.parse('FF$hex', radix: 16); // Add alpha channel
      }
      return null;
    }

    // Detect text direction from content
    TextDirectionHint detectDirection() {
      if (type == 'verse_arabic' || type == 'arabicVerse') {
        return TextDirectionHint.rtl;
      }
      if (textAr != null && textAr!.isNotEmpty) {
        return TextDirectionHint.rtl;
      }
      return TextDirectionHint.ltr;
    }

    return ContentBlock(
      id: id,
      parentId: sectionId, // Use section as parent
      type: _mapContentType(type),
      sortOrder: sortOrder,
      level: level,
      textAr: textAr,
      textAm: textAm,
      style: ContentStyle(
        textColorArgb: parseColor(styleMap['text_color'] as String?),
        backgroundColorArgb: parseColor(styleMap['background_color'] as String?),
        fontFamily: styleMap['font_family'] as String?,
        fontSize: (styleMap['font_size'] as num?)?.toDouble(),
        fontWeight: styleMap['font_weight'] as int?,
        textAlign: styleMap['alignment'] as String?, // Parser uses "alignment"
        lineHeight: (styleMap['line_height'] as num?)?.toDouble(),
        marginTop: (styleMap['margin_top'] as num?)?.toDouble(),
        marginBottom: (styleMap['margin_bottom'] as num?)?.toDouble(),
        paddingHorizontal: (styleMap['padding_horizontal'] as num?)?.toDouble(),
        isDecorative: styleMap['is_decorative'] as bool? ?? false,
        decorativeAsset: styleMap['decorative_asset'] as String?,
        textDirection: detectDirection(),
      ),
      metadata: metaMap,
    );
  }

  /// Maps parser block types to app ContentBlockType enum.
  static ContentBlockType _mapContentType(String parserType) {
    switch (parserType) {
      case 'bookTitle':
        return ContentBlockType.bookTitle;
      case 'surahTitle':
        return ContentBlockType.surahTitle;
      case 'chapterTitle':
        return ContentBlockType.sectionHeading;
      case 'heading':
        return ContentBlockType.subHeading;
      case 'verse_arabic':
        return ContentBlockType.arabicVerse;
      case 'translation_amharic':
        return ContentBlockType.amharicTranslation;
      case 'tafsir':
        return ContentBlockType.tafsir;
      case 'paragraph':
        return ContentBlockType.tafsir; // Generic paragraphs treated as tafsir
      case 'list_item':
        return ContentBlockType.tafsir;
      default:
        return ContentBlockType.unknown;
    }
  }
}
