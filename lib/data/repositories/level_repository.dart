import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/level_model.dart';

/// লেভেল রিপোজিটরি — Level Repository
/// Loads level configurations and word lists from local asset files
class LevelRepository {
  /// Cache of loaded levels by division
  final Map<String, List<Level>> _cachedLevels = {};

  /// All 8 Chapters / Worlds supported in WordNest (Ring of Words / Wordscapes style)
  static const List<Map<String, String>> chapters = [
    {
      'name': 'প্রকৃতি ও সূচনা',
      'chapter': 'অধ্যায় ১',
      'key': 'nature',
      'icon': '🌿',
      'file': 'chapter_1',
      'range': '১ - ২০',
      'description': 'গাছপালা, পরিবার ও রঙিন জগতের শব্দ',
    },
    {
      'name': 'পাহাড় ও নদী',
      'chapter': 'অধ্যায় ২',
      'key': 'hills_rivers',
      'icon': '⛰️',
      'file': 'chapter_2',
      'range': '২১ - ৪০',
      'description': 'পাহাড়, সাগর ও জলপ্রপাতের শব্দ',
    },
    {
      'name': 'চা-বাগান ও অরণ্য',
      'chapter': 'অধ্যায় ৩',
      'key': 'forest',
      'icon': '🍵',
      'file': 'chapter_3',
      'range': '৪১ - ৬০',
      'description': 'সবুজ চা-বাগান ও শ্যামল বনের শব্দ',
    },
    {
      'name': 'ফলমূল ও ঋতুরাজ',
      'chapter': 'অধ্যায় ৪',
      'key': 'seasons',
      'icon': '🥭',
      'file': 'chapter_4',
      'range': '৬১ - ৮০',
      'description': 'রসালো ফল ও ঋতুচক্রের শব্দ',
    },
    {
      'name': 'বন্যপ্রাণী ও সুন্দরবন',
      'chapter': 'অধ্যায় ৫',
      'key': 'wildlife',
      'icon': '🐅',
      'file': 'chapter_5',
      'range': '৮১ - ১০০',
      'description': 'হরিণ, বাঘ ও অরণ্যের রোমাঞ্চকর শব্দ',
    },
    {
      'name': 'নদীমাতৃক ও পালতোলা',
      'chapter': 'অধ্যায় ৬',
      'key': 'rivers',
      'icon': '⛵',
      'file': 'chapter_6',
      'range': '১০১ - ১২০',
      'description': 'নৌকা, নদী ও রূপসী বাংলার শব্দ',
    },
    {
      'name': 'সোনালী ধান ও পল্লীগান',
      'chapter': 'অধ্যায় ৭',
      'key': 'village',
      'icon': '🌾',
      'file': 'chapter_7',
      'range': '১২১ - ১৪০',
      'description': 'সোনালী ধানক্ষেত ও গাঁও-গেরামের শব্দ',
    },
    {
      'name': 'শিল্প, সুর ও সংস্কৃতি',
      'chapter': 'অধ্যায় ৮',
      'key': 'culture',
      'icon': '🎨',
      'file': 'chapter_8',
      'range': '১৪১ - ১৬০',
      'description': 'শিল্প, সাহিত্য ও সংস্কৃতির মাধুর্য',
    },
  ];

  /// Backward-compatibility alias for divisions
  static List<Map<String, String>> get divisions => chapters;

  /// Load all levels for a specific division/chapter
  Future<List<Level>> getLevelsByDivision(String divisionKey) async {
    if (_cachedLevels.containsKey(divisionKey)) {
      return _cachedLevels[divisionKey]!;
    }

    // Map chapter key to corresponding json file if present
    String fileName = divisionKey;
    final matchingChapter = chapters.where((c) => c['key'] == divisionKey).firstOrNull;
    if (matchingChapter != null && matchingChapter['file'] != null) {
      fileName = matchingChapter['file']!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/levels/$fileName.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> levelList = data['levels'] as List<dynamic>;

      final levels = levelList
          .map((item) => Level.fromJson(item as Map<String, dynamic>))
          .toList();

      _cachedLevels[divisionKey] = levels;
      return levels;
    } catch (e) {
      // If asset file doesn't exist yet, fallback to chapter 1
      if (fileName != 'chapter_1') {
        return getLevelsByDivision('nature');
      }
      return [];
    }
  }

  /// Get a single level by ID across all chapters (Levels 1 to 160)
  Future<Level?> getLevelById(int levelId) async {
    // Fast path: calculate target chapter by 20 levels per chapter
    final chapterIndex = ((levelId - 1) ~/ 20).clamp(0, chapters.length - 1);
    final targetChapterKey = chapters[chapterIndex]['key']!;
    final levels = await getLevelsByDivision(targetChapterKey);
    for (final level in levels) {
      if (level.id == levelId) return level;
    }

    // Comprehensive fallback across all chapters
    for (final ch in chapters) {
      final key = ch['key']!;
      final chLevels = await getLevelsByDivision(key);
      for (final level in chLevels) {
        if (level.id == levelId) return level;
      }
    }
    return null;
  }
}
