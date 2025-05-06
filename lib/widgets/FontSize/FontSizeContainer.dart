import 'package:flutter/material.dart';
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
                borderRadius: BorderRadius.circular(15),
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
                          'Font Size',
                          style: TextStyle(
                            color: AppColors.PrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
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
                            style: TextStyle(
                              fontSize: 18 + (_fontSizeValue * 8),
                              fontFamily: GoogleFonts.merriweather().fontFamily,
                              color: AppColors.PrimaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start with the holy name of Allah, the Most Merciful, the Most Merciful.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14 + (_fontSizeValue * 4),
                                color: AppColors.BarColor,
                                fontFamily: GoogleFonts.merriweather().fontFamily
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                            'A',
                            style: TextStyle(
                                fontSize: 14,
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
                                fontSize: 22,
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