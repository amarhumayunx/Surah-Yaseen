import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Manages Google User Messaging Platform (UMP) consent for GDPR/EEA compliance.
/// Required for personalized ads in European Economic Area, UK, and Switzerland.
///
/// See: https://developers.google.com/admob/flutter/privacy
class ConsentManager {
  ConsentManager._();
  static final ConsentManager instance = ConsentManager._();

  bool _initialized = false;
  bool _privacyOptionsRequired = false;

  /// Whether the consent flow has completed. Use this before loading ads.
  bool get isInitialized => _initialized;

  /// Whether a privacy options entry point must be shown (GDPR consent revocation).
  bool get isPrivacyOptionsRequired => _privacyOptionsRequired;

  /// Runs the full consent flow at app launch. Call before [MobileAds.instance.initialize].
  /// - Requests consent info update
  /// - Loads and shows consent form if required (e.g. EEA users)
  /// - Determines if privacy options entry point is needed
  Future<void> initialize() async {
    if (_initialized) return;

    final params = _buildRequestParameters();

    await _requestConsentAndShowForm(params);
    _privacyOptionsRequired = await ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
    _initialized = true;

    debugPrint(
        'ConsentManager: initialized, privacyOptionsRequired=$_privacyOptionsRequired');
  }

  ConsentRequestParameters _buildRequestParameters() {
    if (kDebugMode) {
      final debugSettings = ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: ['14C103ADD23A29FFD26DE6E985FD67DF'],
      );
      return ConsentRequestParameters(consentDebugSettings: debugSettings);
    }
    return ConsentRequestParameters();
  }

  Future<void> _requestConsentAndShowForm(ConsentRequestParameters params) async {
    final completer = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((error) {
          if (error != null) {
            debugPrint('ConsentManager: form error ${error.errorCode} - ${error.message}');
          }
          if (!completer.isCompleted) completer.complete();
        });
      },
      (FormError error) {
        debugPrint(
            'ConsentManager: requestConsentInfoUpdate failed ${error.errorCode} - ${error.message}');
        if (!completer.isCompleted) completer.complete();
      },
    );

    // Prevent indefinite hang if UMP callbacks never fire (e.g. WebView issues)
    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        if (!completer.isCompleted) {
          debugPrint('ConsentManager: timed out after 30s, proceeding without consent');
          completer.complete();
        }
      },
    );
  }

  /// Shows the privacy options form (for consent revocation). Required by GDPR.
  /// Call when user taps "Manage ad consent" or similar in settings.
  Future<void> showPrivacyOptionsForm() async {
    ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null) {
        debugPrint(
            'ConsentManager: privacy options form error ${error.errorCode} - ${error.message}');
      }
    });
  }

  /// Resets consent state. For testing only - removes before release.
  Future<void> reset() => ConsentInformation.instance.reset();
}
