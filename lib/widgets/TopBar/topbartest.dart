import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import '../../constants/app_assets.dart';

class TopBarSet extends StatelessWidget {
  const TopBarSet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic font sizes and icon sizes
    final double fontSizeTitle = screenWidth * 0.06; // ~24 on a 400px screen
    final double fontSizeSubtitle = screenWidth * 0.04; // ~16 on a 400px screen
    final double iconSize = screenWidth * 0.09; // ~40 for a standard screen width

    // Adjusting padding based on screen size
    final double horizontalPadding = screenWidth * 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Directionality.of(context) == TextDirection.rtl
                ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.1416), // Flip horizontally (180°)
              child: Image.asset(
                AppAssets.back_arrow_key,
                height: 25,
                width: 25,
                color: AppColors.SecondaryColor,
              ),
            )
                : Image.asset(
              AppAssets.back_arrow_key,
              height: 25,
              width: 25,
              color: AppColors.SecondaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          Expanded(
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 15.0,right: 0), // Adjust padding for better alignment
                child: Column(
                  children: [
                    Text(
                      'app_name'.tr,
                      style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                        color: AppColors.SecondaryColor,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                      ),
                    ),
                    Text(
                      'surat_name'.tr,
                      style: TextStyle(
                        fontSize: fontSizeSubtitle,
                        color: AppColors.SecondaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }
}
