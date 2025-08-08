import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/level_card_widget.dart';
import './widgets/level_quick_actions_widget.dart';
import './widgets/progress_header_widget.dart';
import './widgets/world_selector_widget.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int currentWorldIndex = 0;
  Map<String, dynamic>? selectedLevelForActions;

  // Mock data for worlds and levels
  final List<Map<String, dynamic>> worlds = [
    {
      "worldName": "Mundo 1: Praderas Verdes",
      "levels": [
        {
          "levelNumber": 1,
          "isLocked": false,
          "isCompleted": true,
          "difficulty": 1,
          "bestScore": 1250,
          "thumbnailUrl":
              "https://images.pexels.com/photos/1072179/pexels-photo-1072179.jpeg?auto=compress&cs=tinysrgb&w=400"
        },
        {
          "levelNumber": 2,
          "isLocked": false,
          "isCompleted": true,
          "difficulty": 1,
          "bestScore": 980,
          "thumbnailUrl":
              "https://images.pexels.com/photos/1072179/pexels-photo-1072179.jpeg?auto=compress&cs=tinysrgb&w=400"
        },
        {
          "levelNumber": 3,
          "isLocked": false,
          "isCompleted": false,
          "difficulty": 2,
          "bestScore": 0,
          "thumbnailUrl":
              "https://images.pexels.com/photos/1072179/pexels-photo-1072179.jpeg?auto=compress&cs=tinysrgb&w=400"
        },
        {
          "levelNumber": 4,
          "isLocked": false,
          "isCompleted": false,
          "difficulty": 2,
          "bestScore": 0,
          "thumbnailUrl":
              "https://images.pexels.com/photos/1072179/pexels-photo-1072179.jpeg?auto=compress&cs=tinysrgb&w=400"
        },
        {
          "levelNumber": 5,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
        {
          "levelNumber": 6,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
        {
          "levelNumber": 7,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
        {
          "levelNumber": 8,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
      ]
    },
    {
      "worldName": "Mundo 2: Desierto Ardiente",
      "levels": [
        {
          "levelNumber": 9,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 2,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
        {
          "levelNumber": 10,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 2,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
        {
          "levelNumber": 11,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
        {
          "levelNumber": 12,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
      ]
    },
    {
      "worldName": "Mundo 3: Montañas Heladas",
      "levels": [
        {
          "levelNumber": 13,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
        {
          "levelNumber": 14,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
        {
          "levelNumber": 15,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
        {
          "levelNumber": 16,
          "isLocked": true,
          "isCompleted": false,
          "difficulty": 3,
          "bestScore": 0,
          "thumbnailUrl": ""
        },
      ]
    },
  ];

  double get completionPercentage {
    int totalLevels = 0;
    int completedLevels = 0;

    for (var world in worlds) {
      final levels = world['levels'] as List;
      totalLevels += levels.length;
      completedLevels +=
          levels.where((level) => level['isCompleted'] == true).length;
    }

    return totalLevels > 0 ? (completedLevels / totalLevels) * 100 : 0;
  }

  List<Map<String, dynamic>> get currentLevels {
    if (currentWorldIndex < worlds.length) {
      return (worlds[currentWorldIndex]['levels'] as List)
          .cast<Map<String, dynamic>>();
    }
    return [];
  }

  String get currentWorldName {
    if (currentWorldIndex < worlds.length) {
      return worlds[currentWorldIndex]['worldName'] as String;
    }
    return '';
  }

  void _navigateToLevel(Map<String, dynamic> levelData) {
    final int levelNumber = levelData['levelNumber'] as int;
    Navigator.pushNamed(context, '/gameplay-screen', arguments: {
      'levelNumber': levelNumber,
      'worldIndex': currentWorldIndex,
    });
  }

  void _showQuickActions(Map<String, dynamic> levelData) {
    setState(() {
      selectedLevelForActions = levelData;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LevelQuickActionsWidget(
        levelData: levelData,
        onReplay: () {
          Navigator.pop(context);
          _navigateToLevel(levelData);
        },
        onViewScore: () {
          Navigator.pop(context);
          _showScoreDetails(levelData);
        },
        onShare: () {
          Navigator.pop(context);
          _shareAchievement(levelData);
        },
        onClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showScoreDetails(Map<String, dynamic> levelData) {
    final int levelNumber = levelData['levelNumber'] as int;
    final int bestScore = levelData['bestScore'] as int;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Estadísticas - Nivel $levelNumber'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mejor Puntuación: $bestScore'),
            const SizedBox(height: 8),
            Text('Intentos: ${(levelData['attempts'] as int?) ?? 1}'),
            const SizedBox(height: 8),
            Text(
                'Tiempo Récord: ${(levelData['bestTime'] as String?) ?? "2:45"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _shareAchievement(Map<String, dynamic> levelData) {
    final int levelNumber = levelData['levelNumber'] as int;
    final int bestScore = levelData['bestScore'] as int;

    // Simulate sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '¡Compartiendo logro del Nivel $levelNumber con puntuación $bestScore!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _switchWorld(int direction) {
    setState(() {
      if (direction > 0 && currentWorldIndex < worlds.length - 1) {
        currentWorldIndex++;
      } else if (direction < 0 && currentWorldIndex > 0) {
        currentWorldIndex--;
      }
    });
  }

  Future<void> _refreshProgress() async {
    // Simulate pull-to-refresh functionality
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // In a real app, this would sync with server
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Fixed header with progress
          ProgressHeaderWidget(
            completionPercentage: completionPercentage,
            onBackPressed: () =>
                Navigator.pushNamed(context, '/main-menu-screen'),
          ),

          // Main content with level grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProgress,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(4.w),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 4 : 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= currentLevels.length) return null;

                          final levelData = currentLevels[index];
                          return LevelCardWidget(
                            levelData: levelData,
                            onTap: () => _navigateToLevel(levelData),
                            onLongPress: levelData['isCompleted'] == true
                                ? () => _showQuickActions(levelData)
                                : null,
                          );
                        },
                        childCount: currentLevels.length,
                      ),
                    ),
                  ),

                  // Add some bottom padding for the world selector
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom world selector
      bottomNavigationBar: WorldSelectorWidget(
        currentWorldName: currentWorldName,
        hasPreviousWorld: currentWorldIndex > 0,
        hasNextWorld: currentWorldIndex < worlds.length - 1,
        onPreviousWorld: () => _switchWorld(-1),
        onNextWorld: () => _switchWorld(1),
      ),
    );
  }
}
