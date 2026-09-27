import 'dart:math';
import 'bangla_utils.dart';

/// গ্রিড সেল — Grid Cell
/// Represents a single cell in the word search grid
class GridCell {
  /// The Bangla character/grapheme displayed in this cell
  final String letter;

  /// Row position in grid
  final int row;

  /// Column position in grid
  final int col;

  /// Whether this cell is part of a target word
  bool isPartOfWord;

  /// Whether this cell is currently selected by the player
  bool isSelected;

  /// Whether this cell's word has been found
  bool isFound;

  /// Which word(s) this cell belongs to (word indices)
  List<int> wordIndices;

  GridCell({
    required this.letter,
    required this.row,
    required this.col,
    this.isPartOfWord = false,
    this.isSelected = false,
    this.isFound = false,
    List<int>? wordIndices,
  }) : wordIndices = wordIndices ?? [];

  /// Create a copy of this cell
  GridCell copyWith({
    String? letter,
    int? row,
    int? col,
    bool? isPartOfWord,
    bool? isSelected,
    bool? isFound,
    List<int>? wordIndices,
  }) {
    return GridCell(
      letter: letter ?? this.letter,
      row: row ?? this.row,
      col: col ?? this.col,
      isPartOfWord: isPartOfWord ?? this.isPartOfWord,
      isSelected: isSelected ?? this.isSelected,
      isFound: isFound ?? this.isFound,
      wordIndices: wordIndices ?? List.from(this.wordIndices),
    );
  }
}

/// শব্দ বসানোর তথ্য — Word Placement Info
/// Records where a word was placed in the grid
class WordPlacement {
  final int wordIndex;
  final int startRow;
  final int startCol;
  final int dirRow; // -1, 0, or 1
  final int dirCol; // -1, 0, or 1
  final List<String> letters;

  const WordPlacement({
    required this.wordIndex,
    required this.startRow,
    required this.startCol,
    required this.dirRow,
    required this.dirCol,
    required this.letters,
  });

  /// Get all cell positions for this word
  List<(int, int)> get positions {
    return List.generate(letters.length, (i) {
      return (startRow + i * dirRow, startCol + i * dirCol);
    });
  }
}

/// গ্রিড ডিরেকশন — Direction for word placement
enum GridDirection {
  horizontal(0, 1),     // →
  vertical(1, 0),       // ↓
  diagonalDown(1, 1),   // ↘
  diagonalUp(-1, 1),    // ↗
  horizontalRev(0, -1), // ←
  verticalRev(-1, 0),   // ↑
  diagonalDownRev(-1, -1), // ↖
  diagonalUpRev(1, -1);    // ↙

  final int dRow;
  final int dCol;
  const GridDirection(this.dRow, this.dCol);
}

/// গ্রিড জেনারেটর — Grid Generator
/// The core algorithm that generates the word search puzzle grid
class GridGenerator {
  final Random _random = Random();

