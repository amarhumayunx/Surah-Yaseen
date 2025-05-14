import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/constants/app_assets.dart';

// RukuFirstScreen Top Bar
class TopBarRukuFive extends StatelessWidget {
  const TopBarRukuFive({super.key});
  final BoxFit iconFit = BoxFit.contain;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: SvgPicture.asset(
            AppAssets.backarrow,
            fit: iconFit,
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