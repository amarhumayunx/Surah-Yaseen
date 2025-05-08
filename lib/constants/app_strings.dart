class AppStrings {
  static const exitDialog = ExitDialogStrings();
  static const deleteDialog = DeleteDialogStrings();
  static const navBar = NavBarStrings();
  static const appnamestrings = AppNameStrings();
  static const bookmarkScreenBodystrings = BookmarkScreenBodyStrings();
  static const onboardingStrings = OnboardingStrings();
  static const rukuStrings = RukuStrings();
  static const homeScreenStrings = HomeScreenStrings();
  static var yasinSurahStrings = YasinSurahStrings();
  static const aboutScreenStrings = AboutScreenStrings();
  static const settingScreenStrings = SettingScreenStrings();
  static const rukuFirstScreenStrings = RukuFirstScreenStrings();
  static const listenAudioScreenString = ListenAudioScreenString();
  static const rukuSecondScreenStrings = RukuSecondScreenStrings();
  static const rukuThirdScreenStrings = RukuThirdScreenStrings();
  static const rukuFourthScreenStrings = RukuFourthScreenStrings();
  static const rukuFivethScreenStrings = RukuFivethScreenStrings();
  static const listenAudioWithTranslationScreenString = ListenAudioWithTranslationScreenString();
}

class ExitDialogStrings {
  const ExitDialogStrings();

  final String title = 'Exit App';
  final String yes = 'YES';
  final String no = 'NO';
}

class DeleteDialogStrings{
  const DeleteDialogStrings();
  final String title = 'Delete App';
  final String yes = 'YES';
  final String no = 'NO';
}

class NavBarStrings{

  const NavBarStrings();

  final String homenavbarbuttonstring = 'Home';
  final String rukubuttonstring = 'Library';
  final String bookmarkbuttonstring = 'Bookmarks';
  final String settingbuttonstring = 'Settings';
}

class AppNameStrings {

  const AppNameStrings();

  final String appname = 'Surah Yaseen';
  final String suratname = '(Makki)';
  final String appnameUrdu = 'سورة يس';
  final String suratnameUrdu = '(مكي)';
}

class BookmarkScreenBodyStrings {

  const BookmarkScreenBodyStrings();

  final String title = 'Bookmarks';

  final String bookmarkitemfirstarabicTextString = 'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ';
  final String bookmarkitemfirsttitleString = 'Ruku 6 · Verse 22';
  final String bookmarkitemfirstdateString = '12/04/25';
  final String bookmarkitemfirsticonTypeString = 'quran';

  final String bookmarkitemsecondarabicTextString = 'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ';
  final String bookmarkitemsecondtitleString = 'Ruku 6 · Verse 22';
  final String bookmarkitemseconddateString = '12/04/25';
  final String bookmarkitemsecondsticonTypeString = 'quran';

  final String bookmarkitemthirdarabicTextString = 'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ';
  final String bookmarkitemthirdtitleString = 'Ruku 6 · Verse 22';
  final String bookmarkitemthirddateString = '12/04/25';
  final String bookmarkitemthirdiconTypeString = 'audio';

  final String all = "All";
  final String recents = "Recents";
}

class OnboardingStrings {

  const OnboardingStrings();

  final String getStartedbuttonString = 'Get Started';
  final String nextbuttonString = 'Next';
  final String skipbuttonString = 'SKIP';

  final String firstPageTitle = 'Read with Clarity & Comfort';
  final String firstPageDesc = 'Rukū‘-wise reading with translation and adjustable font for a smooth experience.';

  final String secondPageTitle = 'Listen & Reflect';
  final String secondPageDesc = 'Immerse in soulful recitation with synchronized verse highlighting and translation.';

  final String thirdPageTitle = 'Listen & Reflect';
  final String thirdPageDesc = 'Immerse in soulful recitation with synchronized verse highlighting and translation.';

  final String fourthPageTitle = 'Listen & Reflect';
  final String fourthPageDesc = 'Immerse in soulful recitation with synchronized verse highlighting and translation.';
}

class RukuStrings {

  const RukuStrings();

  final rukubuttontitle = 'Rukū\'s';

  final textunderrukubutton = '"Surah Yaseen\'s 4 Rukū\'s emphasize Allah\'s oneness, '
      'guidance, consequences of disbelief, '
      'and lessons from past nations.';

  final String rukutitleone = 'Rukū 1';
  final String versetitleonetotwelve = 'Verses 1-12';

  final String rukutwo = 'Rukū 2';
  final String versetitlethirteentothirtytwo = 'Verses 13-32';

