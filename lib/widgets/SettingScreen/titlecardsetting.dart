import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';

class TitleCardSetting extends StatelessWidget {
  const TitleCardSetting({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive card width (80% of screen width, or 230 max)
    final cardWidth = screenWidth * 0.8 > 230 ? 230.0 : screenWidth * 0.8;
    final cardHeight = cardWidth * 0.26; // maintain similar aspect ratio

    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 2),
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
          // Text layer
          Text(
            AppStrings.settingScreenStrings.SettingScreenTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: cardHeight * 0.4, // responsive font size
              fontWeight: FontWeight.bold,
              color: AppColors.HeadingColor,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),

          // ✅ Top Left Corner Image
          Positioned(
            top: 1, // 👈 Move slightly outside the card
            left: 10,
            child: Image.asset(
              AppAssets.topcornerdecor, // ✅ Replace with your asset path
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),

          // ✅ Bottom Right Corner Image
          Positioned(
            bottom: 1, // 👈 Move slightly outside the card
            right: 10,
            child: Image.asset(
              AppAssets.bottomrightdecor, // ✅ Replace with your asset path
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
