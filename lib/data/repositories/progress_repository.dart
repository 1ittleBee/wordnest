import '../local/hive_service.dart';
import '../models/player_progress.dart';

/// রিপোজিটরি — Player Progress Repository
/// Manages loading and persisting player data and preferences
class ProgressRepository {
  /// Load the current progress
  PlayerProgress getProgress() {
    return HiveService.loadProgress();
  }

  /// Save progress
  Future<void> saveProgress(PlayerProgress progress) async {
    await HiveService.saveProgress(progress);
  }

  /// Add coins
  Future<PlayerProgress> addCoins(int amount) async {
    final current = getProgress();
    current.coins += amount;
    await HiveService.saveProgress(current);
    return current;
  }

  /// Deduct coins (returns false if not enough)
  Future<bool> spendCoins(int amount) async {
    final current = getProgress();
    if (current.coins < amount) return false;
    current.coins -= amount;
    await HiveService.saveProgress(current);
    return true;
  }

  /// Complete a level and update stats
  Future<PlayerProgress> completeLevel({
    required int levelId,
    required int stars,
    required int coinsEarned,
  }) async {
    final current = getProgress();
    current.completeLevel(levelId: levelId, stars: stars, coinsEarned: coinsEarned);
    await HiveService.saveProgress(current);
    return current;
  }
}
