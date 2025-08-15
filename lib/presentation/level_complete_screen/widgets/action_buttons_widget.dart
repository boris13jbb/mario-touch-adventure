import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ActionButtonsWidget extends StatefulWidget {
  final VoidCallback onReplay;
  final VoidCallback onLevelSelect;
  final VoidCallback onShare;

  const ActionButtonsWidget({
    Key? key,
    required this.onReplay,
    required this.onLevelSelect,
    required this.onShare,
  }) : super(key: key);

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSlideAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimations = [
      Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      )),
      Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      )),
      Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      )),
    ];

    _scaleAnimations = [
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
        ),
      ),
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
        ),
      ),
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
        ),
      ),
    ];
  }

  void _startSlideAnimations() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  void _handleButtonPress(VoidCallback callback) {
    HapticFeedback.lightImpact();
    callback();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Primary action button (Replay)
          SlideTransition(
            position: _slideAnimations[0],
            child: ScaleTransition(
              scale: _scaleAnimations[0],
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleButtonPress(widget.onReplay),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'replay',
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Repetir Nivel',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Secondary action buttons row
          Row(
            children: [
              // Level select button
              Expanded(
                child: SlideTransition(
                  position: _slideAnimations[1],
                  child: ScaleTransition(
                    scale: _scaleAnimations[1],
                    child: OutlinedButton(
                      onPressed: () => _handleButtonPress(widget.onLevelSelect),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.lightTheme.primaryColor,
                        side: BorderSide(
                          color: AppTheme.lightTheme.primaryColor,
                          width: 2,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1.8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'grid_view',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 20,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Seleccionar\nNivel',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Share button
              Expanded(
                child: SlideTransition(
                  position: _slideAnimations[2],
                  child: ScaleTransition(
                    scale: _scaleAnimations[2],
                    child: OutlinedButton(
                      onPressed: () => _handleButtonPress(widget.onShare),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.successLight,
                        side: BorderSide(
                          color: AppTheme.successLight,
                          width: 2,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1.8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'share',
                            color: AppTheme.successLight,
                            size: 20,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Compartir\nLogro',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.successLight,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Back to menu button
          TextButton(
            onPressed: () => _handleButtonPress(() {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main-menu-screen',
                (route) => false,
              );
            }),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.onSurface
                  .withAlpha((0.7 * 255).round()),
              padding: EdgeInsets.symmetric(vertical: 1.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'home',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withAlpha((0.7 * 255).round()),
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Volver al Menú Principal',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withAlpha((0.7 * 255).round()),
                    fontWeight: FontWeight.w500,
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
