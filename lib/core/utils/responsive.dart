import 'package:flutter/material.dart';

/// Responsive layout breakpoints for reader and home screens.
abstract final class ResponsiveBreakpoints {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;
}

/// Returns horizontal padding based on screen width.
double responsiveHorizontalPadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= ResponsiveBreakpoints.expanded) return 48;
  if (width >= ResponsiveBreakpoints.medium) return 32;
  if (width >= ResponsiveBreakpoints.compact) return 24;
  return 16;
}

/// Max content width for comfortable reading on tablets.
double readerMaxContentWidth(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= ResponsiveBreakpoints.expanded) return 720;
  if (width >= ResponsiveBreakpoints.medium) return 640;
  return width;
}
