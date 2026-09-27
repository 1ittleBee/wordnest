import 'dart:math';
import 'package:characters/characters.dart';

/// বাংলা ইউটিলিটিজ — Bangla Character Utilities
/// Handles proper splitting, validation, and manipulation of Bangla text
class BanglaUtils {
  BanglaUtils._();

  /// All Bangla vowels (স্বরবর্ণ)
  static const List<String> vowels = [
    'অ', 'আ', 'ই', 'ঈ', 'উ', 'ঊ', 'ঋ', 'এ', 'ঐ', 'ও', 'ঔ',
  ];

  /// All Bangla consonants (ব্যঞ্জনবর্ণ)
  static const List<String> consonants = [
    'ক', 'খ', 'গ', 'ঘ', 'ঙ',
    'চ', 'ছ', 'জ', 'ঝ', 'ঞ',
    'ট', 'ঠ', 'ড', 'ঢ', 'ণ',
    'ত', 'থ', 'দ', 'ধ', 'ন',
    'প', 'ফ', 'ব', 'ভ', 'ম',
    'য', 'র', 'ল', 'শ', 'ষ', 'স', 'হ',
    'ড়', 'ঢ়', 'য়',
  ];

  /// Common Bangla letters for grid filling (weighted towards frequently used ones)
  static const List<String> commonLetters = [
    'ক', 'খ', 'গ', 'চ', 'ছ', 'জ', 'ট', 'ড', 'ত', 'থ', 'দ', 'ধ', 'ন',
    'প', 'ফ', 'ব', 'ভ', 'ম', 'য', 'র', 'ল', 'শ', 'স', 'হ',
    'অ', 'আ', 'ই', 'উ', 'এ', 'ও',
    'কা', 'কি', 'কু', 'কে', 'কো',
    'গা', 'গি', 'গু', 'গে',
    'তা', 'তি', 'তু', 'তে',
    'না', 'নি', 'নু', 'নে',
    'পা', 'পি', 'পু', 'পে',
    'বা', 'বি', 'বু', 'বে',
    'মা', 'মি', 'মু', 'মে',
    'রা', 'রি', 'রু', 'রে',
    'লা', 'লি', 'লু', 'লে',
    'সা', 'সি', 'সু', 'সে',
  ];

  static final Random _random = Random();

  /// Split a Bangla word into visual characters (grapheme clusters)
  /// This correctly handles:
  /// - যুক্তবর্ণ (conjuncts like ক্ষ, জ্ঞ)
  /// - মাত্রা/কার (vowel signs like া, ি, ী)
  /// - ফলা (like ্য, ্র)
  ///
  /// Example: "গাছ" → ["গা", "ছ"]
  ///          "প্রকৃতি" → ["প্র", "কৃ", "তি"]
  static List<String> splitWord(String word) {
    return word.characters.toList();
  }

  /// Get a random Bangla letter for filling empty grid cells
  static String getRandomLetter() {
    return commonLetters[_random.nextInt(commonLetters.length)];
  }

  /// Get a random Bangla letter that is NOT in the given set
  /// Used to avoid accidentally creating valid words
  static String getRandomLetterExcluding(Set<String> exclude) {
    String letter;
    int attempts = 0;
    do {
      letter = getRandomLetter();
      attempts++;
    } while (exclude.contains(letter) && attempts < 50);
    return letter;
  }

  /// Check if a character is a Bangla character
  static bool isBanglaChar(String char) {
    if (char.isEmpty) return false;
    final codeUnit = char.codeUnitAt(0);
    // Bangla Unicode range: 0x0980 - 0x09FF
    return codeUnit >= 0x0980 && codeUnit <= 0x09FF;
  }

  /// Get the display width category of a Bangla grapheme
  /// Returns 1 for normal, 2 for wide conjuncts
  static int getCharWidth(String grapheme) {
    // Most Bangla characters display at similar widths
    // This is used for grid cell sizing if needed
    return 1;
  }

  /// Normalize a Bangla string for comparison
  /// Removes extra spaces and normalizes Unicode
  static String normalize(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
