import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

/// Manages TTS language availability and provides utilities to check and install languages
class TtsLanguageManager {
  final FlutterTts flutterTts;

  TtsLanguageManager(this.flutterTts);

  /// Check if Arabic language is available on the device
  Future<bool> isArabicAvailable() async {
    try {
      var languages = await flutterTts.getLanguages;
      bool hasArabic = languages.any(
        (lang) =>
            lang.toString().toLowerCase().contains('ar') ||
            lang.toString().toLowerCase().contains('arab'),
      );
      return hasArabic;
    } catch (e) {
      print("Error checking Arabic availability: $e");
      return false;
    }
  }

  /// Check if English language is available on the device
  Future<bool> isEnglishAvailable() async {
    try {
      var languages = await flutterTts.getLanguages;
      bool hasEnglish = languages.any(
        (lang) =>
            lang.toString().toLowerCase().contains('en') ||
            lang.toString().toLowerCase().contains('eng'),
      );
      return hasEnglish;
    } catch (e) {
      print("Error checking English availability: $e");
      return false;
    }
  }

  /// Get the best available Arabic language code
  Future<String?> getBestArabicLanguage() async {
    try {
      var languages = await flutterTts.getLanguages;
      var arabicLangs = languages
          .where(
            (lang) =>
                lang.toString().toLowerCase().contains('ar') ||
                lang.toString().toLowerCase().contains('arab'),
          )
          .toList();

      if (arabicLangs.isEmpty) return null;

      // Prefer full Arabic over dialect variants if available
      try {
        String arabicCode = arabicLangs.firstWhere(
          (lang) =>
              lang.toString().toLowerCase() == 'ar' ||
              lang.toString().toLowerCase() == 'ara' ||
              lang.toString().toLowerCase() == 'ar-sa' ||
              lang.toString().toLowerCase() == 'ar-eg',
          orElse: () => arabicLangs.first.toString(),
        );
        return arabicCode;
      } catch (e) {
        return arabicLangs.first.toString();
      }
    } catch (e) {
      print("Error getting Arabic language: $e");
      return null;
    }
  }

  /// Get the best available English language code
  Future<String?> getBestEnglishLanguage() async {
    try {
      var languages = await flutterTts.getLanguages;
      var englishLangs = languages
          .where(
            (lang) =>
                lang.toString().toLowerCase().contains('en') ||
                lang.toString().toLowerCase().contains('eng'),
          )
          .toList();

      if (englishLangs.isEmpty) return null;

      // Prefer US or UK English if available
      try {
        String englishCode = englishLangs.firstWhere(
          (lang) =>
              lang.toString().toLowerCase() == 'en-us' ||
              lang.toString().toLowerCase() == 'en-gb' ||
              lang.toString().toLowerCase() == 'en',
          orElse: () => englishLangs.first.toString(),
        );
        return englishCode;
      } catch (e) {
        return englishLangs.first.toString();
      }
    } catch (e) {
      print("Error getting English language: $e");
      return null;
    }
  }

  /// Check if a specific language is installed (Android only)
  Future<bool> isLanguageInstalled(String languageCode) async {
    if (Platform.isAndroid) {
      try {
        // Use the Android-specific method if available
        bool? installed = await flutterTts.isLanguageInstalled(languageCode);
        return installed ?? false;
      } catch (e) {
        print("Error checking if language is installed: $e");
        // Fallback to checking if it's in available languages
        return await _isLanguageInAvailableList(languageCode);
      }
    } else {
      // For iOS, just check if it's in available languages
      return await _isLanguageInAvailableList(languageCode);
    }
  }

  /// Helper method to check if language is in available languages list
  Future<bool> _isLanguageInAvailableList(String languageCode) async {
    try {
      var languages = await flutterTts.getLanguages;
      return languages.any(
        (lang) => lang.toString().toLowerCase() == languageCode.toLowerCase(),
      );
    } catch (e) {
      return false;
    }
  }

  /// Show dialog to guide user to install Arabic language
  Future<void> showArabicInstallDialog(BuildContext context) async {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final fontSize = isSmallScreen ? 14.0 : 16.0;
    final titleFontSize = isSmallScreen ? 18.0 : 20.0;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.9,
              maxHeight: screenSize.height * 0.7,
            ),
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Arabic Language Required',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Message
                  Text(
                    'Arabic text-to-speech is not available on your device. To use audio playback, please install Arabic language support:',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  SizedBox(height: 16),
                  
                  // Instructions
                  _buildInstructionItem(
                    context,
                    '1. Tap "Open Settings" below',
                    fontSize,
                  ),
                  SizedBox(height: 8),
                  _buildInstructionItem(
                    context,
                    '2. Find "Language" or "Text-to-speech" settings',
                    fontSize,
                  ),
                  SizedBox(height: 8),
                  _buildInstructionItem(
                    context,
                    '3. Install Arabic language pack',
                    fontSize,
                  ),
                  SizedBox(height: 8),
                  _buildInstructionItem(
                    context,
                    '4. Return to this app and try again',
                    fontSize,
                  ),
                  SizedBox(height: 24),
                  
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          openTtsSettings();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 20,
                            vertical: isSmallScreen ? 10 : 12,
                          ),
                        ),
                        child: Text(
                          'Open Settings',
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructionItem(
    BuildContext context,
    String text,
    double fontSize,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );
  }

  /// Open TTS settings on the device
  Future<void> openTtsSettings() async {
    try {
      if (Platform.isAndroid) {
        // Android: Open TTS settings
        const androidTtsSettings = 'android.settings.TTS_SETTINGS';
        final uri = Uri.parse('app-settings:$androidTtsSettings');
        
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback: Try to open general settings
          final generalSettings = Uri.parse('app-settings:');
          if (await canLaunchUrl(generalSettings)) {
            await launchUrl(generalSettings, mode: LaunchMode.externalApplication);
          }
        }
      } else if (Platform.isIOS) {
        // iOS: Open general settings (user needs to navigate to Accessibility > Spoken Content)
        final settingsUri = Uri.parse('app-settings:');
        if (await canLaunchUrl(settingsUri)) {
          await launchUrl(settingsUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      print("Error opening TTS settings: $e");
    }
  }

  /// Initialize and ensure Arabic language is available
  /// Returns true if Arabic is available, false otherwise
  Future<bool> ensureArabicAvailable(BuildContext context) async {
    bool isAvailable = await isArabicAvailable();
    
    if (!isAvailable) {
      // Show dialog to guide user
      await showArabicInstallDialog(context);
      // Check again after user might have installed it
      await Future.delayed(Duration(seconds: 1));
      isAvailable = await isArabicAvailable();
    }
    
    return isAvailable;
  }

  /// Initialize and ensure both Arabic and English languages are available
  /// Returns a map with availability status
  Future<Map<String, bool>> ensureLanguagesAvailable(BuildContext context) async {
    bool arabicAvailable = await isArabicAvailable();
    bool englishAvailable = await isEnglishAvailable();
    
    if (!arabicAvailable) {
      await showArabicInstallDialog(context);
      await Future.delayed(Duration(seconds: 1));
      arabicAvailable = await isArabicAvailable();
    }
    
    return {
      'arabic': arabicAvailable,
      'english': englishAvailable,
    };
  }
}
