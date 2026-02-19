import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuButtonsUnderText.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuCard.dart' show RukuDetailCard;
import 'package:surah_yaseen/widgets/RukuScreen/RukuQuoteSection.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuScreenTopBar.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/ListenAudioRukuFourthScreen.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/ListenAudioWithTranslationRukuFourth.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/RukuFourthReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/ruku_fourth_banner_ad_widget.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../constants/app_assets.dart';
import '../widgets/Dividerbar/dividerbar.dart';

class RukuFourthScreen extends StatefulWidget {
  const RukuFourthScreen({super.key});

  @override
  State<RukuFourthScreen> createState() => _RukuFirstScreenState();
}

class _RukuFirstScreenState extends State<RukuFourthScreen> {
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
                    title: 'ruku_four'.tr,
                    verseRange: 'verse_title_fiftyone_to_sixtyseven'.tr,
                    imageTop: -8,
                    imageLeft: 3,
                    imageWidth: 55,
                    imageHeight: 55,
                  ),
                  const SizedBox(height: 10),
                  RukuQuoteSection(translationKey: 'text_under_card_ruku4'),
                  SizedBox(height: 10),
                  RukuButtonsUnderText(
                    rukuNumber: 4,
                    readScreen: const RukuFourthReadScreen(),
                    listenAudioScreen: const ListenAudioRukuFourthScreen(),
                    listenAudioWithTranslationScreen: const ListenAudioWithTranslationRukuFourth(),
                  ),
                ],
              ),
            ),
          ),
          // Banner ad anchored at the bottom
          const RukuFourthBannerAdWidget(),
        ],
      ),
    );
  }
}
