import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:surah_yaseen/bookmark.dart';

import '../../services/notification_service.dart';

class BookmarkProvider with ChangeNotifier {
  late Box<Bookmark> _bookmarkBox;
  bool _isBoxLoaded = false;
  bool _isLoading = true;

  BookmarkProvider() {
    _loadBookmarks();
  }

  List<Bookmark> get bookmarks {
    if (!_isBoxLoaded) {
      return [];
    }
    return _bookmarkBox.values.toList();
  }

  bool get isLoading => _isLoading;

  // Method to check if a verse is bookmarked
  bool isVerseBookmarked(int verseIndex, int rukuNumber) {
    if (!_isBoxLoaded) {
      return false;
    }
    return _bookmarkBox.containsKey('$verseIndex-$rukuNumber');
  }

  // Get the icon type for a bookmarked verse
  String getVerseBookmarkIconType(int verseIndex, int rukuNumber) {
    if (!_isBoxLoaded) {
      return 'quran'; // Default to quran if box isn't loaded
    }

    String key = '$verseIndex-$rukuNumber';
    if (_bookmarkBox.containsKey(key)) {
      Bookmark? bookmark = _bookmarkBox.get(key);
      return bookmark?.iconType ?? 'quran';
    }

    return 'quran'; // Default to quran if bookmark not found
  }

  // Fixed deleteAllBookmarks method
  Future<void> deleteAllBookmarks() async {
    try {
      if (_isBoxLoaded) {
        // Clear all bookmarks from the Hive box
        await _bookmarkBox.clear();
        print("All bookmarks deleted successfully");
        notifyListeners();
      }
    } catch (e) {
      print("Error deleting all bookmarks: $e");
    }
  }

  Future<void> _loadBookmarks() async {
    try {
      // Check if the box is already open
      if (Hive.isBoxOpen('bookmarks')) {
        _bookmarkBox = Hive.box<Bookmark>('bookmarks');
      } else {
        _bookmarkBox = await Hive.openBox<Bookmark>('bookmarks');
      }
      _isBoxLoaded = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error loading bookmarks: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addVerseBookmark({
    required String arabicText,
    required String englishText,
    required int verseIndex,
    required int rukuNumber,
    String iconType = 'quran', // Default to quran, but allow override
  }) async {
    // Check if bookmark already exists
    if (isVerseBookmarked(verseIndex, rukuNumber)) {
      print("Bookmark already exists!");
      return false; // Return false to indicate bookmark wasn't added
    }

    final now = DateTime.now();
    final date = "${now.day}-${now.month}-${now.year}";

    final bookmark = Bookmark(
      arabicText: arabicText,
      englishText: englishText,
      verseIndex: verseIndex,
      rukuNumber: rukuNumber,
      date: date,
      title: 'Rukū $rukuNumber, Verse $verseIndex',
      iconType: iconType, // Use the passed iconType
    );

    try {
      await _bookmarkBox.put('$verseIndex-$rukuNumber', bookmark);
      print("Bookmark added: ${bookmark.title} with icon type: ${bookmark.iconType}");
      print("Total bookmarks: ${_bookmarkBox.values.length}");
      notifyListeners();

      await NotificationService.showBookmarkNotification(bookmark.title);

      return true; // Return true to indicate bookmark was added successfully
    } catch (e) {
      print("Error adding bookmark: $e");
      return false; // Return false if there was an error
    }
  }

  Future<void> removeBookmark(int index) async {
    try {
      await _bookmarkBox.deleteAt(index);
      notifyListeners();
    } catch (e) {
      print("Error removing bookmark: $e");
    }
  }

  // Additional method to remove bookmark by key
  Future<void> removeBookmarkByKey(String key) async {
    try {
      await _bookmarkBox.delete(key);
      notifyListeners();
    } catch (e) {
      print("Error removing bookmark by key: $e");
    }
  }
}