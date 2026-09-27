import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/utils/bangla_utils.dart';
import '../../../core/utils/grid_generator.dart';
import '../../../data/models/hint_model.dart';
import '../../../data/models/level_model.dart';
import '../../../data/models/player_progress.dart';
import '../../../data/models/word_model.dart';
import '../../../data/repositories/progress_repository.dart';

/// রকমারি হাইলাইট রং — Word highlight colors for found words
const List<Color> _wordHighlightColors = [
  Color(0xFF81C784), // হালকা সবুজ
  Color(0xFFFFB74D), // সোনালি কমলা
  Color(0xFF64B5F6), // আকাশী নীল
  Color(0xFFBA68C8), // হালকা বেগুনি
  Color(0xFFFF8A65), // প্রবাল
  Color(0xFF4DB6AC), // সবুজাভ নীল
  Color(0xFFFFD54F), // হলুদ
];

/// গেমের অবস্থা — Game State
class GameState {
  final Level? level;
  final List<GridCell> cells;
  final int gridSize;
  final List<int> selectedIndices;
  final Set<String> foundWords;
  final Map<String, Color> wordColors;
  final Set<int> dimmedIndices; // cells removed by Leaf Fall hint
  final Set<int> hintHighlightedIndices; // cells highlighted by hint
  final bool isCompleted;
  final int hintsUsed;
  final int earnedCoins;
  final int earnedStars;
  final BanglaWord? lastFoundWord;
  final String? feedbackMessage;
  final bool isWrongWord;
  final List<WordPlacement> placements;
  final int remainingSeconds;
  final int totalSeconds;
  final bool isTimeOut;
  final bool emergencyHintTriggered;
  final List<int> lastFoundIndices;
  final String? lastFoundWordStr;
  final int comboCount;
  final DateTime? lastWordFoundTime;
  final String? comboBanner;

  const GameState({
    this.level,
    this.cells = const [],
    this.gridSize = 4,
    this.selectedIndices = const [],
    this.foundWords = const {},
    this.wordColors = const {},
    this.dimmedIndices = const {},
    this.hintHighlightedIndices = const {},
    this.isCompleted = false,
    this.hintsUsed = 0,
    this.earnedCoins = 0,
    this.earnedStars = 0,
    this.lastFoundWord,
    this.feedbackMessage,
    this.isWrongWord = false,
    this.placements = const [],
    this.remainingSeconds = 60,
    this.totalSeconds = 60,
    this.isTimeOut = false,
    this.emergencyHintTriggered = false,
    this.lastFoundIndices = const [],
    this.lastFoundWordStr,
    this.comboCount = 0,
    this.lastWordFoundTime,
    this.comboBanner,
  });

  GameState copyWith({
    Level? level,
    List<GridCell>? cells,
    int? gridSize,
    List<int>? selectedIndices,
    Set<String>? foundWords,
    Map<String, Color>? wordColors,
    Set<int>? dimmedIndices,
    Set<int>? hintHighlightedIndices,
    bool? isCompleted,
    int? hintsUsed,
    int? earnedCoins,
    int? earnedStars,
    BanglaWord? lastFoundWord,
    String? feedbackMessage,
    bool? isWrongWord,
    List<WordPlacement>? placements,
    int? remainingSeconds,
    int? totalSeconds,
    bool? isTimeOut,
    bool? emergencyHintTriggered,
    List<int>? lastFoundIndices,
    String? lastFoundWordStr,
    int? comboCount,
    DateTime? lastWordFoundTime,
    String? comboBanner,
  }) {
    return GameState(
      level: level ?? this.level,
      cells: cells ?? this.cells,
      gridSize: gridSize ?? this.gridSize,
      selectedIndices: selectedIndices ?? this.selectedIndices,
      foundWords: foundWords ?? this.foundWords,
      wordColors: wordColors ?? this.wordColors,
      dimmedIndices: dimmedIndices ?? this.dimmedIndices,
      hintHighlightedIndices:
          hintHighlightedIndices ?? this.hintHighlightedIndices,
      isCompleted: isCompleted ?? this.isCompleted,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      earnedCoins: earnedCoins ?? this.earnedCoins,
      earnedStars: earnedStars ?? this.earnedStars,
      lastFoundWord: lastFoundWord,
      feedbackMessage: feedbackMessage,
      isWrongWord: isWrongWord ?? this.isWrongWord,
      placements: placements ?? this.placements,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isTimeOut: isTimeOut ?? this.isTimeOut,
      emergencyHintTriggered:
          emergencyHintTriggered ?? this.emergencyHintTriggered,
      lastFoundIndices: lastFoundIndices ?? this.lastFoundIndices,
      lastFoundWordStr: lastFoundWordStr ?? this.lastFoundWordStr,
      comboCount: comboCount ?? this.comboCount,
      lastWordFoundTime: lastWordFoundTime ?? this.lastWordFoundTime,
      comboBanner: comboBanner,
    );
  }

