import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/celebration_background_widget.dart';
import './widgets/next_level_preview_widget.dart';
import './widgets/performance_stats_widget.dart';
import './widgets/star_rating_widget.dart';

class LevelCompleteScreen extends StatefulWidget {
  const LevelCompleteScreen({Key? key}) : super(key: key);

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _contentController;
  late Animation<double> _titleBounceAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  // Mock data for level completion
  final Map<String, dynamic> _levelStats = {
    'levelNumber': 3,
    'coinsCollected': 47,
    'totalCoins': 50,
    'enemiesDefeated': 12,
    'totalEnemies': 15,
    'secretsFound': 2,
    'totalSecrets': 3,
    'completionTime': 95, // seconds
    'livesRemaining': 2,
  };

  final Map<String, dynamic> _nextLevelData = {
    'levelNumber': 4,
    'name': 'Castillo de Fuego',
    'description': 'Atraviesa el peligroso castillo lleno de lava y dragones',
    'difficulty': 3,
    'totalCoins': 65,
    'totalEnemies': 20,
    'totalSecrets': 4,
  };

  int _starsEarned = 0;
  bool _showRewards = false;

  @override
  void initState() {
    super.initState();
    _calculateStars();
    _initializeAnimations();
    _startAnimations();
    _triggerCelebrationHaptics();
  }

  void _calculateStars() {
    int stars = 1; // Base star for completion

    // Bonus star for collecting most coins
    final coinsPercentage =
        _levelStats['coinsCollected'] / _levelStats['totalCoins'];
    if (coinsPercentage >= 0.8) stars++;

    // Bonus star for fast completion or lives remaining
    final completionTime = _levelStats['completionTime'] as int;
    final livesRemaining = _levelStats['livesRemaining'] as int;
    if (completionTime <= 90 || livesRemaining >= 2) stars++;

    _starsEarned = math.min(stars, 3);
  }

  void _initializeAnimations() {
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _titleBounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: Curves.elasticOut,
      ),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.elasticOut,
    ));

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  void _startAnimations() {
    _titleController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _contentController.forward();
      }
    });
  }

  void _triggerCelebrationHaptics() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      HapticFeedback.lightImpact();
    });
  }

  void _onStarAnimationComplete() {
    setState(() {
      _showRewards = true;
    });
  }

  void _handleNextLevel() {
    HapticFeedback.selectionClick();
    Navigator.pushReplacementNamed(context, '/gameplay-screen');
  }

  void _handleReplay() {
    HapticFeedback.selectionClick();
    Navigator.pushReplacementNamed(context, '/gameplay-screen');
  }

  void _handleLevelSelect() {
    HapticFeedback.selectionClick();
    Navigator.pushNamed(context, '/level-selection-screen');
  }

  void _handleShare() {
    HapticFeedback.selectionClick();
    _showShareDialog();
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Compartir Logro',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¡Completé el Nivel ${_levelStats['levelNumber']} con $_starsEarned estrellas en Mario Touch Adventure!',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Estadísticas:\n• Monedas: ${_levelStats['coinsCollected']}/${_levelStats['totalCoins']}\n• Tiempo: ${_formatTime(_levelStats['completionTime'])}\n• Enemigos derrotados: ${_levelStats['enemiesDefeated']}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Here would be the actual sharing implementation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('¡Logro compartido exitosamente!'),
                    backgroundColor: AppTheme.successColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
              ),
              child: const Text('Compartir',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Celebration background with particles
          const CelebrationBackgroundWidget(),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 4.h),

                  // Animated title
                  SlideTransition(
                    position: _titleSlideAnimation,
                    child: ScaleTransition(
                      scale: _titleBounceAnimation,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          children: [
                            Text(
                              '¡NIVEL',
                              style: AppTheme.lightTheme.textTheme.displaySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: AppTheme.lightTheme.shadowColor,
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'COMPLETADO!',
                              style: AppTheme.lightTheme.textTheme.displaySmall
                                  ?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: AppTheme.lightTheme.shadowColor,
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Animated content
                  FadeTransition(
                    opacity: _contentFadeAnimation,
                    child: Column(
                      children: [
                        // Star rating
                        StarRatingWidget(
                          stars: _starsEarned,
                          onAnimationComplete: _onStarAnimationComplete,
                        ),

                        SizedBox(height: 3.h),

                        // Performance statistics
                        PerformanceStatsWidget(stats: _levelStats),

                        SizedBox(height: 4.h),

                        // Next level preview
                        NextLevelPreviewWidget(
                          nextLevelData: _nextLevelData,
                          onNextLevel: _handleNextLevel,
                        ),

                        SizedBox(height: 4.h),

                        // Action buttons
                        ActionButtonsWidget(
                          onReplay: _handleReplay,
                          onLevelSelect: _handleLevelSelect,
                          onShare: _handleShare,
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rewards overlay (if any unlocked content)
          if (_showRewards)
            AnimatedOpacity(
              opacity: _showRewards ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.shadowColor,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'emoji_events',
                          color: AppTheme.accentColor,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '¡Nuevo Contenido Desbloqueado!',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Has desbloqueado un nuevo poder especial',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3.h),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showRewards = false;
                            });
                          },
                          child: const Text('¡Genial!',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
