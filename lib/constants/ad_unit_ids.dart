/// Ad Unit IDs for Google Mobile Ads
///
/// App ID: ca-app-pub-3425673808153409~2012844185
import 'dart:io';

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

  // Production ad unit IDs for different screens (Android)
  static const String homeScreenBanner =
      'ca-app-pub-3425673808153409/9699762512';
  static const String rukuScreenBanner =
      'ca-app-pub-3425673808153409/1852313653';
  static const String bookmarkScreenBanner =
      'ca-app-pub-3425673808153409/1354707943'; // Update with actual ID when available
  static const String settingsScreenBanner =
      'ca-app-pub-3425673808153409/2846401946';

  // Ruku detail screens - Android IDs
  static const String rukuFirstScreenBanner =
      'ca-app-pub-3425673808153409/4670048687';
  static const String rukuFirstReadScreenBanner =
      'ca-app-pub-3425673808153409/8226150318';
  static const String rukuFirstAudioScreenBanner =
      'ca-app-pub-3425673808153409/4473795494';
  static const String rukuFirstAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/7319450687';
  static const String rukuSecondScreenBanner =
      'ca-app-pub-3425673808153409/4015636085';
  static const String rukuSecondReadScreenBanner =
      'ca-app-pub-3425673808153409/2746592922';
  static const String rukuSecondAudioScreenBanner =
      'ca-app-pub-3425673808153409/7035028580';
  static const String rukuSecondAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/3703639306';
  static const String rukuThirdScreenBanner =
      'ca-app-pub-3425673808153409/7247292326';
  static const String rukuThirdReadScreenBanner =
      'ca-app-pub-3425673808153409/5181184573';
  static const String rukuThirdAudioScreenBanner =
      'ca-app-pub-3425673808153409/4825149281';
  static const String rukuThirdAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/8572822605';
  static const String rukuFourthScreenBanner =
      'ca-app-pub-3425673808153409/2734344009';
  static const String rukuFourthReadScreenBanner =
      'ca-app-pub-3425673808153409/7571737710';
  static const String rukuFourthAudioScreenBanner =
      'ca-app-pub-3425673808153409/5755087572';
  static const String rukuFourthAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/2098574280';
  static const String rukuFifthScreenBanner =
      'ca-app-pub-3425673808153409/4478476999';
  static const String rukuFifthReadScreenBanner =
      'ca-app-pub-3425673808153409/5853808858';
  static const String rukuFifthAudioScreenBanner =
      'ca-app-pub-3425673808153409/2018683230';
  static const String rukuFifthAudioWithTranslationScreenBanner =
      'ca-app-pub-3425673808153409/9705601564';

  // Other screens - Android IDs
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

  // ========== iOS Production Banner Ad Unit IDs ==========
  // AdMob Console se iOS IDs copy karein aur yahan paste karein
  
  // Main screens - iOS IDs
  static const String homeScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String bookmarkScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String settingsScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';

  // Ruku detail screens - iOS IDs
  static const String rukuFirstScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFirstReadScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFirstAudioScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFirstAudioWithTranslationScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuSecondScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuSecondReadScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuSecondAudioScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuSecondAudioWithTranslationScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuThirdScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuThirdReadScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuThirdAudioScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuThirdAudioWithTranslationScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFourthScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFourthReadScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFourthAudioScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFourthAudioWithTranslationScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFifthScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFifthReadScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFifthAudioScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String rukuFifthAudioWithTranslationScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';

  // Other screens - iOS IDs
  static const String aboutScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String helpScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String languageScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String notificationScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';
  static const String privacyPolicyScreenBannerIOS = 'ca-app-pub-XXXXX/XXXXX';

  // Test App Open Ad Unit IDs (official Google test IDs from documentation)
  static const String testAppOpenAdAndroid =
      'ca-app-pub-3940256099942544/9257395921';
  static const String testAppOpenAdIOS =
      'ca-app-pub-3940256099942544/5575463023';

  // Production App Open Ad Unit IDs
  static const String appOpenAd = 'ca-app-pub-3425673808153409/6355413874'; // Android
  static const String appOpenAdIOS = 'ca-app-pub-XXXXX/XXXXX'; // iOS - AdMob se ID add karein

  // Test Interstitial Ad Unit IDs (official Google test IDs from documentation)
  static const String testInterstitialAdAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testInterstitialAdIOS =
      'ca-app-pub-3940256099942544/4411468910';

  // Production Interstitial Ad Unit IDs
  static const String interstitialAd = 'ca-app-pub-3425673808153409/3872543153'; // Android
  static const String interstitialAdIOS = 'ca-app-pub-XXXXX/XXXXX'; // iOS - AdMob se ID add karein

  /// Get ad unit ID for a specific screen type (Android)
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

  /// Get ad unit ID for a specific screen type based on platform
  /// Returns iOS ID if iOS, otherwise Android ID
  static String getBannerAdUnitIdForPlatform(AdScreenType screenType) {
    if (Platform.isIOS) {
      // iOS IDs - AdMob se actual IDs add karein
      switch (screenType) {
        case AdScreenType.home:
          return homeScreenBannerIOS;
        case AdScreenType.ruku:
          return rukuScreenBannerIOS;
        case AdScreenType.bookmark:
          return bookmarkScreenBannerIOS;
        case AdScreenType.settings:
          return settingsScreenBannerIOS;
        case AdScreenType.rukuFirst:
          return rukuFirstScreenBannerIOS;
        case AdScreenType.rukuSecond:
          return rukuSecondScreenBannerIOS;
        case AdScreenType.rukuThird:
          return rukuThirdScreenBannerIOS;
        case AdScreenType.rukuFourth:
          return rukuFourthScreenBannerIOS;
        case AdScreenType.rukuFifth:
          return rukuFifthScreenBannerIOS;
        case AdScreenType.about:
          return aboutScreenBannerIOS;
        case AdScreenType.help:
          return helpScreenBannerIOS;
        case AdScreenType.language:
          return languageScreenBannerIOS;
        case AdScreenType.notification:
          return notificationScreenBannerIOS;
        case AdScreenType.privacyPolicy:
          return privacyPolicyScreenBannerIOS;
      }
    } else {
      // Android IDs
      return getBannerAdUnitId(screenType);
    }
  }
}
