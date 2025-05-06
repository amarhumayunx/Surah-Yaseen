import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Colors/colors.dart';
import '../../bookmark.dart';
import '../../constants/app_strings.dart';
import '../TopBar/topbar.dart';
import 'BookmarkProvider.dart';
import '../Dividerbar/dividerbar.dart';
import '../SurahTitle/surat_title.dart';
import 'filter_row.dart';
import 'title_card.dart';
import 'bookmark_item.dart';

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
  bool _noRecentBookmarks = false;

  // Method to handle bookmark icon tap
  void _onBookmarkTapped(int index) {
    setState(() {
      if (_deleteMode) {
        // In delete mode, select/deselect for deletion
        if (_selectedForDeletion.contains(index)) {
          _selectedForDeletion.remove(index);
        } else {
          _selectedForDeletion.add(index);
        }
      } else {
        // Normal mode, expand/collapse details
        if (_selectedBookmarkIndex == index) {
          _selectedBookmarkIndex = -1;
        } else {
          _selectedBookmarkIndex = index;
        }
      }
    });
  }

  void _filterBookmarks(List<Bookmark> bookmarks) {
    // Reset the no recent bookmarks flag
    _noRecentBookmarks = false;

    if (_selectedFilter == AppStrings.bookmarkScreenBodystrings.recents) {
      // Get current date and time
      final DateTime now = DateTime.now();
      final DateTime last24Hours = now.subtract(const Duration(hours: 24));

      // Filter bookmarks to only show those added in the last 24 hours
      final List<Bookmark> recentBookmarks = bookmarks.where((bookmark) {
        // Parse the date from dd-mm-yyyy format
        final parts = bookmark.date.split('-').map(int.parse).toList();
        // Create DateTime object (day, month, year)
        final bookmarkDate = DateTime(parts[2], parts[1], parts[0]);

        // Check if the bookmark was added within the last 24 hours
        return bookmarkDate.isAfter(last24Hours) ||
            bookmarkDate.isAtSameMomentAs(last24Hours);
      }).toList();

      // Clear the original list and add only recent bookmarks
      bookmarks.clear();
      bookmarks.addAll(recentBookmarks);

      // Sort by most recent first
      bookmarks.sort((a, b) {
        // Parse dates (dd-mm-yyyy)
        final aParts = a.date.split('-').map(int.parse).toList();
        final bParts = b.date.split('-').map(int.parse).toList();

        // Compare year, then month, then day
        if (aParts[2] != bParts[2]) return bParts[2] - aParts[2]; // Year
        if (aParts[1] != bParts[1]) return bParts[1] - aParts[1]; // Month
        return bParts[0] - aParts[0]; // Day
      });

      // Set flag if no recent bookmarks
      if (bookmarks.isEmpty) {
        _noRecentBookmarks = true;
      }
    }

    // Apply search filter if any
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      bookmarks.retainWhere((bookmark) =>
      bookmark.title.toLowerCase().contains(query) ||
          bookmark.arabicText.toLowerCase().contains(query) ||
          (bookmark.englishText.toLowerCase().contains(query) ?? false)
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
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);

    // Convert to list and sort in descending order to avoid index shifting issues
    final indexesToDelete = _selectedForDeletion.toList()
      ..sort((a, b) => b.compareTo(a));

    for (final index in indexesToDelete) {
      bookmarkProvider.removeBookmark(index);
    }

    setState(() {
      _deleteMode = false;
      _selectedForDeletion.clear();
    });

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          indexesToDelete.length == 1
              ? 'Bookmark deleted'
              : '${indexesToDelete.length} bookmarks deleted',
        ),
        backgroundColor: AppColors.PrimaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.lightColorSec,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 280,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete_outline, size: 40, color: Color(0xFF4CAF87)),
              const SizedBox(height: 15),
              Text(
                'Confirm Delete?',
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
                        _deleteSelectedBookmarks(); // your deletion logic
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF87),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'YES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4CAF87),
                        side: const BorderSide(color: Color(0xFF4CAF87)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'NO',
                        style: TextStyle(
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
    final bookmarks = Provider.of<BookmarkProvider>(context, listen: false).bookmarks;
    setState(() {
      if (_selectedForDeletion.length == bookmarks.length) {
        // If all are selected, unselect all
        _selectedForDeletion.clear();
      } else {
        // Otherwise, select all
        _selectedForDeletion.clear();
        for (int i = 0; i < bookmarks.length; i++) {
          _selectedForDeletion.add(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the BookmarkProvider
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);

    // Create a mutable copy for filtering
    List<Bookmark> filteredBookmarks = List.from(bookmarkProvider.bookmarks);

    // Apply filters
    _filterBookmarks(filteredBookmarks);

    return SafeArea(
      child: Column(
        children: [
          const TopBar(),
          const SizedBox(height: 17),
          const DividerBar(),
          const SurahTitle(),
          TitleCardBookmark(),
          // Added SingleChildScrollView right after TitleCardBookmark
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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

                  // Select All row when in delete mode
                  if (_deleteMode)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _selectAllBookmarks,
                            child: Text(
                              "Select All",
                              style: TextStyle(
                                color: AppColors.PrimaryColor,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                          if (_selectedForDeletion.isNotEmpty)
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: AppColors.PrimaryColor),
                              onPressed: () => _showDeleteConfirmation(context),
                            ),
                        ],
                      ),
                    ),

                  // Bookmark content section
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 200, // Ensures a minimum area for scroll behavior
                    ),
                    child: filteredBookmarks.isEmpty
                        ? _buildEmptyState()
                        : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: filteredBookmarks.asMap().entries.map((entry) {
                          final int index = bookmarkProvider.bookmarks.indexOf(entry.value); // Original index
                          final Bookmark bookmark = entry.value;
                          final bool isSelected = _selectedForDeletion.contains(index);

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () => _onBookmarkTapped(index),
                                child: Stack(
                                  children: [
                                    // Main Bookmark Card
                                    BookmarkItem(
                                      arabicText: bookmark.arabicText,
                                      title: bookmark.title,
                                      date: bookmark.date,
                                      iconType: bookmark.iconType,
                                      isSelected: isSelected,
                                      isInDeleteMode: _deleteMode,
                                    ),

                                    // Delete mode circular checkmark indicator

                                  ],
                                ),
                              ),

                              // Expanded details (only when selected and not in delete mode)
                              if (_selectedBookmarkIndex == index && !_deleteMode)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                                  child: _buildBookmarkDetails(bookmark),
                                ),

                              const SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 60,
            color: AppColors.PrimaryColor,
          ),
          const SizedBox(height: 20),
          Text(
            _searchQuery.isNotEmpty
                ? 'No matching bookmarks found'
                : 'No bookmarks yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.PrimaryColor,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try a different search term'
                : 'Long press on any verse to bookmark it',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.PrimaryColor,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkDetails(Bookmark bookmark) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFCCE7D5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verse Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.PrimaryColor,
            ),
          ),
          Divider(color: AppColors.BarColor),
          const SizedBox(height: 8),
          Text(
            bookmark.arabicText,
            style: TextStyle(
              fontFamily: GoogleFonts.merriweather().fontFamily,
              fontSize: 20,
              color: AppColors.PrimaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 10),
          Text(
            bookmark.englishText ?? 'No translation available',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.BarColor,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.bookmark, color: AppColors.PrimaryColor, size: 16),
              const SizedBox(width: 5),
              Text(
                'Added on: ${bookmark.date}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}