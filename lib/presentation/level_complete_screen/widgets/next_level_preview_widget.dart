import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class NextLevelPreviewWidget extends StatefulWidget {
  final Map<String, dynamic> nextLevelData;
  final VoidCallback onNextLevel;

  const NextLevelPreviewWidget({
    Key? key,
    required this.nextLevelData,
    required this.onNextLevel,
  }) : super(key: key);

  @override
  State<NextLevelPreviewWidget> createState() => _NextLevelPreviewWidgetState();
}

class _NextLevelPreviewWidgetState extends State<NextLevelPreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializePulseAnimation();
  }

  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Text(
            'Próximo Desafío',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Level thumbnail
                Container(
                  width: double.infinity,
                  height: 20.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                        AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      CustomPaint(
                        size: Size(double.infinity, 20.h),
                        painter: LevelPreviewPainter(),
                      ),

                      // Level info overlay
                      Positioned(
                        top: 2.h,
                        left: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Nivel ${widget.nextLevelData['levelNumber']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Difficulty indicators
                      Positioned(
                        top: 2.h,
                        right: 4.w,
                        child: Row(
                          children: List.generate(
                            widget.nextLevelData['difficulty'] as int? ?? 1,
                            (index) => Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: CustomIconWidget(
                                iconName: 'local_fire_department',
                                color: AppTheme.warningColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Center play icon
                      Center(
                        child: Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'play_arrow',
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Level details
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.nextLevelData['name'] as String? ??
                                'Nivel Desconocido',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            widget.nextLevelData['description'] as String? ??
                                'Nuevo desafío te espera',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Column(
                      children: [
                        _buildStatChip(
                          icon: 'monetization_on',
                          value: '${widget.nextLevelData['totalCoins']}',
                          color: AppTheme.accentColor,
                        ),
                        SizedBox(height: 1.h),
                        _buildStatChip(
                          icon: 'sports_kabaddi',
                          value: '${widget.nextLevelData['totalEnemies']}',
                          color: AppTheme.warningColor,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Next level button
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onNextLevel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Siguiente Nivel',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'arrow_forward',
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required String icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class LevelPreviewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw simple geometric pattern
    final path = Path();

    // Draw mountains/hills pattern
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5,
        size.width * 0.5, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.7, size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw some decorative circles
    final circlePaint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.3), 20, circlePaint);
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2), 15, circlePaint);
    canvas.drawCircle(
        Offset(size.width * 0.6, size.height * 0.4), 12, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
