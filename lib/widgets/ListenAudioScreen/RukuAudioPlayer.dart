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

class RukuAudioPlayer extends StatefulWidget {
  final String? title;
  final Map<int, String> verses;
  final int startVerse;
  final int endVerse;
  final int? rukuNumber; // Ruku number for analytics tracking
  final Function(int)? onActiveVerseChanged; // Callback to notify parent about active verse

  const RukuAudioPlayer({
    super.key,
    this.title,
    required this.verses,
    this.startVerse = 0,
    this.endVerse = 12,
    this.rukuNumber,
    this.onActiveVerseChanged,
  });

  @override
  State<RukuAudioPlayer> createState() => _RukuAudioPlayerState();
}

class _RukuAudioPlayerState extends State<RukuAudioPlayer>
    with WidgetsBindingObserver {
  // TTS Engine
  FlutterTts flutterTts = FlutterTts();
  TtsLanguageManager? languageManager;
  TtsState ttsState = TtsState.stopped;

  // TTS Parameters - optimized for Quranic recitation
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.4;
  String? language;
  double currentPosition = 0.0;
  double totalDuration = 0.0;
  Timer? progressTimer;
  DateTime? lastUpdateTime;
  double lastPosition = 0.0;
  double verseProgress = 0.0;
  double currentVerseStartPosition = 0.0;
  double currentVerseDuration = 0.0;

  // Current verse tracking
  int currentVerseIndex = 0;
  List<int> verseKeys = [];
  List<String> verseTexts = [];
  List<double> verseEstimatedDurations = []; // Store estimated durations per verse

  // UI state management
  bool isSpeaking = false;
  bool isTtsInitialized = false;
  bool hasLanguageSupport = false;
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

      // Check if Arabic is available and guide user to install if needed
      bool arabicAvailable = await languageManager!.isArabicAvailable();
      
      if (!arabicAvailable && mounted) {
        // Show dialog to guide user to install Arabic
        await languageManager!.showArabicInstallDialog(context);
        // Check again after user might have installed it
        await Future.delayed(Duration(seconds: 1));
        arabicAvailable = await languageManager!.isArabicAvailable();
      }

      // Set language preference - try Arabic first, then fall back to default
      if (arabicAvailable) {
        language = await languageManager!.getBestArabicLanguage();
        if (language != null) {
          debugPrint("Setting language to: $language");
          await flutterTts.setLanguage(language!);
          hasLanguageSupport = true;
        } else {
          hasLanguageSupport = false;
        }
      } else {
        // Use default language if Arabic not available
        var languages = await flutterTts.getLanguages;
        language = languages.isNotEmpty ? languages.first.toString() : null;
        debugPrint("Arabic not found, using default language: $language");
        if (language != null) {
          await flutterTts.setLanguage(language!);
        }
        hasLanguageSupport = false;
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
        debugPrint("TTS completed speaking verse $currentVerseIndex");

        // Don't reset isSpeaking flag yet if moving to next verse
        bool isLastVerse = currentVerseIndex >= verseTexts.length - 1;

        setState(() {
          isProcessing = false;

          // Only set isSpeaking to false if we're at the last verse
          if (isLastVerse) {
            isSpeaking = false;
          }
        });

        // Start speaking next verse outside setState to prevent UI jumps
        if (!isLastVerse) {
          // DO NOT increment the verse index here yet
          // We'll do that in _speakCurrentVerse after notifying about the new verse

          // Call _speakCurrentVerse but with explicit next index
          _speakNextVerse();
        } else {
          // Track recitation complete event
          if (widget.rukuNumber != null) {
            AnalyticsService.logRecitationComplete(rukuNumber: widget.rukuNumber!);
          }
          setState(() {
            ttsState = TtsState.stopped;
            _stopProgressTimer();
            currentPosition = totalDuration;
          });
        }
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

      // Calculate estimated duration based on verse content
      _calculateVerseDurations();

      setState(() {
        isTtsInitialized = true;
      });

      debugPrint("TTS initialization complete!");
    } catch (e) {
      debugPrint("Error initializing TTS: $e");
      setState(() {
        isTtsInitialized = false;
        hasLanguageSupport = false;
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
      verseTexts = [];
      return;
    }

    // Get all verse keys and sort them
    verseKeys = widget.verses.keys.toList();
    debugPrint("Raw verse keys: $verseKeys");

    // Sort keys based on verse number
    verseKeys.sort();
    debugPrint("Sorted verse keys: $verseKeys");

    // Get the verse texts in order
    verseTexts = verseKeys.map((key) => widget.verses[key]!).toList();

    // Validate verse texts aren't empty
    bool hasEmptyVerses = verseTexts.any((verse) => verse.trim().isEmpty);
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
        verseTexts = verseTexts.sublist(
          widget.startVerse,
          min(endVerse + 1, verseTexts.length),
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
    for (int i = 0; i < verseTexts.length; i++) {
      debugPrint(
        "Verse $i: ${verseTexts[i].substring(0, min(30, verseTexts[i].length))}...",
      );
    }
  }

  void _calculateVerseDurations() {
    // Clear any previous calculations
    verseEstimatedDurations = [];

    // Base duration for short verses (in seconds)
    const double baseDuration = 1.0;

    // Adjust this factor to match your TTS engine's speed setting
    // For rate = 0.5, a multiplier between 0.15-0.2 tends to work well
    const double charTimeFactor = 0.10;

    // Estimate time based on content length
    double totalEstimatedDuration = 0.0;

    for (String verse in verseTexts) {
      // Calculate estimated time based on character count
      int charCount = verse.trim().length;

      // More accurate formula that accounts for your TTS rate setting of 0.5
      double estimatedDuration = max(baseDuration, charCount * charTimeFactor);

      // Add this verse's duration to our list
      verseEstimatedDurations.add(estimatedDuration);
      totalEstimatedDuration += estimatedDuration;
    }

    // Set the total duration
    totalDuration = max(10.0, totalEstimatedDuration);
    debugPrint("Total estimated duration: $totalDuration seconds");
  }

  void _startProgressTimer() {
    _stopProgressTimer();
    lastUpdateTime = DateTime.now();
    lastPosition = currentPosition;

    // Calculate starting position and duration for current verse
    currentVerseStartPosition = 0.0;
    for (int i = 0; i < currentVerseIndex; i++) {
      if (i < verseEstimatedDurations.length) {
        currentVerseStartPosition += verseEstimatedDurations[i];
      }
    }

    currentVerseDuration = currentVerseIndex < verseEstimatedDurations.length
        ? verseEstimatedDurations[currentVerseIndex]
        : 3.0;

    // Create smoother progress updates (60fps)
    progressTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
        setState(() {
          if (lastUpdateTime != null) {
            // Calculate elapsed time since last update
            double elapsedSeconds =
                DateTime.now().difference(lastUpdateTime!).inMilliseconds /
                    1000.0;
            lastUpdateTime = DateTime.now();

            // Calculate progress within current verse (0.0 to 1.0)
            verseProgress = min(
              (currentPosition - currentVerseStartPosition) /
                      currentVerseDuration +
                  (elapsedSeconds / currentVerseDuration),
              1.0,
            );

            // Update current position based on real-time elapsed duration
            // This is the key change - use a direct 1:1 time ratio
            double newPosition = currentPosition + elapsedSeconds;

            // Ensure we don't overshoot the current verse's duration
            if (newPosition <=
                currentVerseStartPosition + currentVerseDuration) {
              currentPosition = newPosition;
              lastPosition = currentPosition;
            } else {
              // Cap at the end of the current verse
              currentPosition = currentVerseStartPosition + currentVerseDuration;
              lastPosition = currentPosition;
              _stopProgressTimer();
            }
          }
        });
      }
    });
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
    } else if (state == AppLifecycleState.resumed && !hasLanguageSupport) {
      _recheckArabicAfterReturn();
    }
  }

  Future<void> _recheckArabicAfterReturn() async {
    if (languageManager == null) return;
    bool available = await languageManager!.isArabicAvailable();
    if (available && mounted) {
      language = await languageManager!.getBestArabicLanguage();
      if (language != null) {
        await flutterTts.setLanguage(language!);
        setState(() {
          hasLanguageSupport = true;
          isTtsInitialized = true;
        });
        debugPrint("Arabic now available after returning from settings: $language");
      }
    }
  }

  Future<void> troubleshootTTS() async {
    try {
      debugPrint("=== TTS TROUBLESHOOTING ===");
      debugPrint("TTS initialized: $isTtsInitialized");
      debugPrint("Current language: $language");

      if (languageManager != null && mounted) {
        await languageManager!.showTroubleshootDialog(
          context,
          isTtsInitialized: isTtsInitialized,
          hasLanguageSupport: hasLanguageSupport,
          currentLanguage: language,
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

    if (verseTexts.isEmpty) {
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

  Future<void> _speakNextVerse() async {
    // First increment our verse index
    int nextVerseIndex = currentVerseIndex + 1;

    // Then notify parent about the active verse change BEFORE starting to speak
    if (widget.onActiveVerseChanged != null &&
        nextVerseIndex < verseKeys.length) {
      widget.onActiveVerseChanged!(verseKeys[nextVerseIndex]);
    }

    // Now update our internal state
    setState(() {
      currentVerseIndex = nextVerseIndex;
    });

    // Finally speak the verse
    _speakCurrentVerse();
  }

  Future<void> _speakFromStart() async {
    debugPrint("Speaking from start");

    // FIRST set currentVerseIndex to 0
    setState(() {
      currentVerseIndex = 0;
    });

    // THEN notify parent about the active verse that will be active (verse 0)
    if (widget.onActiveVerseChanged != null && verseKeys.isNotEmpty) {
      widget.onActiveVerseChanged!(verseKeys[0]);
    }

    // Finally, start speaking
    _speakCurrentVerse();
  }

  Future<void> _speakCurrentVerse() async {
    if (!isTtsInitialized) {
      debugPrint("TTS not initialized, cannot speak verse");
      setState(() {
        isProcessing = false;
      });
      return;
    }

    if (currentVerseIndex < verseTexts.length) {
      String textToSpeak = verseTexts[currentVerseIndex];
      debugPrint(
        "Speaking verse $currentVerseIndex: ${textToSpeak.substring(0, min(20, textToSpeak.length))}...",
      );

      if (textToSpeak.trim().isEmpty) {
        debugPrint("WARNING: Empty verse text, skipping...");
        _speakNextVerse(); // Use our new method
        return;
      }

      // Start progress timer before speaking
      _startProgressTimer();

      // Add tajweed pause after each verse
      textToSpeak = "$textToSpeak، ";

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
    } else {
      debugPrint(
        "Attempted to speak verse $currentVerseIndex but only have ${verseTexts.length} verses",
      );
      setState(() {
        isProcessing = false;
        isSpeaking = false;
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
    // FlutterTts has a continue method
    if (await flutterTts.isLanguageAvailable(language ?? "en-US")) {
      var result = await flutterTts.speak(verseTexts[currentVerseIndex]);
      debugPrint("Resume result: $result");
    } else {
      debugPrint("Language not available for resume");
    }
    setState(() {
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

    // Calculate the next verse index
    int nextVerseIndex = currentVerseIndex + 1;
    if (nextVerseIndex < verseTexts.length) {
      // IMPORTANT: First notify parent about the new active verse before updating state
      if (widget.onActiveVerseChanged != null &&
          nextVerseIndex < verseKeys.length) {
        widget.onActiveVerseChanged!(verseKeys[nextVerseIndex]);
      }

      // Then update our internal state
      setState(() {
        currentVerseIndex = nextVerseIndex;
        // Update position based on current verse
        _updatePositionToCurrentVerse();
        isProcessing = false;
      });

      // If was playing, continue playing from new verse
      if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
        _speakCurrentVerse();
      }
    } else {
      setState(() {
        isProcessing = false;
      });
    }
  }

  void _skipBackward() {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    // Stop current playback
    flutterTts.stop();

    // Calculate the previous verse index
    int prevVerseIndex = currentVerseIndex - 1;
    if (prevVerseIndex >= 0) {
      // IMPORTANT: First notify parent about the new active verse before updating state
      if (widget.onActiveVerseChanged != null &&
          prevVerseIndex < verseKeys.length) {
        widget.onActiveVerseChanged!(verseKeys[prevVerseIndex]);
      }

      // Then update our internal state
      setState(() {
        currentVerseIndex = prevVerseIndex;
        // Update position based on current verse
        _updatePositionToCurrentVerse();
        isProcessing = false;
      });

      // If was playing, continue playing from new verse
      if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
        _speakCurrentVerse();
      }
    } else {
      setState(() {
        isProcessing = false;
      });
    }
  }

  // Helper method to update position based on current verse
  void _updatePositionToCurrentVerse() {
    double position = 0.0;
    for (int i = 0; i < currentVerseIndex; i++) {
      if (i < verseEstimatedDurations.length) {
        position += verseEstimatedDurations[i];
      }
    }
    currentPosition = position;
  }

  // Jump to a specific position in the text
  void _jumpToPosition(double position) {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    // Stop current playback
    flutterTts.stop();

    // Calculate which verse this position corresponds to
    double accumulatedDuration = 0.0;
    int targetVerseIndex = 0;

    for (int i = 0; i < verseEstimatedDurations.length; i++) {
      double nextAccumulatedDuration =
          accumulatedDuration + verseEstimatedDurations[i];
      if (position >= accumulatedDuration &&
          position < nextAccumulatedDuration) {
        targetVerseIndex = i;
        break;
      }
      accumulatedDuration = nextAccumulatedDuration;
      targetVerseIndex = i + 1;
    }

    // Ensure the index is valid
    if (targetVerseIndex >= verseTexts.length) {
      targetVerseIndex = verseTexts.length - 1;
    }

    // IMPORTANT: First notify parent about the new active verse before updating state
    if (widget.onActiveVerseChanged != null &&
        targetVerseIndex < verseKeys.length) {
      widget.onActiveVerseChanged!(verseKeys[targetVerseIndex]);
    }

    setState(() {
      currentVerseIndex = targetVerseIndex;
      currentPosition = position;
      _updatePositionToCurrentVerse();
      isProcessing = false;
    });

    // If the user was playing audio before, start playing from the new position
    if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
      _speakCurrentVerse();
    }
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
    final horizontalPadding = isSmallScreen ? 20.0 : 35.0;
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
              widget.title ?? AppStrings.listenAudioScreenString.Rukutitle,
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
        if (!hasLanguageSupport)
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

