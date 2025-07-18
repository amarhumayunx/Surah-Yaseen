import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'dart:async';
import 'dart:math';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';

enum TtsState { playing, stopped, paused, continued }

class ListenAudioRukuFourthAudioPlayer extends StatefulWidget {
  final String? title;
  final Map<int, String> verses;
  final int startVerse;
  final int endVerse;
  final Function(int)?
  onActiveVerseChanged; // Callback to notify parent about active verse

  const ListenAudioRukuFourthAudioPlayer({
    Key? key,
    this.title,
    required this.verses,
    this.startVerse = 51,
    this.endVerse = 67,
    this.onActiveVerseChanged,
  }) : super(key: key);

  @override
  State<ListenAudioRukuFourthAudioPlayer> createState() =>
      _ListenAudioRukuFourthAudioPlayerState();
}

class _ListenAudioRukuFourthAudioPlayerState
    extends State<ListenAudioRukuFourthAudioPlayer>
    with WidgetsBindingObserver {
  // TTS Engine
  FlutterTts flutterTts = FlutterTts();
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
  List<double> verseEstimatedDurations =
  []; // Store estimated durations per verse

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
    _initVerses();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      print("Initializing Flutter TTS engine...");

      // Set up TTS parameters
      await flutterTts.setVolume(volume);
      await flutterTts.setPitch(pitch);
      await flutterTts.setSpeechRate(rate);

      // Get available languages
      var languages = await flutterTts.getLanguages;
      print("Available TTS languages: $languages");

      // Try to find Arabic language support
      bool hasArabic = languages.any(
            (lang) =>
        lang.toString().toLowerCase().contains('ar') ||
            lang.toString().toLowerCase().contains('arab'),
      );

      // Set language preference - try Arabic first, then fall back to default
      if (hasArabic) {
        var arabicLangs =
        languages
            .where(
              (lang) =>
          lang.toString().toLowerCase().contains('ar') ||
              lang.toString().toLowerCase().contains('arab'),
        )
            .toList();

        // Prefer full Arabic over dialect variants if available
        String arabicCode = arabicLangs.firstWhere(
              (lang) =>
          lang.toString().toLowerCase() == 'ar' ||
              lang.toString().toLowerCase() == 'ara',
          orElse: () => arabicLangs.first.toString(),
        );

        language = arabicCode;
        print("Setting language to: $language");
        await flutterTts.setLanguage(language!);
        hasLanguageSupport = true;
      } else {
        // Use default language if Arabic not available
        language = languages.isNotEmpty ? languages.first.toString() : null;
        print("Arabic not found, using default language: $language");
        if (language != null) {
          await flutterTts.setLanguage(language!);
        }
        hasLanguageSupport = false;
      }

      // Configure TTS event handlers
      flutterTts.setStartHandler(() {
        setState(() {
          print("TTS started speaking");
          ttsState = TtsState.playing;
          isSpeaking = true;
          isProcessing = false;
        });
        _startProgressTimer();
      });

      flutterTts.setCompletionHandler(() {
        print("TTS completed speaking verse $currentVerseIndex");

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
          setState(() {
            ttsState = TtsState.stopped;
            _stopProgressTimer();
            currentPosition = totalDuration;
          });
        }
      });

      flutterTts.setErrorHandler((msg) {
        setState(() {
          print("TTS error: $msg");
          ttsState = TtsState.stopped;
          isSpeaking = false;
          isProcessing = false;

          // Show troubleshooting button when there's an error
          showTroubleshooting = true;
        });

        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Speech error: $msg"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      });

      flutterTts.setCancelHandler(() {
        setState(() {
          print("TTS cancelled");
          ttsState = TtsState.stopped;
          isSpeaking = false;
          isProcessing = false;
        });
      });

      flutterTts.setPauseHandler(() {
        setState(() {
          print("TTS paused");
          ttsState = TtsState.paused;
          isSpeaking = false;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("TTS continued");
          ttsState = TtsState.continued;
          isSpeaking = true;
        });
      });

      // Calculate estimated duration based on verse content
      _calculateVerseDurations();

      setState(() {
        isTtsInitialized = true;
      });

      print("TTS initialization complete!");
    } catch (e) {
      print("Error initializing TTS: $e");
      setState(() {
        isTtsInitialized = false;
        hasLanguageSupport = false;
        showTroubleshooting = true;
      });
    }
  }

  void _initVerses() {
    print("Initializing verses from map with ${widget.verses.length} entries");

    // Guard against empty verses map
    if (widget.verses.isEmpty) {
      print("WARNING: Empty verses map provided!");
      verseKeys = [];
      verseTexts = [];
      return;
    }

    // Get all verse keys and sort them
    verseKeys = widget.verses.keys.toList();
    print("Raw verse keys: $verseKeys");

    // Sort keys based on verse number
    verseKeys.sort();
    print("Sorted verse keys: $verseKeys");

    // FILTER THE KEYS FIRST based on actual verse numbers (not indices)
    if (widget.startVerse > 0 || widget.endVerse > 0) {
      verseKeys = verseKeys.where((key) {
        return key >= widget.startVerse &&
            (widget.endVerse <= 0 || key <= widget.endVerse);
      }).toList();

      print("Filtered verse keys based on range ${widget.startVerse}-${widget.endVerse}: $verseKeys");

      if (verseKeys.isEmpty) {
        print("WARNING: No verses found in the specified range ${widget.startVerse}-${widget.endVerse}!");
      }
    }

    // Now get the verse texts for the FILTERED keys
    verseTexts = verseKeys.map((key) => widget.verses[key]!).toList();

    // Validate verse texts aren't empty
    bool hasEmptyVerses = verseTexts.any((verse) => verse.trim().isEmpty);
    if (hasEmptyVerses) {
      print("WARNING: Some verses have empty text!");
    }

    // Always start at the first verse in our filtered list
    currentVerseIndex = 0;

    // Print the actual verses for debugging
    for (int i = 0; i < verseTexts.length; i++) {
      print(
        "Verse ${verseKeys[i]}: ${verseTexts[i].substring(0, min(30, verseTexts[i].length))}...",
      );
    }
  }

  void _calculateVerseDurations() {
    // Clear any previous calculations
    verseEstimatedDurations = [];

    // Base duration for short verses (in seconds)
    const double baseDuration = 3.0;

    // Estimate time based on content length
    double totalEstimatedDuration = 0.0;

    for (String verse in verseTexts) {
      // Calculate estimated time based on character count
      int charCount = verse.trim().length;

      // Base formula:
      // - 3 seconds minimum for very short verses
      // - ~0.25 seconds per character for longer verses (adjusted for recitation)
      double estimatedDuration = max(baseDuration, charCount * 0.25);

      // Add this verse's duration to our list
      verseEstimatedDurations.add(estimatedDuration);
      totalEstimatedDuration += estimatedDuration;
    }

    // Set the total duration
    totalDuration = max(10.0, totalEstimatedDuration);
    print("Total estimated duration: $totalDuration seconds");
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

    currentVerseDuration =
    currentVerseIndex < verseEstimatedDurations.length
        ? verseEstimatedDurations[currentVerseIndex]
        : 3.0;

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

            // Calculate progress within current verse (0.0 to 1.0)
            verseProgress = min(
              (currentPosition - currentVerseStartPosition) /
                  currentVerseDuration +
                  (elapsedSeconds / currentVerseDuration),
              1.0,
            );

            // Update current position smoothly
            double newPosition =
                currentPosition +
                    (elapsedSeconds * (currentVerseDuration / 3.0));

            // Ensure we don't overshoot the current verse's duration
            if (newPosition <=
                currentVerseStartPosition + currentVerseDuration) {
              currentPosition = newPosition;
              lastPosition = currentPosition;
            } else {
              // If we've reached the end of the current verse, we'll let the completion handler
              // handle the transition to the next verse
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
      // Pause TTS when app is in background
      flutterTts.pause();
    }
  }

  Future<void> troubleshootTTS() async {
    try {
      print("=== TTS TROUBLESHOOTING ===");

      // Check if TTS is initialized
      print("TTS initialized: $isTtsInitialized");

      // Check available languages
      var languages = await flutterTts.getLanguages;
      print("Available languages: $languages");

      // Check available voices
      var voices = await flutterTts.getVoices;
      print("Available voices: $voices");

      // Check engine
      var engine = await flutterTts.getDefaultEngine;
      print("Default engine: $engine");

      // Get current language
      print("Current language: $language");

      // Show troubleshooting dialog to user
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
          title: Text("TTS Troubleshooting"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("TTS Engine: $engine"),
                Text("Current Language: $language"),
                Text("Arabic Support: $hasLanguageSupport"),
                SizedBox(height: 10),
                Text("Available Languages:"),
                Text(languages.join(", "), style: TextStyle(fontSize: 12)),
                SizedBox(height: 10),
                Text(
                  "If Arabic is not available, please install Arabic language pack in your device's text-to-speech settings.",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Test with simple Arabic text before closing
                await flutterTts.speak("بسم الله الرحمن الرحيم");
                Navigator.of(context).pop();
              },
              child: Text("Test Arabic"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        ),
      );

      print("=== END TROUBLESHOOTING ===");
    } catch (e) {
      print("Error during troubleshooting: $e");
    }
  }

  void _handlePlayPause() {
    if (isProcessing) {
      print("TTS is currently processing, please wait");
      return;
    }

    if (!isTtsInitialized) {
      print("TTS not initialized, cannot play/pause");
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
      print("No verses to play");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No verses available to play."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print("Play button pressed. Current state: $ttsState");

    setState(() {
      isProcessing = true;
    });

    if (ttsState == TtsState.playing) {
      print("Pausing playback");
      _pause();
    } else if (ttsState == TtsState.paused) {
      print("Resuming playback");
      _resume();
    } else {
      print("Starting playback from beginning");
      _speakFromStart();
    }
  }

  Future<void> _speakNextVerse() async {
    // First increment our verse index
    int nextVerseIndex = currentVerseIndex + 1;

    // Then notify parent about the active verse change BEFORE starting to speak
    if (widget.onActiveVerseChanged != null && nextVerseIndex < verseKeys.length) {
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
    print("Speaking from start");

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
      print("TTS not initialized, cannot speak verse");
      setState(() {
        isProcessing = false;
      });
      return;
    }

    if (currentVerseIndex < verseTexts.length) {
      String textToSpeak = verseTexts[currentVerseIndex];
      print(
        "Speaking verse $currentVerseIndex: ${textToSpeak.substring(0, min(20, textToSpeak.length))}...",
      );

      if (textToSpeak.trim().isEmpty) {
        print("WARNING: Empty verse text, skipping...");
        _speakNextVerse(); // Use our new method
        return;
      }

      // Start progress timer before speaking
      _startProgressTimer();

      // Add tajweed pause after each verse
      textToSpeak = textToSpeak + "، ";

      // Update state before speaking
      setState(() {
        isSpeaking = true;
      });

      // Actually speak the text
      var result = await flutterTts.speak(textToSpeak);
      print("Speak result: $result");

      if (result != 1) {
        print("Failed to speak, error code: $result");
        setState(() {
          isProcessing = false;
          ttsState = TtsState.stopped;
          isSpeaking = false;
          showTroubleshooting = true;
        });
      }
    } else {
      print(
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
    print("Pause result: $result");
    _stopProgressTimer();
    setState(() {
      isProcessing = false;
    });
  }

  Future<void> _resume() async {
    // FlutterTts has a continue method
    if (await flutterTts.isLanguageAvailable(language ?? "en-US")) {
      var result = await flutterTts.speak(verseTexts[currentVerseIndex]);
      print("Resume result: $result");
    } else {
      print("Language not available for resume");
    }
    setState(() {
      isProcessing = false;
    });
  }

  Future<void> _stop() async {
    var result = await flutterTts.stop();
    print("Stop result: $result");
    _stopProgressTimer();

    // IMPORTANT: First notify parent about resetting to the first verse
    if (widget.onActiveVerseChanged != null && verseKeys.isNotEmpty) {
      widget.onActiveVerseChanged!(verseKeys[0]);
    }

    setState(() {
      ttsState = TtsState.stopped;
      isSpeaking = false;
      currentPosition = 0.0;
      currentVerseIndex = 0;
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
      if (widget.onActiveVerseChanged != null && nextVerseIndex < verseKeys.length) {
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
      if (widget.onActiveVerseChanged != null && prevVerseIndex < verseKeys.length) {
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

    _stop().then((_) {
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
      if (widget.onActiveVerseChanged != null && targetVerseIndex < verseKeys.length) {
        widget.onActiveVerseChanged!(verseKeys[targetVerseIndex]);
      }

      setState(() {
        currentVerseIndex = targetVerseIndex;
        _updatePositionToCurrentVerse();
        isProcessing = false;
      });

      if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
        _speakCurrentVerse();
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
    double sliderValue =
    totalDuration > 0
        ? (currentPosition / totalDuration).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title ?? AppStrings.listenAudioScreenString.Rukutitle,
              style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.merriweather().fontFamily,
                color: AppColors.PrimaryColor,
              ),
            ),
          ),
        ),
        // Language support indicator
        if (!hasLanguageSupport)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Text(
              "Arabic TTS not available on this device",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),

        // TTS initialization status
        if (!isTtsInitialized)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.PrimaryColor),
                SizedBox(width: 10),
                Text(
                  "Initializing speech engine...",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ],
            ),
          ),

        // Slider + Time Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SliderTheme(
                data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  trackHeight: 4.0,
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
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(currentPosition),
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      _formatDuration(totalDuration),
                      style: TextStyle(color: Colors.grey.shade700),
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
              SvgPicture.asset(AppAssets.backwardarrow, width: 30, height: 30),
              _skipBackward,
              tooltip: "Previous verse",
            ),
            const SizedBox(width: 25),
            _roundPlayButton(
              ttsState == TtsState.playing || ttsState == TtsState.continued,
              _handlePlayPause,
            ),
            const SizedBox(width: 25),
            _iconControlButton(
              SvgPicture.asset(AppAssets.forwardarrow, width: 30, height: 30),
              _skipForward,
              tooltip: "Next verse",
            ),
          ],
        ),

        // Troubleshooting button
        if (showTroubleshooting)
          TextButton(
            onPressed: troubleshootTTS,
            child: Text("Troubleshoot TTS Engine"),
          ),
      ],
    );
  }


  Widget _iconControlButton(
      Widget icon,
      Function() onPressed, {
        String? tooltip,
      }) {
    return Tooltip(
      message: tooltip ?? "",
      child: IconButton(
        icon: icon,
        onPressed: isProcessing ? null : onPressed,
        iconSize: 30,
      ),
    );
  }

  Widget _roundPlayButton(bool isPlaying, Function() onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.BarColor, width: 3),
        color: AppColors.PrimaryColor,
      ),
      child: IconButton(
        icon: Stack(
          alignment: Alignment.center,
          children: [
            isProcessing
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : SvgPicture.asset(
              isPlaying ? AppAssets.pause_button : AppAssets.play_button,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ],
        ),
        onPressed: isProcessing ? null : onPressed,
        iconSize: 50,
        tooltip: isPlaying ? "Pause" : "Play",
      ),
    );
  }
}
