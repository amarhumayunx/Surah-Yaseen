import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final int lastPageIndex = 1;

  void nextPage() {
    if (currentPage.value < lastPageIndex) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      // Update the current page after transition
      currentPage.value = currentPage.value + 1;
    }
  }

  void skipToEnd() {
    pageController.jumpToPage(lastPageIndex);
    currentPage.value = lastPageIndex;
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
