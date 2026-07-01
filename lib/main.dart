import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/adhan_service.dart';
import 'services/theme_service.dart';
import 'widgets/prayer_notification_popup.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
    // Tell notification service if app is in foreground
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeService,
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
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _mapThemeMode(themeService.themeMode),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: themeService.textScaler,
                ),
                child: Stack(
                  children: [
                    child!,
                    // Prayer notification popup overlay
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
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}