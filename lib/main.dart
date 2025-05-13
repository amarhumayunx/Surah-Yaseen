import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:surah_yaseen/bookmark.dart';
import 'package:surah_yaseen/screens/splash_screen.dart';
import 'package:surah_yaseen/services/notification_service.dart';
import 'package:surah_yaseen/widgets/BookmarkScreen/BookmarkProvider.dart';
import 'package:surah_yaseen/widgets/FontSize/FontSizeProvider.dart';
import 'package:surah_yaseen/widgets/Language/Language.dart';

// Local Notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkAdapter());
  await Hive.openBox<Bookmark>('bookmarks');

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize NotificationService
  await NotificationService.initialize();

  // Initialize Flutter Local Notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
      translations: Languages(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en','US'),
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SurahYaseenSplashScreen(),
    );
  }
}