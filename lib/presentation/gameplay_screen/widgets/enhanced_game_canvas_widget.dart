import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/physics_engine.dart';

class EnhancedGameCanvasWidget extends StatefulWidget {
  final Player player;
  final List<Enemy> enemies;
  final List<Coin> coins;
  final List<Projectile> projectiles;
  final AnimationController particleController;

  const EnhancedGameCanvasWidget({
    Key? key,
    required this.player,
    required this.enemies,
    required this.coins,
    required this.projectiles,
    required this.particleController,
  }) : super(key: key);

  @override
  State<EnhancedGameCanvasWidget> createState() => _EnhancedGameCanvasWidgetState();
}

class _EnhancedGameCanvasWidgetState extends State<EnhancedGameCanvasWidget>
    with TickerProviderStateMixin {
  // Particle effects
  List<Particle> _particles = [];
  late AnimationController _coinAnimationController;
  late AnimationController _enemyAnimationController;
  
  // Background elements
  List<BackgroundElement> _backgroundElements = [];
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _generateBackgroundElements();
  }
  
  void _setupAnimations() {
    _coinAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _enemyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }
  
  void _generateBackgroundElements() {
    final random = Random();
    _backgroundElements.clear();
    
    // Generate clouds
    for (int i = 0; i < 5; i++) {
      _backgroundElements.add(BackgroundElement(
        type: BackgroundElementType.cloud,
        x: random.nextDouble() * 100,
        y: random.nextDouble() * 20 + 5,
        speed: 0.1 + random.nextDouble() * 0.2,
      ));
    }
    
    // Generate mountains
    for (int i = 0; i < 3; i++) {
      _backgroundElements.add(BackgroundElement(
        type: BackgroundElementType.mountain,
        x: i * 35,
        y: 60,
        speed: 0.05,
      ));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF87CEEB), // Sky blue
            const Color(0xFF98FB98), // Light green
            const Color(0xFF8FBC8F), // Dark green
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background elements
          ..._backgroundElements.map((element) => _buildBackgroundElement(element)),
          
          // Ground
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 20.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF8B4513), // Saddle brown
                    const Color(0xFF654321), // Dark brown
                  ],
                ),
              ),
            ),
          ),
          
          // Game entities
          ...widget.coins.map((coin) => _buildCoin(coin)),
          ...widget.enemies.map((enemy) => _buildEnemy(enemy)),
          ...widget.projectiles.map((projectile) => _buildProjectile(projectile)),
          _buildPlayer(widget.player),
          
          // Particle effects
          ..._particles.map((particle) => _buildParticle(particle)),
        ],
      ),
    );
  }
  
  Widget _buildBackgroundElement(BackgroundElement element) {
    Widget elementWidget;
    
    switch (element.type) {
      case BackgroundElementType.cloud:
        elementWidget = Container(
          width: 8.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
        );
        break;
      case BackgroundElementType.mountain:
        elementWidget = CustomPaint(
          size: Size(15.w, 20.h),
          painter: MountainPainter(),
        );
        break;
    }
    
    return Positioned(
      left: element.x.w,
      top: element.y.h,
      child: elementWidget,
    );
  }
  
  Widget _buildPlayer(Player player) {
    return Positioned(
      left: player.x.w,
      bottom: (100 - player.y - player.height).h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: player.width.w,
            height: player.height.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.9), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.32),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_rounded, color: Colors.white, size: 18.sp),
                Text(
                  'HÉROE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          if (player.isAttacking)
            Positioned(
              top: -1.5.h,
              right: -1.8.w,
              child: Container(
                width: 4.2.w,
                height: 2.2.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withOpacity(0.8),
                      blurRadius: 8,
                      spreadRadius: 1.5,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 100.ms).scale(duration: 180.ms),
            ),
        ],
      ),
    );
  }
  
  Widget _buildEnemy(Enemy enemy) {
    if (!enemy.isAlive) return const SizedBox.shrink();
    
    return Positioned(
      left: enemy.x.w,
      bottom: (100 - enemy.y - enemy.height).h,
      child: Container(
        width: enemy.width.w,
        height: enemy.height.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFF7F1D1D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withOpacity(0.8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.android_rounded,
          color: Colors.white,
          size: 14.sp,
        ),
      ),
    );
  }
  
  Widget _buildCoin(Coin coin) {
    if (coin.isCollected) return const SizedBox.shrink();
    
    return Positioned(
      left: coin.x.w,
      bottom: (100 - coin.y - coin.height).h,
      child: Transform.rotate(
        angle: coin.rotation,
        child: Container(
          width: coin.width.w,
          height: coin.height.h,
          decoration: BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '¢',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildProjectile(Projectile projectile) {
    if (!projectile.isActive) return const SizedBox.shrink();
    
    return Positioned(
      left: projectile.x.w,
      bottom: (100 - projectile.y - projectile.height).h,
      child: Container(
        width: projectile.width.w,
        height: projectile.height.h,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.6),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildParticle(Particle particle) {
    return Positioned(
      left: particle.x.w,
      bottom: (100 - particle.y).h,
      child: Container(
        width: 4.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: particle.color,
          shape: BoxShape.circle,
        ),
      ).animate().fadeOut(duration: particle.duration).scale(
        begin: const Offset(1, 1),
        end: const Offset(0, 0),
        duration: particle.duration,
      ),
    );
  }
  
  void createCoinParticles(double x, double y) {
    final random = Random();
    for (int i = 0; i < 8; i++) {
      _particles.add(Particle(
        x: x + random.nextDouble() * 20 - 10,
        y: y + random.nextDouble() * 20 - 10,
        color: Colors.yellow,
        duration: const Duration(milliseconds: 800),
      ));
    }
    
    // Remove particles after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _particles.clear();
        });
      }
    });
  }
  
  void createEnemyDefeatParticles(double x, double y) {
    final random = Random();
    for (int i = 0; i < 12; i++) {
      _particles.add(Particle(
        x: x + random.nextDouble() * 30 - 15,
        y: y + random.nextDouble() * 30 - 15,
        color: Colors.red,
        duration: const Duration(milliseconds: 600),
      ));
    }
    
    // Remove particles after animation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _particles.clear();
        });
      }
    });
  }
  
  @override
  void dispose() {
    _coinAnimationController.dispose();
    _enemyAnimationController.dispose();
    super.dispose();
  }
}

// Helper classes
class Particle {
  final double x;
  final double y;
  final Color color;
  final Duration duration;
  
  Particle({
    required this.x,
    required this.y,
    required this.color,
    required this.duration,
  });
}

class BackgroundElement {
  final BackgroundElementType type;
  final double x;
  final double y;
  final double speed;
  
  BackgroundElement({
    required this.type,
    required this.x,
    required this.y,
    required this.speed,
  });
}

enum BackgroundElementType {
  cloud,
  mountain,
}

class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.3, size.height * 0.6);
    path.lineTo(size.width * 0.5, size.height * 0.3);
    path.lineTo(size.width * 0.7, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.8);
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