  final String rukuthree = 'Rukū 3';
  final String versetitlethirtythreetofifty = 'Verses 33-50';

  final String rukufour = 'Rukū 4';
  final String versetitlefiftyonetosixtyseven = 'Verses 51-67';

  final String rukufiveth = 'Rukū 5';
  final String versetitlesixtheighttoeightythree = 'Verses 68-83';
}

class HomeScreenStrings{

  const HomeScreenStrings();

  final String textunderbutton = '"The heart of the Quran, a source\nof wisdom and guidance."';

  final String startReading = "Start Reading";
  final String bookmarks = "Bookmarks";
  final String about = "About";
  final String listenAudio = "Listen Audio";

  final String ruku1 = "Ruku 1:";
  final String introductionTo = "Introduction to";
  final String surah = "Surah";
  final String verses1To12 = 'Verses: "1-12"';
  final String emptyString = '';


}

class YasinSurahStrings {

  YasinSurahStrings();

  // Metadata
  final String surahName = "Yasin";
  final String surahNumber = "36";
  final String totalVerses = "83";
  final String revelationType = "Makki";

  // Verses
  final Map<String, String> verses = {
    "verse_0": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
    "verse_1": "يس",
    "verse_2": "وَالْقُرْآنِ الْحَكِيمِ",
    "verse_3": "إِنَّكَ لَمِنَ الْمُرْسَلِينَ",
    "verse_4": "عَلَىٰ صِرَاطٍ مُسْتَقِيمٍ",
    "verse_5": "تَنْزِيلَ الْعَزِيزِ الرَّحِيمِ",
    "verse_6": "لِتُنْذِرَ قَوْمًا مَا أُنْذِرَ آبَاؤُهُمْ فَهُمْ غَافِلُونَ",
    "verse_7": "لَقَدْ حَقَّ الْقَوْلُ عَلَىٰ أَكْثَرِهِمْ فَهُمْ لَا يُؤْمِنُونَ",
    "verse_8": "إِنَّا جَعَلْنَا فِي أَعْنَاقِهِمْ أَغْلَالًا فَهِيَ إِلَى الْأَذْقَانِ فَهُمْ مُقْمَحُونَ",
    "verse_9": "وَجَعَلْنَا مِنْ بَيْنِ أَيْدِيهِمْ سَدًّا وَمِنْ خَلْفِهِمْ سَدًّا فَأَغْشَيْنَاهُمْ فَهُمْ لَا يُبْصِرُونَ",
    "verse_10": "وَسَوَاءٌ عَلَيْهِمْ أَأَنْذَرْتَهُمْ أَمْ لَمْ تُنْذِرْهُمْ لَا يُؤْمِنُونَ",
    "verse_11": "إِنَّمَا تُنْذِرُ مَنِ اتَّبَعَ الذِّكْرَ وَخَشِيَ الرَّحْمَٰنَ بِالْغَيْبِ ۖ فَبَشِّرْهُ بِمَغْفِرَةٍ وَأَجْرٍ كَرِيمٍ",
    "verse_12": "إِنَّا نَحْنُ نُحْيِي الْمَوْتَىٰ وَنَكْتُبُ مَا قَدَّمُوا وَآثَارَهُمْ ۚ وَكُلَّ شَيْءٍ أَحْصَيْنَاهُ فِي إِمَامٍ مُبِينٍ",
    "verse_13": "وَاضْرِبْ لَهُمْ مَثَلًا أَصْحَابَ الْقَرْيَةِ إِذْ جَاءَهَا الْمُرْسَلُونَ",
    "verse_14": "إِذْ أَرْسَلْنَا إِلَيْهِمُ اثْنَيْنِ فَكَذَّبُوهُمَا فَعَزَّزْنَا بِثَالِثٍ فَقَالُوا إِنَّا إِلَيْكُمْ مُرْسَلُونَ",
    "verse_15": "قَالُوا مَا أَنْتُمْ إِلَّا بَشَرٌ مِثْلُنَا وَمَا أَنْزَلَ الرَّحْمَٰنُ مِنْ شَيْءٍ إِنْ أَنْتُمْ إِلَّا تَكْذِبُونَ",
    "verse_16": "قَالُوا رَبُّنَا يَعْلَمُ إِنَّا إِلَيْكُمْ لَمُرْسَلُونَ",
    "verse_17": "وَمَا عَلَيْنَا إِلَّا الْبَلَاغُ الْمُبِينُ",
    "verse_18": "قَالُوا إِنَّا تَطَيَّرْنَا بِكُمْ ۖ لَئِنْ لَمْ تَنْتَهُوا لَنَرْجُمَنَّكُمْ وَلَيَمَسَّنَّكُمْ مِنَّا عَذَابٌ أَلِيمٌ",
    "verse_19": "قَالُوا طَائِرُكُمْ مَعَكُمْ ۚ أَئِنْ ذُكِّرْتُمْ ۚ بَلْ أَنْتُمْ قَوْمٌ مُسْرِفُونَ",
    "verse_20": "وَجَاءَ مِنْ أَقْصَى الْمَدِينَةِ رَجُلٌ يَسْعَىٰ قَالَ يَا قَوْمِ اتَّبِعُوا الْمُرْسَلِينَ",
    "verse_21": "اتَّبِعُوا مَنْ لَا يَسْأَلُكُمْ أَجْرًا وَهُمْ مُهْتَدُونَ",
    "verse_22": "وَمَا لِيَ لَا أَعْبُدُ الَّذِي فَطَرَنِي وَإِلَيْهِ تُرْجَعُونَ",
    "verse_23": "أَأَتَّخِذُ مِنْ دُونِهِ آلِهَةً إِنْ يُرِدْنِ الرَّحْمَٰنُ بِضُرٍّ لَا تُغْنِ عَنِّي شَفَاعَتُهُمْ شَيْئًا وَلَا يُنْقِذُونِ",
    "verse_24": "إِنِّي إِذًا لَفِي ضَلَالٍ مُبِينٍ",
    "verse_25": "إِنِّي آمَنْتُ بِرَبِّكُمْ فَاسْمَعُونِ",
    "verse_26": "قِيلَ ادْخُلِ الْجَنَّةَ ۖ قَالَ يَا لَيْتَ قَوْمِي يَعْلَمُونَ",
    "verse_27": "بِمَا غَفَرَ لِي رَبِّي وَجَعَلَنِي مِنَ الْمُكْرَمِينَ ۞",
    "verse_28": " وَمَا أَنْزَلْنَا عَلَىٰ قَوْمِهِ مِنْ بَعْدِهِ مِنْ جُنْدٍ مِنَ السَّمَاءِ وَمَا كُنَّا مُنْزِلِينَ",
    "verse_29": "إِنْ كَانَتْ إِلَّا صَيْحَةً وَاحِدَةً فَإِذَا هُمْ خَامِدُونَ",
    "verse_30": "يَا حَسْرَةً عَلَى الْعِبَادِ ۚ مَا يَأْتِيهِمْ مِنْ رَسُولٍ إِلَّا كَانُوا بِهِ يَسْتَهْزِئُونَ",
    "verse_31": "أَلَمْ يَرَوْا كَمْ أَهْلَكْنَا قَبْلَهُمْ مِنَ الْقُرُونِ أَنَّهُمْ إِلَيْهِمْ لَا يَرْجِعُونَ",
    "verse_32": "وَإِنْ كُلٌّ لَمَّا جَمِيعٌ لَدَيْنَا مُحْضَرُونَ",
    "verse_33": "وَآيَةٌ لَهُمُ الْأَرْضُ الْمَيْتَةُ أَحْيَيْنَاهَا وَأَخْرَجْنَا مِنْهَا حَبًّا فَمِنْهُ يَأْكُلُونَ",
    "verse_34": "وَجَعَلْنَا فِيهَا جَنَّاتٍ مِنْ نَخِيلٍ وَأَعْنَابٍ وَفَجَّرْنَا فِيهَا مِنَ الْعُيُونِ",
    "verse_35": "لِيَأْكُلُوا مِنْ ثَمَرِهِ وَمَا عَمِلَتْهُ أَيْدِيهِمْ ۖ أَفَلَا يَشْكُرُونَ",
    "verse_36": "سُبْحَانَ الَّذِي خَلَقَ الْأَزْوَاجَ كُلَّهَا مِمَّا تُنْبِتُ الْأَرْضُ وَمِنْ أَنْفُسِهِمْ وَمِمَّا لَا يَعْلَمُونَ",
    "verse_37": "وَآيَةٌ لَهُمُ اللَّيْلُ نَسْلَخُ مِنْهُ النَّهَارَ فَإِذَا هُمْ مُظْلِمُونَ",
    "verse_38": "وَالشَّمْسُ تَجْرِي لِمُسْتَقَرٍّ لَهَا ۚ ذَٰلِكَ تَقْدِيرُ الْعَزِيزِ الْعَلِيمِ",
    "verse_39": "وَالْقَمَرَ قَدَّرْنَاهُ مَنَازِلَ حَتَّىٰ عَادَ كَالْعُرْجُونِ الْقَدِيمِ",
    "verse_40": "لَا الشَّمْسُ يَنْبَغِي لَهَا أَنْ تُدْرِكَ الْقَمَرَ وَلَا اللَّيْلُ سَابِقُ النَّهَارِ ۚ وَكُلٌّ فِي فَلَكٍ يَسْبَحُونَ",
    "verse_41": "وَآيَةٌ لَهُمْ أَنَّا حَمَلْنَا ذُرِّيَّتَهُمْ فِي الْفُلْكِ الْمَشْحُونِ",
    "verse_42": "وَخَلَقْنَا لَهُمْ مِنْ مِثْلِهِ مَا يَرْكَبُونَ",
    "verse_43": "وَإِنْ نَشَأْ نُغْرِقْهُمْ فَلَا صَرِيخَ لَهُمْ وَلَا هُمْ يُنْقَذُونَ",
    "verse_44": "إِلَّا رَحْمَةً مِنَّا وَمَتَاعًا إِلَىٰ حِينٍ",
    "verse_45": "وَإِذَا قِيلَ لَهُمُ اتَّقُوا مَا بَيْنَ أَيْدِيكُمْ وَمَا خَلْفَكُمْ لَعَلَّكُمْ تُرْحَمُونَ",
    "verse_46": "وَمَا تَأْتِيهِمْ مِنْ آيَةٍ مِنْ آيَاتِ رَبِّهِمْ إِلَّا كَانُوا عَنْهَا مُعْرِضِينَ",
    "verse_47": "وَإِذَا قِيلَ لَهُمْ أَنْفِقُوا مِمَّا رَزَقَكُمُ اللَّهُ قَالَ الَّذِينَ كَفَرُوا لِلَّذِينَ آمَنُوا أَنُطْعِمُ مَنْ لَوْ يَشَاءُ اللَّهُ أَطْعَمَهُ إِنْ أَنْتُمْ إِلَّا فِي ضَلَالٍ مُبِينٍ",
    "verse_48": "وَيَقُولُونَ مَتَىٰ هَٰذَا الْوَعْدُ إِنْ كُنْتُمْ صَادِقِينَ",
    "verse_49": "مَا يَنْظُرُونَ إِلَّا صَيْحَةً وَاحِدَةً تَأْخُذُهُمْ وَهُمْ يَخِصِّمُونَ",
    "verse_50": "فَلَا يَسْتَطِيعُونَ تَوْصِيَةً وَلَا إِلَىٰ أَهْلِهِمْ يَرْجِعُونَ",
    "verse_51": "وَنُفِخَ فِي الصُّورِ فَإِذَا هُمْ مِنَ الْأَجْدَاثِ إِلَىٰ رَبِّهِمْ يَنْسِلُونَ",
    "verse_52": "قَالُوا يَا وَيْلَنَا مَنْ بَعَثَنَا مِنْ مَرْقَدِنَا ۜ ۗ هَٰذَا مَا وَعَدَ الرَّحْمَٰنُ وَصَدَقَ الْمُرْسَلُونَ",
    "verse_53": "إِنْ كَانَتْ إِلَّا صَيْحَةً وَاحِدَةً فَإِذَا هُمْ جَمِيعٌ لَدَيْنَا مُحْضَرُونَ",
    "verse_54": "فَالْيَوْمَ لَا تُظْلَمُ نَفْسٌ شَيْئًا وَلَا تُجْزَوْنَ إِلَّا مَا كُنْتُمْ تَعْمَلُونَ",
    "verse_55": "إِنَّ أَصْحَابَ الْجَنَّةِ الْيَوْمَ فِي شُغُلٍ فَاكِهُونَ",
    "verse_56": "هُمْ وَأَزْوَاجُهُمْ فِي ظِلَالٍ عَلَى الْأَرَائِكِ مُتَّكِئُونَ",
    "verse_57": "لَهُمْ فِيهَا فَاكِهَةٌ وَلَهُمْ مَا يَدَّعُونَ",
    "verse_58": "سَلَامٌ قَوْلًا مِنْ رَبٍّ رَحِيمٍ",
    "verse_59": "وَامْتَازُوا الْيَوْمَ أَيُّهَا الْمُجْرِمُونَ ۞",
    "verse_60": " أَلَمْ أَعْهَدْ إِلَيْكُمْ يَا بَنِي آدَمَ أَنْ لَا تَعْبُدُوا الشَّيْطَانَ ۖ إِنَّهُ لَكُمْ عَدُوٌّ مُبِينٌ",
    "verse_61": "وَأَنِ اعْبُدُونِي ۚ هَٰذَا صِرَاطٌ مُسْتَقِيمٌ",
    "verse_62": "وَلَقَدْ أَضَلَّ مِنْكُمْ جِبِلًّا كَثِيرًا ۖ أَفَلَمْ تَكُونُوا تَعْقِلُونَ",
    "verse_63": "هَٰذِهِ جَهَنَّمُ الَّتِي كُنْتُمْ تُوعَدُونَ",
    "verse_64": "اصْلَوْهَا الْيَوْمَ بِمَا كُنْتُمْ تَكْفُرُونَ",
    "verse_65": "الْيَوْمَ نَخْتِمُ عَلَىٰ أَفْوَاهِهِمْ وَتُكَلِّمُنَا أَيْدِيهِمْ وَتَشْهَدُ أَرْجُلُهُمْ بِمَا كَانُوا يَكْسِبُونَ",
    "verse_66": "وَلَوْ نَشَاءُ لَطَمَسْنَا عَلَىٰ أَعْيُنِهِمْ فَاسْتَبَقُوا الصِّرَاطَ فَأَنَّىٰ يُبْصِرُونَ",
    "verse_67": "وَلَوْ نَشَاءُ لَمَسَخْنَاهُمْ عَلَىٰ مَكَانَتِهِمْ فَمَا اسْتَطَاعُوا مُضِيًّا وَلَا يَرْجِعُونَ",
    "verse_68": "وَمَنْ نُعَمِّرْهُ نُنَكِّسْهُ فِي الْخَلْقِ ۖ أَفَلَا يَعْقِلُونَ",
    "verse_69": "وَمَا عَلَّمْنَاهُ الشِّعْرَ وَمَا يَنْبَغِي لَهُ ۚ إِنْ هُوَ إِلَّا ذِكْرٌ وَقُرْآنٌ مُبِينٌ",
    "verse_70": "لِيُنْذِرَ مَنْ كَانَ حَيًّا وَيَحِقَّ الْقَوْلُ عَلَى الْكَافِرِينَ",
    "verse_71": "أَوَلَمْ يَرَوْا أَنَّا خَلَقْنَا لَهُمْ مِمَّا عَمِلَتْ أَيْدِينَا أَنْعَامًا فَهُمْ لَهَا مَالِكُونَ",
    "verse_72": "وَذَلَّلْنَاهَا لَهُمْ فَمِنْهَا رَكُوبُهُمْ وَمِنْهَا يَأْكُلُونَ",
    "verse_73": "وَلَهُمْ فِيهَا مَنَافِعُ وَمَشَارِبُ ۖ أَفَلَا يَشْكُرُونَ",
    "verse_74": "وَاتَّخَذُوا مِنْ دُونِ اللَّهِ آلِهَةً لَعَلَّهُمْ يُنْصَرُونَ",
    "verse_75": "لَا يَسْتَطِيعُونَ نَصْرَهُمْ وَهُمْ لَهُمْ جُنْدٌ مُحْضَرُونَ",
    "verse_76": "فَلَا يَحْزُنْكَ قَوْلُهُمْ ۘ إِنَّا نَعْلَمُ مَا يُسِرُّونَ وَمَا يُعْلِنُونَ",
    "verse_77": "أَوَلَمْ يَرَ الْإِنْسَانُ أَنَّا خَلَقْنَاهُ مِنْ نُطْفَةٍ فَإِذَا هُوَ خَصِيمٌ مُبِينٌ",
    "verse_78": "وَضَرَبَ لَنَا مَثَلًا وَنَسِيَ خَلْقَهُ ۖ قَالَ مَنْ يُحْيِي الْعِظَامَ وَهِيَ رَمِيمٌ",
    "verse_79": "قُلْ يُحْيِيهَا الَّذِي أَنْشَأَهَا أَوَّلَ مَرَّةٍ ۖ وَهُوَ بِكُلِّ خَلْقٍ عَلِيمٌ",
    "verse_80": "الَّذِي جَعَلَ لَكُمْ مِنَ الشَّجَرِ الْأَخْضَرِ نَارًا فَإِذَا أَنْتُمْ مِنْهُ تُوقِدُونَ",
    "verse_81": "أَوَلَيْسَ الَّذِي خَلَقَ السَّمَاوَاتِ وَالْأَرْضَ بِقَادِرٍ عَلَىٰ أَنْ يَخْلُقَ مِثْلَهُمْ ۚ بَلَىٰ وَهُوَ الْخَلَّاقُ الْعَلِيمُ",
    "verse_82": "إِنَّمَا أَمْرُهُ إِذَا أَرَادَ شَيْئًا أَنْ يَقُولَ لَهُ كُنْ فَيَكُونُ",
    "verse_83": "فَسُبْحَانَ الَّذِي بِيَدِهِ مَلَكُوتُ كُلِّ شَيْءٍ وَإِلَيْهِ تُرْجَعُونَ"
  };

