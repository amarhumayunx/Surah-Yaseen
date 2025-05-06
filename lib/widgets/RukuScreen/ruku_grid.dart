import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/screens/RukuFirstScreen.dart';
import 'package:surah_yaseen/screens/RukuSecondScreen.dart';
import 'package:surah_yaseen/screens/RukuThirdScreen.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../../screens/RukuFivethScreen.dart';
import '../../screens/RukuFourthScreen.dart';
import 'ruku_card.dart';

class RukuGrid extends StatelessWidget {
  const RukuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate crossAxisCount and spacing based on screen width
          double screenWidth = constraints.maxWidth;

          // Adjust grid settings for different screen sizes
          int crossAxisCount = screenWidth > 600 ? 3 : 2; // More columns for larger screens
          double mainAxisSpacing = screenWidth > 600 ? 30 : 25; // More space between cards
          double crossAxisSpacing = screenWidth > 600 ? 25 : 20; // Adjust spacing
          double childAspectRatio = screenWidth > 600 ? 1.2 : 1.0; // Change card aspect ratio for larger screens

          return GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
            children: [
              // First Ruku Card with custom positioning
              GestureDetector(
                onTap: () {
                  Get.to(() => RukuFirstScreen());
                },
                child: RukuCard(
                  imagePath: AppAssets.topcornerdecor,
                  title: AppStrings.rukuStrings.rukutitleone,
                  verseRange: AppStrings.rukuStrings.versetitleonetotwelve,
                  imageTop: -8,
                  imageLeft: 3,
                  imageWidth: 55,
                  imageHeight: 55,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Get.to(() => RukuSecondScreen());
                },
                // Second Ruku Card with different positioning
                child: RukuCard(
                  imagePath: AppAssets.topcornerdecor,
                  title: AppStrings.rukuStrings.rukutwo,
                  verseRange: AppStrings.rukuStrings.versetitlethirteentothirtytwo,
                  imageTop: -8,
                  imageLeft: 3,
                  imageWidth: 55,
                  imageHeight: 55,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Get.to(() => RukuThirdScreen());
                },
                // Third Ruku Card with custom positioning
                child: RukuCard(
                  imagePath: AppAssets.topcornerdecor,
                  title: AppStrings.rukuStrings.rukuthree,
                  verseRange: AppStrings.rukuStrings.versetitlethirtythreetofifty,
                  imageTop: -8,
                  imageLeft: 3,
                  imageWidth: 55,
                  imageHeight: 55,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Get.to(() => RukuFourthScreen());
                },
                // Fourth Ruku Card with different positioning
                child: RukuCard(
                  imagePath: AppAssets.topcornerdecor,
                  title: AppStrings.rukuStrings.rukufour,
                  verseRange: AppStrings.rukuStrings.versetitlefiftyonetosixtyseven,
                  imageTop: -8,
                  imageLeft: 3,
                  imageWidth: 55,
                  imageHeight: 55,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Get.to(() => RukuFiveScreen());
                },
                // Fourth Ruku Card with different positioning
                child: RukuCard(
                  imagePath: AppAssets.topcornerdecor,
                  title: AppStrings.rukuStrings.rukufiveth,
                  verseRange: AppStrings.rukuStrings.versetitlesixtheighttoeightythree,
                  imageTop: -8,
                  imageLeft: 3,
                  imageWidth: 55,
                  imageHeight: 55,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
