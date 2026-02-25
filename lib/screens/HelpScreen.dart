// help_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Colors/colors.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/SurahTitle/surat_title.dart';
import '../widgets/TopBar/topbartest.dart';
import '../widgets/Topbackground/top_background.dart';
import '../widgets/Ads/native_style_ad_widget.dart';
import '../constants/ad_unit_ids.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
                const SizedBox(height: 10),
                const SizedBox(height: 5),
                DividerBar(),
                SurahTitle(),
                // Scrollable content below the fixed header widgets
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 200),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'help_support'.tr,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'assistance_text'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'faq'.tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'faq_1'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                // Add more FAQs if needed
                              ],
                            ),
                          ),
                        ),
                        // Native-style ad at the bottom
                        const NativeStyleAdWidget(
                          screenType: AdScreenType.help,
                          minHeight: 50,
                        ),
                      ],
                    ),
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
