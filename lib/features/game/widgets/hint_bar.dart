import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../data/models/hint_model.dart';
import '../providers/game_provider.dart';

/// হিন্ট বার — Hint Action Bar
/// Premium, responsive power-up bar that fits perfectly on all screens with zero cut-off
class HintBar extends ConsumerWidget {
  const HintBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerProgress = ref.watch(playerProgressProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    final hints = [
      HintType.birdCall,
      HintType.leafFall,
      HintType.meaningClue,
      HintType.starlight,
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.goldenLight.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.earthyBrown.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: hints.map((hintType) {
          final info = HintInfo.hints[hintType]!;
          final canAfford = info.cost == 0 || playerProgress.coins >= info.cost;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    gameNotifier.useHint(hintType);
                  },
                  borderRadius: BorderRadius.circular(16),
                  splashColor: AppColors.golden.withValues(alpha: 0.2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: canAfford ? AppColors.cream : const Color(0xFFFAF7F0),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: canAfford
                            ? AppColors.golden
                            : AppColors.earthyBrownLight.withValues(alpha: 0.3),
                        width: canAfford ? 1.5 : 1.0,
                      ),
                      boxShadow: canAfford
                          ? [
                              BoxShadow(
                                color: AppColors.golden.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        Text(
                          info.icon,
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 2),

                        // Title (Always clear and readable)
                        Text(
                          info.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: canAfford
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Coin Price Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: canAfford
                                ? AppColors.golden.withValues(alpha: 0.25)
                                : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🪙', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 2),
                              Text(
                                info.cost.toBanglaDigits(),
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: canAfford
                                      ? AppColors.earthyBrown
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
