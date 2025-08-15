import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/game_state.dart';
import '../../core/audio_manager.dart';
import '../../core/physics_engine.dart';
import './widgets/enhanced_game_canvas_widget.dart';
import './widgets/enhanced_game_controls_widget.dart';
import './widgets/enhanced_game_hud_widget.dart';
import './widgets/enhanced_pause_overlay_widget.dart';

class EnhancedGameplayScreen extends StatefulWidget {
  const EnhancedGameplayScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedGameplayScreen> createState() => _EnhancedGameplayScreenState();
}

class _EnhancedGameplayScreenState extends State<EnhancedGameplayScreen>
    with TickerProviderStateMixin {
  // Physics entities
  late Player _player;
  List<Enemy> _enemies = [];
  List<Coin> _coins = [];
  List<Projectile> _projectiles = [];
  
  // Game state
  bool _isGameActive = true;
  bool _isPaused = false;
  double _screenShakeIntensity = 0.0;
  double _screenShakeTime = 0.0;
  
  // Animation controllers
  late AnimationController _shakeController;
  late AnimationController _particleController;
  
  // Game loop
  Timer? _gameLoopTimer;
  Timer? _particleTimer;
  
  // Random generator
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _initializeGame();
    _setupAnimations();
    _startGameLoop();
  }
  
  void _initializeGame() {
    // Initialize player
    _player = Player();
    
    // Generate level entities
    _generateLevelEntities();
    
    // Set immersive mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
    
    // Lock orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    // Start background music
    final audioManager = AudioManager();
    audioManager.playMusic('audio/background_music.mp3');
  }
  
  void _setupAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }
  
  void _generateLevelEntities() {
    final gameState = context.read<GameState>();
    final level = gameState.currentLevel;
    
    // Generate coins
    _coins.clear();
    int coinCount = 5 + (level * 2);
    for (int i = 0; i < coinCount; i++) {
      final position = PhysicsEngine.generateRandomPosition(10, 90, 10, 40);
      _coins.add(Coin(
        x: position.dx,
        y: position.dy,
      ));
    }
    
    // Generate enemies
    _enemies.clear();
    int enemyCount = 2 + level;
    for (int i = 0; i < enemyCount; i++) {
      final position = PhysicsEngine.generateRandomPosition(10, 90, 0, 30);
      _enemies.add(Enemy(
        x: position.dx,
        y: position.dy,
        speed: 1.0 + (_random.nextDouble() * 2.0),
        patrolDistance: 30.0 + (_random.nextDouble() * 40.0),
      ));
    }
  }
  
  void _startGameLoop() {
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_isPaused && _isGameActive) {
        _updateGameState();
      }
    });
  }
  
  void _updateGameState() {
    setState(() {
      // Update physics entities
      _player.update();
      
      for (var enemy in _enemies) {
        enemy.update();
      }
      
      for (var coin in _coins) {
        coin.update();
      }
      
      for (var projectile in List.from(_projectiles)) {
        projectile.update();
        if (!projectile.isActive) {
          _projectiles.remove(projectile);
        }
      }
      
      // Update screen shake
      if (_screenShakeIntensity > 0) {
        _screenShakeTime += 0.1;
        _screenShakeIntensity *= 0.95;
      }
      
      // Check collisions
      _checkCollisions();
      
      // Check level completion
      _checkLevelCompletion();
    });
  }
  
  void _checkCollisions() {
    final gameState = context.read<GameState>();
    final audioManager = AudioManager();
    
    // Player-Enemy collisions
    for (var enemy in _enemies) {
      if (PhysicsEngine.checkPlayerEnemyCollision(_player, enemy)) {
        _playerLoseLife();
        _applyScreenShake(5.0);
        audioManager.playSfx('audio/player_hit.mp3');
      }
    }
    
    // Player-Coin collisions
    for (var coin in List.from(_coins)) {
      if (PhysicsEngine.checkPlayerCoinCollision(_player, coin)) {
        coin.isCollected = true;
        _coins.remove(coin);
        gameState.collectCoin();
        audioManager.playCoinSound();
        _createCoinParticles(coin.x, coin.y);
      }
    }
    
    // Projectile-Enemy collisions
    for (var projectile in List.from(_projectiles)) {
      for (var enemy in List.from(_enemies)) {
        if (PhysicsEngine.checkProjectileEnemyCollision(projectile, enemy)) {
          projectile.isActive = false;
          enemy.isAlive = false;
          _enemies.remove(enemy);
          gameState.defeatEnemy();
          audioManager.playEnemyDefeatSound();
          _createEnemyDefeatParticles(enemy.x, enemy.y);
          _applyScreenShake(3.0);
        }
      }
    }
  }
  
  void _checkLevelCompletion() {
    if (_coins.isEmpty && _enemies.isEmpty) {
      _completeLevel();
    }
  }
  
  void _playerLoseLife() {
    final gameState = context.read<GameState>();
    gameState.loseLife();
    
    if (gameState.currentLives <= 0) {
      _gameOver();
    }
  }
  
  void _completeLevel() {
    final gameState = context.read<GameState>();
    final audioManager = AudioManager();
    
    gameState.completeLevel();
    audioManager.playLevelCompleteSound();
    
    setState(() {
      _isPaused = true;
    });
    
    _showLevelCompleteDialog();
  }
  
  void _gameOver() {
    final audioManager = AudioManager();
    audioManager.playGameOverSound();
    
    setState(() {
      _isGameActive = false;
    });
    
    Navigator.pushReplacementNamed(context, '/game-over-screen');
  }
  
  void _createCoinParticles(double x, double y) {
    // Create particle effect for coin collection
    _particleController.forward(from: 0.0);
  }
  
  void _createEnemyDefeatParticles(double x, double y) {
    // Create particle effect for enemy defeat
    _particleController.forward(from: 0.0);
  }
  
  void _applyScreenShake(double intensity) {
    _screenShakeIntensity = intensity;
    _screenShakeTime = 0.0;
  }
  
  void _handleMovement(String direction) {
    if (_isPaused) return;
    
    double moveDirection = 0.0;
    switch (direction) {
      case 'left':
        moveDirection = -1.0;
        break;
      case 'right':
        moveDirection = 1.0;
        break;
    }
    
    _player.move(moveDirection);
  }
  
  void _handleJump() {
    if (_isPaused) return;
    
    final audioManager = AudioManager();
    _player.jump();
    audioManager.playJumpSound();
  }
  
  void _handleAttack() {
    if (_isPaused) return;
    
    final audioManager = AudioManager();
    _player.attack();
    audioManager.playAttackSound();
    
    // Create projectile
    _projectiles.add(Projectile(
      x: _player.x + _player.width,
      y: _player.y + _player.height / 2,
      velocityX: 10.0,
      velocityY: -2.0,
    ));
  }
  
  void _pauseGame() {
    setState(() {
      _isPaused = true;
    });
    
    final audioManager = AudioManager();
    audioManager.pauseMusic();
  }
  
  void _resumeGame() {
    setState(() {
      _isPaused = false;
    });
    
    final audioManager = AudioManager();
    audioManager.resumeMusic();
  }
  
  void _restartGame() {
    final gameState = context.read<GameState>();
    gameState.startNewGame();
    
    setState(() {
      _player = Player();
      _projectiles.clear();
      _isPaused = false;
      _isGameActive = true;
    });
    
    _generateLevelEntities();
  }
  
  void _quitGame() {
    final audioManager = AudioManager();
    audioManager.stopMusic();
    
    Navigator.pushReplacementNamed(context, '/main-menu-screen');
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
              ).animate().scale(duration: 500.ms),
              SizedBox(height: 2.h),
              Text(
                'Nivel ${context.read<GameState>().currentLevel} desbloqueado',
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
                _generateLevelEntities();
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
  
  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final screenShake = PhysicsEngine.calculateScreenShake(
      _screenShakeIntensity,
      _screenShakeTime,
    );
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Transform.translate(
        offset: screenShake,
        child: Stack(
          children: [
            // Main game area
            Column(
              children: [
                // Enhanced HUD
                EnhancedGameHudWidget(
                  lives: gameState.currentLives,
                  level: gameState.currentLevel,
                  score: gameState.currentScore,
                  coins: gameState.currentCoins,
                  onPause: _pauseGame,
                ),
                
                // Enhanced game canvas
                Expanded(
                  child: EnhancedGameCanvasWidget(
                    player: _player,
                    enemies: _enemies,
                    coins: _coins,
                    projectiles: _projectiles,
                    particleController: _particleController,
                  ),
                ),
                
                // Enhanced game controls
                EnhancedGameControlsWidget(
                  onMovement: _handleMovement,
                  onJump: _handleJump,
                  onAttack: _handleAttack,
                ),
              ],
            ),
            
            // Enhanced pause overlay
            if (_isPaused)
              EnhancedPauseOverlayWidget(
                onResume: _resumeGame,
                onRestart: _restartGame,
                onQuit: _quitGame,
              ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    _particleTimer?.cancel();
    _shakeController.dispose();
    _particleController.dispose();
    
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
