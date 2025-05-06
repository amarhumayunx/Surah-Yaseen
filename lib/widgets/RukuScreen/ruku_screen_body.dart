import 'package:flutter/material.dart';
import '../Dividerbar/dividerbar.dart';
import 'ruku_grid.dart';
import 'ruku_header.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/TopBar/topbar.dart';

class RukuScreenBody extends StatelessWidget {
  const RukuScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.02;

    return SafeArea(
      child: Column(
        children: [
          const TopBar(),
          SizedBox(height: spacing),
          const DividerBar(),
          const SurahTitle(),
          const RukuHeader(),
          SizedBox(height: 10),

          // Scrollable area starts here
          Expanded(
            child: SingleChildScrollView(
              child: const RukuGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
