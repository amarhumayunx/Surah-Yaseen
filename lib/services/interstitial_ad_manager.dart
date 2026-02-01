import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/ad_unit_ids.dart';

/// Manages Interstitial Ads with progressive timing intervals
/// 
/// Shows ads at intervals: 5 min, 15 min, 25 min, 35 min, 45 min, etc.
/// (First ad after 5 minutes, then increasing by 10 minutes each time)
class InterstitialAdManager {
  static InterstitialAdManager? _instance;
  InterstitialAd? _interstitialAd;
  bool _isShowingAd = false;
  bool _isAdAvailable = false;
  bool _isLoadingAd = false;
  DateTime? _appOpenTime;
  Timer? _adTimer;
  int _nextAdIntervalIndex = 0;
  
  // Ad intervals in minutes: 5, 15, 25, 35, 45, 55, 65, etc.
  // For testing: use shorter intervals (30 seconds, 1 min, 2 min, etc.)
  static const bool _testMode = false; // Set to true for faster testing
  static const List<int> _adIntervals = _testMode 
      ? [1, 2, 3, 4, 5] // Test mode: 1 min, 2 min, 3 min, etc.
      : [5, 15, 25, 35, 45, 55, 65, 75, 85, 95]; // Production: 5 min, 15 min, 25 min, etc.
  static const String _appOpenTimeKey = 'interstitial_app_open_time';
  static const String _nextAdIntervalIndexKey = 'interstitial_next_ad_index';
  static const String _lastAdShownTimeKey = 'interstitial_last_ad_shown';

  InterstitialAdManager._();

  static InterstitialAdManager get instance {
    _instance ??= InterstitialAdManager._();
    return _instance!;
  }

  /// Get the appropriate ad unit ID based on platform and build mode
  String _getAdUnitId() {
    if (kDebugMode) {
      // Use official Google test ad unit IDs in debug mode
      if (Platform.isAndroid) {
        return AdUnitIds.testInterstitialAdAndroid;
      } else if (Platform.isIOS) {
        return AdUnitIds.testInterstitialAdIOS;
      }
    }
    // Use production ad unit ID based on platform
    if (Platform.isAndroid) {
      return AdUnitIds.interstitialAd;
    } else if (Platform.isIOS) {
      return AdUnitIds.interstitialAdIOS;
    }
    return AdUnitIds.interstitialAd; // Fallback
  }

  /// Initialize the interstitial ad manager when app opens (fresh start)
  Future<void> initialize() async {
    debugPrint('Interstitial Ad Manager: ========== INITIALIZING ==========');
    
    // Load saved state first
    await _loadSavedState();
    
    // Check if we should reset (app was closed for more than 1 hour)
    final shouldReset = _shouldResetIntervals();
    
    // Record new app open time (only reset if app was closed for long time)
    if (shouldReset || _appOpenTime == null) {
      _appOpenTime = DateTime.now();
      await _saveAppOpenTime();
      _nextAdIntervalIndex = 0;
      await _saveNextAdIntervalIndex();
      debugPrint('Interstitial Ad Manager: Reset intervals - starting fresh at ${_appOpenTime!.toIso8601String()}');
      debugPrint('Interstitial Ad Manager: First ad will show after 5 minutes');
    } else {
      // Continue from where we left off
      final timeSinceOpen = DateTime.now().difference(_appOpenTime!);
      debugPrint('Interstitial Ad Manager: Continuing from previous session');
      debugPrint('Interstitial Ad Manager: App opened at: ${_appOpenTime!.toIso8601String()}');
      debugPrint('Interstitial Ad Manager: Time since open: ${timeSinceOpen.inMinutes}m ${timeSinceOpen.inSeconds % 60}s');
      debugPrint('Interstitial Ad Manager: Next ad interval index: $_nextAdIntervalIndex');
    }
    
    // Load the first ad
    debugPrint('Interstitial Ad Manager: Loading first ad...');
    loadAd();
    
    // Start the timer to check for ad intervals
    debugPrint('Interstitial Ad Manager: Starting timer (checks every 30 seconds)');
    _startAdTimer();
    debugPrint('Interstitial Ad Manager: ========== INITIALIZATION COMPLETE ==========');
  }

