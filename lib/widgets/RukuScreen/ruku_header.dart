import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';

class RukuHeader extends StatelessWidget {
  const RukuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
              top: 30,
              bottom: 2),
          child: Stack(
            alignment: Alignment.center,
            children: [
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
              Container(
                width: 230,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      color: AppColors.BarColor,
                      width: 4),
                ),
              ),
              Text(
                AppStrings.rukuStrings.rukubuttontitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.HeadingColor,
                  fontFamily: GoogleFonts.poppins().fontFamily,
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
        ),



        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10),
          child: Text(
            AppStrings.rukuStrings.textunderrukubutton,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF4CAF87),
              fontFamily: GoogleFonts.merriweather().fontFamily,
            ),
          ),
        ),
      ],
    );
  }
}
