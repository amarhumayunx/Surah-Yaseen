import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:surah_yaseen/Colors/colors.dart';

import '../../screens/HelpScreen.dart';
import '../../screens/LanguageScreen.dart';
import '../../screens/NotificationScreen.dart';
import '../../screens/PrivacyPolicyScreen.dart';
import '../../screens/RateUsScreen.dart';
import '../../screens/ShareScreen.dart';
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
          borderRadius: BorderRadius.circular(15),
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              _buildMenuItem(Icons.notifications_none, 'Notifications', NotificationScreen()),
              _buildMenuItem(Icons.language, 'Language', LanguageScreen()),
              _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy Policy', PrivacyPolicyScreen()),
              _buildMenuItem(Icons.star_border, 'Rate Us', RateUsScreen()),
              _buildMenuItem(Icons.share_outlined, 'Share', ShareScreen()),
              _buildMenuItem(Icons.help_outline, 'Help', HelpScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Widget screen) {
    return GestureDetector(
      onTap: () {
        // Use GetX for navigation
        Get.to(() => screen); // Get.to() replaces Navigator.push()
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.PrimaryColor),
            SizedBox(width: 12),
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
}