  /// Get the currently formed Bangla word from selected cells
  String get currentSelectedWord {
    return selectedIndices.map((i) => cells[i].letter).join();
  }
}

/// প্লেয়ার প্রগ্রেস প্রোভাইডার
final progressRepositoryProvider = Provider((ref) => ProgressRepository());

final playerProgressProvider =
    StateNotifierProvider<PlayerProgressNotifier, PlayerProgress>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return PlayerProgressNotifier(repo);
});

class PlayerProgressNotifier extends StateNotifier<PlayerProgress> {
  final ProgressRepository _repo;

  PlayerProgressNotifier(this._repo) : super(_repo.getProgress());

  void refresh() {
    state = _repo.getProgress();
  }

  Future<void> addCoins(int amount) async {
    final updated = await _repo.addCoins(amount);
    state = updated;
    AudioService.playCoin();
  }

  Future<bool> spendCoins(int amount) async {
    final success = await _repo.spendCoins(amount);
    if (success) {
      state = _repo.getProgress();
    }
    return success;
  }

  Future<int> consumeFreeTry(int levelId) async {
    final remaining = await _repo.consumeFreeTry(levelId);
    state = _repo.getProgress();
    return remaining;
  }

  Future<void> resetFreeTries(int levelId) async {
    await _repo.resetFreeTries(levelId);
    state = _repo.getProgress();
  }

  Future<void> completeLevel({
    required int levelId,
    required int stars,
    required int coinsEarned,
  }) async {
    final updated = await _repo.completeLevel(
      levelId: levelId,
      stars: stars,
      coinsEarned: coinsEarned,
    );
    state = updated;
  }
}

/// গেম কন্ট্রোলার প্রোভাইডার
final gameProvider =
    StateNotifierProvider.autoDispose<GameNotifier, GameState>((ref) {
  final progressNotifier = ref.read(playerProgressProvider.notifier);
  return GameNotifier(progressNotifier);
});

class GameNotifier extends StateNotifier<GameState> {
  final PlayerProgressNotifier _progressNotifier;
  final GridGenerator _generator = GridGenerator();
  Timer? _timer;

  GameNotifier(this._progressNotifier) : super(const GameState());

