import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:surah_yaseen/bookmark.dart';
import 'package:surah_yaseen/screens/loading_screen.dart';
import 'package:surah_yaseen/services/notification_service.dart';
import 'package:surah_yaseen/services/verse_navigation_service.dart';
import 'package:surah_yaseen/widgets/BookmarkScreen/BookmarkProvider.dart';
import 'package:surah_yaseen/widgets/FontSize/FontSizeProvider.dart';
import 'package:surah_yaseen/widgets/Language/Language.dart';
import 'package:surah_yaseen/services/app_open_ad_manager.dart';
import 'package:surah_yaseen/services/interstitial_ad_manager.dart';
import 'package:surah_yaseen/services/analytics_service.dart';

// Local Notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Analytics Service
  AnalyticsService.initialize();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkAdapter());
  await Hive.openBox<Bookmark>('bookmarks');

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize NotificationService
  await NotificationService.initialize();
  
  // Set up notification tap handler
  NotificationService.onNotificationTapped = (String? payload) {
    // Handle notification tap - navigate to the verse
    VerseNavigationService.handleNotificationPayload(payload);
  };

  // Initialize Flutter Local Notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Initialize Google Mobile Ads SDK
  await MobileAds.instance.initialize();
  
  // Test mode for ads - enabled for testing (not deploying to production yet)
  // TODO: Remove test device IDs when ready to deploy to production
  // For production, remove or comment out the testDeviceIds line
  final RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: [
      '14C103ADD23A29FFD26DE6E985FD67DF', // Test device ID from logs
      // Add more test device IDs as needed
    ],
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  // App Open Ad will be loaded in LoadingScreen
  // Don't load here to avoid blocking app startup
  
  // Initialize Interstitial Ad Manager (fire and forget - async)
  InterstitialAdManager.instance.initialize().catchError((error) {
    debugPrint('Error initializing Interstitial Ad Manager: $error');
  });

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


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    InterstitialAdManager.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final appOpenAdManager = AppOpenAdManager.instance;
    final interstitialAdManager = InterstitialAdManager.instance;

    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground - load ad first, then show if available
        // Load ad for future use (this will also retry if previous load failed)
        appOpenAdManager.loadAd();
        // Show ad if already available (from previous load)
        // Small delay to ensure app is fully resumed
        Future.delayed(const Duration(milliseconds: 500), () {
          appOpenAdManager.showAdIfAvailable();
        });
        // Resume interstitial ad manager (doesn't reset timer)
        interstitialAdManager.resume();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App went to background or is closing
        break;
    }
  }

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
      home: const LoadingScreen(),
    );
  }
}