import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EncouragingMessageWidget extends StatefulWidget {
  const EncouragingMessageWidget({Key? key}) : super(key: key);

  @override
  State<EncouragingMessageWidget> createState() =>
      _EncouragingMessageWidgetState();
}

class _EncouragingMessageWidgetState extends State<EncouragingMessageWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentMessageIndex = 0;

  final List<String> _encouragingMessages = [
    "¡No te rindas! Cada intento te hace más fuerte 💪",
    "¡Casi lo tienes! La próxima vez será la definitiva 🌟",
    "Los mejores jugadores también fallan. ¡Sigue intentando! 🎮",
    "¡Cada nivel completado es una victoria! 🏆",
    "¡Tu aventura apenas comienza! ¡Adelante! 🚀",
    "¡Los héroes nunca se rinden! ¡Tú tampoco! ⭐",
    "¡Practica hace al maestro! ¡Sigue jugando! 🎯",
    "¡La diversión está en el camino, no solo en ganar! 😊",
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _startMessageRotation();
  }

  void _startMessageRotation() {
    _fadeController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _fadeController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _currentMessageIndex =
                  (_currentMessageIndex + 1) % _encouragingMessages.length;
            });
            _fadeController.forward();
            _startMessageRotation();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            width: 85.w,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'favorite',
                  color: AppTheme.warningColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    _encouragingMessages[_currentMessageIndex],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