  final Map<String, String> versesEnglish = {
    "verse_0": "In the name of Allah, the Most Compassionate, the Most Merciful",
    "verse_1": "Ya Sin",
    "verse_2": "By the wise Quran",
    "verse_3": "Truly you are one of the messengers",
    "verse_4": "On a straight path",
    "verse_5": "A revelation from the Mighty, the Most Merciful",
    "verse_6": "That you may warn a people whose forefathers were not warned, so they are unaware",
    "verse_7": "The word has already been realized against most of them, for they do not believe",
    "verse_8": "Indeed, We have put shackles on their necks, and they reach to their chins, so they are with heads raised up",
    "verse_9": "And We have put a barrier before them and a barrier behind them and covered them, so they cannot see",
    "verse_10": "And it is the same to them whether you warn them or do not warn them - they will not believe",
    "verse_11": "You can only warn one who follows the message and fears the Most Merciful unseen. So give him good tidings of forgiveness and a generous reward",
    "verse_12": "Indeed, it is We who bring the dead to life and record what they have put forth and what they left behind, and all things We have enumerated in a clear register",
    "verse_13": "And present to them an example: the people of the city, when the messengers came to it",
    "verse_14": "When We sent to them two but they denied them, so We strengthened them with a third, and they said, 'Indeed, we are messengers to you'",
    "verse_15": "They said, 'You are not but human beings like us, and the Most Merciful has not revealed anything. You are only telling lies'",
    "verse_16": "They said, 'Our Lord knows that we are messengers to you'",
    "verse_17": "And we are not responsible except for clear notification",
    "verse_18": "They said, 'Indeed, we consider you a bad omen. If you do not desist, we will surely stone you, and there will touch you from us a painful punishment'",
    "verse_19": "They said, 'Your omen is with yourselves. Is it because you were reminded? Rather, you are a transgressing people'",
    "verse_20": "And there came from the farthest end of the city a man, running. He said, 'O my people, follow the messengers'",
    "verse_21": "Follow those who do not ask of you payment, and they are rightly guided",
    "verse_22": "And why should I not worship He who created me and to whom you will be returned?",
    "verse_23": "Should I take other than Him as deities? If the Most Merciful intends for me some harm, their intercession will not avail me at all, nor can they save me",
    "verse_24": "Indeed, I would then be in manifest error",
    "verse_25": "Indeed, I have believed in your Lord, so listen to me",
    "verse_26": "It was said, 'Enter Paradise.' He said, 'I wish my people could know'",
    "verse_27": "Of how my Lord has forgiven me and placed me among the honored",
    "verse_28": "And We did not send down upon his people after him any soldiers from the heaven, nor would We have done so",
    "verse_29": "It was not but one shout, and immediately they were extinguished",
    "verse_30": "How regretful for the servants. There did not come to them any messenger except that they used to ridicule him",
    "verse_31": "Have they not seen how many generations We destroyed before them - that they to them will not return?",
    "verse_32": "And indeed, all of them will yet be brought present before Us",
    "verse_33": "And a sign for them is the dead earth. We have brought it to life and brought forth from it grain, and from it they eat",
    "verse_34": "And We placed therein gardens of palm trees and grapevines and caused to burst forth therefrom springs",
    "verse_35": "That they may eat of His fruit. And their hands have not produced it, so will they not be grateful?",
    "verse_36": "Exalted is He who created all pairs - from what the earth grows and from themselves and from that which they do not know",
    "verse_37": "And a sign for them is the night. We remove from it the day, and immediately they are in darkness",
    "verse_38": "And the sun runs to its resting place. That is the determination of the Exalted in Might, the Knowing",
    "verse_39": "And the moon - We have determined for it phases, until it returns like the old date stalk",
    "verse_40": "It is not allowable for the sun to reach the moon, nor does the night overtake the day, but each, in an orbit, is swimming",
    "verse_41": "And a sign for them is that We carried their forefathers in a laden ship",
    "verse_42": "And We created for them the like of it in which they ride",
    "verse_43": "And if We should will, We could drown them; then no one responding to a cry would there be for them, nor would they be saved",
    "verse_44": "Except as a mercy from Us and provision for a time",
    "verse_45": "But when it is said to them, 'Beware of what is before you and what is behind you; perhaps you will receive mercy'",
    "verse_46": "And no sign comes to them from the signs of their Lord except that they turn away therefrom",
    "verse_47": "And when it is said to them, 'Spend from that which Allah has provided for you,' those who disbelieve say to those who believe, 'Should we feed one whom, if Allah had willed, He would have fed? You are not but in clear error'",
    "verse_48": "And they say, 'When is this promise, if you should be truthful?'",
    "verse_49": "They do not await except one blast which will seize them while they are disputing",
    "verse_50": "And they will not be able to make a bequest or return to their families",
    "verse_51": "And the Horn will be blown; and at once from the graves to their Lord they will hasten",
    "verse_52": "They will say, 'O woe to us! Who has raised us up from our sleeping place?' [The reply will be], 'This is what the Most Merciful had promised, and the messengers told the truth'",
    "verse_53": "It will not be but one blast, and at once they are all brought present before Us",
    "verse_54": "So today no soul will be wronged at all, and you will not be recompensed except for what you used to do",
    "verse_55": "Indeed the companions of Paradise, that Day, will be amused in joyful occupation",
    "verse_56": "They and their spouses - in shade, reclining on adorned couches",
    "verse_57": "For them therein is fruit, and for them is whatever they request",
    "verse_58": "'Peace,' a word from a Merciful Lord",
    "verse_59": "But stand apart today, you criminals",
    "verse_60": "Did I not enjoin upon you, O children of Adam, that you not worship Satan - indeed, he is to you a clear enemy",
    "verse_61": "And that you worship [only] Me? This is a straight path",
    "verse_62": "And he had already led astray from among you much of creation, so did you not use reason?",
    "verse_63": "This is the Hellfire which you were promised",
    "verse_64": "Enter it to burn today because you used to disbelieve",
    "verse_65": "That Day, We will seal over their mouths, and their hands will speak to Us, and their feet will testify about what they used to earn",
    "verse_66": "And if We willed, We could have obliterated their eyes, and they would race to [find] the path, and how could they see?",
    "verse_67": "And if We willed, We could have deformed them, [paralyzing them] in their places so they would not be able to proceed, nor could they return",
    "verse_68": "And he to whom We grant long life We reverse in creation; so will they not understand?",
    "verse_69": "And We did not give him knowledge of poetry, nor is it befitting for him. It is not but a message and a clear Quran",
    "verse_70": "To warn whoever is alive and justify the word against the disbelievers",
    "verse_71": "Do they not see that We have created for them from what Our hands have made, grazing livestock, and they are their owners?",
    "verse_72": "And We have tamed them for them, so some of them they ride, and some of them they eat",
    "verse_73": "And for them therein are benefits and drinks, so will they not be grateful?",
    "verse_74": "But they have taken besides Allah deities that perhaps they would be helped",
    "verse_75": "They are not able to help them, and they are for them soldiers in attendance",
    "verse_76": "So let not their speech grieve you. Indeed, We know what they conceal and what they declare",
    "verse_77": "Does man not consider that We created him from a sperm-drop - then at once he is a clear adversary?",
    "verse_78": "And he presents for Us an example and forgets his own creation. He says, 'Who will give life to bones while they are disintegrated?'",
    "verse_79": "Say, 'He will give them life who produced them the first time; and He is, of all creation, Knowing'",
    "verse_80": "He who made for you from the green tree, fire, and then from it you ignite",
    "verse_81": "Is not He who created the heavens and the earth Able to create the likes of them? Yes, and He is the Knowing Creator",
    "verse_82": "His command is only when He intends a thing that He says to it, 'Be,' and it is",
    "verse_83": "So exalted is He in whose hand is the realm of all things, and to Him you will be returned"
  };

