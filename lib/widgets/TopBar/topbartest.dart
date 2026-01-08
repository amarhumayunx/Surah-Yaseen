import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import '../../constants/app_assets.dart';
import '../../screens/NotificationScreen.dart';
import '../../screens/AboutScreen.dart';
import '../../controllers/navigation_controller.dart';

class TopBarSet extends StatelessWidget {
  const TopBarSet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic font sizes and icon sizes
    final double fontSizeTitle = screenWidth * 0.06; // ~24 on a 400px screen
    final double fontSizeSubtitle = screenWidth * 0.04; // ~16 on a 400px screen
    final double iconSize = screenWidth * 0.09; // ~40 for a standard screen width

    // Adjusting padding based on screen size
    final double horizontalPadding = screenWidth * 0.05;
    final BoxFit iconFit = BoxFit.contain;

    // Check if we can pop - GetX navigation uses Navigator under the hood
    // When navigating from grid using Get.to(), Navigator.canPop() will return true
    final bool canPop = Navigator.canPop(context);
    
    // Show notification icon only if we can't pop AND NavigationController exists (navigation bar screen)
    // Otherwise show back arrow (when navigated from grid or other screens)
    bool showNotificationIcon = false;
    
    if (canPop) {
      // Can pop - definitely navigated from somewhere (like from home grid), show back arrow
      showNotificationIcon = false;
    } else {
      // Can't pop - check if we're in a navigation bar screen context
      // When accessed via navigation bar, screens are displayed within NavigationMenu's Scaffold
      // When accessed via Get.to(), they have their own route and canPop would be true
      try {
        final navigationController = Get.find<NavigationController>();
        // Check if current screen is one of the navigation bar screens
        // Navigation bar screens: HomeScreen (index 0), RukuScreen (index 1), 
        // BookmarkScreen (index 2), SettingScreen (index 3)
        final currentIndex = navigationController.selected.value;
        final isNavBarScreen = currentIndex >= 0 && currentIndex <= 3;
        
        if (isNavBarScreen) {
          // We're in a navigation bar screen accessed via navigation bar
          showNotificationIcon = true;
        } else {
          // Not a navigation bar screen, show back arrow
          showNotificationIcon = false;
        }
      } catch (e) {
        // NavigationController not found - not in navigation bar context, show back arrow
        showNotificationIcon = false;
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Show notification icon if navigation bar screen, otherwise show back arrow
          showNotificationIcon
              ? GestureDetector(
                  onTap: () {
                    Get.to(() => NotificationScreen());
                  },
                  child: Icon(
                    Icons.notifications_none_outlined,
                    color: AppColors.SecondaryColor,
                    size: iconSize,
                  ),
                )
              : IconButton(
                  icon: Directionality.of(context) == TextDirection.rtl
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(3.1416), // Flip horizontally (180°)
                          child: SvgPicture.asset(
                            AppAssets.backarrow,
                            fit: iconFit,
                          ),
                        )
                      : SvgPicture.asset(
                          AppAssets.backarrow,
                          fit: iconFit,
                        ),
                  onPressed: () {
                    // Use GetX back navigation (works with Get.to() navigation)
                    Get.back();
                  },
                ),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 0), // Adjust padding for better alignment
                child: Column(
                  children: [
                    Text(
                      'app_name'.tr,
                      style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                        color: AppColors.SecondaryColor,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                      ),
                    ),
                    Text(
                      'surat_name'.tr,
                      style: TextStyle(
                        fontSize: fontSizeSubtitle,
                        color: AppColors.SecondaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right side icon - show info icon if navigation bar screen, otherwise empty space
          showNotificationIcon
              ? GestureDetector(
                  onTap: () {
                    Get.to(() => AboutScreen());
                  },
                  child: Icon(
                    Icons.info_outline,
                    size: iconSize,
                    color: AppColors.SecondaryColor,
                  ),
                )
              : SizedBox(width: 48),
        ],
      ),
    );
  }
}
