import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioScreen/ListenAudioScreenTopBar.dart';
import 'package:surah_yaseen/widgets/ListenAudioScreen/RukuAudioPlayer.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../../../Colors/colors.dart';
import 'ruku_config.dart';
import 'verse_page_container_arabic.dart';

/// Generic reusable Ruku Listen Audio Screen widget (Arabic only)
/// Replaces all individual ListenAudioRuku*Screen files
class RukuListenAudioScreen extends StatefulWidget {
  final RukuConfig config;
  final Map<int, String> verses; // Arabic verses map

  const RukuListenAudioScreen({
    super.key,
    required this.config,
    required this.verses,
  });

  @override
  State<RukuListenAudioScreen> createState() => _RukuListenAudioScreenState();
}

class _RukuListenAudioScreenState extends State<RukuListenAudioScreen> {
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
                  const TopBarListenAudioScreen(),
                  const DividerBar(),
                  const SurahTitle(),
                  const SizedBox(height: 90),
                  ArabicVerseContainer(
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
                  RukuAudioPlayer(
                    title: widget.config.audioTitleKey.tr,
                    verses: widget.verses,
                    startVerse: widget.config.startVerseIndex,
                    endVerse: widget.config.lastVerseIndex,
                    rukuNumber: widget.config.rukuNumber,
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

