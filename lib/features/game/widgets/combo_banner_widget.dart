import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// কম্বো ব্যানার উইজেট — Combo / Streak Floating Text Popup
/// Displays a vibrant, celebratory floating badge when consecutive words
/// are discovered within a short duration.
class ComboBannerWidget extends StatefulWidget {
  final String? comboText;
  final VoidCallback? onDismiss;

  const ComboBannerWidget({
    super.key,
    required this.comboText,
    this.onDismiss,
  });

  @override
  State<ComboBannerWidget> createState() => _ComboBannerWidgetState();
}

class _ComboBannerWidgetState extends State<ComboBannerWidget> {
  String? _displayText;
  int _counter = 0;

  @override
  void didUpdateWidget(covariant ComboBannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.comboText != null && widget.comboText != oldWidget.comboText) {
      setState(() {
        _displayText = widget.comboText;
        _counter++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_displayText == null) return const SizedBox.shrink();

    return IgnorePointer(
      child: Center(
        child: Container(
          key: ValueKey('combo_banner_$_counter'),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF6D00), // Vibrant Amber-Orange
                Color(0xFFFFAB00), // Warm Gold
                Color(0xFFFF3D00), // Fiery Orange
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6D00).withValues(alpha: 0.5),
                blurRadius: 16,
                spreadRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _displayText!,
            style: GoogleFonts.hindSiliguri(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              shadows: [
                const Shadow(
                  color: Colors.black38,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        )
            .animate(onComplete: (_) {
              if (mounted) {
                setState(() {
                  _displayText = null;
                });
                widget.onDismiss?.call();
              }
            })
            .scale(
              begin: const Offset(0.4, 0.4),
              end: const Offset(1.15, 1.15),
              duration: 250.ms,
              curve: Curves.easeOutBack,
            )
            .then()
            .scale(
              begin: const Offset(1.15, 1.15),
              end: const Offset(1.0, 1.0),
              duration: 150.ms,
            )
            .moveY(
              begin: 0,
              end: -35,
              duration: 1200.ms,
              curve: Curves.easeOutCubic,
            )
            .shimmer(delay: 200.ms, duration: 600.ms, color: Colors.white)
            .fadeOut(delay: 900.ms, duration: 400.ms),
      ),
    );
  }
}
