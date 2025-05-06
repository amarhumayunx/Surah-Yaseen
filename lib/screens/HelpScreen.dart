// help_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Colors/colors.dart';
import '../widgets/AboutScreen/top_bar_about.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/SurahTitle/surat_title.dart';
import '../widgets/Topbackground/top_background.dart';






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
                TopBarAbout(),
                SizedBox(height: 10,),
                SizedBox(height: 5,),
                DividerBar(),
                SurahTitle(),
                SizedBox(height: 200),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Help & Support",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "If you need any assistance, please contact us at support@example.com.",
                          style: TextStyle(fontSize: 16,color: AppColors.whiteColor),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "FAQ:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.whiteColor),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "1. How to use the app?\n- Simply open the app and follow the instructions.",
                          style: TextStyle(fontSize: 16,
                          color: AppColors.whiteColor),
                        ),
                        // Add more FAQs if needed
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}