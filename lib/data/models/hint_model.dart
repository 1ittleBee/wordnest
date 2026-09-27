/// বিভিন্ন ধরণের সাহায্য — Hint Types
enum HintType {
  /// পাখির ডাক — প্রথম বর্ণ উন্মোচন (Cost: 50 coins)
  birdCall,

  /// পাতা ঝরা — ভুল বর্ণ অপসারণ (Cost: 80 coins)
  leafFall,

  /// তারার আলো — শব্দের সারি/কলাম হাইলাইট (Cost: 100 coins)
  starlight,

  /// টিয়া সাহায্য — পুরো শব্দ উন্মোচন (Cost: 200 coins)
  parrotHelper,

  /// ঘুরিয়ে দেখো — গ্রিড পুনর্বিন্যাস (বিনামূল্যে, প্রতি লেভেলে ১ বার)
  rotateShuffle,

  /// অর্থ দেখো — শব্দের অর্থ ক্লু হিসেবে প্রদর্শন (Cost: 30 coins)
  meaningClue,
}

/// তথ্যের বিবরণী — Hint metadata & cost definition
class HintInfo {
  final HintType type;
  final String title;
  final String description;
  final String icon;
  final int cost;
  final bool isFreeOnce;

  const HintInfo({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.cost,
    this.isFreeOnce = false,
  });

  static const Map<HintType, HintInfo> hints = {
    HintType.birdCall: HintInfo(
      type: HintType.birdCall,
      title: 'পাখির ডাক',
      description: 'একটি শব্দের প্রথম বর্ণ দেখাবে',
      icon: '🪺',
      cost: 50,
    ),
    HintType.leafFall: HintInfo(
      type: HintType.leafFall,
      title: 'পাতা ঝরা',
      description: 'গ্রিড থেকে ৪টি অপ্রয়োজনীয় বর্ণ সরিয়ে দেবে',
      icon: '🍃',
      cost: 80,
    ),
    HintType.starlight: HintInfo(
      type: HintType.starlight,
      title: 'তারার আলো',
      description: 'যে সারি বা কলামে শব্দ আছে তা উজ্জ্বল করবে',
      icon: '🌟',
      cost: 100,
    ),
    HintType.parrotHelper: HintInfo(
      type: HintType.parrotHelper,
      title: 'টিয়া সাহায্য',
      description: 'একটি সম্পূর্ণ শব্দ খুঁজে দেবে',
      icon: '🦜',
      cost: 200,
    ),
    HintType.rotateShuffle: HintInfo(
      type: HintType.rotateShuffle,
      title: 'ঘুরিয়ে দেখো',
      description: 'গ্রিডটিকে নতুন দৃষ্টিভঙ্গিতে সাজাবে',
      icon: '🔄',
      cost: 0,
      isFreeOnce: true,
    ),
    HintType.meaningClue: HintInfo(
      type: HintType.meaningClue,
      title: 'অর্থ দেখো',
      description: 'শব্দের অর্থ ক্লু হিসেবে দেখাবে',
      icon: '💡',
      cost: 30,
    ),
  };
}

/// গ্রিডে হিন্ট প্রয়োগের ফলাফল — Hint Execution State
class HintResult {
  final HintType type;
  final bool success;
  final String message;
  final List<int>? affectedCellIndices;
  final int? targetWordIndex;

  const HintResult({
    required this.type,
    required this.success,
    required this.message,
    this.affectedCellIndices,
    this.targetWordIndex,
  });
}
