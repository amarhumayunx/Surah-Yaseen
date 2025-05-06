import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';

class TopBackground extends StatelessWidget {
  const TopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Setting the height to be a fraction of the screen height
    final double backgroundHeight = screenHeight * 0.35; // ~35% of screen height

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: backgroundHeight,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backgroundhomepage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
