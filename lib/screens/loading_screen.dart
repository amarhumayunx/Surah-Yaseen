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

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  // Removed unused variable
  double _loadingProgress = 0.0;
  String _loadingStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _loadResources();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadResources() async {
    try {
      // Step 1: Initialize app open ad
      setState(() {
        _loadingStatus = 'Loading resources...';
        _loadingProgress = 0.1;
      });

      final appOpenAdManager = AppOpenAdManager.instance;
      await appOpenAdManager.recordAppLaunch();

      // Load app open ad
      appOpenAdManager.loadAd();

      setState(() {
        _loadingProgress = 0.3;
        _loadingStatus = 'Preparing content...';
      });

      // Wait for app open ad to load (with timeout - max 4 seconds)
      bool adLoaded = false;
      int attempts = 0;
      const int maxAttempts = 20; // 20 * 200ms = 4 seconds max wait

      while (!adLoaded && attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 200));
        adLoaded = await appOpenAdManager.shouldShowAdOnAppOpen();
        attempts++;

        // Update progress while waiting
        if (attempts % 5 == 0) {
          setState(() {
            _loadingProgress = 0.3 + (attempts / maxAttempts) * 0.3;
          });
        }
      }

      // If ad didn't load, that's okay - we'll proceed anyway
      if (!adLoaded) {
        debugPrint('App Open Ad: Not loaded yet, proceeding anyway');
      }

      setState(() {
        _loadingProgress = 0.6;
        _loadingStatus = 'Almost ready...';
      });

      // Pre-load banner ads (optional - for faster loading later)
      // This is just to warm up the ad SDK
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _loadingProgress = 0.9;
        _loadingStatus = 'Finalizing...';
      });

      // Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _loadingProgress = 1.0;
        _loadingStatus = 'Ready!';
      });

      // Navigate after loading is complete
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNext();
    } catch (e) {
      debugPrint('Error loading resources: $e');
      // Even if there's an error, proceed to next screen
      _navigateToNext();
    }
  }

  Future<void> _navigateToNext() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    final appOpenAdManager = AppOpenAdManager.instance;
    bool shouldShowAd = await appOpenAdManager.shouldShowAdOnAppOpen();

    // Navigate function
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
      // Try to show the app open ad
      final adShown = await appOpenAdManager.showAdIfAvailable();

      if (adShown) {
        // Wait a moment for ad to display
        await Future.delayed(const Duration(milliseconds: 300));
        navigate();
      } else {
        // Ad not available - navigate immediately
        navigate();
      }
    } else {
      // Don't show ad - navigate directly
      navigate();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                AppAssets.surahiconsplashscreenicon,
                width: 200,
                height: 150,
              ),
            ),
            const SizedBox(height: 30),

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
            Container(width: 170, height: 2, color: AppColors.BarColor),
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
            const SizedBox(height: 50),

            // Loading Animation
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.BarColor, width: 3),
                  ),
                  child: CircularProgressIndicator(
                    value: _loadingProgress,
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.BarColor,
                    ),
                    backgroundColor: AppColors.PrimaryColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Loading Status Text
            Text(
              _loadingStatus,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.SecondaryColor,
                fontFamily: GoogleFonts.merriweather().fontFamily,
              ),
            ),
            const SizedBox(height: 10),

            // Progress Percentage
            if (_loadingProgress > 0)
              Text(
                '${(_loadingProgress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.SecondaryColor.withOpacity(0.7),
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
