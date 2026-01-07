import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  bool _hasError = false;
  String? _errorMessage;

  // Use test ad unit ID for development, production ad unit ID for release
  // Test ad unit IDs always return test ads
  String get _adUnitId {
    if (kDebugMode) {
      // Test ad unit IDs - always return test ads
      // Android: ca-app-pub-3940256099942544/6300978111
      // iOS: ca-app-pub-3940256099942544/2934735716
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
    // Production ad unit ID
    return 'ca-app-pub-3425673808153409/1354707943';
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd?.dispose();
    
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isBannerAdReady = true;
              _hasError = false;
              _errorMessage = null;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          debugPrint('Error code: ${err.code}');
          debugPrint('Error domain: ${err.domain}');
          debugPrint('Error response info: ${err.responseInfo}');
          
          if (mounted) {
            setState(() {
              _isBannerAdReady = false;
              _hasError = true;
              _errorMessage = err.message;
            });
          }
          
          ad.dispose();
          
          // Error code 3 = ERROR_CODE_NO_FILL (no ad available)
          // This is common for new ad units. The ad will show once ads are available.
          if (err.code == 3) {
            debugPrint('No ad available (No fill). This is normal for new ad units.');
            debugPrint('The ad will appear once ads become available in your region.');
          }
        },
        onAdOpened: (_) {
          debugPrint('Banner ad opened.');
        },
        onAdClosed: (_) {
          debugPrint('Banner ad closed.');
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
    // Don't show anything if ad is not ready and there's no error
    // (ad might still be loading)
    if (!_isBannerAdReady && !_hasError) {
      return const SizedBox.shrink();
    }

    // If there's an error, show nothing (or optionally show a placeholder)
    if (_hasError) {
      // Optionally show a placeholder or retry button in debug mode
      if (kDebugMode) {
        return Container(
          height: AdSize.banner.height.toDouble(),
          alignment: Alignment.center,
          child: Text(
            'Ad unavailable\n(Error: ${_errorMessage ?? "Unknown"})',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

