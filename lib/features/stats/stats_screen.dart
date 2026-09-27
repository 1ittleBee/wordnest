import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/extensions/string_extensions.dart';
import '../game/providers/game_provider.dart';

/// পরিসংখ্যান স্ক্রিন — Player Stats Screen
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'আপনার পরিসংখ্যান',
          style: GoogleFonts.hindSiliguri(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Overall Score Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'শব্দ সাধনার অগ্রগতি',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'মোট ${progress.totalStars.toBanglaDigits()} টি তারকা অর্জিত',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 15,
                      color: AppColors.goldenLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stat Cards Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    title: 'খুঁজে পাওয়া শব্দ',
                    value: progress.totalWordsFound.toBanglaDigits(),
                    icon: '🔍',
                    color: AppColors.skyBlueLight,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatTile(
                    title: 'সম্পন্ন লেভেল',
                    value: progress.completedLevels.length.toBanglaDigits(),
                    icon: '🎯',
                    color: AppColors.primaryLight.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    title: 'মোট কয়েন',
                    value: progress.coins.toBanglaDigits(),
                    icon: '🪙',
                    color: AppColors.goldenLight,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatTile(
                    title: 'চলতি স্ট্রিক',
                    value: '${progress.currentStreak.toBanglaDigits()} দিন',
                    icon: '🔥',
                    color: AppColors.softPinkLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.hindSiliguri(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.hindSiliguri(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
