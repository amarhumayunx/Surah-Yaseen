import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Colors/colors.dart';

class BookmarkConfirmationDialog extends StatelessWidget {
  final String message;

  const BookmarkConfirmationDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppColors.lightColorapp,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              message.contains('Already')
                  ? Icons.bookmark
                  : Icons.bookmark_added_rounded,
              size: 40,
              color: AppColors.PrimaryColor,
            ),
            const SizedBox(height: 15),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.PrimaryColor,
                fontFamily: GoogleFonts.merriweather().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
