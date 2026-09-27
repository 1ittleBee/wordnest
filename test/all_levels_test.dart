import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('All 8 Chapters & 160 Levels Verification', () {
    test('Verifies all 8 chapter JSON files exist and have 20 levels each', () {
      int totalLevels = 0;

      for (int i = 1; i <= 8; i++) {
        final file = File('assets/data/levels/chapter_$i.json');
        expect(file.existsSync(), isTrue, reason: 'chapter_$i.json should exist');

        final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        final banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
        expect(json['division'], equals('অধ্যায় ${banglaDigits[i]}'));
        expect(json['divisionKey'], equals('chapter_$i'));

        final levels = json['levels'] as List;
        expect(levels.length, equals(20), reason: 'Chapter $i should have exactly 20 levels');

        final expectedStartId = (i - 1) * 20 + 1;
        final expectedEndId = i * 20;

        for (int j = 0; j < levels.length; j++) {
          final level = levels[j] as Map<String, dynamic>;
          final id = level['id'] as int;
          expect(id, equals(expectedStartId + j));

          final category = level['category'] as String?;
          expect(category, isNotNull);
          expect(category!.isNotEmpty, isTrue);

          final words = level['words'] as List;
          expect(words.isNotEmpty, isTrue);

          for (final w in words) {
            final wordObj = w as Map<String, dynamic>;
            final word = wordObj['word'] as String?;
            final meaning = wordObj['meaning'] as String?;
            final example = wordObj['example'] as String?;

            if (word == null || meaning == null || example == null) {
              fail('Failed at Chapter $i, Level $id, wordObj: $wordObj');
            }
          }
          totalLevels++;
        }
      }

      expect(totalLevels, equals(160));
    });
  });
}
