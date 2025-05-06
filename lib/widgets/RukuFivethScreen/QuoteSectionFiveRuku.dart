import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/colors.dart';
import '../../constants/app_strings.dart';

class QuoteSectionRukuFive extends StatelessWidget {
  const QuoteSectionRukuFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        right: 4,
        left: 4,
        bottom: 4,),
      child: Text(
        AppStrings.rukuFivethScreenStrings.textUnderCard,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.PrimaryColor,
          fontFamily: GoogleFonts.merriweather().fontFamily,
        ),
      ),
    );
  }
}
