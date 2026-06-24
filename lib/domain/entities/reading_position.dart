import 'package:equatable/equatable.dart';

/// Saved reading position for continue/recent reading.
class ReadingPosition extends Equatable {
  const ReadingPosition({
    required this.id,
    required this.contentBlockId,
    required this.scrollOffset,
    required this.scrollFraction,
    required this.visitedAt,
    this.charOffset,
    this.isContinueReading = false,
    this.sectionTitle,
  });

  final int id;
  final int contentBlockId;
  final double scrollOffset;
  final double scrollFraction;
  final int? charOffset;
  final DateTime visitedAt;
  final bool isContinueReading;
  final String? sectionTitle;

  @override
  List<Object?> get props => [
        id,
        contentBlockId,
        scrollOffset,
        scrollFraction,
        charOffset,
        visitedAt,
        isContinueReading,
        sectionTitle,
      ];
}
