import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioWithTranslation/ListenAudioWithTranslastionScreenTopbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioWithTranslation/RukuAudioPlayerWithTranslation.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import 'ruku_config.dart';
import 'verse_page_container_with_translation.dart';

/// Generic reusable Ruku Listen Audio With Translation Screen widget
/// Replaces all individual ListenAudioWithTranslationRuku* files
class RukuListenAudioWithTranslationScreen extends StatefulWidget {
  final RukuConfig config;
  final Map<int, String> verses; // Arabic verses map

  const RukuListenAudioWithTranslationScreen({
    super.key,
    required this.config,
    required this.verses,
  });

  @override
  State<RukuListenAudioWithTranslationScreen> createState() =>
      _RukuListenAudioWithTranslationScreenState();
}

class _RukuListenAudioWithTranslationScreenState
    extends State<RukuListenAudioWithTranslationScreen> {
  late int _currentPage;
  int _activeVerseIndex = -1;

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
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
    if (_currentPage < widget.config.totalPages) {
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

  void _handleActiveVerseChanged(int verseIndex) {
    setState(() {
      _activeVerseIndex = verseIndex;

      int versesPerPage = 6;
      int targetPage = (verseIndex / versesPerPage).floor() + 1;

      if (_currentPage != targetPage &&
          targetPage <= widget.config.totalPages &&
          targetPage > 0) {
        _currentPage = targetPage;
      }
    });
  }

  int _calculateStartVerseIndex() {
    return widget.config.startVerseIndex + ((_currentPage - 1) * 6);
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
                  TopBarListenAudioWithTranslationScreen(),
                  DividerBar(),
                  SurahTitle(),
                  const SizedBox(height: 90),
                  ArabicVerseWithTranslationContainer(
                    rukuNumber: widget.config.rukuNumber,
                    startVerseIndex: _calculateStartVerseIndex(),
                    lastVerseIndex: widget.config.lastVerseIndex,
                    versesPerPage: 6,
                    currentPage: _currentPage,
                    totalPages: widget.config.totalPages,
                    isListeningAudio: true,
                    onPrevPage: _goToPrevPage,
                    onNextPage: _goToNextPage,
                    activeVerseIndex: _activeVerseIndex,
                  ),
                  SizedBox(height: 10),
                  RukuAudioPlayerWithTranslation(
                    title: widget.config.audioWithTranslationTitleKey.tr,
                    verses: widget.verses,
                    startVerse: widget.config.startVerseIndex,
                    endVerse: widget.config.lastVerseIndex,
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

