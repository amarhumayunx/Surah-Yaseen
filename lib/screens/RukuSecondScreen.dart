import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/QuoteSectionSecondRuku.dart';
import 'package:surah_yaseen/widgets/RukuSecondScreen/RukuSecondScreenTopBar.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';

import '../constants/app_assets.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/RukuSecondScreen/ButtonsUndertextSecond.dart';
import '../widgets/RukuSecondScreen/RukuSecondCard.dart';
import '../widgets/SurahTitle/surat_title.dart';

class RukuSecondScreen extends StatefulWidget {
  const RukuSecondScreen({super.key});

  @override
  State<RukuSecondScreen> createState() => _RukuSecondScreenState();
}

class _RukuSecondScreenState extends State<RukuSecondScreen> {

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
              child: Padding(padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20
              ),
              child: Column(
                children: [
                  const TopBarRukuSecond(),
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SizedBox(height: 10),
                  const SurahTitle(),
                  const SizedBox(height: 80),

                  RukuSecondCard(
                    imagePath: AppAssets.topcornerdecor,
                    title: 'ruku_two'.tr,
                    verseRange: 'verse_title_thirteen_to_thirtytwo'.tr,
                    imageTop: -8,
                    imageLeft: 3,
                    imageWidth: 55,
                    imageHeight: 55,
                  ),
                  SizedBox(height: 10),
                  QuoteSectionRukuSecond(),
                  SizedBox(height: 10),
                  ButtonsUnderTextRukuSecondScreen(),

                ],
              ),
              ))
          ]
      ),
    );
  }
}
