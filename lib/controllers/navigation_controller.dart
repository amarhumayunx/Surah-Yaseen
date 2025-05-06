import 'package:get/get.dart';
import 'package:surah_yaseen/screens/BookmarkScreen.dart';
import 'package:surah_yaseen/screens/RukuScreen.dart';
import 'package:surah_yaseen/screens/SettingScreen.dart';

import '../screens/HomeScreen.dart';

class NavigationController extends GetxController{
  final Rx<int> selected = 0.obs;

  final screens = [
    HomeScreen(),
    RukuScreen(),
    BookmarkScreen(),
    SettingScreen()
  ];

}