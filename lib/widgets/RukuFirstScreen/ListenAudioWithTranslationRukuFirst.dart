import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioWithTranslation/ListenAudioWithTranslastionScreenTopbar.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/ListenAudioWithTranslationRukuFirstAudioPlayer.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/VersePageContainerWithTranslationRukuFirst.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';


class ListenAudioWithTranslationRukuFirst extends StatefulWidget {
  const ListenAudioWithTranslationRukuFirst({super.key});

  @override
  State<ListenAudioWithTranslationRukuFirst> createState() => _ListenAudioWithTranslationState();
}

class _ListenAudioWithTranslationState extends State<ListenAudioWithTranslationRukuFirst> {

  final Map<int, String> yaseen_verses = {
    0: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
    1: "يس",
    2: "وَالْقُرْآنِ الْحَكِيمِ",
    3: "إِنَّكَ لَمِنَ الْمُرْسَلِينَ",
    4: "عَلَىٰ صِرَاطٍ مُّسْتَقِيمٍ",
    5: "تَنزِيلَ الْعَزِيزِ الرَّحِيمِ",
    6: "لِتُنذِرَ قَوْمًا مَّا أُنذِرَ آبَاؤُهُمْ فَهُمْ غَافِلُونَ",
    7: "لَقَدْ حَقَّ الْقَوْلُ عَلَىٰ أَكْثَرِهِمْ فَهُمْ لَا يُؤْمِنُونَ",
    8: "إِنَّا جَعَلْنَا فِي أَعْنَاقِهِمْ أَغْلَالًا فَهِيَ إِلَى الْأَذْقَانِ فَهُم مُّقْمَحُونَ",
    9: "وَجَعَلْنَا مِن بَيْنِ أَيْدِيهِمْ سَدًّا وَمِنْ خَلْفِهِمْ سَدًّا فَأَغْشَيْنَاهُمْ فَهُمْ لَا يُبْصِرُونَ",
    10: "وَسَوَاءٌ عَلَيْهِمْ أَأَنذَرْتَهُمْ أَمْ لَمْ تُنذِرْهُمْ لَا يُؤْمِنُونَ",
    11: "إِنَّمَا تُنذِرُ مَنِ اتَّبَعَ الذِّكْرَ وَخَشِيَ الرَّحْمَٰنَ بِالْغَيْبِ ۖ فَبَشِّرْهُ بِمَغْفِرَةٍ وَأَجْرٍ كَرِيمٍ",
    12: "إِنَّا نَحْنُ نُحْيِي الْمَوْتَىٰ وَنَكْتُبُ مَا قَدَّمُوا وَآثَارَهُمْ ۚ وَكُلَّ شَيْءٍ أَحْصَيْنَاهُ فِي إِمَامٍ مُّبِينٍ",
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
                        ArabicVerseWithTranslationContainerRukuFirst(
                            rukuNumber: 1,
                            startVerseIndex: 0 + ((_currentPage - 1) * 6),
                            lastVerseIndex: 12,
                            versesPerPage: 6,
                            currentPage: _currentPage,
                            totalPages: _totalPages,
                            isListeningAudio: true,
                            onPrevPage: _goToPrevPage,
                            onNextPage: _goToNextPage,
                            activeVerseIndex: _activeVerseIndex,

                        ),
                        SizedBox(height: 10),
                        ListenAudioWithTranslationRukuFirstAudioPlayer(
                          title: 'ruku_title_audio_trans1'.tr,
                          verses: yaseen_verses,
                          startVerse: 0,  // Start from the first verse
                          endVerse: 12,    // End at verse 3
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
