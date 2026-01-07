import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuButtonsUnderText.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuCard.dart' show RukuDetailCard;
import 'package:surah_yaseen/widgets/RukuScreen/RukuQuoteSection.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuScreenTopBar.dart';
import 'package:surah_yaseen/widgets/RukuThirdScreen/ListenAudioRukuThirdScreen.dart';
import 'package:surah_yaseen/widgets/RukuThirdScreen/ListenAudioWithTranslationRukuThird.dart';
import 'package:surah_yaseen/widgets/RukuThirdScreen/RukuThirdReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuThirdScreen/ruku_third_banner_ad_widget.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../constants/app_assets.dart';
import '../widgets/Dividerbar/dividerbar.dart';

class RukuThirdScreen extends StatefulWidget {
  const RukuThirdScreen({super.key});

  @override
  State<RukuThirdScreen> createState() => _RukuFirstScreenState();
}

class _RukuFirstScreenState extends State<RukuThirdScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
        children: [
          TopBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  const RukuScreenTopBar(),
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SizedBox(height: 10),
                  const SurahTitle(),
                  const SizedBox(height: 80),
                  // Wrap the RukuCard with a container to set custom size for this screen
                  RukuDetailCard(
                    imagePath: AppAssets.topcornerdecor,
                    title: 'ruku_three'.tr,
                    verseRange: 'verse_title_thirtythree_to_fifty'.tr,
                    imageTop: -8,
                    imageLeft: 3,
                    imageWidth: 55,
                    imageHeight: 55,
                  ),
                  const SizedBox(height: 10),
                  RukuQuoteSection(translationKey: 'text_under_card_ruku3'),
                  SizedBox(height: 10),
                  RukuButtonsUnderText(
                    readScreen: const RukuThirdReadScreen(),
                    listenAudioScreen: const ListenAudioRukuThirdScreen(),
                    listenAudioWithTranslationScreen: const ListenAudioWithTranslationRukuThird(),
                  ),
                ],
              ),
            ),
          ),
          // Banner ad anchored at the bottom
          const RukuThirdBannerAdWidget(),
        ],
      ),
    );
  }
}
