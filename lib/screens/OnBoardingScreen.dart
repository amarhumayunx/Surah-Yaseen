import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Colors/colors.dart';
import 'package:surah_yaseen/widgets/OnBoardingScreen/onboarding_data.dart';
import '../controllers/onboarding_controller.dart';
import 'package:surah_yaseen/widgets/OnBoardingScreen/onboarding_page.dart';
import 'package:surah_yaseen/widgets/OnBoardingScreen/onboarding_bottom_buttons.dart';

class Onboardingscreen extends StatelessWidget {
  Onboardingscreen({super.key});

  final onboardingController = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SecondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
            Padding(
              padding: const EdgeInsets.only(bottom: 55),
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
            OnboardingBottomButtons(totalPages: onboardingData.length),
          ],
        ),
      ),
    );
  }
}
