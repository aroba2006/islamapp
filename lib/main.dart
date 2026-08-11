import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
// ✅ ADDED
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/adhan_service.dart';
import 'services/theme_service.dart';
import 'widgets/prayer_notification_popup.dart';
import 'app_theme.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ ADDED: Initialize Firebase before anything else
  //await Firebase.initializeApp();

  // Initialize services
  await NotificationService.initialize();
  await AdhanService.initialize();
  await ThemeService().initialize();
  
  runApp(const IslamicApp());
}

class IslamicApp extends StatefulWidget {
  const IslamicApp({super.key});

  static _IslamicAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_IslamicAppState>();

  @override
  State<IslamicApp> createState() => _IslamicAppState();
}

class _IslamicAppState extends State<IslamicApp> with WidgetsBindingObserver {
  String _locale = 'ar';
  final ThemeService _themeService = ThemeService();
  PrayerNotificationPopup? _currentNotification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPreferences();
    
    // Mark app as in foreground from the start
    NotificationService.setAppInForeground(true);
    
    // Setup notification callback for in-app popups
    NotificationService.onPrayerTimeNotification = _showInAppNotification;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      NotificationService.setAppInForeground(true);
    } else {
      NotificationService.setAppInForeground(false);
    }
  }

  void _showInAppNotification(String prayerName) {
    setState(() {
      _currentNotification = PrayerNotificationPopup(
        prayerName: prayerName,
        onDismiss: () {
          setState(() => _currentNotification = null);
        },
      );
    });
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locale = prefs.getString('locale') ?? 'ar';
    });
  }

  Future<void> setLocale(String newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', newLocale);
    setState(() => _locale = newLocale);
  }

  Future<void> setAdhanReciter(String reciter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhanReciter', reciter);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationService.dispose();
    super.dispose();
  }

  /// Build theme with Google Fonts applied
  ThemeData _buildTheme(ThemeData baseTheme, String fontKey) {
    final fontFamily = _getGoogleFontFamily(fontKey);
    final newTextTheme = baseTheme.textTheme.apply(
      fontFamily: fontFamily,
    );
    return baseTheme.copyWith(textTheme: newTextTheme);
  }

  String _getGoogleFontFamily(String fontKey) {
    switch (fontKey) {
      case 'amiri': return GoogleFonts.amiri().fontFamily ?? 'Amiri';
      case 'elMessiri': return GoogleFonts.elMessiri().fontFamily ?? 'El Messiri';
      case 'arefRuqaa': return GoogleFonts.arefRuqaa().fontFamily ?? 'Aref Ruqaa';
      case 'cairo': return GoogleFonts.cairo().fontFamily ?? 'Cairo';
      case 'tajawal': return GoogleFonts.tajawal().fontFamily ?? 'Tajawal';
      default: return GoogleFonts.amiri().fontFamily ?? 'Amiri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeService),
        ChangeNotifierProvider(
          create: (_) => AuthService()..initialize(),
        ),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Islamy App',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
              Locale('fr'),
            ],
            locale: Locale(_locale),
            theme: _buildTheme(AppTheme.lightTheme, themeService.fontFamily),
            darkTheme: _buildTheme(AppTheme.darkTheme, themeService.fontFamily),
            themeMode: _mapThemeMode(themeService.themeMode),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: themeService.textScaler,
                ),
                child: Stack(
                  children: [
                    child!,
                    if (_currentNotification != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(child: _currentNotification!),
                      ),
                  ],
                ),
              );
            },
            home: const HomeScreen(),
          );
        },
      ),
    );
  }

  ThemeMode _mapThemeMode(AppThemeMode serviceMode) {
    switch (serviceMode) {
      case AppThemeMode.light: return ThemeMode.light;
      case AppThemeMode.dark: return ThemeMode.dark;
      case AppThemeMode.system: return ThemeMode.system;
    }
  }
}