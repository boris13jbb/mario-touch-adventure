import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudioControlsWidget extends StatefulWidget {
  const AudioControlsWidget({Key? key}) : super(key: key);

  @override
  State<AudioControlsWidget> createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Background music toggle
        GestureDetector(
          onTap: () {
            setState(() {
              _isMusicEnabled = !_isMusicEnabled;
            });
          },
          child: Container(
            width: 12.w,
            height: 12.w,
            margin: EdgeInsets.only(bottom: 2.h),
            decoration: BoxDecoration(
              color: _isMusicEnabled
                  ? AppTheme.lightTheme.colorScheme.primary
                  : Colors.grey.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _isMusicEnabled ? 'music_note' : 'music_off',
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        // Sound effects toggle
        GestureDetector(
          onTap: () {
            setState(() {
              _isSoundEnabled = !_isSoundEnabled;
            });
          },
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _isSoundEnabled
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : Colors.grey.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _isSoundEnabled ? 'volume_up' : 'volume_off',
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
