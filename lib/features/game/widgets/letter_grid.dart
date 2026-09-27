import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../providers/game_provider.dart';
import 'letter_cell.dart';

/// বর্ণ গ্রিড — Letter Grid Widget
/// Renders the NxN word search matrix with fluid drag & tap gesture detection
class LetterGrid extends ConsumerStatefulWidget {
  const LetterGrid({super.key});

  @override
  ConsumerState<LetterGrid> createState() => _LetterGridState();
}

class _LetterGridState extends ConsumerState<LetterGrid> {
  final GlobalKey _gridKey = GlobalKey();

  int? _getIndexFromOffset(Offset localPosition, double size, int gridSize) {
    if (localPosition.dx < 0 ||
        localPosition.dx >= size ||
        localPosition.dy < 0 ||
        localPosition.dy >= size) {
      return null;
    }
    final cellWidth = size / gridSize;
    final cellHeight = size / gridSize;

    final col = (localPosition.dx / cellWidth).floor().clamp(0, gridSize - 1);
    final row = (localPosition.dy / cellHeight).floor().clamp(0, gridSize - 1);

    return row * gridSize + col;
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    final gridSize = gameState.gridSize;
    final cells = gameState.cells;

    if (cells.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep grid strictly square and responsive
        final size = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        return Center(
          child: Container(
            width: size,
            height: size,
            key: _gridKey,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.woodPlate,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.woodPlateBorder,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.woodPlateBorder.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: GestureDetector(
              onPanStart: (details) {
                final idx = _getIndexFromOffset(details.localPosition, size - 16, gridSize);
                if (idx != null) {
                  gameNotifier.startSelection(idx);
                }
              },
              onPanUpdate: (details) {
                final idx = _getIndexFromOffset(details.localPosition, size - 16, gridSize);
                if (idx != null) {
                  gameNotifier.updateSelection(idx);
                }
              },
              onPanEnd: (_) {
                gameNotifier.endSelection();
              },
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: cells.length,
                itemBuilder: (context, index) {
                  final cell = cells[index];
                  final isSelected = gameState.selectedIndices.contains(index);
                  final isDimmed = gameState.dimmedIndices.contains(index);
                  final isHinted = gameState.hintHighlightedIndices.contains(index);

                  // Determine color if part of found word
                  Color? foundColor;
                  if (cell.isFound) {
                    for (final entry in gameState.wordColors.entries) {
                      // Check if cell is part of this word
                      foundColor = entry.value;
                      break;
                    }
                  }

                  return LetterCell(
                    cell: cell,
                    isSelected: isSelected,
                    isFound: cell.isFound,
                    isDimmed: isDimmed,
                    isHinted: isHinted,
                    foundColor: foundColor,
                    onTap: () {
                      gameNotifier.handleCellTap(index);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
