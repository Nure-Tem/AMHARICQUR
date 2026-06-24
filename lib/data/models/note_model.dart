import '../../domain/entities/note.dart';

class NoteModel {
  const NoteModel({
    required this.id,
    required this.contentBlockId,
    required this.noteText,
    required this.createdAt,
    required this.updatedAt,
    this.highlightId,
    this.charOffsetStart,
    this.charOffsetEnd,
  });

  final String id;
  final String? highlightId;
  final int contentBlockId;
  final int? charOffsetStart;
  final int? charOffsetEnd;
  final String noteText;
  final int createdAt;
  final int updatedAt;

  factory NoteModel.fromMap(Map<String, Object?> map) {
    return NoteModel(
      id: map['id']! as String,
      highlightId: map['highlight_id'] as String?,
      contentBlockId: map['content_block_id']! as int,
      charOffsetStart: map['char_offset_start'] as int?,
      charOffsetEnd: map['char_offset_end'] as int?,
      noteText: map['note_text']! as String,
      createdAt: map['created_at']! as int,
      updatedAt: map['updated_at']! as int,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'highlight_id': highlightId,
        'content_block_id': contentBlockId,
        'char_offset_start': charOffsetStart,
        'char_offset_end': charOffsetEnd,
        'note_text': noteText,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  Note toEntity() => Note(
        id: id,
        highlightId: highlightId,
        contentBlockId: contentBlockId,
        charOffsetStart: charOffsetStart,
        charOffsetEnd: charOffsetEnd,
        noteText: noteText,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      );

  factory NoteModel.fromEntity(Note entity) => NoteModel(
        id: entity.id,
        highlightId: entity.highlightId,
        contentBlockId: entity.contentBlockId,
        charOffsetStart: entity.charOffsetStart,
        charOffsetEnd: entity.charOffsetEnd,
        noteText: entity.noteText,
        createdAt: entity.createdAt.millisecondsSinceEpoch,
        updatedAt: entity.updatedAt.millisecondsSinceEpoch,
      );
}
