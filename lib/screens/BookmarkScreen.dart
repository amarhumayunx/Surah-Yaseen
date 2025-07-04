import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Colors/colors.dart';
import 'package:surah_yaseen/widgets/BookmarkScreen/bookmark_screen_body.dart';

import '../widgets/Topbackground/top_background.dart';


class BookmarkScreen extends StatefulWidget {
  final int verseIndex;
  final int rukuNumber;

  // Define the constructor with the required named parameters
  const BookmarkScreen({
    super.key,
    required this.verseIndex,
    required this.rukuNumber
  });


  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
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
        children: const [
          TopBackground(),
          BookmarkScreenBody(),
        ],
      ),
    );
  }
}
