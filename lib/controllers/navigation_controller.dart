import 'package:get/get.dart';
import 'package:surah_yaseen/screens/BookmarkScreen.dart';
import 'package:surah_yaseen/screens/RukuScreen.dart';
import 'package:surah_yaseen/screens/SettingScreen.dart';

import '../screens/HomeScreen.dart';

/// Controls bottom navigation index. GetX disposes this when route is removed.
class NavigationController extends GetxController {
  final Rx<int> selected = 0.obs;

  /// Tab content widgets; index matches [selected].
  final screens = [
    HomeScreen(),
    RukuScreen(),
    BookmarkScreen(verseIndex: 0, rukuNumber: 0,),
    SettingScreen()
  ];

}