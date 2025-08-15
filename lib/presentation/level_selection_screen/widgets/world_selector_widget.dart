import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class WorldSelectorWidget extends StatelessWidget {
  final String currentWorldName;
  final VoidCallback? onPreviousWorld;
  final VoidCallback? onNextWorld;
  final bool hasPreviousWorld;
  final bool hasNextWorld;

  const WorldSelectorWidget({
    Key? key,
    required this.currentWorldName,
    this.onPreviousWorld,
    this.onNextWorld,
    this.hasPreviousWorld = false,
    this.hasNextWorld = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous world button
            GestureDetector(
              onTap: hasPreviousWorld ? onPreviousWorld : null,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasPreviousWorld
                      ? AppTheme.lightTheme.colorScheme.primaryContainer
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back_ios',
                  color: hasPreviousWorld
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  size: 20,
                ),
              ),
            ),

            // Current world name
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer
                      .withAlpha((0.3 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentWorldName,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Next world button
            GestureDetector(
              onTap: hasNextWorld ? onNextWorld : null,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasNextWorld
                      ? AppTheme.lightTheme.colorScheme.primaryContainer
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: hasNextWorld
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
