import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/player_progress.dart';

/// Hive Local Storage Service
/// Handles all local data persistence
class HiveService {
  static const String _progressBoxName = 'progress';
  static const String _settingsBoxName = 'settings';
  static const String _progressKey = 'player_progress';

  static late Box _progressBox;
  static late Box _settingsBox;

  /// Initialize Hive and open boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    _progressBox = await Hive.openBox(_progressBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // === Player Progress ===

  /// Save player progress
  static Future<void> saveProgress(PlayerProgress progress) async {
    await _progressBox.put(_progressKey, jsonEncode(progress.toJson()));
  }

  /// Load player progress (returns default if none exists)
  static PlayerProgress loadProgress() {
    final data = _progressBox.get(_progressKey);
    if (data == null) return PlayerProgress();
    try {
      return PlayerProgress.fromJson(
        jsonDecode(data as String) as Map<String, dynamic>,
      );
    } catch (_) {
      return PlayerProgress();
    }
  }

  // === Settings ===

  /// Get a setting value
  static T? getSetting<T>(String key) {
    return _settingsBox.get(key) as T?;
  }

  /// Set a setting value
  static Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Sound enabled (default: true)
  static bool get isSoundEnabled =>
      _settingsBox.get('sound_enabled', defaultValue: true) as bool;

  static Future<void> setSoundEnabled(bool value) async {
    await _settingsBox.put('sound_enabled', value);
  }

  /// Music enabled (default: false — quiet startup)
  static bool get isMusicEnabled =>
      _settingsBox.get('music_enabled', defaultValue: false) as bool;

  static Future<void> setMusicEnabled(bool value) async {
    await _settingsBox.put('music_enabled', value);
  }
}
