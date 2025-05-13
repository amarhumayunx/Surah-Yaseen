import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Colors/colors.dart'; // Adjust import path as needed
import '../widgets/TopBar/topbartest.dart'; // Adjust import path as needed
import '../widgets/Dividerbar/dividerbar.dart'; // Adjust import path as needed
import '../widgets/Topbackground/top_background.dart'; // Adjust import path as needed

class VerseScreen extends StatefulWidget {
  final int verseIndex;
  final int rukuNumber;
  final String arabicText;

  const VerseScreen({
    Key? key,
    required this.verseIndex,
    required this.rukuNumber,
    required this.arabicText,
  }) : super(key: key);

  @override
  _VerseScreenState createState() => _VerseScreenState();
}

class _VerseScreenState extends State<VerseScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Create scroll controller
    _scrollController = ScrollController();

    // Set up system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
        children: [
          // Top background
          TopBackground(),

          // Safe Area to prevent overlap with system UI
          SafeArea(
            child: Column(
              children: [
                // Top bar
                TopBarSet(),

                // Divider
                DividerBar(),

                // Verse Details
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Verse Details Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.PrimaryColor,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Verse Information
                                Text(
                                  'Ruku ${widget.rukuNumber} | Verse ${widget.verseIndex}',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12),

                                // Arabic Text
                                Text(
                                  widget.arabicText,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                // Action Buttons
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Bookmark Button
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // Implement bookmark functionality
                                        // You might want to use your existing BookmarkProvider
                                      },
                                      icon: Icon(Icons.bookmark_add),
                                      label: Text('Bookmark'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.PrimaryColor,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),

                                    // Share Button
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // Implement share functionality
                                      },
                                      icon: Icon(Icons.share),
                                      label: Text('Share'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.PrimaryColor,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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