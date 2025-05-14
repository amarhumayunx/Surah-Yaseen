import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/screens/RukuFirstScreen.dart';
import 'package:surah_yaseen/screens/RukuSecondScreen.dart';
import 'package:surah_yaseen/screens/RukuThirdScreen.dart';
import '../../constants/app_assets.dart';
import '../../screens/RukuFivethScreen.dart';
import '../../screens/RukuFourthScreen.dart';
import 'ruku_card.dart';

class RukuGrid extends StatelessWidget {
  const RukuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.minWidth;
              int crossAxisCount = screenWidth > 600 ? 3 : 2;
              double mainAxisSpacing = screenWidth > 600 ? 5 : 5;
              double crossAxisSpacing = screenWidth > 600 ? 5 : 5;
              double childAspectRatio = screenWidth > 600 ? 1.0 : 1.0;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                childAspectRatio: childAspectRatio,
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => RukuFirstScreen()),
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_title_one'.tr,
                      verseRange: 'verse_title_one_to_twelve'.tr,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => RukuSecondScreen()),
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_two'.tr,
                      verseRange: 'verse_title_thirteen_to_thirtytwo'.tr,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => RukuThirdScreen()),
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_three'.tr,
                      verseRange: 'verse_title_thirtythree_to_fifty'.tr,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => RukuFourthScreen()),
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_four'.tr,
                      verseRange: 'verse_title_fiftyone_to_sixtyseven'.tr,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => RukuFiveScreen()),
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_five'.tr,
                      verseRange: 'verse_title_sixtyeight_to_eightythree'.tr,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20), // Space at the end
      ],
    );
  }
}
