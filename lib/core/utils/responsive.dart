import 'package:flutter/material.dart';

/// Responsive layout helpers for consistent scaling across devices.
/// Use for padding, font sizes, and breakpoints (phone vs tablet).
class Responsive {
  Responsive._();

  /// Breakpoint for tablet layout (dual-pane, larger typography).
  static const double tabletBreakpoint = 600;

  /// Small phone width threshold.
  static const double smallPhoneWidth = 360;

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  }

  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).width < smallPhoneWidth;
  }

  /// Scale [value] by screen width relative to 360 logical px.
  static double scaleWidth(BuildContext context, double value) {
    final w = MediaQuery.sizeOf(context).width;
    return value * (w / 360).clamp(0.8, 1.4);
  }

  /// Scale [value] by screen height relative to 800 logical px.
  static double scaleHeight(BuildContext context, double value) {
    final h = MediaQuery.sizeOf(context).height;
    return value * (h / 800).clamp(0.8, 1.3);
  }

  /// Responsive horizontal padding (larger on tablet).
  static EdgeInsets paddingHorizontal(BuildContext context, {double phone = 20, double? tablet}) {
    final t = tablet ?? phone * 1.5;
    return EdgeInsets.symmetric(
      horizontal: isTablet(context) ? t : phone,
    );
  }

  /// Responsive font size (slightly larger on tablet).
  static double fontSize(BuildContext context, double base, {double tabletScale = 1.1}) {
    return isTablet(context) ? base * tabletScale : base;
  }
}
