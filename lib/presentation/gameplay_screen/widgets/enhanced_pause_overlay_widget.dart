import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/audio_manager.dart';

class EnhancedPauseOverlayWidget extends StatefulWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const EnhancedPauseOverlayWidget({
    Key? key,
    required this.onResume,
    required this.onRestart,
    required this.onQuit,
  }) : super(key: key);

  @override
  State<EnhancedPauseOverlayWidget> createState() => _EnhancedPauseOverlayWidgetState();
}

class _EnhancedPauseOverlayWidgetState extends State<EnhancedPauseOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _buttonController;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }
  
  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _buttonController.forward();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.7 * _fadeController.value),
          child: Center(
            child: AnimatedBuilder(
              animation: _scaleController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * _scaleController.value),
                  child: _buildPauseDialog(),
                );
              },
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildPauseDialog() {
    return Container(
      width: 80.w,
      constraints: BoxConstraints(maxHeight: 60.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.surface,
            AppTheme.lightTheme.colorScheme.surface.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 3.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.pause_circle_filled,
                  color: Colors.white,
                  size: 12.w,
                ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                SizedBox(height: 2.h),
                Text(
                  'JUEGO PAUSADO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                SizedBox(height: 2.h),
                
                // Resume button
                _buildActionButton(
                  icon: Icons.play_arrow,
                  text: 'Continuar',
                  color: AppTheme.successColor,
                  onTap: _handleResume,
                  delay: 0,
                ),
                
                SizedBox(height: 2.h),
                
                // Restart button
                _buildActionButton(
                  icon: Icons.refresh,
                  text: 'Reiniciar',
                  color: AppTheme.warningColor,
                  onTap: _handleRestart,
                  delay: 100,
                ),
                
                SizedBox(height: 2.h),
                
                // Quit button
                _buildActionButton(
                  icon: Icons.exit_to_app,
                  text: 'Salir',
                  color: AppTheme.errorColor,
                  onTap: _handleQuit,
                  delay: 200,
                ),
                
                SizedBox(height: 3.h),
                
                // Game tips
                _buildGameTips(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
    required int delay,
  }) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        final buttonDelay = delay / 1000.0;
        final buttonProgress = _buttonController.value;
        final isVisible = buttonProgress >= buttonDelay;
        
        return AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Transform.translate(
            offset: Offset(0, isVisible ? 0 : 20),
            child: GestureDetector(
              onTap: () {
                AudioManager().playButtonClickSound();
                onTap();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.8),
                      color.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildGameTips() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            '💡 Consejos',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            '• Usa los controles para moverte\n• Salta para evitar enemigos\n• Ataca para derrotar enemigos\n• Recolecta monedas para puntos',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontSize: 10.sp,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  void _handleResume() {
    _fadeController.reverse().then((_) {
      widget.onResume();
    });
  }
  
  void _handleRestart() {
    _fadeController.reverse().then((_) {
      widget.onRestart();
    });
  }
  
  void _handleQuit() {
    _fadeController.reverse().then((_) {
      widget.onQuit();
    });
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _buttonController.dispose();
    super.dispose();
  }
}
