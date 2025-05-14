import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surah_yaseen/Colors/colors.dart';

class NotificationHistoryClearDialog extends StatelessWidget {
  const NotificationHistoryClearDialog({super.key});

  Future<bool> showNotificationHistoryClearDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.lightColorapp,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete_outline, size: 40, color: Color(0xFF4CAF87)),
              const SizedBox(height: 15),
              Text(
                'notification_dialog_title'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colorone,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'yes'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.merriweather().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      child: Text(
                        'no'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.merriweather().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
