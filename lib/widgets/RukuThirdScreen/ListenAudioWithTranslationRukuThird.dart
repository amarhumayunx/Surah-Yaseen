import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioWithTranslation/ListenAudioWithTranslastionScreenTopbar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import 'ListenAudioWithTranslationRukuThirdAudioPlayer.dart';
import 'VersePageContainerWithTranslationRukuThird.dart';

class ListenAudioWithTranslationRukuThird extends StatefulWidget {
  const ListenAudioWithTranslationRukuThird({super.key});

  @override
  State<ListenAudioWithTranslationRukuThird> createState() => _ListenAudioWithTranslationState();
}

class _ListenAudioWithTranslationState extends State<ListenAudioWithTranslationRukuThird> {

  final Map<int ,String> yaseen_verses = {
    33: "وَآيَةٌ لَهُمُ الْأَرْضُ الْمَيْتَةُ أَحْيَيْنَاهَا وَأَخْرَجْنَا مِنْهَا حَبًّا فَمِنْهُ يَأْكُلُونَ",
    34: "وَجَعَلْنَا فِيهَا جَنَّاتٍ مِنْ نَخِيلٍ وَأَعْنَابٍ وَفَجَّرْنَا فِيهَا مِنَ الْعُيُونِ",
    35: "لِيَأْكُلُوا مِنْ ثَمَرِهِ وَمَا عَمِلَتْهُ أَيْدِيهِمْ ۖ أَفَلَا يَشْكُرُونَ",
    36: "سُبْحَانَ الَّذِي خَلَقَ الْأَزْوَاجَ كُلَّهَا مِمَّا تُنْبِتُ الْأَرْضُ وَمِنْ أَنْفُسِهِمْ وَمِمَّا لَا يَعْلَمُونَ",
    37: "وَآيَةٌ لَهُمُ اللَّيْلُ نَسْلَخُ مِنْهُ النَّهَارَ فَإِذَا هُمْ مُظْلِمُونَ",
    38: "وَالشَّمْسُ تَجْرِي لِمُسْتَقَرٍّ لَهَا ۚ ذَٰلِكَ تَقْدِيرُ الْعَزِيزِ الْعَلِيمِ",
    39: "وَالْقَمَرَ قَدَّرْنَاهُ مَنَازِلَ حَتَّىٰ عَادَ كَالْعُرْجُونِ الْقَدِيمِ",
    40: "لَا الشَّمْسُ يَنْبَغِي لَهَا أَنْ تُدْرِكَ الْقَمَرَ وَلَا اللَّيْلُ سَابِقُ النَّهَارِ ۚ وَكُلٌّ فِي فَلَكٍ يَسْبَحُونَ",
    41: "وَآيَةٌ لَهُمْ أَنَّا حَمَلْنَا ذُرِّيَّتَهُمْ فِي الْفُلْكِ الْمَشْحُونِ",
    42: "وَخَلَقْنَا لَهُمْ مِنْ مِثْلِهِ مَا يَرْكَبُونَ",
    43: "وَإِنْ نَشَأْ نُغْرِقْهُمْ فَلَا صَرِيخَ لَهُمْ وَلَا هُمْ يُنْقَذُونَ",
    44: "إِلَّا رَحْمَةً مِنَّا وَمَتَاعًا إِلَىٰ حِينٍ",
    45: "وَإِذَا قِيلَ لَهُمُ اتَّقُوا مَا بَيْنَ أَيْدِيكُمْ وَمَا خَلْفَكُمْ لَعَلَّكُمْ تُرْحَمُونَ",
    46: "وَمَا تَأْتِيهِمْ مِنْ آيَةٍ مِنْ آيَاتِ رَبِّهِمْ إِلَّا كَانُوا عَنْهَا مُعْرِضِينَ",
    47: "وَإِذَا قِيلَ لَهُمْ أَنْفِقُوا مِمَّا رَزَقَكُمُ اللَّهُ قَالَ الَّذِينَ كَفَرُوا لِلَّذِينَ آمَنُوا أَنُطْعِمُ مَنْ لَوْ يَشَاءُ اللَّهُ أَطْعَمَهُ إِنْ أَنْتُمْ إِلَّا فِي ضَلَالٍ مُبِينٍ",
    48: "وَيَقُولُونَ مَتَىٰ هَٰذَا الْوَعْدُ إِنْ كُنْتُمْ صَادِقِينَ",
    49: "مَا يَنْظُرُونَ إِلَّا صَيْحَةً وَاحِدَةً تَأْخُذُهُمْ وَهُمْ يَخِصِّمُونَ",
    50: "فَلَا يَسْتَطِيعُونَ تَوْصِيَةً وَلَا إِلَىٰ أَهْلِهِمْ يَرْجِعُونَ",
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
                        ArabicVerseWithTranslationContainerRukuThird(
                          rukuNumber: 3,
                          startVerseIndex: 33 + ((_currentPage - 1) * 6),
                          lastVerseIndex: 50,
                          versesPerPage: 6,
                          currentPage: _currentPage,
                          totalPages: _totalPages,
                          isListeningAudio: true,
                          onPrevPage: _goToPrevPage,
                          onNextPage: _goToNextPage,
                          activeVerseIndex: _activeVerseIndex,

                        ),
                        SizedBox(height: 10),
                        ListenAudioWithTranslationRukuThirdAudioPlayer(
                          title: 'ruku_title_audio_trans3'.tr,
                          verses: yaseen_verses,
                          startVerse: 33,
                          endVerse: 50,
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
