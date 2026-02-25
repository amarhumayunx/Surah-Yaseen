import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surah_yaseen/widgets/TopBar/topbartest.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../widgets/TopBar/topbar.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import '../widgets/HomeScreen/quote_section.dart';
import '../widgets/HomeScreen/option_grid.dart';
import 'package:surah_yaseen/constants/app_assets.dart';
import '../widgets/Ads/native_style_ad_widget.dart';
import '../constants/ad_unit_ids.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                const TopBarSet(),
                SizedBox(height: spacing),
                const DividerBar(),
                const SurahTitle(),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontal,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: spacing),
                        SvgPicture.asset(
                          AppAssets.quran,
                          height: imageHeight,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: spacing),
                        QuoteSection(),

                        // ✅ Expanded with Stack for fade effect
                        Expanded(
                          child: Stack(
                            children: [
                              // Scrollable content
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    SizedBox(height: 12),
                                    OptionGrid(),
                                    SizedBox(height: spacing),
                                    const NativeStyleAdWidget(
                                      screenType: AdScreenType.home,
                                      minHeight: 60,
                                    ),
                                    SizedBox(height: 100),
                                  ],
                                ),
                              ),

                              // ✅ Top fade effect
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
                                          AppColors.lightColorSec.withOpacity(
                                            0.0,
                                          ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
