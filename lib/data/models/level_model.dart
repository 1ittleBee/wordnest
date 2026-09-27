import '../../core/extensions/string_extensions.dart';
import 'word_model.dart';

/// কঠিনতার মাত্রা — Difficulty levels
enum Difficulty {
  easy,    // সহজ — 4x4 grid, 2-3 words
  medium,  // মাঝারি — 5x5 grid, 3-5 words
  hard,    // কঠিন — 6x6+ grid, 5-7 words
}

/// লেভেল মডেল — Level Model
/// Represents a single game level with category, words, and grid config
class Level {
  /// Unique level ID
  final int id;

  /// Division name (e.g., "ঢাকা", "চট্টগ্রাম")
  final String division;

  /// Category name in Bangla (e.g., "প্রকৃতি", "খাবার")
  final String category;

  /// Category emoji icon
  final String categoryIcon;

  /// List of target words to find
  final List<BanglaWord> targetWords;

  /// Grid size (4 = 4x4, 5 = 5x5, etc.)
  final int gridSize;

  /// Difficulty level
  final Difficulty difficulty;

  const Level({
    required this.id,
    required this.division,
    required this.category,
    required this.categoryIcon,
    required this.targetWords,
    required this.gridSize,
    required this.difficulty,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] as int,
      division: json['division'] as String,
      category: json['category'] as String,
      categoryIcon: json['categoryIcon'] as String,
      targetWords: (json['words'] as List)
          .map((w) => BanglaWord.fromJson(w as Map<String, dynamic>))
          .toList(),
      gridSize: json['gridSize'] as int,
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => Difficulty.easy,
      ),
    );
  }

  /// Chapter name based on 20 levels per chapter (e.g., "অধ্যায় ১")
  String get chapterName {
    final chapterNum = ((id - 1) ~/ 20) + 1;
    return 'অধ্যায় $chapterNum'.toBanglaDigits();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'division': division,
        'category': category,
        'categoryIcon': categoryIcon,
        'words': targetWords.map((w) => w.toJson()).toList(),
        'gridSize': gridSize,
        'difficulty': difficulty.name,
      };
}
