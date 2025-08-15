import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/game_canvas_widget.dart';
import './widgets/game_controls_widget.dart';
import './widgets/game_hud_widget.dart';
import './widgets/pause_overlay_widget.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({Key? key}) : super(key: key);

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen>
    with TickerProviderStateMixin {
  // Game state variables
  int _lives = 3;
  int _currentLevel = 1;
  // int _score = 0; // Unused field - commented out
  bool _isPaused = false;
  bool _isGameActive = true;

  // Player state
  String _playerDirection = '';
  bool _isJumping = false;
  bool _isAttacking = false;

  // Game entities
  List<Map<String, dynamic>> _coins = [];
  List<Map<String, dynamic>> _enemies = [];
  List<Map<String, dynamic>> _projectiles = [];

  // Game loop timer
  Timer? _gameLoopTimer;
  Timer? _projectileTimer;

  // Random generator for game elements
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startGameLoop();
  }

  void _initializeGame() {
    // Initialize game entities based on current level
    _generateCoins();
    _generateEnemies();

    // Set system UI overlay style for immersive gaming
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );

    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _generateCoins() {
    _coins.clear();
    int coinCount = 5 + (_currentLevel * 2);

    for (int i = 0; i < coinCount; i++) {
      _coins.add({
        'id': i,
        'x': _random.nextDouble() * (100.w - 8.w),
        'y': _random.nextDouble() * (40.h - 8.w) + 10.h,
        'collected': false,
      });
    }
  }

  void _generateEnemies() {
    _enemies.clear();
    int enemyCount = 2 + _currentLevel;

    for (int i = 0; i < enemyCount; i++) {
      _enemies.add({
        'id': i,
        'x': _random.nextDouble() * (100.w - 12.w),
        'y': _random.nextDouble() * (30.h - 12.w) + 20.h,
        'direction': _random.nextBool() ? 1 : -1,
        'speed': 1.0 + (_random.nextDouble() * 2.0),
        'alive': true,
      });
    }
  }

  void _startGameLoop() {
    _gameLoopTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (!_isPaused && _isGameActive) {
        _updateGameState();
      }
    });
  }

  void _updateGameState() {
    setState(() {
      // Update enemy positions
      for (var enemy in _enemies) {
        if (enemy['alive']) {
          enemy['x'] += enemy['direction'] * enemy['speed'];

          // Bounce off screen edges
          if (enemy['x'] <= 0 || enemy['x'] >= 100.w - 12.w) {
            enemy['direction'] *= -1;
          }
        }
      }

      // Update projectile positions
      for (var projectile in List.from(_projectiles)) {
        projectile['x'] += projectile['direction'] * 5.0;

        // Remove projectiles that go off screen
        if (projectile['x'] < 0 || projectile['x'] > 100.w) {
          _projectiles.remove(projectile);
        }
      }

      // Check level completion
      if (_coins.where((coin) => !coin['collected']).isEmpty &&
          _enemies.where((enemy) => enemy['alive']).isEmpty) {
        _completeLevel();
      }
    });
  }

  void _handleMovement(String direction) {
    setState(() {
      _playerDirection = direction;
    });
  }

  void _handleJump() {
    if (!_isJumping) {
      setState(() {
        _isJumping = true;
      });

      // Reset jump state after animation
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isJumping = false;
          });
        }
      });
    }
  }

  void _handleAttack() {
    setState(() {
      _isAttacking = true;
    });

    // Create projectile
    _projectiles.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'x': 50.0, // Player position
      'y': 45.h, // Player level
      'direction': 1.0, // Moving right
    });

    // Reset attack state
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isAttacking = false;
        });
      }
    });
  }

  void _onCoinCollected(Map<String, dynamic> coin) {
    setState(() {
      coin['collected'] = true;
      _coins = _coins.where((c) => c['id'] != coin['id']).toList();
      _score += 10;
    });

    // Haptic feedback for coin collection
    HapticFeedback.lightImpact();
  }

  void _onEnemyHit(Map<String, dynamic> enemy) {
    setState(() {
      enemy['alive'] = false;
      _enemies = _enemies.where((e) => e['id'] != enemy['id']).toList();
      _score += 25;
    });

    // Haptic feedback for enemy defeat
    HapticFeedback.mediumImpact();
  }

  void _pauseGame() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeGame() {
    setState(() {
      _isPaused = false;
    });
  }

  void _restartGame() {
    setState(() {
      _lives = 3;
      _currentLevel = 1;
      _score = 0;
      _isPaused = false;
      _isGameActive = true;
      _playerDirection = '';
      _isJumping = false;
      _isAttacking = false;
      _projectiles.clear();
    });

    _initializeGame();
  }

  void _quitGame() {
    Navigator.pushReplacementNamed(context, '/main-menu-screen');
  }

  void _completeLevel() {
    setState(() {
      _currentLevel++;
      _isPaused = true;
    });

    // Show level completion dialog
    _showLevelCompleteDialog();
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '¡Nivel Completado!',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppTheme.lightTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.accentLight,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'Nivel $_currentLevel desbloqueado',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeGame();
                _resumeGame();
              },
              child: Text(
                'Continuar',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _gameOver() {
  //   setState(() {
  //     _isGameActive = false;
  //   });
  // 
  //   Navigator.pushReplacementNamed(context, '/game-over-screen');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main game area
          Column(
            children: [
              // HUD
              GameHudWidget(
                lives: _lives,
                level: _currentLevel,
                coins: _coins.length,
                onPause: _pauseGame,
              ),

              // Game canvas
              Expanded(
                child: GameCanvasWidget(
                  playerDirection: _playerDirection,
                  isJumping: _isJumping,
                  isAttacking: _isAttacking,
                  coins: _coins,
                  enemies: _enemies,
                  projectiles: _projectiles,
                  onCoinCollected: _onCoinCollected,
                  onEnemyHit: _onEnemyHit,
                ),
              ),

              // Game controls
              GameControlsWidget(
                onMovement: _handleMovement,
                onJump: _handleJump,
                onAttack: _handleAttack,
              ),
            ],
          ),

          // Pause overlay
          if (_isPaused)
            PauseOverlayWidget(
              onResume: _resumeGame,
              onRestart: _restartGame,
              onQuit: _quitGame,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    _projectileTimer?.cancel();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );

    // Restore orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }
}
