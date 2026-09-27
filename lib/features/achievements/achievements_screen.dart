import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/extensions/string_extensions.dart';
import '../../data/models/achievement_model.dart';
import '../game/providers/game_provider.dart';

/// অর্জন স্ক্রিন — Achievements Screen
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);
    final allAchievements = Achievement.defaultAchievements;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'অর্জন ও পদক',
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: allAchievements.length,
        itemBuilder: (context, index) {
          final achievement = allAchievements[index];
          // Check unlock condition
          bool isUnlocked = false;
          if (achievement.id == 'novice') {
            isUnlocked = progress.completedLevels.isNotEmpty;
          } else if (achievement.id == 'word_hunter_10') {
            isUnlocked = progress.totalWordsFound >= 10;
          } else if (achievement.id == 'chapter_1_explorer') {
            isUnlocked = progress.completedLevels.length >= 5;
          } else if (achievement.id == 'chapter_1_master') {
            isUnlocked = progress.completedLevels.length >= 20;
          } else if (achievement.id == 'streak_3') {
            isUnlocked = progress.currentStreak >= 3;
          }

          final reward = achievement.rewardCoins.toBanglaDigits();

          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUnlocked ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isUnlocked ? AppColors.golden : Colors.grey.shade300,
                  width: isUnlocked ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isUnlocked ? 0.05 : 0.01),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isUnlocked ? AppColors.goldenLight : Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isUnlocked ? AppColors.golden : Colors.grey.shade400,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isUnlocked ? achievement.icon : '🔒',
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isUnlocked ? AppColors.textPrimary : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          achievement.description,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            color: isUnlocked ? AppColors.textSecondary : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Reward badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUnlocked ? AppColors.goldenLight : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          '+$reward',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isUnlocked ? AppColors.earthyBrown : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
