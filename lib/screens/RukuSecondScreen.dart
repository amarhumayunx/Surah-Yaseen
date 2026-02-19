import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuButtonsUnderText.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuCard.dart' show RukuDetailCard;
import 'package:surah_yaseen/widgets/RukuScreen/RukuQuoteSection.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuScreenTopBar.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/ListenAudioRukuSecondScreen.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/ListenAudioWithTranslationRukuSecond.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/RukuSecondReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/ruku_second_banner_ad_widget.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../constants/app_assets.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/SurahTitle/surat_title.dart';

class RukuSecondScreen extends StatefulWidget {
  const RukuSecondScreen({super.key});

  @override
  State<RukuSecondScreen> createState() => _RukuSecondScreenState();
}

class _RukuSecondScreenState extends State<RukuSecondScreen> {

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
              child: Padding(padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20
              ),
              child: Column(
                children: [
                  const RukuScreenTopBar(),
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SizedBox(height: 10),
                  const SurahTitle(),
                  const SizedBox(height: 80),

                  RukuDetailCard(
                    imagePath: AppAssets.topcornerdecor,
                    title: 'ruku_two'.tr,
                    verseRange: 'verse_title_thirteen_to_thirtytwo'.tr,
                    imageTop: -8,
                    imageLeft: 3,
                    imageWidth: 55,
                    imageHeight: 55,
                  ),
                  SizedBox(height: 10),
                  RukuQuoteSection(translationKey: 'text_under_card_ruku2'),
                  SizedBox(height: 10),
                  RukuButtonsUnderText(
                    rukuNumber: 2,
                    readScreen: const RukuSecondReadScreen(),
                    listenAudioScreen: const ListenAudioRukuSecondScreen(),
                    listenAudioWithTranslationScreen: const ListenAudioWithTranslationRukuSecond(),
                  ),

                ],
              ),
              )),
          // Banner ad anchored at the bottom
          const RukuSecondBannerAdWidget(),
        ],
      ),
    );
  }
}
