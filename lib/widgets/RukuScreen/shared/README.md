# Reusable Ruku Screen Widgets

This directory contains generic, reusable widgets that replace duplicate code across all 5 Ruku screens.

## Overview

Previously, each Ruku screen had its own duplicate files:
- `Ruku*ReadScreen.dart` (5 files)
- `ListenAudioRuku*Screen.dart` (5 files)
- `ListenAudioWithTranslationRuku*.dart` (5 files)
- `VersePageContainer*.dart` (15 files - 3 per Ruku)

**Now replaced with:**
- `ruku_read_screen.dart` - Single reusable read screen
- `ruku_listen_audio_screen.dart` - Single reusable audio screen
- `ruku_listen_audio_with_translation_screen.dart` - Single reusable audio with translation screen
- `verse_page_container.dart` - Single reusable verse container
- `verse_page_container_arabic.dart` - Single reusable Arabic-only container
- `verse_page_container_with_translation.dart` - Single reusable container with translation
- `ruku_config.dart` - Configuration model for Ruku-specific data

## Usage Example

### Updating RukuFirstScreen

**Before:**
```dart
import 'package:surah_yaseen/widgets/RukuFirstScreen/RukuFirstReadScreen.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/ListenAudioRukuFirstScreen.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/ListenAudioWithTranslationRukuFirst.dart';

RukuButtonsUnderText(
  readScreen: const RukuFirstReadScreen(),
  listenAudioScreen: const ListenAudioRukuFirstScreen(),
  listenAudioWithTranslationScreen: const ListenAudioWithTranslationRukuFirst(),
),
```

**After:**
```dart
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_listen_audio_screen.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_listen_audio_with_translation_screen.dart';

// Define verses map (can be extracted from AppStrings or kept as is)
final Map<int, String> ruku1Verses = {
  0: "يس",
  1: "وَالْقُرْآنِ الْحَكِيمِ",
  // ... rest of verses
};

final config = RukuConfig.getRukuConfig(1);

RukuButtonsUnderText(
  readScreen: RukuReadScreen(config: config),
  listenAudioScreen: RukuListenAudioScreen(
    config: config,
    verses: ruku1Verses,
  ),
  listenAudioWithTranslationScreen: RukuListenAudioWithTranslationScreen(
    config: config,
    verses: ruku1Verses,
  ),
),
```

## Benefits

1. **Code Reduction**: Eliminated ~30+ duplicate files
2. **Maintainability**: Single source of truth for each widget type
3. **Consistency**: All Ruku screens behave identically
4. **Easier Updates**: Fix bugs or add features in one place
5. **Better Organization**: Clear separation of concerns

## Migration Steps

1. Import the new shared widgets
2. Get the RukuConfig for your Ruku number
3. Define the verses map (if using audio screens)
4. Replace old widget instances with new generic ones
5. Test thoroughly
6. Delete old duplicate files

## Files Structure

```
shared/
├── ruku_config.dart                    # Configuration model
├── ruku_read_screen.dart               # Generic read screen
├── ruku_listen_audio_screen.dart       # Generic audio screen
├── ruku_listen_audio_with_translation_screen.dart  # Generic audio with translation
├── verse_page_container.dart          # Generic verse container (with translation)
├── verse_page_container_arabic.dart   # Generic Arabic-only container
└── verse_page_container_with_translation.dart  # Generic container with translation
```

