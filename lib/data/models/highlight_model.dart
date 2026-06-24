import '../../core/enums/highlight_color.dart';
import '../../domain/entities/highlight.dart';

class HighlightModel {
  const HighlightModel({
    required this.id,
    required this.contentBlockId,
    required this.charOffsetStart,
    required this.charOffsetEnd,
    required this.color,
    required this.selectedText,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final int contentBlockId;
  final int charOffsetStart;
  final int charOffsetEnd;
  final String color;
  final String selectedText;
  final int createdAt;
  final int updatedAt;

  factory HighlightModel.fromMap(Map<String, Object?> map) {
    return HighlightModel(
      id: map['id']! as String,
      contentBlockId: map['content_block_id']! as int,
      charOffsetStart: map['char_offset_start']! as int,
      charOffsetEnd: map['char_offset_end']! as int,
      color: map['color']! as String,
      selectedText: map['selected_text']! as String,
      createdAt: map['created_at']! as int,
      updatedAt: map['updated_at']! as int,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'content_block_id': contentBlockId,
        'char_offset_start': charOffsetStart,
        'char_offset_end': charOffsetEnd,
        'color': color,
        'selected_text': selectedText,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  Highlight toEntity() => Highlight(
        id: id,
        contentBlockId: contentBlockId,
        charOffsetStart: charOffsetStart,
        charOffsetEnd: charOffsetEnd,
        color: HighlightColor.fromStorage(color),
        selectedText: selectedText,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      );

  factory HighlightModel.fromEntity(Highlight entity) => HighlightModel(
        id: entity.id,
        contentBlockId: entity.contentBlockId,
        charOffsetStart: entity.charOffsetStart,
        charOffsetEnd: entity.charOffsetEnd,
        color: entity.color.storageValue,
        selectedText: entity.selectedText,
        createdAt: entity.createdAt.millisecondsSinceEpoch,
        updatedAt: entity.updatedAt.millisecondsSinceEpoch,
      );
}
