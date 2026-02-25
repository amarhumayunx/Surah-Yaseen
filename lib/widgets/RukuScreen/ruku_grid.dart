import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/screens/RukuFirstScreen.dart';
import 'package:surah_yaseen/screens/RukuSecondScreen.dart';
import 'package:surah_yaseen/screens/RukuThirdScreen.dart';
import '../../constants/app_assets.dart';
import '../../screens/RukuFivethScreen.dart';
import '../../screens/RukuFourthScreen.dart';
import '../../services/analytics_service.dart';
import 'ruku_card.dart';
import 'package:surah_yaseen/core/utils/responsive.dart';

class RukuGrid extends StatelessWidget {
  const RukuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final horizontalPadding = isTablet ? 40.0 : 30.0;
    final crossAxisCount = isTablet ? 3 : 2;
    const double spacing = 5;

    // Use MediaQuery so grid always has valid width (LayoutBuilder inside scroll can get 0)
    final gridWidth = (MediaQuery.sizeOf(context).width - (horizontalPadding * 2)).clamp(200.0, double.infinity);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SizedBox(
            width: gridWidth,
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: 1.0,
              children: [
                  GestureDetector(
                    onTap: () {
                      AnalyticsService.logRukuOpen(rukuNumber: 1);
                      Get.to(
                        () => RukuFirstScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_title_one'.tr,
                      verseRange: 'verse_title_one_to_twelve'.tr,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AnalyticsService.logRukuOpen(rukuNumber: 2);
                      Get.to(
                        () => RukuSecondScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_two'.tr,
                      verseRange: 'verse_title_thirteen_to_thirtytwo'.tr,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AnalyticsService.logRukuOpen(rukuNumber: 3);
                      Get.to(
                        () => RukuThirdScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_three'.tr,
                      verseRange: 'verse_title_thirtythree_to_fifty'.tr,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AnalyticsService.logRukuOpen(rukuNumber: 4);
                      Get.to(
                        () => RukuFourthScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_four'.tr,
                      verseRange: 'verse_title_fiftyone_to_sixtyseven'.tr,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AnalyticsService.logRukuOpen(rukuNumber: 5);
                      Get.to(
                        () => RukuFiveScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: RukuCard(
                      backgroundSvgPath: AppAssets.rukucard,
                      title: 'ruku_five'.tr,
                      verseRange: 'verse_title_sixtyeight_to_eightythree'.tr,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
