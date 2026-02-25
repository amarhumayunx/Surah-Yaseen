import 'package:flutter/material.dart';
import '../Dividerbar/dividerbar.dart';
import 'ruku_grid.dart';
import 'ruku_header.dart';
import 'package:surah_yaseen/widgets/SurahTitle/surat_title.dart';
import 'package:surah_yaseen/widgets/TopBar/topbartest.dart';
import '../Ads/native_style_ad_widget.dart';
import '../../constants/ad_unit_ids.dart';
import '../../Colors/colors.dart';

class RukuScreenBody extends StatelessWidget {
  const RukuScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.02;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const TopBarSet(),
          SizedBox(height: spacing),
          const DividerBar(),
          const SurahTitle(),
          const RukuHeader(),

          // ✅ Expanded with Stack for fade effect
          Expanded(
            child: Stack(
              children: [
                // Scrollable content
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      const RukuGrid(),
                      const NativeStyleAdWidget(
                        screenType: AdScreenType.ruku,
                        minHeight: 60,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // ✅ Top fade effect
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.lightColorSec,
                            AppColors.lightColorSec.withOpacity(0.0),
                          ],
                        ),
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