  /// Initialize a level and generate its letter grid
  void initLevel(Level level) {
    _timer?.cancel();

    final wordsSplit = level.targetWords
        .map((w) => BanglaUtils.splitWord(w.word))
        .toList();

    var result = _generator.generate(
      words: wordsSplit,
      gridSize: level.gridSize,
      allowDiagonal: level.difficulty != Difficulty.easy,
    );

    // Fallback if placement failed with current size: increase attempts without diagonals
    if (result == null) {
      result = _generator.generate(
        words: wordsSplit,
        gridSize: level.gridSize,
        allowDiagonal: false,
        maxAttempts: 200,
      );
    }

    // Flatten 2D grid to 1D
    final flatCells = <GridCell>[];
    if (result != null) {
      for (final row in result.grid) {
        flatCells.addAll(row);
      }
    } else {
      // Emergency fallback grid
      for (int r = 0; r < level.gridSize; r++) {
        for (int c = 0; c < level.gridSize; c++) {
          flatCells.add(GridCell(
            letter: BanglaUtils.getRandomLetter(),
            row: r,
            col: c,
          ));
        }
      }
    }

    state = GameState(
      level: level,
      cells: flatCells,
      gridSize: level.gridSize,
      placements: result?.placements ?? [],
      foundWords: {},
      wordColors: {},
      selectedIndices: [],
      hintsUsed: 0,
      isCompleted: false,
      remainingSeconds: 60,
      totalSeconds: 60,
      isTimeOut: false,
      emergencyHintTriggered: false,
    );

    _startTimer();
  }

  /// Restart the current level
  void restartLevel() {
    if (state.level != null) {
      initLevel(state.level!);
    }
  }

  /// Pause the timer (e.g. when exit confirmation modal is shown)
  void pauseTimer() {
    _timer?.cancel();
  }

  /// Resume the timer (e.g. when player cancels exit modal and continues)
  void resumeTimer() {
    if (state.isCompleted || state.isTimeOut) return;
    _startTimer();
  }

