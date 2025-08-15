import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameStatsWidget extends StatelessWidget {
  final int coinsCollected;
  final int enemiesDefeated;
  final int levelProgress;
  final String timePlayed;

  const GameStatsWidget({
    Key? key,
    required this.coinsCollected,
    required this.enemiesDefeated,
    required this.levelProgress,
    required this.timePlayed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha((0.3 * 255).round()),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Estadísticas Finales',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                icon: 'monetization_on',
                value: coinsCollected.toString(),
                label: 'Monedas',
                color: AppTheme.accentLight,
              ),
              _buildStatItem(
                context,
                icon: 'sports_kabaddi',
                value: enemiesDefeated.toString(),
                label: 'Enemigos',
                color: AppTheme.warningLight,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                icon: 'flag',
                value: levelProgress.toString(),
                label: 'Nivel',
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
              _buildStatItem(
                context,
                icon: 'timer',
                value: timePlayed,
                label: 'Tiempo',
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withAlpha((0.2 * 255).round()),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 6.w,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
