import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:share_plus/share_plus.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../screens/HelpScreen.dart';
import '../../screens/LanguageScreen.dart';
import '../../screens/NotificationScreen.dart';

class MenuOptionsContainer extends StatefulWidget {
  const MenuOptionsContainer({super.key});

  @override
  State<MenuOptionsContainer> createState() => _MenuOptionsContainerState();
}

class _MenuOptionsContainerState extends State<MenuOptionsContainer> {
  @override
  Widget build(BuildContext context) {
    return _buildMenuOptionsContainer();
  }

  Widget _buildMenuOptionsContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.BarColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Column(
            children: [
              _buildMenuItem(
                Icons.notifications_none,
                'notifications'.tr,
                NotificationScreen(),
                null,
              ),
              _buildMenuItem(
                Icons.language,
                'language'.tr,
                LanguageScreen(),
                null,
              ),
              _buildMenuItem(
                Icons.privacy_tip_outlined,
                'privacy_policy'.tr,
                null,
                onPrivacyPolicy,
              ),
              // Handle the Rate Us button directly here
              _buildMenuItem(Icons.star_border, 'rate_us'.tr, null, onRateUs),
              // Handle the Share button directly here
              _buildMenuItem(Icons.share_outlined, 'share'.tr, null, onShare),
              _buildMenuItem(Icons.help_outline, 'help'.tr, HelpScreen(), null),
            ],
          ),
        ),
      ),
    );
  }

  // Modify _buildMenuItem to accept an action for Rate Us or Share directly
  Widget _buildMenuItem(
    IconData icon,
    String title,
    Widget? screen,
    void Function()? onAction,
  ) {
    return GestureDetector(
      onTap: () {
        if (onAction != null) {
          onAction(); // Trigger the action directly if it's provided (Rate Us or Share)
        } else if (screen != null) {
          // Navigate to the screen if no action is provided with custom animation
          Get.to(
            () => screen,
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.PrimaryColor),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: AppColors.PrimaryColor,
                fontFamily: GoogleFonts.merriweather().fontFamily,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function for Privacy Policy - opens in in-app browser
  void onPrivacyPolicy() async {
    const String privacyPolicyUrl = 'https://v0-surah-yaseenx.vercel.app/';

    try {
      final Uri url = Uri.parse(privacyPolicyUrl);

      // Try to launch with in-app browser first
      if (await canLaunchUrl(url)) {
        try {
          await launchUrl(
            url,
            mode: LaunchMode.inAppWebView,
            webViewConfiguration: const WebViewConfiguration(
              enableJavaScript: true,
              enableDomStorage: true,
            ),
          );
        } catch (e) {
          // Fallback to external browser if in-app browser fails
          if (mounted) {
            await launchUrl(url, mode: LaunchMode.platformDefault);
          }
        }
      } else {
        // If canLaunchUrl returns false, try direct launch
        if (mounted) {
          await launchUrl(url, mode: LaunchMode.platformDefault);
        }
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                'Could not open the Privacy Policy. Please check your internet connection.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Function for Rate Us
  void onRateUs() async {
    const String playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.example.yourapp'; // Replace with your app's Play Store URL

    if (await canLaunch(playStoreUrl)) {
      await launch(playStoreUrl);
    } else {
      // Handle error if the URL can't be launched
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Could not open the Play Store.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  // Function for Share
  void onShare() {
    const String appLink =
        'https://play.google.com/store/apps/details?id=com.example.yourapp'; // Replace with your app's Play Store URL
    Share.share('Check out this amazing app: $appLink');
  }
}
