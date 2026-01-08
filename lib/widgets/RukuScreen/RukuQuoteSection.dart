import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Colors/colors.dart';

// Reusable Quote Section for all Ruku Screens
class RukuQuoteSection extends StatelessWidget {
  final String translationKey; // e.g., 'text_under_card_ruku1'

  const RukuQuoteSection({
    super.key,
    required this.translationKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        right: 4,
        left: 4,
        bottom: 4,
      ),
      child: Text(
        translationKey.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.PrimaryColor,
          fontFamily: GoogleFonts.merriweather().fontFamily,
        ),
      ),
    );
  }
}





