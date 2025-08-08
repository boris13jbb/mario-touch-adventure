import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../../core/app_export.dart';

class AdvancedTechniquesWidget extends StatefulWidget {
  const AdvancedTechniquesWidget({super.key});

  @override
  State<AdvancedTechniquesWidget> createState() =>
      _AdvancedTechniquesWidgetState();
}

class _AdvancedTechniquesWidgetState extends State<AdvancedTechniquesWidget>
    with TickerProviderStateMixin {
  late AnimationController _doubleJumpController;
  late AnimationController _secretController;
  late AnimationController _powerUpController;
  late Animation<double> _doubleJumpAnimation;
  late Animation<double> _secretAnimation;
  late Animation<double> _powerUpAnimation;

  int _selectedTechnique = 0;

  final List<Map<String, dynamic>> _techniques = [
    {
      'title': 'Doble Salto',
      'description':
          'Toca el botón de salto dos veces rápidamente para realizar un doble salto y alcanzar plataformas más altas.',
      'icon': 'keyboard_double_arrow_up',
      'color': Color(0xFF9C27B0),
      'tip': 'Timing perfecto: 0.5 segundos entre saltos',
    },
    {
      'title': 'Áreas Secretas',
      'description':
          'Busca paredes agrietadas o plataformas ocultas. Salta hacia ellas para descubrir áreas secretas con recompensas.',
      'icon': 'search',
      'color': Color(0xFFFF9800),
      'tip': 'Las áreas secretas brillan sutilmente',
    },
    {
      'title': 'Power-ups',
      'description':
          'Recolecta power-ups especiales para obtener habilidades temporales como velocidad extra o invencibilidad.',
      'icon': 'flash_on',
      'color': Color(0xFF2196F3),
      'tip': 'Los efectos duran 10 segundos',
    },
  ];

  @override
  void initState() {
    super.initState();

    _doubleJumpController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _secretController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _powerUpController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _doubleJumpAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _doubleJumpController,
      curve: Curves.easeInOut,
    ));

    _secretAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _secretController,
      curve: Curves.easeInOut,
    ));

    _powerUpAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _powerUpController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _doubleJumpController.dispose();
    _secretController.dispose();
    _powerUpController.dispose();
    super.dispose();
  }

  Widget _buildTechniqueDemo(int index) {
    switch (index) {
      case 0:
        return _buildDoubleJumpDemo();
      case 1:
        return _buildSecretAreaDemo();
      case 2:
        return _buildPowerUpDemo();
      default:
        return Container();
    }
  }

  Widget _buildDoubleJumpDemo() {
    return Container(
      height: 22.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        children: [
          // Background platforms
          Positioned(
            bottom: 2.h,
            left: 0,
            right: 0,
            child: Container(
              height: 1.h,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),

          // High platform
          Positioned(
            bottom: 15.h,
            right: 15.w,
            child: Container(
              width: 20.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Animated character with double jump
          AnimatedBuilder(
            animation: _doubleJumpAnimation,
            builder: (context, child) {
              double progress = _doubleJumpAnimation.value;
              double characterX = 10.w + (progress * 50.w);
              double characterY;

              if (progress < 0.3) {
                // First jump
                characterY = 3.h + (sin(progress * pi / 0.3) * 8.h);
              } else if (progress < 0.6) {
                // Second jump (double jump)
                double secondJumpProgress = (progress - 0.3) / 0.3;
                characterY = 8.h + (sin(secondJumpProgress * pi) * 10.h);
              } else {
                // Landing on high platform
                characterY = 17.h;
              }

              return Positioned(
                bottom: characterY,
                left: characterX,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: Colors.white,
                      size: 3.w,
                    ),
                  ),
                ),
              );
            },
          ),

          // Jump indicators
          AnimatedBuilder(
            animation: _doubleJumpAnimation,
            builder: (context, child) {
              if (_doubleJumpAnimation.value < 0.3) {
                return Positioned(
                  bottom: 10.h,
                  left: 20.w,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '1er Salto',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              } else if (_doubleJumpAnimation.value < 0.6) {
                return Positioned(
                  bottom: 16.h,
                  left: 35.w,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '2do Salto',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecretAreaDemo() {
    return Container(
      height: 22.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        children: [
          // Background
          Positioned(
            bottom: 2.h,
            left: 0,
            right: 0,
            child: Container(
              height: 1.h,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),

          // Normal wall
          Positioned(
            bottom: 3.h,
            right: 20.w,
            child: Container(
              width: 3.w,
              height: 15.h,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.5),
            ),
          ),

          // Secret wall with glowing effect
          AnimatedBuilder(
            animation: _secretAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 3.h,
                right: 5.w,
                child: Container(
                  width: 3.w,
                  height: 15.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800)
                        .withValues(alpha: _secretAnimation.value * 0.7),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9800)
                            .withValues(alpha: _secretAnimation.value * 0.5),
                        blurRadius: 12,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Character
          Positioned(
            bottom: 3.h,
            left: 15.w,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'person',
                  color: Colors.white,
                  size: 3.w,
                ),
              ),
            ),
          ),

          // Hidden treasure
          AnimatedBuilder(
            animation: _secretAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 8.h,
                right: 2.w,
                child: Opacity(
                  opacity: _secretAnimation.value,
                  child: Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'star',
                        color: Colors.white,
                        size: 3.w,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Search indicator
          Positioned(
            top: 2.h,
            left: 4.w,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'search',
                    color: Colors.white,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Busca el brillo',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerUpDemo() {
    return Container(
      height: 22.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        children: [
          // Background
          Positioned(
            bottom: 2.h,
            left: 0,
            right: 0,
            child: Container(
              height: 1.h,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),

          // Power-up item
          AnimatedBuilder(
            animation: _powerUpAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 8.h + (sin(_powerUpAnimation.value * 2 * pi) * 2).h,
                left: 30.w,
                child: Transform.rotate(
                  angle: _powerUpAnimation.value * 2 * pi,
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2196F3).withValues(alpha: 0.5),
                          blurRadius: 12,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'flash_on',
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Character with power-up effect
          AnimatedBuilder(
            animation: _powerUpAnimation,
            builder: (context, child) {
              bool hasPowerUp = _powerUpAnimation.value > 0.5;
              return Positioned(
                bottom: 3.h,
                left: 15.w,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: hasPowerUp
                        ? const Color(0xFF2196F3)
                        : AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: hasPowerUp
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2196F3)
                                  .withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: Colors.white,
                      size: 3.w,
                    ),
                  ),
                ),
              );
            },
          ),

          // Power-up effects
          AnimatedBuilder(
            animation: _powerUpAnimation,
            builder: (context, child) {
              if (_powerUpAnimation.value > 0.5) {
                return Positioned(
                  top: 2.h,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'flash_on',
                          color: Colors.white,
                          size: 3.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Velocidad x2',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Técnicas Avanzadas',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),

          // Technique selector
          Container(
            height: 6.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _techniques.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final technique = _techniques[index];
                final isSelected = _selectedTechnique == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedTechnique = index),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? technique['color'] as Color
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: technique['color'] as Color,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: technique['icon'] as String,
                          color: isSelected
                              ? Colors.white
                              : technique['color'] as Color,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          technique['title'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : technique['color'] as Color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 3.h),

          // Selected technique demonstration
          _buildTechniqueDemo(_selectedTechnique),

          SizedBox(height: 2.h),

          // Description
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (_techniques[_selectedTechnique]['color'] as Color)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (_techniques[_selectedTechnique]['color'] as Color)
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _techniques[_selectedTechnique]['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: (_techniques[_selectedTechnique]['color'] as Color)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb',
                        color:
                            _techniques[_selectedTechnique]['color'] as Color,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Consejo: ${_techniques[_selectedTechnique]['tip']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _techniques[_selectedTechnique]['color']
                                as Color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}