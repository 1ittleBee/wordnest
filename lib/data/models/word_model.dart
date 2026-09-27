/// বাংলা শব্দ মডেল — Bangla Word Model
/// Represents a single Bangla word with its meaning and example
class BanglaWord {
  /// The Bangla word (e.g., "গাছ")
  final String word;

  /// Meaning/definition in Bangla (e.g., "যে উদ্ভিদ মাটিতে শিকড় গেড়ে বড় হয়")
  final String meaning;

  /// Example sentence in Bangla (e.g., "আমাদের বাগানে একটি বড় গাছ আছে।")
  final String exampleSentence;

  const BanglaWord({
    required this.word,
    required this.meaning,
    required this.exampleSentence,
  });

  factory BanglaWord.fromJson(Map<String, dynamic> json) {
    return BanglaWord(
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      exampleSentence: json['example'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'meaning': meaning,
        'example': exampleSentence,
      };
}
