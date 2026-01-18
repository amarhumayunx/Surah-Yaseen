import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/OnBoardingScreen/onboarding_data.dart';
import 'package:surah_yaseen/widgets/OnBoardingScreen/onboarding_page.dart';
import 'package:surah_yaseen/widgets/OnBoardingScreen/onboarding_bottom_buttons.dart';

import '../Colors/colors.dart';
import '../controllers/onboarding_controller.dart';

class Onboardingscreen extends StatelessWidget {
  const Onboardingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingController = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: AppColors.SecondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // PageView in an Expanded widget to take available space
            Expanded(
              child: PageView.builder(
                controller: onboardingController.pageController,
                onPageChanged:
                    (index) => onboardingController.currentPage.value = index,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return OnboardingPage(
                    image: data['image']!,
                    title: data['title']!,
                    desc: data['desc']!,
                  );
                },
              ),
            ),

            // Page Indicator
            Obx(() => Container(
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 32, // Same width for all dots
                  height: 10, // Same height for all dots
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Fully rounded pill shape
                    color: onboardingController.currentPage.value == index
                        ? AppColors.HeadingColor // Dark forest green for active
                        : AppColors.OnbaordingScreenDotColor, // Light muted green for inactive
                  ),
                ),
              ),
            ),
            )),

            // Bottom buttons
            OnboardingBottomButtons(totalPages: onboardingData.length),
          ],
        ),
      ),
    );
  }
}
