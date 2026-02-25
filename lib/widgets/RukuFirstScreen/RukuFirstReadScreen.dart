import 'package:flutter/material.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/ruku_first_read_banner_ad_widget.dart';

/// Ruku 1 Read screen: shared RukuReadScreen + banner ad at bottom.
class RukuFirstReadScreen extends StatelessWidget {
  const RukuFirstReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RukuReadScreen(
      config: RukuConfig.getRukuConfig(1),
      bannerAd: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: const RukuFirstReadBannerAdWidget(),
          ),
        ),
      ),
    );
  }
}
