import 'package:flutter/material.dart';

/// A class that contains all theme configurations for the mobile gaming application.
class AppTheme {
  AppTheme._();

  // Gaming-optimized color palette for mobile platformer
  static const Color primaryColor = Color(0xFF1E3A8A); // Azul principal institucional
  static const Color secondaryColor = Color(0xFF16A34A); // Verde secundario
  static const Color accentColor = Color(0xFFF97316); // Naranja/Coral
  static const Color backgroundColor = Color(0xFFFFFFFF); // Blanco
  
  static const Color primaryLight = Color(0xFF1E3A8A);
  static const Color primaryVariantLight = Color(0xFF1F4E99);
  static const Color secondaryLight = Color(0xFF16A34A);
  static const Color secondaryVariantLight = Color(0xFF22C55E);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color errorLight = Color(0xFFFF8B94);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF2D3436);
  static const Color onSurfaceLight = Color(0xFF2D3436);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // Success and warning colors for gaming feedback
  static const Color successLight = Color(0xFF16A34A);
  static const Color warningLight = Color(0xFFF97316);
  static const Color accentLight = Color(0xFFF97316);

  // Dark theme colors (adapted for gaming)
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primaryVariantDark = Color(0xFF1F4E99);
  static const Color secondaryDark = Color(0xFF16A34A);
  static const Color secondaryVariantDark = Color(0xFF22C55E);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceDark = Color(0xFF2D2D2D);
  static const Color errorDark = Color(0xFFFF8B94);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFFFFFFFF);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF000000);

  static const Color successDark = Color(0xFF16A34A);
  static const Color warningDark = Color(0xFFF97316);
  static const Color accentDark = Color(0xFFF97316);

  // Card and dialog colors optimized for gaming
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2D2D2D);
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFF2D2D2D);

  // Shadow colors for gaming UI depth
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x1AFFFFFF);

  // Divider colors for minimal borders
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF404040);

  // Text colors with gaming hierarchy
  static const Color textPrimaryLight = Color(0xFF2D3436);
  static const Color textSecondaryLight = Color(0xFF636E72);
  static const Color textDisabledLight = Color(0x61000000);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textDisabledDark = Color(0x61FFFFFF);

  /// Light theme optimized for mobile gaming
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: onPrimaryLight,
      primaryContainer: primaryVariantLight,
      onPrimaryContainer: onPrimaryLight,
      secondary: secondaryLight,
      onSecondary: onSecondaryLight,
      secondaryContainer: secondaryVariantLight,
      onSecondaryContainer: onSecondaryLight,
      tertiary: accentLight,
      onTertiary: onSecondaryLight,
      tertiaryContainer: accentLight,
      onTertiaryContainer: onSecondaryLight,
      error: errorLight,
      onError: onErrorLight,
      errorContainer: errorLight,
      onErrorContainer: onErrorLight,
      background: backgroundLight,
      onBackground: onBackgroundLight,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      surfaceVariant: surfaceLight,
      onSurfaceVariant: onSurfaceLight,
      outline: dividerLight,
      outlineVariant: dividerLight,
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: backgroundDark,
      onInverseSurface: onBackgroundDark,
      inversePrimary: primaryDark,
      surfaceTint: primaryLight,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimaryLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimaryLight,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondaryLight,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textSecondaryLight,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: onPrimaryLight,
        elevation: 4,
        shadowColor: shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        side: const BorderSide(color: primaryLight, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 4,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryLight,
      foregroundColor: onPrimaryLight,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: onPrimaryLight,
      elevation: 6,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceLight,
      contentTextStyle: const TextStyle(color: textPrimaryLight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: const DividerThemeData(
      color: dividerLight,
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(
      color: primaryLight,
      size: 24,
    ),
    primaryIconTheme: const IconThemeData(
      color: onPrimaryLight,
      size: 24,
    ),
  );

  /// Dark theme optimized for mobile gaming
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: onPrimaryDark,
      primaryContainer: primaryVariantDark,
      onPrimaryContainer: onPrimaryDark,
      secondary: secondaryDark,
      onSecondary: onSecondaryDark,
      secondaryContainer: secondaryVariantDark,
      onSecondaryContainer: onSecondaryDark,
      tertiary: accentDark,
      onTertiary: onSecondaryDark,
      tertiaryContainer: accentDark,
      onTertiaryContainer: onSecondaryDark,
      error: errorDark,
      onError: onErrorDark,
      errorContainer: errorDark,
      onErrorContainer: onErrorDark,
      background: backgroundDark,
      onBackground: onBackgroundDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      surfaceVariant: surfaceDark,
      onSurfaceVariant: onSurfaceDark,
      outline: dividerDark,
      outlineVariant: dividerDark,
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: backgroundLight,
      onInverseSurface: onBackgroundLight,
      inversePrimary: primaryLight,
      surfaceTint: primaryDark,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimaryDark,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondaryDark,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textSecondaryDark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: onPrimaryDark,
        elevation: 4,
        shadowColor: shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryDark,
        side: const BorderSide(color: primaryDark, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 4,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryDark,
      foregroundColor: onPrimaryDark,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: onPrimaryDark,
      elevation: 6,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorDark, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceDark,
      contentTextStyle: const TextStyle(color: textPrimaryDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: const DividerThemeData(
      color: dividerDark,
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(
      color: primaryDark,
      size: 24,
    ),
    primaryIconTheme: const IconThemeData(
      color: onPrimaryDark,
      size: 24,
    ),
  );
}
