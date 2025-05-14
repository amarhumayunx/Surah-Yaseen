import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

import '../../constants/app_assets.dart';

class RukuHeader extends StatelessWidget {
  const RukuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
              top: 25,
              bottom: 1),
          width: 240,
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // SVG Background with proper sizing
              SvgPicture.asset(
                AppAssets.titleheader,
                fit: BoxFit.fill, // Use fill to ensure the entire area is covered
              ),
              // Text remains centered with proper contrast
              Padding(
                padding: const EdgeInsets.only(top: 1,bottom: 8,right: 5,left: 5),
                child: Text(
                  'ruku_button_title'.tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.HeadingColor,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.only(top: 2,bottom: 15,right: 35,left: 35),
          child: Text(
            'text_under_ruku_button'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.PrimaryColor,
                fontFamily: GoogleFonts.merriweather().fontFamily,
                height: 1.5
            ),
          ),
        ),
      ],
    );
  }
}