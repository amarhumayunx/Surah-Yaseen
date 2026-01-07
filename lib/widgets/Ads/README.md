# Reusable Banner Ad Widget

Yeh ek reusable banner ad widget hai jo app ke har screen mein use ho sakta hai. Har screen ke liye alag ad unit ID use hota hai.

## Features

- ✅ Reusable - ek hi widget har jagah use karo
- ✅ Screen-based IDs - har screen ka apna ad unit ID
- ✅ Automatic test ads - debug mode mein automatically test ads show hote hain
- ✅ Error handling - proper error handling aur logging
- ✅ Easy to use - simple API

## Usage

### Method 1: Screen Type Use Karna (Recommended)

Yeh sabse easy aur maintainable way hai:

```dart
import '../widgets/Ads/reusable_banner_ad.dart';
import '../constants/ad_unit_ids.dart';

// Screen mein use karo:
ReusableBannerAd(
  screenType: AdScreenType.settings,
  minHeight: 50, // Optional
)
```

### Method 2: Direct Ad Unit ID Use Karna

Agar aap directly ad unit ID dena chahte hain:

```dart
import '../widgets/Ads/reusable_banner_ad.dart';
import '../constants/ad_unit_ids.dart';

ReusableBannerAd(
  adUnitId: AdUnitIds.settingsScreenBanner,
  minHeight: 50, // Optional
)
```

## Available Screen Types

- `AdScreenType.home` - Home screen
- `AdScreenType.ruku` - Ruku screen
- `AdScreenType.bookmark` - Bookmark screen
- `AdScreenType.settings` - Settings screen
- `AdScreenType.rukuFirst` - Ruku First screen
- `AdScreenType.rukuSecond` - Ruku Second screen
- `AdScreenType.rukuThird` - Ruku Third screen
- `AdScreenType.rukuFourth` - Ruku Fourth screen
- `AdScreenType.rukuFifth` - Ruku Fifth screen
- `AdScreenType.about` - About screen
- `AdScreenType.help` - Help screen
- `AdScreenType.language` - Language screen
- `AdScreenType.notification` - Notification screen
- `AdScreenType.privacyPolicy` - Privacy Policy screen

## Example: SettingScreen mein Use

```dart
import '../widgets/Ads/reusable_banner_ad.dart';
import '../constants/ad_unit_ids.dart';

// Column ya ListView mein:
Column(
  children: [
    // ... other widgets
    SizedBox(height: 20),
    ReusableBannerAd(
      screenType: AdScreenType.settings,
      minHeight: 50,
    ),
    SizedBox(height: 20),
  ],
)
```

## Naya Screen Add Karna

1. `lib/constants/ad_unit_ids.dart` mein:
   - `AdScreenType` enum mein naya screen type add karo
   - `AdUnitIds` class mein naya constant add karo
   - `getBannerAdUnitId()` method mein case add karo

2. Screen mein use karo:
   ```dart
   ReusableBannerAd(screenType: AdScreenType.yourNewScreen)
   ```

## Notes

- Debug mode mein automatically test ads show hote hain
- Production mode mein actual ads show hote hain
- Ad load nahi hua to widget automatically hide ho jata hai
- Proper error handling aur logging included hai

