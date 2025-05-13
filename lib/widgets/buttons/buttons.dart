// File: lib/widgets/Buttons/ruku_style_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/colors.dart';
import '../../constants/app_assets.dart';

class RukuStyleButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const RukuStyleButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shadow
            Container(
              width: double.infinity,
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
            // Border
            Container(
              width: double.infinity,
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
            // Text
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.HeadingColor,
                fontFamily: GoogleFonts.merriweather().fontFamily,
              ),
            ),
            // Top-left decoration
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
            // Bottom-right decoration
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
    );
  }
}
