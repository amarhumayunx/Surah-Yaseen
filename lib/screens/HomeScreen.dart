import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../widgets/TopBar/topbar.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import '../widgets/HomeScreen/quote_section.dart';
import '../widgets/HomeScreen/option_grid.dart';
import 'package:surah_yaseen/constants/app_assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    // Set system UI to edge-to-edge mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    
    // Initialize banner ad
    _loadBannerAd();
  }

  void _loadBannerAd() {
    // Use test ad unit ID for development
    // For Android: ca-app-pub-3940256099942544/6300978111
    // For iOS: ca-app-pub-3940256099942544/2934735716
    // Replace with your production ad unit ID when ready: 'ca-app-pub-3425673808153409/9699762512'
    final String adUnitId = kDebugMode
        ? 'ca-app-pub-3940256099942544/6300978111' // Test ad unit ID
        : 'ca-app-pub-3425673808153409/9699762512'; // Production ad unit ID
    
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
          print('Banner ad loaded successfully');
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          print('Error code: ${err.code}');
          print('Error domain: ${err.domain}');
          _isBannerAdReady = false;
          ad.dispose();
        },
        onAdOpened: (_) {
          print('Banner ad opened');
        },
        onAdClosed: (_) {
          print('Banner ad closed');
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic values based on screen dimensions
    final double paddingHorizontal = screenWidth * 0.01;
    final double imageHeight = screenHeight * 0.15; // Slightly reduced to save space
    final double spacing = screenHeight * 0.01;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.lightColorSec,
        body: Stack(
          children: [
            TopBackground(),
            SafeArea(
              child: Column(
                children: [
                  // Fixed top section
                  const TopBar(),
                  SizedBox(height: spacing),
                  const DividerBar(),
                  const SurahTitle(),

                  // Content area with adjusted spacing
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            AppAssets.quran,
                            height: imageHeight,
                            fit: BoxFit.contain,
                          ),
                          QuoteSection(),
                          OptionGrid(),
                          // Banner Ad at the bottom
                          if (_isBannerAdReady && _bannerAd != null)
                            Container(
                              alignment: Alignment.center,
                              width: _bannerAd!.size.width.toDouble(),
                              height: _bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd!),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}