import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Colors/colors.dart';
import '../../bookmark.dart';
import '../../constants/app_strings.dart';
import '../TopBar/topbartest.dart';
import 'BookmarkProvider.dart';
import '../Dividerbar/dividerbar.dart';
import '../SurahTitle/surat_title.dart';
import 'filter_row.dart';
import 'title_card.dart';
import 'bookmark_item.dart';
import '../Ads/native_style_ad_widget.dart';
import '../../constants/ad_unit_ids.dart';

class BookmarkScreenBody extends StatefulWidget {
  const BookmarkScreenBody({super.key});

  @override
  State<BookmarkScreenBody> createState() => _BookmarkScreenBodyState();
}

class _BookmarkScreenBodyState extends State<BookmarkScreenBody> {
  String _selectedFilter = AppStrings.bookmarkScreenBodystrings.all;
  int _selectedBookmarkIndex = -1;
  String _searchQuery = '';
  bool _deleteMode = false;
  final Set<int> _selectedForDeletion = {};

  void _onBookmarkTapped(int index) {
    setState(() {
      if (_deleteMode) {
        if (_selectedForDeletion.contains(index)) {
          _selectedForDeletion.remove(index);
        } else {
          _selectedForDeletion.add(index);
        }
      } else {
        if (_selectedBookmarkIndex == index) {
          _selectedBookmarkIndex = -1;
        } else {
          _selectedBookmarkIndex = index;
        }
      }
    });
  }

  void _filterBookmarks(List<Bookmark> bookmarks) {
    if (_selectedFilter == 'recents'.tr) {
      final DateTime now = DateTime.now();
      final DateTime last24Hours = now.subtract(const Duration(hours: 24));

      final List<Bookmark> recentBookmarks =
          bookmarks.where((bookmark) {
            try {
              final parts = bookmark.date.split('-').map(int.parse).toList();
              if (parts.length != 3) return false;
              final bookmarkDate = DateTime(parts[2], parts[1], parts[0]);
              return bookmarkDate.isAfter(last24Hours) ||
                  bookmarkDate.isAtSameMomentAs(last24Hours);
            } catch (_) {
              return false;
            }
          }).toList();

      bookmarks.clear();
      bookmarks.addAll(recentBookmarks);

      bookmarks.sort((a, b) {
        try {
          final aParts = a.date.split('-').map(int.parse).toList();
          final bParts = b.date.split('-').map(int.parse).toList();
          if (aParts.length != 3 || bParts.length != 3) return 0;
          if (aParts[2] != bParts[2]) return bParts[2] - aParts[2];
          if (aParts[1] != bParts[1]) return bParts[1] - aParts[1];
          return bParts[0] - aParts[0];
        } catch (_) {
          return 0;
        }
      });
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      bookmarks.retainWhere(
        (bookmark) =>
            bookmark.title.toLowerCase().contains(query) ||
            bookmark.arabicText.toLowerCase().contains(query) ||
            bookmark.englishText.toLowerCase().contains(query),
      );
    }
  }

  void _toggleDeleteMode() {
    setState(() {
      _deleteMode = !_deleteMode;
      if (!_deleteMode) {
        _selectedForDeletion.clear();
      }
    });
  }

