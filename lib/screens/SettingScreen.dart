import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/widgets/SettingScreen/MenuOptionsContainer.dart';
import 'package:surah_yaseen/widgets/SettingScreen/titlecardsetting.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/TopBar/topbartest.dart';
import '../Colors/colors.dart';
import '../widgets/FontSize/FontSizeContainer.dart';
import '../widgets/Topbackground/top_background.dart';
import '../widgets/Ads/native_style_ad_widget.dart';
import '../constants/ad_unit_ids.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double paddingHorizontal = screenWidth * 0.01;
    final double imageHeight = screenHeight * 0.15;
    final double spacing = screenHeight * 0.02;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
        children: [
          TopBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                TopBarSet(),
                SizedBox(height: spacing),
                DividerBar(),
                SurahTitle(),
                TitleCardSetting(),

                Expanded(
                  child: Stack(
                    children: [
                      // Scrollable content
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            FontSizeContainer(),
                            SizedBox(height: spacing),
                            const NativeStyleAdWidget(
                              screenType: AdScreenType.settings,
                              minHeight: 50,
                            ),
                            SizedBox(height: spacing),
                            MenuOptionsContainer(),
                            SizedBox(height: spacing),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.lightColorSec,
                                  AppColors.lightColorSec.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
