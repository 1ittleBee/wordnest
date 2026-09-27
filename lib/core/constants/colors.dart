import 'package:flutter/material.dart';

/// WordNest Color Palette — বাংলা সাংস্কৃতিক থিম
/// Inspired by Bangladesh's nature, art, and traditions
class AppColors {
  AppColors._();

  // === Primary Colors ===
  /// সবুজ (Leafy Green) — Primary brand color
  static const Color primary = Color(0xFF2D6A4F);
  static const Color primaryLight = Color(0xFF40916C);
  static const Color primaryDark = Color(0xFF1B4332);

  // === Accent Colors ===
  /// সোনালি (Golden) — Coins, highlights, celebrations
  static const Color golden = Color(0xFFE9C46A);
  static const Color goldenLight = Color(0xFFF4D58D);
  static const Color goldenDark = Color(0xFFD4A03C);

  /// কমলা (Accent Orange) — Streaks, fiery highlights
  static const Color accentOrange = Color(0xFFE76F51);

  // === Warm Tones ===
  /// মাটি (Earthy Brown) — Text, borders, grid frame
  static const Color earthyBrown = Color(0xFF6B4226);
  static const Color earthyBrownLight = Color(0xFF8B6242);
  static const Color earthyBrownDark = Color(0xFF4A2C17);

  // === Soft Tones ===
  /// গোলাপি (Soft Pink) — Selected letters, celebration
  static const Color softPink = Color(0xFFF4A0A0);
  static const Color softPinkLight = Color(0xFFFFC1C1);

  /// ক্রিম (Cream) — Grid background, cards
  static const Color cream = Color(0xFFFFF8E7);
  static const Color creamDark = Color(0xFFF5ECD0);
  static const Color cardBg = Color(0xFFFFFBF2);

  /// আকাশি (Sky Blue) — Secondary accents
  static const Color skyBlue = Color(0xFF89CFF0);
  static const Color skyBlueLight = Color(0xFFB0DFFF);

  /// হালকা সবুজ (Light Green) — Background gradients
  static const Color lightGreen = Color(0xFFB7E4C7);
  static const Color lightGreenSoft = Color(0xFFD8F3DC);

  // === UI Colors ===
  static const Color background = Color(0xFFF0F7F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F0E8);

  // === Cell & Grid Plate Colors ===
  static const Color cellNormal = Color(0xFFFFFBF2);
  static const Color cellBorder = Color(0xFFE2D6C0);
  static const Color woodPlate = Color(0xFFECE0CA);
  static const Color woodPlateBorder = Color(0xFF8B6242);

  // === Text Colors ===
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF4A4A6A);
  static const Color textLight = Color(0xFF8A8AAA);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnGolden = Color(0xFF4A2C17);

  // === Game State Colors ===
  static const Color correct = Color(0xFF2D6A4F);
  static const Color wrong = Color(0xFFE63946);
  static const Color selected = Color(0xFFE9C46A);
  static const Color found = Color(0xFF40916C);
  static const Color hint = Color(0xFF89CFF0);
  static const Color locked = Color(0xFFBDBDBD);

  // === Star Colors ===
  static const Color starFilled = Color(0xFFFFD700);
  static const Color starEmpty = Color(0xFFD0D0D0);

  // === Gradients ===
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const LinearGradient goldenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldenLight, golden],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightGreenSoft, cream],
  );

  static const LinearGradient gameBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8F5E8), Color(0xFFFFF8E7)],
  );
}
