import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/colors.dart';
import '../../constants/app_strings.dart';

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.settingScreenStrings.TextUnderTheImage,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        color: AppColors.PrimaryColor,
        fontFamily: GoogleFonts.merriweather().fontFamily,
      ),
    );
  }
}
