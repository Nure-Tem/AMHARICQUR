import 'package:flutter/material.dart';

import '../../core/enums/content_block_type.dart';
import '../../core/enums/text_direction_hint.dart';
import '../../domain/entities/book_content.dart';

/// Renders a single content block with proper typography and styling.
/// 
/// Preserves exact text, reading order, typography, spacing, colors, and alignment
/// from the parser-generated structured data.
class ContentBlockWidget extends StatelessWidget {
  const ContentBlockWidget({
    super.key,
    required this.block,
    this.onTap,
    this.onLongPress,
  });

  final ContentBlock block;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final style = block.style;

    // Build text widgets for Arabic and Amharic
    final List<Widget> children = [];

    if (block.textAr != null && block.textAr!.isNotEmpty) {
      children.add(_buildText(
        context,
        block.textAr!,
        textDirection: TextDirection.rtl,
        style: style,
        isArabic: true,
      ));
    }

    if (block.textAm != null && block.textAm!.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: 8));
      }
      children.add(_buildText(
        context,
        block.textAm!,
        textDirection: TextDirection.ltr,
        style: style,
        isArabic: false,
      ));
    }

    // Apply block-level styling
    Widget content = Column(
      crossAxisAlignment: _getCrossAxisAlignment(style.textAlign),
      children: children,
    );

    // Apply margins
    content = Padding(
      padding: EdgeInsets.only(
        top: style.marginTop ?? _getDefaultMarginTop(block.type),
        bottom: style.marginBottom ?? _getDefaultMarginBottom(block.type),
        left: style.paddingHorizontal ?? 16,
        right: style.paddingHorizontal ?? 16,
      ),
      child: content,
    );

    // Handle decorative blocks
    if (style.isDecorative) {
      content = _buildDecorativeBlock(content);
    }

    // Make tappable
    if (onTap != null || onLongPress != null) {
      content = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: content,
      );
    }

    return RepaintBoundary(child: content);
  }

  Widget _buildText(
    BuildContext context,
    String text,
    {
    required TextDirection textDirection,
    required ContentStyle style,
    required bool isArabic,
  }) {
    final theme = Theme.of(context);
    
    // Determine font size
    final baseFontSize = style.fontSize ?? _getDefaultFontSize(block.type);
    
    // Determine font family
    final fontFamily = style.fontFamily ?? (isArabic ? 'Noto Naskh Arabic' : 'Noto Sans');
    
    // Determine font weight
    final fontWeight = style.fontWeight != null
        ? FontWeight.values[style.fontWeight! ~/ 100 - 1]
        : _getDefaultFontWeight(block.type);
    
    // Determine text color
    final textColor = style.textColorArgb != null
        ? Color(style.textColorArgb!)
        : theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Directionality(
      textDirection: textDirection,
      child: Text(
        text,
        textAlign: _getTextAlign(style.textAlign),
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: baseFontSize,
          fontWeight: fontWeight,
          color: textColor,
          height: style.lineHeight ?? 1.6,
        ),
      ),
    );
  }

  Widget _buildDecorativeBlock(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: child,
    );
  }

  TextDirection _getTextDirection(TextDirectionHint hint, ContentBlockType type) {
    switch (hint) {
      case TextDirectionHint.rtl:
        return TextDirection.rtl;
      case TextDirectionHint.ltr:
        return TextDirection.ltr;
      case TextDirectionHint.auto:
        // Auto-detect based on block type
        if (type == ContentBlockType.arabicVerse || type == ContentBlockType.arabicText) {
          return TextDirection.rtl;
        }
        return TextDirection.ltr;
    }
  }

  TextAlign _getTextAlign(String? align) {
    switch (align?.toLowerCase()) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'left':
        return TextAlign.left;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.start;
    }
  }

  CrossAxisAlignment _getCrossAxisAlignment(String? align) {
    switch (align?.toLowerCase()) {
      case 'center':
        return CrossAxisAlignment.center;
      case 'right':
        return CrossAxisAlignment.end;
      case 'left':
        return CrossAxisAlignment.start;
      default:
        return CrossAxisAlignment.stretch;
    }
  }

  double _getDefaultFontSize(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.bookTitle:
        return 28.0;
      case ContentBlockType.surahTitle:
        return 24.0;
      case ContentBlockType.sectionHeading:
        return 20.0;
      case ContentBlockType.subHeading:
        return 18.0;
      case ContentBlockType.arabicVerse:
        return 20.0;
      case ContentBlockType.arabicText:
        return 18.0;
      case ContentBlockType.amharicTranslation:
        return 16.0;
      case ContentBlockType.tafsir:
        return 14.0;
      default:
        return 14.0;
    }
  }

  FontWeight _getDefaultFontWeight(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.bookTitle:
      case ContentBlockType.surahTitle:
      case ContentBlockType.sectionHeading:
        return FontWeight.bold;
      case ContentBlockType.subHeading:
        return FontWeight.w600;
      case ContentBlockType.arabicVerse:
        return FontWeight.w500;
      default:
        return FontWeight.normal;
    }
  }

  double _getDefaultMarginTop(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.bookTitle:
        return 32.0;
      case ContentBlockType.surahTitle:
        return 24.0;
      case ContentBlockType.sectionHeading:
        return 20.0;
      case ContentBlockType.subHeading:
        return 16.0;
      case ContentBlockType.arabicVerse:
        return 12.0;
      default:
        return 8.0;
    }
  }

  double _getDefaultMarginBottom(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.bookTitle:
        return 16.0;
      case ContentBlockType.surahTitle:
        return 12.0;
      case ContentBlockType.sectionHeading:
        return 12.0;
      case ContentBlockType.subHeading:
        return 8.0;
      default:
        return 8.0;
    }
  }
}
