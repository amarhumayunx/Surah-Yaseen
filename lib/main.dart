// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:surah_yaseen/bookmark.dart';
import 'package:surah_yaseen/screens/splash_screen.dart';
import 'package:surah_yaseen/widgets/BookmarkScreen/BookmarkProvider.dart';
import 'package:surah_yaseen/widgets/FontSize/FontSizeProvider.dart';

void main() async {
  // Initialize Hive before running the app
  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkAdapter());
  await Hive.openBox<Bookmark>('bookmarks');  // Open the bookmarks box

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookmarkProvider()),
        ChangeNotifierProvider(create: (context) => FontSizeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Surah Yaseen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SurahYaseenSplashScreen(),
    );
  }
}