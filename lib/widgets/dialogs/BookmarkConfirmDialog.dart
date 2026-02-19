import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Colors/colors.dart';

class BookmarkConfirmationDialog extends StatelessWidget {
  final String message;

  const BookmarkConfirmationDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final dialogWidth = screenSize.width * 0.85;
    final dialogMaxWidth = 400.0;
    final padding = isSmallScreen ? 16.0 : 20.0;
    final iconSize = isSmallScreen ? 32.0 : 40.0;
    final fontSize = isSmallScreen ? 16.0 : 18.0;
    final spacing = isSmallScreen ? 12.0 : 15.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppColors.lightColorapp,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: dialogMaxWidth,
          maxHeight: screenSize.height * 0.5,
        ),
        padding: EdgeInsets.all(padding),
        width: dialogWidth.clamp(250.0, dialogMaxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              message.contains('Already')
                  ? Icons.bookmark
                  : Icons.bookmark_added_rounded,
              size: iconSize,
              color: AppColors.PrimaryColor,
            ),
            SizedBox(height: spacing),
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.PrimaryColor,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
