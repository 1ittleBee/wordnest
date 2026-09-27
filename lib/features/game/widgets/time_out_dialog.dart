import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/extensions/string_extensions.dart';

/// সময় শেষ ডায়ালগ — Time Out Dialog
/// Appears when the 60-second level countdown runs out.
/// Requires 10 coins to retry, with a free emergency gift if coins < 10.
class TimeOutDialog extends StatelessWidget {
  final int coins;
  final int retryCost;
  final int remainingFreeTries;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const TimeOutDialog({
    super.key,
    required this.coins,
    this.retryCost = 10,
    this.remainingFreeTries = 0,
    required this.onRetry,
    required this.onExit,
  });

  static Future<void> show(
    BuildContext context, {
    required int coins,
    int retryCost = 10,
    int remainingFreeTries = 0,
    required VoidCallback onRetry,
    required VoidCallback onExit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => TimeOutDialog(
        coins: coins,
        retryCost: retryCost,
        remainingFreeTries: remainingFreeTries,
        onRetry: onRetry,
        onExit: onExit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasEnoughCoins = coins >= retryCost;
    final costBangla = retryCost.toBanglaDigits();
    final coinsBangla = coins.toBanglaDigits();

    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsing Alarm Icon
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFF5252), width: 2),
                ),
                child: const Icon(
                  Icons.alarm_off_rounded,
                  size: 42,
                  color: Color(0xFFD32F2F),
                ),
              )
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.easeOutBack)
                  .shake(delay: 400.ms, duration: 500.ms),

              const SizedBox(height: 16),

              // Title
              Text(
                'সময় শেষ! ⏰',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.earthyBrown,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                '৬০ সেকেন্ড পেরিয়ে গেছে!\nমন খারাপের কিছু নেই, আবার চেষ্টা করে ৩ স্টার ছিনিয়ে নিন!',
                textAlign: TextAlign.center,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Status Card (Free Tries or Coin Balance)
              if (remainingFreeTries > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFA5D6A7)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stars_rounded,
                          size: 20, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 8),
                      Text(
                        'ফ্রি সুযোগ বাকি: ${remainingFreeTries.toBanglaDigits()} / ৩ টি',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFCDD2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      Text(
                        '৩টি ফ্রি সুযোগ শেষ! পরবর্তী চেষ্টা: ১০ 🪙',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFC62828),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
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
              ],

              const SizedBox(height: 18),

              // Retry Button (Free or Coin Cost)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh_rounded, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        remainingFreeTries > 0
                            ? 'পুনরায় চেষ্টা (বিনামূল্যে)'
                            : (hasEnoughCoins
                                ? 'পুনরায় চেষ্টা ($costBangla 🪙)'
                                : 'উপহার নিন (+২০ 🪙) ও খেলুন'),
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Exit Button (Secondary)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onExit,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: Text(
                    'চ্যাপ্টারে ফিরে যান',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.cellBorder, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
