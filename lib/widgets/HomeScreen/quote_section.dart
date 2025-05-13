import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Colors/colors.dart';

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045; // ~18 at 400px screen width

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        'text_under_button'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontStyle: FontStyle.italic,
          color: AppColors.PrimaryColor,
          fontFamily: GoogleFonts.merriweather().fontFamily,
        ),
      ),
    );
  }
}