  void _deleteSelectedBookmarks() {
    final bookmarkProvider = Provider.of<BookmarkProvider>(
      context,
      listen: false,
    );

    final indexesToDelete =
        _selectedForDeletion.toList()..sort((a, b) => b.compareTo(a));

    for (final index in indexesToDelete) {
      bookmarkProvider.removeBookmark(index);
    }

    setState(() {
      _deleteMode = false;
      _selectedForDeletion.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          indexesToDelete.length == 1
              ? 'bookmark_deleted'.tr
              : '${indexesToDelete.length} bookmarks_deleted'.tr,
        ),
        backgroundColor: AppColors.PrimaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: AppColors.lightColorSec,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 280,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete_outline,
                    size: 40,
                    color: Color(0xFF4CAF87),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'delete_dialog_title'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4CAF87),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _deleteSelectedBookmarks();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF87),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'yes'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4CAF87),
                            side: const BorderSide(color: Color(0xFF4CAF87)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'no'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _selectAllBookmarks() {
    final bookmarks =
        Provider.of<BookmarkProvider>(context, listen: false).bookmarks;
    setState(() {
      if (_selectedForDeletion.length == bookmarks.length) {
        _selectedForDeletion.clear();
      } else {
        _selectedForDeletion.clear();
        for (int i = 0; i < bookmarks.length; i++) {
          _selectedForDeletion.add(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);

    if (bookmarkProvider.isLoading) {
      return SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'loading'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.PrimaryColor,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Bookmark> filteredBookmarks = List.from(bookmarkProvider.bookmarks);
    _filterBookmarks(filteredBookmarks);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double paddingHorizontal = screenWidth * 0.01;
    final double imageHeight = screenHeight * 0.15;
    final double spacing = screenHeight * 0.02;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const TopBarSet(),
          SizedBox(height: spacing),
          const DividerBar(),
          const SurahTitle(),
          TitleCardBookmark(),
          FilterRow(
            selectedFilter: _selectedFilter,
            onFilterSelected: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            onSearch: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            onShowDeleteMode: _toggleDeleteMode,
          ),

          // ✅ Expanded with Stack for fade effect
          Expanded(
            child: Stack(
              children: [
                // Scrollable content
                SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_deleteMode)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _selectAllBookmarks,
                                child: Text(
                                  'select_all'.tr,
                                  style: TextStyle(
                                    color: AppColors.PrimaryColor,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                                ),
                              ),
                              if (_selectedForDeletion.isNotEmpty)
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: AppColors.PrimaryColor,
                                  ),
                                  onPressed:
                                      () => _showDeleteConfirmation(context),
                                ),
                            ],
                          ),
                        ),
                      SizedBox(height: spacing),

                      Container(
                        constraints: const BoxConstraints(minHeight: 200),
                        child:
                            filteredBookmarks.isEmpty
                                ? _buildEmptyState()
                                : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children:
                                        filteredBookmarks.asMap().entries.map((
                                          entry,
                                        ) {
                                          final int index = bookmarkProvider
                                              .bookmarks
                                              .indexOf(entry.value);
                                          final Bookmark bookmark = entry.value;
                                          final bool isSelected =
                                              _selectedForDeletion.contains(
                                                index,
                                              );
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap:
                                                    () => _onBookmarkTapped(
                                                      index,
                                                    ),
                                                child: Stack(
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    BookmarkItem(
                                                      arabicText:
                                                          bookmark.arabicText,
                                                      title: bookmark.title,
                                                      date: bookmark.date,
                                                      iconType:
                                                          bookmark.iconType,
                                                      isSelected: isSelected,
                                                      isInDeleteMode:
                                                          _deleteMode,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (_selectedBookmarkIndex ==
                                                      index &&
                                                  !_deleteMode)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 10,
                                                        bottom: 5,
                                                      ),
                                                  child: _buildBookmarkDetails(
                                                    bookmark,
                                                  ),
                                                ),
                                              SizedBox(height: spacing),
                                            ],
                                          );
                                        }).toList(),
                                  ),
                                ),
                      ),
                      const NativeStyleAdWidget(
                        screenType: AdScreenType.bookmark,
                        minHeight: 60,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // ✅ Top fade effect
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.lightColorSec,
                            AppColors.lightColorSec.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 60, color: AppColors.PrimaryColor),
          const SizedBox(height: 20),
          Text(
            _searchQuery.isNotEmpty
                ? 'no_matching_bookmarks_found'.tr
                : 'no_bookmarks_yet'.tr,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.PrimaryColor,
              fontFamily: GoogleFonts.merriweather().fontFamily,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _searchQuery.isNotEmpty
                ? 'try_a_different_search_term'.tr
                : 'long_press_on_any_verse_to_bookmark_it'.tr,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.PrimaryColor,
              fontFamily: GoogleFonts.merriweather().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkDetails(Bookmark bookmark) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.BarColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'verse_details'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.PrimaryColor,
              fontFamily: GoogleFonts.merriweather().fontFamily,
            ),
          ),
          Divider(color: AppColors.BarColor),
          const SizedBox(height: 0),
          Text(
            bookmark.arabicText,
            style: ArabicTextStyle(
              arabicFont: ArabicFont.lateef,
              fontSize: 24,
              color: AppColors.PrimaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 5),
          Text(
            bookmark.englishText,
            style: TextStyle(
              fontSize: 14,
              fontFamily: GoogleFonts.merriweather().fontFamily,
              color: AppColors.BarColor,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.bookmark, color: AppColors.PrimaryColor, size: 16),
              const SizedBox(width: 2),
              Text(
                '${'added_on'.tr} ${bookmark.date}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  color: AppColors.PrimaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
