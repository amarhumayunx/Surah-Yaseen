import 'dart:math' as math;

import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Colors/colors.dart';
import '../../constants/app_assets.dart';

class BookmarkItem extends StatelessWidget {
  final String arabicText;
  final String title;
  final String date;
  final String iconType;
  final bool isSelected;
  final bool isInDeleteMode;

  const BookmarkItem({
    super.key,
    required this.arabicText,
    required this.title,
    required this.date,
    required this.iconType,
    this.isSelected = false,
    this.isInDeleteMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            isInDeleteMode ? 40 : 16, // Add extra padding on the left when in delete mode
            16,
            16,
            16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColors.BarColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container with Image Asset
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: Image.asset(
                  _getIconPath(),
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic Text
                    Text(
                      arabicText,
                      style: ArabicTextStyle(
                        arabicFont: ArabicFont.lateef,
                        fontSize: 24,
                        color: AppColors.BookmarktextColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Title Text
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.PrimaryColor,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                      ),
                    ),
                    // Date Text
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.PrimaryColor,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow Icon - Only show if not in delete mode
              if (!isInDeleteMode)
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.PrimaryColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.BarColor,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: Directionality.of(context) == TextDirection.ltr ? 7 : null,
                        left: Directionality.of(context) == TextDirection.rtl ? 7 : null,
                        bottom: 4,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Directionality.of(context) == TextDirection.rtl
                              ? Matrix4.rotationY(math.pi) // Flip horizontally for RTL
                              : Matrix4.identity(),
                          child: Image.asset(
                            AppAssets.bottomcornerdecor,
                            width: 28,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // Bottom right decoration
        Positioned(
          right: Directionality.of(context) == TextDirection.ltr ? 8 : null,
          left: Directionality.of(context) == TextDirection.rtl ? 8 : null,
          bottom: 8,
          child: ClipRRect(
            borderRadius: Directionality.of(context) == TextDirection.ltr
                ? const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              topLeft: Radius.circular(25),
            )
                : const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(0),
              topRight: Radius.circular(25),
            ),
            child: Transform(
              alignment: Alignment.center,
              transform: Directionality.of(context) == TextDirection.rtl
                  ? Matrix4.rotationY(math.pi) // Flip horizontally for RTL
                  : Matrix4.identity(),
              child: Image.asset(
                AppAssets.bottomrightdecor,
                width: 40,
                height: 22,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Selection circle - Only show when in delete mode
        if (isInDeleteMode)
          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.PrimaryColor : Colors.transparent,
                  border: Border.all(
                    color: AppColors.PrimaryColor,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                )
                    : null,
              ),
            ),
          ),
      ],
    );
  }

  // Helper method to return icon path based on the iconType
  String _getIconPath() {
    return iconType == 'audio'
        ? AppAssets.headphoneimagebookmark
        : AppAssets.quranpakimagebookmark;
  }
}