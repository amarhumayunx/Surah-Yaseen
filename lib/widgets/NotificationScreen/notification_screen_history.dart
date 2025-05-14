import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHistoryManager {
  static const String _historyKey = 'notification_history';

  // Save a notification to history with verse details
  static Future<void> saveNotification({
    required String title,
    required int verseIndex,
    required int rukuNumber,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> history = prefs.getStringList(_historyKey) ?? [];
      final timestamp = DateTime.now().toString().substring(0, 19);

      // Create JSON string with all needed info for navigation
      final Map<String, dynamic> notificationData = {
        'timestamp': timestamp,
        'title': title,
        'verseIndex': verseIndex,
        'rukuNumber': rukuNumber,
      };

      // Convert to JSON string
      final String notificationJson = _encodeNotification(notificationData);

      // Add to history list (at the beginning)
      history.insert(0, notificationJson);

      // Limit history size to 100 items to prevent excessive storage use
      if (history.length > 100) {
        history.removeLast();
      }

      // Save to SharedPreferences
      await prefs.setStringList(_historyKey, history);
      debugPrint('Notification saved to history: $title');
    } catch (e) {
      debugPrint('Error saving notification to history: $e');
    }
  }

  // Get all notifications as structured data
  static Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> history = prefs.getStringList(_historyKey) ?? [];

      // Convert each JSON string to a Map
      final List<Map<String, dynamic>> notifications = history.map((jsonStr) {
        try {
          return _decodeNotification(jsonStr);
        } catch (e) {
          debugPrint('Error parsing notification: $e');
          return {
            'timestamp': 'Unknown',
            'title': 'Error: Could not parse notification',
            'verseIndex': -1,
            'rukuNumber': -1,
          };
        }
      }).toList();

      return notifications;
    } catch (e) {
      debugPrint('Error loading notification history: $e');
      return [];
    }
  }


  // Clear all notification history
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_historyKey, []);
      debugPrint('Notification history cleared');
    } catch (e) {
      debugPrint('Error clearing notification history: $e');
    }
  }

  // Helper method to encode notification data to JSON string
  static String _encodeNotification(Map<String, dynamic> notification) {
    return '${notification['timestamp']}|${notification['title']}|${notification['verseIndex']}|${notification['rukuNumber']}';
  }

  // Helper method to decode notification string back to map
  static Map<String, dynamic> _decodeNotification(String notificationStr) {
    final parts = notificationStr.split('|');
    if (parts.length >= 4) {
      // Parse the datetime
      final datetime = DateTime.parse(parts[0]);

      // Format date and time separately
      final formattedDate = '${datetime.year}-${_twoDigit(datetime.month)}-${_twoDigit(datetime.day)}';
      final formattedTime = '${_twoDigit(datetime.hour)}:${_twoDigit(datetime.minute)}';

      return {
        'date': formattedDate,
        'time': formattedTime,
        'title': 'Ruku ${parts[3]} | Verse ${parts[2]}',
        'verseIndex': int.parse(parts[2]),
        'rukuNumber': int.parse(parts[3]),
      };
    } else {
      // Fallback for corrupted data
      return {
        'date': 'Unknown',
        'time': 'Unknown',
        'title': 'Unknown Notification',
        'verseIndex': -1,
        'rukuNumber': -1,
      };
    }
  }

  // Helper method to ensure two-digit formatting
  static String _twoDigit(int n) => n.toString().padLeft(2, '0');
}