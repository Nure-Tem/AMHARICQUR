import 'package:equatable/equatable.dart';

/// Personal note attached to a highlight or content location.
class Note extends Equatable {
  const Note({
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
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        highlightId,
        contentBlockId,
        charOffsetStart,
        charOffsetEnd,
        noteText,
        createdAt,
        updatedAt,
      ];
}
