import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuButtonsUnderText.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuCard.dart'
    show RukuDetailCard;
import 'package:surah_yaseen/widgets/RukuScreen/RukuQuoteSection.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuScreenTopBar.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/ListenAudioRukuFourthScreen.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/ListenAudioWithTranslationRukuFourth.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/RukuFourthReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/RukuFourthReadScreenUrdu.dart';
import 'package:surah_yaseen/widgets/AdaptiveScrollView/adaptive_scroll_view.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/ruku_fourth_banner_ad_widget.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/TopBar/topbartest.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../constants/app_constants.dart';
import '../constants/ad_unit_ids.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double spacing = screenHeight * 0.02;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
        children: [
          TopBackground(),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: spacing),
                const TopBarSet(),
                SizedBox(height: spacing),
                const DividerBar(),
                SizedBox(height: spacing),
                const SurahTitle(),
                SizedBox(height: 60),

                Expanded(
                  child: Stack(
                    children: [
                      AdaptiveScrollView(
                        hasAd: true,
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.03),
                            RukuDetailCard(
                              imagePath: AppAssets.topcornerdecor,
                              title: 'ruku_four'.tr,
                              verseRange:
                                  'verse_title_fiftyone_to_sixtyseven'.tr,
                              imageTop: -8,
                              imageLeft: 3,
                              imageWidth: screenWidth * 0.14,
                              imageHeight: screenWidth * 0.14,
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            RukuQuoteSection(
                              translationKey: 'text_under_card_ruku4',
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            RukuButtonsUnderText(
                              rukuNumber: 4,
                              screenType: AdScreenType.rukuFourth,
                              readScreen: const RukuFourthReadScreen(),
                              readScreenWithUrdu: const RukuFourthReadScreenUrdu(),
                              listenAudioScreen:
                                  const ListenAudioRukuFourthScreen(),
                              listenAudioWithTranslationScreen:
                                  const ListenAudioWithTranslationRukuFourth(),
                            ),
                            SizedBox(
                              height:
                                  AppConstants.bannerAdBottomPadding +
                                  screenHeight * 0.05,
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Container(
                            height: screenHeight * 0.04,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.lightColorSec,
                                  AppColors.lightColorSec.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const RukuFourthBannerAdWidget(),
        ],
      ),
    );
  }
}
