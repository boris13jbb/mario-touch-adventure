import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_background_widget.dart';
import './widgets/audio_controls_widget.dart';
import './widgets/footer_widget.dart';
import './widgets/game_title_widget.dart';
import './widgets/menu_button_widget.dart';
import './widgets/player_stats_widget.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  bool _showQuickAccess = false;
  Timer? _quickAccessTimer;

  void _handleIniciarJuego() {
    Navigator.pushNamed(context, '/enhanced-gameplay-screen');
  }

  void _handleNiveles() {
    Navigator.pushNamed(context, '/level-selection-screen');
  }

  void _handleInstrucciones() {
    Navigator.pushNamed(context, '/instructions-screen');
  }

  void _toggleQuickAccess() {
    _quickAccessTimer?.cancel();

    setState(() {
      _showQuickAccess = !_showQuickAccess;
    });

    if (_showQuickAccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Acceso rápido al último nivel jugado'),
          duration: Duration(seconds: 2),
        ),
      );

      // Auto-hide after 3 seconds
      _quickAccessTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showQuickAccess = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _quickAccessTimer?.cancel();
    super.dispose();
  }

  void _handleQuickAccess() {
    final gameState = context.read<GameState>();
    if (!gameState.isGameActive) {
      gameState.startNewGame();
    }
    Navigator.pushNamed(context, '/enhanced-gameplay-screen');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final int lastPlayedLevel = gameState.currentLevel;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Animated background
            const AnimatedBackgroundWidget(),

            // Main content
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                    // Top section with audio controls and stats
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Audio controls
                          const AudioControlsWidget(),

                          // Player statistics
                          const PlayerStatsWidget(),
                        ],
                      ),
                    ),

                    // Game title
                    SizedBox(height: 5.h),
                    const GameTitleWidget(),

                    // Main menu buttons
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Primary button - Iniciar Juego
                          MenuButtonWidget(
                            text: 'Iniciar Juego',
                            backgroundColor: AppTheme.successLight,
                            onPressed: _handleIniciarJuego,
                            isPrimary: true,
                          ),

                          // Secondary buttons
                          MenuButtonWidget(
                            text: 'Niveles',
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            onPressed: _handleNiveles,
                          ),

                          TextButton.icon(
                            onPressed: _toggleQuickAccess,
                            icon: const Icon(Icons.flash_on_rounded),
                            label: Text(
                              _showQuickAccess
                                  ? 'Ocultar acceso rápido'
                                  : 'Mostrar acceso rápido',
                            ),
                          ),

                          MenuButtonWidget(
                            text: 'Instrucciones',
                            backgroundColor: AppTheme.accentLight,
                            onPressed: _handleInstrucciones,
                          ),

                          // Quick access button (conditional)
                          if (_showQuickAccess) ...[
                            SizedBox(height: 2.h),
                            AnimatedOpacity(
                              opacity: _showQuickAccess ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                width: 70.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.warningLight,
                                      AppTheme.warningLight
                                          .withAlpha((0.8 * 255).round()),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withAlpha((0.5 * 255).round()),
                                    width: 1,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _handleQuickAccess,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomIconWidget(
                                            iconName: 'flash_on',
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            'Último Nivel ($lastPlayedLevel)',
                                            style: AppTheme.lightTheme.textTheme
                                                .titleMedium
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Footer
                    const FooterWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
