import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/widgets/BookmarkScreen/bookmark_screen_body_second.dart';

import '../../Colors/colors.dart';
import '../Topbackground/top_background.dart';



class BookmarkScreenSecond extends StatefulWidget {
  final int verseIndex;
  final int rukuNumber;

  // Define the constructor with the required named parameters
  const BookmarkScreenSecond({
    super.key,
    required this.verseIndex,
    required this.rukuNumber
  });


  @override
  State<BookmarkScreenSecond> createState() => _BookmarkScreenSecondState();
}

class _BookmarkScreenSecondState extends State<BookmarkScreenSecond> {
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
          BookmarkScreenBodySecond(),
        ],
      ),
    );
  }
}
