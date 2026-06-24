import 'package:equatable/equatable.dart';

import '../../core/enums/highlight_color.dart';

/// Text highlight overlay — stores offsets, never modifies book content.
class Highlight extends Equatable {
  const Highlight({
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
  final HighlightColor color;
  final String selectedText;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        contentBlockId,
        charOffsetStart,
        charOffsetEnd,
        color,
        selectedText,
        createdAt,
        updatedAt,
      ];
}
