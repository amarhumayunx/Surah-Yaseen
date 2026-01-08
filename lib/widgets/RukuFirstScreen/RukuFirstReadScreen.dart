import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/ReadScreen/ReadScreenTopBar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../../Colors/colors.dart';
import '../Dividerbar/dividerbar.dart';
import 'VersePageContainerRukuFirst.dart';
import 'ruku_first_read_banner_ad_widget.dart';

class RukuFirstReadScreen extends StatefulWidget {
  const RukuFirstReadScreen({super.key});

  @override
  State<RukuFirstReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<RukuFirstReadScreen> {
  int _currentPage = 1;
  int _totalPages = 4;
  int _totalPageDialogBox = 3;
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

  @override
  void initState() {
    super.initState();

    // Check if we have arguments for initial page (from notification tap)
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      final initialPage = arguments['initialPage'];
      if (initialPage != null && initialPage is int) {
        _currentPage = initialPage.clamp(1, _totalPages);
      }
    }

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  const TopBarReadScreen(),
                  const SizedBox(height: 10),
                  const DividerBar(),
                  const SurahTitle(),
                  const SizedBox(height: 80),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Center(
                        child: VersePageContainer(
                          rukuNumber: 1,
                          startVerseIndex: (_currentPage - 1) * 4,
                          lastVerseIndex: 12,
                          versesPerPage: 4,
                          versesPerPageDialogBox: 6,
                          currentPage: _currentPage,
                          totalPages: _totalPages,
                          totalPageDialogBox: _totalPageDialogBox,
                          onPageChanged: _handlePageChanged,
                          onPrevPage:
                              _currentPage > 1
                                  ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                  }
                                  : null,
                          onNextPage:
                              _currentPage < _totalPages
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
                  ),
                ],
              ),
            ),
          ),
          // Banner Ad at the bottom
          const RukuFirstReadBannerAdWidget(),
        ],
      ),
    );
  }
}
