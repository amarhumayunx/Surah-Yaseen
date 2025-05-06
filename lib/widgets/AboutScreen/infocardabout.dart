import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/colors.dart';
import '../../constants/app_strings.dart';

class InfoBoxCard extends StatelessWidget {
  const InfoBoxCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Removed the Expanded widget from here
    return SingleChildScrollView(
      child: Column(
        children: [
          // Chapter Details Card
          _buildInfoCard(
            title: AppStrings.aboutScreenStrings.chapterDetails,
            children: [
              _buildDetailRow(AppStrings.aboutScreenStrings.SurahNumberText, AppStrings.aboutScreenStrings.SurahNumber),
              _buildDetailRow(AppStrings.aboutScreenStrings.TotalVersesText, AppStrings.aboutScreenStrings.TotalVerses),
              _buildDetailRow(AppStrings.aboutScreenStrings.RukuText, AppStrings.aboutScreenStrings.Ruku),
              _buildDetailRow(AppStrings.aboutScreenStrings.PlaceOfRevelationText,AppStrings.aboutScreenStrings.PlaceOfRevelation),
              _buildDetailRow(AppStrings.aboutScreenStrings.MainThemesText, AppStrings.aboutScreenStrings.MainThemes),
              _buildDetailRow(AppStrings.aboutScreenStrings.text,AppStrings.aboutScreenStrings.themeText),
            ],
          ),

          // Significance & Benefits Card
          _buildInfoCard(
            title: AppStrings.aboutScreenStrings.significanceAndBenefits,
            children: [
              _buildCenteredText(AppStrings.aboutScreenStrings.SandBline1),
              _buildCenteredText(AppStrings.aboutScreenStrings.SandBline2),
              _buildCenteredText(AppStrings.aboutScreenStrings.SandBline3),
              _buildCenteredText(AppStrings.aboutScreenStrings.SandBline4),
              _buildCenteredText(AppStrings.aboutScreenStrings.SandBline5),
            ],
          ),

          // Purpose of App Card
          _buildInfoCard(
            title: AppStrings.aboutScreenStrings.purposeOfApp,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text(
                  AppStrings.aboutScreenStrings.PurposeOfAppText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    color: AppColors.PrimaryColor,
                  ),
                ),
              )
            ],
          ),

          // Add some padding at the bottom for better scrolling
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.BarColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkgreenColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontFamily: GoogleFonts.merriweather().fontFamily,
              color: AppColors.PrimaryColor,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontFamily: GoogleFonts.merriweather().fontFamily,
                color: AppColors.PrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenteredText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontFamily: GoogleFonts.merriweather().fontFamily,
          color: AppColors.PrimaryColor,
        ),
      ),
    );
  }
}