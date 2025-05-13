import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioScreen/ListenAudioScreenTopBar.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/ListenAudioRukuFirstAudioPlayer.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../../Colors/colors.dart';
import 'VersePageContainerArabicRukuFirst.dart';

class ListenAudioRukuFirstScreen extends StatefulWidget {
  const ListenAudioRukuFirstScreen({super.key});

  @override
  State<ListenAudioRukuFirstScreen> createState() => _ListenAudioScreenState();
}

class _ListenAudioScreenState extends State<ListenAudioRukuFirstScreen> {
  int _currentPage = 1;
  final int _totalPages = 2; // Total number of pages for Arabic verses

  // Track the active verse being spoken
  int _activeVerseIndex = -1;

  final Map<int, String> yaseen_verses = {
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
                children: [
                  const TopBarListenAudioScreen(),
                  const DividerBar(),
                  const SurahTitle(),
                  const SizedBox(height: 90),

                  ArabicVerseContainerRukuFirst(
                    rukuNumber: 1,
                    startVerseIndex: 1 + ((_currentPage - 1) * 6),
                    lastVerseIndex: 12,
                    versesPerPage: 6,
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    isListeningAudio: true,
                    onPrevPage: _goToPrevPage,
                    onNextPage: _goToNextPage,
                    activeVerseIndex: _activeVerseIndex, // Pass the active verse index
                  ),
                  SizedBox(height: 10),

                  // Pass a callback to the audio player to update active verse
                  ListenAudioRukuFirstAudioPlayer(
                    title: 'ruku_title_audio1'.tr,
                    verses: yaseen_verses,
                    startVerse: 0,
                    endVerse: 12,
                    onActiveVerseChanged: _handleActiveVerseChanged, // New callback
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