import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'dart:async';
import 'dart:math';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../../services/tts_language_manager.dart';
import '../../services/analytics_service.dart';

enum TtsState { playing, stopped, paused, continued }
enum ContentType { arabic, english }

class RukuAudioPlayerWithTranslation extends StatefulWidget {
  final String? title;
  final Map<int, String> verses;
  final int startVerse;
  final int endVerse;
  final int? rukuNumber; // Ruku number for analytics tracking
  final Function(int)? onActiveVerseChanged; // Callback to notify parent about active verse

  const RukuAudioPlayerWithTranslation({
    super.key,
    this.title,
    required this.verses,
    this.startVerse = 0,
    this.endVerse = 12,
    this.rukuNumber,
    this.onActiveVerseChanged,
  });

  @override
  State<RukuAudioPlayerWithTranslation> createState() =>
      _RukuAudioPlayerWithTranslationState();
}

class _RukuAudioPlayerWithTranslationState
    extends State<RukuAudioPlayerWithTranslation>
    with WidgetsBindingObserver {
  // TTS Engine
  FlutterTts flutterTts = FlutterTts();
  TtsLanguageManager? languageManager;
  TtsState ttsState = TtsState.stopped;

  // TTS Parameters - optimized for Quranic recitation
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.4;
  String? arabicLanguage;
  String? englishLanguage;
  double currentPosition = 0.0;
  double totalDuration = 0.0;
  Timer? progressTimer;
  DateTime? lastUpdateTime;
  double lastPosition = 0.0;
  double verseProgress = 0.0;
  double currentContentStartPosition = 0.0;
  double currentContentDuration = 0.0;

  // Current verse tracking
  int currentVerseIndex = 0;
  ContentType currentContentType = ContentType.arabic; // Start with Arabic
  List<int> verseKeys = [];
  List<String> arabicVerseTexts = [];
  List<String> englishTranslations = [];
  List<double> verseEstimatedDurations = []; // Store estimated durations per verse
  List<double> translationEstimatedDurations = []; // Store translation durations

  // UI state management
  bool isSpeaking = false;
  bool isTtsInitialized = false;
  bool hasArabicLanguageSupport = false;
  bool hasEnglishLanguageSupport = false;
  bool isProcessing = false;
  bool showTroubleshooting = false; // Control visibility of troubleshooting button

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    languageManager = TtsLanguageManager(flutterTts);
    _initVerses();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      debugPrint("Initializing Flutter TTS engine...");

      // Set up TTS parameters
      await flutterTts.setVolume(volume);
      await flutterTts.setPitch(pitch);
      await flutterTts.setSpeechRate(rate);

      // Check if Arabic and English are available and guide user to install if needed
      bool arabicAvailable = await languageManager!.isArabicAvailable();
      bool englishAvailable = await languageManager!.isEnglishAvailable();
      
      if (!arabicAvailable && mounted) {
        // Show dialog to guide user to install Arabic
        await languageManager!.showArabicInstallDialog(context);
        // Check again after user might have installed it
        await Future.delayed(Duration(seconds: 1));
        arabicAvailable = await languageManager!.isArabicAvailable();
      }

      // Set Arabic language preference
      if (arabicAvailable) {
        arabicLanguage = await languageManager!.getBestArabicLanguage();
        if (arabicLanguage != null) {
          debugPrint("Setting Arabic language to: $arabicLanguage");
          hasArabicLanguageSupport = true;
        } else {
          hasArabicLanguageSupport = false;
        }
      } else {
        debugPrint("Arabic not found");
        hasArabicLanguageSupport = false;
      }

      // Set English language preference
      if (englishAvailable) {
        englishLanguage = await languageManager!.getBestEnglishLanguage();
        if (englishLanguage != null) {
          debugPrint("Setting English language to: $englishLanguage");
          hasEnglishLanguageSupport = true;
        } else {
          hasEnglishLanguageSupport = false;
        }
      } else {
        // Use default language if English not available
        var languages = await flutterTts.getLanguages;
        englishLanguage = languages.isNotEmpty ? languages.first.toString() : null;
        debugPrint("English not found specifically, using default language: $englishLanguage");
        hasEnglishLanguageSupport = englishLanguage != null;
      }

      // Configure TTS event handlers
      flutterTts.setStartHandler(() {
        setState(() {
          debugPrint("TTS started speaking");
          ttsState = TtsState.playing;
          isSpeaking = true;
          isProcessing = false;
        });
        _startProgressTimer();
      });

      flutterTts.setCompletionHandler(() {
        debugPrint("TTS completed speaking content for verse $currentVerseIndex, type: $currentContentType");

        // Don't reset isSpeaking flag yet
        setState(() {
          isProcessing = false;
        });

        // Handle the completion based on current content type
        _handleContentCompletion();
      });

      flutterTts.setErrorHandler((msg) {
        setState(() {
          debugPrint("TTS error: $msg");
          ttsState = TtsState.stopped;
          isSpeaking = false;
          isProcessing = false;

          // Show troubleshooting button when there's an error
          showTroubleshooting = true;
        });

        // Check if error is related to language support
        if (msg.toString().toLowerCase().contains('language') ||
            msg.toString().toLowerCase().contains('arabic')) {
          // Show dialog to guide user to install Arabic
          if (mounted) {
            languageManager?.showArabicInstallDialog(context);
          }
        }

        // Show error message to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Speech error: $msg"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
      });

      flutterTts.setCancelHandler(() {
        setState(() {
          debugPrint("TTS cancelled");
          ttsState = TtsState.stopped;
          isSpeaking = false;
          isProcessing = false;
        });
      });

      flutterTts.setPauseHandler(() {
        setState(() {
          debugPrint("TTS paused");
          ttsState = TtsState.paused;
          isSpeaking = false;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          debugPrint("TTS continued");
          ttsState = TtsState.continued;
          isSpeaking = true;
        });
      });

      // Load translations
      _loadTranslations();

      // Calculate estimated duration based on verse content
      _calculateContentDurations();

      setState(() {
        isTtsInitialized = true;
      });

      debugPrint("TTS initialization complete!");
    } catch (e) {
      debugPrint("Error initializing TTS: $e");
      setState(() {
        isTtsInitialized = false;
        hasArabicLanguageSupport = false;
        hasEnglishLanguageSupport = false;
        showTroubleshooting = true;
      });
    }
  }

  void _initVerses() {
    debugPrint("Initializing verses from map with ${widget.verses.length} entries");

    // Guard against empty verses map
    if (widget.verses.isEmpty) {
      debugPrint("WARNING: Empty verses map provided!");
      verseKeys = [];
      arabicVerseTexts = [];
      return;
    }

    // Get all verse keys and sort them
    verseKeys = widget.verses.keys.toList();
    debugPrint("Raw verse keys: $verseKeys");

    // Sort keys based on verse number
    verseKeys.sort();
    debugPrint("Sorted verse keys: $verseKeys");

    // Get the verse texts in order
    arabicVerseTexts = verseKeys.map((key) => widget.verses[key]!).toList();

    // Validate verse texts aren't empty
    bool hasEmptyVerses = arabicVerseTexts.any((verse) => verse.trim().isEmpty);
    if (hasEmptyVerses) {
      debugPrint("WARNING: Some verses have empty text!");
    }

    // Set starting verse based on widget parameter
    currentVerseIndex = 0; // Always start at first filtered verse

    // Adjust end verse if needed
    int endVerse = widget.endVerse < 0 ? verseKeys.length - 1 : widget.endVerse;
    if (endVerse >= verseKeys.length) {
      endVerse = verseKeys.length - 1;
    }
    debugPrint("Ending verse index: $endVerse");

    // Keep only the verses within the range
    if (widget.startVerse > 0 || widget.endVerse >= 0) {
      if (verseKeys.length > widget.startVerse) {
        verseKeys = verseKeys.sublist(
          widget.startVerse,
          min(endVerse + 1, verseKeys.length),
        );
        arabicVerseTexts = arabicVerseTexts.sublist(
          widget.startVerse,
          min(endVerse + 1, arabicVerseTexts.length),
        );
        debugPrint(
          "Filtered to ${verseKeys.length} verses from index ${widget.startVerse} to $endVerse",
        );
      } else {
        debugPrint(
          "WARNING: Start verse index ${widget.startVerse} is out of bounds!",
        );
      }
    }

    // Print the actual verses for debugging
    for (int i = 0; i < arabicVerseTexts.length; i++) {
      debugPrint(
        "Verse $i: ${arabicVerseTexts[i].substring(0, min(30, arabicVerseTexts[i].length))}...",
      );
    }
  }

  void _loadTranslations() {
    // Initialize translations list with the same length as verses
    englishTranslations = List<String>.filled(verseKeys.length, "");

    // Load translations from AppStrings
    for (int i = 0; i < verseKeys.length; i++) {
      int verseKey = verseKeys[i]; // Get the actual verse number from verseKeys

      // Get the translation using the verse key directly
      String translationKey = "verse_$verseKey"; // Use the actual verse number, not the index

      // Try to get the translation from AppStrings
      try {
        // Access the translation directly using the real verse number
        String translation = AppStrings.yasinSurahStrings.versesEnglish[translationKey] ?? "Translation not available";

        englishTranslations[i] = translation;
        debugPrint("Loaded translation for verse $verseKey: ${englishTranslations[i].substring(0, min(30, englishTranslations[i].length))}...");
      } catch (e) {
        debugPrint("Error loading translation for verse_$verseKey: $e");
        englishTranslations[i] = "Translation not available";
      }
    }
  }

  void _calculateContentDurations() {
    // Clear any previous calculations
    verseEstimatedDurations = [];
    translationEstimatedDurations = [];

    // Base duration for short verses/translations (in seconds)
    const double arabicBaseDuration = 3.0;
    const double englishBaseDuration = 2.0;

    // Estimate time based on content length
    double totalEstimatedDuration = 0.0;

    // Calculate for Arabic verses
    for (String verse in arabicVerseTexts) {
      // Calculate estimated time based on character count
      int charCount = verse.trim().length;
      // Arabic recitation is slower
      double estimatedDuration = max(arabicBaseDuration, charCount * 0.25);
      verseEstimatedDurations.add(estimatedDuration);
      totalEstimatedDuration += estimatedDuration;
    }

    // Calculate for English translations
    for (String translation in englishTranslations) {
      // Calculate estimated time based on character count - English is generally faster than Arabic
      int charCount = translation.trim().length;
      double estimatedDuration = max(englishBaseDuration, charCount * 0.08);
      translationEstimatedDurations.add(estimatedDuration);
      totalEstimatedDuration += estimatedDuration;
    }

    // Set the total duration (for both Arabic and English)
    totalDuration = max(10.0, totalEstimatedDuration);
    debugPrint("Total estimated duration (all verses + translations): $totalDuration seconds");
  }

  void _startProgressTimer() {
    _stopProgressTimer();
    lastUpdateTime = DateTime.now();
    lastPosition = currentPosition;

    // Calculate starting position and duration for current content
    currentContentStartPosition = _calculateCurrentContentStartPosition();
    currentContentDuration = _getCurrentContentDuration();

    // Create smoother progress updates (60 updates per second)
    progressTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
        setState(() {
          if (lastUpdateTime != null) {
            // Calculate elapsed time since last update
            double elapsedSeconds =
                DateTime.now().difference(lastUpdateTime!).inMilliseconds /
                    1000.0;
            lastUpdateTime = DateTime.now();

            // Calculate progress within current content (0.0 to 1.0)
            verseProgress = min(
              (currentPosition - currentContentStartPosition) /
                      currentContentDuration +
                  (elapsedSeconds / currentContentDuration),
              1.0,
            );

            // Update current position smoothly
            double newPosition =
                currentPosition + (elapsedSeconds * (currentContentDuration / 3.0));

            // Ensure we don't overshoot the current content's duration
            if (newPosition <= currentContentStartPosition + currentContentDuration) {
              currentPosition = newPosition;
              lastPosition = currentPosition;
            } else {
              // If we've reached the end of the current content, we'll let the completion handler
              // handle the transition
              _stopProgressTimer();
            }
          }
        });
      }
    });
  }

  // Calculate the starting position of current content (verse or translation)
  double _calculateCurrentContentStartPosition() {
    double position = 0.0;

    // Add duration of all completed verses and their translations
    for (int i = 0; i < currentVerseIndex; i++) {
      position += verseEstimatedDurations[i];
      position += translationEstimatedDurations[i];
    }

    // If we're on a translation, add the duration of the current verse
    if (currentContentType == ContentType.english) {
      position += verseEstimatedDurations[currentVerseIndex];
    }

    return position;
  }

  // Get the duration of the current content (verse or translation)
  double _getCurrentContentDuration() {
    if (currentContentType == ContentType.arabic) {
      return currentVerseIndex < verseEstimatedDurations.length
          ? verseEstimatedDurations[currentVerseIndex]
          : 3.0;
    } else {
      return currentVerseIndex < translationEstimatedDurations.length
          ? translationEstimatedDurations[currentVerseIndex]
          : 2.0;
    }
  }

  void _stopProgressTimer() {
    progressTimer?.cancel();
    progressTimer = null;
    lastUpdateTime = null;
    lastPosition = currentPosition;
    verseProgress = 0.0;
  }

  @override
  void dispose() {
    flutterTts.stop();
    _stopProgressTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      flutterTts.pause();
    } else if (state == AppLifecycleState.resumed && !hasArabicLanguageSupport) {
      _recheckArabicAfterReturn();
    }
  }

  Future<void> _recheckArabicAfterReturn() async {
    if (languageManager == null) return;
    bool available = await languageManager!.isArabicAvailable();
    if (available && mounted) {
      arabicLanguage = await languageManager!.getBestArabicLanguage();
      if (arabicLanguage != null) {
        await flutterTts.setLanguage(arabicLanguage!);
        setState(() {
          hasArabicLanguageSupport = true;
          isTtsInitialized = true;
        });
        debugPrint("Arabic now available after returning from settings: $arabicLanguage");
      }
    }
  }

  Future<void> troubleshootTTS() async {
    try {
      debugPrint("=== TTS TROUBLESHOOTING ===");
      debugPrint("TTS initialized: $isTtsInitialized");
      debugPrint("Arabic language: $arabicLanguage");
      debugPrint("English language: $englishLanguage");

      if (languageManager != null && mounted) {
        await languageManager!.showTroubleshootDialog(
          context,
          isTtsInitialized: isTtsInitialized,
          hasLanguageSupport: hasArabicLanguageSupport,
          currentLanguage: arabicLanguage ?? englishLanguage,
        );
      }

      debugPrint("=== END TROUBLESHOOTING ===");
    } catch (e) {
      debugPrint("Error during troubleshooting: $e");
    }
  }

  void _handlePlayPause() {
    if (isProcessing) {
      debugPrint("TTS is currently processing, please wait");
      return;
    }

    if (!isTtsInitialized) {
      debugPrint("TTS not initialized, cannot play/pause");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Speech engine not available. Please check your device settings.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (arabicVerseTexts.isEmpty) {
      debugPrint("No verses to play");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No verses available to play."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    debugPrint("Play button pressed. Current state: $ttsState");

    setState(() {
      isProcessing = true;
    });

    if (ttsState == TtsState.playing) {
      debugPrint("Pausing playback");
      _pause();
    } else if (ttsState == TtsState.paused) {
      debugPrint("Resuming playback");
      _resume();
    } else {
      debugPrint("Starting playback from beginning");
      // Track audio play event
      if (widget.rukuNumber != null) {
        AnalyticsService.logAudioPlay(rukuNumber: widget.rukuNumber!);
      }
      _speakFromStart();
    }
  }

  void _handleContentCompletion() {
    if (currentContentType == ContentType.arabic) {
      // Just finished an Arabic verse, now play its English translation
      setState(() {
        currentContentType = ContentType.english;
      });
      _speakCurrentContent();
    } else {
      // Just finished an English translation, move to next verse
      int nextVerseIndex = currentVerseIndex + 1;

      if (nextVerseIndex < arabicVerseTexts.length) {
        // We have more verses to play

        // First notify parent about the new verse
        if (widget.onActiveVerseChanged != null) {
          widget.onActiveVerseChanged!(verseKeys[nextVerseIndex]);
        }

        // Update our internal state
        setState(() {
          currentVerseIndex = nextVerseIndex;
          currentContentType = ContentType.arabic; // Reset to Arabic for next verse
        });

        // Speak the next verse
        _speakCurrentContent();
      } else {
        // We've completed all verses and translations
        // Track recitation complete event
        if (widget.rukuNumber != null) {
          AnalyticsService.logRecitationComplete(rukuNumber: widget.rukuNumber!);
        }
        setState(() {
          ttsState = TtsState.stopped;
          isSpeaking = false;
          _stopProgressTimer();
          currentPosition = totalDuration;
        });
      }
    }
  }

  Future<void> _speakFromStart() async {
    debugPrint("Speaking from start");

    // Reset verse index and content type
    setState(() {
      currentVerseIndex = 0;
      currentContentType = ContentType.arabic;
    });

    // Notify parent about the active verse
    if (widget.onActiveVerseChanged != null && verseKeys.isNotEmpty) {
      widget.onActiveVerseChanged!(verseKeys[0]);
    }

    // Start speaking
    _speakCurrentContent();
  }

  Future<void> _speakCurrentContent() async {
    if (!isTtsInitialized) {
      debugPrint("TTS not initialized, cannot speak");
      setState(() {
        isProcessing = false;
      });
      return;
    }

    String textToSpeak;
    String? languageToUse;

    if (currentContentType == ContentType.arabic) {
      // Speaking Arabic verse
      textToSpeak = arabicVerseTexts[currentVerseIndex];
      languageToUse = arabicLanguage;
      debugPrint("Speaking Arabic verse $currentVerseIndex: ${textToSpeak.substring(0, min(20, textToSpeak.length))}...");
    } else {
      // Speaking English translation
      textToSpeak = englishTranslations[currentVerseIndex];
      languageToUse = englishLanguage;
      debugPrint("Speaking English translation $currentVerseIndex: ${textToSpeak.substring(0, min(20, textToSpeak.length))}...");
    }

    if (textToSpeak.trim().isEmpty) {
      debugPrint("WARNING: Empty text, skipping...");
      _handleContentCompletion(); // Skip to next content
      return;
    }

    // Set the appropriate language
    if (languageToUse != null) {
      await flutterTts.setLanguage(languageToUse);
    } else {
      debugPrint("WARNING: No language available for ${currentContentType.toString()}, using default");
    }

    // Start progress timer before speaking
    _startProgressTimer();

    // Add pause after each verse/translation
    textToSpeak = textToSpeak + (currentContentType == ContentType.arabic ? "، " : ". ");

    // Update state before speaking
    setState(() {
      isSpeaking = true;
    });

    // Actually speak the text
    var result = await flutterTts.speak(textToSpeak);
    debugPrint("Speak result: $result");

    if (result != 1) {
      debugPrint("Failed to speak, error code: $result");
      setState(() {
        isProcessing = false;
        ttsState = TtsState.stopped;
        isSpeaking = false;
        showTroubleshooting = true;
      });
    }
  }

  Future<void> _pause() async {
    var result = await flutterTts.pause();
    debugPrint("Pause result: $result");
    // Track audio pause event
    if (widget.rukuNumber != null) {
      AnalyticsService.logAudioPause(rukuNumber: widget.rukuNumber!);
    }
    _stopProgressTimer();
    setState(() {
      isProcessing = false;
    });
  }

  Future<void> _resume() async {
    // Set the appropriate language before resuming
    String? languageToUse = currentContentType == ContentType.arabic
        ? arabicLanguage
        : englishLanguage;

    if (languageToUse != null) {
      await flutterTts.setLanguage(languageToUse);
    }

    // Get the current content to speak
    String textToSpeak = currentContentType == ContentType.arabic
        ? arabicVerseTexts[currentVerseIndex]
        : englishTranslations[currentVerseIndex];

    var result = await flutterTts.speak(textToSpeak);
    debugPrint("Resume result: $result");

    setState(() {
      isProcessing = false;
    });
  }

  Future<void> _stop() async {
    var result = await flutterTts.stop();
    debugPrint("Stop result: $result");
    _stopProgressTimer();

    // Notify parent about resetting to the first verse
    if (widget.onActiveVerseChanged != null && verseKeys.isNotEmpty) {
      widget.onActiveVerseChanged!(verseKeys[0]);
    }

    setState(() {
      ttsState = TtsState.stopped;
      isSpeaking = false;
      currentPosition = 0.0;
      currentVerseIndex = 0;
      currentContentType = ContentType.arabic;
      isProcessing = false;
    });
  }

  void _skipForward() {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    // Stop current playback
    flutterTts.stop();

    // Handle different skipping behavior based on current content type
    if (currentContentType == ContentType.arabic) {
      // Skip to the translation of current verse
      setState(() {
        currentContentType = ContentType.english;
        _updatePositionToCurrentContent();
        isProcessing = false;
      });
    } else {
      // Skip to the next verse
      int nextVerseIndex = currentVerseIndex + 1;
      if (nextVerseIndex < arabicVerseTexts.length) {
        // Notify parent about the new active verse
        if (widget.onActiveVerseChanged != null) {
          widget.onActiveVerseChanged!(verseKeys[nextVerseIndex]);
        }

        setState(() {
          currentVerseIndex = nextVerseIndex;
          currentContentType = ContentType.arabic;
          _updatePositionToCurrentContent();
          isProcessing = false;
        });
      } else {
        setState(() {
          isProcessing = false;
        });
      }
    }

    // If was playing, continue playing from new content
    if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
      _speakCurrentContent();
    }
  }

  void _skipBackward() {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    // Stop current playback
    flutterTts.stop();

    // Handle different skipping behavior based on current content type
    if (currentContentType == ContentType.english) {
      // Go back to the Arabic verse of current index
      setState(() {
        currentContentType = ContentType.arabic;
        _updatePositionToCurrentContent();
        isProcessing = false;
      });
    } else {
      // Go back to previous verse
      int prevVerseIndex = currentVerseIndex - 1;
      if (prevVerseIndex >= 0) {
        // Notify parent about the new active verse
        if (widget.onActiveVerseChanged != null) {
          widget.onActiveVerseChanged!(verseKeys[prevVerseIndex]);
        }

        setState(() {
          currentVerseIndex = prevVerseIndex;
          currentContentType = ContentType.arabic;
          _updatePositionToCurrentContent();
          isProcessing = false;
        });
      } else {
        setState(() {
          isProcessing = false;
        });
      }
    }

    // If was playing, continue playing from new content
    if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
      _speakCurrentContent();
    }
  }

  // Helper method to update position based on current content
  void _updatePositionToCurrentContent() {
    currentPosition = _calculateCurrentContentStartPosition();
  }

  // Jump to a specific position in the playback
  void _jumpToPosition(double position) {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    _stop().then((_) {
      // Calculate which verse and content type this position corresponds to
      double accumulatedDuration = 0.0;
      int targetVerseIndex = 0;
      ContentType targetContentType = ContentType.arabic;

      for (int i = 0; i < arabicVerseTexts.length; i++) {
        // Check if position is within the Arabic verse
        double arabicEndPosition = accumulatedDuration + verseEstimatedDurations[i];
        if (position >= accumulatedDuration && position < arabicEndPosition) {
          targetVerseIndex = i;
          targetContentType = ContentType.arabic;
          break;
        }

        accumulatedDuration = arabicEndPosition;

        // Check if position is within the English translation
        double englishEndPosition = accumulatedDuration + translationEstimatedDurations[i];
        if (position >= accumulatedDuration && position < englishEndPosition) {
          targetVerseIndex = i;
          targetContentType = ContentType.english;
          break;
        }

        accumulatedDuration = englishEndPosition;

        // If we're past this verse completely, continue to next
        targetVerseIndex = i + 1;
        targetContentType = ContentType.arabic;
      }

      // Ensure the index is valid
      if (targetVerseIndex >= arabicVerseTexts.length) {
        targetVerseIndex = arabicVerseTexts.length - 1;
        targetContentType = ContentType.english;
      }

      // Update the position and verse information
      setState(() {
        currentVerseIndex = targetVerseIndex;
        currentContentType = targetContentType;
        currentPosition = position;
        isProcessing = false;
      });

      // Notify parent about the new active verse
      if (widget.onActiveVerseChanged != null) {
        widget.onActiveVerseChanged!(verseKeys[targetVerseIndex]);
      }

      // If was playing, continue playing from new position
      if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
        _speakCurrentContent();
      }
    });
  }

  String _formatDuration(double seconds) {
    int mins = (seconds / 60).floor();
    int secs = (seconds % 60).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = isSmallScreen ? 15.0 : 20.0;
    final sliderPadding = isSmallScreen ? 10.0 : 15.0;
    final titleFontSize = isSmallScreen ? 18.0 : 20.0;
    final indicatorFontSize = isSmallScreen ? 11.0 : 12.0;
    final iconSize = isSmallScreen ? 24.0 : 30.0;
    final playButtonSize = isSmallScreen ? 45.0 : 50.0;
    final buttonSpacing = isSmallScreen ? 20.0 : 25.0;
    final thumbRadius = isSmallScreen ? 6.0 : 8.0;
    final trackHeight = isSmallScreen ? 3.0 : 4.0;

    double sliderValue = totalDuration > 0
        ? (currentPosition / totalDuration).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title Text
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title ?? AppStrings.listenAudioWithTranslationScreenString.Ruku1title,
              style: TextStyle(
                fontSize: titleFontSize,
                fontFamily: GoogleFonts.merriweather().fontFamily,
                fontWeight: FontWeight.bold,
                color: AppColors.PrimaryColor,
              ),
            ),
          ),
        ),

        // Language support indicator
        if (!hasArabicLanguageSupport && isTtsInitialized)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              "Arabic TTS not available on this device",
              style: TextStyle(color: Colors.red, fontSize: indicatorFontSize),
            ),
          ),

        // TTS initialization status
        if (!isTtsInitialized)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: isSmallScreen ? 16 : 20,
                  height: isSmallScreen ? 16 : 20,
                  child: CircularProgressIndicator(
                    color: AppColors.PrimaryColor,
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 8 : 10),
                Flexible(
                  child: Text(
                    "Initializing speech engine...",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: indicatorFontSize),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

        // Slider + Time Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sliderPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SliderTheme(
                data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: thumbRadius),
                  trackHeight: trackHeight,
                ),
                child: Slider(
                  value: sliderValue,
                  onChanged: (value) {
                    double newPosition = value * totalDuration;
                    _jumpToPosition(newPosition);
                  },
                  activeColor: AppColors.PrimaryColor,
                  divisions: 50000,
                  inactiveColor: AppColors.AudioPlayerInActiveColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12.0 : 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(currentPosition),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: isSmallScreen ? 11.0 : 12.0,
                      ),
                    ),
                    Text(
                      _formatDuration(totalDuration),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: isSmallScreen ? 11.0 : 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Control Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _iconControlButton(
              SvgPicture.asset(AppAssets.backwardarrow, width: iconSize, height: iconSize),
              _skipBackward,
              tooltip: "Previous verse",
              iconSize: iconSize,
            ),
            SizedBox(width: buttonSpacing),
            _roundPlayButton(
              ttsState == TtsState.playing || ttsState == TtsState.continued,
              _handlePlayPause,
              buttonSize: playButtonSize,
            ),
            SizedBox(width: buttonSpacing),
            _iconControlButton(
              SvgPicture.asset(AppAssets.forwardarrow, width: iconSize, height: iconSize),
              _skipForward,
              tooltip: "Next verse",
              iconSize: iconSize,
            ),
          ],
        ),

        // Troubleshooting button
        if (showTroubleshooting)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: TextButton.icon(
              onPressed: troubleshootTTS,
              icon: Icon(Icons.build_circle_rounded, size: 16, color: AppColors.colorone),
              label: Text(
                "Troubleshoot TTS Engine",
                style: TextStyle(
                  fontSize: isSmallScreen ? 12.0 : 14.0,
                  color: AppColors.colorone,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _iconControlButton(
    Widget icon,
    Function() onPressed, {
    String? tooltip,
    double iconSize = 30,
  }) {
    return Tooltip(
      message: tooltip ?? "",
      child: IconButton(
        icon: icon,
        onPressed: isProcessing ? null : onPressed,
        iconSize: iconSize,
      ),
    );
  }

  Widget _roundPlayButton(bool isPlaying, Function() onPressed, {double buttonSize = 50}) {
    final iconSize = buttonSize * 0.4;
    final borderWidth = buttonSize * 0.06;
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.BarColor, width: borderWidth),
        color: AppColors.PrimaryColor,
      ),
      child: IconButton(
        icon: Stack(
          alignment: Alignment.center,
          children: [
            isProcessing
                ? SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : SvgPicture.asset(
                    isPlaying ? AppAssets.pause_button : AppAssets.play_button,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  ),
          ],
        ),
        onPressed: isProcessing ? null : onPressed,
        iconSize: buttonSize,
        tooltip: isPlaying ? "Pause" : "Play",
      ),
    );
  }
}