  /// Resume the interstitial ad manager when app comes to foreground
  /// This doesn't reset the timer, just ensures it's running
  void resume() {
    debugPrint('Interstitial Ad Manager: Resuming...');
    
    // If timer is not running, start it
    if (_adTimer == null || !_adTimer!.isActive) {
      _startAdTimer();
    }
    
    // Load ad if not available
    if (!_isAdAvailable && !_isLoadingAd) {
      loadAd();
    }
  }

  /// Load saved state from SharedPreferences
  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load app open time
    final appOpenTimeString = prefs.getString(_appOpenTimeKey);
    if (appOpenTimeString != null) {
      try {
        _appOpenTime = DateTime.parse(appOpenTimeString);
      } catch (e) {
        debugPrint('Interstitial Ad Manager: Error parsing app open time: $e');
        _appOpenTime = DateTime.now();
      }
    }
    
    // Load next ad interval index
    _nextAdIntervalIndex = prefs.getInt(_nextAdIntervalIndexKey) ?? 0;
    
    debugPrint('Interstitial Ad Manager: Loaded state - interval index: $_nextAdIntervalIndex');
  }

  /// Save app open time
  Future<void> _saveAppOpenTime() async {
    if (_appOpenTime == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appOpenTimeKey, _appOpenTime!.toIso8601String());
  }

  /// Save next ad interval index
  Future<void> _saveNextAdIntervalIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_nextAdIntervalIndexKey, _nextAdIntervalIndex);
  }

  /// Check if intervals should be reset (app was closed for more than 1 hour)
  bool _shouldResetIntervals() {
    if (_appOpenTime == null) return true;
    final timeSinceLastOpen = DateTime.now().difference(_appOpenTime!);
    return timeSinceLastOpen.inHours >= 1;
  }

  /// Start timer to check for ad intervals
  void _startAdTimer() {
    _adTimer?.cancel();
    
    // Check every 30 seconds if it's time to show an ad (or every 5 seconds in test mode)
    final checkInterval = _testMode ? const Duration(seconds: 5) : const Duration(seconds: 30);
    _adTimer = Timer.periodic(checkInterval, (timer) {
      _checkAndShowAd();
    });
    
    debugPrint('Interstitial Ad Manager: Timer started - checking every ${checkInterval.inSeconds} seconds');
    
    // Also check immediately
    _checkAndShowAd();
  }

  /// Check if it's time to show an ad and show it
  Future<void> _checkAndShowAd() async {
    if (_isShowingAd || _appOpenTime == null) {
      if (_appOpenTime == null) {
        debugPrint('Interstitial Ad Manager: Cannot check - app open time is null');
      }
      return;
    }
    
    final timeSinceAppOpen = DateTime.now().difference(_appOpenTime!);
    final minutesSinceAppOpen = timeSinceAppOpen.inMinutes;
    final secondsSinceAppOpen = timeSinceAppOpen.inSeconds;
    
    // Get the next ad interval
    int nextInterval;
    if (_nextAdIntervalIndex >= _adIntervals.length) {
      // If we've shown all predefined intervals, use the last interval + 10 minutes
      final lastInterval = _adIntervals.last;
      nextInterval = lastInterval + ((_nextAdIntervalIndex - _adIntervals.length + 1) * 10);
    } else {
      nextInterval = _adIntervals[_nextAdIntervalIndex];
    }
    
    // Log every minute for debugging (or every 10 seconds in test mode)
    final logInterval = _testMode ? 10 : 60;
    if (secondsSinceAppOpen % logInterval == 0) {
      debugPrint('Interstitial Ad Manager: Time since app open: ${minutesSinceAppOpen}m ${secondsSinceAppOpen % 60}s, Next ad at: ${nextInterval}m, Index: $_nextAdIntervalIndex, Ad available: $_isAdAvailable, Loading: $_isLoadingAd');
    }
    
    if (minutesSinceAppOpen >= nextInterval) {
      debugPrint('Interstitial Ad Manager: Time reached! Showing ad (${minutesSinceAppOpen}m >= ${nextInterval}m)');
      await _showAdAndUpdateInterval();
    }
  }

  /// Show ad and update to next interval
  Future<void> _showAdAndUpdateInterval() async {
    if (_isShowingAd || !_isAdAvailable || _interstitialAd == null) {
      // If ad is not available, try to load it
      if (!_isAdAvailable && !_isLoadingAd) {
        loadAd();
      }
      return;
    }
    
    debugPrint('Interstitial Ad Manager: Showing ad at interval ${_nextAdIntervalIndex + 1}');
    
    // Show the ad
    try {
      _interstitialAd!.show();
    } catch (e) {
      debugPrint('Interstitial Ad Manager: Error showing ad: $e');
      _isAdAvailable = false;
      _interstitialAd?.dispose();
      _interstitialAd = null;
      loadAd();
    }
  }

  /// Load an Interstitial Ad
  Future<void> loadAd() async {
    // Don't load if already loaded, being shown, or currently loading
    if (_interstitialAd != null || _isShowingAd || _isLoadingAd) {
      return;
    }

    _isLoadingAd = true;
    final String adUnitId = _getAdUnitId();
    debugPrint('Interstitial Ad Manager: Loading ad (unitId: $adUnitId)');

    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('Interstitial Ad Manager: Ad loaded successfully');
            _interstitialAd = ad;
            _isAdAvailable = true;
            _isLoadingAd = false;
            _registerAdListeners(ad);
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('Interstitial Ad Manager: Ad failed to load: ${error.message} (code: ${error.code})');
            _isLoadingAd = false;
            _interstitialAd = null;
            _isAdAvailable = false;
            
            // Retry after 1 minute
            Future.delayed(const Duration(minutes: 1), () {
              if (!_isShowingAd && !_isLoadingAd) {
                loadAd();
              }
            });
          },
        ),
      );
    } catch (e) {
      debugPrint('Interstitial Ad Manager: Exception loading ad: $e');
      _isLoadingAd = false;
      _isAdAvailable = false;
      
      // Retry after 1 minute
      Future.delayed(const Duration(minutes: 1), () {
        if (!_isShowingAd && !_isLoadingAd) {
          loadAd();
        }
      });
    }
  }

  /// Register listeners for the ad
  void _registerAdListeners(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        _isShowingAd = true;
        debugPrint('Interstitial Ad Manager: Ad showed full screen content');
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('Interstitial Ad Manager: Ad failed to show: ${error.message}');
        _isShowingAd = false;
        ad.dispose();
        _interstitialAd = null;
        _isAdAvailable = false;
        // Load a new ad for next time
        loadAd();
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('Interstitial Ad Manager: Ad dismissed');
        _isShowingAd = false;
        ad.dispose();
        _interstitialAd = null;
        _isAdAvailable = false;
        
        // Save the time when ad was shown
        _saveLastAdShownTime();
        
        // Move to next interval
        _nextAdIntervalIndex++;
        _saveNextAdIntervalIndex(); // Fire and forget
        
        debugPrint('Interstitial Ad Manager: Next ad will show at interval ${_nextAdIntervalIndex + 1}');
        
        // Load a new ad for next time
        loadAd();
      },
      onAdImpression: (InterstitialAd ad) {
        debugPrint('Interstitial Ad Manager: Ad recorded an impression');
      },
      onAdClicked: (InterstitialAd ad) {
        debugPrint('Interstitial Ad Manager: Ad was clicked');
      },
    );
  }

  /// Save the time when ad was last shown
  Future<void> _saveLastAdShownTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastAdShownTimeKey, DateTime.now().toIso8601String());
  }

  /// Dispose the current ad and cleanup
  void dispose() {
    _adTimer?.cancel();
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isAdAvailable = false;
    _isShowingAd = false;
  }
}

