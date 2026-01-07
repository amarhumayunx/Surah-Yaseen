import 'dart:math';

import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:surah_yaseen/widgets/dialogs/BookmarkConfirmDialog.dart';
import '../../../Colors/colors.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_strings.dart';
import '../../BookmarkScreen/BookmarkProvider.dart';
import '../../FontSize/FontSizeProvider.dart';
import '../../NotificationScreen/notification_screen_history.dart';

/// Generic reusable Arabic-only VersePageContainer widget for audio listening screens
class ArabicVerseContainer extends StatefulWidget {
  final int rukuNumber;
  final int startVerseIndex;
  final int lastVerseIndex;
  final int versesPerPage;
  final int currentPage;
  final int totalPages;
  final bool isListeningAudio;
  final int activeVerseIndex;
  final Function(int)? onPageChanged;
  final VoidCallback? onPrevPage;
  final VoidCallback? onNextPage;

  const ArabicVerseContainer({
    super.key,
    required this.rukuNumber,
    required this.startVerseIndex,
    required this.lastVerseIndex,
    required this.versesPerPage,
    required this.currentPage,
    required this.totalPages,
    this.isListeningAudio = false,
    this.activeVerseIndex = 0,
    this.onPageChanged,
    this.onPrevPage,
    this.onNextPage,
  });

  @override
  State<ArabicVerseContainer> createState() => _ArabicVerseContainerState();
}

