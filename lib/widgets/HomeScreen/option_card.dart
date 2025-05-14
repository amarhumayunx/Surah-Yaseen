import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/constants/app_assets.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String verses;
  final VoidCallback onTap;
  final double height;
  final double width;

  const OptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.verses,
    required this.onTap,
    double? size,
  })  : height = size ?? 150,
        width = size ?? 150;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 1.5),
            spreadRadius: 0.2,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.center, // Center stack children
          children: [
            // SVG Background
            SvgPicture.asset(
              AppAssets.optioncard,
              width: width,
              height: height,
              fit: BoxFit.fill,
            ),

            // Content
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.HeadingColor,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.PrimaryColor,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                    ),
                  ),
                  if (verses.isNotEmpty)
                    Text(
                      verses,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.PrimaryColor,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                      ),
                    ),
                  const SizedBox(height: 15),
                  SvgPicture.asset(
                    AppAssets.homescreenbutton,
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}