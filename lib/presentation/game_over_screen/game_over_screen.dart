import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/achievement_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/encouraging_message_widget.dart';
import './widgets/game_stats_widget.dart';
import './widgets/social_sharing_widget.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _titleScaleAnimation;
  late Animation<double> _titleOpacityAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _contentOpacityAnimation;

  // Mock game data
  final Map<String, dynamic> gameData = {
    "coinsCollected": 127,
    "enemiesDefeated": 15,
    "levelProgress": 3,
    "timePlayed": "2:34",
    "achievements": [
      "¡Primera vez derrotando 10 enemigos!",
      "¡Coleccionista de monedas - 100+ monedas!",
      "¡Superviviente del nivel 3!",
    ],
    "isNewRecord": true,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _titleScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.elasticOut,
    ));

    _titleOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeIn,
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _contentOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeIn,
    ));
  }

  void _startAnimationSequence() {
    _titleAnimationController.forward();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _contentAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleRestartLevel();
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.lightTheme.scaffoldBackgroundColor
                    .withAlpha((0.95 * 255).round()),
                AppTheme.lightTheme.scaffoldBackgroundColor
                    .withAlpha((0.98 * 255).round()),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 4.h),
                  _buildGameOverTitle(),
                  SizedBox(height: 4.h),
                  _buildAnimatedContent(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverTitle() {
    return AnimatedBuilder(
      animation: _titleAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _titleScaleAnimation.value,
          child: Opacity(
            opacity: _titleOpacityAnimation.value,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.primary,
                        AppTheme.lightTheme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(4.w),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withAlpha((0.3 * 255).round()),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    'Game Over',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha((0.3 * 255).round()),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '¡Buen intento, aventurero!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedContent() {
    return AnimatedBuilder(
      animation: _contentAnimationController,
      builder: (context, child) {
        return SlideTransition(
          position: _contentSlideAnimation,
          child: FadeTransition(
            opacity: _contentOpacityAnimation,
            child: Column(
              children: [
                GameStatsWidget(
                  coinsCollected: (gameData["coinsCollected"] as int),
                  enemiesDefeated: (gameData["enemiesDefeated"] as int),
                  levelProgress: (gameData["levelProgress"] as int),
                  timePlayed: (gameData["timePlayed"] as String),
                ),
                SizedBox(height: 3.h),
                AchievementWidget(
                  achievements:
                      (gameData["achievements"] as List).cast<String>(),
                ),
                SizedBox(height: 3.h),
                ActionButtonsWidget(
                  onRestartLevel: _handleRestartLevel,
                  onSelectLevel: _handleSelectLevel,
                  onMainMenu: _handleMainMenu,
                ),
                SizedBox(height: 3.h),
                SocialSharingWidget(
                  coinsCollected: (gameData["coinsCollected"] as int),
                  enemiesDefeated: (gameData["enemiesDefeated"] as int),
                  levelProgress: (gameData["levelProgress"] as int),
                ),
                SizedBox(height: 3.h),
                const EncouragingMessageWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleRestartLevel() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/gameplay-screen');
  }

  void _handleSelectLevel() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/level-selection-screen');
  }

  void _handleMainMenu() {
    HapticFeedback.lightImpact();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main-menu-screen',
      (route) => false,
    );
  }
}
