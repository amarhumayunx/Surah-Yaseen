import 'package:flutter/material.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/ruku_second_read_banner_ad_widget.dart';

/// Ruku 2 Read screen: shared RukuReadScreen + banner ad at bottom.
class RukuSecondReadScreen extends StatelessWidget {
  const RukuSecondReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RukuReadScreen(
      config: RukuConfig.getRukuConfig(2),
      bannerAd: const Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RukuSecondReadBannerAdWidget(),
          ),
        ),
      ),
    );
  }
}
