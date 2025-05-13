import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            title: 'chapter_details'.tr,
            children: [
              _buildDetailRow('surah_number_text'.tr,'surah_number'.tr),
              _buildDetailRow('total_verses_text'.tr, 'total_verses'.tr),
              _buildDetailRow('ruku_text'.tr, 'ruku'.tr),
              _buildDetailRow('place_of_revelation_text'.tr,'place_of_revelation'.tr),
              _buildDetailRow('main_themes_text'.tr, 'main_themes'.tr),
              _buildDetailRow(AppStrings.aboutScreenStrings.text,'theme_text'.tr),
            ],
          ),

          // Significance & Benefits Card
          _buildInfoCard(
            title: 'significance_and_benefits'.tr,
            children: [
              _buildCenteredText('sandb_line1'.tr),
              _buildCenteredText('sandb_line2'.tr),
              _buildCenteredText('sandb_line3'.tr),
              _buildCenteredText('sandb_line4'.tr),
              _buildCenteredText('sandb_line5'.tr),
            ],
          ),

          // Purpose of App Card
          _buildInfoCard(
            title: 'purpose_of_app'.tr,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text(
                  'purpose_of_app_text'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    color: AppColors.PrimaryColor,
                  ),
                ),
              )
            ],
          ),

          // Add some padding at the bottom for better scrolling
          SizedBox(height: 15),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.merriweather().fontFamily,
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
              fontSize: 13,
              fontFamily: GoogleFonts.merriweather().fontFamily,
              color: AppColors.PrimaryColor,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
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
          fontSize: 13,
          fontFamily: GoogleFonts.merriweather().fontFamily,
          color: AppColors.PrimaryColor,
        ),
      ),
    );
  }
}