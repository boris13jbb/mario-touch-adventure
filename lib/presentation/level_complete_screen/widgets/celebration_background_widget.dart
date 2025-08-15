import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CelebrationBackgroundWidget extends StatefulWidget {
  const CelebrationBackgroundWidget({Key? key}) : super(key: key);

  @override
  State<CelebrationBackgroundWidget> createState() =>
      _CelebrationBackgroundWidgetState();
}

class _CelebrationBackgroundWidgetState
    extends State<CelebrationBackgroundWidget> with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _starsController;
  late AnimationController _coinsController;

  final List<ConfettiParticle> _confettiParticles = [];
  final List<StarParticle> _starParticles = [];
  final List<CoinParticle> _coinParticles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _starsController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _coinsController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _initializeParticles();
    _startAnimations();
  }

  void _initializeParticles() {
    // Initialize confetti particles
    for (int i = 0; i < 50; i++) {
      _confettiParticles.add(ConfettiParticle(
        x: _random.nextDouble() * 100.w,
        y: -10.h,
        color: _getRandomColor(),
        size: _random.nextDouble() * 3 + 2,
        velocity: _random.nextDouble() * 2 + 1,
        rotation: _random.nextDouble() * 2 * math.pi,
      ));
    }

    // Initialize star particles
    for (int i = 0; i < 20; i++) {
      _starParticles.add(StarParticle(
        x: _random.nextDouble() * 100.w,
        y: _random.nextDouble() * 100.h,
        size: _random.nextDouble() * 4 + 3,
        opacity: _random.nextDouble() * 0.5 + 0.5,
        twinkleSpeed: _random.nextDouble() * 2 + 1,
      ));
    }

    // Initialize coin particles
    for (int i = 0; i < 15; i++) {
      _coinParticles.add(CoinParticle(
        x: _random.nextDouble() * 100.w,
        y: _random.nextDouble() * 100.h,
        size: _random.nextDouble() * 6 + 8,
        floatSpeed: _random.nextDouble() * 1.5 + 0.5,
        phase: _random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      AppTheme.lightTheme.primaryColor,
      AppTheme.lightTheme.colorScheme.secondary,
      AppTheme.accentLight,
      AppTheme.successLight,
      AppTheme.warningLight,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _startAnimations() {
    _confettiController.repeat();
    _starsController.repeat(reverse: true);
    _coinsController.repeat();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _starsController.dispose();
    _coinsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.primaryColor.withAlpha((0.3 * 255).round()),
            AppTheme.lightTheme.colorScheme.secondary.withAlpha((0.2 * 255).round()),
            AppTheme.lightTheme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated confetti
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(100.w, 100.h),
                painter: ConfettiPainter(
                  particles: _confettiParticles,
                  animation: _confettiController,
                ),
              );
            },
          ),

          // Animated stars
          AnimatedBuilder(
            animation: _starsController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(100.w, 100.h),
                painter: StarsPainter(
                  particles: _starParticles,
                  animation: _starsController,
                ),
              );
            },
          ),

          // Animated coins
          AnimatedBuilder(
            animation: _coinsController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(100.w, 100.h),
                painter: CoinsPainter(
                  particles: _coinParticles,
                  animation: _coinsController,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ConfettiParticle {
  double x;
  double y;
  final Color color;
  final double size;
  final double velocity;
  final double rotation;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.velocity,
    required this.rotation,
  });
}

class StarParticle {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;

  StarParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
  });
}

class CoinParticle {
  final double x;
  final double y;
  final double size;
  final double floatSpeed;
  final double phase;

  CoinParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.floatSpeed,
    required this.phase,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final Animation<double> animation;

  ConfettiPainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      // Update particle position
      particle.y += particle.velocity;
      if (particle.y > size.height + 20) {
        particle.y = -20;
        particle.x = math.Random().nextDouble() * size.width;
      }

      paint.color = particle.color;
      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation + animation.value * 2 * math.pi);
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size * 2),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StarsPainter extends CustomPainter {
  final List<StarParticle> particles;
  final Animation<double> animation;

  StarsPainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppTheme.accentLight;

    for (final particle in particles) {
      final opacity = particle.opacity *
          (0.5 +
              0.5 *
                  math.sin(
                      animation.value * particle.twinkleSpeed * 2 * math.pi));
      paint.color = AppTheme.accentLight.withAlpha((opacity * 255).round());

      _drawStar(canvas, Offset(particle.x, particle.y), particle.size, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const int points = 5;
    final double angle = 2 * math.pi / points;
    final double radius = size;
    final double innerRadius = radius * 0.4;

    for (int i = 0; i < points * 2; i++) {
      final double currentAngle = i * angle / 2 - math.pi / 2;
      final double currentRadius = i.isEven ? radius : innerRadius;
      final double x = center.dx + currentRadius * math.cos(currentAngle);
      final double y = center.dy + currentRadius * math.sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CoinsPainter extends CustomPainter {
  final List<CoinParticle> particles;
  final Animation<double> animation;

  CoinsPainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentLight
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.orange.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final particle in particles) {
      final floatOffset = 10 *
          math.sin(animation.value * particle.floatSpeed * 2 * math.pi +
              particle.phase);
      final center = Offset(particle.x, particle.y + floatOffset);

      // Draw coin shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withAlpha((0.2 * 255).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(
        Offset(center.dx + 2, center.dy + 2),
        particle.size / 2,
        shadowPaint,
      );

      // Draw coin
      canvas.drawCircle(center, particle.size / 2, paint);
      canvas.drawCircle(center, particle.size / 2, strokePaint);

      // Draw coin symbol
      final textPainter = TextPainter(
        text: TextSpan(
          text: '\$',
          style: TextStyle(
            color: Colors.orange.shade800,
            fontSize: particle.size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
