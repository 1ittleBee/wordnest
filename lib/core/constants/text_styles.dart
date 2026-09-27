import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// WordNest Typography — বাংলা টাইপোগ্রাফি
/// Uses Hind Siliguri for beautiful Bangla text rendering
class AppTextStyles {
  AppTextStyles._();

  // === Base Font Family ===
  static String get _fontFamily => GoogleFonts.hindSiliguri().fontFamily!;

  // === Display / Logo ===
  static TextStyle get displayLarge => GoogleFonts.hindSiliguri(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.hindSiliguri(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // === Headings ===
  static TextStyle get headlineLarge => GoogleFonts.hindSiliguri(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.hindSiliguri(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.hindSiliguri(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // === Title ===
  static TextStyle get titleLarge => GoogleFonts.hindSiliguri(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.hindSiliguri(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.hindSiliguri(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  // === Body ===
  static TextStyle get bodyLarge => GoogleFonts.hindSiliguri(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.hindSiliguri(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.hindSiliguri(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
      );

  // === Game-Specific ===
  /// Grid letter style — extra bold, large for readability
  static TextStyle get gridLetter => GoogleFonts.hindSiliguri(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.earthyBrown,
      );

  /// Grid letter when selected
  static TextStyle get gridLetterSelected => GoogleFonts.hindSiliguri(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
      );

  /// Grid letter when found
  static TextStyle get gridLetterFound => GoogleFonts.hindSiliguri(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.found.withValues(alpha: 0.5),
      );

  /// Category banner text
  static TextStyle get categoryBanner => GoogleFonts.hindSiliguri(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
        letterSpacing: 1.2,
      );

  /// Word list item (target words)
  static TextStyle get wordListItem => GoogleFonts.hindSiliguri(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.earthyBrown,
      );

  /// Word list item when found (strikethrough)
  static TextStyle get wordListItemFound => GoogleFonts.hindSiliguri(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.found,
        decoration: TextDecoration.lineThrough,
        decorationColor: AppColors.found,
        decorationThickness: 2.5,
      );

  /// Level number
  static TextStyle get levelNumber => GoogleFonts.hindSiliguri(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
      );

  /// Coin count display
  static TextStyle get coinCount => GoogleFonts.hindSiliguri(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.goldenDark,
      );

  /// Button text
  static TextStyle get buttonText => GoogleFonts.hindSiliguri(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
      );

  /// Button text small
  static TextStyle get buttonTextSmall => GoogleFonts.hindSiliguri(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
      );
}
