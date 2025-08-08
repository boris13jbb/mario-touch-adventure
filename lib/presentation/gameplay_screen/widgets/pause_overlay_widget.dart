import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class PauseOverlayWidget extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onQuit;

  const PauseOverlayWidget({
    Key? key,
    required this.onResume,
    required this.onRestart,
    required this.onQuit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Container(
          width: 80.w,
          constraints: BoxConstraints(maxHeight: 60.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    'JUEGO PAUSADO',
                    style: GoogleFonts.fredoka(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Game paused icon
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'pause_circle_filled',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 48,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Action buttons
                    _buildActionButton(
                      text: 'CONTINUAR',
                      icon: 'play_arrow',
                      color: AppTheme.successColor,
                      onTap: onResume,
                    ),

                    SizedBox(height: 2.h),

                    _buildActionButton(
                      text: 'REINICIAR',
                      icon: 'refresh',
                      color: AppTheme.warningColor,
                      onTap: onRestart,
                    ),

                    SizedBox(height: 2.h),

                    _buildActionButton(
                      text: 'SALIR',
                      icon: 'exit_to_app',
                      color: Colors.red,
                      onTap: onQuit,
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 6.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              text,
              style: GoogleFonts.nunito(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
