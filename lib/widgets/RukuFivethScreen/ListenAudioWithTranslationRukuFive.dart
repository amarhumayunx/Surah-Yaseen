import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import 'package:surah_yaseen/widgets/Dividerbar/dividerbar.dart';
import 'package:surah_yaseen/widgets/ListenAudioWithTranslation/ListenAudioWithTranslastionScreenTopbar.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';

import 'ListenAudioWithTranslationRukuFiveAudioPlayer.dart';

class ListenAudioWithTranslationRukuFive extends StatefulWidget {
  const ListenAudioWithTranslationRukuFive({super.key});

  @override
  State<ListenAudioWithTranslationRukuFive> createState() => _ListenAudioWithTranslationState();
}

class _ListenAudioWithTranslationState extends State<ListenAudioWithTranslationRukuFive> {

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
          children: [
            const TopBackground(),
            SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  child: Column(
                      children: const [
                        TopBarListenAudioWithTranslationScreen(),
                        SizedBox(height: 20,),
                        DividerBar(),
                        SurahTitle(),
                        SizedBox(height: 300,),
                        ListenAudioWithTranslationRukuFiveAudioPlayer(),

                      ]
                  ),
                ))
          ]
      ),
    );
  }
}
