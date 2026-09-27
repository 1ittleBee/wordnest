import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../data/models/level_model.dart';

/// ক্যাটাগরি ব্যানার — Category Banner
/// Shows the level category, division, and icon in a beautiful scroll banner
class CategoryBanner extends StatelessWidget {
  final Level? level;

  const CategoryBanner({super.key, this.level});

  @override
  Widget build(BuildContext context) {
    if (level == null) return const SizedBox.shrink();

    final levelNumBangla = level!.id.toBanglaDigits();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.cardBg,
            AppColors.cream,
            AppColors.cardBg,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.earthyBrownLight,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.earthyBrown.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Division & Level Number
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'লেভেল $levelNumBangla',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '•  ${level!.chapterName}',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.goldenLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.golden.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  level!.categoryIcon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  level!.category,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.earthyBrown,
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
