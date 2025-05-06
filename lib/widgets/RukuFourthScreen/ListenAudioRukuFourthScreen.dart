import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioScreen/ListenAudioScreenTopBar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../../Colors/colors.dart';
import '../../constants/app_strings.dart';
import 'ListenAudioRukuFourthAudioPlayer.dart';
import 'VersePageContainerArabicRukuFourth.dart';

class ListenAudioRukuFourthScreen extends StatefulWidget {
  const ListenAudioRukuFourthScreen({super.key});

  @override
  State<ListenAudioRukuFourthScreen> createState() => _ListenAudioScreenState();
}

class _ListenAudioScreenState extends State<ListenAudioRukuFourthScreen> {

  final String audioPath = 'asset:///assets/audio/surahyaseenrukufour51to67.mp3';

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
  final int _totalPages = 3; // Total number of pages for Arabic verses

  void _handlePageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
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
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SurahTitle(),
                  const SizedBox(height: 70),

                  // Verse Container
                  ArabicVerseContainerRukuFourth(
                    rukuNumber: 4, // Example ruku number
                    startVerseIndex: 51 + ((_currentPage - 1) * 6), // Calculate start verse based on current page
                    lastVerseIndex: 67, // Last verse index
                    versesPerPage: 6, // Number of verses per page
                    currentPage: _currentPage, // Current page from state
                    totalPages: _totalPages, // Total number of pages
                    isListeningAudio: true, // This is audio mode
                    onPrevPage: _goToPrevPage, // Use the method to go to previous page
                    onNextPage: _goToNextPage, // Use the method to go to next page
                  ),
                  SizedBox(height: 10),
                  ListenAudioRukuFourthAudioPlayer(
                    title: AppStrings.listenAudioScreenString.Rukutitle4,
                    verses: yaseen_verses,
                    startVerse: 51,
                    endVerse: 67,
                  ),
                  // Add more widgets like audio player or list here if needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
