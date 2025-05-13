import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/constants/app_assets.dart';

class TitleCardBookmark extends StatelessWidget {
  TitleCardBookmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Stack(
        clipBehavior: Clip.none,
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
            'bookmarks'.tr,
            style: TextStyle(
              fontSize: 22,
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
