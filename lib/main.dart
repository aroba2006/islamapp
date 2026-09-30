import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/adhan_service.dart';
import 'services/theme_service.dart';
//import 'services/quran_reciter_service.dart';
import 'widgets/prayer_notification_popup.dart';
import 'app_theme.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await AndroidAlarmManager.initialize();
  }

  await NotificationService.initialize();
  await AdhanService.initialize();
  await ThemeService().initialize();
  
  // Initialize Quran audio service
  /*final quranService = QuranReciterService();
  await quranService.initialize();*/
  
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
  //final QuranReciterService _quranService = QuranReciterService();
  PrayerNotificationPopup? _currentNotification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPreferences();
    
    NotificationService.setAppInForeground(true);
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
        onStopAdhan: () {
          NotificationService.stopAdhan();
          AdhanService.stopAdhan();
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
   // _quranService.dispose();
    super.dispose();
  }

  /// Build theme with Google Fonts applied correctly to fix loading issues
  ThemeData _buildTheme(ThemeData baseTheme, String fontKey) {
    TextTheme newTextTheme;
    switch (fontKey) {
      case 'elMessiri': newTextTheme = GoogleFonts.elMessiriTextTheme(baseTheme.textTheme); break;
      case 'arefRuqaa': newTextTheme = GoogleFonts.arefRuqaaTextTheme(baseTheme.textTheme); break;
      case 'cairo': newTextTheme = GoogleFonts.cairoTextTheme(baseTheme.textTheme); break;
      case 'tajawal': newTextTheme = GoogleFonts.tajawalTextTheme(baseTheme.textTheme); break;
      case 'almarai': newTextTheme = GoogleFonts.almaraiTextTheme(baseTheme.textTheme); break;
      case 'reemKufi': newTextTheme = GoogleFonts.reemKufiTextTheme(baseTheme.textTheme); break;
      case 'changa': newTextTheme = GoogleFonts.changaTextTheme(baseTheme.textTheme); break;
      case 'lateef': newTextTheme = GoogleFonts.lateefTextTheme(baseTheme.textTheme); break;
      case 'ibmPlexSansArabic': newTextTheme = GoogleFonts.ibmPlexSansArabicTextTheme(baseTheme.textTheme); break;
      case 'readexPro': newTextTheme = GoogleFonts.readexProTextTheme(baseTheme.textTheme); break;
      case 'rakkas': newTextTheme = GoogleFonts.rakkasTextTheme(baseTheme.textTheme); break;
      case 'kufam': newTextTheme = GoogleFonts.kufamTextTheme(baseTheme.textTheme); break;
      case 'amiri':
      default:
        newTextTheme = GoogleFonts.amiriTextTheme(baseTheme.textTheme);
        break;
    }
    return baseTheme.copyWith(textTheme: newTextTheme);
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