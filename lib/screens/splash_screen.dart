import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surah_yaseen/screens/OnBoardingScreen.dart';
import '../Colors/colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_assets.dart';
import '../menu/navigation_menu.dart';
import '../services/app_open_ad_manager.dart';

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

    // Show splash screen for minimum 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if we should show app open ad after splash screen
    final appOpenAdManager = AppOpenAdManager.instance;
    // Record this cold start so the app-open ad logic can reach the minimum
    // launch threshold. Without this, ads may never load/show.
    await appOpenAdManager.recordAppLaunch();
    bool shouldShowAd = await appOpenAdManager.shouldShowAdOnAppOpen();
    if (!shouldShowAd) {
      // Wait briefly for an ad to finish loading on first open
      final becameAvailable = await appOpenAdManager.waitUntilAdAvailable(timeout: const Duration(seconds: 2));
      if (becameAvailable) {
        shouldShowAd = true;
      }
    }

    // Navigate function to avoid code duplication
    void navigate() {
      if (isFirstTime) {
        prefs.setBool('isFirstTime', false).then((_) {
          Get.off(() => Onboardingscreen());
        });
      } else {
        Get.off(() => const NavigationMenu());
      }
    }

    if (shouldShowAd) {
      // Try to show the app open ad
      final adShown = await appOpenAdManager.showAdIfAvailable();
      
      if (adShown) {
        // Ad was shown successfully - it will handle its own lifecycle
        // We need to navigate after a short delay to ensure ad is displayed
        // The navigation will happen even if ad is showing (ad is fullscreen)
        // Wait a moment for ad to fully display, then navigate
        // Note: Ad will be on top as fullscreen, navigation happens behind it
        await Future.delayed(const Duration(milliseconds: 300));
        navigate();
      } else {
        // Ad not available or not shown - navigate immediately
        navigate();
      }
    } else {
      // Don't show ad - navigate directly
      navigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PrimaryColor,
      body: SafeArea(
        child: Center(
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
      ),
    );
  }
}
