import 'package:flutter_test/flutter_test.dart';
import 'package:wordnest/core/utils/bangla_utils.dart';

void main() {
  test('Bangla grapheme cluster splitting test', () {
    final words = BanglaUtils.splitWord('প্রকৃতি');
    expect(words, equals(['প্র', 'কৃ', 'তি']));

    final family = BanglaUtils.splitWord('পরিবার');
    expect(family, equals(['প', 'রি', 'বা', 'র']));

    final conjunct = BanglaUtils.splitWord('বিজ্ঞান');
    expect(conjunct, equals(['বি', 'জ্ঞা', 'ন']));
  });
}