  // Sections or Rukus - Corrected to use a Map<String, dynamic> for nested objects with mixed types
  final Map<String, Map<String, dynamic>> rukus = {
    "ruku_1": {"start": 1, "end": 12, "title": "Divine Revelation and Prophethood"},
    "ruku_2": {"start": 13, "end": 32, "title": "The People of the Town"},
    "ruku_3": {"start": 33, "end": 50, "title": "Signs of Allah's Power"},
    "ruku_4": {"start": 51, "end": 67, "title": "The Day of Judgment"},
    "ruku_5": {"start": 68, "end": 83, "title": "The Unity of Creation"}
  };

  // Translation titles
  final String translationTitle = "Translation";
  final String tafseerTitle = "Tafseer";

  // Features
  final String shareVerse = "Share Verse";
  final String copyVerse = "Copy Verse";
  final String addToBookmarks = "Add to Bookmarks";
  final String removeBookmark = "Remove Bookmark";

  // Descriptions
  final String surahDescription = "Surah Ya-Sin is the 36th chapter of the Quran. It is often referred to as 'The Heart of the Quran' and consists of 83 verses. The chapter begins with the Arabic letters 'Ya' and 'Sin', which are among the mysterious letters of the Quran.";
  final String virtuesOfYasin = "It is recommended to recite Surah Ya-Sin during difficult times, for the deceased, and is often read on Friday nights.";

