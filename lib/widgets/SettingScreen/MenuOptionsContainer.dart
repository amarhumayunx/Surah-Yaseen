import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:share_plus/share_plus.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';
import '../../screens/HelpScreen.dart';
import '../../screens/LanguageScreen.dart';
import '../../screens/NotificationScreen.dart';
import '../../screens/PrivacyPolicyWebViewScreen.dart';

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

  // Function for Privacy Policy - opens in custom WebView with floating back button
  void onPrivacyPolicy() {
    Get.to(
      () => PrivacyPolicyWebViewScreen(url: AppConstants.privacyPolicyUrl),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Function for Rate Us
  void onRateUs() async {
    final uri = Uri.parse(AppConstants.playStoreUrl);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        _showPlayStoreError();
      }
    } catch (_) {
      if (mounted) _showPlayStoreError();
    }
  }

  void _showPlayStoreError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text('Could not open the Play Store.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // Function for Share
  void onShare() {
    Share.share('Check out this amazing app: ${AppConstants.playStoreUrl}');
  }
}
