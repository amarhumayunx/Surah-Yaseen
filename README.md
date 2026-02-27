## Surah Yaseen Companion

A beautiful Flutter app to **read, listen, and reflect on Surah Yaseen**, the heart of the Qur'an.  
It offers ruku-wise navigation, audio playback, translations, bookmarks, and daily reminder notifications.

---

## Features

- **Beautiful Quranic reading experience**
  - High-quality Arabic font with multiple weights
  - Clean, distraction-free UI
  - Optimized for portrait reading

- **Ruku-wise navigation**
  - Jump between Surah Yaseen rukus easily
  - Separate screens for each ruku with Arabic and translation views

- **Audio playback**
  - Just Audio–based player for Surah Yaseen
  - Listen with or without translation
  - Background-safe and integrated with the app UI

- **Translations & font controls**
  - Multiple language support using `get` translations
  - Adjustable Arabic/translation font sizes

- **Bookmarks**
  - Save verses/rukus as bookmarks using Hive
  - Quickly resume where you left off

- **Reminders & notifications**
  - Daily reminders powered by `flutter_local_notifications`
  - Deep-linking to the relevant verse using `VerseNavigationService`

- **Modern tech stack**
  - Flutter 3, GetX, Provider, Hive, Firebase Analytics
  - Google Mobile Ads (banner, interstitial, app open ads)

---

## Download

- **Google Play Store**: [`Surah Yaseen Companion`](https://play.google.com/store/apps/details?id=com.amarhumayun.surahyaseen)

---

## Tech Stack

- **Framework**: Flutter (`sdk: ^3.7.2`)
- **State & navigation**: GetX, Provider
- **Local storage**: Hive, GetStorage, SharedPreferences
- **UI & layout**: Google Fonts, `flutter_screenutil`, custom Arabic font
- **Audio & video**: `just_audio`, `audio_session`, `chewie`, `video_player`, `flutter_tts`
- **Notifications**: `flutter_local_notifications`, `permission_handler`
- **Analytics & backend**: `firebase_core`, `firebase_analytics`
- **Ads**: `google_mobile_ads` (banner, interstitial, app-open)

See `pubspec.yaml` for the full list of dependencies.

---

## Getting Started

### Prerequisites

- Flutter SDK installed (version compatible with Dart `^3.7.2`)
- Android Studio and/or Xcode for platform tooling
- A configured Firebase project (if you want analytics)
- Google Mobile Ads app IDs and ad unit IDs for your own release builds

### Clone the repository

```bash
git clone https://github.com/amarhumayunx/Surah-Yaseen.git
cd Surah-Yaseen
```

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

You can select an emulator or a physical device from your IDE or CLI.

---

## Platform Configuration (Overview)

- **Firebase**  
  - Add your own `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) if you want to use Firebase Analytics.

- **Google Mobile Ads**  
  - Update ad unit IDs in the `lib/constants/ad_unit_ids.dart` file for your own apps.
  - Debug builds automatically use test ads (see `reusable_banner_ad` and ad managers).

- **App icons & splash**  
  - Managed via `flutter_launcher_icons` and `flutter_native_splash` using the configuration in `pubspec.yaml`.

---

## Project Structure (High Level)

- `lib/main.dart` – App entry point, initialization (Firebase, Hive, notifications, ads, etc.).
- `lib/screens/` – Main app screens (Ruku screens, About, Privacy Policy, etc.).
- `lib/widgets/` – Reusable UI widgets (home options, ruku readers, audio players, ads, settings, etc.).
- `lib/services/` – Core services like notifications, consent manager, verse navigation, analytics, ad managers.
- `lib/constants/` – Constants such as strings and ad unit IDs.

---

## Notes

- This repository is primarily a **Surah Yaseen companion app**, not a general-purpose Quran app.
- Always verify ad and analytics policies for your target regions (GDPR/EEA consent, etc.).
- Feel free to fork and adapt for personal use or learning.

---

## License

Specify your license here (e.g. MIT, proprietary, etc.). If none is provided, assume the code is for personal/non-commercial use unless stated otherwise.

