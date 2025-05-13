import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/colors.dart';

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'text_under_the_image'.tr,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: AppColors.PrimaryColor,
        fontFamily: GoogleFonts.merriweather().fontFamily,
      ),
    );
  }
}
