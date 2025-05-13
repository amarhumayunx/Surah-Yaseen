import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surah_yaseen/screens/OnBoardingScreen.dart';
import '../Colors/colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_assets.dart';
import '../menu/navigation_menu.dart';

class SurahYaseenSplashScreen extends StatefulWidget {
  const SurahYaseenSplashScreen({super.key});

  @override
  State<SurahYaseenSplashScreen> createState() => _SurahYaseenSplashScreenState();
}

class _SurahYaseenSplashScreenState extends State<SurahYaseenSplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNext();
  }

  Future<void> navigateToNext() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    await Future.delayed(const Duration(seconds: 2));

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      Get.off(() => Onboardingscreen());
    } else {
      Get.off(() => const NavigationMenu()); // Replace with your actual home screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                AppAssets.surahiconsplashscreenicon,
                width: 300,
                height: 200,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.appnamestrings.appname,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.merriweather().fontFamily,
                color: AppColors.SecondaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 170,
              height: 2,
              color: AppColors.BarColor,
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.appnamestrings.appnameUrdu,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.SecondaryColor,
                fontFamily: GoogleFonts.merriweather().fontFamily,
              ),
            )
          ],
        ),
      ),
    );
  }
}
