import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:surah_yaseen/widgets/dialogs/BookmarkConfirmDialog.dart';
import '../../Colors/colors.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../BookmarkScreen/BookmarkProvider.dart';
import '../FontSize/FontSizeProvider.dart';

class VersePageContainerRukuSecond extends StatefulWidget {
  final int rukuNumber;
  final int startVerseIndex;
  final int lastVerseIndex;
  final int versesPerPage;
  final int versesPerPageDialogBox;
  final int currentPage;
  final int totalPageDialogBox;
  final int totalPages;
  final Function(int)? onPageChanged;
  final VoidCallback? onPrevPage;
  final VoidCallback? onNextPage;
  final bool isFullScreen;
  final VoidCallback onToggleFullScreen;

  const VersePageContainerRukuSecond({
    Key? key,
    required this.rukuNumber,
    required this.startVerseIndex,
    required this.lastVerseIndex,
    required this.versesPerPage,
    required this.versesPerPageDialogBox,
    required this.currentPage,
    required this.totalPageDialogBox,
    required this.totalPages,
    this.onPageChanged,
    this.onPrevPage,
    this.onNextPage,
    required this.isFullScreen,
    required this.onToggleFullScreen,
  }) : super(key: key);

  @override
  State<VersePageContainerRukuSecond> createState() => _VersePageContainerState();
}

class _VersePageContainerState extends State<VersePageContainerRukuSecond> {
  late PageController _dialogPageController;
  late int _currentDialogPage;
  int? _longPressedVerseIndex;
  final Color _bookmarkHighlightColor = Color(0xFFF6FAF7); // Soft greenish background
  final Color _bookmarkBorderColor = Color(0xFFCCE7D5); // Green border

  @override
  void initState() {
    super.initState();
    _currentDialogPage = widget.currentPage;
    _dialogPageController = PageController(initialPage: widget.currentPage - 1);
  }

  @override
  void dispose() {
    _dialogPageController.dispose();
    super.dispose();
  }

  // Reset highlight when page changes or when widget rebuilds with new data
  @override
  void didUpdateWidget(VersePageContainerRukuSecond oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset highlight when moving to a different page or verse set
    if (oldWidget.startVerseIndex != widget.startVerseIndex ||
        oldWidget.currentPage != widget.currentPage) {
      setState(() {
        _longPressedVerseIndex = null;
      });
    }
  }

