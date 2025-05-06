import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/colors.dart';
import '../../constants/app_strings.dart';

class QuoteSectionRukuSecond extends StatelessWidget {
  const QuoteSectionRukuSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
        top: 4,
        right: 4,
        left: 4,
        bottom: 4,),
    child: Text(
      AppStrings.rukuSecondScreenStrings.textUnderCard,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: AppColors.PrimaryColor,
        fontFamily: GoogleFonts.merriweather().fontFamily,
      ),
    ),);
  }
}
