import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import '../Colors/colors.dart';
import '../constants/app_assets.dart';
import '../controllers/navigation_controller.dart';

/// Navigation style types based on device behavior
enum NavigationType {
  gestureNavigation,
  buttonNavigation,
  mixed,
}

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  NavigationType navigationType = NavigationType.buttonNavigation;
  double bottomPadding = 24.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _detectSystemNavigationBar();
  }

  void _detectSystemNavigationBar() {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewPadding.bottom;

    // Always set to gesture navigation to match Android gesture style
    navigationType = NavigationType.gestureNavigation;

    // Platform-specific adjustments
    if (Platform.isAndroid) {
      if (bottomInset > 0) {
        // Definitely gesture navigation
        bottomPadding = 8.0; // Reduced padding to match Android gesture nav
      } else {
        // Use gesture navigation styling even for button navigation
        bottomPadding = 16.0;
      }
    } else if (Platform.isIOS) {
      if (bottomInset > 20) {
        // iPhone with notch
        bottomPadding = 12.0;
      } else {
        // iPhone without notch
        bottomPadding = 8.0;
      }
    } else {
      // Other platforms
      bottomPadding = 16.0;
    }

    setState(() {}); // Trigger a rebuild once calculated
  }

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(NavigationController());
    final mediaQuery = MediaQuery.of(context);
    final safeAreaBottom = mediaQuery.padding.bottom;

    return WillPopScope(
      onWillPop: () async {
        if (navigationController.selected.value != 0) {
          navigationController.selected.value = 0;
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Obx(() =>
        navigationController.screens[navigationController.selected.value]),
        extendBody: true,
        backgroundColor: AppColors.lightColorSec,
        bottomNavigationBar: Obx(() =>
            _buildBottomNavigation(navigationController, safeAreaBottom)),
      ),
    );
  }

  Widget _buildBottomNavigation(
      NavigationController controller, double safeAreaBottom) {
    // Using a consistent height that matches Android gesture navigation style
    final double navBarHeight = 65.0;

    // Calculate bottom margin - always use gesture-like spacing
    final double bottomMargin = bottomPadding + safeAreaBottom;

    return Container(
      margin: EdgeInsets.only(
        bottom: bottomMargin,
        left: 16,
        right: 16,
      ),
      height: navBarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              index: 0,
              assetPath: AppAssets.homeiconnavbar_svg,
              controller: controller,
            ),
            _buildNavItem(
              index: 1,
              assetPath: AppAssets.ruku_svg,
              controller: controller,
            ),
            _buildNavItem(
              index: 2,
              assetPath: AppAssets.bookmark_svg,
              controller: controller,
            ),
            _buildNavItem(
              index: 3,
              assetPath: AppAssets.setting_svg,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String assetPath,
    required NavigationController controller,
  }) {
    final isSelected = controller.selected.value == index;

    // Using a consistent size for all navigation modes to match gesture style
    const double iconSize = 22;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selected.value = index,
        behavior: HitTestBehavior.opaque, // Improves tap area
        child: Center(
          child: Container(
            width: 65, // Slightly smaller for gesture nav style
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: isSelected
                ? BoxDecoration(
              color: AppColors.fontColor,
              borderRadius: BorderRadius.circular(18),
            )
                : null,
            child: SvgPicture.asset(
              assetPath,
              height: iconSize,
              width: iconSize + 2,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : AppColors.fontColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}