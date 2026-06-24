import 'package:equatable/equatable.dart';

import '../../core/enums/content_block_type.dart';
import '../../core/enums/text_direction_hint.dart';

/// Immutable styling metadata for a content block (colors, fonts, layout).
class ContentStyle extends Equatable {
  const ContentStyle({
    this.textColorArgb,
    this.backgroundColorArgb,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.lineHeight,
    this.marginTop,
    this.marginBottom,
    this.paddingHorizontal,
    this.isDecorative = false,
    this.decorativeAsset,
    this.textDirection = TextDirectionHint.auto,
  });

  final int? textColorArgb;
  final int? backgroundColorArgb;
  final String? fontFamily;
  final double? fontSize;
  final int? fontWeight;
  final String? textAlign;
  final double? lineHeight;
  final double? marginTop;
  final double? marginBottom;
  final double? paddingHorizontal;
  final bool isDecorative;
  final String? decorativeAsset;
  final TextDirectionHint textDirection;

  @override
  List<Object?> get props => [
        textColorArgb,
        backgroundColorArgb,
        fontFamily,
        fontSize,
        fontWeight,
        textAlign,
        lineHeight,
        marginTop,
        marginBottom,
        paddingHorizontal,
        isDecorative,
        decorativeAsset,
        textDirection,
      ];
}

/// A single immutable block of structured book content.
class ContentBlock extends Equatable {
  const ContentBlock({
    required this.id,
    this.parentId,
    required this.type,
    required this.sortOrder,
    this.level,
    this.textAr,
    this.textAm,
    this.style = const ContentStyle(),
    this.metadata = const {},
  });

  final int id;
  final int? parentId;
  final ContentBlockType type;
  final int sortOrder;
  final int? level;
  final String? textAr;
  final String? textAm;
  final ContentStyle style;
  final Map<String, dynamic> metadata;

  /// Primary display text based on block type.
  String? get primaryText {
    if (textAr != null && textAr!.isNotEmpty) return textAr;
    return textAm;
  }

  bool get isHeading =>
      type == ContentBlockType.bookTitle ||
      type == ContentBlockType.surahTitle ||
      type == ContentBlockType.sectionHeading ||
      type == ContentBlockType.subHeading;

  @override
  List<Object?> get props => [
        id,
        parentId,
        type,
        sortOrder,
        level,
        textAr,
        textAm,
        style,
        metadata,
      ];
}

/// Table of contents node (hierarchical navigation entry).
class TocEntry extends Equatable {
  const TocEntry({
    required this.contentBlockId,
    required this.title,
    required this.sortOrder,
    required this.level,
    this.children = const [],
  });

  final int contentBlockId;
  final String title;
  final int sortOrder;
  final int level;
  final List<TocEntry> children;

  @override
  List<Object?> get props => [contentBlockId, title, sortOrder, level, children];
}

/// Search result pointing to a content location.
class SearchResult extends Equatable {
  const SearchResult({
    required this.contentBlockId,
    required this.snippet,
    required this.sortOrder,
    this.matchField,
    this.rank,
  });

  final int contentBlockId;
  final String snippet;
  final int sortOrder;
  final String? matchField;
  final double? rank;

  @override
  List<Object?> get props => [contentBlockId, snippet, sortOrder, matchField, rank];
}
