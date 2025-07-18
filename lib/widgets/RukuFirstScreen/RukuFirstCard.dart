import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

import '../../constants/app_assets.dart';

class RukuFirstCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String verseRange;
  // Added parameters for card dimensions
  final double cardWidth;
  final double cardHeight;
  // Added parameters for image positioning
  final double imageTop;
  final double imageLeft;
  final double imageWidth;
  final double imageHeight;

  const RukuFirstCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.verseRange,
    // Optional parameters with default values
    this.cardWidth = 160, // Default card width
    this.cardHeight = 150, // Default card height
    this.imageTop = -4,
    this.imageLeft = 3,
    this.imageWidth = 45,
    this.imageHeight = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
            color: AppColors.BarColor,
            width: 1.5),
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
            left: Directionality.of(context) == TextDirection.ltr ? imageLeft : null,
            right: Directionality.of(context) == TextDirection.rtl ? imageLeft : null,
            child: ClipRRect(
              borderRadius: Directionality.of(context) == TextDirection.ltr
                  ? const BorderRadius.only(topLeft: Radius.circular(20))
                  : const BorderRadius.only(topRight: Radius.circular(20)),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(
                  Directionality.of(context) == TextDirection.rtl ? pi : 0,
                ),
                child: Image.asset(
                  imagePath,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
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
        ],
      ),
    );
  }
}