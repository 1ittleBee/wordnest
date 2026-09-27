import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../data/models/word_model.dart';

/// শব্দ তালিকা প্যানেল — Word List Panel
/// Displays the list of target words to find with discovered status badges
class WordListPanel extends StatelessWidget {
  final List<BanglaWord> targetWords;
  final Set<String> foundWords;
  final Map<String, Color> wordColors;
  final String? lastFoundWordStr;
  final Function(BanglaWord)? onWordTap;

  const WordListPanel({
    super.key,
    required this.targetWords,
    required this.foundWords,
    required this.wordColors,
    this.lastFoundWordStr,
    this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    final foundCount = foundWords.length.toBanglaDigits();
    final totalCount = targetWords.length.toBanglaDigits();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.earthyBrownLight.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'খুঁজে বের করুন:',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$foundCount / $totalCount টি শব্দ',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Word Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: targetWords.map((word) {
              final isFound = foundWords.contains(word.word);
              final color = wordColors[word.word] ?? AppColors.correct;

              if (isFound) {
                final isJustFound = word.word == lastFoundWordStr;
                // Discovered Word Pill
                Widget pillWidget = GestureDetector(
                  onTap: () => onWordTap?.call(word),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 18, color: color),
                        const SizedBox(width: 6),
                        Text(
                          word.word,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: color,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: color,
                            decorationThickness: 2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.info_outline_rounded, size: 14, color: color.withOpacity(0.8)),
                      ],
                    ),
                  ),
                );

                if (isJustFound) {
                  pillWidget = pillWidget
                      .animate(key: ValueKey('pill_pop_${word.word}'))
                      .scale(
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1.0, 1.0),
                        duration: 350.ms,
                        curve: Curves.elasticOut,
                      )
                      .shimmer(duration: 500.ms, color: Colors.white70);
                }
                return pillWidget;
              } else {
                // Word to find — Clearly visible!
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.golden.withOpacity(0.8),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.golden.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        word.word,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }).toList(),
          ),
        ],
      ),
    );
  }
}
