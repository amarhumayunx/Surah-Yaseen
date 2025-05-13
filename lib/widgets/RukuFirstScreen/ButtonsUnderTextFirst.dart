import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/ListenAudioWithTranslationRukuFirst.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/RukuFirstReadScreen.dart';
import '../../Colors/colors.dart';
import 'ListenAudioRukuFirstScreen.dart';

// RukuFirstScreen Button Under Text
class ButtonsUnderText extends StatelessWidget {
  const ButtonsUnderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Read Button
        _buildButton(
          'read'.tr,
              () => Get.to(() => const RukuFirstReadScreen()),
        ),

        const SizedBox(height: 12),

        // Listen Audio Button
        _buildButton(
          'listen_audio'.tr,
              () => Get.to(() => const ListenAudioRukuFirstScreen()),
        ),

        const SizedBox(height: 12),

        // Listen Audio with translation Button
        _buildButton(
          'listen_audio_with_translation'.tr,
              () => Get.to(() => const ListenAudioWithTranslationRukuFirst()),
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
              fontFamily: GoogleFonts.merriweather().fontFamily,
              fontWeight: FontWeight.w600, // Font weight
            ),
          ),
        ),
      ),
    );
  }

}