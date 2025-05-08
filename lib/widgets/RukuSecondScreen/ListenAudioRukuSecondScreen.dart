import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioScreen/ListenAudioScreenTopBar.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/ListenAudioRukuSecondAudioPlayer.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/VersePageContainerArabicRukuSecond.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../../Colors/colors.dart';
import '../../constants/app_strings.dart';

class ListenAudioRukuSecondScreen extends StatefulWidget {
  const ListenAudioRukuSecondScreen({super.key});

  @override
  State<ListenAudioRukuSecondScreen> createState() => _ListenAudioRukuSecondScreenState();
}

class _ListenAudioRukuSecondScreenState extends State<ListenAudioRukuSecondScreen> {

  final Map<int, String> yaseen_verses = {
    13: "وَاضْرِبْ لَهُمْ مَثَلًا أَصْحَابَ الْقَرْيَةِ إِذْ جَاءَهَا الْمُرْسَلُونَ",
    14: "إِذْ أَرْسَلْنَا إِلَيْهِمُ اثْنَيْنِ فَكَذَّبُوهُمَا فَعَزَّزْنَا بِثَالِثٍ فَقَالُوا إِنَّا إِلَيْكُمْ مُرْسَلُونَ",
    15: "قَالُوا مَا أَنْتُمْ إِلَّا بَشَرٌ مِثْلُنَا وَمَا أَنْزَلَ الرَّحْمَٰنُ مِنْ شَيْءٍ إِنْ أَنْتُمْ إِلَّا تَكْذِبُونَ",
    16: "قَالُوا رَبُّنَا يَعْلَمُ إِنَّا إِلَيْكُمْ لَمُرْسَلُونَ",
    17: "وَمَا عَلَيْنَا إِلَّا الْبَلَاغُ الْمُبِينُ",
    18: "قَالُوا إِنَّا تَطَيَّرْنَا بِكُمْ ۖ لَئِنْ لَمْ تَنْتَهُوا لَنَرْجُمَنَّكُمْ وَلَيَمَسَّنَّكُمْ مِنَّا عَذَابٌ أَلِيمٌ",
    19: "قَالُوا طَائِرُكُمْ مَعَكُمْ ۚ أَئِنْ ذُكِّرْتُمْ ۚ بَلْ أَنْتُمْ قَوْمٌ مُسْرِفُونَ",
    20: "وَجَاءَ مِنْ أَقْصَى الْمَدِينَةِ رَجُلٌ يَسْعَىٰ قَالَ يَا قَوْمِ اتَّبِعُوا الْمُرْسَلِينَ",
    21: "اتَّبِعُوا مَنْ لَا يَسْأَلُكُمْ أَجْرًا وَهُمْ مُهْتَدُونَ",
    22: "وَمَا لِيَ لَا أَعْبُدُ الَّذِي فَطَرَنِي وَإِلَيْهِ تُرْجَعُونَ",
    23: "أَأَتَّخِذُ مِنْ دُونِهِ آلِهَةً إِنْ يُرِدْنِ الرَّحْمَٰنُ بِضُرٍّ لَا تُغْنِ عَنِّي شَفَاعَتُهُمْ شَيْئًا وَلَا يُنْقِذُونِ",
    24: "إِنِّي إِذًا لَفِي ضَلَالٍ مُبِينٍ",
    25: "إِنِّي آمَنْتُ بِرَبِّكُمْ فَاسْمَعُونِ",
    26: "قِيلَ ادْخُلِ الْجَنَّةَ ۖ قَالَ يَا لَيْتَ قَوْمِي يَعْلَمُونَ",
    27: "بِمَا غَفَرَ لِي رَبِّي وَجَعَلَنِي مِنَ الْمُكْرَمِينَ ۞",
    28: "وَمَا أَنْزَلْنَا عَلَىٰ قَوْمِهِ مِنْ بَعْدِهِ مِنْ جُنْدٍ مِنَ السَّمَاءِ وَمَا كُنَّا مُنْزِلِينَ",
    29: "إِنْ كَانَتْ إِلَّا صَيْحَةً وَاحِدَةً فَإِذَا هُمْ خَامِدُونَ",
    30: "يَا حَسْرَةً عَلَى الْعِبَادِ ۚ مَا يَأْتِيهِمْ مِنْ رَسُولٍ إِلَّا كَانُوا بِهِ يَسْتَهْزِئُونَ",
    31: "أَلَمْ يَرَوْا كَمْ أَهْلَكْنَا قَبْلَهُمْ مِنَ الْقُرُونِ أَنَّهُمْ إِلَيْهِمْ لَا يَرْجِعُونَ",
    32: "وَإِنْ كُلٌّ لَمَّا جَمِيعٌ لَدَيْنَا مُحْضَرُونَ",
  };

  int _currentPage = 1;
  final int _totalPages = 4; // Total number of pages for Arabic verses
  int _activeVerseIndex = -1; // Set initial active verse to the first verse (13)
  final int _versesPerPage = 6; // Define as a constant for consistency

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
      int targetPage = ((verseIndex - 13) / _versesPerPage).floor() + 1;

      if (_currentPage != targetPage && targetPage <= _totalPages && targetPage > 0) {
        _currentPage = targetPage;
      }
    });
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
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SurahTitle(),
                  const SizedBox(height: 70),

                  // Verse Container
                  ArabicVerseContainerRukuSecond(
                    rukuNumber: 2,
                    startVerseIndex: 13 + ((_currentPage - 1) * _versesPerPage), // Use the constant
                    lastVerseIndex: 32,
                    versesPerPage: _versesPerPage, // Use the constant
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    isListeningAudio: true,
                    onPrevPage: _goToPrevPage,
                    onNextPage: _goToNextPage,
                    activeVerseIndex: _activeVerseIndex,
                  ),
                  const SizedBox(height: 10), // Use const for static sizes
                  ListenAudioRukuSecondAudioPlayer(
                    title: AppStrings.listenAudioScreenString.Rukutitle2,
                    verses: yaseen_verses,
                    startVerse: 13,
                    endVerse: 32,
                    onActiveVerseChanged: _handleActiveVerseChanged,
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