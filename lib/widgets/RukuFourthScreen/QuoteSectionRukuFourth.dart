import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/colors.dart';

class QuoteSectionRukuFourth extends StatelessWidget {
  const QuoteSectionRukuFourth({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
        top: 4,
        right: 4,
        left: 4,
        bottom: 4,),
    child: Text(
      'text_under_card_ruku4'.tr,
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
