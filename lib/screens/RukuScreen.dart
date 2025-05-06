import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Colors/colors.dart';
import 'package:surah_yaseen/widgets/RukuScreen/ruku_screen_body.dart';

import '../widgets/Topbackground/top_background.dart';

class RukuScreen extends StatefulWidget {
  const RukuScreen({super.key});

  @override
  State<RukuScreen> createState() => _RukuScreenState();
}

class _RukuScreenState extends State<RukuScreen> {


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
          RukuScreenBody(),
        ],
      ),
    );
  }
}
