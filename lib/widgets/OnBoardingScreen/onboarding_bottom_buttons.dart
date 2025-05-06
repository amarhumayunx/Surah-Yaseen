import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/controllers/onboarding_controller.dart';
import 'package:surah_yaseen/menu/navigation_menu.dart';

import '../../constants/app_strings.dart';

class OnboardingBottomButtons extends StatelessWidget {
  final int totalPages;

  const OnboardingBottomButtons({super.key, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    final onboardingController = Get.find<OnboardingController>();

    return Obx(() {
      final currentPage = onboardingController.currentPage.value;
      final isLastPage = currentPage == totalPages - 1;

      return Container(
        height: 140,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: AppColors.SecondaryColor,
        child: currentPage > 0
            ? Center(
          child: SizedBox(
            width: 350,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (isLastPage) {
                  Get.to(() => NavigationMenu());
                } else {
                  onboardingController.nextPage();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.HeadingColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                isLastPage ? AppStrings.onboardingStrings.getStartedbuttonString : AppStrings.onboardingStrings.nextbuttonString,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Get.to(() => NavigationMenu()),
              child: Text(
                AppStrings.onboardingStrings.skipbuttonString,
                style: TextStyle(
                  color: AppColors.HeadingColor,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 60,
              child: ElevatedButton(
                onPressed: onboardingController.nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.HeadingColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
