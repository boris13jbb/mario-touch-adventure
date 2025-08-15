import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> socialLinks = [
      {
        "name": "Facebook",
        "icon": "facebook",
        "url": "https://facebook.com/mariotouchadventure"
      },
      {
        "name": "Twitter",
        "icon": "alternate_email",
        "url": "https://twitter.com/mariotouchadv"
      },
      {
        "name": "Instagram",
        "icon": "camera_alt",
        "url": "https://instagram.com/mariotouchadventure"
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((0.8 * 255).round()),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Social media links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (socialLinks as List).map<Widget>((dynamic link) {
              final linkMap = link as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  // Handle social media link tap
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Abriendo ${linkMap["name"]}...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withAlpha((0.2 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: linkMap["icon"] as String,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 1.h),
          // Developer credits
          Text(
            '© 2025 Mario Touch Adventure',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha((0.8 * 255).round()),
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Desarrollado con ❤️ para gamers móviles',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha((0.6 * 255).round()),
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }
}
