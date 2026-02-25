import 'package:flutter/material.dart';
import '../../Colors/colors.dart';
import '../../core/theme/app_colors.dart';

/// Wraps any ad (banner or native) in a card that matches the native ad layout
/// from the design: white card, rounded corners, shadow, and "Ad" badge.
/// Use this so all ad placements look consistent across the app.
class StyledAdCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? minHeight;

  const StyledAdCard({
    super.key,
    required this.child,
    this.padding,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(minHeight: minHeight ?? 80),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: padding ?? const EdgeInsets.fromLTRB(16, 28, 16, 12),
                  child: child,
                ),
                // "Ad" badge - small yellow pill like in the design
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.BarColor.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      'Ad',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
