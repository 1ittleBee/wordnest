import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/grid_generator.dart';

/// বর্ণ সেল — Letter Cell Widget
/// Renders an individual Bangla letter in the word search grid
class LetterCell extends StatelessWidget {
  final GridCell cell;
  final bool isSelected;
  final bool isFound;
  final bool isDimmed;
  final bool isHinted;
  final Color? foundColor;
  final VoidCallback? onTap;

  const LetterCell({
    super.key,
    required this.cell,
    this.isSelected = false,
    this.isFound = false,
    this.isDimmed = false,
    this.isHinted = false,
    this.foundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic styling based on state
    Color backgroundColor = AppColors.cellNormal;
    Color textColor = AppColors.textPrimary;
    Color borderColor = AppColors.cellBorder;
    double elevation = 2;
    List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];

    if (isFound) {
      backgroundColor = foundColor ?? AppColors.correct;
      textColor = Colors.white;
      borderColor = (foundColor ?? AppColors.correct).withOpacity(0.8);
      elevation = 4;
    } else if (isSelected) {
      backgroundColor = AppColors.golden;
      textColor = AppColors.textOnGolden;
      borderColor = AppColors.goldenDark;
      elevation = 6;
      shadows = [
        BoxShadow(
          color: AppColors.golden.withOpacity(0.5),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ];
    } else if (isHinted) {
      backgroundColor = AppColors.goldenLight;
      borderColor = AppColors.golden;
      textColor = AppColors.earthyBrown;
    }

    Widget cellWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isSelected || isHinted ? 2.5 : 1.5,
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
    if (isSelected) {
      cellWidget = cellWidget
          .animate(target: 1)
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.08, 1.08),
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
