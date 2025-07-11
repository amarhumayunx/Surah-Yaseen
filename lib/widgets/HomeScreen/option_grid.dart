import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/screens/RukuScreen.dart';
import '../../screens/AboutScreen.dart';
import '../../screens/BookmarkScreen.dart';
import 'option_card.dart';

class OptionGrid extends StatelessWidget {
  const OptionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate dynamic offsets and scaling based on screen size
    final double topOffset = screenHeight * 0.01; // ~3% from top
    final double scaleFactor = screenWidth > 550 ? 1.01 : 1.0;

    return Transform.translate(
      offset: Offset(0, topOffset),
      child: Transform.scale(
        scale: scaleFactor,
        child: Wrap(
          spacing: screenWidth * 0.01, // ~3% horizontal spacing
          runSpacing: screenHeight * 0.01, // ~1.5% vertical spacing
          alignment: WrapAlignment.center,
          children: [
            OptionCard(
              title: 'start_reading'.tr,
              subtitle: 'ruku1'.tr,
              verses: 'verse_title_one_to_twelve'.tr,
              onTap: () => Get.to(() => RukuScreen()),
              size: screenHeight * 0.19,
            ),
            OptionCard(
              title: 'bookmarks'.tr,
              subtitle: 'ruku1'.tr,
              verses: ''.tr,
              onTap: () => Get.to(() => BookmarkScreen(verseIndex: 0, rukuNumber: 0,)),
              size: screenHeight * 0.17,
            ),
            OptionCard(
              title: 'about'.tr,
              subtitle: 'introduction_to'.tr,
              verses: 'surah'.tr,
              onTap: () => Get.to(() => AboutScreen()),
              size: screenHeight * 0.17,
            ),
            Transform.translate(
              offset: Offset(0, -screenHeight * 0.02), // Responsive upward offset
              child: OptionCard(
                title: 'listen_audio'.tr,
                subtitle: 'ruku1'.tr,
                verses: 'verse_title_one_to_twelve'.tr,
                onTap: () => Get.to(() => RukuScreen()),
                size: screenHeight * 0.19,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
