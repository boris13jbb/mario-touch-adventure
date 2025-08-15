import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../../core/color_utils.dart';

import '../../../core/app_export.dart';

class GameControlsWidget extends StatefulWidget {
  final Function(String) onMovement;
  final VoidCallback onJump;
  final VoidCallback onAttack;

  const GameControlsWidget({
    Key? key,
    required this.onMovement,
    required this.onJump,
    required this.onAttack,
  }) : super(key: key);

  @override
  State<GameControlsWidget> createState() => _GameControlsWidgetState();
}

class _GameControlsWidgetState extends State<GameControlsWidget> {
  String _currentDirection = '';
  bool _isJumpPressed = false;
  bool _isAttackPressed = false;

  void _handleMovement(String direction) {
    if (_currentDirection != direction) {
      setState(() {
        _currentDirection = direction;
      });
      widget.onMovement(direction);
      HapticFeedback.selectionClick();
    }
  }

  void _stopMovement() {
    if (_currentDirection.isNotEmpty) {
      setState(() {
        _currentDirection = '';
      });
      widget.onMovement('');
    }
  }

  void _handleJump() {
    setState(() {
      _isJumpPressed = true;
    });
    widget.onJump();
    HapticFeedback.mediumImpact();

    Future.delayed(Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _isJumpPressed = false;
        });
      }
    });
  }

  void _handleAttack() {
    setState(() {
      _isAttackPressed = true;
    });
    widget.onAttack();
    HapticFeedback.heavyImpact();

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isAttackPressed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Virtual joystick
          _buildVirtualJoystick(),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildVirtualJoystick() {
    return Container(
      width: 25.w,
      height: 25.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Joystick base
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.2 * 255).round()),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withAlpha((0.3 * 255).round()),
                width: 2,
              ),
            ),
          ),

          // Directional buttons
          Positioned(
            top: 0,
            child: GestureDetector(
              onTapDown: (_) => _handleMovement('up'),
              onTapUp: (_) => _stopMovement(),
              onTapCancel: () => _stopMovement(),
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _currentDirection == 'up'
                      ? AppTheme.lightTheme.primaryColor.withAlpha((0.8 * 255).round())
                      : Colors.white.withAlpha((0.3 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'keyboard_arrow_up',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            child: GestureDetector(
              onTapDown: (_) => _handleMovement('left'),
              onTapUp: (_) => _stopMovement(),
              onTapCancel: () => _stopMovement(),
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _currentDirection == 'left'
                      ? AppTheme.lightTheme.primaryColor.withAlpha((0.8 * 255).round())
                      : Colors.white.withAlpha((0.3 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'keyboard_arrow_left',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 0,
            child: GestureDetector(
              onTapDown: (_) => _handleMovement('right'),
              onTapUp: (_) => _stopMovement(),
              onTapCancel: () => _stopMovement(),
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _currentDirection == 'right'
                      ? AppTheme.lightTheme.primaryColor.withAlpha((0.8 * 255).round())
                      : Colors.white.withAlpha((0.3 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'keyboard_arrow_right',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Attack button
        GestureDetector(
          onTap: _handleAttack,
          child: Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: _isAttackPressed
                  ? Colors.red.withAlpha((0.9 * 255).round())
                  : Colors.red.withAlpha((0.7 * 255).round()),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.3 * 255).round()),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'flash_on',
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Jump button
        GestureDetector(
          onTap: _handleJump,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: _isJumpPressed
                  ? AppTheme.successLight.withAlpha((0.9 * 255).round())
                  : AppTheme.successLight.withAlpha((0.7 * 255).round()),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.3 * 255).round()),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'SALTO',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
