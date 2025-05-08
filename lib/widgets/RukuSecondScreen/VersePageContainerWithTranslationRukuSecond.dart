import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:surah_yaseen/widgets/dialogs/BookmarkConfirmDialog.dart';
import '../../Colors/colors.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../BookmarkScreen/BookmarkProvider.dart';
import '../FontSize/FontSizeProvider.dart';

class ArabicVerseWithTranslationContainerRukuSecond extends StatefulWidget {
  final int rukuNumber;
  final int startVerseIndex;
  final int lastVerseIndex;
  final int versesPerPage;
  final int currentPage;
  final int totalPages;
  final bool isListeningAudio;
  final int activeVerseIndex; // New property to track active verse being played
  final Function(int)? onPageChanged;
  final VoidCallback? onPrevPage;
  final VoidCallback? onNextPage;

  const ArabicVerseWithTranslationContainerRukuSecond({
    Key? key,
    required this.rukuNumber,
    required this.startVerseIndex,
    required this.lastVerseIndex,
    required this.versesPerPage,
    required this.currentPage,
    required this.totalPages,
    this.isListeningAudio = false,
    this.activeVerseIndex = 0, // Default to no active verse
    this.onPageChanged,
    this.onPrevPage,
    this.onNextPage,
  }) : super(key: key);

  @override
  State<ArabicVerseWithTranslationContainerRukuSecond> createState() => _ArabicVerseWithTranslationContainerState();
}

class _ArabicVerseWithTranslationContainerState extends State<ArabicVerseWithTranslationContainerRukuSecond> {
  int? _longPressedVerseIndex;
  final Color _bookmarkHighlightColor = Color(0xFFF6FAF7); // Soft greenish background
  final Color _bookmarkBorderColor = Color(0xFFCCE7D5); // Green border
  final Color _activeVerseHighlightColor = Color(0xFFF6F0DE); // Soft yellowish background
  final Color _activeVerseBorderColor = AppColors.BarColor; // Golden border

  @override
  void didUpdateWidget(ArabicVerseWithTranslationContainerRukuSecond oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset highlight when moving to a different page or verse set
    if (oldWidget.startVerseIndex != widget.startVerseIndex ||
        oldWidget.currentPage != widget.currentPage) {
      setState(() {
        _longPressedVerseIndex = null;
      });
    }
  }

  Future<void> _showBookmarkConfirmationDialog(
      BuildContext context,
      int verseIndex,
      String arabicText)
  async {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);

    // Get English translation
    String? englishText = "";
    if (AppStrings.yasinSurahStrings.versesEnglish.containsKey('verse_$verseIndex')) {
      englishText = AppStrings.yasinSurahStrings.versesEnglish['verse_$verseIndex'];
    }

    // Determine the icon type based on whether the user is listening to audio
    String iconType = widget.isListeningAudio ? 'audio' : 'quran';

    // Add the verse to bookmarks with the appropriate icon type
    bool wasAdded = await bookmarkProvider.addVerseBookmark(
      arabicText: arabicText,
      englishText: englishText ?? "", // Pass the English translation
      verseIndex: verseIndex,
      rukuNumber: widget.rukuNumber,
      iconType: iconType, // Pass the icon type
    );

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

