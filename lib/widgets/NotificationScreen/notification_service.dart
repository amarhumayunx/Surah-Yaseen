import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this package

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'bookmark_channel_id';
  static const String _channelName = 'Bookmarks';
  static const String _channelDescription =
      'Notifies when a verse is bookmarked';
  static void Function(String? payload)? onNotificationTapped;


  static Future<void> initialize() async {
    // Request notification permissions first
    await _requestPermissions();

    // Initialize with sound and icon
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize with callback for handling notification taps
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
        if (onNotificationTapped != null) {
          onNotificationTapped!(response.payload);
        }
      },
    );


    // Create notification channel
    await _createNotificationChannel();
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      // For Android 13 and higher (SDK 33+), explicitly request notification permission
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }
    }
  }

  static Future<void> _createNotificationChannel() async {
    if (Platform.isAndroid) {
      final AndroidNotificationChannel channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high, // Make sure it's high
        enableLights: true,
        enableVibration: true,
        playSound: true,
        showBadge: true,
      );

      // Register the channel with the plugin
      await _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  static Future<void> showBookmarkNotification(
      String verseTitle, {
        int? verseIndex,
        int? rukuNumber,
      }) async {
    debugPrint('Showing notification for: $verseTitle');

    // Construct a string payload with all needed data
    final String payload = '$verseTitle|$verseIndex|$rukuNumber';

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
      icon: '@mipmap/ic_launcher',
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final int notificationId =
    DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await _plugin.show(
      notificationId,
      Get.locale?.languageCode == 'ur'
          ? 'آیت محفوظ کر دی گئی'
          : 'Verse Bookmarked',
      Get.locale?.languageCode == 'ur'
          ? '$verseTitle کو محفوظ کر لیا گیا ہے۔'
          : '$verseTitle has been saved.',
      platformDetails,
      payload: payload,
    );


    debugPrint('Notification sent with ID: $notificationId');
  }


  // Helper method to check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final bool? areEnabled = await _plugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      return areEnabled ?? false;
    }
    return true; // Default for iOS
  }
}