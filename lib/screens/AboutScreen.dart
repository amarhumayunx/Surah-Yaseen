import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surah_yaseen/widgets/AboutScreen/TitleCardAbout.dart';
import 'package:surah_yaseen/widgets/AboutScreen/infocardabout.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import '../Colors/colors.dart';
import '../constants/app_assets.dart';
import '../widgets/AboutScreen/quote_section.dart';
import '../widgets/TopBar/topbartest.dart';
import '../widgets/Topbackground/top_background.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
    final double imageHeight = screenHeight * 0.17;
    final double spacing = screenHeight * 0.02;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
        children: [
          TopBackground(),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: spacing),
                TopBarSet(),
                SizedBox(height: spacing),
                DividerBar(),
                SurahTitle(),
                TitleCardAbout(),
                SizedBox(height: spacing),
                Expanded(
                  child: Stack(
                    children: [
                      // Scrollable content
                      ListView(
                        children: [
                          SizedBox(height: spacing),
                          SvgPicture.asset(
                            AppAssets.quran,
                            height: imageHeight,
                            width: screenWidth,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: spacing),
                          QuoteSection(),
                          SizedBox(height: spacing),
                          InfoBoxCard(),
                          SizedBox(height: spacing),
                        ],
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
