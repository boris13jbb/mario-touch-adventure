import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StarRatingWidget extends StatefulWidget {
  final int stars;
  final VoidCallback? onAnimationComplete;

  const StarRatingWidget({
    Key? key,
    required this.stars,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _starControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rotationAnimations;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startStarAnimations();
  }

  void _initializeAnimations() {
    _starControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      ),
    );

    _scaleAnimations = _starControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _rotationAnimations = _starControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  void _startStarAnimations() async {
    for (int i = 0; i < widget.stars; i++) {
      await Future.delayed(Duration(milliseconds: 300 * i));
      if (mounted) {
        _starControllers[i].forward();
        _triggerHapticFeedback();
      }
    }

    if (mounted) {
      _glowController.repeat(reverse: true);
      widget.onAnimationComplete?.call();
    }
  }

  void _triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    for (final controller in _starControllers) {
      controller.dispose();
    }
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        children: [
          Text(
            'Puntuación',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isEarned = index < widget.stars;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _starControllers[index],
                    _glowController,
                  ]),
                  builder: (context, child) {
                    final scale =
                        isEarned ? _scaleAnimations[index].value : 0.8;
                    final rotation =
                        isEarned ? _rotationAnimations[index].value : 0.0;
                    final glow = isEarned ? _glowAnimation.value : 0.0;

                    return Transform.scale(
                      scale: scale,
                      child: Transform.rotate(
                        angle: rotation * 0.5,
                        child: Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: isEarned
                                ? [
                                    BoxShadow(
                                      color: AppTheme.accentColor
                                          .withValues(alpha: glow * 0.6),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ]
                                : null,
                          ),
                          child: CustomPaint(
                            size: Size(15.w, 15.w),
                            painter: StarPainter(
                              isEarned: isEarned,
                              glowIntensity: glow,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          Text(
            _getStarMessage(),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStarMessage() {
    switch (widget.stars) {
      case 3:
        return '¡Perfecto! Rendimiento excepcional';
      case 2:
        return '¡Muy bien! Buen rendimiento';
      case 1:
        return '¡Completado! Puedes mejorar';
      default:
        return 'Inténtalo de nuevo';
    }
  }
}

class StarPainter extends CustomPainter {
  final bool isEarned;
  final double glowIntensity;

  StarPainter({required this.isEarned, required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = isEarned
          ? AppTheme.accentColor
          : AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = isEarned
          ? Colors.orange.shade800
          : AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);

    // Draw glow effect for earned stars
    if (isEarned && glowIntensity > 0) {
      final glowPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = AppTheme.accentColor.withValues(alpha: glowIntensity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      _drawStar(canvas, center, radius * 1.2, glowPaint);
    }

    // Draw main star
    _drawStar(canvas, center, radius, paint);
    _drawStar(canvas, center, radius, strokePaint);

    // Draw inner highlight for earned stars
    if (isEarned) {
      final highlightPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white.withValues(alpha: 0.3);
      _drawStar(canvas, center, radius * 0.6, highlightPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const int points = 5;
    final double angle = (2 * 3.14159) / points;
    final double innerRadius = radius * 0.4;

    final path = Path();

    for (int i = 0; i < points * 2; i++) {
      final double currentAngle = i * angle / 2 - 3.14159 / 2;
      final double currentRadius = i.isEven ? radius : innerRadius;
      final double x = center.dx + currentRadius * cos(currentAngle);
      final double y = center.dy + currentRadius * sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  double cos(double angle) => math.cos(angle);
  double sin(double angle) => math.sin(angle);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}