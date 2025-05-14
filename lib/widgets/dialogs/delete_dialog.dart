import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  Future<bool> showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.lightColorapp,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 280,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline, size: 40, color: AppColors.colorone),
              const SizedBox(height: 15),
              Text('delete_dialog_title'.tr,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      fontWeight: FontWeight.w500,
                      color: AppColors.PrimaryColor)),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkgreenColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('yes'.tr,
                          style: TextStyle(
                              fontFamily: GoogleFonts.merriweather().fontFamily,
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.colorone,
                        side: BorderSide(color: AppColors.colorone),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('no'.tr,
                          style: TextStyle(
                              fontFamily: GoogleFonts.merriweather().fontFamily,
                              fontSize: 16, fontWeight: FontWeight.bold)),
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
    return const SizedBox.shrink();
  }
}
