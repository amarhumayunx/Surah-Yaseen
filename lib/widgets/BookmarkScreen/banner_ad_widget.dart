import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  final AdSize? adSize;

  const BannerAdWidget({
    super.key,
    required this.adUnitId,
    this.adSize,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (_isAdLoading) return;

    setState(() {
      _isAdLoading = true;
    });

    // Use test ad unit ID in debug mode, otherwise use the provided ad unit ID
    final String adUnitId = kDebugMode 
        ? 'ca-app-pub-3940256099942544/6300978111' // Google's test banner ad unit
        : widget.adUnitId;

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
            });
          }
          debugPrint('Banner ad loaded successfully');
        },
        onAdFailedToLoad: (ad, error) {
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
              _isAdLoading = false;
            });
          }
          // Dispose the ad if it failed to load
          ad.dispose();
          _bannerAd = null;
          
          // Log error for debugging
          debugPrint('Banner ad failed to load: ${error.code} - ${error.message}');
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
    // Don't show anything if ad is loading or failed
    if (!_isAdLoaded) {
      return const SizedBox.shrink();
    }

    if (_bannerAd == null) {
      return const SizedBox.shrink();
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

