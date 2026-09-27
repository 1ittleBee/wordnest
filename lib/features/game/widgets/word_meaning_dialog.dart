import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/word_model.dart';

/// শব্দের অর্থ ডায়ালগ — Word Meaning Educational Dialog
class WordMeaningDialog extends StatelessWidget {
  final BanglaWord word;

  const WordMeaningDialog({super.key, required this.word});

  static void show(BuildContext context, BanglaWord word) {
    showDialog(
      context: context,
      builder: (context) => WordMeaningDialog(word: word),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.cardBg,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mascot & Icon Header
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.goldenLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.golden, width: 2),
              ),
              alignment: Alignment.center,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -1.5),
                  child: Transform.flip(
                    flipX: true,
                    child: const Text(
                      '🐦',
                      style: TextStyle(
                        fontSize: 32,
                        height: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Word Title
            Text(
              word.word,
              style: GoogleFonts.hindSiliguri(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Meaning Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.earthyBrownLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, size: 18, color: AppColors.earthyBrown),
                      const SizedBox(width: 6),
                      Text(
                        'অর্থ:',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.earthyBrown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.meaning,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (word.exampleSentence.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: AppColors.earthyBrownLight),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.format_quote_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'বাক্যে প্রয়োগ:',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.exampleSentence,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dismiss Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'বুঝেছি',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
