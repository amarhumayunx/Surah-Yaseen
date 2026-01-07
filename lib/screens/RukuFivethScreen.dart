import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../constants/app_assets.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuButtonsUnderText.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuCard.dart' show RukuDetailCard;
import 'package:surah_yaseen/widgets/RukuScreen/RukuQuoteSection.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuScreenTopBar.dart';
import 'package:surah_yaseen/widgets/RukuFivethScreen/ListenAudioRukuFiveScreen.dart';
import 'package:surah_yaseen/widgets/RukuFivethScreen/ListenAudioWithTranslationRukuFive.dart';
import 'package:surah_yaseen/widgets/RukuFivethScreen/RukuFiveReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuFivethScreen/ruku_fifth_banner_ad_widget.dart';

class RukuFiveScreen extends StatefulWidget {
  const RukuFiveScreen({super.key});

  @override
  State<RukuFiveScreen> createState() => _RukuFirstScreenState();
}

class _RukuFirstScreenState extends State<RukuFiveScreen> {
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
                    title: 'ruku_five'.tr,
                    verseRange: 'verse_title_sixtyeight_to_eightythree'.tr,
                    imageTop: -8,
                    imageLeft: 3,
                    imageWidth: 55,
                    imageHeight: 55,
                  ),
                  const SizedBox(height: 10),
                  RukuQuoteSection(translationKey: 'text_under_card_ruku5'),
                  SizedBox(height: 10),
                  RukuButtonsUnderText(
                    readScreen: const RukuFiveReadScreen(),
                    listenAudioScreen: const ListenAudioRukuFiveScreen(),
                    listenAudioWithTranslationScreen: const ListenAudioWithTranslationRukuFive(),
                  ),
                ],
              ),
            ),
          ),
          // Banner ad anchored at the bottom
          const RukuFifthBannerAdWidget(),
        ],
      ),
    );
  }
}
