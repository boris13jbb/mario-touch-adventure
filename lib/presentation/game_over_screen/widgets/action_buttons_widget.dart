import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onRestartLevel;
  final VoidCallback onSelectLevel;
  final VoidCallback onMainMenu;

  const ActionButtonsWidget({
    Key? key,
    required this.onRestartLevel,
    required this.onSelectLevel,
    required this.onMainMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          context,
          text: 'Reiniciar Nivel',
          icon: 'refresh',
          color: AppTheme.successColor,
          onPressed: () {
            HapticFeedback.mediumImpact();
            onRestartLevel();
          },
          isPrimary: true,
        ),
        SizedBox(height: 2.h),
        _buildActionButton(
          context,
          text: 'Seleccionar Nivel',
          icon: 'list',
          color: AppTheme.lightTheme.colorScheme.secondary,
          onPressed: () {
            HapticFeedback.lightImpact();
            onSelectLevel();
          },
        ),
        SizedBox(height: 2.h),
        _buildActionButton(
          context,
          text: 'Menú Principal',
          icon: 'home',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          onPressed: () {
            HapticFeedback.lightImpact();
            onMainMenu();
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String text,
    required String icon,
    required Color color,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 75.w,
      height: 6.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? color : color.withValues(alpha: 0.1),
          foregroundColor: isPrimary ? Colors.white : color,
          elevation: isPrimary ? 4 : 2,
          shadowColor: color.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: color.withValues(alpha: 0.5),
                    width: 2,
                  ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isPrimary ? Colors.white : color,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isPrimary ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
