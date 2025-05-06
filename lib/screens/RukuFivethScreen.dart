import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../Colors/colors.dart';
import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/RukuFivethScreen/ButtonsUnderTextFive.dart';
import '../widgets/RukuFivethScreen/QuoteSectionFiveRuku.dart';
import '../widgets/RukuFivethScreen/RukuFiveCard.dart';
import '../widgets/RukuFivethScreen/RukuFiveScreenTopBar.dart';

class RukuFiveScreen extends StatefulWidget {
  const RukuFiveScreen({super.key});

  @override
  State<RukuFiveScreen> createState() => _RukuFirstScreenState();
}

class _RukuFirstScreenState extends State<RukuFiveScreen> {
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
                  const TopBarRukuFive(),
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SizedBox(height: 10),
                  const SurahTitle(),
                  const SizedBox(height: 80),
                  // Wrap the RukuCard with a container to set custom size for this screen
                  RukuFiveCard(
                    imagePath: AppAssets.topcornerdecor,
                    title: AppStrings.rukuStrings.rukufiveth,
                    verseRange: AppStrings.rukuStrings.versetitlesixtheighttoeightythree,
                    imageTop: -8,
                    imageLeft: 3,
                    imageWidth: 55,
                    imageHeight: 55,
                  ),
                  const SizedBox(height: 10),
                  QuoteSectionRukuFive(),
                  SizedBox(height: 10),
                  ButtonsUnderTextRukuFive(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
