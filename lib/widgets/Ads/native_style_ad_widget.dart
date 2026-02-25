import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../Colors/colors.dart';
import '../../constants/ad_unit_ids.dart';
import 'styled_ad_card.dart';
import 'reusable_banner_ad.dart';

/// Shows an ad in the native-style layout from the design: white card with
/// rounded corners, shadow, and "Ad" badge. Uses Native Ad (medium template)
/// when available so the ad looks like the reference (icon, title, description,
/// rating, CTA). Falls back to banner inside the same card if native fails.
class NativeStyleAdWidget extends StatefulWidget {
  final AdScreenType screenType;
  final double? minHeight;

  const NativeStyleAdWidget({
    super.key,
    required this.screenType,
    this.minHeight,
  });

  @override
  State<NativeStyleAdWidget> createState() => _NativeStyleAdWidgetState();
}

class _NativeStyleAdWidgetState extends State<NativeStyleAdWidget> {
  NativeAd? _nativeAd;
  bool _nativeLoaded = false;
  bool _nativeLoadFailed = false;
  Timer? _timeoutTimer;

  /// Single AdWidget instance per ad - prevents "already in the Widget tree" error on rebuild.
  Widget? _cachedAdWidget;

  static const Duration _loadTimeout = Duration(seconds: 15);

  static NativeTemplateStyle _templateStyle() {
    return NativeTemplateStyle(
      templateType: TemplateType.medium,
      mainBackgroundColor: Colors.white,
      cornerRadius: 14,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: Colors.white,
        backgroundColor: AppColors.colorone,
        size: 14,
      ),
      primaryTextStyle: NativeTemplateTextStyle(
        textColor: const Color(0xFF212121),
        size: 16,
      ),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: const Color(0xFF616161),
        size: 13,
      ),
    );
  }

  String get _nativeAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? AdUnitIds.testNativeAdAndroid
          : AdUnitIds.testNativeAdIOS;
    }
    return AdUnitIds.getNativeAdUnitId(widget.screenType) ??
        AdUnitIds.nativeAdHome;
  }

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    _timeoutTimer = Timer(_loadTimeout, _onTimeout);

    _nativeAd = NativeAd(
      adUnitId: _nativeAdUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _timeoutTimer?.cancel();
          if (mounted) {
            setState(() => _nativeLoaded = true);
          }
          debugPrint('Native ad loaded: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (ad, error) {
          _timeoutTimer?.cancel();
          ad.dispose();
          _nativeAd = null;
          if (mounted) {
            setState(() {
              _nativeLoaded = false;
              _nativeLoadFailed = true;
            });
          }
          debugPrint('Native ad failed to load: ${error.message} (code: ${error.code})');
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: _templateStyle(),
    );
    _nativeAd!.load();
  }

  void _onTimeout() {
    if (_nativeLoaded || _nativeLoadFailed) return;
    debugPrint('Native ad timed out after ${_loadTimeout.inSeconds}s – falling back to banner');
    _nativeAd?.dispose();
    _nativeAd = null;
    if (mounted) {
      setState(() {
        _nativeLoadFailed = true;
      });
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _cachedAdWidget = null;
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_nativeLoaded && _nativeAd != null) {
      final ad = _nativeAd!;
      _cachedAdWidget ??= AdWidget(key: ValueKey(ad.hashCode), ad: ad);
      return StyledAdCard(
        minHeight: widget.minHeight ?? 120,
        padding: const EdgeInsets.fromLTRB(12, 28, 12, 12),
        child: SizedBox(height: 280, child: _cachedAdWidget),
      );
    }

    if (!_nativeLoadFailed) {
      return StyledAdCard(
        minHeight: widget.minHeight ?? 120,
        child: Center(
          child: LoadingAnimationWidget.discreteCircle(
            color: AppColors.PrimaryColor,
            size: 48,
          ),
        ),
      );
    }

    // Fallback: banner in the same styled card when native fails or times out
    return StyledAdCard(
      minHeight: widget.minHeight ?? 60,
      child: ReusableBannerAd(screenType: widget.screenType, minHeight: 50),
    );
  }
}
