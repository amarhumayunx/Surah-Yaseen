import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Colors/colors.dart';
import '../../constants/app_assets.dart';
import 'FontSizeProvider.dart'; // Import the provider

class FontSizeContainer extends StatelessWidget {
  const FontSizeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
        builder: (context, fontSizeProvider, child) {
          final _fontSizeValue = fontSizeProvider.fontSizeValue;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: AppColors.BarColor, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.fontsizeicon,
                          width: 24,
                          height: 24,
                          color: AppColors.PrimaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'font_size'.tr,
                          style: TextStyle(
                            color: AppColors.PrimaryColor,
                            fontSize: 16,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                            textAlign: TextAlign.center,
                            style: ArabicTextStyle(
                              arabicFont: ArabicFont.lateef,
                              fontSize: 24 + (_fontSizeValue * 8),
                              color: AppColors.PrimaryColor,
                              height: 1.5
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'bismillah'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13 + (_fontSizeValue * 8),
                                color: AppColors.BarColor,
                                fontFamily: GoogleFonts.merriweather().fontFamily,
                                height: 1.3
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                            'A',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: AppColors.PrimaryColor)),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.PrimaryColor,
                              inactiveTrackColor: Colors.grey.shade200,
                              thumbColor: AppColors.PrimaryColor,
                            ),
                            child: Slider(
                              value: _fontSizeValue,
                              min: 0,
                              max: 1,
                              onChanged: (value) {
                                fontSizeProvider.setFontSize(value);
                              },
                            ),
                          ),
                        ),
                        Text(
                            'A',
                            style: TextStyle(
                                fontSize: 21,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: AppColors.PrimaryColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}