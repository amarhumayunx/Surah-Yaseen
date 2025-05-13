import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

import '../../constants/app_assets.dart';

class TitleCardAbout extends StatelessWidget {
  const TitleCardAbout({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Limit max width to 230, or use 80% of screen width if smaller
    final cardWidth = screenWidth * 0.8 > 230 ? 230.0 : screenWidth * 0.8;
    final cardHeight = cardWidth * 0.26; // keep similar aspect ratio

    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(top: 25, bottom: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shadow layer
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          // Border layer
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppColors.BarColor,
                width: 4,
              ),
            ),
          ),
          // Title text
          Text(
            'about_screen_title'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: cardHeight * 0.4, // responsive font size
              fontWeight: FontWeight.bold,
              color: AppColors.HeadingColor,
              fontFamily: GoogleFonts.merriweather().fontFamily,
            ),
          ),

          Positioned(
            top: 1,
            left: 10,
            child: Image.asset(
              AppAssets.topcornerdecor,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            bottom: 1,
            right: 10,
            child: Image.asset(
              AppAssets.bottomrightdecor,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),

        ],
      ),
    );
  }
}
