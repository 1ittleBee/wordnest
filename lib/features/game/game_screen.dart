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
import 'widgets/combo_banner_widget.dart';
import 'widgets/flying_coins_overlay.dart';
import 'widgets/paid_try_dialog.dart';
import 'widgets/quit_confirmation_dialog.dart';
import 'widgets/speed_star_timer_bar.dart';
import 'widgets/time_out_dialog.dart';
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
  bool _isShowingQuitDialog = false;
  bool _coinBadgePunch = false;
  final GlobalKey<FlyingCoinsOverlayState> _flyingCoinsKey = GlobalKey();
  final GlobalKey _coinTargetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndInitLevel();
    });
  }

  void _checkAndInitLevel() async {
    final progress = ref.read(playerProgressProvider);
    final freeTries = progress.getFreeTries(widget.level.id);

    if (freeTries > 0) {
      // Free tries still available
      ref.read(gameProvider.notifier).initLevel(widget.level);
    } else {
      // Free limit ended! Every try costs 10 coins
      final currentCoins = progress.coins;
      await PaidTryDialog.show(
        context,
        coins: currentCoins,
        entryCost: 10,
        onPayAndPlay: () async {
          final progressNotifier = ref.read(playerProgressProvider.notifier);
          final userCoins = ref.read(playerProgressProvider).coins;
          if (userCoins < 10) {
            await progressNotifier.addCoins(20);
          }
          final spent = await progressNotifier.spendCoins(10);
          if (spent) {
            AudioService.playCoin();
          }
          if (mounted) {
            Navigator.of(context).pop(); // dismiss dialog
            ref.read(gameProvider.notifier).initLevel(widget.level);
          }
        },
        onCancel: () {
          if (mounted) {
            Navigator.of(context).pop(); // dismiss dialog
            Navigator.of(context).pop(); // return to chapter/levels
          }
        },
      );
    }
  }

  void _toggleSound() async {
    final updated = !_soundEnabled;
    await HiveService.setSoundEnabled(updated);
    setState(() {
      _soundEnabled = updated;
    });
  }

  void _handleBackAttempt() async {
    if (_isShowingQuitDialog) return;
    final gameState = ref.read(gameProvider);
    if (gameState.isCompleted || gameState.isTimeOut) {
      Navigator.of(context).pop();
      return;
    }

    _isShowingQuitDialog = true;
    final currentFreeTries =
        ref.read(playerProgressProvider).getFreeTries(widget.level.id);

    ref.read(gameProvider.notifier).pauseTimer();

    await QuitConfirmationDialog.show(
      context,
      remainingFreeTries: currentFreeTries,
      onContinue: () {
        Navigator.of(context).pop(); // dismiss modal
        ref.read(gameProvider.notifier).resumeTimer();
      },
      onConfirmQuit: () async {
        Navigator.of(context).pop(); // dismiss modal
        await ref
            .read(playerProgressProvider.notifier)
            .consumeFreeTry(widget.level.id);
        if (mounted) {
          Navigator.of(context).pop(); // exit to chapter/levels
        }
      },
    );
    _isShowingQuitDialog = false;
  }

  void _handleTimeOut() async {
    final progress = ref.read(playerProgressProvider);
    final freeTries = progress.getFreeTries(widget.level.id);

    // This attempt ended in timeout, so consume 1 free try if available
    int remainingFree = freeTries;
    if (freeTries > 0) {
      await ref
          .read(playerProgressProvider.notifier)
          .consumeFreeTry(widget.level.id);
      remainingFree =
          ref.read(playerProgressProvider).getFreeTries(widget.level.id);
    }

    if (!mounted) return;

    final currentCoins = ref.read(playerProgressProvider).coins;

    await TimeOutDialog.show(
      context,
      coins: currentCoins,
      retryCost: 10,
      remainingFreeTries: remainingFree,
      onRetry: () async {
        final progressNotifier = ref.read(playerProgressProvider.notifier);
        if (remainingFree > 0) {
          // Free retry used
          AudioService.playLetterTap();
        } else {
          // Free tries exhausted - every retry costs 10 coins!
          final userCoins = ref.read(playerProgressProvider).coins;
          if (userCoins < 10) {
            await progressNotifier.addCoins(20);
          }
          final spent = await progressNotifier.spendCoins(10);
          if (spent) {
            AudioService.playCoin();
          }
        }
        if (mounted) {
          Navigator.of(context).pop(); // dismiss dialog
          ref.read(gameProvider.notifier).restartLevel();
        }
      },
      onExit: () {
        if (mounted) {
          Navigator.of(context).pop(); // dismiss dialog
          Navigator.of(context).pop(); // exit to chapter/levels
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final playerProgress = ref.watch(playerProgressProvider);
    final currentFreeTries = playerProgress.getFreeTries(widget.level.id);

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

      // Timeout listener
      if (next.isTimeOut && !(previous?.isTimeOut ?? false)) {
        _handleTimeOut();
      }

      // Word found flying coins animation listener
      if (next.foundWords.length > (previous?.foundWords.length ?? 0)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final renderBox =
              _coinTargetKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final targetOffset =
                renderBox.localToGlobal(renderBox.size.center(Offset.zero));
            final size = MediaQuery.of(context).size;
            final startOffset = Offset(size.width / 2, size.height * 0.65);
            _flyingCoinsKey.currentState?.spawnCoins(
              startPos: startOffset,
              targetPos: targetOffset,
              count: 6,
              onAllArrived: () {
                if (mounted) {
                  setState(() => _coinBadgePunch = true);
                  Future.delayed(const Duration(milliseconds: 250), () {
                    if (mounted) setState(() => _coinBadgePunch = false);
                  });
                }
              },
            );
          }
        });
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackAttempt();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: FlyingCoinsOverlay(
          key: _flyingCoinsKey,
          child: Stack(
            children: [
              SafeArea(
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
                            onPressed: _handleBackAttempt,
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

                          // Sound toggle, Tries badge & Coin balance
                          Row(
                            children: [
                              // Free Tries Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: currentFreeTries > 0
                                      ? const Color(0xFFE8F5E9)
                                      : const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: currentFreeTries > 0
                                        ? const Color(0xFFA5D6A7)
                                        : const Color(0xFFFFCDD2),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currentFreeTries > 0 ? '🎯' : '⚠️',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${currentFreeTries.toBanglaDigits()}/৩',
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: currentFreeTries > 0
                                            ? const Color(0xFF2E7D32)
                                            : const Color(0xFFC62828),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _toggleSound,
                                icon: Icon(
                                  _soundEnabled
                                      ? Icons.volume_up_rounded
                                      : Icons.volume_off_rounded,
                                  color: AppColors.earthyBrown,
                                  size: 20,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 4),
                              // Coin Balance Badge with key for flying coins & punch bounce
                              Container(
                                key: _coinTargetKey,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.cream,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: AppColors.goldenLight, width: 1.2),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('🪙', style: TextStyle(fontSize: 13)),
                                    const SizedBox(width: 4),
                                    Text(
                                      playerProgress.coins.toBanglaDigits(),
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  .animate(target: _coinBadgePunch ? 1 : 0)
                                  .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.25, 1.25),
                                    duration: 150.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Speed Star Timer Bar
                    SpeedStarTimerBar(
                      remainingSeconds: gameState.remainingSeconds,
                      totalSeconds: gameState.totalSeconds,
                      isCompleted: gameState.isCompleted,
                    ),

                    // Category Banner
                    CategoryBanner(level: widget.level),

                    // Target Words Panel
                    WordListPanel(
                      targetWords: widget.level.targetWords,
                      foundWords: gameState.foundWords,
                      wordColors: gameState.wordColors,
                      lastFoundWordStr: gameState.lastFoundWordStr,
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

              // Feature 6: Red Vignette Tension Overlay in the last 10s
              if (gameState.remainingSeconds <= 10 &&
                  !gameState.isTimeOut &&
                  !gameState.isCompleted)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.0,
                          colors: [
                            Colors.transparent,
                            const Color(0xFFD32F2F).withValues(alpha: 0.22),
                          ],
                          stops: const [0.65, 1.0],
                        ),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fade(
                          begin: 0.35,
                          end: 1.0,
                          duration: 600.ms,
                          curve: Curves.easeInOut,
                        ),
                  ),
                ),

              // Feature 4: Combo / Streak Floating Text Popup
              ComboBannerWidget(
                comboText: gameState.comboBanner,
                onDismiss: () {
                  ref.read(gameProvider.notifier).clearComboBanner();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
