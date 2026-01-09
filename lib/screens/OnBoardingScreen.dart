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
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: onboardingController.currentPage.value == index ? 32 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), // Fully rounded pill shape
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
