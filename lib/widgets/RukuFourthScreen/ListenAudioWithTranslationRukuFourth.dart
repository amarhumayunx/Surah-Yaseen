import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioWithTranslation/ListenAudioWithTranslastionScreenTopbar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';

import '../../constants/app_strings.dart';
import 'ListenAudioWithTranslationRukuFourthAudioPlayer.dart';
import 'VersePageContainerWithTranslationRukuFourth.dart';

class ListenAudioWithTranslationRukuFourth extends StatefulWidget {
  const ListenAudioWithTranslationRukuFourth({super.key});

  @override
  State<ListenAudioWithTranslationRukuFourth> createState() => _ListenAudioWithTranslationState();
}

class _ListenAudioWithTranslationState extends State<ListenAudioWithTranslationRukuFourth> {

  final Map<int, String> yaseen_verses = {
    51: "وَنُفِخَ فِي الصُّورِ فَإِذَا هُمْ مِنَ الْأَجْدَاثِ إِلَىٰ رَبِّهِمْ يَنْسِلُونَ",
    52: "قَالُوا يَا وَيْلَنَا مَنْ بَعَثَنَا مِنْ مَرْقَدِنَا ۜ ۗ هَٰذَا مَا وَعَدَ الرَّحْمَٰنُ وَصَدَقَ الْمُرْسَلُونَ",
    53: "إِنْ كَانَتْ إِلَّا صَيْحَةً وَاحِدَةً فَإِذَا هُمْ جَمِيعٌ لَدَيْنَا مُحْضَرُونَ",
    54: "فَالْيَوْمَ لَا تُظْلَمُ نَفْسٌ شَيْئًا وَلَا تُجْزَوْنَ إِلَّا مَا كُنْتُمْ تَعْمَلُونَ",
    55: "إِنَّ أَصْحَابَ الْجَنَّةِ الْيَوْمَ فِي شُغُلٍ فَاكِهُونَ",
    56: "هُمْ وَأَزْوَاجُهُمْ فِي ظِلَالٍ عَلَى الْأَرَائِكِ مُتَّكِئُونَ",
    57: "لَهُمْ فِيهَا فَاكِهَةٌ وَلَهُمْ مَا يَدَّعُونَ",
    58: "سَلَامٌ قَوْلًا مِنْ رَبٍّ رَحِيمٍ",
    59: "وَامْتَازُوا الْيَوْمَ أَيُّهَا الْمُجْرِمُونَ ۞",
    60: " أَلَمْ أَعْهَدْ إِلَيْكُمْ يَا بَنِي آدَمَ أَنْ لَا تَعْبُدُوا الشَّيْطَانَ ۖ إِنَّهُ لَكُمْ عَدُوٌّ مُبِينٌ",
    61: "وَأَنِ اعْبُدُونِي ۚ هَٰذَا صِرَاطٌ مُسْتَقِيمٌ",
    62: "وَلَقَدْ أَضَلَّ مِنْكُمْ جِبِلًّا كَثِيرًا ۖ أَفَلَمْ تَكُونُوا تَعْقِلُونَ",
    63: "هَٰذِهِ جَهَنَّمُ الَّتِي كُنْتُمْ تُوعَدُونَ",
    64: "اصْلَوْهَا الْيَوْمَ بِمَا كُنْتُمْ تَكْفُرُونَ",
    65: "الْيَوْمَ نَخْتِمُ عَلَىٰ أَفْوَاهِهِمْ وَتُكَلِّمُنَا أَيْدِيهِمْ وَتَشْهَدُ أَرْجُلُهُمْ بِمَا كَانُوا يَكْسِبُونَ",
    66: "وَلَوْ نَشَاءُ لَطَمَسْنَا عَلَىٰ أَعْيُنِهِمْ فَاسْتَبَقُوا الصِّرَاطَ فَأَنَّىٰ يُبْصِرُونَ",
    67: "وَلَوْ نَشَاءُ لَمَسَخْنَاهُمْ عَلَىٰ مَكَانَتِهِمْ فَمَا اسْتَطَاعُوا مُضِيًّا وَلَا يَرْجِعُونَ"
  };

  int _currentPage = 1;
  final int _totalPages = 3;
  int _activeVerseIndex = -1;

  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToPrevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  // New method to handle active verse changes from audio player
  void _handleActiveVerseChanged(int verseIndex) {
    setState(() {
      _activeVerseIndex = verseIndex;

      // Auto-navigate to the page containing the active verse if needed
      int versesPerPage = 6;
      int targetPage = (verseIndex / versesPerPage).floor() + 1;

      if (_currentPage != targetPage && targetPage <= _totalPages && targetPage > 0) {
        _currentPage = targetPage;
      }
    });
  }

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
          children: [
            const TopBackground(),
            SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  child: Column(
                      children:
                      [
                        TopBarListenAudioWithTranslationScreen(),
                        DividerBar(),
                        SurahTitle(),
                        const SizedBox(height: 90),
                        ArabicVerseWithTranslationContainerRukuFourth(
                          rukuNumber: 4,
                          startVerseIndex: 51 + ((_currentPage - 1) * 6),
                          lastVerseIndex: 67,
                          versesPerPage: 6,
                          currentPage: _currentPage,
                          totalPages: _totalPages,
                          isListeningAudio: true,
                          onPrevPage: _goToPrevPage,
                          onNextPage: _goToNextPage,
                          activeVerseIndex: _activeVerseIndex,

                        ),
                        SizedBox(height: 10),
                        ListenAudioWithTranslationRukuFourthAudioPlayer(
                          title: AppStrings.listenAudioWithTranslationScreenString.Ruku4title,
                          verses: yaseen_verses,
                          startVerse: 51,
                          endVerse: 67,
                          onActiveVerseChanged: _handleActiveVerseChanged,
                        ),
                      ]
                  ),
                ))
          ]
      ),
    );
  }
}