  void _showFullScreenDialog(BuildContext context) {
    // Reset dialog page controller to current page
    _currentDialogPage = widget.currentPage;
    _dialogPageController = PageController(initialPage: widget.currentPage - 1);

    // Reset any highlighted verse when showing the fullscreen dialog
    setState(() {
      _longPressedVerseIndex = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (
          BuildContext dialogContext
          )
      {
        return StatefulBuilder(
          builder: (
              BuildContext context,
              StateSetter setDialogState
              )
          {
            return Stack(
              children: [
                // Close button positioned outside the container
                Positioned(
                  top: 20,
                  left: 30,  // Changed from 'right: 20' to 'left: 20'
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                      widget.onToggleFullScreen();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,  // Changed to transparent background
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Main container
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.78,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Ruku Title
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Rukū ${widget.rukuNumber}',
                            style: TextStyle(
                              color: AppColors.PrimaryColor,
                              fontSize: 28,
                              fontFamily: GoogleFonts.merriweather().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // PageView for swipeable pages
                        Expanded(
                          child: PageView.builder(
                            controller: _dialogPageController,
                            onPageChanged: (int page) {
                              setDialogState(() {
                                _currentDialogPage = page + 1;
                              });
                              if (widget.onPageChanged != null) {
                                widget.onPageChanged!(page + 1);
                              }
                            },
                            itemCount: widget.totalPageDialogBox,
                            itemBuilder: (context, pageIndex) {
                              int startIdx = 13 + pageIndex * widget.versesPerPageDialogBox;
                              return _buildVersesPageFullscreen(startIdx, setDialogState);
                            },
                          ),
                        ),

                        // Footer
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.PrimaryColor,
                                  size: 20,
                                ),
                                onPressed: _currentDialogPage > 1
                                    ? () {
                                  _dialogPageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                                    : null,
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'Page $_currentDialogPage of ${widget.totalPageDialogBox}',
                                  style: TextStyle(
                                    color: AppColors.PrimaryColor,
                                    fontSize: 16,
                                    fontFamily: GoogleFonts.merriweather().fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.PrimaryColor,
                                  size: 20,
                                ),
                                onPressed: _currentDialogPage < widget.totalPageDialogBox
                                    ? () {
                                  _dialogPageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: 35, // Adjust the left position
                  top: 60,  // Adjust the top position
                  child: Image.asset(
                    AppAssets.topcornerdecor, // Replace with your image asset path
                    width: 70,
                    height: 70,
                  ),
                ),

                // Add Image Asset to bottom-right corner (in full-screen dialog)
                Positioned(
                  right: 35,  // Adjust the right position
                  bottom: 60, // Adjust the bottom position
                  child: Image.asset(
                    AppAssets.bottomrightdecor, // Replace with your image asset path
                    width: 70,
                    height: 70,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showBookmarkConfirmationDialog(
      BuildContext context,
      int verseIndex,
      String arabicText,
      String englishText)
  async
  {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);

    // Add the verse to bookmarks
    bool wasAdded = await bookmarkProvider.addVerseBookmark(
      arabicText: arabicText,
      englishText: englishText,
      verseIndex: verseIndex,
      rukuNumber: widget.rukuNumber,
    );

    // Show the appropriate confirmation dialog
    showDialog(
      context: context,
      builder: (_) => BookmarkConfirmationDialog(
          message: wasAdded ? 'Verse Bookmarked' : 'Verse Already Bookmarked'
      ),
    ).then((_) {
      // Reset the highlight after the dialog is dismissed
      setState(() {
        _longPressedVerseIndex = null;
      });
    });
  }

  Widget _buildVersesPage(int startIdx, bool isInDialog) {

    final fontSizeProvider = Provider.of<FontSizeProvider>(context, listen: true);
    final _fontSizeValue = fontSizeProvider.fontSizeValue;
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: true);

    Map<String, String> versesArabic = AppStrings.yasinSurahStrings.verses;
    Map<String, String> versesEnglish = AppStrings.yasinSurahStrings.versesEnglish;

    List<MapEntry<String, String>> arabicEntries = [];
    List<MapEntry<String, String>> englishEntries = [];

    int versesToShow = isInDialog ? widget.versesPerPageDialogBox : widget.versesPerPage;

    for (int i = startIdx; i < startIdx + versesToShow && i <= widget.lastVerseIndex; i++) {
      String key = 'verse_$i';
      if (versesArabic.containsKey(key) && versesEnglish.containsKey(key)) {
        arabicEntries.add(MapEntry(key, versesArabic[key]!));
        englishEntries.add(MapEntry(key, versesEnglish[key]!));
      }
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: widget.isFullScreen || isInDialog ? 24 : 20,
          vertical: widget.isFullScreen || isInDialog ? 20 : 15
      ),
      itemCount: arabicEntries.length,
      itemBuilder: (context, index) {
        final actualVerseIndex = startIdx + index;
        final arabicText = arabicEntries[index].value;
        final englishText = englishEntries[index].value;
        final isSelected = _longPressedVerseIndex == index;

        // Check if this verse is already bookmarked
        final isBookmarked = bookmarkProvider.isVerseBookmarked(
            actualVerseIndex,
            widget.rukuNumber
        );

        return GestureDetector(
          onLongPress: () {
            setState(() {
              _longPressedVerseIndex = index;
            });

            Future.delayed(Duration(milliseconds: 300), () {
              _showBookmarkConfirmationDialog(
                context,
                actualVerseIndex,
                arabicText,
                englishText,
              );
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.all((isSelected || isBookmarked) ? 12 : 0),
            decoration: (isSelected || isBookmarked)
                ? BoxDecoration(
              color: _bookmarkHighlightColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _bookmarkBorderColor,
                width: 1.5,
              ),
            )
                : null,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Space for bookmark icon if verse is bookmarked
                    if (isBookmarked)
                      SizedBox(width: 30),

                    // Main content with adjusted width
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            arabicText,
                            style: TextStyle(
                              fontFamily: GoogleFonts.merriweather().fontFamily,
                              fontSize: isInDialog ?
                              (24 + (_fontSizeValue * 8)) : // For dialog box
                              (widget.isFullScreen ?
                              (24 + (_fontSizeValue * 8)) : // For fullscreen
                              (24 + (_fontSizeValue * 8))), // For regular view
                              color: AppColors.PrimaryColor,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(height: widget.isFullScreen || isInDialog ? 14 : 10),
                          Text(
                            englishText,
                            style: TextStyle(
                              fontSize: isInDialog ?
                              (18 + (_fontSizeValue * 8)) : // For dialog box
                              (widget.isFullScreen ?
                              (18 + (_fontSizeValue * 8)) : // For fullscreen
                              (14 + (_fontSizeValue * 8))),
                              color: widget.isFullScreen || isInDialog
                                  ? AppColors.BarColor
                                  : AppColors.BarColor,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          if (index < arabicEntries.length - 1)
                            SizedBox(height: widget.isFullScreen || isInDialog ? 20 : 12),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bookmark icon that appears when verse is selected
                if (isSelected || isBookmarked)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.bookmark,
                        color: AppColors.PrimaryColor,
                        size: isBookmarked ? 22 : 20, // Slightly larger for bookmarked verses
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

  // For fullscreen dialog mode with bookmark functionality
  Widget _buildVersesPageFullscreen(int startIdx, StateSetter setDialogState) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context, listen: true);
    final _fontSizeValue = fontSizeProvider.fontSizeValue;
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: true);

    // Track highlighted verse in fullscreen mode
    int? _dialogLongPressedVerseIndex;

    Map<String, String> versesArabic = AppStrings.yasinSurahStrings.verses;
    Map<String, String> versesEnglish = AppStrings.yasinSurahStrings.versesEnglish;

    List<MapEntry<String, String>> arabicEntries = [];
    List<MapEntry<String, String>> englishEntries = [];

    int versesToShow = widget.versesPerPageDialogBox;

    for (int i = startIdx; i < startIdx + versesToShow && i <= widget.lastVerseIndex; i++) {
      String key = 'verse_$i';
      if (versesArabic.containsKey(key) && versesEnglish.containsKey(key)) {
        arabicEntries.add(MapEntry(key, versesArabic[key]!));
        englishEntries.add(MapEntry(key, versesEnglish[key]!));
      }
    }

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            itemCount: arabicEntries.length,
            itemBuilder: (context, index) {
              final actualVerseIndex = startIdx + index;
              final arabicText = arabicEntries[index].value;
              final englishText = englishEntries[index].value;
              final isSelected = _dialogLongPressedVerseIndex == index;

              // Check if this verse is already bookmarked
              final isBookmarked = bookmarkProvider.isVerseBookmarked(
                  actualVerseIndex,
                  widget.rukuNumber
              );

              return GestureDetector(
                onLongPress: () {
                  // Update local state for the dialog
                  setState(() {
                    _dialogLongPressedVerseIndex = index;
                  });

                  Future.delayed(Duration(milliseconds: 300), () async {
                    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);

                    // Add the verse to bookmarks
                    bool wasAdded = await bookmarkProvider.addVerseBookmark(
                      arabicText: arabicText,
                      englishText: englishText,
                      verseIndex: actualVerseIndex,
                      rukuNumber: widget.rukuNumber,
                    );

                    // Show the appropriate confirmation dialog
                    showDialog(
                      context: context,
                      builder: (_) => BookmarkConfirmationDialog(
                          message: wasAdded ? 'Verse Bookmarked' : 'Verse Already Bookmarked'
                      ),
                    ).then((_) {
                      // Reset the highlight after the dialog is dismissed
                      setState(() {
                        _dialogLongPressedVerseIndex = null;
                      });
                    });
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.all((isSelected || isBookmarked) ? 12 : 0),
                  decoration: (isSelected || isBookmarked)
                      ? BoxDecoration(
                    color: _bookmarkHighlightColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _bookmarkBorderColor,
                      width: 1.5,
                    ),
                  )
                      : null,
                  child: Stack(
                    children: [
                      // Content Container with padding for bookmark icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Space for bookmark icon if verse is bookmarked
                          if (isBookmarked)
                            SizedBox(width: 32), // Slightly wider in fullscreen mode

                          // Main content with adjusted width
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  arabicText,
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.merriweather().fontFamily,
                                    fontSize: 24 + (_fontSizeValue * 8),
                                    color: AppColors.PrimaryColor,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(height: 14),
                                Text(
                                  englishText,
                                  style: TextStyle(
                                    fontSize: 18 + (_fontSizeValue * 8),
                                    color: AppColors.BarColor,
                                    fontWeight: FontWeight.w400,
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                if (index < arabicEntries.length - 1)
                                  SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Bookmark icon that appears when verse is selected or permanently bookmarked
                      if (isSelected || isBookmarked)
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.bookmark,
                              color: AppColors.PrimaryColor,
                              size: isBookmarked ? 24 : 20, // Slightly larger for bookmarked verses in fullscreen
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isFullScreen ? double.infinity : 350,
      height: widget.isFullScreen ? double.infinity : 480,
      decoration: BoxDecoration(
        color: widget.isFullScreen ? Colors.white.withOpacity(0.95) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: widget.isFullScreen ? Colors.transparent : AppColors.BarColor,
          width: widget.isFullScreen ? 0 : 1.5,
        ),
      ),
      margin: EdgeInsets.zero,
      child: Stack(
        children: [
          Column(
            children: [
              // Ruku Title
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: widget.isFullScreen ? 16 : 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  widget.isFullScreen ? 'Full Screen' : 'Rukū ${widget.rukuNumber}',
                  style: TextStyle(
                    color: AppColors.PrimaryColor,
                    fontSize: widget.isFullScreen ? 28 : 24,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Main Content - Swipeable in regular mode too
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) {
                    if (details.primaryVelocity! > 0) {
                      // Swiped right - go to previous page
                      if (widget.onPrevPage != null && widget.currentPage > 1) {
                        // Reset highlight before changing page
                        setState(() {
                          _longPressedVerseIndex = null;
                        });
                        widget.onPrevPage!();
                      }
                    } else if (details.primaryVelocity! < 0) {
                      // Swiped left - go to next page
                      if (widget.onNextPage != null && widget.currentPage < widget.totalPages) {
                        // Reset highlight before changing page
                        setState(() {
                          _longPressedVerseIndex = null;
                        });
                        widget.onNextPage!();
                      }
                    }
                  },
                  child: _buildVersesPage(widget.startVerseIndex, false),
                ),
              ),

              // Footer
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(
                  vertical: widget.isFullScreen ? 12 : 6,
                  horizontal: widget.isFullScreen ? 16 : 0,
                ),
                decoration: widget.isFullScreen
                    ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                )
                    : null,
                child: Row(
                  mainAxisAlignment: widget.isFullScreen
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  children: [
                    if (!widget.isFullScreen)
                      IconButton(
                        icon: Icon(Icons.fullscreen, color: AppColors.PrimaryColor, size: 20),
                        onPressed: () => _showFullScreenDialog(context),
                      ),
                    if (!widget.isFullScreen) const SizedBox(width: 45),

                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.PrimaryColor,
                        size: widget.isFullScreen ? 20 : 18,
                      ),
                      onPressed: widget.currentPage > 1 ? () {
                        // Reset highlight before changing page
                        setState(() {
                          _longPressedVerseIndex = null;
                        });
                        widget.onPrevPage!();
                      } : null,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Page ${widget.currentPage} of ${widget.totalPages}',
                        style: TextStyle(
                          color: AppColors.PrimaryColor,
                          fontSize: widget.isFullScreen ? 16 : 14,
                          fontFamily: GoogleFonts.merriweather().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.PrimaryColor,
                        size: widget.isFullScreen ? 20 : 18,
                      ),
                      onPressed: widget.currentPage < widget.totalPages ? () {
                        // Reset highlight before changing page
                        setState(() {
                          _longPressedVerseIndex = null;
                        });
                        widget.onNextPage!();
                      } : null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Add Image Asset to top-left corner (before the Ruku Title)
          Positioned(
            left: 5,  // Adjust the left position
            top: -9,   // Adjust the top position
            child: Image.asset(
              AppAssets.topcornerdecor, // Replace with your image asset path
              width: 70,
              height: 70,
            ),
          ),

          // Add Image Asset to bottom-right corner
          Positioned(
            right: 5,  // Adjust the right position
            bottom: -8, // Adjust the bottom position
            child: Image.asset(
              AppAssets.bottomrightdecor, // Replace with your image asset path
              width: 70,
              height: 70,
            ),
          ),
        ],
      ),
    );
  }

}