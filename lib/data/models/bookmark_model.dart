import '../../domain/entities/bookmark.dart';

class BookmarkModel {
  const BookmarkModel({
    required this.id,
    required this.contentBlockId,
    required this.customName,
    required this.createdAt,
    required this.updatedAt,
    this.charOffset,
    this.previewText,
  });

  final String id;
  final int contentBlockId;
  final String customName;
  final int createdAt;
  final int updatedAt;
  final int? charOffset;
  final String? previewText;

  factory BookmarkModel.fromMap(Map<String, Object?> map) {
    return BookmarkModel(
      id: map['id']! as String,
      contentBlockId: map['content_block_id']! as int,
      customName: map['custom_name']! as String,
      createdAt: map['created_at']! as int,
      updatedAt: map['updated_at']! as int,
      charOffset: map['char_offset'] as int?,
      previewText: map['preview_text'] as String?,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'content_block_id': contentBlockId,
        'custom_name': customName,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'char_offset': charOffset,
        'preview_text': previewText,
      };

  Bookmark toEntity() => Bookmark(
        id: id,
        contentBlockId: contentBlockId,
        customName: customName,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
        charOffset: charOffset,
        previewText: previewText,
      );

  factory BookmarkModel.fromEntity(Bookmark entity) => BookmarkModel(
        id: entity.id,
        contentBlockId: entity.contentBlockId,
        customName: entity.customName,
        createdAt: entity.createdAt.millisecondsSinceEpoch,
        updatedAt: entity.updatedAt.millisecondsSinceEpoch,
        charOffset: entity.charOffset,
        previewText: entity.previewText,
      );
}
