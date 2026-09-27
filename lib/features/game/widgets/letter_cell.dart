import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/grid_generator.dart';

/// বর্ণ সেল — Letter Cell Widget
/// Renders an individual Bangla letter in the word search grid with
/// rich micro-animations (spring drag, invalid shake, wave bounce).
class LetterCell extends StatelessWidget {
  final GridCell cell;
  final bool isSelected;
  final bool isWrong;
  final bool isFound;
  final bool isDimmed;
  final bool isHinted;
  final Color? foundColor;
  final int? waveBounceOrder;
  final VoidCallback? onTap;

  const LetterCell({
    super.key,
    required this.cell,
    this.isSelected = false,
    this.isWrong = false,
    this.isFound = false,
    this.isDimmed = false,
    this.isHinted = false,
    this.foundColor,
    this.waveBounceOrder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic styling based on state
    Color backgroundColor = AppColors.cellNormal;
    Color textColor = AppColors.textPrimary;
    Color borderColor = AppColors.cellBorder;
    List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];

    if (isFound) {
      backgroundColor = foundColor ?? AppColors.correct;
      textColor = Colors.white;
      borderColor = (foundColor ?? AppColors.correct).withValues(alpha: 0.85);
      shadows = [
        BoxShadow(
          color: (foundColor ?? AppColors.correct).withValues(alpha: 0.35),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
    } else if (isWrong) {
      // Feature 2: Soft crimson flash when invalid
      backgroundColor = const Color(0xFFFFCDD2);
      textColor = const Color(0xFFC62828);
      borderColor = const Color(0xFFEF5350);
      shadows = [
        BoxShadow(
          color: const Color(0xFFEF5350).withValues(alpha: 0.45),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ];
    } else if (isSelected) {
      // Feature 5: Golden glow & spring selection
      backgroundColor = AppColors.golden;
      textColor = AppColors.textOnGolden;
      borderColor = AppColors.goldenDark;
      shadows = [
        BoxShadow(
          color: AppColors.golden.withValues(alpha: 0.6),
          blurRadius: 10,
          spreadRadius: 2.5,
        ),
      ];
    } else if (isHinted) {
      backgroundColor = AppColors.goldenLight;
      borderColor = AppColors.golden;
      textColor = AppColors.earthyBrown;
    }

    Widget cellWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutBack,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isSelected || isHinted || isWrong ? 2.5 : 1.5,
        ),
        boxShadow: shadows,
      ),
      alignment: Alignment.center,
      child: Text(
        cell.letter,
        style: GoogleFonts.hindSiliguri(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );

    // Apply animations
    if (isWrong) {
      // Feature 2: Invalid word shake
      cellWidget = cellWidget
          .animate(key: const ValueKey('cell_wrong_shake'))
          .shake(duration: 400.ms, hz: 4, offset: const Offset(5, 0));
    } else if (waveBounceOrder != null) {
      // Feature 1: Word Found staggered wave bounce & shimmer
      cellWidget = cellWidget
          .animate(key: ValueKey('cell_wave_${waveBounceOrder}_${cell.letter}'))
          .scale(
            delay: (waveBounceOrder! * 65).ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.24, 1.24),
            duration: 200.ms,
            curve: Curves.easeOutBack,
          )
          .then()
          .scale(
            begin: const Offset(1.24, 1.24),
            end: const Offset(1.0, 1.0),
            duration: 180.ms,
            curve: Curves.easeIn,
          )
          .shimmer(
            delay: (waveBounceOrder! * 65).ms,
            duration: 450.ms,
            color: Colors.white70,
          );
    } else if (isSelected) {
      // Feature 5: Spring Scale Up during drag
      cellWidget = cellWidget
          .animate(target: 1)
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.14, 1.14),
            duration: 150.ms,
            curve: Curves.easeOutBack,
          );
    } else if (isHinted) {
      cellWidget = cellWidget
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.12, 1.12),
            duration: 500.ms,
          );
    }

    if (isDimmed) {
      cellWidget = Opacity(
        opacity: 0.25,
        child: cellWidget,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: cellWidget,
      ),
    );
  }
}
