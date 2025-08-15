import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/audio_manager.dart';

class EnhancedGameControlsWidget extends StatefulWidget {
  final Function(String) onMovement;
  final VoidCallback onJump;
  final VoidCallback onAttack;

  const EnhancedGameControlsWidget({
    Key? key,
    required this.onMovement,
    required this.onJump,
    required this.onAttack,
  }) : super(key: key);

  @override
  State<EnhancedGameControlsWidget> createState() => _EnhancedGameControlsWidgetState();
}

class _EnhancedGameControlsWidgetState extends State<EnhancedGameControlsWidget>
    with TickerProviderStateMixin {
  // Touch states
  bool _isLeftPressed = false;
  bool _isRightPressed = false;
  bool _isJumpPressed = false;
  bool _isAttackPressed = false;
  
  // Animation controllers
  late AnimationController _leftButtonController;
  late AnimationController _rightButtonController;
  late AnimationController _jumpButtonController;
  late AnimationController _attackButtonController;
  
  // Haptic feedback
  // final HapticFeedback _hapticFeedback = HapticFeedback();
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }
  
  void _setupAnimations() {
    _leftButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _rightButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _jumpButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _attackButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Movement controls (left side)
          Positioned(
            left: 5.w,
            bottom: 5.h,
            child: Row(
              children: [
                _buildMovementButton(
                  icon: Icons.arrow_back,
                  isPressed: _isLeftPressed,
                  controller: _leftButtonController,
                  onTapDown: () => _handleLeftPress(),
                  onTapUp: () => _handleLeftRelease(),
                  onTapCancel: () => _handleLeftRelease(),
                ),
                SizedBox(width: 3.w),
                _buildMovementButton(
                  icon: Icons.arrow_forward,
                  isPressed: _isRightPressed,
                  controller: _rightButtonController,
                  onTapDown: () => _handleRightPress(),
                  onTapUp: () => _handleRightRelease(),
                  onTapCancel: () => _handleRightRelease(),
                ),
              ],
            ),
          ),
          
          // Action controls (right side)
          Positioned(
            right: 5.w,
            bottom: 5.h,
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.keyboard_arrow_up,
                  isPressed: _isJumpPressed,
                  controller: _jumpButtonController,
                  onTapDown: () => _handleJumpPress(),
                  onTapUp: () => _handleJumpRelease(),
                  onTapCancel: () => _handleJumpRelease(),
                  color: AppTheme.successLight,
                ),
                SizedBox(width: 3.w),
                _buildActionButton(
                  icon: Icons.flash_on,
                  isPressed: _isAttackPressed,
                  controller: _attackButtonController,
                  onTapDown: () => _handleAttackPress(),
                  onTapUp: () => _handleAttackRelease(),
                  onTapCancel: () => _handleAttackRelease(),
                  color: AppTheme.warningLight,
                ),
              ],
            ),
          ),
          
          // Center joystick area (alternative control)
          Positioned(
            left: 50.w - 15.w,
            bottom: 5.h,
            child: _buildJoystickArea(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMovementButton({
    required IconData icon,
    required bool isPressed,
    required AnimationController controller,
    required VoidCallback onTapDown,
    required VoidCallback onTapUp,
    required VoidCallback onTapCancel,
  }) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: () => onTapCancel(),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (controller.value * 0.1),
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isPressed 
                    ? AppTheme.primaryLight.withOpacity(0.8)
                    : AppTheme.primaryLight.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12.w / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 6.w,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required bool isPressed,
    required AnimationController controller,
    required VoidCallback onTapDown,
    required VoidCallback onTapUp,
    required VoidCallback onTapCancel,
    required Color color,
  }) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: () => onTapCancel(),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (controller.value * 0.1),
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isPressed 
                    ? color.withOpacity(0.8)
                    : color.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12.w / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 6.w,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildJoystickArea() {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.w / 2),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.w / 2),
          ),
        ),
      ),
    );
  }
  
  void _handleLeftPress() {
    if (!_isLeftPressed) {
      setState(() {
        _isLeftPressed = true;
      });
      _leftButtonController.forward();
      widget.onMovement('left');
      HapticFeedback.selectionClick();
      AudioManager().playButtonClickSound();
    }
  }
  
  void _handleLeftRelease() {
    if (_isLeftPressed) {
      setState(() {
        _isLeftPressed = false;
      });
      _leftButtonController.reverse();
      widget.onMovement('');
    }
  }
  
  void _handleRightPress() {
    if (!_isRightPressed) {
      setState(() {
        _isRightPressed = true;
      });
      _rightButtonController.forward();
      widget.onMovement('right');
      HapticFeedback.selectionClick();
      AudioManager().playButtonClickSound();
    }
  }
  
  void _handleRightRelease() {
    if (_isRightPressed) {
      setState(() {
        _isRightPressed = false;
      });
      _rightButtonController.reverse();
      widget.onMovement('');
    }
  }
  
  void _handleJumpPress() {
    if (!_isJumpPressed) {
      setState(() {
        _isJumpPressed = true;
      });
      _jumpButtonController.forward();
      widget.onJump();
      HapticFeedback.mediumImpact();
      AudioManager().playButtonClickSound();
    }
  }
  
  void _handleJumpRelease() {
    if (_isJumpPressed) {
      setState(() {
        _isJumpPressed = false;
      });
      _jumpButtonController.reverse();
    }
  }
  
  void _handleAttackPress() {
    if (!_isAttackPressed) {
      setState(() {
        _isAttackPressed = true;
      });
      _attackButtonController.forward();
      widget.onAttack();
      HapticFeedback.heavyImpact();
      AudioManager().playButtonClickSound();
    }
  }
  
  void _handleAttackRelease() {
    if (_isAttackPressed) {
      setState(() {
        _isAttackPressed = false;
      });
      _attackButtonController.reverse();
    }
  }
  
  @override
  void dispose() {
    _leftButtonController.dispose();
    _rightButtonController.dispose();
    _jumpButtonController.dispose();
    _attackButtonController.dispose();
    super.dispose();
  }
}
