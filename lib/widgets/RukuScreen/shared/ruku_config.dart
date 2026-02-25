/// Configuration model for Ruku-specific data
/// This helps avoid hardcoding values across multiple screens
class RukuConfig {
  final int rukuNumber;
  final int startVerseIndex; // 0-based index
  final int lastVerseIndex; // 0-based index
  final int totalPages;
  final int totalPageDialogBox;
  final int versesPerPage;
  final int versesPerPageDialogBox;
  final int dialogStartVerseOffset; // Offset for calculating start index in dialog
  final Map<int, String> verses; // Arabic verses map
  final String titleKey; // Translation key for title
  final String verseRangeKey; // Translation key for verse range
  final String quoteKey; // Translation key for quote section
  final String audioTitleKey; // Translation key for audio title
  final String audioWithTranslationTitleKey; // Translation key for audio with translation title

  const RukuConfig({
    required this.rukuNumber,
    required this.startVerseIndex,
    required this.lastVerseIndex,
    required this.totalPages,
    required this.totalPageDialogBox,
    required this.versesPerPage,
    required this.versesPerPageDialogBox,
    this.dialogStartVerseOffset = 0, // Default to 0
    required this.verses,
    required this.titleKey,
    required this.verseRangeKey,
    required this.quoteKey,
    required this.audioTitleKey,
    required this.audioWithTranslationTitleKey,
  });

  /// Predefined configurations for all 5 Rukus
  static const List<RukuConfig> allRukus = [
    RukuConfig(
      rukuNumber: 1,
      startVerseIndex: 0,
      lastVerseIndex: 12,
      totalPages: 4,
      totalPageDialogBox: 3,
      versesPerPage: 4,
      versesPerPageDialogBox: 6,
      dialogStartVerseOffset: 0,
      verses: {}, // Will be populated from AppStrings
      titleKey: 'ruku_title_one',
      verseRangeKey: 'verse_title_one_to_twelve',
      quoteKey: 'text_under_card_ruku1',
      audioTitleKey: 'ruku_title_audio1',
      audioWithTranslationTitleKey: 'ruku_title_audio_trans1',
    ),
    RukuConfig(
      rukuNumber: 2,
      startVerseIndex: 12,
      lastVerseIndex: 32,
      totalPages: 5,
      totalPageDialogBox: 4,
      versesPerPage: 4,
      versesPerPageDialogBox: 6,
      dialogStartVerseOffset: 13,
      verses: {},
      titleKey: 'ruku_two',
      verseRangeKey: 'verse_title_thirteen_to_thirtytwo',
      quoteKey: 'text_under_card_ruku2',
      audioTitleKey: 'ruku_title_audio2',
      audioWithTranslationTitleKey: 'ruku_title_audio_trans2',
    ),
    RukuConfig(
      rukuNumber: 3,
      startVerseIndex: 32,
      lastVerseIndex: 50,
      totalPages: 5,
      totalPageDialogBox: 3,
      versesPerPage: 4,
      versesPerPageDialogBox: 6,
      dialogStartVerseOffset: 33,
      verses: {},
      titleKey: 'ruku_three',
      verseRangeKey: 'verse_title_thirtythree_to_fifty',
      quoteKey: 'text_under_card_ruku3',
      audioTitleKey: 'ruku_title_audio3',
      audioWithTranslationTitleKey: 'ruku_title_audio_trans3',
    ),
    RukuConfig(
      rukuNumber: 4,
      startVerseIndex: 50,
      lastVerseIndex: 67,
      totalPages: 5,
      totalPageDialogBox: 3,
      versesPerPage: 4,
      versesPerPageDialogBox: 6,
      dialogStartVerseOffset: 51,
      verses: {},
      titleKey: 'ruku_four',
      verseRangeKey: 'verse_title_fiftyone_to_sixtyseven',
      quoteKey: 'text_under_card_ruku4',
      audioTitleKey: 'ruku_title_audio4',
      audioWithTranslationTitleKey: 'ruku_title_audio_trans4',
    ),
    RukuConfig(
      rukuNumber: 5,
      startVerseIndex: 67,
      lastVerseIndex: 83,
      totalPages: 5,
      totalPageDialogBox: 3,
      versesPerPage: 4,
      versesPerPageDialogBox: 6,
      dialogStartVerseOffset: 68,
      verses: {},
      titleKey: 'ruku_five',
      verseRangeKey: 'verse_title_sixtyeight_to_eightythree',
      quoteKey: 'text_under_card_ruku5',
      audioTitleKey: 'ruku_title_audio5',
      audioWithTranslationTitleKey: 'ruku_title_audio_trans5',
    ),
  ];

  /// Get configuration for a specific Ruku number
  static RukuConfig getRukuConfig(int rukuNumber) {
    return allRukus.firstWhere(
      (config) => config.rukuNumber == rukuNumber,
      orElse: () => allRukus[0],
    );
  }
}

