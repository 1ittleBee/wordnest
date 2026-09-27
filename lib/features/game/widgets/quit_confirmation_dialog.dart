import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/extensions/string_extensions.dart';

/// খেলা ছাড়ার নিশ্চিতকরণ ডায়ালগ — Quit Confirmation Modal
/// Shown when user attempts to leave an active level.
/// Explicitly warns that exiting will consume one free try.
class QuitConfirmationDialog extends StatelessWidget {
  final int remainingFreeTries;
  final VoidCallback onContinue;
  final VoidCallback onConfirmQuit;

  const QuitConfirmationDialog({
    super.key,
    required this.remainingFreeTries,
    required this.onContinue,
    required this.onConfirmQuit,
  });

  static Future<bool?> show(
    BuildContext context, {
    required int remainingFreeTries,
    required VoidCallback onContinue,
    required VoidCallback onConfirmQuit,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => QuitConfirmationDialog(
        remainingFreeTries: remainingFreeTries,
        onContinue: onContinue,
        onConfirmQuit: onConfirmQuit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final triesBangla = remainingFreeTries.toBanglaDigits();
    final nextTriesBangla = (remainingFreeTries - 1).clamp(0, 3).toBanglaDigits();
    final hasFreeTries = remainingFreeTries > 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        onContinue();
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
              // Warning Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFB74D), width: 2),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 42,
                  color: Color(0xFFE65100),
                ),
              )
                  .animate()
                  .scale(duration: 350.ms, curve: Curves.easeOutBack)
                  .shake(delay: 350.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // Title
              Text(
                'খেলা ছাড়তে চান? ⚠️',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.earthyBrown,
                ),
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                'এখন বের হয়ে গেলে এটি আপনার একটি চেষ্টা হিসেবে গণ্য হবে!',
                textAlign: TextAlign.center,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Tries status box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: hasFreeTries ? AppColors.cream : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: hasFreeTries ? AppColors.goldenLight : const Color(0xFFFFCDD2),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hasFreeTries ? '🎯' : '🪙',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hasFreeTries
                              ? 'অবশিষ্ট ফ্রি সুযোগ: $triesBangla / ৩'
                              : 'সব ফ্রি সুযোগ শেষ!',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: hasFreeTries
                                ? AppColors.earthyBrown
                                : const Color(0xFFC62828),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasFreeTries
                          ? (remainingFreeTries == 1
                              ? 'বেরিয়ে গেলে সব ফ্রি সুযোগ শেষ হবে (পরের চেষ্টা ১০ 🪙)!'
                              : 'বেরিয়ে গেলে সুযোগ কমে $nextTriesBangla টি হবে।')
                          : 'পরবর্তীতে পুনরায় খেলতে ১০ কয়েন লাগবে।',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Primary Button: Continue playing (Stay in game)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onContinue,
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: Text(
                    'খেলা চালিয়ে যান',
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

              // Secondary Button: Exit (Counts as a try)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onConfirmQuit,
                  icon: const Icon(Icons.exit_to_app_rounded, size: 18),
                  label: Text(
                    'বেরিয়ে যান (চেষ্টা গণ্য হবে)',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD32F2F),
                    side: const BorderSide(color: Color(0xFFFFCDD2), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
