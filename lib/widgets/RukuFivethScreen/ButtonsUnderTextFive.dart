import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Colors/colors.dart';
import 'ListenAudioRukuFiveScreen.dart';
import 'ListenAudioWithTranslationRukuFive.dart';
import 'RukuFiveReadScreen.dart';

// RukuFirstScreen Button Under Text
class ButtonsUnderTextRukuFive extends StatelessWidget {
  const ButtonsUnderTextRukuFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Read Button
        _buildButton(
          'read'.tr,
              () => Get.to(() => const RukuFiveReadScreen()),
        ),

        const SizedBox(height: 12),

        // Listen Audio Button
        _buildButton(
          'listen_audio'.tr,
              () => Get.to(() => const ListenAudioRukuFiveScreen()),
        ),

        const SizedBox(height: 12),

        // Listen Audio with translation Button
        _buildButton(
          'listen_audio_with_translation'.tr,
              () => Get.to(() => const ListenAudioWithTranslationRukuFive()),
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.BarColor, // Border color
            width: 2,
          ),
          borderRadius: BorderRadius.circular(22), // Rounded corners
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.PrimaryColor, // Button background color
            foregroundColor: Colors.white, // Button text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            elevation: 0, // No shadow
            padding: const EdgeInsets.symmetric(vertical: 18), // Vertical padding
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12, // Font size
              fontFamily: GoogleFonts.merriweather().fontFamily, // Font family,
              fontWeight: FontWeight.w600, // Font weight
            ),
          ),
        ),
      ),
    );
  }

}