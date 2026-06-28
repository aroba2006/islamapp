import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Light Mode Color Palette
class LightColors {
  static const Color primary = Color(0xFF1B5E3F); // Dark green
  static const Color secondary = Color(0xFFA68B3D); // Darker gold for light mode
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF0F8F4); // Very light green
  static const Color surfaceVariant = Color(0xFFE8F3EE); // Slightly darker light green
  static const Color onBackground = Colors.black;
  static const Color onSurface = Color(0xFF1B5E3F);
  static const Color border = Color(0xFFA68B3D); // Darker gold
}

/// Dark Mode Color Palette
class DarkColors {
  static const Color primary = Color(0xFF1B5E3F); // Dark green
  static const Color secondary = Color(0xFFD4AF37); // Gold
  static const Color background = Color(0xFF0B3D2E); // Dark green background
  static const Color surface = Color(0xFF144D32); // Slightly lighter green
  static const Color surfaceVariant = Color(0xFF1A5A3D); // Even lighter green
  static const Color onBackground = Colors.white;
  static const Color onSurface = Colors.white;
  static const Color border = Color(0xFFD4AF37);
}

class AppTheme {
  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: LightColors.primary,
      primary: LightColors.primary,
      secondary: LightColors.secondary,
      surface: LightColors.surface,
      background: LightColors.background,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: LightColors.background,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: LightColors.background,
      foregroundColor: LightColors.onBackground,
      elevation: 0,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.amiri(color: LightColors.onBackground),
      displayMedium: GoogleFonts.arefRuqaa(color: LightColors.onBackground),
      titleLarge: GoogleFonts.elMessiri(color: LightColors.onBackground),
      bodyLarge: GoogleFonts.elMessiri(color: LightColors.onBackground),
      bodyMedium: GoogleFonts.elMessiri(color: LightColors.onSurface),
    ),
  );

  /// Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: DarkColors.primary,
      primary: DarkColors.primary,
      secondary: DarkColors.secondary,
      surface: DarkColors.surface,
      background: DarkColors.background,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: DarkColors.background,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkColors.background,
      foregroundColor: DarkColors.onBackground,
      elevation: 0,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.amiri(color: DarkColors.onBackground),
      displayMedium: GoogleFonts.arefRuqaa(color: DarkColors.onBackground),
      titleLarge: GoogleFonts.elMessiri(color: DarkColors.onBackground),
      bodyLarge: GoogleFonts.elMessiri(color: DarkColors.onBackground),
      bodyMedium: GoogleFonts.elMessiri(color: DarkColors.onSurface),
    ),
  );

  /// Get theme brightness (light or dark)
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get colors based on brightness
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color getSecondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  static Color getOnBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? DarkColors.onBackground 
        : LightColors.onBackground;
  }
}