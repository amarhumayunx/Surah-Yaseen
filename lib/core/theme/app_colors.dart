import 'package:flutter/material.dart';

/// Application-wide color palette.
/// Centralizes theme colors for consistency and easy maintenance.
class AppColors {
  AppColors._();

  // Primary palette (PascalCase kept for backward compatibility with existing code)
  // ignore: non_constant_identifier_names
  static Color get PrimaryColor => const Color(0xFF64AE90);
  static Color get LoadingScreenBackgroundColor => const Color(0xFF227653);
  // ignore: non_constant_identifier_names
  static Color get SecondaryColor => const Color(0xFFFFFFFF);
  // ignore: non_constant_identifier_names
  static Color get BarColor => const Color(0xFFCCA90D);
  // ignore: non_constant_identifier_names
  static Color get HeadingColor => const Color(0xFF227653);
  static Color get fontColor => const Color(0xFF88B7A4);
  static Color get lightColor => const Color(0xFFAAD2C4);
  static Color get lightColorSec => const Color(0xFFE5F0E7);
  static Color get blackColor => Colors.black;
  static Color get whiteColor => const Color(0xFF86C1A9);
  static Color get darkgreenColor => const Color(0xFF227653);
  static Color get lightColorapp => const Color(0xFFE9F7F1);
  static Color get colorone => const Color(0xFF4CAF87);
  static Color get primaryGreen => const Color(0xFF4A6D51);
  static Color get lightBeige => const Color(0xFFD9D58E);
  static Color get errorRed => Colors.red;
  static Color get textGray => const Color(0xFF616161);
  static Color get textWhite => Colors.white;
  // ignore: non_constant_identifier_names
  static Color get AudioPlayerInActiveColor => const Color(0xFFCFC378);
  // ignore: non_constant_identifier_names
  static Color get BookmarktextColor => const Color(0xFF227653);
  // ignore: non_constant_identifier_names
  static Color get OnbaordingScreenDotColor => const Color(0xFF90BAA9);

  /// Bookmark verse highlight (soft greenish)
  static Color get bookmarkHighlightColor => const Color(0xFFF6FAF7);

  /// Bookmark verse border
  static Color get bookmarkBorderColor => const Color(0xFFCCE7D5);
}
