import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlayerStatsWidget extends StatelessWidget {
  const PlayerStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock player statistics
    final Map<String, dynamic> playerStats = {
      "totalCoins": 2847,
      "highestLevel": 12,
      "livesRemaining": 3,
      "lastPlayed": "2025-08-07",
    };

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.9 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total coins
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: AppTheme.accentLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '\$',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '${playerStats["totalCoins"]}',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          // Highest level
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'flag',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Nivel ${playerStats["highestLevel"]}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          // Lives remaining
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                (playerStats["livesRemaining"] as int),
                (index) => Padding(
                  padding: EdgeInsets.only(right: 1.w),
                  child: CustomIconWidget(
                    iconName: 'favorite',
                    color: AppTheme.warningLight,
                    size: 14,
                  ),
                ),
              ),
              if ((playerStats["livesRemaining"] as int) < 3)
                ...List.generate(
                  3 - (playerStats["livesRemaining"] as int),
                  (index) => Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: CustomIconWidget(
                      iconName: 'favorite_border',
                      color: Colors.grey,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
