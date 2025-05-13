import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../constants/app_assets.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/RukuFourthScreen/ButtonsUnderTextFourth.dart';
import '../widgets/RukuFourthScreen/QuoteSectionRukuFourth.dart';
import '../widgets/RukuFourthScreen/RukuFourthCard.dart';
import '../widgets/RukuFourthScreen/RukuFourthScreenTopBar.dart';

class RukuFourthScreen extends StatefulWidget {
  const RukuFourthScreen({super.key});

  @override
  State<RukuFourthScreen> createState() => _RukuFirstScreenState();
}

class _RukuFirstScreenState extends State<RukuFourthScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  const TopBarRukuFourth(),
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SizedBox(height: 10),
                  const SurahTitle(),
                  const SizedBox(height: 80),
                  // Wrap the RukuCard with a container to set custom size for this screen
                  RukuFourthCard(
                    imagePath: AppAssets.topcornerdecor,
                    title: 'ruku_four'.tr,
                    verseRange: 'verse_title_fiftyone_to_sixtyseven'.tr,
                    imageTop: -8,
                    imageLeft: 3,
                    imageWidth: 55,
                    imageHeight: 55,
                  ),
                  const SizedBox(height: 10),
                  QuoteSectionRukuFourth(),
                  SizedBox(height: 10),
                  ButtonsUnderTextFourthRuku(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
