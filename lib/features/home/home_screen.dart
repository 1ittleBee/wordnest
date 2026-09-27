import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/extensions/string_extensions.dart';
import '../../data/models/player_progress.dart';
import '../../data/repositories/level_repository.dart';
import '../achievements/achievements_screen.dart';
import '../daily_challenge/daily_challenge_screen.dart';
import '../game/game_screen.dart';
import '../game/providers/game_provider.dart';
import '../map/map_screen.dart';
import '../settings/settings_screen.dart';
import '../stats/stats_screen.dart';

/// হোম স্ক্রিন — Main Home Screen
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _startCurrentGame(BuildContext context, PlayerProgress progress) async {
    final repo = LevelRepository();
    final nextLevelId = progress.completedLevels.length + 1;
    final level = await repo.getLevelById(nextLevelId) ??
        await repo.getLevelById(1);

    if (context.mounted && level != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GameScreen(level: level),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);
    final completedCount = progress.completedLevels.length.toBanglaDigits();
    final coins = progress.coins.toBanglaDigits();
    final streak = progress.currentStreak.toBanglaDigits();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Profile & Stat Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Streak Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.accentOrange.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          '$streak দিনের ধারাবাহিকতা',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Coins & Settings
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.goldenLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.golden, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(
                              coins,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.earthyBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.settings_rounded,
                            size: 20,
                            color: AppColors.earthyBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Hero Mascot Greeting Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'স্বাগতম বন্ধু! 🌿',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'শব্দ খোঁজের রোমাঞ্চকর ভ্রমণ',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'সম্পন্ন লেভেল: $completedCount টি',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Cute Tuntuni Mascot Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(0, -2),
                          child: Transform.flip(
                            flipX: true,
                            child: const Text(
                              '🐦',
                              style: TextStyle(
                                fontSize: 44,
                                height: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(begin: 0, end: -6, duration: 1000.ms),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Big "Play Game" Main Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () => _startCurrentGame(context, progress),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.golden,
                      elevation: 6,
                      shadowColor: AppColors.golden.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded,
                            size: 36, color: AppColors.textOnGolden),
                        const SizedBox(width: 8),
                        Text(
                          'খেলা শুরু করুন',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textOnGolden,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 1200.ms),
              const SizedBox(height: 24),

              // Feature Navigation Grid
              Row(
                children: [
                  // Chapter / World Map Card
                  Expanded(
                    child: _buildHomeCard(
                      context: context,
                      title: 'অধ্যায় মানচিত্র',
                      subtitle: 'শব্দ সাম্রাজ্যের বিশ্ব',
                      icon: '🗺️',
                      color: AppColors.skyBlueLight,
                      borderColor: AppColors.skyBlue,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MapScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Daily Challenge Card
                  Expanded(
                    child: _buildHomeCard(
                      context: context,
                      title: 'দৈনিক চ্যালেঞ্জ',
                      subtitle: '+১০০ কয়েন বোনাস',
                      icon: '📅',
                      color: AppColors.softPinkLight,
                      borderColor: AppColors.softPink,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DailyChallengeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  // Achievements Card
                  Expanded(
                    child: _buildHomeCard(
                      context: context,
                      title: 'অর্জন ও ব্যাজ',
                      subtitle: 'পদক সংগ্রহ করুন',
                      icon: '🏆',
                      color: AppColors.goldenLight,
                      borderColor: AppColors.golden,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AchievementsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Statistics Card
                  Expanded(
                    child: _buildHomeCard(
                      context: context,
                      title: 'পরিসংখ্যান',
                      subtitle: 'আপনার অগ্রগতি',
                      icon: '📊',
                      color: AppColors.primaryLight.withOpacity(0.4),
                      borderColor: AppColors.primary,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const StatsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.hindSiliguri(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
