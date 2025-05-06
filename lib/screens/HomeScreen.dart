import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../widgets/TopBar/topbar.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/dialogs/exit_dialog.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import '../widgets/HomeScreen/quote_section.dart';
import '../widgets/HomeScreen/option_grid.dart';
import 'package:surah_yaseen/constants/app_assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NavigationController _navigationController = Get.find<NavigationController>();
  final ExitDialog _exitDialog = ExitDialog();

  @override
  void initState() {
    super.initState();
    // Set system UI to edge-to-edge mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await _exitDialog.showExitDialog(context);
    if (shouldExit) {
      // Exit the app safely
      Future.delayed(const Duration(milliseconds: 100), () {
        SystemNavigator.pop();
      });
      return false; // Prevent manual pop
    }
    return false; // Cancel back press
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic values based on screen dimensions
    final double paddingHorizontal = screenWidth * 0.01; // ~25 on a 360px screen
    final double imageHeight = screenHeight * 0.13; // ~100px for the Quran image
    final double imageWidth = screenWidth * 0.9; // ~80% of screen width
    final double spacing = screenHeight * 0.02; // Dynamic spacing

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.lightColorSec,
        body: Stack(
          children: [
            TopBackground(),
            SafeArea(
              child: Column(
                children: [
                  const TopBar(),
                  SizedBox(height: spacing),
                  const DividerBar(),
                  const SurahTitle(),
                  SizedBox(height: 30),
                  Image.asset(
                    AppAssets.quran,
                    height: imageHeight,
                    width: imageWidth, // Set width dynamically
                    fit: BoxFit.contain, // Ensure the image maintains its aspect ratio
                  ),
                  SizedBox(height: 10),
                  QuoteSection(),
                  OptionGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}