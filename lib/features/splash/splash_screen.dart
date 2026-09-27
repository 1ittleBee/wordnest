import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/extensions/string_extensions.dart';
import '../home/home_screen.dart';

/// স্প্ল্যাশ স্ক্রিন — Splash Screen
/// Features Ring of Words style animated mascot walking along the progress bar
/// with live percentage speech bubble and drifting nature petals
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _stepController;
  late final AnimationController _petalController;

  // Drift particles for atmospheric falling leaves / petals
  late final List<_PetalParticle> _particles;

  @override
  void initState() {
    super.initState();

    // 1. Loading progress controller (0.0 to 1.0 over 2.8 seconds)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // 2. Mascot walking / hopping bob controller
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..repeat(reverse: true);

    // 3. Falling petals / leaves animation
    _petalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();

    // Generate falling leaf & blossom particles
    final random = math.Random(42);
    const icons = ['🍃', '🌸', '🌿', '✨'];
    _particles = List.generate(14, (i) {
      return _PetalParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: 0.6 + random.nextDouble() * 0.7,
        swayAmount: 16 + random.nextDouble() * 20,
        swaySpeed: 1.5 + random.nextDouble() * 2.0,
        size: 14 + random.nextDouble() * 10,
        opacity: 0.35 + random.nextDouble() * 0.45,
        icon: icons[i % icons.length],
        rotationSpeed: (random.nextBool() ? 1 : -1) * (1.0 + random.nextDouble() * 2),
      );
    });

    _startLoading();
  }

  void _startLoading() async {
    // Start smooth progress animation
    await _progressController.forward();

    // Small delay at 100% for celebration feel
    await Future.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _stepController.dispose();
    _petalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // 1. Lush Gradient Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1E5E45), // Deep emerald
                    Color(0xFF144533), // Rich forest
                    Color(0xFF0D3325), // Night woods
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 2. Falling Leaves / Petals Ambient Animation
          AnimatedBuilder(
            animation: _petalController,
            builder: (context, _) {
              return Stack(
                children: _particles.map((p) {
                  final progress = _petalController.value;
                  final currentY = ((p.y + progress * p.speed) % 1.0) * size.height;
                  final currentX = (p.x * size.width) +
                      math.sin((progress * p.swaySpeed + p.x) * 2 * math.pi) *
                          p.swayAmount;
                  final rot = progress * p.rotationSpeed * 2 * math.pi;

                  return Positioned(
                    left: currentX,
                    top: currentY,
                    child: Transform.rotate(
                      angle: rot,
                      child: Opacity(
                        opacity: p.opacity,
                        child: Text(
                          p.icon,
                          style: TextStyle(fontSize: p.size),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // 3. Center Branding: Logo + Title + Subtitle
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Animated Tree Nest & Mascot Emblem
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.goldenLight,
                        Color(0xFFFFD572),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.golden, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text('🌳', style: TextStyle(fontSize: 66)),
                )
                    .animate()
                    .scale(
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    )
                    .shimmer(delay: 800.ms, duration: 1200.ms),
                const SizedBox(height: 22),

                // App Title
                Text(
                  'WordNest',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: AppColors.goldenLight,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),

                // Subtitle
                Text(
                  'বাংলা শব্দ খোঁজ ও আনন্দময় শিক্ষা',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .slideY(begin: 0.2, end: 0),

                const Spacer(flex: 4),

                // 4. Mascot Walking on Progress Bar (Ring of Words Style!)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: _buildMascotProgressBar(),
                ),

                const SizedBox(height: 14),

                // "লোড হচ্ছে..." Text below bar
                Text(
                  'লোড হচ্ছে...',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fade(begin: 0.5, end: 1.0, duration: 900.ms),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the interactive loading track with mascot walking along the top
  Widget _buildMascotProgressBar() {
    const double barHeight = 18.0;
    const double mascotSize = 46.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // The mascot can travel from x=0 to x=(totalWidth - mascotSize)
        final travelDistance = totalWidth - mascotSize;

        return AnimatedBuilder(
          animation: Listenable.merge([_progressController, _stepController]),
          builder: (context, _) {
            final progress = _progressController.value;
            final percent = (progress * 100).toInt();

            // Horizontal position of mascot
            final mascotX = travelDistance * progress;

            // Hopping / walking vertical bounce
            final stepBob = -math.sin(_stepController.value * math.pi) * 6;
            // Slight tilt while walking
            final stepTilt = math.sin(_stepController.value * math.pi * 2) * 0.08;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mascot + Speech Bubble moving above progress bar
                SizedBox(
                  width: totalWidth,
                  height: 72,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: mascotX,
                        bottom: 0,
                        child: Transform.translate(
                          offset: Offset(0, stepBob),
                          child: Transform.rotate(
                            angle: stepTilt,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Thought / Speech Bubble
                                _buildSpeechBubble('$percent%'.toBanglaDigits()),
                                const SizedBox(height: 2),

                                // Animated Mascot Bird
                                Container(
                                  width: mascotSize,
                                  height: mascotSize,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.goldenLight,
                                        Color(0xFFFFD572),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
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
                                            fontSize: 24,
                                            height: 1.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // Capsule Progress Bar Track
                Container(
                  height: barHeight,
                  width: totalWidth,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(barHeight / 2),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Active Progress Fill
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.04, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(barHeight / 2),
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.goldenLight,
                                AppColors.golden,
                                Color(0xFFFF9E3D),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.golden.withValues(alpha: 0.5),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Builds a speech/thought bubble displaying the percentage
  Widget _buildSpeechBubble(String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: GoogleFonts.hindSiliguri(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
              height: 1.1,
            ),
          ),
        ),
        // Small downward triangle pointer
        CustomPaint(
          size: const Size(6, 4),
          painter: _TriangleTailPainter(),
        ),
      ],
    );
  }
}

/// Custom painter for the little speech bubble pointer tail
class _TriangleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Particle model for falling nature petals / leaves
class _PetalParticle {
  final double x;
  final double y;
  final double speed;
  final double swayAmount;
  final double swaySpeed;
  final double size;
  final double opacity;
  final String icon;
  final double rotationSpeed;

  _PetalParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.swayAmount,
    required this.swaySpeed,
    required this.size,
    required this.opacity,
    required this.icon,
    required this.rotationSpeed,
  });
}
