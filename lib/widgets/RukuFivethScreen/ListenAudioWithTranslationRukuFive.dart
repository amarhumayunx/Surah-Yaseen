import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioWithTranslation/ListenAudioWithTranslastionScreenTopbar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';

import '../../constants/app_strings.dart';
import 'ListenAudioWithTranslationRukuFiveAudioPlayer.dart';
import 'VersePageContainerWithTranslationRukuFive.dart';

class ListenAudioWithTranslationRukuFive extends StatefulWidget {
  const ListenAudioWithTranslationRukuFive({super.key});

  @override
  State<ListenAudioWithTranslationRukuFive> createState() => _ListenAudioWithTranslationState();
}

class _ListenAudioWithTranslationState extends State<ListenAudioWithTranslationRukuFive> {

  final Map<int, String> yaseen_verses = {
    68: "وَمَنْ نُعَمِّرْهُ نُنَكِّسْهُ فِي الْخَلْقِ ۖ أَفَلَا يَعْقِلُونَ",
    69: "وَمَا عَلَّمْنَاهُ الشِّعْرَ وَمَا يَنْبَغِي لَهُ ۚ إِنْ هُوَ إِلَّا ذِكْرٌ وَقُرْآنٌ مُبِينٌ",
    70: "لِيُنْذِرَ مَنْ كَانَ حَيًّا وَيَحِقَّ الْقَوْلُ عَلَى الْكَافِرِينَ",
    71: "أَوَلَمْ يَرَوْا أَنَّا خَلَقْنَا لَهُمْ مِمَّا عَمِلَتْ أَيْدِينَا أَنْعَامًا فَهُمْ لَهَا مَالِكُونَ",
    72: "وَذَلَّلْنَاهَا لَهُمْ فَمِنْهَا رَكُوبُهُمْ وَمِنْهَا يَأْكُلُونَ",
    73: "وَلَهُمْ فِيهَا مَنَافِعُ وَمَشَارِبُ ۖ أَفَلَا يَشْكُرُونَ",
    74: "وَاتَّخَذُوا مِنْ دُونِ اللَّهِ آلِهَةً لَعَلَّهُمْ يُنْصَرُونَ",
    75: "لَا يَسْتَطِيعُونَ نَصْرَهُمْ وَهُمْ لَهُمْ جُنْدٌ مُحْضَرُونَ",
    76: "فَلَا يَحْزُنْكَ قَوْلُهُمْ ۘ إِنَّا نَعْلَمُ مَا يُسِرُّونَ وَمَا يُعْلِنُونَ",
    77: "أَوَلَمْ يَرَ الْإِنْسَانُ أَنَّا خَلَقْنَاهُ مِنْ نُطْفَةٍ فَإِذَا هُوَ خَصِيمٌ مُبِينٌ",
    78: "وَضَرَبَ لَنَا مَثَلًا وَنَسِيَ خَلْقَهُ ۖ قَالَ مَنْ يُحْيِي الْعِظَامَ وَهِيَ رَمِيمٌ",
    79: "قُلْ يُحْيِيهَا الَّذِي أَنْشَأَهَا أَوَّلَ مَرَّةٍ ۖ وَهُوَ بِكُلِّ خَلْقٍ عَلِيمٌ",
    80: "الَّذِي جَعَلَ لَكُمْ مِنَ الشَّجَرِ الْأَخْضَرِ نَارًا فَإِذَا أَنْتُمْ مِنْهُ تُوقِدُونَ",
    81: "أَوَلَيْسَ الَّذِي خَلَقَ السَّمَاوَاتِ وَالْأَرْضَ بِقَادِرٍ عَلَىٰ أَنْ يَخْلُقَ مِثْلَهُمْ ۚ بَلَىٰ وَهُوَ الْخَلَّاقُ الْعَلِيمُ",
    82: "إِنَّمَا أَمْرُهُ إِذَا أَرَادَ شَيْئًا أَنْ يَقُولَ لَهُ كُنْ فَيَكُونُ",
    83: "فَسُبْحَانَ الَّذِي بِيَدِهِ مَلَكُوتُ كُلِّ شَيْءٍ وَإِلَيْهِ تُرْجَعُونَ"
  };

  int _currentPage = 1;
  final int _totalPages = 8;
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
                        ArabicVerseWithTranslationContainerRukuFive(
                          rukuNumber: 5,
                          startVerseIndex: 68 + ((_currentPage - 1) * 6),
                          lastVerseIndex: 83,
                          versesPerPage: 6,
                          currentPage: _currentPage,
                          totalPages: _totalPages,
                          isListeningAudio: true,
                          onPrevPage: _goToPrevPage,
                          onNextPage: _goToNextPage,
                          activeVerseIndex: _activeVerseIndex,

                        ),
                        SizedBox(height: 10),
                        ListenAudioWithTranslationRukuFiveAudioPlayer(
                          title: AppStrings.listenAudioWithTranslationScreenString.Ruku5title,
                          verses: yaseen_verses,
                          startVerse: 68,
                          endVerse: 83,
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
