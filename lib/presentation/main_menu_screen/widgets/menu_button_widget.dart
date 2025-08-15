import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MenuButtonWidget extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final bool isPrimary;

  const MenuButtonWidget({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  State<MenuButtonWidget> createState() => _MenuButtonWidgetState();
}

class _MenuButtonWidgetState extends State<MenuButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              width: 80.w,
              height: widget.isPrimary ? 8.h : 7.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.backgroundColor,
                    widget.backgroundColor.withAlpha((0.8 * 255).round()),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? Colors.black.withAlpha((0.1 * 255).round())
                        : Colors.black.withAlpha((0.3 * 255).round()),
                    blurRadius: _isPressed ? 4 : 8,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withAlpha((0.3 * 255).round()),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: widget.isPrimary ? 16.sp : 14.sp,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withAlpha((0.5 * 255).round()),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
