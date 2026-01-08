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
        vertical: height * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 3,
            child: Image.asset(
              image,
              height: height * 0.25,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: height * 0.03),
          Flexible(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(
                fontSize: height * 0.022,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.merriweather().fontFamily,
                color: AppColors.darkgreenColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: height * 0.01),
          Flexible(
            flex: 1,
            child: Text(
              desc,
              style: TextStyle(
                fontSize: height * 0.018,
                fontFamily: GoogleFonts.merriweather().fontFamily,
                color: AppColors.darkgreenColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