  // Other useful strings
  final String loading = "Loading...";
  final String error = "Error loading content. Please try again.";
  final String searchHint = "Search in Surah Ya-Sin...";
  final String noResults = "No results found";
  final String settings = "Settings";
  final String fontSizeLabel = "Font Size";
  final String languageLabel = "Language";
  final String themeLabel = "Theme";
  final String darkMode = "Dark Mode";
  final String lightMode = "Light Mode";
}

class AboutScreenStrings {

  const AboutScreenStrings();

  final String AboutScreenTitle = 'About';

  final String chapterDetails = "Chapter Details";
  final String significanceAndBenefits = "Significance & Benefits";
  final String purposeOfApp = "Purpose of App";
  final String PurposeOfAppText = "This app is designed to help you read, listen, "
      "and understand Surah Yaseen with ease. "
      "Bookmark verses, listen to recitations, "
      "and explore its deep meanings in one place.";
  final String SurahNumberText = "Surah Number: ";
  final String SurahNumber = "36";
  final String TotalVersesText = "Total Verses: ";
  final String TotalVerses = "83";
  final String RukuText = "Ruku's: ";
  final String Ruku = "5";
  final String PlaceOfRevelationText = "Place of Revelation: ";
  final String PlaceOfRevelation = "Makkah";
  final String MainThemesText = "Main Themes: ";
  final String MainThemes = "Faith, resurrection";
  final String text = "";
  final String themeText = "divine signs, reward & punishment.";

