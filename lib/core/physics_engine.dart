import 'dart:math';
import 'package:flutter/material.dart';

/// Professional physics engine for realistic game mechanics
class PhysicsEngine {
  static const double _gravity = 0.8;
  static const double _jumpForce = -15.0;
  static const double _groundLevel = 0.0;
  static const double _friction = 0.85;
  static const double _airResistance = 0.95;
  
  /// Physics-based player entity
  static class Player {
    double x = 50.0;
    double y = 0.0;
    double velocityX = 0.0;
    double velocityY = 0.0;
    bool isOnGround = false;
    bool isJumping = false;
    bool isAttacking = false;
    double width = 40.0;
    double height = 40.0;
    
    void update() {
      // Apply gravity
      if (!isOnGround) {
        velocityY += _gravity;
      }
      
      // Apply friction on ground
      if (isOnGround) {
        velocityX *= _friction;
      } else {
        velocityX *= _airResistance;
      }
      
      // Update position
      x += velocityX;
      y += velocityY;
      
      // Ground collision
      if (y >= _groundLevel) {
        y = _groundLevel;
        velocityY = 0.0;
        isOnGround = true;
        isJumping = false;
      } else {
        isOnGround = false;
      }
      
      // Screen boundaries
      if (x < 0) {
        x = 0;
        velocityX = 0;
      } else if (x > 100 - width) {
        x = 100 - width;
        velocityX = 0;
      }
    }
    
    void jump() {
      if (isOnGround && !isJumping) {
        velocityY = _jumpForce;
        isJumping = true;
        isOnGround = false;
      }
    }
    
    void move(double direction) {
      if (direction != 0) {
        velocityX += direction * 2.0;
        velocityX = velocityX.clamp(-8.0, 8.0);
      }
    }
    
    void attack() {
      isAttacking = true;
      // Reset attack state after animation
      Future.delayed(const Duration(milliseconds: 300), () {
        isAttacking = false;
      });
    }
    
    Rect getBounds() {
      return Rect.fromLTWH(x, y, width, height);
    }
  }
  
  /// Physics-based enemy entity
  static class Enemy {
    double x = 0.0;
    double y = 0.0;
    double velocityX = 0.0;
    double velocityY = 0.0;
    bool isAlive = true;
    double width = 30.0;
    double height = 30.0;
    double speed = 1.0;
    double direction = 1.0;
    double patrolDistance = 50.0;
    double startX = 0.0;
    
    Enemy({
      required this.x,
      required this.y,
      this.speed = 1.0,
      this.patrolDistance = 50.0,
    }) {
      startX = x;
    }
    
    void update() {
      if (!isAlive) return;
      
      // Apply gravity
      velocityY += _gravity;
      
      // Update position
      x += velocityX;
      y += velocityY;
      
      // Ground collision
      if (y >= _groundLevel) {
        y = _groundLevel;
        velocityY = 0.0;
      }
      
      // Patrol movement
      velocityX = direction * speed;
      
      // Change direction at patrol boundaries
      if (x <= startX || x >= startX + patrolDistance) {
        direction *= -1;
      }
    }
    
    Rect getBounds() {
      return Rect.fromLTWH(x, y, width, height);
    }
  }
  
  /// Physics-based coin entity
  static class Coin {
    double x = 0.0;
    double y = 0.0;
    bool isCollected = false;
    double width = 20.0;
    double height = 20.0;
    double rotation = 0.0;
    
    Coin({required this.x, required this.y});
    
    void update() {
      if (!isCollected) {
        rotation += 0.1; // Rotate coin
      }
    }
    
    Rect getBounds() {
      return Rect.fromLTWH(x, y, width, height);
    }
  }
  
  /// Physics-based projectile entity
  static class Projectile {
    double x = 0.0;
    double y = 0.0;
    double velocityX = 0.0;
    double velocityY = 0.0;
    bool isActive = true;
    double width = 10.0;
    double height = 10.0;
    
    Projectile({
      required this.x,
      required this.y,
      required this.velocityX,
      required this.velocityY,
    });
    
    void update() {
      if (!isActive) return;
      
      // Apply gravity
      velocityY += _gravity * 0.5;
      
      // Update position
      x += velocityX;
      y += velocityY;
      
      // Deactivate if off screen or hitting ground
      if (x < 0 || x > 100 || y > 100) {
        isActive = false;
      }
    }
    
    Rect getBounds() {
      return Rect.fromLTWH(x, y, width, height);
    }
  }
  
  /// Check collision between two rectangles
  static bool checkCollision(Rect rect1, Rect rect2) {
    return rect1.overlaps(rect2);
  }
  
  /// Check collision between player and enemy
  static bool checkPlayerEnemyCollision(Player player, Enemy enemy) {
    if (!enemy.isAlive) return false;
    
    final playerBounds = player.getBounds();
    final enemyBounds = enemy.getBounds();
    
    return checkCollision(playerBounds, enemyBounds);
  }
  
  /// Check collision between player and coin
  static bool checkPlayerCoinCollision(Player player, Coin coin) {
    if (coin.isCollected) return false;
    
    final playerBounds = player.getBounds();
    final coinBounds = coin.getBounds();
    
    return checkCollision(playerBounds, coinBounds);
  }
  
  /// Check collision between projectile and enemy
  static bool checkProjectileEnemyCollision(Projectile projectile, Enemy enemy) {
    if (!projectile.isActive || !enemy.isAlive) return false;
    
    final projectileBounds = projectile.getBounds();
    final enemyBounds = enemy.getBounds();
    
    return checkCollision(projectileBounds, enemyBounds);
  }
  
  /// Calculate distance between two points
  static double calculateDistance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }
  
  /// Generate random position within bounds
  static Offset generateRandomPosition(double minX, double maxX, double minY, double maxY) {
    final random = Random();
    return Offset(
      minX + random.nextDouble() * (maxX - minX),
      minY + random.nextDouble() * (maxY - minY),
    );
  }
  
  /// Apply screen shake effect
  static Offset calculateScreenShake(double intensity, double time) {
    final random = Random();
    return Offset(
      (random.nextDouble() - 0.5) * intensity * sin(time),
      (random.nextDouble() - 0.5) * intensity * sin(time),
    );
  }
  
  /// Calculate particle trail effect
  static List<Offset> calculateParticleTrail(Offset start, Offset end, int particleCount) {
    final particles = <Offset>[];
    for (int i = 0; i < particleCount; i++) {
      final t = i / (particleCount - 1);
      final x = start.dx + (end.dx - start.dx) * t;
      final y = start.dy + (end.dy - start.dy) * t;
      particles.add(Offset(x, y));
    }
    return particles;
  }
}
