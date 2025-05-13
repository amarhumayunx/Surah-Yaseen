import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/constants/app_assets.dart';

// RukuSecondScreen Top Bar
class TopBarRukuSecond extends StatelessWidget {
  const TopBarRukuSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Image.asset(
            AppAssets.back_arrow_key,
            height: 30,
            width: 30,
            color: AppColors.SecondaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'app_name'.tr,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.SecondaryColor,
                    ),
                  ), // Added vertical spacing between text elements
                  Text(
                    'surat_name'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.SecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Add a spacer of the same width as the back button to maintain balance
        SizedBox(width: 48),
      ],
    );
  }
}