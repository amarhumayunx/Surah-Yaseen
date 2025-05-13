import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surah_yaseen/widgets/TopBar/topbartest.dart';

import '../Colors/colors.dart';
import '../services/notification_service.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/NotificationScreen/notification_screen_history.dart';
import '../widgets/SurahTitle/surat_title.dart';
import '../widgets/Topbackground/top_background.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> notificationHistory = [];
  bool isNotificationsEnabled = false;
  bool isLoading = true;
  bool isHistoryAlreadyCleared = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    // Load notification history and check if notifications are enabled
    _loadNotificationHistory();
    _checkNotificationsStatus();
  }

  Future<void> _loadNotificationHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('notification_history') ?? [];

      setState(() {
        notificationHistory = history;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading notification history: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkNotificationsStatus() async {
    try {
      await NotificationService.initialize();

      final enabled = await NotificationService.areNotificationsEnabled();
      setState(() {
        isNotificationsEnabled = enabled;
      });
    } catch (e) {
      debugPrint('Error checking notification status: $e');
    }
  }

  Future<void> _clearNotificationHistory() async {
    try {
      // Check if history is already cleared
      final prefs = await SharedPreferences.getInstance();
      final currentHistory = prefs.getStringList('notification_history') ?? [];

      if (currentHistory.isEmpty) {
        // If history is already empty, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('notification_history_already_cleared'.tr)),
        );
        return;
      }

      // Clear the history
      await prefs.setStringList('notification_history', []);

      setState(() {
        notificationHistory = [];
        isHistoryAlreadyCleared = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('notification_history_cleared'.tr)),
      );
    } catch (e) {
      debugPrint('Error clearing notification history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
        children: [
          TopBackground(),
          SafeArea(
            child: Column(
              children: [
                TopBarSet(),
                SizedBox(height: 10,),
                DividerBar(),
                SurahTitle(),
                SizedBox(height: 80,),

                // Notification status and buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'notification_status'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isNotificationsEnabled
                              ? AppColors.PrimaryColor
                              : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isNotificationsEnabled ? 'enabled'.tr : 'disabled'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Test Notification Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _clearNotificationHistory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.PrimaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('clear'.tr),
                        ),
                      ),
                    ],
                  ),
                ),

                // Notification History Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.history, color: AppColors.whiteColor),
                      SizedBox(width: 8),
                      Text(
                        'notification_history'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Notification History List
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: NotificationHistoryManager.getNotificationHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'no_notifications'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.whiteColor.withOpacity(0.7),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final notification = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              //NotificationHistoryManager.navigateFromNotification(notification);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.PrimaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.notifications,
                                    color: AppColors.PrimaryColor,
                                    size: 30,
                                  ),
                                ),
                                title: Text(
                                  notification['title'] ?? 'Unknown Notification',
                                  style: TextStyle(
                                    color: AppColors.PrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    Text(
                                      '${notification['date']} | ${notification['time']}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}