  Widget _buildVersesPage(int startIdx) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context, listen: true);
    final _fontSizeValue = fontSizeProvider.fontSizeValue;
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: true);

    Map<String, String> versesArabic = AppStrings.yasinSurahStrings.verses;
    Map<String, String> versesEnglish = AppStrings.yasinSurahStrings.versesEnglish;

    List<MapEntry<String, String>> arabicEntries = [];
    List<MapEntry<String, String>> englishEntries = [];

    for (int i = startIdx; i < startIdx + widget.versesPerPage && i <= widget.lastVerseIndex; i++) {
      String key = 'verse_$i';
      if (versesArabic.containsKey(key)) {
        arabicEntries.add(MapEntry(key, versesArabic[key]!));
        if (versesEnglish.containsKey(key)) {
          englishEntries.add(MapEntry(key, versesEnglish[key]!));
        } else {
          // If no translation exists, add empty string
          englishEntries.add(MapEntry(key, ""));
        }
      }
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      itemCount: arabicEntries.length,
      itemBuilder: (context, index) {
        final actualVerseIndex = startIdx + index;
        final arabicText = arabicEntries[index].value;
        final englishText = englishEntries[index].value;
        final isSelected = _longPressedVerseIndex == index;

        // Check if this verse is the active verse being spoken
        final isActiveVerse = widget.activeVerseIndex == actualVerseIndex;

        // Check if this verse is already bookmarked
        final isBookmarked = bookmarkProvider.isVerseBookmarked(
            actualVerseIndex,
            widget.rukuNumber
        );

        // Get the bookmark icon type if it's bookmarked
        String bookmarkIconType = 'quran'; // Default
        if (isBookmarked) {
          bookmarkIconType = bookmarkProvider.getVerseBookmarkIconType(
              actualVerseIndex,
              widget.rukuNumber
          );
        }

        // Determine container styling based on states
        Color containerColor;
        Color borderColor;

        if (isActiveVerse) {
          // Active verse takes precedence when playing audio
          containerColor = _activeVerseHighlightColor;
          borderColor = _activeVerseBorderColor;
        } else if (isSelected || isBookmarked) {
          // Normal bookmark styling
          containerColor = _bookmarkHighlightColor;
          borderColor = _bookmarkBorderColor;
        } else {
          // Default - no special styling
          containerColor = Colors.transparent;
          borderColor = Colors.transparent;
        }

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
              );
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.all((isSelected || isBookmarked || isActiveVerse) ? 12 : 0),
            decoration: (isSelected || isBookmarked || isActiveVerse)
                ? BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: borderColor,
                width: 1.5,
              ),
            )
                : null,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Space for bookmark icon if verse is bookmarked or active verse
                    if (isBookmarked || isActiveVerse)
                      SizedBox(width: 30),

                    // Main content with adjusted width
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Arabic verse text
                          Text(
                            arabicText,
                            style: ArabicTextStyle(
                              arabicFont: ArabicFont.lateef,
                              fontSize: 24 + (_fontSizeValue * 8),
                              color: AppColors.PrimaryColor,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),

                          // Add space between Arabic and English text
                          SizedBox(height: 14),

                          // English translation
                          Text(
                            englishText,
                            style: TextStyle(
                              fontFamily: GoogleFonts.merriweather().fontFamily,
                              fontSize: 13 + (_fontSizeValue * 8),
                              color: AppColors.PrimaryColor,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.left,
                          ),

                          // Add space between verses
                          if (index < arabicEntries.length - 1)
                            SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),

                // Display appropriate icon based on state
                if (isSelected || isBookmarked || isActiveVerse)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: isActiveVerse && !isBookmarked
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
        border: Border.all(
          color: AppColors.BarColor,
          width: 1.5,
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
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  'Rukū ${widget.rukuNumber}',
                  style: TextStyle(
                    color: AppColors.PrimaryColor,
                    fontSize: 24,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Main Content - Swipeable
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) {
                    if (details.primaryVelocity! > 0) {
                      // Swiped right - go to previous page
                      if (widget.onPrevPage != null && widget.currentPage > 1) {
                        widget.onPrevPage!();
                      }
                    } else if (details.primaryVelocity! < 0) {
                      // Swiped left - go to next page
                      if (widget.onNextPage != null && widget.currentPage < widget.totalPages) {
                        widget.onNextPage!();
                      }
                    }
                  },
                  child: _buildVersesPage(widget.startVerseIndex),
                ),
              ),

              // Footer
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
                        size: 18,
                      ),
                      onPressed: widget.currentPage > 1 ? widget.onPrevPage : null,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Page ${widget.currentPage} of ${widget.totalPages}',
                        style: TextStyle(
                          color: AppColors.PrimaryColor,
                          fontSize: 14,
                          fontFamily: GoogleFonts.merriweather().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.PrimaryColor,
                        size: 18,
                      ),
                      onPressed: widget.currentPage < widget.totalPages ? widget.onNextPage : null,
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