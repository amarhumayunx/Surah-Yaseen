import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Application theme configuration.
/// Ensures consistent scaffold background to prevent black flashes during navigation.
class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
        primarySwatch: Colors.green,
        primaryColor: AppColors.PrimaryColor,
        scaffoldBackgroundColor: AppColors.lightColorSec,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.light(
          primary: AppColors.PrimaryColor,
          secondary: AppColors.BarColor,
          surface: AppColors.lightColorSec,
          error: AppColors.errorRed,
          onPrimary: AppColors.textWhite,
          onSecondary: AppColors.textWhite,
          onSurface: AppColors.HeadingColor,
          onError: AppColors.textWhite,
        ),
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.merriweather(),
          bodyMedium: GoogleFonts.merriweather(),
          bodySmall: GoogleFonts.merriweather(),
          titleLarge: GoogleFonts.merriweather(fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.merriweather(),
          titleSmall: GoogleFonts.merriweather(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.PrimaryColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.PrimaryColor,
            foregroundColor: AppColors.textWhite,
            elevation: 0,
          ),
        ),
      );
}
