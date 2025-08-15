import 'package:flutter_test/flutter_test.dart';
import 'package:mario_touch_adventure/core/physics_engine.dart';

void main() {
  group('PhysicsEngine Tests', () {
    test('should apply gravity correctly', () {
      double velocityY = 0.0;
      velocityY = PhysicsEngine.applyGravity(velocityY);
      expect(velocityY, equals(PhysicsEngine.gravity));
    });

    test('should apply friction correctly', () {
      double velocityX = 10.0;
      
      // Test ground friction
      double groundFriction = PhysicsEngine.applyFriction(velocityX, true);
      expect(groundFriction, equals(velocityX * PhysicsEngine.friction));
      
      // Test air resistance
      double airResistance = PhysicsEngine.applyFriction(velocityX, false);
      expect(airResistance, equals(velocityX * PhysicsEngine.airResistance));
    });

    test('should check ground collision correctly', () {
      expect(PhysicsEngine.isOnGround(PhysicsEngine.groundLevel), isTrue);
      expect(PhysicsEngine.isOnGround(PhysicsEngine.groundLevel + 1), isTrue);
      expect(PhysicsEngine.isOnGround(PhysicsEngine.groundLevel - 1), isFalse);
    });

    test('should clamp values correctly', () {
      expect(PhysicsEngine.clamp(5.0, 0.0, 10.0), equals(5.0));
      expect(PhysicsEngine.clamp(-5.0, 0.0, 10.0), equals(0.0));
      expect(PhysicsEngine.clamp(15.0, 0.0, 10.0), equals(10.0));
    });
  });
}
