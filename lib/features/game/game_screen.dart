import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/services/audio_service.dart';
import '../../data/models/level_model.dart';
import '../../data/local/hive_service.dart';
import '../level_complete/level_complete_screen.dart';
import 'providers/game_provider.dart';
import 'widgets/category_banner.dart';
import 'widgets/hint_bar.dart';
import 'widgets/letter_grid.dart';
import 'widgets/word_list_panel.dart';
import 'widgets/word_meaning_dialog.dart';

/// মূল খেলা স্ক্রিন — Core Game Screen
class GameScreen extends ConsumerStatefulWidget {
  final Level level;

  const GameScreen({super.key, required this.level});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _soundEnabled = HiveService.isSoundEnabled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameProvider.notifier).initLevel(widget.level);
    });
  }

  void _toggleSound() async {
    final updated = !_soundEnabled;
    await HiveService.setSoundEnabled(updated);
    setState(() {
      _soundEnabled = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final playerProgress = ref.watch(playerProgressProvider);

    // Completion listener
    ref.listen<GameState>(gameProvider, (previous, next) {
      if (next.isCompleted && !(previous?.isCompleted ?? false)) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LevelCompleteScreen(
                  level: widget.level,
                  stars: next.earnedStars,
                  coinsEarned: next.earnedCoins,
                  foundWords: next.level?.targetWords ?? [],
                ),
              ),
            );
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Stats Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  // Selected Word Preview Bubble
                  Expanded(
                    child: Center(
                      child: gameState.selectedIndices.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.goldenLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppColors.golden, width: 1.5),
                              ),
                              child: Text(
                                gameState.currentSelectedWord,
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.earthyBrown,
                                ),
                              ),
                            )
                              .animate()
                              .scale(
                                duration: 150.ms,
                                curve: Curves.easeOutBack,
                              )
                          : const SizedBox.shrink(),
                    ),
                  ),

                  // Sound toggle & Coin balance
                  Row(
                    children: [
                      IconButton(
                        onPressed: _toggleSound,
                        icon: Icon(
                          _soundEnabled
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                          color: AppColors.earthyBrown,
                          size: 22,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.goldenLight, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              playerProgress.coins.toBanglaDigits(),
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Category Banner
            CategoryBanner(level: widget.level),

            // Target Words Panel
            WordListPanel(
              targetWords: widget.level.targetWords,
              foundWords: gameState.foundWords,
              wordColors: gameState.wordColors,
              onWordTap: (word) {
                WordMeaningDialog.show(context, word);
              },
            ),

            // Feedback Message Bar
            if (gameState.feedbackMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: gameState.isWrongWord
                        ? AppColors.wrong.withOpacity(0.15)
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    gameState.feedbackMessage!,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: gameState.isWrongWord
                          ? AppColors.wrong
                          : AppColors.primaryDark,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 200.ms)
                    .shake(duration: gameState.isWrongWord ? 300.ms : 0.ms),
              ),

            // Letter Search Grid
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: LetterGrid(),
              ),
            ),

            // Hint Bar
            const HintBar(),
          ],
        ),
      ),
    );
  }
}
