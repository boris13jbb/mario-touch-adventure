import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_techniques_widget.dart';
import './widgets/control_demonstration_widget.dart';
import './widgets/gameplay_mechanics_widget.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _characterController;
  late Animation<double> _headerAnimation;
  late Animation<double> _characterAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _tutorialCompleted = false;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _characterController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutBack,
    ));

    _characterAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.easeInOut,
    ));

    _headerController.forward();
    _loadTutorialStatus();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _characterController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTutorialStatus() {
    // In a real app, this would load from SharedPreferences
    setState(() {
      _tutorialCompleted = false;
    });
  }

  void _markTutorialCompleted() {
    setState(() {
      _tutorialCompleted = true;
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Show completion message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Tutorial completado! Ya puedes comenzar a jugar.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Jugar',
          textColor: AppTheme.lightTheme.colorScheme.tertiary,
          onPressed: () => Navigator.pushNamed(context, '/gameplay-screen'),
        ),
      ),
    );
  }

  void _scrollToSection(double position) {
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -50 * (1 - _headerAnimation.value)),
                  child: Opacity(
                    opacity: _headerAnimation.value,
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow
                                .withAlpha((0.1 * 255).round()),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Back button
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withAlpha((0.1 * 255).round()),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'arrow_back',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 6.w,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 4.w),

                          // Title
                          Expanded(
                            child: Text(
                              'Instrucciones',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          // Completion status
                          if (_tutorialCompleted)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: Colors.white,
                                    size: 4.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Completado',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome section with animated character
                    Container(
                      width: 90.w,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary
                                .withAlpha((0.1 * 255).round()),
                            AppTheme.lightTheme.colorScheme.secondary
                                .withAlpha((0.1 * 255).round()),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withAlpha((0.3 * 255).round()),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Animated character sprite
                          AnimatedBuilder(
                            animation: _characterAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_characterAnimation.value, 0),
                                child: Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary
                                            .withAlpha((0.3 * 255).round()),
                                        blurRadius: 12,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'sports_esports',
                                      color: Colors.white,
                                      size: 10.w,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 3.h),

                          // Welcome text
                          Text(
                            '¡Bienvenido a Mario Touch Adventure!',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 2.h),

                          Text(
                            'Aprende los controles táctiles y las mecánicas del juego para convertirte en un maestro de las plataformas.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Quick navigation
                    Container(
                      width: 90.w,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withAlpha((0.3 * 255).round()),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Navegación Rápida',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    _scrollToSection(400);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary
                                          .withAlpha((0.1 * 255).round()),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'touch_app',
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          size: 6.w,
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'Controles',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    _scrollToSection(800);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary
                                          .withAlpha((0.1 * 255).round()),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'videogame_asset',
                                          color: AppTheme
                                              .lightTheme.colorScheme.secondary,
                                          size: 6.w,
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'Mecánicas',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    _scrollToSection(1200);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.tertiary
                                          .withAlpha((0.1 * 255).round()),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'star',
                                          color: AppTheme
                                              .lightTheme.colorScheme.tertiary,
                                          size: 6.w,
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'Avanzado',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Control demonstration section
                    const ControlDemonstrationWidget(),

                    SizedBox(height: 4.h),

                    // Gameplay mechanics section
                    const GameplayMechanicsWidget(),

                    SizedBox(height: 4.h),

                    // Advanced techniques section
                    const AdvancedTechniquesWidget(),

                    SizedBox(height: 4.h),

                    // Tips and completion section
                    Container(
                      width: 90.w,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withAlpha((0.3 * 255).round()),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow
                                .withAlpha((0.1 * 255).round()),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'lightbulb',
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                size: 6.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Consejos Importantes',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 3.h),

                          // Tips list
                          ...[
                            'Los botones de control están optimizados para el uso con los pulgares',
                            'Mantén presionado el botón de salto para saltos más altos',
                            'Los enemigos pueden ser eliminados saltando sobre ellos o disparándoles',
                            'Explora cada nivel completamente para encontrar todas las monedas',
                            'Usa el doble salto para alcanzar áreas difíciles',
                          ]
                              .map((tip) => Padding(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 2.w,
                                          height: 2.w,
                                          margin: EdgeInsets.only(top: 1.h),
                                          decoration: BoxDecoration(
                                            color: AppTheme.lightTheme
                                                .colorScheme.tertiary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Expanded(
                                          child: Text(
                                            tip,
                                            style: AppTheme
                                                .lightTheme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurface,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),

                          SizedBox(height: 3.h),

                          // Completion button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _tutorialCompleted
                                  ? null
                                  : _markTutorialCompleted,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _tutorialCompleted
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                    : AppTheme.lightTheme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: _tutorialCompleted
                                        ? 'check_circle'
                                        : 'play_arrow',
                                    color: Colors.white,
                                    size: 5.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    _tutorialCompleted
                                        ? '¡Tutorial Completado!'
                                        : 'Marcar como Completado',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.pushNamed(context, '/main-menu-screen');
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              side: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'home',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 5.w,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Menú Principal',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.pushNamed(context, '/gameplay-screen');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.secondary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'play_arrow',
                                  color: Colors.white,
                                  size: 5.w,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Comenzar Juego',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