class _ArabicVerseContainerState extends State<ArabicVerseContainer> {
  int? _longPressedVerseIndex;
  late PageController _pageController;
  final Color _bookmarkHighlightColor = Color(0xFFF6FAF7);
  final Color _bookmarkBorderColor = Color(0xFFCCE7D5);
  final Color _activeVerseHighlightColor = Color(0xFFF6F0DE);
  final Color _activeVerseBorderColor = AppColors.BarColor;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentPage - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ArabicVerseContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startVerseIndex != widget.startVerseIndex ||
        oldWidget.currentPage != widget.currentPage) {
      // Sync page controller with current page
      if (_pageController.hasClients &&
          _pageController.page?.round() != widget.currentPage - 1) {
        _pageController.animateToPage(
          widget.currentPage - 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      setState(() {
        _longPressedVerseIndex = null;
      });
    }
  }

  Future<void> _showBookmarkConfirmationDialog(
    BuildContext buildContext,
    int verseIndex,
    String arabicText,
  ) async {
    if (!mounted || !buildContext.mounted) return;
    final bookmarkProvider = Provider.of<BookmarkProvider>(
      buildContext,
      listen: false,
    );

    String iconType = widget.isListeningAudio ? 'audio' : 'quran';

    bool wasAdded = await bookmarkProvider.addVerseBookmark(
      arabicText: arabicText,
      englishText: "",
      verseIndex: verseIndex,
      rukuNumber: widget.rukuNumber,
      iconType: iconType,
    );

    await NotificationHistoryManager.saveNotification(
      title: 'Verse $verseIndex',
      verseIndex: verseIndex,
      rukuNumber: widget.rukuNumber,
    );

    if (!mounted || !buildContext.mounted) return;
    showDialog(
      context: buildContext,
      builder:
          (_) => BookmarkConfirmationDialog(
            message:
                wasAdded
                    ? 'verse_bookmarked'.tr
                    : 'verse_already_bookmarked'.tr,
          ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _longPressedVerseIndex = null;
        });
      }
    });
  }

  int _calculateStartIndexForPage(int page) {
    // Calculate the starting verse index for a given page
    // widget.startVerseIndex is already calculated for widget.currentPage
    // So we need to adjust based on the difference between requested page and current page
    int pageDifference = page - widget.currentPage;
    return widget.startVerseIndex + (pageDifference * widget.versesPerPage);
  }

  Widget _buildVersesPage(int startIdx) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(
      context,
      listen: true,
    );
    final fontSizeValue = fontSizeProvider.fontSizeValue;
    final bookmarkProvider = Provider.of<BookmarkProvider>(
      context,
      listen: true,
    );

    Map<String, String> versesArabic = AppStrings.yasinSurahStrings.verses;

    List<MapEntry<String, String>> arabicEntries = [];

    for (
      int i = startIdx;
      i < startIdx + widget.versesPerPage && i <= widget.lastVerseIndex;
      i++
    ) {
      String key = 'verse_$i';
      if (versesArabic.containsKey(key)) {
        arabicEntries.add(MapEntry(key, versesArabic[key]!));
      }
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      itemCount: arabicEntries.length,
      itemBuilder: (context, index) {
        final actualVerseIndex = startIdx + index;
        final arabicText = arabicEntries[index].value;
        final isSelected = _longPressedVerseIndex == index;

        final isActiveVerse = widget.activeVerseIndex == actualVerseIndex;

        final isBookmarked = bookmarkProvider.isVerseBookmarked(
          actualVerseIndex,
          widget.rukuNumber,
        );

        String bookmarkIconType = 'quran';
        if (isBookmarked) {
          bookmarkIconType = bookmarkProvider.getVerseBookmarkIconType(
            actualVerseIndex,
            widget.rukuNumber,
          );
        }

        Color containerColor;
        Color borderColor;

        if (isActiveVerse) {
          containerColor = _activeVerseHighlightColor;
          borderColor = _activeVerseBorderColor;
        } else if (isSelected || isBookmarked) {
          containerColor = _bookmarkHighlightColor;
          borderColor = _bookmarkBorderColor;
        } else {
          containerColor = Colors.transparent;
          borderColor = Colors.transparent;
        }

        return GestureDetector(
          onLongPress: () {
            setState(() {
              _longPressedVerseIndex = index;
            });

            final buildContext = context;
            Future.delayed(Duration(milliseconds: 300), () async {
              if (!mounted || !buildContext.mounted) return;
              await _showBookmarkConfirmationDialog(
                buildContext,
                actualVerseIndex,
                arabicText,
              );
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.all(
              (isSelected || isBookmarked || isActiveVerse) ? 12 : 0,
            ),
            decoration:
                (isSelected || isBookmarked || isActiveVerse)
                    ? BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: borderColor, width: 1.5),
                    )
                    : null,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isBookmarked || isActiveVerse) SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            arabicText,
                            style: ArabicTextStyle(
                              arabicFont: ArabicFont.lateef,
                              fontSize: 24 + (fontSizeValue * 8),
                              color: AppColors.PrimaryColor,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          if (index < arabicEntries.length - 1)
                            SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isSelected || isBookmarked || isActiveVerse)
                  Positioned(
                    left:
                        Directionality.of(context) == TextDirection.ltr
                            ? 2
                            : null,
                    right:
                        Directionality.of(context) == TextDirection.rtl
                            ? 2
                            : null,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child:
                          isActiveVerse && !isBookmarked
                              ? Icon(
                                Icons.volume_up,
                                size: 22,
                                color: AppColors.PrimaryColor,
                              )
                              : bookmarkIconType == 'audio'
                              ? Image.asset(
                                AppAssets.headphoneimagebookmark,
                                width: 22,
                                height: 22,
                              )
                              : Image.asset(
                                AppAssets.quranpakimagebookmark,
                                width: 22,
                                height: 22,
                              ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.BarColor, width: 1.5),
      ),
      margin: EdgeInsets.zero,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  '${'ruku_line_bookmark'.tr} ${widget.rukuNumber}',
                  style: GoogleFonts.merriweather(
                    color: AppColors.PrimaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.totalPages,
                  onPageChanged: (int page) {
                    final newPage = page + 1;
                    if (newPage != widget.currentPage) {
                      // Notify parent about page change
                      if (widget.onPageChanged != null) {
                        widget.onPageChanged!(newPage);
                      }
                      // Also trigger appropriate callback for parent state update
                      if (newPage > widget.currentPage &&
                          widget.onNextPage != null) {
                        widget.onNextPage!();
                      } else if (newPage < widget.currentPage &&
                          widget.onPrevPage != null) {
                        widget.onPrevPage!();
                      }
                    }
                  },
                  itemBuilder: (context, pageIndex) {
                    final pageNumber = pageIndex + 1;
                    final startIdx = _calculateStartIndexForPage(pageNumber);
                    return _buildVersesPage(startIdx);
                  },
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.PrimaryColor,
                        size: 16,
                      ),
                      onPressed:
                          widget.currentPage > 1 ? widget.onPrevPage : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${'page'.tr} ${widget.currentPage} ${'of'.tr} ${widget.totalPages}',
                        style: GoogleFonts.merriweather(
                          color: AppColors.PrimaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.PrimaryColor,
                        size: 16,
                      ),
                      onPressed:
                          widget.currentPage < widget.totalPages
                              ? widget.onNextPage
                              : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: Directionality.of(context) == TextDirection.ltr ? 5 : null,
            right: Directionality.of(context) == TextDirection.rtl ? 5 : null,
            top: -9,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                Directionality.of(context) == TextDirection.rtl ? pi : 0,
              ),
              child: Image.asset(
                AppAssets.topcornerdecor,
                width: 70,
                height: 70,
              ),
            ),
          ),
          Positioned(
            right: Directionality.of(context) == TextDirection.ltr ? 5 : null,
            left: Directionality.of(context) == TextDirection.rtl ? 5 : null,
            bottom: -8,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                Directionality.of(context) == TextDirection.rtl ? pi : 0,
              ),
              child: Image.asset(
                AppAssets.bottomrightdecor,
                width: 70,
                height: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
