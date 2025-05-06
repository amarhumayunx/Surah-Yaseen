import 'package:flutter/material.dart';
import 'package:surah_yaseen/Colors/colors.dart';

class DividerBar extends StatelessWidget {
  const DividerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final barWidth = screenWidth * 0.65; // 65% of screen width

    return Container(
      height: 2,
      width: barWidth,
      color: AppColors.BarColor,
      margin: const EdgeInsets.symmetric(vertical: 5),
    );
  }
}
