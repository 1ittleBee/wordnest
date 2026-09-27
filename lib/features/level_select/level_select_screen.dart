import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/extensions/string_extensions.dart';
import '../../data/models/level_model.dart';
import '../../data/repositories/level_repository.dart';
import '../game/game_screen.dart';
import '../game/providers/game_provider.dart';

/// লেভেল নির্বাচন স্ক্রিন — Level Selection Screen
/// Displays 20 levels per division with star ratings and locked states
class LevelSelectScreen extends ConsumerStatefulWidget {
  final String divisionKey;
  final String divisionName;
  final String divisionIcon;
  final int divisionIndex;

  const LevelSelectScreen({
    super.key,
    required this.divisionKey,
    required this.divisionName,
    required this.divisionIcon,
    required this.divisionIndex,
  });

  @override
  ConsumerState<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends ConsumerState<LevelSelectScreen> {
  final LevelRepository _levelRepo = LevelRepository();
  List<Level> _levels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  void _loadLevels() async {
    final levels = await _levelRepo.getLevelsByDivision(widget.divisionKey);
    if (mounted) {
      setState(() {
        _levels = levels;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(playerProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.divisionIcon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              widget.divisionName,
              style: GoogleFonts.hindSiliguri(
                fontWeight: FontWeight.w700,
                fontSize: 19,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _levels.isEmpty
              ? Center(
                  child: Text(
                    'শীঘ্রই আসছে নতুন লেভেল...',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _levels.length,
                  itemBuilder: (context, index) {
                    final level = _levels[index];
                    final isCompleted = progress.completedLevels.contains(level.id);
                    // Next available level or previously completed
                    final isUnlocked = level.id == 1 ||
                        progress.completedLevels.contains(level.id) ||
                        progress.completedLevels.contains(level.id - 1);
                    final stars = progress.levelStars[level.id] ?? 0;
                    final levelNum = level.id.toBanglaDigits();

                    return InkWell(
                      onTap: isUnlocked
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GameScreen(level: level),
                                ),
                              );
                            }
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isUnlocked ? Colors.white : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isCompleted
                                ? AppColors.golden
                                : (isUnlocked ? AppColors.primary : Colors.grey.shade300),
                            width: isCompleted || isUnlocked ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isUnlocked ? 0.06 : 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isUnlocked) ...[
                              Text(
                                level.categoryIcon,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                levelNum,
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Star rating row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (starIdx) {
                                  return Icon(
                                    starIdx < stars
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 16,
                                    color: starIdx < stars
                                        ? AppColors.golden
                                        : Colors.grey.shade300,
                                  );
                                }),
                              ),
                            ] else ...[
                              const Icon(
                                Icons.lock_outline_rounded,
                                size: 30,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                levelNum,
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
