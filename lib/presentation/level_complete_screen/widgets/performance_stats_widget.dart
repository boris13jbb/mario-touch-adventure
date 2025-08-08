import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PerformanceStatsWidget extends StatefulWidget {
  final Map<String, dynamic> stats;

  const PerformanceStatsWidget({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  State<PerformanceStatsWidget> createState() => _PerformanceStatsWidgetState();
}

class _PerformanceStatsWidgetState extends State<PerformanceStatsWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late List<Animation<double>> _progressAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startProgressAnimations();
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimations = [
      Tween<double>(begin: 0.0, end: _getCoinsPercentage()).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      ),
      Tween<double>(begin: 0.0, end: _getEnemiesPercentage()).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
        ),
      ),
      Tween<double>(begin: 0.0, end: _getSecretsPercentage()).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
        ),
      ),
    ];
  }

  void _startProgressAnimations() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  double _getCoinsPercentage() {
    final collected = (widget.stats['coinsCollected'] as int?) ?? 0;
    final total = (widget.stats['totalCoins'] as int?) ?? 1;
    return collected / total;
  }

  double _getEnemiesPercentage() {
    final defeated = (widget.stats['enemiesDefeated'] as int?) ?? 0;
    final total = (widget.stats['totalEnemies'] as int?) ?? 1;
    return defeated / total;
  }

  double _getSecretsPercentage() {
    final found = (widget.stats['secretsFound'] as int?) ?? 0;
    final total = (widget.stats['totalSecrets'] as int?) ?? 1;
    return found / total;
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estadísticas del Nivel',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),

          // Coins collected
          _buildStatItem(
            icon: 'monetization_on',
            title: 'Monedas Recolectadas',
            value:
                '${widget.stats['coinsCollected']}/${widget.stats['totalCoins']}',
            progress: _progressAnimations[0],
            color: AppTheme.accentColor,
          ),

          SizedBox(height: 2.h),

          // Enemies defeated
          _buildStatItem(
            icon: 'sports_kabaddi',
            title: 'Enemigos Derrotados',
            value:
                '${widget.stats['enemiesDefeated']}/${widget.stats['totalEnemies']}',
            progress: _progressAnimations[1],
            color: AppTheme.warningColor,
          ),

          SizedBox(height: 2.h),

          // Secrets found
          _buildStatItem(
            icon: 'star',
            title: 'Secretos Encontrados',
            value:
                '${widget.stats['secretsFound']}/${widget.stats['totalSecrets']}',
            progress: _progressAnimations[2],
            color: AppTheme.successColor,
          ),

          SizedBox(height: 3.h),

          // Completion time
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'timer',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiempo de Completado',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatTime(
                            widget.stats['completionTime'] as int? ?? 0),
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getTimeRatingColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getTimeRating(),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String title,
    required String value,
    required Animation<double> progress,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        AnimatedBuilder(
          animation: progress,
          builder: (context, child) {
            return Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getTimeRating() {
    final time = widget.stats['completionTime'] as int? ?? 0;
    if (time <= 60) return 'RÁPIDO';
    if (time <= 120) return 'BUENO';
    return 'LENTO';
  }

  Color _getTimeRatingColor() {
    final time = widget.stats['completionTime'] as int? ?? 0;
    if (time <= 60) return AppTheme.successColor;
    if (time <= 120) return AppTheme.accentColor;
    return AppTheme.warningColor;
  }
}
