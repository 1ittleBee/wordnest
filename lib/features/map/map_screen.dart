import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/extensions/string_extensions.dart';
import '../../data/repositories/level_repository.dart';
import '../game/providers/game_provider.dart';
import '../level_select/level_select_screen.dart';

/// অধ্যায় মানচিত্র স্ক্রিন — Chapter / World Map Screen
/// Interactive journey across the chapters/worlds of WordNest (Ring of Words style)
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);
    final chapters = LevelRepository.chapters;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'অধ্যায় মানচিত্র',
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
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chap = chapters[index];
            final chapKey = chap['key']!;
            final chapName = chap['name']!;
            final chapNumber = chap['chapter'] ?? 'অধ্যায় ${(index + 1)}'.toBanglaDigits();
            final chapIcon = chap['icon']!;
            final chapDesc = chap['description'] ?? 'শব্দ ধাঁধার রোমাঞ্চকর জগৎ';
            final levelRange = chap['range'] ?? '${index * 20 + 1} - ${(index + 1) * 20}'.toBanglaDigits();

            // Unlocked if previous chapter is accessible or is first chapter
            final isUnlocked = index <= progress.currentDivisionIndex;
            final isCurrent = index == progress.currentDivisionIndex;

            // Stars in this chapter (20 levels per chapter)
            final startLevelId = index * 20 + 1;
            final endLevelId = (index + 1) * 20;
            int chapStars = 0;
            int completedInChapter = 0;
            for (int lvl = startLevelId; lvl <= endLevelId; lvl++) {
              chapStars += progress.levelStars[lvl] ?? 0;
              if (progress.completedLevels.contains(lvl)) {
                completedInChapter++;
              }
            }
            final isFullyCompleted = completedInChapter >= 20;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: InkWell(
                onTap: isUnlocked
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LevelSelectScreen(
                              divisionKey: chapKey,
                              divisionName: '$chapNumber: $chapName',
                              divisionIcon: chapIcon,
                              divisionIndex: index,
                            ),
                          ),
                        );
                      }
                    : null,
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUnlocked ? Colors.white : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isFullyCompleted
                          ? AppColors.primary
                          : (isCurrent
                              ? AppColors.golden
                              : (isUnlocked ? AppColors.primaryLight.withOpacity(0.6) : Colors.grey.shade300)),
                      width: isCurrent || isFullyCompleted ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isUnlocked ? 0.05 : 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chapter Icon Avatar Node
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              gradient: isUnlocked
                                  ? LinearGradient(
                                      colors: [
                                        AppColors.goldenLight,
                                        AppColors.golden.withOpacity(0.3),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isUnlocked ? null : Colors.grey.shade300,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isUnlocked ? AppColors.golden : Colors.grey,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              isUnlocked ? chapIcon : '🔒',
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Chapter Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Chapter Number & Status Chip
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isUnlocked
                                            ? AppColors.primaryLight.withOpacity(0.4)
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        chapNumber,
                                        style: GoogleFonts.hindSiliguri(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: isUnlocked ? AppColors.primaryDark : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (isFullyCompleted)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryLight,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'সম্পন্ন ✨',
                                          style: GoogleFonts.hindSiliguri(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      )
                                    else if (isCurrent)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.goldenLight,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'চলমান 🎯',
                                          style: GoogleFonts.hindSiliguri(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.earthyBrown,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                // Chapter Name
                                Text(
                                  chapName,
                                  style: GoogleFonts.hindSiliguri(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: isUnlocked ? AppColors.textPrimary : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 2),

                                // Chapter Description & Level Range
                                Text(
                                  isUnlocked
                                      ? '$chapDesc • লেভেল $levelRange'
                                      : 'পূর্ববর্তী অধ্যায় সম্পন্ন করে আনলক করুন',
                                  style: GoogleFonts.hindSiliguri(
                                    fontSize: 12,
                                    color: isUnlocked ? AppColors.textSecondary : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Stars or Lock Icon
                          if (isUnlocked)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded, size: 18, color: AppColors.golden),
                                    const SizedBox(width: 3),
                                    Text(
                                      '$chapStars/৬০'.toBanglaDigits(),
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.earthyBrown,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                              ],
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Icon(Icons.lock_outline_rounded, color: Colors.grey),
                            ),
                        ],
                      ),

                      // Progress bar for unlocked chapters
                      if (isUnlocked) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: (completedInChapter / 20).clamp(0.0, 1.0),
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isFullyCompleted ? AppColors.primary : AppColors.golden,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'লেভেল $levelRange',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '$completedInChapter/২০ সম্পন্ন'.toBanglaDigits(),
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isFullyCompleted ? AppColors.primaryDark : AppColors.earthyBrown,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
