import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

/// Reusable snackbar widget for showing "Press again to exit" message
class ExitSnackBar {
  /// Shows the exit snackbar with custom message
  static void show({
    String? message,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Dismiss any existing snackbar first
    Get.closeCurrentSnackbar();
    
    Get.snackbar(
      '', // Empty title
      message ?? 'press_again_to_exit'.tr,
      messageText: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.PrimaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message ?? 'press_again_to_exit'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      titleText: const SizedBox.shrink(), // Hide title
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(
        bottom: 100,
        left: 20,
        right: 20,
      ),
      duration: duration,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 0,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  /// Dismisses the current snackbar if shown
  static void dismiss() {
    Get.closeCurrentSnackbar();
  }
}

