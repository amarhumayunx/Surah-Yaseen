import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  Future<bool> showExitDialog(BuildContext context) async {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final dialogWidth = screenSize.width * 0.85;
    final dialogMaxWidth = 400.0;
    final padding = isSmallScreen ? 16.0 : 20.0;
    final iconSize = isSmallScreen ? 32.0 : 40.0;
    final titleFontSize = isSmallScreen ? 18.0 : 20.0;
    final buttonFontSize = isSmallScreen ? 14.0 : 16.0;
    final spacing1 = isSmallScreen ? 12.0 : 15.0;
    final spacing2 = isSmallScreen ? 20.0 : 25.0;
    final buttonPadding = isSmallScreen ? 10.0 : 12.0;
    final buttonSpacing = isSmallScreen ? 12.0 : 15.0;

    return await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.lightColorapp,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: dialogMaxWidth,
            maxHeight: screenSize.height * 0.5,
          ),
          padding: EdgeInsets.all(padding),
          width: dialogWidth.clamp(280.0, dialogMaxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.exit_to_app, size: iconSize, color: AppColors.PrimaryColor),
              SizedBox(height: spacing1),
              Flexible(
                child: Text('exit_dialog_title'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: titleFontSize,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                        fontWeight: FontWeight.w500,
                        color: AppColors.PrimaryColor)),
              ),
              SizedBox(height: spacing2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.colorone,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      ),
                      child: Text('yes'.tr,
                          style: TextStyle(fontSize: buttonFontSize,
                              fontFamily: GoogleFonts.merriweather().fontFamily,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: buttonSpacing),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.colorone,
                        side: BorderSide(color: AppColors.colorone),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      ),
                      child: Text('no'.tr,
                          style: TextStyle(fontSize: buttonFontSize,
                              fontFamily: GoogleFonts.merriweather().fontFamily,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    // This widget doesn't render anything by itself
    return const SizedBox.shrink();
  }
}