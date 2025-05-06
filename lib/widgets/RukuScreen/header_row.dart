import 'package:flutter/material.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:get/get.dart';
import '../../constants/app_strings.dart';
import '../../screens/AboutScreen.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.notifications_none_outlined,
            color: AppColors.SecondaryColor, size: 40),
        Padding(
          padding: const EdgeInsets.only(top: 6.0), // Adjust this to move text up/down
          child: Column(
            children: [
              Text(
                AppStrings.appnamestrings.appname,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.SecondaryColor,
                ),
              ),
              Text(
                AppStrings.appnamestrings.suratname,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.SecondaryColor,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => AboutScreen());
          },
          child: Icon(
            Icons.info_outline,
            size: 40,
            color: AppColors.SecondaryColor,
          ),
        ),
      ],
    );
  }
}
