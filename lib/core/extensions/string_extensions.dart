/// বাংলা সংখ্যা রূপান্তর — Extension to convert numbers to Bangla digits
extension BanglaNumberExtension on num {
  /// Convert an integer or double to Bangla numeral string
  /// Example: 123 -> ১২৩
  String toBanglaDigits() {
    const englishToBangla = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };

    return toString().split('').map((char) => englishToBangla[char] ?? char).join();
  }
}

/// স্ট্রিং এক্সটেনশন — String Extensions
extension BanglaStringExtension on String {
  /// Convert any English digits inside string to Bangla digits
  String toBanglaDigits() {
    const englishToBangla = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };

    return split('').map((char) => englishToBangla[char] ?? char).join();
  }
}
