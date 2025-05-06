import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String desc;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen height and width
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.08,
        vertical: height * 0.1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            image,
            height: height * 0.3,
          ),
          SizedBox(height: height * 0.08),
          Text(
            title,
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.merriweather().fontFamily,
              color: AppColors.HeadingColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: height * 0.01),
          Text(
            desc,
            style: TextStyle(
              fontSize: height * 0.02,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.merriweather().fontFamily,
              color: AppColors.fontColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
