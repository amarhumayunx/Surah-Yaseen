import 'package:flutter/material.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';
import 'package:surah_yaseen/widgets/RukuThirdScreen/ruku_third_read_banner_ad_widget.dart';

/// Ruku 3 Read screen with Urdu translation: Arabic + Urdu.
class RukuThirdReadScreenUrdu extends StatelessWidget {
  const RukuThirdReadScreenUrdu({super.key});

  @override
  Widget build(BuildContext context) {
    return RukuReadScreen(
      config: RukuConfig.getRukuConfig(3),
      useUrduTranslation: true,
      bannerAd: const Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: RukuThirdReadBannerAdWidget(),
          ),
        ),
      ),
    );
  }
}
