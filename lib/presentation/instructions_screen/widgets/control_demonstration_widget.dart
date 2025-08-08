import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ControlDemonstrationWidget extends StatefulWidget {
  const ControlDemonstrationWidget({super.key});

  @override
  State<ControlDemonstrationWidget> createState() =>
      _ControlDemonstrationWidgetState();
}

class _ControlDemonstrationWidgetState extends State<ControlDemonstrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _characterController;
  late AnimationController _pulseController;
  late Animation<double> _characterAnimation;
  late Animation<double> _pulseAnimation;

  bool _isMovingLeft = false;
  bool _isMovingRight = false;
  bool _isJumping = false;
  bool _isShooting = false;

  @override
  void initState() {
    super.initState();

    _characterController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _characterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _characterController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _performAction(String action) {
    setState(() {
      switch (action) {
        case 'left':
          _isMovingLeft = true;
          _isMovingRight = false;
          break;
        case 'right':
          _isMovingRight = true;
          _isMovingLeft = false;
          break;
        case 'jump':
          _isJumping = true;
          break;
        case 'shoot':
          _isShooting = true;
          break;
      }
    });

    _characterController.forward().then((_) {
      _characterController.reverse();
      setState(() {
        _isMovingLeft = false;
        _isMovingRight = false;
        _isJumping = false;
        _isShooting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 35.h,
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
        children: [
          // Title
          Text(
            'Área de Práctica',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),

          // Character demonstration area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Stack(
                children: [
                  // Background elements
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

                  // Animated character
                  AnimatedBuilder(
                    animation: _characterAnimation,
                    builder: (context, child) {
                      return Positioned(
                        bottom: _isJumping
                            ? 8.h + (_characterAnimation.value * 6.h)
                            : 3.h,
                        left: _isMovingLeft
                            ? 10.w - (_characterAnimation.value * 8.w)
                            : _isMovingRight
                                ? 10.w + (_characterAnimation.value * 8.w)
                                : 10.w,
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: _isJumping
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : _isShooting
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                    : AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.shadow
                                    .withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: _isJumping
                                  ? 'keyboard_arrow_up'
                                  : _isShooting
                                      ? 'radio_button_unchecked'
                                      : 'person',
                              color: Colors.white,
                              size: 4.w,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Projectile animation
                  if (_isShooting)
                    AnimatedBuilder(
                      animation: _characterAnimation,
                      builder: (context, child) {
                        return Positioned(
                          bottom: 5.h,
                          left: 18.w + (_characterAnimation.value * 20.w),
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
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Control buttons
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // Movement controls
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'Movimiento',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: GestureDetector(
                                      onTap: () => _performAction('left'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _isMovingLeft
                                              ? AppTheme.lightTheme.colorScheme
                                                  .primary
                                              : AppTheme.lightTheme.colorScheme
                                                  .surface,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppTheme
                                                .lightTheme.colorScheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: CustomIconWidget(
                                            iconName: 'keyboard_arrow_left',
                                            color: _isMovingLeft
                                                ? Colors.white
                                                : AppTheme.lightTheme
                                                    .colorScheme.primary,
                                            size: 6.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: GestureDetector(
                                      onTap: () => _performAction('right'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _isMovingRight
                                              ? AppTheme.lightTheme.colorScheme
                                                  .primary
                                              : AppTheme.lightTheme.colorScheme
                                                  .surface,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppTheme
                                                .lightTheme.colorScheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: CustomIconWidget(
                                            iconName: 'keyboard_arrow_right',
                                            color: _isMovingRight
                                                ? Colors.white
                                                : AppTheme.lightTheme
                                                    .colorScheme.primary,
                                            size: 6.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 4.w),

                // Action buttons
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      // Jump button
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Saltar',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: GestureDetector(
                                      onTap: () => _performAction('jump'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _isJumping
                                              ? AppTheme.lightTheme.colorScheme
                                                  .secondary
                                              : AppTheme.lightTheme.colorScheme
                                                  .surface,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.lightTheme
                                                .colorScheme.secondary,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: CustomIconWidget(
                                            iconName: 'keyboard_arrow_up',
                                            color: _isJumping
                                                ? Colors.white
                                                : AppTheme.lightTheme
                                                    .colorScheme.secondary,
                                            size: 6.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 2.w),

                      // Shoot button
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Disparar',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Expanded(
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: GestureDetector(
                                      onTap: () => _performAction('shoot'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _isShooting
                                              ? AppTheme.lightTheme.colorScheme
                                                  .tertiary
                                              : AppTheme.lightTheme.colorScheme
                                                  .surface,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.lightTheme
                                                .colorScheme.tertiary,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: CustomIconWidget(
                                            iconName: 'radio_button_unchecked',
                                            color: _isShooting
                                                ? Colors.white
                                                : AppTheme.lightTheme
                                                    .colorScheme.tertiary,
                                            size: 5.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
          ),
        ],
      ),
    );
  }
}
