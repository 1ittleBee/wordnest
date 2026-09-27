import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/extensions/string_extensions.dart';

/// স্পিড স্টার টাইমার বার — Speed Star Timer Bar
/// Displays a real-time countdown with dynamic 3-Star tier badges,
/// double-coin bonus status, and emergency alert in the last 10 seconds.
class SpeedStarTimerBar extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isCompleted;

  const SpeedStarTimerBar({
    super.key,
    required this.remainingSeconds,
    this.totalSeconds = 60,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
    final isEmergency = remainingSeconds <= 10 && remainingSeconds > 0;
    final isDoubleCoin = remainingSeconds > 30;
    final isTwoStar = remainingSeconds <= 30 && remainingSeconds > 10;
    final isOneStar = remainingSeconds <= 10;

    // Formatting mm:ss in Bangla
    final minutes = (remainingSeconds ~/ 60).toBanglaDigits();
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0').toBanglaDigits();
    final timeText = '$minutes:$seconds';

    // Dynamic color based on tier
    final Color barColor = remainingSeconds > 30
        ? const Color(0xFF2E7D32) // Forest green
        : (remainingSeconds > 10
            ? const Color(0xFFF57C00) // Vibrant amber
            : const Color(0xFFD32F2F)); // Urgent crimson

    final Color badgeBg = remainingSeconds > 30
        ? const Color(0xFFE8F5E9)
        : (remainingSeconds > 10
            ? const Color(0xFFFFF3E0)
            : const Color(0xFFFFEBEE));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEmergency ? const Color(0xFFFF5252) : AppColors.cellBorder,
          width: isEmergency ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isEmergency ? const Color(0xFFFF5252) : Colors.black).withOpacity(isEmergency ? 0.2 : 0.05),
            blurRadius: isEmergency ? 10 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Clock & Time display
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.timer_rounded,
                          size: 18,
                          color: barColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeText,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: barColor,
                        ),
                      ),
                    ],
                  )
                      .animate(
                        target: isEmergency ? 1 : 0,
                        onPlay: (c) {
                          if (isEmergency) c.repeat(reverse: true);
                        },
                      )
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.12, 1.12),
                        duration: 380.ms,
                        curve: Curves.easeInOut,
                      ),
                  if (isEmergency) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF1744),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '💡 ফ্রি হিন্ট!',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(duration: 500.ms),
                  ],
                ],
              ),

              // Right: Star badges & bonus status
              Row(
                children: [
                  _buildStar(1, isOneStar || isTwoStar || isDoubleCoin),
                  const SizedBox(width: 3),
                  _buildStar(2, isTwoStar || isDoubleCoin),
                  const SizedBox(width: 3),
                  _buildStar(3, isDoubleCoin),
                  const SizedBox(width: 8),

                  // Bonus badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: barColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      isDoubleCoin
                          ? '৩★ ২x কয়েন'
                          : (isTwoStar ? '২★ স্টার' : '১★ শেষ সুযোগ'),
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: barColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Animated Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: progress, end: progress),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: AppColors.background,
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStar(int starNumber, bool isActive) {
    return Icon(
      isActive ? Icons.star_rounded : Icons.star_outline_rounded,
      size: 20,
      color: isActive ? AppColors.golden : Colors.black26,
    );
  }
}
