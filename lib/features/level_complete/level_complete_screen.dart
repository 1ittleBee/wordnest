import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/services/audio_service.dart';
import '../../data/models/level_model.dart';
import '../../data/models/word_model.dart';
import '../../data/repositories/level_repository.dart';
import '../game/game_screen.dart';
import '../home/home_screen.dart';

/// লেভেল সম্পূর্ণ স্ক্রিন — Level Complete Celebration Screen
class LevelCompleteScreen extends StatefulWidget {
  final Level level;
  final int stars;
  final int coinsEarned;
  final List<BanglaWord> foundWords;

  const LevelCompleteScreen({
    super.key,
    required this.level,
    required this.stars,
    required this.coinsEarned,
    required this.foundWords,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    AudioService.playLevelComplete();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _goToNextLevel() async {
    final nextId = widget.level.id + 1;
    final repo = LevelRepository();
    final nextLevel = await repo.getLevelById(nextId);

    if (mounted) {
      if (nextLevel != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameScreen(level: nextLevel),
          ),
        );
      } else {
        // All levels completed or return home
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    }
  }

  void _replayLevel() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => GameScreen(level: widget.level),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levelNumBangla = widget.level.id.toBanglaDigits();
    final coinsBangla = widget.coinsEarned.toBanglaDigits();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti explosion
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              AppColors.primary,
              AppColors.golden,
              AppColors.accentOrange,
              AppColors.skyBlue,
              AppColors.softPink,
            ],
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Mascot Celebration
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.goldenLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.golden, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.golden.withOpacity(0.3),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Center(
                      child: Transform.translate(
                        offset: const Offset(0, -2.5),
                        child: Transform.flip(
                          flipX: true,
                          child: const Text(
                            '🐦',
                            style: TextStyle(
                              fontSize: 52,
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),
                  const SizedBox(height: 16),

                  // Celebratory Title
                  Text(
                    'অসাধারণ বিজয়!',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms)
                      .slideY(begin: 0.2, end: 0),

                  Text(
                    'লেভেল $levelNumBangla সম্পূর্ণ হয়েছে',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Star Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final hasStar = index < widget.stars;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          hasStar ? Icons.star_rounded : Icons.star_border_rounded,
                          size: 54,
                          color: hasStar ? AppColors.golden : Colors.grey.shade400,
                        ),
                      )
                          .animate()
                          .scale(
                            delay: (300 + index * 200).ms,
                            duration: 400.ms,
                            curve: Curves.elasticOut,
                          );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Coins Reward Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.goldenLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.golden, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          '+$coinsBangla কয়েন অর্জিত!',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.earthyBrown,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms)
                      .scale(),
                  const SizedBox(height: 28),

                  // Learned Words Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.earthyBrownLight),
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
                        Row(
                          children: [
                            const Text('📖', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              'আজকে যা শিখলেন:',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...widget.foundWords.map((word) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('🌱', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${word.word}: ',
                                          style: GoogleFonts.hindSiliguri(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                        TextSpan(
                                          text: word.meaning,
                                          style: GoogleFonts.hindSiliguri(
                                            fontSize: 14,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Actions: Next Level Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _goToNextLevel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'পরের লেভেল',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Secondary Action Buttons: Replay & Home
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _replayLevel,
                          icon: const Icon(Icons.replay_rounded, color: AppColors.earthyBrown),
                          label: Text(
                            'পুনরায় খেলুন',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.earthyBrown,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.earthyBrownLight, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.home_rounded, color: AppColors.primary),
                          label: Text(
                            'হোম',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
