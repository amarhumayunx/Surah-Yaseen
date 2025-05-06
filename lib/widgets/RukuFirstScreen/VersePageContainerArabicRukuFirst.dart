import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:surah_yaseen/widgets/dialogs/BookmarkConfirmDialog.dart';
import '../../Colors/colors.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../BookmarkScreen/BookmarkProvider.dart';
import '../FontSize/FontSizeProvider.dart';

class ArabicVerseContainerRukuFirst extends StatefulWidget {
  final int rukuNumber;
  final int startVerseIndex;
  final int lastVerseIndex;
  final int versesPerPage;
  final int currentPage;
  final int totalPages;
  final bool isListeningAudio; // New property to check if user is listening to audio
  final Function(int)? onPageChanged;
  final VoidCallback? onPrevPage;
  final VoidCallback? onNextPage;

  const ArabicVerseContainerRukuFirst({
    Key? key,
    required this.rukuNumber,
    required this.startVerseIndex,
    required this.lastVerseIndex,
    required this.versesPerPage,
    required this.currentPage,
    required this.totalPages,
    this.isListeningAudio = false, // Default is reading mode (not listening to audio)
    this.onPageChanged,
    this.onPrevPage,
    this.onNextPage,
  }) : super(key: key);

  @override
  State<ArabicVerseContainerRukuFirst> createState() => _ArabicVerseContainerState();
}

class _ArabicVerseContainerState extends State<ArabicVerseContainerRukuFirst> {
  int? _longPressedVerseIndex;
  final Color _bookmarkHighlightColor = Color(0xFFF6FAF7); // Soft greenish background
  final Color _bookmarkBorderColor = Color(0xFFCCE7D5); // Green border

  @override
  void didUpdateWidget(ArabicVerseContainerRukuFirst oldWidget) {
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

    // Determine the icon type based on whether the user is listening to audio
    String iconType = widget.isListeningAudio ? 'audio' : 'quran';

    // Add the verse to bookmarks with the appropriate icon type
    bool wasAdded = await bookmarkProvider.addVerseBookmark(
      arabicText: arabicText,
      englishText: "", // Empty since we're only showing Arabic
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

    List<MapEntry<String, String>> arabicEntries = [];

    for (int i = startIdx; i < startIdx + widget.versesPerPage && i <= widget.lastVerseIndex; i++) {
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
            padding: EdgeInsets.all((isSelected || isBookmarked) ? 12 : 0),
            decoration: (isSelected || isBookmarked)
                ? BoxDecoration(
              color: _bookmarkHighlightColor, // Soft greenish background
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _bookmarkBorderColor, // Green border
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
                              fontSize: 24 + (_fontSizeValue * 8),
                              color: AppColors.PrimaryColor,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
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

                // Bookmark icon that appears when verse is selected or bookmarked
                if (isSelected || isBookmarked)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: bookmarkIconType == 'audio'
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
      height: 300,
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