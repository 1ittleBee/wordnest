import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/extensions/string_extensions.dart';

/// পেইড ট্রাই ডায়ালগ — Paid Try Confirmation Dialog
/// Shown when entering a level after all 3 free tries have been exhausted.
/// Requires 10 coins per try.
class PaidTryDialog extends StatelessWidget {
  final int coins;
  final int entryCost;
  final VoidCallback onPayAndPlay;
  final VoidCallback onCancel;

  const PaidTryDialog({
    super.key,
    required this.coins,
    this.entryCost = 10,
    required this.onPayAndPlay,
    required this.onCancel,
  });

  static Future<void> show(
    BuildContext context, {
    required int coins,
    int entryCost = 10,
    required VoidCallback onPayAndPlay,
    required VoidCallback onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PaidTryDialog(
        coins: coins,
        entryCost: entryCost,
        onPayAndPlay: onPayAndPlay,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasEnoughCoins = coins >= entryCost;
    final costBangla = entryCost.toBanglaDigits();
    final coinsBangla = coins.toBanglaDigits();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        onCancel();
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Coin Icon
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.goldenLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.golden, width: 2),
                ),
                child: const Center(
                  child: Text('🪙', style: TextStyle(fontSize: 40)),
                ),
              )
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.easeOutBack)
                  .shake(delay: 400.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // Title
              Text(
                'ফ্রি লিমিট শেষ! 🪙',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.earthyBrown,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'এই লেভেলের ৩টি ফ্রি সুযোগ শেষ হয়ে গেছে।\nপ্রতিটি নতুন চেষ্টার জন্য ১০ কয়েন লাগবে।',
                textAlign: TextAlign.center,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Balance card
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.goldenLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'আপনার কয়েন ব্যালেন্স:',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.earthyBrown,
                      ),
                    ),
                    Row(
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          coinsBangla,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Pay & Play Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onPayAndPlay,
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: Text(
                    hasEnoughCoins
                        ? '$costBangla কয়েন দিয়ে খেলুন'
                        : 'উপহার নিন (+২০ 🪙) ও খেলুন',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Cancel / Return Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(
                        color: AppColors.cellBorder, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'ফিরে যান',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
