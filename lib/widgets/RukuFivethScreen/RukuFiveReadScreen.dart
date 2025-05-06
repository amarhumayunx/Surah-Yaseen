import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/widgets/ReadScreen/ReadScreenTopBar.dart';
import 'package:surah_yaseen/widgets/RukuFivethScreen/VersePageContainerRukuFive.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/Topbackground/top_background.dart';
import '../../Colors/colors.dart';
import '../Dividerbar/dividerbar.dart';

class RukuFiveReadScreen extends StatefulWidget {
  const RukuFiveReadScreen({super.key});

  @override
  State<RukuFiveReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<RukuFiveReadScreen> {

  final firstVerseIndex = 68;
  final lastVerseIndex = 83;

  int _currentPage = 1;
  int _totalPages = 4;
  int _totalPageDialogBox = 3;
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
          // Background
          const TopBackground(),
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Column(
                children: [
                  const TopBarReadScreen(),
                  const SizedBox(height: 10),
                  const DividerBar(),
                  const SurahTitle(),
                  const SizedBox(height: 70),

                  Expanded(
                    child: Center(
                      child: VersePageContainerRukuFive(
                        rukuNumber: 5,
                        startVerseIndex: (_currentPage - 1) * 4 + 68,
                        lastVerseIndex: 83,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}