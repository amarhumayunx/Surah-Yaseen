import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this package

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'bookmark_channel_id';
  static const String _channelName = 'Bookmarks';
  static const String _channelDescription =
      'Notifies when a verse is bookmarked';

  // Callback function to handle notification taps
  static Function(String? payload)? onNotificationTapped;

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
        // Handle notification tap via callback
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
      
      // For Android 12 and higher (SDK 31+), request exact alarm permission
      // This is required for scheduling exact alarms (notifications)
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
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
    required int verseIndex,
    required int rukuNumber,
  }) async {
    // Debug print to verify the method is called
    debugPrint('Showing notification for: $verseTitle (Verse $verseIndex, Ruku $rukuNumber)');

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
      // Use a unique ID for each notification
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

    // Use a random ID to prevent notification overrides
    final int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // Create payload with verseIndex and rukuNumber: format "verseIndex|rukuNumber"
    final String payload = '$verseIndex|$rukuNumber';

    // Ensure the notification has a valid title and body
    await _plugin.show(
      notificationId, // Unique Notification ID
      'Verse Bookmarked', // Title of the notification
      '$verseTitle has been saved.', // Body of the notification
      platformDetails,
      payload: payload, // Payload with verseIndex and rukuNumber
    );

    debugPrint('Notification sent with ID: $notificationId, payload: $payload');
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