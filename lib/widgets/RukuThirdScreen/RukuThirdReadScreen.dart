import 'package:flutter/material.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';
import 'package:surah_yaseen/widgets/RukuThirdScreen/ruku_third_read_banner_ad_widget.dart';

/// Ruku 3 Read screen: shared RukuReadScreen + banner ad at bottom.
class RukuThirdReadScreen extends StatelessWidget {
  const RukuThirdReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RukuReadScreen(
      config: RukuConfig.getRukuConfig(3),
      bannerAd: const Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RukuThirdReadBannerAdWidget(),
          ),
        ),
      ),
    );
  }
}
