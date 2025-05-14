import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

import '../../constants/app_assets.dart';

class RukuCard extends StatelessWidget {
  final String title;
  final String verseRange;
  final String backgroundSvgPath;

  const RukuCard({
    super.key,
    required this.title,
    required this.verseRange,
    required this.backgroundSvgPath,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive card dimensions
    final cardWidth = screenWidth / (screenWidth > 600 ? 3 : 2.4); // 3 per row on large screens, 2.4 on small
    final cardHeight = screenHeight / 4; // quarter of screen height

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 1.5),
            spreadRadius: 0.1,
          ),
        ],
      ),
      child: Stack(
        children: [
          // SVG Background
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SvgPicture.asset(
              backgroundSvgPath,
              width: cardWidth,
              height: cardHeight,
              fit: BoxFit.fill,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkgreenColor,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  verseRange,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.fontColor,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Center(
                  child: SvgPicture.asset(
                    AppAssets.quranpakrukuscreen_svg,
                    height: 70,
                    width: 70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}