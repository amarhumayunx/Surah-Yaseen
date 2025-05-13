import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Colors/colors.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/SurahTitle/surat_title.dart';
import '../widgets/TopBar/topbartest.dart';
import '../widgets/Topbackground/top_background.dart';


class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

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
                TopBarSet(),
                SizedBox(height: 10,),
                SizedBox(height: 5,),
                DividerBar(),
                SurahTitle(),
                SizedBox(height: 200),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'privacy_policy'.tr,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'privacy_line'.tr,
                            style: TextStyle(fontSize: 16,color: AppColors.whiteColor),
                          ),
                        ),
                        // Add more privacy policy details here
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