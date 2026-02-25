import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surah_yaseen/screens/OnBoardingScreen.dart';
import '../Colors/colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_assets.dart';
import '../menu/navigation_menu.dart';
import '../services/app_open_ad_manager.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _loadingProgress = 0.0;
  String _loadingStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    try {
      setState(() {
        _loadingStatus = 'Loading resources...';
        _loadingProgress = 0.1;
      });

      final appOpenAdManager = AppOpenAdManager.instance;
      await appOpenAdManager.recordAppLaunch();

      appOpenAdManager.loadAd();

      setState(() {
        _loadingProgress = 0.3;
        _loadingStatus = 'Preparing content...';
      });

      bool adLoaded = false;
      int attempts = 0;
      const int maxAttempts = 20;

      while (!adLoaded && attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 200));
        adLoaded = await appOpenAdManager.shouldShowAdOnAppOpen();
        attempts++;

        if (attempts % 5 == 0) {
          setState(() {
            _loadingProgress = 0.3 + (attempts / maxAttempts) * 0.3;
          });
        }
      }

      if (!adLoaded) {
        debugPrint('App Open Ad: Not loaded yet, proceeding anyway');
      }

      setState(() {
        _loadingProgress = 0.6;
        _loadingStatus = 'Almost ready...';
      });

      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _loadingProgress = 0.9;
        _loadingStatus = 'Finalizing...';
      });

      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _loadingProgress = 1.0;
        _loadingStatus = 'Ready!';
      });

      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNext();
    } catch (e) {
      debugPrint('Error loading resources: $e');
      _navigateToNext();
    }
  }

  Future<void> _navigateToNext() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    final appOpenAdManager = AppOpenAdManager.instance;
    bool shouldShowAd = await appOpenAdManager.shouldShowAdOnAppOpen();

    void navigate() {
      if (isFirstTime) {
        prefs.setBool('isFirstTime', false).then((_) {
          Get.off(() => const Onboardingscreen());
        });
      } else {
        Get.off(() => const NavigationMenu());
      }
    }

    if (shouldShowAd) {
      final adShown = await appOpenAdManager.showAdIfAvailable();
      if (adShown) {
        await Future.delayed(const Duration(milliseconds: 300));
        navigate();
      } else {
        navigate();
      }
    } else {
      navigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LoadingScreenBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Center Content: Icon + App Name + Bar + Urdu Name ──
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Icon
                  ClipRRect(
                    child: Image.asset(
                      AppAssets.surahiconsplashscreenicon,
                      width: 200,
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // App Name
                  Text(
                    AppStrings.appnamestrings.appname,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      color: AppColors.SecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Decorative Bar
                  Container(width: 180, height: 2, color: AppColors.BarColor),
                  const SizedBox(height: 10),

                  // Urdu App Name
                  Text(
                    AppStrings.appnamestrings.appnameUrdu,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.SecondaryColor,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom Loading Section ──
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Loading Animation
                  LoadingAnimationWidget.fourRotatingDots(
                    color: AppColors.BarColor,
                    size: 60,
                  ),
                  const SizedBox(height: 10),

                  // Loading Status Text
                  Text(
                    _loadingStatus,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.SecondaryColor,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Progress Percentage
                  if (_loadingProgress > 0)
                    Text(
                      '${(_loadingProgress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.SecondaryColor.withValues(alpha: 0.7),
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
