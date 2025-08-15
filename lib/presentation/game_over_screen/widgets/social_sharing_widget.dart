import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialSharingWidget extends StatelessWidget {
  final int coinsCollected;
  final int enemiesDefeated;
  final int levelProgress;

  const SocialSharingWidget({
    Key? key,
    required this.coinsCollected,
    required this.enemiesDefeated,
    required this.levelProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withAlpha((0.8 * 255).round()),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha((0.2 * 255).round()),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Comparte tu Puntuación',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareButton(
                context,
                icon: 'share',
                label: 'Compartir',
                color: AppTheme.lightTheme.colorScheme.primary,
                onPressed: () => _shareScore(context),
              ),
              _buildShareButton(
                context,
                icon: 'content_copy',
                label: 'Copiar',
                color: AppTheme.lightTheme.colorScheme.secondary,
                onPressed: () => _copyScore(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: color.withAlpha((0.1 * 255).round()),
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color: color.withAlpha((0.3 * 255).round()),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareScore(BuildContext context) {
    final shareText = _generateShareText();
    // Platform-specific sharing would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartiendo puntuación: $shareText'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _copyScore(BuildContext context) {
    final shareText = _generateShareText();
    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Puntuación copiada al portapapeles'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  String _generateShareText() {
    return '¡Acabo de completar el nivel $levelProgress en Mario Touch Adventure! 🎮\n'
        'Monedas: $coinsCollected 🪙\n'
        'Enemigos derrotados: $enemiesDefeated ⚔️\n'
        '¡Únete a la aventura!';
  }
}
