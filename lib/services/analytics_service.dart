import 'package:firebase_analytics/firebase_analytics.dart';

/// Service for tracking analytics events throughout the app
/// 
/// This service provides a centralized way to log custom events to Firebase Analytics.
/// All events are anonymous and do not collect personal information.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  static FirebaseAnalytics? _analytics;
  static FirebaseAnalyticsObserver? _observer;

  /// Initialize the analytics service
  /// Should be called after Firebase.initializeApp()
  static void initialize() {
    _analytics = FirebaseAnalytics.instance;
    _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
  }

  /// Get the Firebase Analytics instance
  static FirebaseAnalytics? get analytics => _analytics;

  /// Get the Firebase Analytics Observer for navigation tracking
  static FirebaseAnalyticsObserver? get observer => _observer;

  /// Track when user starts reciting Surah Yaseen
  static Future<void> logRecitationStart({required int rukuNumber}) async {
    await _analytics?.logEvent(
      name: 'recitation_start',
      parameters: {
        'ruku_number': rukuNumber,
      },
    );
  }

  /// Track when user completes recitation of a ruku
  static Future<void> logRecitationComplete({required int rukuNumber}) async {
    await _analytics?.logEvent(
      name: 'recitation_complete',
      parameters: {
        'ruku_number': rukuNumber,
      },
    );
  }

  /// Track when audio playback starts
  static Future<void> logAudioPlay({required int rukuNumber}) async {
    await _analytics?.logEvent(
      name: 'audio_play',
      parameters: {
        'ruku_number': rukuNumber,
      },
    );
  }

  /// Track when audio playback is paused
  static Future<void> logAudioPause({required int rukuNumber}) async {
    await _analytics?.logEvent(
      name: 'audio_pause',
      parameters: {
        'ruku_number': rukuNumber,
      },
    );
  }

  /// Track when audio playback stops
  static Future<void> logAudioStop({required int rukuNumber}) async {
    await _analytics?.logEvent(
      name: 'audio_stop',
      parameters: {
        'ruku_number': rukuNumber,
      },
    );
  }

  /// Track when translation is enabled
  static Future<void> logTranslationEnabled({required int rukuNumber}) async {
    await _analytics?.logEvent(
      name: 'translation_enabled',
      parameters: {
        'ruku_number': rukuNumber,
      },
    );
  }

  /// Track when translation is disabled
  static Future<void> logTranslationDisabled({required int rukuNumber}) async {
    await _analytics?.logEvent(
      name: 'translation_disabled',
      parameters: {
        'ruku_number': rukuNumber,
      },
    );
  }

  /// Track when a ruku is opened/viewed
  static Future<void> logRukuOpen({required int rukuNumber}) async {
    await _analytics?.logEvent(
      name: 'ruku_open',
      parameters: {
        'ruku_number': rukuNumber,
      },
    );
  }

  /// Track when a bookmark is added
  static Future<void> logBookmarkAdd({
    required int verseIndex,
    required int rukuNumber,
    String? iconType,
  }) async {
    await _analytics?.logEvent(
      name: 'bookmark_add',
      parameters: {
        'verse_index': verseIndex,
        'ruku_number': rukuNumber,
        if (iconType != null) 'icon_type': iconType,
      },
    );
  }

  /// Track when a bookmark is removed
  static Future<void> logBookmarkRemove({
    required int verseIndex,
    required int rukuNumber,
  }) async {
    await _analytics?.logEvent(
      name: 'bookmark_remove',
      parameters: {
        'verse_index': verseIndex,
        'ruku_number': rukuNumber,
      },
    );
  }

  /// Track screen views
  static Future<void> logScreenView({required String screenName}) async {
    await _analytics?.logScreenView(screenName: screenName);
  }

  /// Track custom events with flexible parameters
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics?.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
