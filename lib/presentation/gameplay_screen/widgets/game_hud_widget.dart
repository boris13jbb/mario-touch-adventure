import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class GameHudWidget extends StatelessWidget {
  final int lives;
  final int level;
  final int coins;
  final VoidCallback onPause;

  const GameHudWidget({
    Key? key,
    required this.lives,
    required this.level,
    required this.coins,
    required this.onPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Lives counter
            _buildLivesCounter(),

            // Level indicator
            _buildLevelIndicator(),

            // Coins and pause button
            Row(
              children: [
                _buildCoinsCounter(),
                SizedBox(width: 3.w),
                _buildPauseButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivesCounter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < lives; i++)
            Padding(
              padding: EdgeInsets.only(right: i < lives - 1 ? 1.w : 0),
              child: CustomIconWidget(
                iconName: 'favorite',
                color: Colors.red,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLevelIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Nivel $level',
        style: GoogleFonts.fredoka(
          fontSize: 14.sp,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildCoinsCounter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'monetization_on',
            color: AppTheme.accentColor,
            size: 18,
          ),
          SizedBox(width: 1.w),
          Text(
            '$coins',
            style: GoogleFonts.nunito(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPauseButton() {
    return GestureDetector(
      onTap: onPause,
      child: Container(
        width: 10.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: 'pause',
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
