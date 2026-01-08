import 'package:flutter/material.dart';
import '../Dividerbar/dividerbar.dart';
import 'ruku_grid.dart';
import 'ruku_header.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/TopBar/topbartest.dart';

class RukuScreenBody extends StatelessWidget {
  const RukuScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.02;

    return SafeArea(
      child: Column(
        children: [
          const TopBarSet(),
          SizedBox(height: spacing),
          const DividerBar(),
          const SurahTitle(),
          const RukuHeader(),

          // Scrollable area starts here
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [const RukuGrid(), const SizedBox(height: 20)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
