import 'package:flutter/material.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/ruku_second_read_banner_ad_widget.dart';

/// Ruku 2 Read screen with Urdu translation: Arabic + Urdu.
class RukuSecondReadScreenUrdu extends StatelessWidget {
  const RukuSecondReadScreenUrdu({super.key});

  @override
  Widget build(BuildContext context) {
    return RukuReadScreen(
      config: RukuConfig.getRukuConfig(2),
      useUrduTranslation: true,
      bannerAd: const Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: RukuSecondReadBannerAdWidget(),
          ),
        ),
      ),
    );
  }
}
