import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/TopBar/topbartest.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import '../../../Colors/colors.dart';
import '../../../constants/app_constants.dart';
import 'ruku_config.dart';
import 'verse_page_container.dart';

class RukuReadScreen extends StatefulWidget {
  final RukuConfig config;
  final Widget? bannerAd;

  const RukuReadScreen({super.key, required this.config, this.bannerAd});

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
    int baseOffset = widget.config.startVerseIndex;
    int pageOffset = (_currentPage - 1) * widget.config.versesPerPage;
    return baseOffset + pageOffset;
  }

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      final initialPage = arguments['initialPage'];
      if (initialPage != null && initialPage is int) {
        _currentPage = initialPage.clamp(1, widget.config.totalPages);
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
        children: [
          const TopBackground(),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                children: [
                  const TopBarSet(),
                  SizedBox(height: screenHeight * 0.02),
                  const DividerBar(),
                  SizedBox(height: screenHeight * 0.02),
                  const SurahTitle(),
                  SizedBox(height: screenHeight * 0.07),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            widget.bannerAd != null
                                ? AppConstants.bannerAdBottomPadding +
                                    screenHeight * 0.02
                                : 0,
                      ),
                      child: Center(
                        child: VersePageContainer(
                          rukuNumber: widget.config.rukuNumber,
                          startVerseIndex: _calculateStartVerseIndex(),
                          lastVerseIndex: widget.config.lastVerseIndex,
                          versesPerPage: widget.config.versesPerPage,
                          versesPerPageDialogBox:
                              widget.config.versesPerPageDialogBox,
                          currentPage: _currentPage,
                          totalPages: widget.config.totalPages,
                          totalPageDialogBox: widget.config.totalPageDialogBox,
                          dialogStartVerseOffset:
                              widget.config.dialogStartVerseOffset,
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
                              _currentPage < widget.config.totalPages
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

          if (widget.bannerAd != null)
            Positioned(bottom: 0, left: 0, right: 0, child: widget.bannerAd!),
        ],
      ),
    );
  }
}
