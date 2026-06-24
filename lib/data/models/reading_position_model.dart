import '../../domain/entities/reading_position.dart';

class ReadingPositionModel {
  const ReadingPositionModel({
    required this.id,
    required this.contentBlockId,
    required this.scrollOffset,
    required this.scrollFraction,
    required this.visitedAt,
    this.charOffset,
    this.isContinueReading = 0,
    this.sectionTitle,
  });

  final int id;
  final int contentBlockId;
  final double scrollOffset;
  final double scrollFraction;
  final int? charOffset;
  final int visitedAt;
  final int isContinueReading;
  final String? sectionTitle;

  factory ReadingPositionModel.fromMap(Map<String, Object?> map) {
    return ReadingPositionModel(
      id: map['id']! as int,
      contentBlockId: map['content_block_id']! as int,
      scrollOffset: (map['scroll_offset'] as num).toDouble(),
      scrollFraction: (map['scroll_fraction'] as num).toDouble(),
      charOffset: map['char_offset'] as int?,
      visitedAt: map['visited_at']! as int,
      isContinueReading: map['is_continue_reading'] as int? ?? 0,
      sectionTitle: map['section_title'] as String?,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'content_block_id': contentBlockId,
        'scroll_offset': scrollOffset,
        'scroll_fraction': scrollFraction,
        'char_offset': charOffset,
        'visited_at': visitedAt,
        'is_continue_reading': isContinueReading,
        'section_title': sectionTitle,
      };

  ReadingPosition toEntity() => ReadingPosition(
        id: id,
        contentBlockId: contentBlockId,
        scrollOffset: scrollOffset,
        scrollFraction: scrollFraction,
        charOffset: charOffset,
        visitedAt: DateTime.fromMillisecondsSinceEpoch(visitedAt),
        isContinueReading: isContinueReading == 1,
        sectionTitle: sectionTitle,
      );

  factory ReadingPositionModel.fromEntity(ReadingPosition entity) =>
      ReadingPositionModel(
        id: entity.id,
        contentBlockId: entity.contentBlockId,
        scrollOffset: entity.scrollOffset,
        scrollFraction: entity.scrollFraction,
        charOffset: entity.charOffset,
        visitedAt: entity.visitedAt.millisecondsSinceEpoch,
        isContinueReading: entity.isContinueReading ? 1 : 0,
        sectionTitle: entity.sectionTitle,
      );
}
