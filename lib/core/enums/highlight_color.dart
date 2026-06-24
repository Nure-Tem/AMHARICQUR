import 'package:flutter/material.dart';

/// Supported highlight colors. Overlays only — never modifies book text.
enum HighlightColor {
  yellow,
  green,
  blue,
  pink,
  orange;

  String get storageValue => name;

  static HighlightColor fromStorage(String? value) {
    if (value == null) return HighlightColor.yellow;
    return HighlightColor.values.firstWhere(
      (e) => e.name == value,
      orElse: () => HighlightColor.yellow,
    );
  }

  /// Light-mode highlight overlay color (semi-transparent).
  Color get lightOverlay => switch (this) {
        HighlightColor.yellow => const Color(0xFFFFF59D).withValues(alpha: 0.6),
        HighlightColor.green => const Color(0xFFA5D6A7).withValues(alpha: 0.6),
        HighlightColor.blue => const Color(0xFF90CAF9).withValues(alpha: 0.6),
        HighlightColor.pink => const Color(0xFFF48FB1).withValues(alpha: 0.6),
        HighlightColor.orange => const Color(0xFFFFCC80).withValues(alpha: 0.6),
      };

  /// Dark-mode highlight overlay color (semi-transparent).
  Color get darkOverlay => switch (this) {
        HighlightColor.yellow => const Color(0xFFF9A825).withValues(alpha: 0.35),
        HighlightColor.green => const Color(0xFF388E3C).withValues(alpha: 0.35),
        HighlightColor.blue => const Color(0xFF1976D2).withValues(alpha: 0.35),
        HighlightColor.pink => const Color(0xFFC2185B).withValues(alpha: 0.35),
        HighlightColor.orange => const Color(0xFFE65100).withValues(alpha: 0.35),
      };
}
