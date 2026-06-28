import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App Theme Mode (renamed to avoid conflict with Flutter's ThemeMode)
enum AppThemeMode {
  system,    // Follow device theme
  light,     // Force light mode
  dark,      // Force dark mode
}

/// Text Scale Factor for accessibility
enum TextScaleFactor {
  small,   // 0.85x
  medium,  // 1.0x (default)
  large;   // 1.2x

  /// Get the multiplier value
  double get multiplier {
    switch (this) {
      case TextScaleFactor.small:
        return 0.85;
      case TextScaleFactor.medium:
        return 1.0;
      case TextScaleFactor.large:
        return 1.2;
    }
  }

  /// Get readable label
  String getLabel(String languageCode) {
    switch (this) {
      case TextScaleFactor.small:
        return languageCode == 'ar' ? 'صغير' : (languageCode == 'fr' ? 'Petit' : 'Small');
      case TextScaleFactor.medium:
        return languageCode == 'ar' ? 'عادي' : (languageCode == 'fr' ? 'Moyen' : 'Medium');
      case TextScaleFactor.large:
        return languageCode == 'ar' ? 'كبير' : (languageCode == 'fr' ? 'Grand' : 'Large');
    }
  }
}

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  late SharedPreferences _prefs;
  AppThemeMode _themeMode = AppThemeMode.system;
  TextScaleFactor _textScaleFactor = TextScaleFactor.medium;
  bool _isInitialized = false;

  // Getters
  AppThemeMode get themeMode => _themeMode;
  TextScaleFactor get textScaleFactor => _textScaleFactor;
  double get textScaleMultiplier => _textScaleFactor.multiplier;
  bool get isInitialized => _isInitialized;

  /// A TextScaler built from the current multiplier — use this in a
  /// MediaQuery override to apply font scaling app-wide automatically.
  TextScaler get textScaler => TextScaler.linear(_textScaleFactor.multiplier);

  Future<void> initialize() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _loadThemeMode();
    _loadTextScaleFactor();
    _isInitialized = true;
    notifyListeners();
  }

  void _loadThemeMode() {
    final String? savedMode = _prefs.getString('themeMode');
    if (savedMode != null) {
      _themeMode = AppThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedMode,
        orElse: () => AppThemeMode.system,
      );
    } else {
      _themeMode = AppThemeMode.system;
    }
  }

  void _loadTextScaleFactor() {
    final String? savedScale = _prefs.getString('textScaleFactor');
    if (savedScale != null) {
      _textScaleFactor = TextScaleFactor.values.firstWhere(
        (scale) => scale.toString() == savedScale,
        orElse: () => TextScaleFactor.medium,
      );
    } else {
      _textScaleFactor = TextScaleFactor.medium;
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString('themeMode', mode.toString());
    notifyListeners();
  }

  Future<void> setTextScaleFactor(TextScaleFactor scale) async {
    _textScaleFactor = scale;
    await _prefs.setString('textScaleFactor', scale.toString());
    notifyListeners();
  }

  /// Get the actual brightness based on theme mode and system settings
  Brightness? getThemeBrightness(BuildContext context) {
    switch (_themeMode) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        return null; // Let system decide
    }
  }

  /// Check if currently in dark mode
  bool isDarkMode(BuildContext context) {
    final themeBrightness = getThemeBrightness(context);
    if (themeBrightness != null) {
      return themeBrightness == Brightness.dark;
    }
    // If system theme, check device settings
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  /// Apply text scale to a given size
  double getScaledSize(double baseSize) {
    return baseSize * _textScaleFactor.multiplier;
  }
}