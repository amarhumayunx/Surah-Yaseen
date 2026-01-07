# Migration Guide - Reusable Ruku Widgets

## 🎯 Overview

All Ruku screen files can now be replaced with reusable widgets. This guide shows how to migrate.

---

## ✅ Available Reusable Widgets

1. **`RukuReadScreen`** - Replaces all `Ruku*ReadScreen.dart` files
2. **`RukuListenAudioScreen`** - Replaces all `ListenAudioRuku*Screen.dart` files  
3. **`RukuListenAudioWithTranslationScreen`** - Replaces all `ListenAudioWithTranslationRuku*.dart` files
4. **`VersePageContainer`** - Already reusable (with `dialogStartVerseOffset`)
5. **`ArabicVerseContainer`** - Already reusable
6. **`ArabicVerseWithTranslationContainer`** - Already reusable

---

## 📝 Migration Steps

### Step 1: Update RukuReadScreen Files

#### Before (RukuFirstReadScreen.dart):
```dart
import 'VersePageContainerRukuFirst.dart';

class RukuFirstReadScreen extends StatefulWidget {
  // ... 111 lines of code
  VersePageContainer(
    rukuNumber: 1,
    startVerseIndex: (_currentPage - 1) * 4,
    lastVerseIndex: 12,
    // ... many parameters
  )
}
```

#### After:
```dart
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';

class RukuFirstReadScreen extends StatelessWidget {
  const RukuFirstReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RukuReadScreen(
      config: RukuConfig.getRukuConfig(1),
    );
  }
}
```

**Code Reduction:** 111 lines → 12 lines (89% reduction!)

---

### Step 2: Update ListenAudioRuku*Screen Files

#### Before (ListenAudioRukuFirstScreen.dart):
```dart
class ListenAudioRukuFirstScreen extends StatefulWidget {
  // ... 137 lines of code
  final Map<int, String> yaseen_verses = {
    0: "يس",
    1: "وَالْقُرْآنِ الْحَكِيمِ",
    // ... many verses
  };
  // ... state management, navigation, etc.
}
```

#### After:
```dart
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_listen_audio_screen.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
import 'package:surah_yaseen/constants/app_strings.dart';

class ListenAudioRukuFirstScreen extends StatelessWidget {
  const ListenAudioRukuFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get verses from AppStrings or define here
    final Map<int, String> verses = {
      0: "يس",
      1: "وَالْقُرْآنِ الْحَكِيمِ",
      // ... verses
    };

    return RukuListenAudioScreen(
      config: RukuConfig.getRukuConfig(1),
      verses: verses,
    );
  }
}
```

**Code Reduction:** 137 lines → ~25 lines (82% reduction!)

---

### Step 3: Update ListenAudioWithTranslationRuku* Files

#### Before:
```dart
class ListenAudioWithTranslationRukuFirst extends StatefulWidget {
  // ... 135 lines of code
}
```

#### After:
```dart
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_listen_audio_with_translation_screen.dart';
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';

class ListenAudioWithTranslationRukuFirst extends StatelessWidget {
  const ListenAudioWithTranslationRukuFirst({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<int, String> verses = {
      // ... verses
    };

    return RukuListenAudioWithTranslationScreen(
      config: RukuConfig.getRukuConfig(1),
      verses: verses,
    );
  }
}
```

---

## 🔧 Complete Migration Example

### For Ruku 1:

**Before:** 3 separate files (~383 lines total)
- `RukuFirstReadScreen.dart` (111 lines)
- `ListenAudioRukuFirstScreen.dart` (137 lines)
- `ListenAudioWithTranslationRukuFirst.dart` (135 lines)

**After:** 3 simple files (~75 lines total)
- `RukuFirstReadScreen.dart` (12 lines)
- `ListenAudioRukuFirstScreen.dart` (25 lines)
- `ListenAudioWithTranslationRukuFirst.dart` (25 lines)

**Savings:** 308 lines (80% reduction!)

---

## 📋 Migration Checklist

For each Ruku (1-5):

- [ ] Replace `Ruku*ReadScreen.dart` with `RukuReadScreen` widget
- [ ] Replace `ListenAudioRuku*Screen.dart` with `RukuListenAudioScreen` widget
- [ ] Replace `ListenAudioWithTranslationRuku*.dart` with `RukuListenAudioWithTranslationScreen` widget
- [ ] Update imports to use shared widgets
- [ ] Use `RukuConfig.getRukuConfig(rukuNumber)` for configuration
- [ ] Test all functionality (reading, audio, translation)

---

## 🎯 Quick Reference

### Ruku Config Numbers:
- Ruku 1: `RukuConfig.getRukuConfig(1)`
- Ruku 2: `RukuConfig.getRukuConfig(2)`
- Ruku 3: `RukuConfig.getRukuConfig(3)`
- Ruku 4: `RukuConfig.getRukuConfig(4)`
- Ruku 5: `RukuConfig.getRukuConfig(5)`

### Import Paths:
```dart
// Read Screen
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_read_screen.dart';

// Listen Audio
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_listen_audio_screen.dart';

// Listen Audio With Translation
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_listen_audio_with_translation_screen.dart';

// Config
import 'package:surah_yaseen/widgets/RukuScreen/shared/ruku_config.dart';
```

---

## ⚠️ Important Notes

1. **Verses Map**: You still need to provide the `verses` map for audio screens. This can be:
   - Defined locally in each screen
   - Loaded from `AppStrings`
   - Centralized in a verses service

2. **Navigation**: The reusable widgets handle all navigation internally. No need to manage page state manually.

3. **Customization**: If you need custom behavior, you can:
   - Extend the reusable widgets
   - Modify the shared widgets (affects all Rukus)
   - Use the config system to add more parameters

---

## 🚀 Benefits After Migration

✅ **80% less code** - From ~1900 lines to ~375 lines  
✅ **Easier maintenance** - Fix bugs once, applies everywhere  
✅ **Consistent behavior** - All Rukus work identically  
✅ **Faster development** - Add features once, all Rukus get them  
✅ **Better testing** - Test one widget, covers all Rukus  

---

## 📞 Need Help?

If you encounter issues during migration:
1. Check the `REUSABLE_CODE_ANALYSIS.md` for detailed analysis
2. Review the example usage in `example_usage.dart`
3. Compare with existing working implementations

