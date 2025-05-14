import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.SecondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // PageView in an Expanded widget to take available space
            Expanded(
              flex: 7, // Give more space to the content
              child: PageView.builder(
                controller: onboardingController.pageController,
                onPageChanged: (index) =>
                onboardingController.currentPage.value = index,
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

            // Page indicator with flexible sizing
            Flexible(
              flex: 1,
              child: SmoothPageIndicator(
                controller: onboardingController.pageController,
                count: onboardingData.length,
                effect: ExpandingDotsEffect(
                  spacing: 5,
                  radius: 10,
                  dotWidth: 12,
                  dotHeight: 8.5,
                  dotColor: AppColors.OnbaordingScreenDotColor,
                  activeDotColor: AppColors.darkgreenColor,
                ),
              ),
            ),

            // Bottom buttons with constrained height
            SizedBox(
              height: screenHeight * 0.1, // 10% of screen height
              child: OnboardingBottomButtons(totalPages: onboardingData.length),
            ),

            // Small bottom padding to ensure no overflow
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}