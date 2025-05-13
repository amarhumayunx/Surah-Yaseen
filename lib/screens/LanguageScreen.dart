import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Colors/colors.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/SurahTitle/surat_title.dart';
import '../widgets/TopBar/topbartest.dart';
import '../widgets/Topbackground/top_background.dart';
import '../widgets/buttons/buttons.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
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
                const SizedBox(height: 10),
                DividerBar(),
                SurahTitle(),
                const SizedBox(height: 100),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'select_language'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        RukuStyleButton(
                          title: 'English',
                          onPressed: () {
                            Get.updateLocale(const Locale('en', 'US'));
                            Get.snackbar(
                              'Surah Yaseen',
                              '',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.black12,
                              colorText: Colors.white,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              borderRadius: 40,
                              snackStyle: SnackStyle.FLOATING,
                              overlayColor: Colors.black.withOpacity(0.2),
                              messageText: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/illustrations/surahicon.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 2),
                                          const Text(
                                            'App language has been set to English',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        RukuStyleButton(
                          title: 'اردو',
                          onPressed: () {
                            Get.updateLocale(const Locale('ur', 'PK'));
                            Get.snackbar(
                              'سورۃ یٰسین',
                              '',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.black12,
                              colorText: Colors.white,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              borderRadius: 40,
                              snackStyle: SnackStyle.FLOATING,
                              overlayColor: Colors.black.withOpacity(0.2),
                              messageText: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/illustrations/surahicon.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 2),
                                          const Text(
                                            'ایپ کی زبان اردو پر سیٹ کر دی گئی ہے',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
