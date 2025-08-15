import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../../core/app_export.dart';

class GameplayMechanicsWidget extends StatefulWidget {
  const GameplayMechanicsWidget({super.key});

  @override
  State<GameplayMechanicsWidget> createState() =>
      _GameplayMechanicsWidgetState();
}

class _GameplayMechanicsWidgetState extends State<GameplayMechanicsWidget>
    with TickerProviderStateMixin {
  late AnimationController _coinController;
  late AnimationController _enemyController;
  late AnimationController _obstacleController;
  late Animation<double> _coinAnimation;
  late Animation<double> _enemyAnimation;
  late Animation<double> _obstacleAnimation;

  int _selectedMechanic = 0;

  final List<Map<String, dynamic>> _mechanics = [
    {
      'title': 'Recolección de Monedas',
      'description':
          'Toca las monedas doradas para sumar puntos. Cada moneda vale 100 puntos.',
      'icon': 'monetization_on',
      'color': Color(0xFFFFD700),
    },
    {
      'title': 'Eliminación de Enemigos',
      'description':
          'Dispara proyectiles para eliminar enemigos. Cada enemigo eliminado vale 200 puntos.',
      'icon': 'gps_fixed',
      'color': Color(0xFFFF6B6B),
    },
    {
      'title': 'Navegación de Obstáculos',
      'description':
          'Salta sobre obstáculos y plataformas para avanzar en el nivel.',
      'icon': 'terrain',
      'color': Color(0xFF4ECDC4),
    },
  ];

  @override
  void initState() {
    super.initState();

    _coinController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _enemyController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _obstacleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _coinAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _coinController,
      curve: Curves.easeInOut,
    ));

    _enemyAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _enemyController,
      curve: Curves.linear,
    ));

    _obstacleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _obstacleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _coinController.dispose();
    _enemyController.dispose();
    _obstacleController.dispose();
    super.dispose();
  }

  Widget _buildMechanicDemo(int index) {
    switch (index) {
      case 0:
        return _buildCoinDemo();
      case 1:
        return _buildEnemyDemo();
      case 2:
        return _buildObstacleDemo();
      default:
        return Container();
    }
  }

  Widget _buildCoinDemo() {
    return Container(
      height: 20.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha((0.3 * 255).round()),
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
                  .withAlpha((0.3 * 255).round()),
            ),
          ),

          // Character
          Positioned(
            bottom: 3.h,
            left: 10.w,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
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

          // Animated coins
          AnimatedBuilder(
            animation: _coinAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 8.h + (2 * sin(_coinAnimation.value * 2 * pi)).h,
                left: 25.w + (_coinAnimation.value * 30.w),
                child: Transform.rotate(
                  angle: _coinAnimation.value * 2 * pi,
                  child: Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withAlpha((0.3 * 255).round()),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'monetization_on',
                        color: Colors.white,
                        size: 3.w,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Score indicator
          Positioned(
            top: 2.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+100',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnemyDemo() {
    return Container(
      height: 20.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha((0.3 * 255).round()),
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
                  .withAlpha((0.3 * 255).round()),
            ),
          ),

          // Character
          Positioned(
            bottom: 3.h,
            left: 10.w,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
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

          // Moving enemy
          AnimatedBuilder(
            animation: _enemyAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 3.h,
                left: 60.w + (_enemyAnimation.value * 20.w),
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'bug_report',
                      color: Colors.white,
                      size: 3.w,
                    ),
                  ),
                ),
              );
            },
          ),

          // Projectile
          AnimatedBuilder(
            animation: _enemyAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 5.h,
                left: 18.w + (_enemyAnimation.value * 40.w),
                child: Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),

          // Score indicator
          Positioned(
            top: 2.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+200',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObstacleDemo() {
    return Container(
      height: 20.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha((0.3 * 255).round()),
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
                  .withAlpha((0.3 * 255).round()),
            ),
          ),

          // Animated character jumping
          AnimatedBuilder(
            animation: _obstacleAnimation,
            builder: (context, child) {
              double jumpHeight = _obstacleAnimation.value > 1.0
                  ? 8.h + ((2.0 - _obstacleAnimation.value) * 6.h)
                  : 3.h + ((_obstacleAnimation.value - 0.8) * 30).h;

              return Positioned(
                bottom: jumpHeight,
                left: 15.w,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary,
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
              );
            },
          ),

          // Obstacles
          Positioned(
            bottom: 3.h,
            left: 30.w,
            child: Container(
              width: 8.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'terrain',
                  color: Colors.white,
                  size: 4.w,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 3.h,
            left: 50.w,
            child: Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'terrain',
                  color: Colors.white,
                  size: 4.w,
                ),
              ),
            ),
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
          color: AppTheme.lightTheme.colorScheme.primary.withAlpha((0.3 * 255).round()),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withAlpha((0.1 * 255).round()),
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
            'Mecánicas de Juego',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),

          // Mechanic selector
          Container(
            height: 6.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _mechanics.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final mechanic = _mechanics[index];
                final isSelected = _selectedMechanic == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedMechanic = index),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? mechanic['color'] as Color
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: mechanic['color'] as Color,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: mechanic['icon'] as String,
                          color: isSelected
                              ? Colors.white
                              : mechanic['color'] as Color,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          mechanic['title'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : mechanic['color'] as Color,
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

          // Selected mechanic demonstration
          _buildMechanicDemo(_selectedMechanic),

          SizedBox(height: 2.h),

          // Description
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (_mechanics[_selectedMechanic]['color'] as Color)
                  .withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (_mechanics[_selectedMechanic]['color'] as Color)
                    .withAlpha((0.3 * 255).round()),
              ),
            ),
            child: Text(
              _mechanics[_selectedMechanic]['description'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
