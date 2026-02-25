import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../Colors/colors.dart';

class TtsLanguageManager {
  final FlutterTts flutterTts;
  static const _channel = MethodChannel('com.amarhumayun.surahyaseen/tts');

  TtsLanguageManager(this.flutterTts);

  Future<bool> isArabicAvailable() async {
    try {
      var languages = await flutterTts.getLanguages;
      return languages.any(
        (lang) =>
            lang.toString().toLowerCase().contains('ar') ||
            lang.toString().toLowerCase().contains('arab'),
      );
    } catch (e) {
      debugPrint("Error checking Arabic availability: $e");
      return false;
    }
  }

  Future<bool> isEnglishAvailable() async {
    try {
      var languages = await flutterTts.getLanguages;
      return languages.any(
        (lang) =>
            lang.toString().toLowerCase().contains('en') ||
            lang.toString().toLowerCase().contains('eng'),
      );
    } catch (e) {
      debugPrint("Error checking English availability: $e");
      return false;
    }
  }

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
      debugPrint("Error getting Arabic language: $e");
      return null;
    }
  }

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
      debugPrint("Error getting English language: $e");
      return null;
    }
  }

  Future<bool> isLanguageInstalled(String languageCode) async {
    if (Platform.isAndroid) {
      try {
        bool? installed = await flutterTts.isLanguageInstalled(languageCode);
        return installed ?? false;
      } catch (e) {
        debugPrint("Error checking if language is installed: $e");
        return await _isLanguageInAvailableList(languageCode);
      }
    } else {
      return await _isLanguageInAvailableList(languageCode);
    }
  }

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

  /// Triggers Android's native TTS data install activity
  Future<bool> _installTtsData() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod('installTtsData');
      return result == true;
    } catch (e) {
      debugPrint("Error launching TTS install: $e");
      return false;
    }
  }

  /// Opens device TTS settings directly via platform channel (Android) or url_launcher (iOS)
  Future<bool> _openTtsSettings() async {
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('openTtsSettings');
        return result == true;
      } else if (Platform.isIOS) {
        // iOS doesn't have a direct TTS settings intent
        return false;
      }
    } catch (e) {
      debugPrint("Error opening TTS settings: $e");
    }
    return false;
  }

  /// Show themed dialog to guide user to install Arabic TTS language
  Future<void> showArabicInstallDialog(BuildContext context) async {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final dialogWidth = screenSize.width * 0.85;
    const dialogMaxWidth = 420.0;
    final padding = isSmallScreen ? 16.0 : 24.0;
    final iconSize = isSmallScreen ? 40.0 : 48.0;
    final titleFontSize = isSmallScreen ? 17.0 : 19.0;
    final bodyFontSize = isSmallScreen ? 13.0 : 14.5;
    final buttonFontSize = isSmallScreen ? 13.0 : 15.0;
    final merriweather = GoogleFonts.merriweather().fontFamily;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColors.lightColorapp,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: dialogMaxWidth,
              maxHeight: screenSize.height * 0.72,
            ),
            padding: EdgeInsets.all(padding),
            width: dialogWidth.clamp(280.0, dialogMaxWidth),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: iconSize + 20,
                    height: iconSize + 20,
                    decoration: BoxDecoration(
                      color: AppColors.PrimaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.record_voice_over_rounded,
                      size: iconSize,
                      color: AppColors.darkgreenColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Text(
                    'Arabic Voice Required',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontFamily: merriweather,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkgreenColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 14),
                  Text(
                    'Arabic text-to-speech is not installed on your device. '
                    'Please download the Arabic voice to listen to Surah Yaseen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      color: AppColors.textGray,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 22),

                  _buildStep(
                    '1',
                    'Tap "Download Arabic" below',
                    bodyFontSize,
                  ),
                  SizedBox(height: 8),
                  _buildStep(
                    '2',
                    'Select Arabic language from the list',
                    bodyFontSize,
                  ),
                  SizedBox(height: 8),
                  _buildStep(
                    '3',
                    'Wait for download to complete',
                    bodyFontSize,
                  ),
                  SizedBox(height: 8),
                  _buildStep(
                    '4',
                    'Return to this app and play again',
                    bodyFontSize,
                  ),

                  SizedBox(height: isSmallScreen ? 20 : 26),

                  // Primary action: Download Arabic
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Get.back();
                        if (Platform.isAndroid) {
                          bool launched = await _installTtsData();
                          if (!launched) {
                            await _openTtsSettings();
                          }
                        } else {
                          await _openTtsSettings();
                        }
                      },
                      icon: Icon(Icons.download_rounded, size: 20),
                      label: Text(
                        'Download Arabic',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontFamily: merriweather,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.colorone,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 14,
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Secondary: Open TTS settings
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        Get.back();
                        await _openTtsSettings();
                      },
                      icon: Icon(Icons.settings_rounded, size: 18),
                      label: Text(
                        'Open TTS Settings',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontFamily: merriweather,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.colorone,
                        side: BorderSide(color: AppColors.colorone),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 10 : 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Cancel
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        color: AppColors.textGray,
                        fontFamily: merriweather,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(String number, String text, double fontSize) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.PrimaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.textGray,
            ),
          ),
        ),
      ],
    );
  }

  /// Shows a themed troubleshooting dialog matching the app style
  Future<void> showTroubleshootDialog(
    BuildContext context, {
    required bool isTtsInitialized,
    required bool hasLanguageSupport,
    String? currentLanguage,
  }) async {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final dialogWidth = screenSize.width * 0.85;
    const dialogMaxWidth = 420.0;
    final padding = isSmallScreen ? 16.0 : 24.0;
    final titleFontSize = isSmallScreen ? 17.0 : 19.0;
    final bodyFontSize = isSmallScreen ? 13.0 : 14.0;
    final buttonFontSize = isSmallScreen ? 13.0 : 15.0;
    final merriweather = GoogleFonts.merriweather().fontFamily;

    var languages = <dynamic>[];
    String? engine;
    try {
      languages = await flutterTts.getLanguages;
      engine = await flutterTts.getDefaultEngine;
    } catch (_) {}

    final arabicLangs = languages
        .where((l) => l.toString().toLowerCase().contains('ar'))
        .toList();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.lightColorapp,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: dialogMaxWidth,
            maxHeight: screenSize.height * 0.7,
          ),
          padding: EdgeInsets.all(padding),
          width: dialogWidth.clamp(280.0, dialogMaxWidth),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.build_circle_rounded,
                  size: isSmallScreen ? 36 : 44,
                  color: AppColors.PrimaryColor,
                ),
                SizedBox(height: 12),
                Text(
                  'TTS Diagnostics',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontFamily: merriweather,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkgreenColor,
                  ),
                ),
                SizedBox(height: 16),
                _buildInfoRow('Engine', engine ?? 'Unknown', bodyFontSize),
                _buildInfoRow('Language', currentLanguage ?? 'Not set', bodyFontSize),
                _buildInfoRow(
                  'Arabic',
                  hasLanguageSupport ? 'Available' : 'Not Available',
                  bodyFontSize,
                  valueColor: hasLanguageSupport
                      ? AppColors.colorone
                      : AppColors.errorRed,
                ),
                _buildInfoRow(
                  'TTS Ready',
                  isTtsInitialized ? 'Yes' : 'No',
                  bodyFontSize,
                  valueColor: isTtsInitialized
                      ? AppColors.colorone
                      : AppColors.errorRed,
                ),
                if (arabicLangs.isNotEmpty) ...[
                  SizedBox(height: 8),
                  _buildInfoRow(
                    'Arabic Voices',
                    arabicLangs.join(', '),
                    bodyFontSize,
                  ),
                ],
                SizedBox(height: 20),
                if (!hasLanguageSupport) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Get.back();
                        if (Platform.isAndroid) {
                          bool launched = await _installTtsData();
                          if (!launched) await _openTtsSettings();
                        } else {
                          await _openTtsSettings();
                        }
                      },
                      icon: Icon(Icons.download_rounded, size: 18),
                      label: Text(
                        'Download Arabic',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontFamily: merriweather,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.colorone,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      await flutterTts.speak("بسم الله الرحمن الرحيم");
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.colorone,
                      side: BorderSide(color: AppColors.colorone),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Test Arabic Voice',
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        fontFamily: merriweather,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      color: AppColors.textGray,
                      fontFamily: merriweather,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    double fontSize, {
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: AppColors.darkgreenColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
                color: valueColor ?? AppColors.textGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> ensureArabicAvailable(BuildContext context) async {
    bool isAvailable = await isArabicAvailable();

    if (!isAvailable) {
      await showArabicInstallDialog(context);
      await Future.delayed(Duration(seconds: 1));
      isAvailable = await isArabicAvailable();
    }

    return isAvailable;
  }

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
