import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/RukuFirstReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/RukuSecondReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuThirdScreen/RukuThirdReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuFourthScreen/RukuFourthReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuFivethScreen/RukuFiveReadScreen.dart';
import 'package:surah_yaseen/services/analytics_service.dart';

/// Service to handle navigation to specific verses in Ruku screens
class VerseNavigationService {
  /// Navigate to a specific verse in the appropriate Ruku screen
  /// 
  /// [verseIndex] - The index of the verse (1-based)
  /// [rukuNumber] - The Ruku number (1-5)
  static void navigateToVerse({
    required int verseIndex,
    required int rukuNumber,
  }) {
    // Validate inputs
    // verseIndex can be 0 (Bismillah) or higher, rukuNumber should be 1-5
    if (verseIndex < 0 || rukuNumber < 1 || rukuNumber > 5) {
      debugPrint('Invalid navigation parameters: verseIndex=$verseIndex, rukuNumber=$rukuNumber');
      return;
    }

    // Calculate which page contains the verse based on Ruku
    int targetPage = _calculatePageForVerse(verseIndex, rukuNumber);

    // Prepare arguments to pass to the screen
    final arguments = {
      'initialPage': targetPage,
      'targetVerseIndex': verseIndex,
    };

    // Track ruku open event
    AnalyticsService.logRukuOpen(rukuNumber: rukuNumber);

    // Navigate to the appropriate Ruku Read Screen
    switch (rukuNumber) {
      case 1:
        Get.to(
          () => const RukuFirstReadScreen(),
          arguments: arguments,
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 2:
        Get.to(
          () => const RukuSecondReadScreen(),
          arguments: arguments,
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 3:
        Get.to(
          () => const RukuThirdReadScreen(),
          arguments: arguments,
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 4:
        Get.to(
          () => const RukuFourthReadScreen(),
          arguments: arguments,
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 5:
        Get.to(
          () => const RukuFiveReadScreen(),
          arguments: arguments,
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      default:
        debugPrint('Invalid Ruku number: $rukuNumber');
    }
  }

  /// Calculate which page contains the given verse
  /// 
  /// Verse ranges per Ruku (0-based indexing):
  /// Ruku 1: Verses 0-11 (Bismillah=0, Ya Seen=1, etc., 4 verses per page = 4 pages)
  /// Ruku 2: Verses 12-31 (4 verses per page = 5 pages)
  /// Ruku 3: Verses 32-49 (4 verses per page = 5 pages)
  /// Ruku 4: Verses 50-66 (4 verses per page = 5 pages)
  /// Ruku 5: Verses 67-82 (4 verses per page = 4 pages)
  static int _calculatePageForVerse(int verseIndex, int rukuNumber) {
    const int versesPerPage = 4;
    
    switch (rukuNumber) {
      case 1:
        // Verses 0-11 (0-based: Bismillah=0, Ya Seen=1, etc.)
        // Page 1: verses 0-3, Page 2: verses 4-7, Page 3: verses 8-11
        return (verseIndex / versesPerPage).floor() + 1;
      
      case 2:
        // Verses 13-32 (1-based)
        // Page 1: verses 13-16, Page 2: verses 17-20, etc.
        return ((verseIndex - 13) / versesPerPage).floor() + 1;
      
      case 3:
        // Verses 33-50 (1-based)
        return ((verseIndex - 33) / versesPerPage).floor() + 1;
      
      case 4:
        // Verses 51-67 (1-based)
        return ((verseIndex - 51) / versesPerPage).floor() + 1;
      
      case 5:
        // Verses 68-83 (1-based)
        return ((verseIndex - 68) / versesPerPage).floor() + 1;
      
      default:
        return 1;
    }
  }

  /// Parse notification payload and navigate
  /// Payload format: "verseIndex|rukuNumber"
  static void handleNotificationPayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      debugPrint('Empty notification payload');
      return;
    }

    try {
      final parts = payload.split('|');
      if (parts.length >= 2) {
        final verseIndex = int.parse(parts[0]);
        final rukuNumber = int.parse(parts[1]);
        navigateToVerse(verseIndex: verseIndex, rukuNumber: rukuNumber);
      } else {
        debugPrint('Invalid payload format: $payload');
      }
    } catch (e) {
      debugPrint('Error parsing notification payload: $e');
    }
  }
}
