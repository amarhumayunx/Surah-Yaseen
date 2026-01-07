# Reusable VersePageContainer Widget Usage Guide

## Overview

The `VersePageContainer` widget in `lib/widgets/RukuScreen/shared/verse_page_container.dart` is now a **fully reusable widget** that can replace all individual Ruku container files.

## Key Features

✅ **Single widget for all Rukus** - No need for separate files per Ruku  
✅ **Configurable start offset** - Handles different verse starting points  
✅ **Fixed Google Fonts issues** - Uses proper async font loading  
✅ **Fixed page controller** - Proper page navigation in full screen dialog  
✅ **All features included** - Bookmarks, full screen dialog, swipe navigation

## How to Use

### For Ruku 1 (offset = 0, default)

```dart
VersePageContainer(
  rukuNumber: 1,
  startVerseIndex: _calculateStartVerseIndex(),
  lastVerseIndex: 12,
  versesPerPage: 6,
  versesPerPageDialogBox: 6,
  currentPage: _currentPage,
  totalPageDialogBox: 2,
  totalPages: 2,
  // dialogStartVerseOffset: 0, // Optional, defaults to 0
  onPrevPage: _goToPrevPage,
  onNextPage: _goToNextPage,
  isFullScreen: false,
  onToggleFullScreen: () {
    // Handle full screen toggle
  },
)
```

### For Ruku 2 (offset = 13)

```dart
VersePageContainer(
  rukuNumber: 2,
  startVerseIndex: _calculateStartVerseIndex(),
  lastVerseIndex: 27,
  versesPerPage: 6,
  versesPerPageDialogBox: 6,
  currentPage: _currentPage,
  totalPageDialogBox: 3,
  totalPages: 3,
  dialogStartVerseOffset: 13, // Important: Set offset for Ruku 2
  onPrevPage: _goToPrevPage,
  onNextPage: _goToNextPage,
  isFullScreen: false,
  onToggleFullScreen: () {
    // Handle full screen toggle
  },
)
```

### For Ruku 3 (offset = 33)

```dart
VersePageContainer(
  rukuNumber: 3,
  dialogStartVerseOffset: 33, // Set offset for Ruku 3
  // ... other parameters
)
```

### For Ruku 4 (offset = 51)

```dart
VersePageContainer(
  rukuNumber: 4,
  dialogStartVerseOffset: 51, // Set offset for Ruku 4
  // ... other parameters
)
```

### For Ruku 5 (offset = 68)

```dart
VersePageContainer(
  rukuNumber: 5,
  dialogStartVerseOffset: 68, // Set offset for Ruku 5
  // ... other parameters
)
```

## Migration Guide

### Step 1: Import the shared widget

Replace:
```dart
import '../RukuFirstScreen/VersePageContainerRukuFirst.dart';
```

With:
```dart
import '../RukuScreen/shared/verse_page_container.dart';
```

### Step 2: Replace widget usage

**Before:**
```dart
VersePageContainerRukuFirst(
  rukuNumber: 1,
  startVerseIndex: _calculateStartVerseIndex(),
  // ... other params
)
```

**After:**
```dart
VersePageContainer(
  rukuNumber: 1,
  startVerseIndex: _calculateStartVerseIndex(),
  dialogStartVerseOffset: 0, // or omit for Ruku 1
  // ... other params
)
```

### Step 3: Set correct offset for each Ruku

| Ruku | Offset Value |
|------|-------------|
| 1    | 0 (default) |
| 2    | 13         |
| 3    | 33         |
| 4    | 51         |
| 5    | 68         |

## Benefits

1. **Code Reduction**: One widget instead of 5 separate files
2. **Easier Maintenance**: Fix bugs once, applies to all Rukus
3. **Consistency**: All Rukus behave the same way
4. **Less Duplication**: No repeated code

## What's Fixed

✅ Page text updates immediately in full screen dialog  
✅ Google Fonts errors resolved  
✅ Proper page controller synchronization  
✅ All Rukus use the same reliable code

## Files That Can Be Replaced

You can now replace these individual files with the shared widget:
- `VersePageContainerRukuFirst.dart`
- `VersePageContainerRukuSecond.dart`
- `VersePageContainerRukuThird.dart`
- `VersePageContainerRukuFourth.dart`
- `VersePageContainerRukuFive.dart`

Just update the imports and add the `dialogStartVerseOffset` parameter!

