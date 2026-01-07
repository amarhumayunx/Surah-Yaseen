// Example: How to update RukuFirstScreen to use the new reusable widgets
// 
// This file demonstrates the migration from duplicate code to reusable widgets.
// Apply the same pattern to RukuSecondScreen, RukuThirdScreen, etc.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuButtonsUnderText.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuCard.dart' show RukuDetailCard;
import 'package:surah_yaseen/widgets/RukuScreen/RukuQuoteSection.dart';
import 'package:surah_yaseen/widgets/RukuScreen/RukuScreenTopBar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../../../Colors/colors.dart';
import '../../../constants/app_assets.dart';
import '../../Dividerbar/dividerbar.dart';

// Import the new reusable widgets
import 'ruku_config.dart';
import 'ruku_read_screen.dart';
import 'ruku_listen_audio_screen.dart';
import 'ruku_listen_audio_with_translation_screen.dart';

class RukuFirstScreenExample extends StatefulWidget {
  const RukuFirstScreenExample({super.key});

  @override
  State<RukuFirstScreenExample> createState() => _RukuFirstScreenExampleState();
}

class _RukuFirstScreenExampleState extends State<RukuFirstScreenExample> {
  // Define verses map for audio playback
  // This can be extracted from AppStrings or kept as a constant
  final Map<int, String> ruku1Verses = {
    0: "يس",
    1: "وَالْقُرْآنِ الْحَكِيمِ",
    2: "إِنَّكَ لَمِنَ الْمُرْسَلِينَ",
    3: "عَلَىٰ صِرَاطٍ مُّسْتَقِيمٍ",
    4: "تَنزِيلَ الْعَزِيزِ الرَّحِيمِ",
    5: "لِتُنذِرَ قَوْمًا مَّا أُنذِرَ آبَاؤُهُمْ فَهُمْ غَافِلُونَ",
    6: "لَقَدْ حَقَّ الْقَوْلُ عَلَىٰ أَكْثَرِهِمْ فَهُمْ لَا يُؤْمِنُونَ",
    7: "إِنَّا جَعَلْنَا فِي أَعْنَاقِهِمْ أَغْلَالًا فَهِيَ إِلَى الْأَذْقَانِ فَهُم مُّقْمَحُونَ",
    8: "وَجَعَلْنَا مِن بَيْنِ أَيْدِيهِمْ سَدًّا وَمِنْ خَلْفِهِمْ سَدًّا فَأَغْشَيْنَاهُمْ فَهُمْ لَا يُبْصِرُونَ",
    9: "وَسَوَاءٌ عَلَيْهِمْ أَأَنذَرْتَهُمْ أَمْ لَمْ تُنذِرْهُمْ لَا يُؤْمِنُونَ",
    10: "إِنَّمَا تُنذِرُ مَنِ اتَّبَعَ الذِّكْرَ وَخَشِيَ الرَّحْمَٰنَ بِالْغَيْبِ ۖ فَبَشِّرْهُ بِمَغْفِرَةٍ وَأَجْرٍ كَرِيمٍ",
    11: "إِنَّا نَحْنُ نُحْيِي الْمَوْتَىٰ وَنَكْتُبُ مَا قَدَّمُوا وَآثَارَهُمْ ۚ وَكُلَّ شَيْءٍ أَحْصَيْنَاهُ فِي إِمَامٍ مُّبِينٍ",
  };

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
    // Get configuration for Ruku 1
    final config = RukuConfig.getRukuConfig(1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
        children: [
          TopBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  const RukuScreenTopBar(),
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SizedBox(height: 10),
                  const SurahTitle(),
                  const SizedBox(height: 90),
                  RukuDetailCard(
                    imagePath: AppAssets.topcornerdecor,
                    title: config.titleKey.tr,
                    verseRange: config.verseRangeKey.tr,
                    imageTop: -8,
                    imageLeft: 3,
                    imageWidth: 55,
                    imageHeight: 55,
                  ),
                  const SizedBox(height: 10),
                  RukuQuoteSection(translationKey: config.quoteKey),
                  SizedBox(height: 10),
                  // Use the new reusable widgets instead of individual screen classes
                  RukuButtonsUnderText(
                    readScreen: RukuReadScreen(config: config),
                    listenAudioScreen: RukuListenAudioScreen(
                      config: config,
                      verses: ruku1Verses,
                    ),
                    listenAudioWithTranslationScreen: RukuListenAudioWithTranslationScreen(
                      config: config,
                      verses: ruku1Verses,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// Migration Checklist:
// ============================================
// 
// 1. ✅ Import new shared widgets
// 2. ✅ Get RukuConfig for the Ruku number
// 3. ✅ Define verses map (for audio screens)
// 4. ✅ Replace old widget instances
// 5. ✅ Update translation keys to use config
// 6. ⬜ Test the screen thoroughly
// 7. ⬜ Delete old duplicate files:
//    - RukuFirstReadScreen.dart
//    - ListenAudioRukuFirstScreen.dart
//    - ListenAudioWithTranslationRukuFirst.dart
//    - VersePageContainerRukuFirst.dart
//    - VersePageContainerArabicRukuFirst.dart
//    - VersePageContainerWithTranslationRukuFirst.dart
// 
// Repeat for RukuSecondScreen, RukuThirdScreen, RukuFourthScreen, RukuFiveScreen

