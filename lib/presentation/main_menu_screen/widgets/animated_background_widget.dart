import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnimatedBackgroundWidget extends StatefulWidget {
  const AnimatedBackgroundWidget({Key? key}) : super(key: key);

  @override
  State<AnimatedBackgroundWidget> createState() =>
      _AnimatedBackgroundWidgetState();
}

class _AnimatedBackgroundWidgetState extends State<AnimatedBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _cloudController;
  late AnimationController _coinController;
  late Animation<double> _cloudAnimation;
  late Animation<double> _coinAnimation;

  @override
  void initState() {
    super.initState();

    _cloudController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _coinController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _cloudAnimation = Tween<double>(
      begin: -100.w,
      end: 100.w,
    ).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.linear,
    ));

    _coinAnimation = Tween<double>(
      begin: 0,
      end: 20,
    ).animate(CurvedAnimation(
      parent: _coinController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _coinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.secondary,
            AppTheme.lightTheme.colorScheme.primary,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Moving clouds
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) {
              return Positioned(
                top: 15.h,
                left: _cloudAnimation.value,
                child: CustomImageWidget(
                  imageUrl:
                      "https://images.pexels.com/photos/158163/clouds-cloudporn-weather-lookup-158163.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                  width: 25.w,
                  height: 8.h,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _cloudAnimation,
            builder: (context, child) {
              return Positioned(
                top: 25.h,
                left: _cloudAnimation.value + 40.w,
                child: CustomImageWidget(
                  imageUrl:
                      "https://images.pexels.com/photos/158163/clouds-cloudporn-weather-lookup-158163.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                  width: 20.w,
                  height: 6.h,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          // Floating coins
          AnimatedBuilder(
            animation: _coinAnimation,
            builder: (context, child) {
              return Positioned(
                top: 35.h + _coinAnimation.value,
                left: 20.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '\$',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _coinAnimation,
            builder: (context, child) {
              return Positioned(
                top: 45.h - _coinAnimation.value,
                right: 25.w,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '\$',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
