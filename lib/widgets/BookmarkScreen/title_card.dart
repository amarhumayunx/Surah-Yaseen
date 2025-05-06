import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/constants/app_assets.dart';
import '../../constants/app_strings.dart';

class TitleCardBookmark extends StatelessWidget {
  TitleCardBookmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Stack(
        clipBehavior: Clip.none, // 👈 Important to allow images to overflow
        alignment: Alignment.center,
        children: [
          // Main white card with shadow
          Container(
            width: 230,
            height: 60,
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
          // White card with colored border
          Container(
            width: 230,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppColors.BarColor,
                width: 4,
              ),
            ),
          ),
          // Title Text
          Text(
            AppStrings.bookmarkScreenBodystrings.title,
            style: TextStyle(
              fontSize: 22,
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
