/// প্লেয়ার প্রগ্রেস — Player Progress Model
/// Tracks the player's journey through the game
class PlayerProgress {
  /// Total coins earned
  int coins;

  /// Current chapter index (0 = অধ্যায় ১)
  int currentDivisionIndex;

  /// Map of levelId -> stars earned (0-3)
  Map<int, int> levelStars;

  /// Set of completed level IDs
  Set<int> completedLevels;

  /// Total words found across all levels
  int totalWordsFound;

  /// Current daily streak count
  int dailyStreak;

  /// Last daily challenge completion date (ISO string)
  String? lastDailyChallengeDate;

  /// Set of unlocked achievement IDs
  Set<String> unlockedAchievements;

  /// Total hints used
  int totalHintsUsed;

  /// Total time played in seconds
  int totalTimePlayedSeconds;

  /// Map of levelId -> remaining free tries (defaults to 3 per level)
  Map<int, int> levelFreeTries;

  PlayerProgress({
    this.coins = 200, // Start with 200 coins
    this.currentDivisionIndex = 0,
    Map<int, int>? levelStars,
    Set<int>? completedLevels,
    this.totalWordsFound = 0,
    this.dailyStreak = 1,
    this.lastDailyChallengeDate,
    Set<String>? unlockedAchievements,
    this.totalHintsUsed = 0,
    this.totalTimePlayedSeconds = 0,
    Map<int, int>? levelFreeTries,
  })  : levelStars = levelStars ?? {},
        completedLevels = completedLevels ?? {},
        unlockedAchievements = unlockedAchievements ?? {},
        levelFreeTries = levelFreeTries ?? {};

  /// Get stars for a specific level
  int getStars(int levelId) => levelStars[levelId] ?? 0;

  /// Check if a level is completed
  bool isLevelCompleted(int levelId) => completedLevels.contains(levelId);

  /// Get total stars earned
  int get totalStars => levelStars.values.fold(0, (sum, s) => sum + s);

  /// Convenient aliases
  Map<int, int> get stars => levelStars;
  int get currentStreak => dailyStreak;
  int get currentDivision => currentDivisionIndex;

  /// Get remaining free tries for a level (defaults to 3)
  int getFreeTries(int levelId) => levelFreeTries[levelId] ?? 3;

  /// Consume one free try for a level
  int consumeFreeTry(int levelId) {
    final current = getFreeTries(levelId);
    final remaining = (current - 1).clamp(0, 3);
    levelFreeTries[levelId] = remaining;
    return remaining;
  }

  /// Reset free tries for a level (e.g. after level completion or 10-coin retry)
  void resetFreeTries(int levelId) {
    levelFreeTries[levelId] = 3;
  }

  /// Complete a level and update stats
  void completeLevel({
    required int levelId,
    required int stars,
    required int coinsEarned,
  }) {
    completedLevels.add(levelId);
    resetFreeTries(levelId);
    final previousStars = levelStars[levelId] ?? 0;
    if (stars > previousStars) {
      levelStars[levelId] = stars;
    }
    coins += coinsEarned;
    // Calculate division unlocking: every 20 levels advances to next division
    final nextDivision = completedLevels.length ~/ 20;
    if (nextDivision > currentDivisionIndex && nextDivision < 8) {
      currentDivisionIndex = nextDivision;
    }
  }

  /// Chapter names in order
  static const List<String> chapters = [
    'অধ্যায় ১: প্রকৃতি ও সূচনা',
    'অধ্যায় ২: পাহাড় ও নদী',
    'অধ্যায় ৩: চা-বাগান ও অরণ্য',
    'অধ্যায় ৪: ফলমূল ও ঋতুরাজ',
    'অধ্যায় ৫: বন্যপ্রাণী ও সুন্দরবন',
    'অধ্যায় ৬: নদীমাতৃক ও পালতোলা',
    'অধ্যায় ৭: সোনালী ধান ও পল্লীগান',
    'অধ্যায় ৮: শিল্প, সুর ও সংস্কৃতি',
  ];

  /// Chapter file keys (for loading JSON)
  static const List<String> chapterKeys = [
    'chapter_1',
    'chapter_2',
    'chapter_3',
    'chapter_4',
    'chapter_5',
    'chapter_6',
    'chapter_7',
    'chapter_8',
  ];

  /// Backward compatibility aliases
  static List<String> get divisions => chapters;
  static List<String> get divisionKeys => chapterKeys;

  /// Get current chapter name
  String get currentChapterName => chapters[currentDivisionIndex.clamp(0, chapters.length - 1)];
  String get currentDivisionName => currentChapterName;

  /// Serialize to JSON map for Hive storage
  Map<String, dynamic> toJson() => {
        'coins': coins,
        'currentDivisionIndex': currentDivisionIndex,
        'levelStars': levelStars.map((k, v) => MapEntry(k.toString(), v)),
        'completedLevels': completedLevels.toList(),
        'totalWordsFound': totalWordsFound,
        'dailyStreak': dailyStreak,
        'lastDailyChallengeDate': lastDailyChallengeDate,
        'unlockedAchievements': unlockedAchievements.toList(),
        'totalHintsUsed': totalHintsUsed,
        'totalTimePlayedSeconds': totalTimePlayedSeconds,
        'levelFreeTries':
            levelFreeTries.map((k, v) => MapEntry(k.toString(), v)),
      };

  /// Deserialize from JSON map
  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    return PlayerProgress(
      coins: json['coins'] as int? ?? 200,
      currentDivisionIndex: json['currentDivisionIndex'] as int? ?? 0,
      levelStars: (json['levelStars'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(int.parse(k), v as int)) ??
          {},
      completedLevels:
          (json['completedLevels'] as List?)?.map((e) => e as int).toSet() ??
              {},
      totalWordsFound: json['totalWordsFound'] as int? ?? 0,
      dailyStreak: json['dailyStreak'] as int? ?? 1,
      lastDailyChallengeDate: json['lastDailyChallengeDate'] as String?,
      unlockedAchievements: (json['unlockedAchievements'] as List?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      totalHintsUsed: json['totalHintsUsed'] as int? ?? 0,
      totalTimePlayedSeconds: json['totalTimePlayedSeconds'] as int? ?? 0,
      levelFreeTries: (json['levelFreeTries'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(int.parse(k), v as int)) ??
          {},
    );
  }
}
