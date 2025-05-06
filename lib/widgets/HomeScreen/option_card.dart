import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/constants/app_assets.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String verses;
  final VoidCallback onTap;
  final double height;

  final double bottomDecorWidth;
  final double bottomDecorHeight;
  final double bottomDecorRight;
  final double bottomDecorBottom;

  const OptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.verses,
    required this.onTap,
    this.height = 150,
    this.bottomDecorWidth = 30,
    this.bottomDecorHeight = 40,
    this.bottomDecorRight = 45,
    this.bottomDecorBottom = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8, // Shadow all around
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            width: 150,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.BarColor,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
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
                      fontSize: 14,
                      color: AppColors.PrimaryColor,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                    ),
                  ),
                  if (verses.isNotEmpty)
                    Text(
                      verses,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.PrimaryColor,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                      ),
                    ),
                  const SizedBox(height: 15),
                  Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.PrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: onTap,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -4,
            left: 5,
            child: Image.asset(AppAssets.topcornerdecor, width: 45, height: 45),
          ),
          Positioned(
            bottom: bottomDecorBottom,
            right: bottomDecorRight,
            child: Image.asset(
              AppAssets.bottomcornerdecor,
              width: bottomDecorWidth,
              height: bottomDecorHeight,
            ),
          ),
        ],
      ),
    );
  }
}
