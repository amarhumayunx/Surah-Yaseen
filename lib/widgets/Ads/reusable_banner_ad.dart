import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../constants/ad_unit_ids.dart';

/// A reusable banner ad widget that can be used across different screens
/// with different ad unit IDs.
/// 
/// Usage examples:
/// 1. Using screen type (recommended):
///    ReusableBannerAd(screenType: AdScreenType.settings)
/// 
/// 2. Using direct ad unit ID:
///    ReusableBannerAd(adUnitId: AdUnitIds.settingsScreenBanner)
class ReusableBannerAd extends StatefulWidget {
  /// The ad unit ID for this banner ad (optional if screenType is provided)
  final String? adUnitId;
  
  /// Screen type to automatically get the correct ad unit ID (optional if adUnitId is provided)
  final AdScreenType? screenType;
  
  /// Optional custom ad size. Defaults to AdSize.banner
  final AdSize? adSize;
  
  /// Optional height for the container when ad is loading or failed
  final double? minHeight;

  const ReusableBannerAd({
    super.key,
    this.adUnitId,
    this.screenType,
    this.adSize,
    this.minHeight,
  }) : assert(
          adUnitId != null || screenType != null,
          'Either adUnitId or screenType must be provided',
        );

  @override
  State<ReusableBannerAd> createState() => _ReusableBannerAdState();
}

class _ReusableBannerAdState extends State<ReusableBannerAd> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (_isAdLoading) return;

    setState(() {
      _isAdLoading = true;
      _hasError = false;
    });

    // Get the ad unit ID - either from screenType or directly provided
    final String productionAdUnitId = widget.screenType != null
        ? AdUnitIds.getBannerAdUnitIdForPlatform(widget.screenType!) // Platform-aware
        : widget.adUnitId!;

    // Use test ad unit ID in debug mode, otherwise use the provided ad unit ID
    final String adUnitId = kDebugMode 
        ? (Platform.isAndroid 
            ? AdUnitIds.testBannerAndroid // Google's test banner ad unit for Android
            : AdUnitIds.testBannerIOS) // Google's test banner ad unit for iOS
        : productionAdUnitId;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: widget.adSize ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
              _isAdLoading = false;
              _hasError = false;
            });
          }
          debugPrint('Banner ad loaded successfully: $adUnitId');
        },
        onAdFailedToLoad: (ad, error) {
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
              _isAdLoading = false;
              _hasError = true;
            });
          }
          // Dispose the ad if it failed to load
          ad.dispose();
          _bannerAd = null;
          
          // Log error for debugging
          debugPrint('Banner ad failed to load: ${error.code} - ${error.message}');
          debugPrint('Ad Unit ID: $adUnitId');
          
          // Error code 3 = ERROR_CODE_NO_FILL (no ad available)
          // This is common for new ad units
          if (error.code == 3) {
            debugPrint('No ad available (No fill). This is normal for new ad units.');
          }
        },
        onAdOpened: (_) {
          debugPrint('Banner ad opened');
        },
        onAdClosed: (_) {
          debugPrint('Banner ad closed');
        },
        onAdImpression: (_) {
          debugPrint('Banner ad impression recorded');
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show nothing if ad is loading or failed (in production)
    if (!_isAdLoaded) {
      // In debug mode, optionally show a placeholder
      if (kDebugMode && _hasError && widget.minHeight != null) {
        return Container(
          height: widget.minHeight,
          alignment: Alignment.center,
          child: Text(
            'Ad unavailable\n(Error loading ad)',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        );
      }
      return SizedBox(height: widget.minHeight ?? 0);
    }

    if (_bannerAd == null) {
      return SizedBox(height: widget.minHeight ?? 0);
    }

    // Get the screen width to ensure the ad fits properly
    final screenWidth = MediaQuery.of(context).size.width;
    final adWidth = _bannerAd!.size.width.toDouble();
    final adHeight = _bannerAd!.size.height.toDouble();

    return Container(
      alignment: Alignment.center,
      width: adWidth > screenWidth ? screenWidth : adWidth,
      height: adHeight,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

