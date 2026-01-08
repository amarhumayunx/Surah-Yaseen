import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../constants/ad_unit_ids.dart';

/// Anchored adaptive banner ad widget for RukuSecondAudioWithTranslationScreen
/// Follows Google Mobile Ads SDK best practices for anchored adaptive banners
class RukuSecondAudioWithTranslationBannerAdWidget extends StatefulWidget {
  const RukuSecondAudioWithTranslationBannerAdWidget({super.key});

  @override
  State<RukuSecondAudioWithTranslationBannerAdWidget> createState() =>
      _RukuSecondAudioWithTranslationBannerAdWidgetState();
}

class _RukuSecondAudioWithTranslationBannerAdWidgetState
    extends State<RukuSecondAudioWithTranslationBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  bool _hasError = false;
  String? _errorMessage;
  AdSize? _adSize;

  // Get ad unit ID - use test ads in debug mode, production in release
  String get _adUnitId {
    if (kDebugMode) {
      // Test ad unit IDs - always return test ads
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/9214589741';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
    // Production ad unit ID for RukuSecondAudioWithTranslationScreen
    return AdUnitIds.rukuSecondAudioWithTranslationScreenBanner;
  }

  @override
  void initState() {
    super.initState();
    // Load ad after the first frame to ensure MediaQuery is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBannerAd();
    });
  }

  Future<void> _loadBannerAd() async {
    if (!mounted) return;

    // Get the width of the device's screen in density-independent pixels
    final width = MediaQuery.sizeOf(context).width.truncate();

    // Get an AnchoredAdaptiveBannerAdSize before loading the ad
    final size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (size == null) {
      debugPrint('Unable to get width of anchored banner.');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Unable to get ad size';
        });
      }
      return;
    }

    if (!mounted) return;

    setState(() {
      _adSize = size;
    });

    // Dispose previous ad if exists
    _bannerAd?.dispose();

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Called when an ad is successfully received.
          debugPrint('Ad was loaded.');
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              _isBannerAdReady = true;
              _hasError = false;
              _errorMessage = null;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          // Called when an ad request failed.
          debugPrint('Ad failed to load with error: $err');
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
        onAdOpened: (Ad ad) {
          // Called when an ad opens an overlay that covers the screen.
          debugPrint('Ad was opened.');
        },
        onAdClosed: (Ad ad) {
          // Called when an ad removes an overlay that covers the screen.
          debugPrint('Ad was closed.');
        },
        onAdImpression: (Ad ad) {
          // Called when an impression occurs on the ad.
          debugPrint('Ad recorded an impression.');
        },
        onAdClicked: (Ad ad) {
          // Called when a click event occurs on the ad.
          debugPrint('Ad was clicked.');
        },
        onAdWillDismissScreen: (Ad ad) {
          // iOS only. Called before dismissing a full screen view.
          debugPrint('Ad will be dismissed.');
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
          height: _adSize?.height.toDouble() ?? AdSize.banner.height.toDouble(),
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

    // Display the banner ad
    if (_bannerAd != null && _adSize != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: SizedBox(
            width: _adSize!.width.toDouble(),
            height: _adSize!.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
