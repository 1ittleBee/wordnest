import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/services/audio_service.dart';

/// কয়েন ওড়ার ওভারলে — Flying Coins Particle Overlay
/// Animates golden coin particles in a smooth parabolic arc towards the coin wallet
class FlyingCoinsOverlay extends StatefulWidget {
  final Widget child;

  const FlyingCoinsOverlay({
    super.key,
    required this.child,
  });

  @override
  FlyingCoinsOverlayState createState() => FlyingCoinsOverlayState();
}

class FlyingCoinsOverlayState extends State<FlyingCoinsOverlay>
    with TickerProviderStateMixin {
  final List<_CoinParticle> _activeCoins = [];
  final Random _random = Random();

  /// Spawns a burst of flying coins from [startPos] towards [targetPos]
  void spawnCoins({
    required Offset startPos,
    required Offset targetPos,
    int count = 6,
    VoidCallback? onAllArrived,
  }) {
    int arrivedCount = 0;

    for (int i = 0; i < count; i++) {
      final delayMs = i * 70;
      final durationMs = 600 + _random.nextInt(150);

      // Random control point for curved parabolic arc
      final midX = (startPos.dx + targetPos.dx) / 2 + (_random.nextDouble() * 100 - 50);
      final midY = min(startPos.dy, targetPos.dy) - (70 + _random.nextDouble() * 80);
      final controlPoint = Offset(midX, midY);

      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationMs),
      );

      final particle = _CoinParticle(
        start: startPos,
        control: controlPoint,
        end: targetPos,
        controller: controller,
      );

      setState(() {
        _activeCoins.add(particle);
      });

      Future.delayed(Duration(milliseconds: delayMs), () {
        if (!mounted) return;
        controller.forward().then((_) {
          if (!mounted) return;
          AudioService.playCoin();
          setState(() {
            _activeCoins.remove(particle);
          });
          controller.dispose();
          arrivedCount++;
          if (arrivedCount == count) {
            onAllArrived?.call();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    for (final c in _activeCoins) {
      c.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_activeCoins.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _CoinsPainter(_activeCoins),
              ),
            ),
          ),
      ],
    );
  }
}

class _CoinParticle {
  final Offset start;
  final Offset control;
  final Offset end;
  final AnimationController controller;

  _CoinParticle({
    required this.start,
    required this.control,
    required this.end,
    required this.controller,
  });

  Offset get currentPosition {
    final t = Curves.easeInOutCubic.transform(controller.value);
    // Quadratic Bezier: B(t) = (1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
    final u = 1 - t;
    final x = u * u * start.dx + 2 * u * t * control.dx + t * t * end.dx;
    final y = u * u * start.dy + 2 * u * t * control.dy + t * t * end.dy;
    return Offset(x, y);
  }

  double get scale {
    final t = controller.value;
    if (t < 0.2) return (t / 0.2).clamp(0.2, 1.2);
    if (t > 0.85) return ((1.0 - t) / 0.15).clamp(0.0, 1.0);
    return 1.0;
  }
}

class _CoinsPainter extends CustomPainter {
  final List<_CoinParticle> particles;

  _CoinsPainter(this.particles)
      : super(repaint: Listenable.merge(particles.map((p) => p.controller).toList()));

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final pos = p.currentPosition;
      final scale = p.scale;
      if (scale <= 0) continue;

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.scale(scale);

      // Draw shiny golden coin
      final shadowPaint = Paint()
        ..color = const Color(0xFFFFB300).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset.zero, 13, shadowPaint);

      final outerPaint = Paint()
        ..color = const Color(0xFFFFD54F)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 12, outerPaint);

      final innerBorder = Paint()
        ..color = const Color(0xFFFF8F00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset.zero, 10, innerBorder);

      final centerPaint = Paint()
        ..color = const Color(0xFFFFC107)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 8, centerPaint);

      // Star emblem in center
      final starPaint = Paint()
        ..color = const Color(0xFFFFF8E1)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 3.5, starPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CoinsPainter oldDelegate) => true;
}
