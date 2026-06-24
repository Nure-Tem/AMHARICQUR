import 'package:equatable/equatable.dart';

/// User bookmark anchored to a content block.
class Bookmark extends Equatable {
  const Bookmark({
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? charOffset;
  final String? previewText;

  @override
  List<Object?> get props => [
        id,
        contentBlockId,
        customName,
        createdAt,
        updatedAt,
        charOffset,
        previewText,
      ];
}
