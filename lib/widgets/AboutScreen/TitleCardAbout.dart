import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import '../../constants/app_assets.dart';

class TitleCardAbout extends StatelessWidget {
  const TitleCardAbout({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: screenWidth * 0.06),
          width: screenWidth * 0.6, // responsive width
          height: screenWidth * 0.175, // maintain 240:70 ratio
          child: Stack(
            alignment: Alignment.center,
            children: [
              // SVG Background with proper sizing
              SvgPicture.asset(AppAssets.titleheader, fit: BoxFit.fill),
              Padding(
                padding: EdgeInsets.only(
                  top: screenWidth * 0.003,
                  bottom: screenWidth * 0.02,
                  right: screenWidth * 0.015,
                  left: screenWidth * 0.012,
                ),
                child: Text(
                  'about_screen_title'.tr,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: AppColors.HeadingColor,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
