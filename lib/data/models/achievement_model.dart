/// অর্জন মডেল — Achievement Model
/// Represents an in-game achievement/badge for the player
class Achievement {
  /// Unique identifier (e.g. 'first_word', 'chapter_1_master')
  final String id;

  /// Bangla display name
  final String title;

  /// Bangla description of how to unlock
  final String description;

  /// Icon or emoji representing the achievement
  final String icon;

  /// Coin reward upon unlocking
  final int rewardCoins;

  /// Whether the achievement has been unlocked
  final bool isUnlocked;

  /// Timestamp when unlocked
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.rewardCoins = 50,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? rewardCoins,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'icon': icon,
        'rewardCoins': rewardCoins,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      rewardCoins: json['rewardCoins'] as int? ?? 50,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'] as String)
          : null,
    );
  }

  /// Default list of all game achievements
  static List<Achievement> get defaultAchievements => const [
        Achievement(
          id: 'novice',
          title: 'নবীন সন্ধানকারী',
          description: 'প্রথম লেভেল সম্পন্ন করুন',
          icon: '🌱',
          rewardCoins: 30,
        ),
        Achievement(
          id: 'word_hunter_10',
          title: 'শব্দ শিকারী',
          description: 'মোট ১০টি শব্দ খুঁজে বের করুন',
          icon: '🏹',
          rewardCoins: 50,
        ),
        Achievement(
          id: 'chapter_1_explorer',
          title: 'অধ্যায় অভিযাত্রী',
          description: 'প্রথম অধ্যায়ের ৫টি লেভেল সম্পূর্ণ করুন',
          icon: '🌿',
          rewardCoins: 80,
        ),
        Achievement(
          id: 'chapter_1_master',
          title: 'অধ্যায় চ্যাম্পিয়ন',
          description: 'প্রথম অধ্যায়ের সব লেভেল সম্পূর্ণ করুন',
          icon: '👑',
          rewardCoins: 200,
        ),
        Achievement(
          id: 'streak_3',
          title: 'ধারাবাহিক সাধক',
          description: 'টানা ৩ দিন খেলুন',
          icon: '🔥',
          rewardCoins: 100,
        ),
        Achievement(
          id: 'perfect_finder',
          title: 'নিখুঁত খেলোয়াড়',
          description: 'কোনো সাহায্য (Hint) ছাড়া লেভেল সম্পূর্ণ করুন',
          icon: '✨',
          rewardCoins: 60,
        ),
        Achievement(
          id: 'vocabulary_master',
          title: 'শব্দকোষ সম্রাট',
          description: '৫০টি শব্দের অর্থ জেনে নিন',
          icon: '📚',
          rewardCoins: 150,
        ),
        Achievement(
          id: 'bird_friend',
          title: 'টুনটুনির প্রিয় বন্ধু',
          description: 'টুনটুনি মাসকট দিয়ে ১০টি সাহায্য নিন',
          icon: '🐦',
          rewardCoins: 50,
        ),
      ];
}
