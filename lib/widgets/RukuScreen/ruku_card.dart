import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

import '../../constants/app_assets.dart';

class RukuCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String verseRange;

  // Optional image positioning (kept same)
  final double imageTop;
  final double imageLeft;
  final double imageWidth;
  final double imageHeight;

  const RukuCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.verseRange,
    this.imageTop = -4,
    this.imageLeft = 5,
    this.imageWidth = 45,
    this.imageHeight = 45,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.BarColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            spreadRadius: 1,
            blurRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: imageTop,
            left: imageLeft,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
              child: Image.asset(
                imagePath,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkgreenColor,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                verseRange,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.fontColor,
                  fontFamily: GoogleFonts.poppins().fontFamily,
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
        ],
      ),
    );
  }
}
