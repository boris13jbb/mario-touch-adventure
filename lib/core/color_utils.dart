import 'package:flutter/material.dart';

/// Utility class for color operations
class ColorUtils {
  /// Create a color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// Create a color with alpha
  static Color withAlpha(Color color, int alpha) {
    return color.withAlpha(alpha);
  }
  
  /// Blend two colors
  static Color blend(Color color1, Color color2, double factor) {
    return Color.lerp(color1, color2, factor)!;
  }
  
  /// Darken a color
  static Color darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
  
  /// Lighten a color
  static Color lighten(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}