  final String SandBline1 = 'Known as the "Heart of the Quran."';
  final String SandBline2 = "Reciting it brings blessings and forgiveness.";
  final String SandBline3 = "Often read in times of hardship.";
  final String SandBline4 = "Helps in seeking Allah\'s mercy.";
  final String SandBline5 = "Strengthens faith and connection with Allah.";

}

class SettingScreenStrings {

  const SettingScreenStrings();

  final String SettingScreenTitle = 'Settings';
  final String TextUnderTheImage = 'The heart of the Quran, a source of wisdom and guidance.';
}

class RukuFirstScreenStrings {
  const RukuFirstScreenStrings();

  final String TextUnderCard = 'Rukū‘ 1 affirms the Quran’s wisdom, Prophet Muhammad’s (PBUH) mission, and warns disbelievers of their spiritual blindness.';
}

class RukuSecondScreenStrings {
  const RukuSecondScreenStrings();

  final String textUnderCard = 'Rukū‘ 2 tells of a town’s messengers, a faithful believer’s plea, and the tragic rejection by its disbelieving people.';
}

class RukuThirdScreenStrings {
  const RukuThirdScreenStrings();
  final String textUnderCard = 'Rukū‘ 3 highlights God’s signs in nature, the revival of dead earth, and calls mankind to reflect with grateful hearts.';
}

