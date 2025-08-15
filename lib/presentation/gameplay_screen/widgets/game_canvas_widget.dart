import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameCanvasWidget extends StatefulWidget {
  final String playerDirection;
  final bool isJumping;
  final bool isAttacking;
  final List<Map<String, dynamic>> coins;
  final List<Map<String, dynamic>> enemies;
  final List<Map<String, dynamic>> projectiles;
  final Function(Map<String, dynamic>) onCoinCollected;
  final Function(Map<String, dynamic>) onEnemyHit;

  const GameCanvasWidget({
    Key? key,
    required this.playerDirection,
    required this.isJumping,
    required this.isAttacking,
    required this.coins,
    required this.enemies,
    required this.projectiles,
    required this.onCoinCollected,
    required this.onEnemyHit,
  }) : super(key: key);

  @override
  State<GameCanvasWidget> createState() => _GameCanvasWidgetState();
}

class _GameCanvasWidgetState extends State<GameCanvasWidget>
    with TickerProviderStateMixin {
  late AnimationController _playerAnimationController;
  late AnimationController _coinAnimationController;
  late AnimationController _enemyAnimationController;

  late Animation<double> _playerAnimation;
  late Animation<double> _coinRotationAnimation;
  late Animation<double> _enemyMovementAnimation;

  double _playerX = 50.0;
  double _playerY = 200.0;
  double _groundLevel = 200.0;
  bool _isPlayerOnGround = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _playerAnimationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    _coinAnimationController =
        AnimationController(duration: Duration(milliseconds: 2000), vsync: this)
          ..repeat();

    _enemyAnimationController =
        AnimationController(duration: Duration(milliseconds: 3000), vsync: this)
          ..repeat();

    _playerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _playerAnimationController, curve: Curves.easeInOut));

    _coinRotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159)
        .animate(_coinAnimationController);

    _enemyMovementAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_enemyAnimationController);
  }

  @override
  void didUpdateWidget(GameCanvasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.playerDirection != oldWidget.playerDirection) {
      _updatePlayerPosition();
    }

    if (widget.isJumping != oldWidget.isJumping && widget.isJumping) {
      _performJump();
    }
  }

  void _updatePlayerPosition() {
    setState(() {
      switch (widget.playerDirection) {
        case 'left':
          _playerX = (_playerX - 5).clamp(0.0, 100.w - 15.w);
          break;
        case 'right':
          _playerX = (_playerX + 5).clamp(0.0, 100.w - 15.w);
          break;
      }
    });
  }

  void _performJump() {
    if (_isPlayerOnGround) {
      setState(() {
        _isPlayerOnGround = false;
      });

      _playerAnimationController.forward().then((_) {
        _playerAnimationController.reverse().then((_) {
          setState(() {
            _isPlayerOnGround = true;
          });
        });
      });
    }
  }

  void _checkCollisions() {
    // Check coin collisions
    for (var coin in List.from(widget.coins)) {
      if (_isColliding(_playerX, _playerY, coin['x'], coin['y'])) {
        widget.onCoinCollected(coin);
      }
    }

    // Check enemy collisions with projectiles
    for (var projectile in List.from(widget.projectiles)) {
      for (var enemy in List.from(widget.enemies)) {
        if (_isColliding(
            projectile['x'], projectile['y'], enemy['x'], enemy['y'])) {
          widget.onEnemyHit(enemy);
        }
      }
    }
  }

  bool _isColliding(double x1, double y1, double x2, double y2) {
    double distance = ((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
    return distance < 1000; // Collision threshold
  }

  @override
  Widget build(BuildContext context) {
    _checkCollisions();

    return Container(
        width: double.infinity,
        height: 60.h,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xFF87CEEB),
              Color(0xFF98FB98),
            ])),
        child: Stack(children: [
          // Background elements
          _buildBackground(),

          // Game entities
          ..._buildCoins(),
          ..._buildEnemies(),
          ..._buildProjectiles(),

          // Player character
          _buildPlayer(),

          // Ground
          _buildGround(),
        ]));
  }

  Widget _buildBackground() {
    return Positioned.fill(child: CustomPaint(painter: BackgroundPainter()));
  }

  Widget _buildPlayer() {
    double jumpOffset = _isPlayerOnGround ? 0 : -30 * _playerAnimation.value;

    return AnimatedBuilder(
        animation: _playerAnimation,
        builder: (context, child) {
          return Positioned(
              left: _playerX,
              bottom: 15.h + jumpOffset,
              child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                      color: widget.isAttacking
                          ? Colors.orange
                          : AppTheme.lightTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha((0.3 * 255).round()),
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ]),
                  child: Center(
                      child: CustomIconWidget(
                          iconName: widget.isAttacking ? 'flash_on' : 'person',
                          color: Colors.white,
                          size: 24))));
        });
  }

  List<Widget> _buildCoins() {
    return widget.coins.map((coin) {
      return AnimatedBuilder(
          animation: _coinRotationAnimation,
          builder: (context, child) {
            return Positioned(
                left: coin['x'].toDouble(),
                top: coin['y'].toDouble(),
                child: Transform.rotate(
                    angle: _coinRotationAnimation.value,
                    child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                            color: AppTheme.accentLight,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withAlpha((0.2 * 255).round()),
                                  blurRadius: 2,
                                  offset: Offset(0, 1)),
                            ]),
                        child: Center(
                            child: CustomIconWidget(
                                iconName: 'monetization_on',
                                color: Colors.white,
                                size: 16)))));
          });
    }).toList();
  }

  List<Widget> _buildEnemies() {
    return widget.enemies.map((enemy) {
      return AnimatedBuilder(
          animation: _enemyMovementAnimation,
          builder: (context, child) {
            return Positioned(
                left: enemy['x'].toDouble(),
                top: enemy['y'].toDouble(),
                child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(width: 2)),
                    child: Center(
                        child: CustomIconWidget(
                            iconName: 'bug_report',
                            color: Colors.white,
                            size: 20))));
          });
    }).toList();
  }

  List<Widget> _buildProjectiles() {
    return widget.projectiles.map((projectile) {
      return Positioned(
          left: projectile['x'].toDouble(),
          top: projectile['y'].toDouble(),
          child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.orange.withAlpha((0.5 * 255).round()),
                        blurRadius: 4,
                        spreadRadius: 1),
                  ])));
    }).toList();
  }

  Widget _buildGround() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
            height: 15.h,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0xFF8B4513),
                  Color(0xFF654321),
                ])),
            child: CustomPaint(painter: GroundPainter())));
  }

  @override
  void dispose() {
    _playerAnimationController.dispose();
    _coinAnimationController.dispose();
    _enemyAnimationController.dispose();
    super.dispose();
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha((0.3 * 255).round())
      ..style = PaintingStyle.fill;

    // Draw clouds
    for (int i = 0; i < 3; i++) {
      double x = (size.width / 4) * (i + 1);
      double y = size.height * 0.2;

      canvas.drawCircle(Offset(x, y), 20, paint);
      canvas.drawCircle(Offset(x + 15, y), 25, paint);
      canvas.drawCircle(Offset(x + 30, y), 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // Draw grass texture
    for (int i = 0; i < size.width.toInt(); i += 10) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), 8), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
