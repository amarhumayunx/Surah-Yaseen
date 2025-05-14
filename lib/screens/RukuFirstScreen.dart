import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/ButtonsUnderTextFirst.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/QuoteSectionFirstRuku.dart';
import 'package:surah_yaseen/widgets/RukuFirstScreen/RukuFirstCard.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../constants/app_assets.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/RukuFirstScreen/RukuFirstScreenTopBar.dart';

class RukuFirstScreen extends StatefulWidget {
  const RukuFirstScreen({super.key});

  @override
  State<RukuFirstScreen> createState() => _RukuFirstScreenState();
}

class _RukuFirstScreenState extends State<RukuFirstScreen> {
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
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  const TopBarRukuFirst(),
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SizedBox(height: 10),
                  const SurahTitle(),
                  const SizedBox(height: 90),
                  // Wrap the RukuCard with a container to set custom size for this screen
                  RukuFirstCard(
                      imagePath: AppAssets.topcornerdecor,
                      title: 'ruku_title_one'.tr,
                      verseRange: 'verse_title_one_to_twelve'.tr,
                      imageTop: -8,
                      imageLeft: 3,
                      imageWidth: 55,
                      imageHeight: 55,
                  ),
                  const SizedBox(height: 10),
                  QuoteSectionRukuFirst(),
                  SizedBox(height: 10),
                  ButtonsUnderText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
