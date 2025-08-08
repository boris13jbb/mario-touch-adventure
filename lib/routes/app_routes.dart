import 'package:flutter/material.dart';
import '../presentation/level_selection_screen/level_selection_screen.dart';
import '../presentation/level_complete_screen/level_complete_screen.dart';
import '../presentation/gameplay_screen/gameplay_screen.dart';
import '../presentation/gameplay_screen/enhanced_gameplay_screen.dart';
import '../presentation/main_menu_screen/main_menu_screen.dart';
import '../presentation/game_over_screen/game_over_screen.dart';
import '../presentation/instructions_screen/instructions_screen.dart';

class AppRoutes {
  // Route constants
  static const String initial = '/';
  static const String levelSelection = '/level-selection-screen';
  static const String levelComplete = '/level-complete-screen';
  static const String gameplay = '/gameplay-screen';
  static const String enhancedGameplay = '/enhanced-gameplay-screen';
  static const String mainMenu = '/main-menu-screen';
  static const String gameOver = '/game-over-screen';
  static const String instructions = '/instructions-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const MainMenuScreen(),
    levelSelection: (context) => const LevelSelectionScreen(),
    levelComplete: (context) => const LevelCompleteScreen(),
    gameplay: (context) => const GameplayScreen(),
    enhancedGameplay: (context) => const EnhancedGameplayScreen(),
    mainMenu: (context) => const MainMenuScreen(),
    gameOver: (context) => const GameOverScreen(),
    instructions: (context) => const InstructionsScreen(),
  };
}
