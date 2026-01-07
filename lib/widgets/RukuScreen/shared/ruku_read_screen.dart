import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/widgets/ReadScreen/ReadScreenTopBar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import '../../../Colors/colors.dart';
import 'ruku_config.dart';
import 'verse_page_container.dart';

/// Generic reusable Ruku Read Screen widget
/// Replaces all individual Ruku*ReadScreen files
/// 
/// Usage:
/// ```dart
/// RukuReadScreen(config: RukuConfig.getRukuConfig(1))
/// ```
class RukuReadScreen extends StatefulWidget {
  final RukuConfig config;

  const RukuReadScreen({
    super.key,
    required this.config,
  });

  @override
  State<RukuReadScreen> createState() => _RukuReadScreenState();
}

class _RukuReadScreenState extends State<RukuReadScreen> {
  int _currentPage = 1;
  bool _isFullScreen = false;

  void toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  int _calculateStartVerseIndex() {
    // Calculate start verse index based on current page
    // For Ruku 1: starts at 0, each page has 4 verses
    // For other Rukus: add the offset
    int baseOffset = widget.config.startVerseIndex;
    int pageOffset = (_currentPage - 1) * widget.config.versesPerPage;
    return baseOffset + pageOffset;
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
          // Background
          const TopBackground(),
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Column(
                children: [
                  const TopBarReadScreen(),
                  const SizedBox(height: 10),
                  const DividerBar(),
                  const SurahTitle(),
                  const SizedBox(height: 70),

                  Expanded(
                    child: Center(
                      child: VersePageContainer(
                        rukuNumber: widget.config.rukuNumber,
                        startVerseIndex: _calculateStartVerseIndex(),
                        lastVerseIndex: widget.config.lastVerseIndex,
                        versesPerPage: widget.config.versesPerPage,
                        versesPerPageDialogBox: widget.config.versesPerPageDialogBox,
                        currentPage: _currentPage,
                        totalPages: widget.config.totalPages,
                        totalPageDialogBox: widget.config.totalPageDialogBox,
                        dialogStartVerseOffset: widget.config.dialogStartVerseOffset,
                        onPageChanged: _handlePageChanged,
                        onPrevPage: _currentPage > 1
                            ? () {
                                setState(() {
                                  _currentPage--;
                                });
                              }
                            : null,
                        onNextPage: _currentPage < widget.config.totalPages
                            ? () {
                                setState(() {
                                  _currentPage++;
                                });
                              }
                            : null,
                        isFullScreen: false,
                        onToggleFullScreen: toggleFullScreen,
                      ),
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
