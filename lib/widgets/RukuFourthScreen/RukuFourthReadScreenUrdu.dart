import 'package:flutter/material.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/ruku_fourth_read_banner_ad_widget.dart';

/// Ruku 4 Read screen with Urdu translation: Arabic + Urdu.
class RukuFourthReadScreenUrdu extends StatelessWidget {
  const RukuFourthReadScreenUrdu({super.key});

  @override
  Widget build(BuildContext context) {
    return RukuReadScreen(
      config: RukuConfig.getRukuConfig(4),
      useUrduTranslation: true,
      bannerAd: const Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: RukuFourthReadBannerAdWidget(),
          ),
        ),
      ),
    );
  }
}
