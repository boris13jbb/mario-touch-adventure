import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementWidget extends StatefulWidget {
  final List<String> achievements;

  const AchievementWidget({
    Key? key,
    required this.achievements,
  }) : super(key: key);

  @override
  State<AchievementWidget> createState() => _AchievementWidgetState();
}

class _AchievementWidgetState extends State<AchievementWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    if (widget.achievements.isNotEmpty) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: 85.w,
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentLight.withAlpha((0.2 * 255).round()),
                    AppTheme.successLight.withAlpha((0.2 * 255).round()),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: AppTheme.accentLight.withAlpha((0.5 * 255).round()),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'emoji_events',
                        color: AppTheme.accentLight,
                        size: 6.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '¡Logros Desbloqueados!',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.accentLight,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  ...widget.achievements
                      .map((achievement) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.5.h),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: AppTheme.accentLight,
                                  size: 4.w,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    achievement,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
