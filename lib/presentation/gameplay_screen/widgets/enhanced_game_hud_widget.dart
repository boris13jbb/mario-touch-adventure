import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EnhancedGameHudWidget extends StatefulWidget {
  final int lives;
  final int level;
  final int score;
  final int coins;
  final VoidCallback onPause;

  const EnhancedGameHudWidget({
    Key? key,
    required this.lives,
    required this.level,
    required this.score,
    required this.coins,
    required this.onPause,
  }) : super(key: key);

  @override
  State<EnhancedGameHudWidget> createState() => _EnhancedGameHudWidgetState();
}

class _EnhancedGameHudWidgetState extends State<EnhancedGameHudWidget>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late AnimationController _coinAnimationController;
  late AnimationController _lifeAnimationController;
  
  int _previousScore = 0;
  int _previousCoins = 0;
  int _previousLives = 0;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _previousScore = widget.score;
    _previousCoins = widget.coins;
    _previousLives = widget.lives;
  }
  
  void _setupAnimations() {
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _coinAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _lifeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }
  
  @override
  void didUpdateWidget(EnhancedGameHudWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Animate score changes
    if (widget.score != _previousScore) {
      _scoreAnimationController.forward(from: 0.0);
      _previousScore = widget.score;
    }
    
    // Animate coin changes
    if (widget.coins != _previousCoins) {
      _coinAnimationController.forward(from: 0.0);
      _previousCoins = widget.coins;
    }
    
    // Animate life changes
    if (widget.lives != _previousLives) {
      _lifeAnimationController.forward(from: 0.0);
      _previousLives = widget.lives;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
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
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              // Left side - Lives and Level
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    _buildLivesDisplay(),
                    SizedBox(width: 4.w),
                    _buildLevelDisplay(),
                  ],
                ),
              ),
              
              // Center - Score
              Expanded(
                flex: 3,
                child: _buildScoreDisplay(),
              ),
              
              // Right side - Coins and Pause
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildCoinsDisplay(),
                    SizedBox(width: 4.w),
                    _buildPauseButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLivesDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            color: Colors.white,
            size: 4.w,
          ),
          SizedBox(width: 1.w),
          Text(
            '${widget.lives}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate(target: widget.lives != _previousLives ? 1 : 0)
      .scale(duration: 300.ms, curve: Curves.elasticOut);
  }
  
  Widget _buildLevelDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: 4.w,
          ),
          SizedBox(width: 1.w),
          Text(
            'Nivel ${widget.level}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScoreDisplay() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.accentColor.withOpacity(0.8),
              AppTheme.accentColor.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PUNTUACIÓN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            AnimatedBuilder(
              animation: _scoreAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_scoreAnimationController.value * 0.2),
                  child: Text(
                    '${widget.score}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCoinsDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on,
            color: Colors.white,
            size: 4.w,
          ),
          SizedBox(width: 1.w),
          AnimatedBuilder(
            animation: _coinAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_coinAnimationController.value * 0.3),
                child: Text(
                  '${widget.coins}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildPauseButton() {
    return GestureDetector(
      onTap: widget.onPause,
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10.w / 2),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          Icons.pause,
          color: Colors.white,
          size: 5.w,
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _coinAnimationController.dispose();
    _lifeAnimationController.dispose();
    super.dispose();
  }
}
