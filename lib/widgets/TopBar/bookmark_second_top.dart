import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import '../../constants/app_assets.dart';
import '../../screens/AboutScreen.dart';

class TopBarBookmark extends StatelessWidget {
  const TopBarBookmark({super.key});

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
    final BoxFit iconFit = BoxFit.contain;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Directionality.of(context) == TextDirection.rtl
                ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.1416),
              child: SvgPicture.asset(
                AppAssets.backarrow,
                fit: iconFit,
                height: 23,
              ),
            )
                : SvgPicture.asset(
              AppAssets.backarrow,
              fit: iconFit,
              height: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01), // Adjust padding for better alignment
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
          GestureDetector(
            onTap: () {
              Get.to(() => AboutScreen());
            },
            child: Icon(
              Icons.info_outline,
              size: iconSize,
              color: AppColors.SecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}