import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_strings.dart';

class SurahTitle extends StatelessWidget {
  const SurahTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic font sizes based on screen width
    final double fontSizeTitle = screenWidth * 0.08; // ~32 on a 400px screen
    final double fontSizeSubtitle = screenWidth * 0.045; // ~18 on a 400px screen

    return Column(
      children: [
        Text(
          AppStrings.appnamestrings.appnameUrdu,
          style: TextStyle(
            fontSize: fontSizeTitle,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.merriweather().fontFamily,
            color: Colors.white,
          ),
        ),
        Text(
          AppStrings.appnamestrings.suratnameUrdu,
          style: TextStyle(
            fontSize: fontSizeSubtitle,
            fontFamily: GoogleFonts.merriweather().fontFamily,
            color: Colors.white,
          ),
        ),



      ],
    );
  }
}
