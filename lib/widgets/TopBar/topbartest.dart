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

    final double fontSizeTitle = screenWidth * 0.06;
    final double fontSizeSubtitle = screenWidth * 0.04;
    final double iconSize = screenWidth * 0.09;
    final double horizontalPadding = screenWidth * 0.05;
    final BoxFit iconFit = BoxFit.contain;

    final bool canPop = Navigator.canPop(context);

    bool showNotificationIcon = false;

    if (canPop) {
      showNotificationIcon = false;
    } else {
      try {
        final navigationController = Get.find<NavigationController>();
        final currentIndex = navigationController.selected.value;
        final isNavBarScreen = currentIndex >= 0 && currentIndex <= 3;

        if (isNavBarScreen) {
          showNotificationIcon = true;
        } else {
          showNotificationIcon = false;
        }
      } catch (e) {
        showNotificationIcon = false;
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon:
                    Directionality.of(context) == TextDirection.rtl
                        ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(3.1416),
                          child: SvgPicture.asset(
                            AppAssets.backarrow,
                            fit: iconFit,
                          ),
                        )
                        : SvgPicture.asset(AppAssets.backarrow, fit: iconFit),
                onPressed: () {
                  Get.back();
                },
              ),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 0),
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