  /// Generate a word search grid with the given words
  ///
  /// [words] — List of Bangla words (already split into grapheme clusters)
  /// [gridSize] — Size of the grid (e.g., 4 for 4×4)
  /// [allowDiagonal] — Whether to allow diagonal placements
  ///
  /// Returns a 2D list of GridCell objects, or null if generation failed
  ({List<List<GridCell>> grid, List<WordPlacement> placements})? generate({
    required List<List<String>> words,
    required int gridSize,
    bool allowDiagonal = true,
    int maxAttempts = 100,
  }) {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final result = _tryGenerate(
        words: words,
        gridSize: gridSize,
        allowDiagonal: allowDiagonal,
      );
      if (result != null) return result;
    }
    return null;
  }

  ({List<List<GridCell>> grid, List<WordPlacement> placements})? _tryGenerate({
    required List<List<String>> words,
    required int gridSize,
    required bool allowDiagonal,
  }) {
    // Initialize empty grid
    final grid = List.generate(
      gridSize,
      (row) => List.generate(
        gridSize,
        (col) => GridCell(letter: '', row: row, col: col),
      ),
    );

    final placements = <WordPlacement>[];

    // Sort words by length (longest first for better placement)
    final wordIndices = List.generate(words.length, (i) => i);
    wordIndices.sort((a, b) => words[b].length.compareTo(words[a].length));

    // Try to place each word
    for (final wordIdx in wordIndices) {
      final wordLetters = words[wordIdx];
      final placed = _placeWord(
        grid: grid,
        wordLetters: wordLetters,
        wordIndex: wordIdx,
        gridSize: gridSize,
        allowDiagonal: allowDiagonal,
      );

      if (placed == null) return null; // Failed to place this word
      placements.add(placed);
    }

    // Fill empty cells with random Bangla letters
    _fillEmptyCells(grid, gridSize);

    return (grid: grid, placements: placements);
  }

  /// Try to place a single word in the grid
  WordPlacement? _placeWord({
    required List<List<GridCell>> grid,
    required List<String> wordLetters,
    required int wordIndex,
    required int gridSize,
    required bool allowDiagonal,
  }) {
    // Get available directions
    final directions = <GridDirection>[
      GridDirection.horizontal,
      GridDirection.vertical,
    ];
    if (allowDiagonal) {
      directions.addAll([
        GridDirection.diagonalDown,
        GridDirection.diagonalUp,
      ]);
    }

    // Also allow reverse directions for variety
    final allDirections = <GridDirection>[...directions];
    allDirections.addAll([
      GridDirection.horizontalRev,
      GridDirection.verticalRev,
    ]);
    if (allowDiagonal) {
      allDirections.addAll([
        GridDirection.diagonalDownRev,
        GridDirection.diagonalUpRev,
      ]);
    }

    // Shuffle directions for randomness
    allDirections.shuffle(_random);

    // Try each direction
    for (final dir in allDirections) {
      // Calculate valid starting positions
      final positions = _getValidStartPositions(
        wordLength: wordLetters.length,
        gridSize: gridSize,
        dRow: dir.dRow,
        dCol: dir.dCol,
      );

      positions.shuffle(_random);

      // Try each starting position
      for (final (startRow, startCol) in positions) {
        if (_canPlaceWord(
          grid: grid,
          wordLetters: wordLetters,
          startRow: startRow,
          startCol: startCol,
          dRow: dir.dRow,
          dCol: dir.dCol,
        )) {
          // Place the word
          _doPlaceWord(
            grid: grid,
            wordLetters: wordLetters,
            wordIndex: wordIndex,
            startRow: startRow,
            startCol: startCol,
            dRow: dir.dRow,
            dCol: dir.dCol,
          );

          return WordPlacement(
            wordIndex: wordIndex,
            startRow: startRow,
            startCol: startCol,
            dirRow: dir.dRow,
            dirCol: dir.dCol,
            letters: wordLetters,
          );
        }
      }
    }

    return null; // Could not place word
  }

  /// Get all valid starting positions for a word in a given direction
  List<(int, int)> _getValidStartPositions({
    required int wordLength,
    required int gridSize,
    required int dRow,
    required int dCol,
  }) {
    final positions = <(int, int)>[];

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        // Check if the word fits starting from this position
        final endRow = row + (wordLength - 1) * dRow;
        final endCol = col + (wordLength - 1) * dCol;

        if (endRow >= 0 &&
            endRow < gridSize &&
            endCol >= 0 &&
            endCol < gridSize) {
          positions.add((row, col));
        }
      }
    }

    return positions;
  }

  /// Check if a word can be placed at the given position and direction
  bool _canPlaceWord({
    required List<List<GridCell>> grid,
    required List<String> wordLetters,
    required int startRow,
    required int startCol,
    required int dRow,
    required int dCol,
  }) {
    for (int i = 0; i < wordLetters.length; i++) {
      final row = startRow + i * dRow;
      final col = startCol + i * dCol;
      final cell = grid[row][col];

      // Cell is empty → OK
      if (cell.letter.isEmpty) continue;

      // Cell has the same letter (shared with another word) → OK
      if (cell.letter == wordLetters[i]) continue;

      // Cell has a different letter → CONFLICT
      return false;
    }
    return true;
  }

  /// Actually place the word in the grid
  void _doPlaceWord({
    required List<List<GridCell>> grid,
    required List<String> wordLetters,
    required int wordIndex,
    required int startRow,
    required int startCol,
    required int dRow,
    required int dCol,
  }) {
    for (int i = 0; i < wordLetters.length; i++) {
      final row = startRow + i * dRow;
      final col = startCol + i * dCol;
      grid[row][col] = grid[row][col].copyWith(
        letter: wordLetters[i],
        isPartOfWord: true,
        wordIndices: [...grid[row][col].wordIndices, wordIndex],
      );
    }
  }

  /// Fill empty cells with random Bangla letters
  void _fillEmptyCells(List<List<GridCell>> grid, int gridSize) {
    // Collect all letters used in target words to sometimes reuse them
    final usedLetters = <String>{};
    for (final row in grid) {
      for (final cell in row) {
        if (cell.letter.isNotEmpty) {
          usedLetters.add(cell.letter);
        }
      }
    }

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (grid[row][col].letter.isEmpty) {
          // Mix of common random letters and used letters for realism
          final letter = _random.nextDouble() < 0.3 && usedLetters.isNotEmpty
              ? usedLetters.elementAt(_random.nextInt(usedLetters.length))
              : BanglaUtils.getRandomLetter();

          grid[row][col] = grid[row][col].copyWith(letter: letter);
        }
      }
    }
  }
}