  /// Start the 60-second level countdown timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (state.isCompleted || state.isTimeOut) {
        t.cancel();
        return;
      }

      final newRemaining = state.remainingSeconds - 1;

      if (newRemaining <= 0) {
        t.cancel();
        AudioService.playWrong();
        state = state.copyWith(
          remainingSeconds: 0,
          isTimeOut: true,
          feedbackMessage: 'সময় শেষ! আবার চেষ্টা করুন।',
        );
      } else {
        // Trigger emergency hint when exactly 10 seconds remaining
        if (newRemaining == 10 && !state.emergencyHintTriggered) {
          _triggerEmergencyHint();
        } else if (newRemaining <= 5) {
          AudioService.playLetterTap();
        }
        state = state.copyWith(remainingSeconds: newRemaining);
      }
    });
  }

  /// Emergency hint triggered at 10 seconds remaining
  void _triggerEmergencyHint() {
    AudioService.playBirdChirp();
    final unfoundWords = state.level?.targetWords
            .where((w) => !state.foundWords.contains(w.word))
            .toList() ??
        [];
    if (unfoundWords.isEmpty) return;

    final targetWord = unfoundWords.first;
    final firstChar = BanglaUtils.splitWord(targetWord.word).first;

    int? hintCellIndex;
    for (int i = 0; i < state.cells.length; i++) {
      if (state.cells[i].letter == firstChar && !state.cells[i].isFound) {
        hintCellIndex = i;
        break;
      }
    }

    state = state.copyWith(
      emergencyHintTriggered: true,
      hintHighlightedIndices: hintCellIndex != null
          ? {...state.hintHighlightedIndices, hintCellIndex}
          : state.hintHighlightedIndices,
      feedbackMessage: '💡 শেষ ১০ সেকেন্ড! ফ্রি বর্ণ হিন্ট দেওয়া হয়েছে!',
      isWrongWord: false,
    );
  }

  /// Check if current selected cells form an unfound target word
  bool _checkAndMatchWord() {
    if (state.selectedIndices.isEmpty) return false;

    final selectedWord = state.currentSelectedWord;
    final reversedWord = state.selectedIndices.reversed
        .map((i) => state.cells[i].letter)
        .join();

    final targetWords = state.level?.targetWords ?? [];

    BanglaWord? matchedWord;
    for (final word in targetWords) {
      if (state.foundWords.contains(word.word)) continue;

      if (word.word == selectedWord || word.word == reversedWord) {
        matchedWord = word;
        break;
      }
    }

    if (matchedWord != null) {
      _handleWordFound(matchedWord, List.from(state.selectedIndices));
      return true;
    }
    return false;
  }

  /// Cell touch/pan started
  void startSelection(int index) {
    if (state.isCompleted) return;
    if (index < 0 || index >= state.cells.length) return;

    AudioService.playLetterTap();
    state = state.copyWith(
      selectedIndices: [index],
      feedbackMessage: null,
      isWrongWord: false,
    );

    // If single letter is a target word (like "মা"), match immediately!
    _checkAndMatchWord();
  }

  /// Cell touched during pan/drag
  void updateSelection(int index) {
    if (state.isCompleted) return;
    if (index < 0 || index >= state.cells.length) return;

    final current = state.selectedIndices;
    if (current.isEmpty) {
      startSelection(index);
      return;
    }

    // If already in list, allow backtracking to the previous element
    if (current.contains(index)) {
      if (current.length > 1 && current[current.length - 2] == index) {
        state = state.copyWith(
          selectedIndices: current.sublist(0, current.length - 1),
        );
      }
      return;
    }

    // Ensure adjacent step in 8 directions
    final lastIndex = current.last;
    final lastRow = lastIndex ~/ state.gridSize;
    final lastCol = lastIndex % state.gridSize;
    final newRow = index ~/ state.gridSize;
    final newCol = index % state.gridSize;

    final dRow = (newRow - lastRow).abs();
    final dCol = (newCol - lastCol).abs();

    if (dRow <= 1 && dCol <= 1 && (dRow != 0 || dCol != 0)) {
      AudioService.playLetterTap();
      state = state.copyWith(
        selectedIndices: [...current, index],
      );
      // Auto-validate whenever word is formed!
      _checkAndMatchWord();
    }
  }

  /// Handle individual cell tap (tap-to-play mode)
  void handleCellTap(int index) {
    if (state.isCompleted) return;
    if (index < 0 || index >= state.cells.length) return;

    final current = state.selectedIndices;

    if (current.isEmpty) {
      startSelection(index);
      return;
    }

    if (current.contains(index)) {
      if (!_checkAndMatchWord()) {
        state = state.copyWith(selectedIndices: []);
      }
      return;
    }

    final lastIndex = current.last;
    final lastRow = lastIndex ~/ state.gridSize;
    final lastCol = lastIndex % state.gridSize;
    final newRow = index ~/ state.gridSize;
    final newCol = index % state.gridSize;

    final dRow = (newRow - lastRow).abs();
    final dCol = (newCol - lastCol).abs();

    if (dRow <= 1 && dCol <= 1 && (dRow != 0 || dCol != 0)) {
      updateSelection(index);
    } else {
      startSelection(index);
    }
  }

  /// Pan/Touch ended — validate word
  void endSelection() {
    if (state.isCompleted || state.selectedIndices.isEmpty) return;

    if (_checkAndMatchWord()) return;

    // If only 1 letter was touched and didn't match, quietly deselect without buzzer
    if (state.selectedIndices.length <= 1) {
      state = state.copyWith(selectedIndices: []);
      return;
    }
    // Wrong word when multiple letters were connected
    AudioService.playWrong();
    state = state.copyWith(
      isWrongWord: true,
      feedbackMessage: 'আবার চেষ্টা করো!',
    );
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        state = state.copyWith(
          selectedIndices: [],
          isWrongWord: false,
        );
      }
    });
  }

  void _handleWordFound(BanglaWord word, List<int> indices) {
    AudioService.playWordFound();

    final now = DateTime.now();
    int newCombo = 1;
    String? comboBanner;
    if (state.lastWordFoundTime != null &&
        now.difference(state.lastWordFoundTime!) <= const Duration(seconds: 7)) {
      newCombo = state.comboCount + 1;
    }
    if (newCombo >= 2) {
      if (newCombo == 2) {
        comboBanner = 'দারুণ! কম্বো x২ 🔥';
      } else if (newCombo == 3) {
        comboBanner = 'অসাধারণ! কম্বো x৩ ⚡';
      } else {
        comboBanner = 'অবিশ্বাস্য! কম্বো x$newCombo 💥';
      }
    }

    final newFoundWords = Set<String>.from(state.foundWords)..add(word.word);
    final color = _wordHighlightColors[newFoundWords.length % _wordHighlightColors.length];
    final newWordColors = Map<String, Color>.from(state.wordColors)..[word.word] = color;

    // Update cells
    final newCells = List<GridCell>.from(state.cells);
    for (final idx in indices) {
      newCells[idx] = newCells[idx].copyWith(isFound: true);
    }

    final isAllFound = newFoundWords.length == (state.level?.targetWords.length ?? 0);
    int earnedCoins = 10; // 10 coins per word
    int stars = 3;

    if (isAllFound) {
      _timer?.cancel();
      final elapsed = state.totalSeconds - state.remainingSeconds;

      // Calculate stars & coins based on speed timer:
      // <= 30 seconds: 3 Stars + Double Coin Bonus!
      // 31 to 50 seconds: 2 Stars
      // > 50 seconds: 1 Star
      if (elapsed <= 30) {
        stars = 3;
        earnedCoins = (newFoundWords.length * 10 + 30) * 2; // Double coin bonus!
      } else if (elapsed <= 50) {
        stars = 2;
        earnedCoins = newFoundWords.length * 10 + 20;
      } else {
        stars = 1;
        earnedCoins = newFoundWords.length * 10 + 10;
      }

      AudioService.playLevelComplete();
      if (state.level != null) {
        _progressNotifier.completeLevel(
          levelId: state.level!.id,
          stars: stars,
          coinsEarned: earnedCoins,
        );
      }
    } else {
      _progressNotifier.addCoins(10);
    }

    state = state.copyWith(
      cells: newCells,
      foundWords: newFoundWords,
      wordColors: newWordColors,
      selectedIndices: [],
      lastFoundWord: word,
      lastFoundIndices: indices,
      lastFoundWordStr: word.word,
      comboCount: newCombo,
      lastWordFoundTime: now,
      comboBanner: comboBanner,
      feedbackMessage: isAllFound
          ? (stars == 3
              ? 'অসাধারণ! ৩ স্টার ও দ্বিগুণ কয়েন! 🌟'
              : (stars == 2
                  ? 'চমৎকার! ২ স্টার অর্জিত হয়েছে!'
                  : 'ভালো খেলেছেন! ১ স্টার অর্জিত হয়েছে!'))
          : 'চমৎকার! "${word.word}" পাওয়া গেছে!',
      isCompleted: isAllFound,
      earnedCoins: earnedCoins,
      earnedStars: stars,
    );
  }

  void clearComboBanner() {
    if (state.comboBanner != null) {
      state = state.copyWith(comboBanner: null);
    }
  }

  /// Use a Hint in the game
  Future<bool> useHint(HintType hintType) async {
    if (state.isCompleted) return false;
    final hint = HintInfo.hints[hintType];
    if (hint == null) return false;

    // Check coins if not free
    if (hint.cost > 0) {
      final success = await _progressNotifier.spendCoins(hint.cost);
      if (!success) {
        final currentCoins = _progressNotifier.state.coins;
        final needed = hint.cost - currentCoins;
        AudioService.playWrong();
        state = state.copyWith(
          feedbackMessage: '🪙 আরও ${needed.toBanglaDigits()}টি কয়েন দরকার!',
          isWrongWord: false,
        );
        return false;
      }
    }

    state = state.copyWith(hintsUsed: state.hintsUsed + 1);

    switch (hintType) {
      case HintType.birdCall:
        _applyBirdCallHint();
        break;
      case HintType.leafFall:
        _applyLeafFallHint();
        break;
      case HintType.starlight:
        _applyStarlightHint();
        break;
      case HintType.parrotHelper:
        _applyParrotHelperHint();
        break;
      case HintType.rotateShuffle:
        if (state.level != null) {
          initLevel(state.level!);
        }
        break;
      case HintType.meaningClue:
        _applyMeaningClue();
        break;
    }

    return true;
  }

  void _applyBirdCallHint() {
    AudioService.playBirdChirp();
    // Find first letter of an unfound word
    final unfoundWords = state.level?.targetWords
            .where((w) => !state.foundWords.contains(w.word))
            .toList() ??
        [];
    if (unfoundWords.isEmpty) return;

    final targetWord = unfoundWords.first;
    final firstChar = BanglaUtils.splitWord(targetWord.word).first;

    // Locate cell matching this first character that is part of the word
    for (int i = 0; i < state.cells.length; i++) {
      if (state.cells[i].letter == firstChar && !state.cells[i].isFound) {
        state = state.copyWith(
          hintHighlightedIndices: {i},
          feedbackMessage: 'টুনটুনি প্রথম বর্ণটি দেখিয়ে দিল!',
        );
        break;
      }
    }
  }

  void _applyLeafFallHint() {
    AudioService.playLetterTap();
    // Find up to 4 non-word cells and dim them
    final nonWordIndices = <int>[];
    for (int i = 0; i < state.cells.length; i++) {
      if (!state.cells[i].isPartOfWord && !state.dimmedIndices.contains(i)) {
        nonWordIndices.add(i);
      }
    }

    nonWordIndices.shuffle();
    final toDim = nonWordIndices.take(4).toSet();
    state = state.copyWith(
      dimmedIndices: {...state.dimmedIndices, ...toDim},
      feedbackMessage: 'অপ্রয়োজনীয় বর্ণ ঝরে গেল!',
    );
  }

  void _applyStarlightHint() {
    AudioService.playCoin();
    final unfoundWords = state.level?.targetWords
            .where((w) => !state.foundWords.contains(w.word))
            .toList() ??
        [];
    if (unfoundWords.isEmpty) return;

    final firstWord = unfoundWords.first;
    for (final placement in state.placements) {
      final placedWord = placement.letters.join();
      if (placedWord == firstWord.word) {
        // Highlight row
        final row = placement.startRow;
        final rowIndices = List.generate(
          state.gridSize,
          (col) => row * state.gridSize + col,
        ).toSet();

        state = state.copyWith(
          hintHighlightedIndices: rowIndices,
          feedbackMessage: 'তারার আলোয় সারিটি জ্বলে উঠল!',
        );
        break;
      }
    }
  }

  void _applyParrotHelperHint() {
    final unfoundWords = state.level?.targetWords
            .where((w) => !state.foundWords.contains(w.word))
            .toList() ??
        [];
    if (unfoundWords.isEmpty) return;

    final targetWord = unfoundWords.first;
    for (final placement in state.placements) {
      final placedWord = placement.letters.join();
      if (placedWord == targetWord.word) {
        final indices = placement.positions
            .map((pos) => pos.$1 * state.gridSize + pos.$2)
            .toList();
        _handleWordFound(targetWord, indices);
        state = state.copyWith(
          feedbackMessage: 'টিয়া পাখি "${targetWord.word}" খুঁজে দিল!',
        );
        break;
      }
    }
  }

  void _applyMeaningClue() {
    final unfoundWords = state.level?.targetWords
            .where((w) => !state.foundWords.contains(w.word))
            .toList() ??
        [];
    if (unfoundWords.isEmpty) return;

    final target = unfoundWords.first;
    state = state.copyWith(
      feedbackMessage: 'ক্লু: "${target.meaning}"',
    );
  }

  void clearHintHighlights() {
    state = state.copyWith(hintHighlightedIndices: {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
