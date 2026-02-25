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

    return Scaffold(
      backgroundColor: AppColors.SecondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              flex: 3,
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

            // Smooth Page Indicator
            Container(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: SmoothPageIndicator(
                controller: onboardingController.pageController,
                count: onboardingData.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.HeadingColor,
                  dotColor: AppColors.OnbaordingScreenDotColor,
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 3,
                  spacing: 8,
                ),
              ),
            ),

            // Bottom Buttons
            OnboardingBottomButtons(totalPages: onboardingData.length),
          ],
        ),
      ),
    );
  }
}
