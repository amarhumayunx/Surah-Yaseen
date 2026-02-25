import 'package:flutter/material.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';
import 'package:surah_yaseen/widgets/RukuFivethScreen/ruku_fifth_read_banner_ad_widget.dart';

/// Ruku 5 Read screen: shared RukuReadScreen + banner ad at bottom.
class RukuFiveReadScreen extends StatelessWidget {
  const RukuFiveReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RukuReadScreen(
      config: RukuConfig.getRukuConfig(5),
      bannerAd: const Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RukuFifthReadBannerAdWidget(),
          ),
        ),
      ),
    );
  }
}
