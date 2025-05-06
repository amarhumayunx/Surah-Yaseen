import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Colors/colors.dart';
import 'ListenAudioRukuFourthScreen.dart';
import 'ListenAudioWithTranslationRukuFourth.dart';
import 'RukuFourthReadScreen.dart';
// RukuThirdScreen Button Under Text
class ButtonsUnderTextFourthRuku extends StatelessWidget {
  const ButtonsUnderTextFourthRuku({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Read Button
        _buildButton(
          'Read',
              () => Get.to(() => const RukuFourthReadScreen()),
        ),

        const SizedBox(height: 12),

        // Listen Audio Button
        _buildButton(
          'Listen Audio',
              () => Get.to(() => const ListenAudioRukuFourthScreen()),
        ),

        const SizedBox(height: 12),

        // Listen Audio with translation Button
        _buildButton(
          'Listen Audio with translation',
              () => Get.to(() => const ListenAudioWithTranslationRukuFourth()),
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
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
            padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16, // Font size
              fontWeight: FontWeight.w600, // Font weight
            ),
          ),
        ),
      ),
    );
  }

}