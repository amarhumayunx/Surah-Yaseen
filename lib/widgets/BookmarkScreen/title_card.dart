import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/constants/app_assets.dart';

class TitleCardBookmark extends StatelessWidget {
  TitleCardBookmark({super.key});

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

              Padding(
                padding: const EdgeInsets.only(top: 1,bottom: 8,right: 6,left: 5),
                child: Text(
                  'bookmarks'.tr,
                  style: TextStyle(
                    fontSize: 22,
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
