import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/widgets/ReadScreen/ReadScreenTopBar.dart';
import 'package:surah_yaseen/widgets/RukuThirdScreen/VersePageContainerRukuThird.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../../Colors/colors.dart';
import '../Dividerbar/dividerbar.dart';

class RukuThirdReadScreen extends StatefulWidget {
  const RukuThirdReadScreen({super.key});

  @override
  State<RukuThirdReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<RukuThirdReadScreen> {

  final int firstVerseIndex = 32; // verse 13
  final int lastVerseIndex = 50;

  int _currentPage = 1;
  int _totalPages = 5; // 4 verses per page
  int _totalPageDialogBox = 3; // 6 verses per page
  bool _isFullScreen = false;

  void toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

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
                horizontal: 24,
                vertical: 16,
              ),
              child: Column(
                children: [
                  const TopBarReadScreen(),
                  const SizedBox(height: 20),
                  const DividerBar(),
                  const SurahTitle(),
                  const SizedBox(height: 70),

                  Expanded(
                    child: Center(
                      child: VersePageContainerRukuThird(
                        rukuNumber: 3, // Updated to Ruku 2
                        startVerseIndex: (_currentPage - 1) * 4 + 33, // 13th verse is index 12
                        lastVerseIndex: 50, // 32nd verse is index 31
                        versesPerPage: 4,
                        versesPerPageDialogBox: 6,
                        currentPage: _currentPage,
                        totalPages: _totalPages,
                        totalPageDialogBox: _totalPageDialogBox,
                        onPageChanged: _handlePageChanged,
                        onPrevPage: _currentPage > 1
                            ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                            : null,
                        onNextPage: _currentPage < _totalPages
                            ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                            : null,
                        isFullScreen: false,
                        onToggleFullScreen: toggleFullScreen,
                      ),
                    ),
                  ),


                  // You can add more widgets below as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
