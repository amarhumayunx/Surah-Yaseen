/// Ad Unit IDs for Google Mobile Ads
///
/// App ID: ca-app-pub-3425673808153409~2012844185
library;

/// Enum to identify different screens for ad placement
enum AdScreenType {
  home,
  ruku,
  bookmark,
  settings,
  rukuFirst,
  rukuSecond,
  rukuThird,
  rukuFourth,
  rukuFifth,
  about,
  help,
  language,
  notification,
  privacyPolicy,
}

/// Ad Unit IDs for Google Mobile Ads
class AdUnitIds {
  // Test ad unit IDs (used in debug mode)
  static const String testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testBannerIOS = 'ca-app-pub-3940256099942544/2934735716';

  // Production ad unit IDs for different screens
  static const String homeScreenBanner =
      'ca-app-pub-3425673808153409/9699762512';
  static const String rukuScreenBanner =
      'ca-app-pub-3425673808153409/1354707943';
  static const String bookmarkScreenBanner =
      'ca-app-pub-3425673808153409/1354707943'; // Update with actual ID when available
  static const String settingsScreenBanner =
      'ca-app-pub-3425673808153409/2846401946';

  // Ruku detail screens - add actual IDs when available
  static const String rukuFirstScreenBanner =
      'ca-app-pub-3425673808153409/9273221255';
  static const String rukuFirstReadScreenBanner =
      'ca-app-pub-3425673808153409/3352285514';
  static const String rukuFirstAudioScreenBanner =
      'ca-app-pub-3425673808153409/4473795494';
  static const String rukuFirstAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/7319450687';
  static const String rukuSecondScreenBanner =
      'ca-app-pub-3425673808153409/5142404555';
  static const String rukuSecondReadScreenBanner =
      'ca-app-pub-3425673808153409/4693287342';
  static const String rukuSecondAudioScreenBanner =
      'ca-app-pub-3425673808153409/7035028580';
  static const String rukuSecondAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/3703639306';
  static const String rukuThirdScreenBanner =
      'ca-app-pub-3425673808153409/4686931372';
  static const String rukuThirdReadScreenBanner =
      'ca-app-pub-3425673808153409/3136323785';
  static const String rukuThirdAudioScreenBanner =
      'ca-app-pub-3425673808153409/4825149281';
  static const String rukuThirdAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/8572822605';
  static const String rukuFourthScreenBanner =
      'ca-app-pub-3425673808153409/7365065601';
  static const String rukuFourthReadScreenBanner =
      'ca-app-pub-3425673808153409/8381250916';
  static const String rukuFourthAudioScreenBanner =
      'ca-app-pub-3425673808153409/5755087572';
  static const String rukuFourthAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/2098574280';
  static const String rukuFifthScreenBanner =
      'ca-app-pub-3425673808153409/7856020190';
  static const String rukuFifthReadScreenBanner =
      'ca-app-pub-3425673808153409/5853808858';
  static const String rukuFifthAudioScreenBanner =
      'ca-app-pub-3425673808153409/2018683230';
  static const String rukuFifthAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/9705601564';

  // Other screens - add actual IDs when available
  static const String aboutScreenBanner =
      'ca-app-pub-3425673808153409/7456742557'; // Info screen banner
  static const String helpScreenBanner =
      'ca-app-pub-3425673808153409/1354707943'; // Update with actual ID
  static const String languageScreenBanner =
      'ca-app-pub-3425673808153409/9091697358';
  static const String notificationScreenBanner =
      'ca-app-pub-3425673808153409/1027065576';
  static const String privacyPolicyScreenBanner =
      'ca-app-pub-3425673808153409/1354707943'; // Update with actual ID

  // Test App Open Ad Unit IDs (official Google test IDs from documentation)
  static const String testAppOpenAdAndroid =
      'ca-app-pub-3940256099942544/9257395921';
  static const String testAppOpenAdIOS =
      'ca-app-pub-3940256099942544/5575463023';

  // Production App Open Ad Unit ID
  static const String appOpenAd = 'ca-app-pub-3425673808153409/6355413874';

  // Test Interstitial Ad Unit IDs (official Google test IDs from documentation)
  static const String testInterstitialAdAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testInterstitialAdIOS =
      'ca-app-pub-3940256099942544/4411468910';

  // Production Interstitial Ad Unit ID
  static const String interstitialAd = 'ca-app-pub-3425673808153409/3872543153';

  /// Get ad unit ID for a specific screen type
  /// Returns the appropriate ad unit ID based on the screen type
  static String getBannerAdUnitId(AdScreenType screenType) {
    switch (screenType) {
      case AdScreenType.home:
        return homeScreenBanner;
      case AdScreenType.ruku:
        return rukuScreenBanner;
      case AdScreenType.bookmark:
        return bookmarkScreenBanner;
      case AdScreenType.settings:
        return settingsScreenBanner;
      case AdScreenType.rukuFirst:
        return rukuFirstScreenBanner;
      case AdScreenType.rukuSecond:
        return rukuSecondScreenBanner;
      case AdScreenType.rukuThird:
        return rukuThirdScreenBanner;
      case AdScreenType.rukuFourth:
        return rukuFourthScreenBanner;
      case AdScreenType.rukuFifth:
        return rukuFifthScreenBanner;
      case AdScreenType.about:
        return aboutScreenBanner;
      case AdScreenType.help:
        return helpScreenBanner;
      case AdScreenType.language:
        return languageScreenBanner;
      case AdScreenType.notification:
        return notificationScreenBanner;
      case AdScreenType.privacyPolicy:
        return privacyPolicyScreenBanner;
    }
  }
}
