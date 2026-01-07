import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/ad_unit_ids.dart';

/// Manages App Open Ads throughout the app lifecycle
/// 
/// App Open Ads are shown when:
/// - App transitions from background to foreground
/// - Not on first app launch (to allow users to experience the app first)
/// - At least 4 hours have passed since last ad was shown (rate limiting)
class AppOpenAdManager {
  static AppOpenAdManager? _instance;
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  bool _isAdAvailable = false;
  bool _isLoadingAd = false;
  int _retryCount = 0;
  DateTime? _appOpenLoadTime; // Track when ad was loaded for expiration check
  static const String _lastAdShownKey = 'last_app_open_ad_shown';
  static const String _appLaunchCountKey = 'app_launch_count';
  static const int _maxRetries = 3;
  /// Maximum duration allowed between loading and showing the ad (4 hours per Google docs)
  static const Duration maxCacheDuration = Duration(hours: 4);

  AppOpenAdManager._();

  static AppOpenAdManager get instance {
    _instance ??= AppOpenAdManager._();
    return _instance!;
  }

  /// Record a cold start app launch.
  ///
  /// NOTE: This should be called once per app start (e.g. from splash) so the
  /// launch counter can reach `_minAppLaunches`. We intentionally do NOT tie
  /// launch count to ad showing, otherwise ads can get stuck never loading.
  Future<int> recordAppLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = (prefs.getInt(_appLaunchCountKey) ?? 0) + 1;
    await prefs.setInt(_appLaunchCountKey, newCount);
    debugPrint('App Open Ad: App launch recorded (count=$newCount)');
    return newCount;
  }

  /// Get the appropriate ad unit ID based on platform and build mode
  /// Uses official Google test ad unit IDs in debug mode
  String _getAdUnitId() {
    if (kDebugMode) {
      // Use official Google test ad unit IDs in debug mode
      if (Platform.isAndroid) {
        return AdUnitIds.testAppOpenAdAndroid;
      } else if (Platform.isIOS) {
        return AdUnitIds.testAppOpenAdIOS;
      }
    }
    // Use production ad unit ID in release mode
    return AdUnitIds.appOpenAd;
  }

  /// Load an App Open Ad
  Future<void> loadAd() async {
    // Check if ad is already loaded, being shown, or currently loading
    if (_appOpenAd != null || _isShowingAd || _isLoadingAd) {
      debugPrint('App Open Ad: Skipping load - already loaded: ${_appOpenAd != null}, showing: $_isShowingAd, loading: $_isLoadingAd');
      return;
    }

    // Check retry limit
    if (_retryCount >= _maxRetries) {
      debugPrint('App Open Ad: Max retries ($_maxRetries) reached. Will retry later.');
      // Reset retry count after 5 minutes
      Future.delayed(const Duration(minutes: 5), () {
        _retryCount = 0;
      });
      return;
    }

    _isLoadingAd = true;
    final String adUnitId = _getAdUnitId();
    debugPrint('App Open Ad: Loading (kReleaseMode=$kReleaseMode, retryCount=$_retryCount, unitId=$adUnitId)');

    try {
      await AppOpenAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('App Open Ad loaded successfully');
            _appOpenLoadTime = DateTime.now(); // Record load time for expiration check
            _appOpenAd = ad;
            _isAdAvailable = true;
            _isLoadingAd = false;
            _retryCount = 0; // Reset retry count on success
            _registerAdListeners(ad);
          },
          onAdFailedToLoad: (error) {
            _isLoadingAd = false;
            _appOpenAd = null;
            _isAdAvailable = false;
            
            debugPrint('App Open Ad failed to load: ${error.message} (code: ${error.code})');
            debugPrint('Ad Unit ID used: $adUnitId');
            
            // Handle specific error codes
            // Error code 3 can mean:
            // - ERROR_CODE_NO_FILL (no ad available)
            // - Ad unit doesn't match format (wrong ad type in AdMob)
            final errorMsg = error.message.toLowerCase();
            final isFormatError = errorMsg.contains('doesn\'t match format') || 
                                 errorMsg.contains('doesnt match format') ||
                                 errorMsg.contains('match format') ||
                                 errorMsg.contains('wrong format') ||
                                 errorMsg.contains('invalid format');
            
            if (error.code == 3 && isFormatError) {
              debugPrint('⚠️⚠️⚠️ App Open Ad: Ad unit format error detected! ⚠️⚠️⚠️');
              debugPrint('   Error message: ${error.message}');
              debugPrint('   This means the ad unit ID is NOT configured as an App Open Ad in AdMob.');
              debugPrint('   Current ad unit ID: $adUnitId');
              debugPrint('   Action required:');
              debugPrint('   1. Go to AdMob console (https://apps.admob.com)');
              debugPrint('   2. Find ad unit with ID ending in: ${adUnitId.split('/').last}');
              debugPrint('   3. Verify it is set up as "App Open" format (not Banner, Interstitial, etc.)');
              debugPrint('   4. If it\'s the wrong type, create a new App Open Ad unit and update the ID');
              // Don't retry for format errors - it's a configuration issue
              _retryCount = _maxRetries; // Prevent retries
            } else if (error.code == 3) {
              debugPrint('App Open Ad: No fill error - no ads available. This is normal in some regions or for new ad units.');
              // For "No fill" errors, retry with longer delay
              _retryCount++;
              final delaySeconds = 30 * _retryCount; // Exponential backoff: 30s, 60s, 90s
              debugPrint('App Open Ad: Retrying in $delaySeconds seconds (attempt $_retryCount/$_maxRetries)');
              Future.delayed(Duration(seconds: delaySeconds), () {
                if (!_isShowingAd && _retryCount < _maxRetries) {
                  loadAd();
                }
              });
            } else {
              // For other errors, retry with standard delay
              _retryCount++;
              debugPrint('App Open Ad: Retrying in 30 seconds (attempt $_retryCount/$_maxRetries)');
              Future.delayed(const Duration(seconds: 30), () {
                if (!_isShowingAd && _retryCount < _maxRetries) {
                  loadAd();
                }
              });
            }
          },
        ),
      );
    } catch (e) {
      _isLoadingAd = false;
      debugPrint('Exception loading App Open Ad: $e');
      _isAdAvailable = false;
      _retryCount++;
      // Retry after delay
      Future.delayed(const Duration(seconds: 30), () {
        if (!_isShowingAd && _retryCount < _maxRetries) {
          loadAd();
        }
      });
    }
  }

  /// Register listeners for the ad
  void _registerAdListeners(AppOpenAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('App Open Ad showed full screen content');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('App Open Ad failed to show: ${error.message}');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _isAdAvailable = false;
        _appOpenLoadTime = null;
        // Load a new ad for next time
        loadAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('App Open Ad dismissed');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _isAdAvailable = false;
        _appOpenLoadTime = null;
        
        // Save the time when ad was shown for rate limiting
        _saveLastAdShownTime();
        
        // Load a new ad for next time
        loadAd();
      },
    );
  }

  /// Show the App Open Ad if available
  /// Returns true if ad was shown, false otherwise
  /// Follows official Google AdMob documentation pattern
  Future<bool> showAdIfAvailable() async {
    debugPrint('App Open Ad: showAdIfAvailable called (_isShowingAd=$_isShowingAd, _isAdAvailable=$_isAdAvailable, _appOpenAd=${_appOpenAd != null})');
    
    // Don't show if already showing
    if (_isShowingAd) {
      debugPrint('App Open Ad: Cannot show - ad is already being shown');
      return false;
    }
    
    // Check if ad is available
    if (!_isAdAvailable || _appOpenAd == null) {
      debugPrint('App Open Ad: Cannot show - ad not available (available: $_isAdAvailable, ad exists: ${_appOpenAd != null})');
      // Try to load an ad if we don't have one
      if (_appOpenAd == null && !_isLoadingAd) {
        debugPrint('App Open Ad: Attempting to load ad...');
        loadAd();
      }
      return false;
    }

    // Check if ad has expired (4 hours max cache duration per Google docs)
    if (_appOpenLoadTime != null) {
      final timeSinceLoad = DateTime.now().difference(_appOpenLoadTime!);
      if (timeSinceLoad > maxCacheDuration) {
        debugPrint('App Open Ad: Maximum cache duration exceeded (${timeSinceLoad.inHours}h ${timeSinceLoad.inMinutes.remainder(60)}m). Loading another ad.');
        _appOpenAd!.dispose();
        _appOpenAd = null;
        _isAdAvailable = false;
        _appOpenLoadTime = null;
        loadAd();
        return false;
      }
    }

    try {
      debugPrint('App Open Ad: Attempting to show ad...');
      // Show the ad - this is a fire-and-forget operation
      // The callbacks will handle the lifecycle
      _appOpenAd!.show();
      debugPrint('App Open Ad: show() called successfully');
      return true;
    } catch (e, stackTrace) {
      debugPrint('Exception showing App Open Ad: $e');
      debugPrint('Stack trace: $stackTrace');
      _isAdAvailable = false;
      _appOpenAd?.dispose();
      _appOpenAd = null;
      _appOpenLoadTime = null;
      // Try to load a new ad
      if (!_isLoadingAd) {
        loadAd();
      }
      return false;
    }
  }

  /// Save the time when ad was last shown
  Future<void> _saveLastAdShownTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastAdShownKey, DateTime.now().toIso8601String());
  }

  /// Check if app open ad should be shown after splash screen
  /// This is called specifically when app opens (cold start)
  Future<bool> shouldShowAdOnAppOpen() async {
    // Check if ad is available
    final bool canShow = _isAdAvailable && _appOpenAd != null;
    debugPrint('App Open Ad: shouldShowAdOnAppOpen = $canShow (_isAdAvailable=$_isAdAvailable, _appOpenAd=${_appOpenAd != null})');
    return canShow;
  }

  /// Dispose the current ad (call when app is closing)
  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isAdAvailable = false;
    _isShowingAd = false;
    _appOpenLoadTime = null;
  }

  /// Wait a short time for an ad to become available (best-effort).
  /// Returns true if the ad became available within [timeout].
  Future<bool> waitUntilAdAvailable({Duration timeout = const Duration(seconds: 2)}) async {
    debugPrint('App Open Ad: waitUntilAdAvailable called (timeout=${timeout.inSeconds}s)');
    final int totalMillis = timeout.inMilliseconds;
    const int step = 100;
    int waited = 0;
    while (waited < totalMillis) {
      if (_isAdAvailable && _appOpenAd != null) {
        debugPrint('App Open Ad: Ad became available after ${waited}ms');
        return true;
      }
      await Future.delayed(const Duration(milliseconds: step));
      waited += step;
    }
    final bool available = _isAdAvailable && _appOpenAd != null;
    debugPrint('App Open Ad: waitUntilAdAvailable finished - available: $available');
    return available;
  }
}
