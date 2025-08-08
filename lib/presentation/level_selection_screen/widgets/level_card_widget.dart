import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LevelCardWidget extends StatelessWidget {
  final Map<String, dynamic> levelData;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const LevelCardWidget({
    Key? key,
    required this.levelData,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLocked = levelData['isLocked'] as bool? ?? false;
    final bool isCompleted = levelData['isCompleted'] as bool? ?? false;
    final int levelNumber = levelData['levelNumber'] as int? ?? 1;
    final int difficulty = levelData['difficulty'] as int? ?? 1;
    final String thumbnailUrl = levelData['thumbnailUrl'] as String? ?? '';

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      onLongPress: isCompleted && onLongPress != null ? onLongPress : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isLocked
              ? AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5)
              : AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail section
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  color: AppTheme.lightTheme.colorScheme.primaryContainer
                      .withValues(alpha: 0.3),
                ),
                child: Stack(
                  children: [
                    // Level thumbnail
                    if (thumbnailUrl.isNotEmpty && !isLocked)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: CustomImageWidget(
                          imageUrl: thumbnailUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    // Lock overlay
                    if (isLocked)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'lock',
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                            size: 32,
                          ),
                        ),
                      ),

                    // Completion checkmark
                    if (isCompleted && !isLocked)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'check',
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Level info section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Level number
                    Text(
                      'Nivel $levelNumber',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: isLocked
                            ? AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5)
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Difficulty stars
                    if (!isLocked)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: CustomIconWidget(
                              iconName: 'star',
                              color: index < difficulty
                                  ? AppTheme.accentColor
                                  : AppTheme.lightTheme.colorScheme.outline,
                              size: 12,
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