class RukuFourthScreenStrings {
  const RukuFourthScreenStrings();
  final String textUnderCard = 'Rukū‘ 4 warns of the Day of Judgment, illustrates regret of sinners, and confirms the Quran’s truth and divine source.';
}

class RukuFivethScreenStrings {
  const RukuFivethScreenStrings();

  final String textUnderCard = 'Rukū‘ 5 highlights the resurrection, Allah’s power to revive the dead, and the certainty of the final return.';
}

class ListenAudioScreenString {
  const ListenAudioScreenString();

  final String Rukutitle = 'Rukū 1 Audio';
  final String Rukutitle2 = 'Rukū 2 Audio';
  final String Rukutitle3 = 'Rukū 3 Audio';
  final String Rukutitle4 = 'Rukū 4 Audio';
  final String Rukutitle5 = 'Rukū 5 Audio';
}

class ListenAudioWithTranslationScreenString{
  const ListenAudioWithTranslationScreenString();

  final String Ruku1title = 'Rukū 1 Audio With Translation';
  final String Ruku2title = 'Rukū 2 Audio With Translation';
  final String Ruku3title = 'Rukū 3 Audio With Translation';
  final String Ruku4title = 'Rukū 4 Audio With Translation';
  final String Ruku5title = 'Rukū 5 Audio With Translation';
}
