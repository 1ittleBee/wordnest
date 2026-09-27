import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/extensions/string_extensions.dart';
import '../../data/models/level_model.dart';
import '../../data/models/word_model.dart';
import '../game/game_screen.dart';
import '../game/providers/game_provider.dart';

/// দৈনিক চ্যালেঞ্জ স্ক্রিন — Daily Challenge Screen
class DailyChallengeScreen extends ConsumerWidget {
  const DailyChallengeScreen({super.key});

  /// Generate today's special puzzle level
  Level _getTodayPuzzle() {
    final now = DateTime.now();
    return Level(
      id: 9999, // Special Daily ID
      division: 'দৈনিক উৎসব',
      category: 'ঋতু ও প্রকৃতি',
      categoryIcon: '🌦️',
      gridSize: 5,
      difficulty: Difficulty.medium,
      targetWords: const [
        BanglaWord(
          word: 'বৃষ্টি',
          meaning: 'আকাশ থেকে ঝরে পড়া জলবিন্দু',
          exampleSentence: 'বর্ষাকালে অঝোর ধারায় বৃষ্টি পড়ে।',
        ),
        BanglaWord(
          word: 'মেঘ',
          meaning: 'জলকণার পুঞ্জ যা আকাশে ভাসে',
          exampleSentence: 'নীল আকাশে সাদা মেঘ ভেসে বেড়ায়।',
        ),
        BanglaWord(
          word: 'বিদ্যুৎ',
          meaning: 'আকাশে ক্ষণস্থায়ী উজ্জ্বল আলোক রেখা',
          exampleSentence: 'ঝড়ের রাতে আকাশে বিদ্যুৎ চমকায়।',
        ),
        BanglaWord(
          word: 'রামধনু',
          meaning: 'বৃষ্টির পর আকাশে দৃশ্যমান সপ্তবর্ণ ধনুক',
          exampleSentence: 'বৃষ্টি থামতেই আকাশে সুন্দর রামধনু উঠল।',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);
    final streak = progress.currentStreak.toBanglaDigits();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'দৈনিক চ্যালেঞ্জ',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Calendar / Date Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'আজকের বিশেষ চ্যালেঞ্জ 🌟',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Streak Trophy Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF8A65),
                      AppColors.accentOrange,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentOrange.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 54)),
                    const SizedBox(height: 10),
                    Text(
                      '$streak দিনের অবিরাম যাত্রা!',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'প্রতিদিন ধাঁধা খেলে স্ট্রিক অটুট থাকবে',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Reward Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.goldenLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppColors.goldenLight,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text('🎁', style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'বিশেষ পুরস্কার',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'আজকের চ্যালেঞ্জ সম্পন্ন করলে +১০০ কয়েন!',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Start Challenge Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    final puzzle = _getTodayPuzzle();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GameScreen(level: puzzle),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bolt_rounded, size: 28, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'চ্যালেঞ্জ শুরু করুন',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
