import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surah_yaseen/widgets/AboutScreen/TitleCardAbout.dart';
import 'package:surah_yaseen/widgets/AboutScreen/infocardabout.dart';
import 'package:surah_yaseen/widgets/AboutScreen/top_bar_about.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import '../Colors/colors.dart';
import '../constants/app_assets.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/AboutScreen/quote_section.dart';
import '../widgets/Topbackground/top_background.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final NavigationController _navigationController = Get.find<NavigationController>();

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
            child: Column(
              children: [
                SizedBox(height: 10,),
                TopBarAbout(),
                SizedBox(height: 5,),
                DividerBar(),
                SurahTitle(),
                TitleCardAbout(),
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Image(
                          image: AssetImage(AppAssets.quran),
                          height: 150,
                        ),
                      ),
                      SizedBox(height: 10),
                      QuoteSection(),
                      InfoBoxCard(), // Now this will work correctly because we removed the Expanded from InfoBoxCard
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