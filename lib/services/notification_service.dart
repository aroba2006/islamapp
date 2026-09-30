import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'dart:isolate';
import 'dart:ui';

const String _stopPortName = 'adhan_stop_port';

@pragma('vm:entry-point')
void onNotificationResponse(NotificationResponse response) async {
  DartPluginRegistrant.ensureInitialized();
  debugPrint('Adhan stop pressed, action: ${response.actionId}');

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('stopAdhan', true);

  IsolateNameServer.lookupPortByName(_stopPortName)?.send('stop');
}

/// Represents an available adhan reciter
class AdhanReciter {
  final String name;
  final String assetPath; // Local asset path to adhan audio file

  AdhanReciter({
    required this.name,
    required this.assetPath,
  });
}

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static Timer? _adhanStopTimer;

  // ──── NOTIFICATION ENABLED STATE ────
  static bool _notificationsEnabled = true;

  // Available adhan reciters (local assets)
  static final List<AdhanReciter> adhanReciters = [
    AdhanReciter(
      name: 'Al-Afasi',
      assetPath: 'assets/adhan/afasiadhan.mp3',
    ),
    AdhanReciter(
      name: 'Tobar',
      assetPath: 'assets/adhan/adhantobar.mp3',
    ),
    AdhanReciter(
      name: 'Moqassas',
      assetPath: 'assets/adhan/moqassas.mp3',
    ),
    AdhanReciter(
      name: 'Qatami',
      assetPath: 'assets/adhan/qatamiadhan.mp3',
    ),
    AdhanReciter(
      name: 'Refaat',
      assetPath: 'assets/adhan/refaatadhan.mp3',
    ),
  ];

  // Currently selected reciter
  static AdhanReciter? selectedReciter;

  // Track if app is in foreground
  static bool _isAppInForeground = true;

  // Callback for in-app notifications
  static Function(String prayerName)? onPrayerTimeNotification;

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onNotificationResponse,
    );

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final android = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
      await android?.requestExactAlarmsPermission();
    }


    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    await _setupAudioSession();
    await _loadNotificationState();
  }

  static Future<void> _setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  static Future<void> _loadNotificationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    } catch (e) {
      print('Error loading notification state: $e');
      _notificationsEnabled = true;
    }
  }

  static bool areNotificationsEnabled() {
    return _notificationsEnabled;
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsEnabled', enabled);
      _notificationsEnabled = enabled;

      if (!enabled) {
        await cancelAll();
      }

      print('Notifications ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      print('Error setting notification state: $e');
    }
  }

  static void setAppInForeground(bool inForeground) {
    _isAppInForeground = inForeground;
  }

  static void selectAdhanReciter(AdhanReciter reciter) {
    selectedReciter = reciter;
  }

  static Future<void> _playAdhan(
    String prayerName, {
    Duration duration = const Duration(seconds: 30),
  }) async {
    if (selectedReciter == null) return;

    try {
      await _audioPlayer.setAsset(selectedReciter!.assetPath);
      _audioPlayer.play(); 

      _adhanStopTimer?.cancel();
      _adhanStopTimer = Timer(duration, () async {
        await _audioPlayer.stop();
      });
    } catch (e) {
      print('Error playing adhan: $e');
    }
  }

  static Future<void> stopAdhan() async {
    _adhanStopTimer?.cancel();
    await _audioPlayer.stop();
  }

  static Future<void> showInstantNotification(
    String title,
    String body, {
    bool playAdhan = false,
    Duration adhanDuration = const Duration(seconds: 30),
  }) async {
    if (!_notificationsEnabled) return;

    if (_isAppInForeground) {
      onPrayerTimeNotification?.call(title);
    } else {
      const androidDetails = AndroidNotificationDetails(
        'prayer_channel',
        'Prayer Times',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(0, title, body, details);
    }

    if (playAdhan) {
      _playAdhan(title, duration: adhanDuration);
    }
  }

  static Future<void> schedulePrayerNotification(
    String prayerName,
    DateTime prayerTime, {
    bool playAdhan = true,
  }) async {
    if (!_notificationsEnabled) return;
    if (prayerTime.isBefore(DateTime.now())) return;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final id = prayerName.hashCode & 0x7FFFFFFF;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('prayerName_$id', prayerName);

      await AndroidAlarmManager.oneShotAt(
        prayerTime,
        id,
        playBackgroundAdhanCallback,
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
        rescheduleOnReboot: true,
      );
    } 
    else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      final scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        iOS: iosDetails,
      );

      final iosPrefs = await SharedPreferences.getInstance();
      final iosLang = iosPrefs.getString('locale') ?? 'ar';

      await _notifications.zonedSchedule(
        prayerName.hashCode,
        _AdhanL10n.title(iosLang),
        _AdhanL10n.body(prayerName, iosLang),
        scheduledTime,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  /// ──── NEW: TEST ADHAN METHOD ────
  /// Instantly triggers the background alarm callback logic so you can test it 
  /// without waiting for an actual prayer time.
  static Future<void> showTestAdhan({required String reciter, required bool isWholeAdhan}) async {
    if (!_notificationsEnabled) return;

    // Save test state to SharedPreferences so the background callback reads it
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhanReciter', reciter);
    await prefs.setBool('isWholeAdhan', isWholeAdhan);
    await prefs.setString('prayerName_0', 'Test');
    await playBackgroundAdhanCallback(0);
  }

  static Future<void> cancelAll() async {
    await cancelAdhan();
    await _notifications.cancelAll();
  }

  static Future<void> cancelPrayerNotification(String prayerName) async {
    await _notifications.cancel(prayerName.hashCode);
  }

  static Future<void> cancelAdhan() async {
    _adhanStopTimer?.cancel();
    await _audioPlayer.stop();
  }

  static List<String> getAvailableReciters() {
    return adhanReciters.map((r) => r.name).toList();
  }

  static Future<void> dispose() async {
    _adhanStopTimer?.cancel();
    await _audioPlayer.dispose();
  }
}

// -------------------------------------------------------------
// TRANSLATIONS FOR THE ADHAN NOTIFICATION
// -------------------------------------------------------------
class _AdhanL10n {
  static const Map<String, String> _title = {
    'ar': 'حان وقت الصلاة',
    'en': "It's time to pray",
    'fr': "C'est l'heure de la prière",
  };

  static const Map<String, String> _stop = {
    'ar': 'إيقاف الأذان',
    'en': 'Stop Adhan',
    'fr': "Arrêter l'adhan",
  };

  static const Map<String, Map<String, String>> _names = {
    'fajr': {'ar': 'الفجر', 'en': 'Fajr', 'fr': 'Fajr'},
    'sunrise': {'ar': 'الشروق', 'en': 'Sunrise', 'fr': 'Lever du soleil'},
    'dhuhr': {'ar': 'الظهر', 'en': 'Dhuhr', 'fr': 'Dhuhr'},
    'asr': {'ar': 'العصر', 'en': 'Asr', 'fr': 'Asr'},
    'maghrib': {'ar': 'المغرب', 'en': 'Maghrib', 'fr': 'Maghrib'},
    'isha': {'ar': 'العشاء', 'en': 'Isha', 'fr': 'Isha'},
    'test': {'ar': 'تجربة', 'en': 'Test', 'fr': 'Test'},
  };

  /// Matches whatever key the prayer screen uses (English or Arabic).
  static String? _canon(String raw) {
    final s = raw.toLowerCase();
    if (s.contains('test') || raw.contains('تجربة')) return 'test';
    if (s.contains('fajr') || raw.contains('الفجر')) return 'fajr';
    if (s.contains('sunrise') || s.contains('shuruq') || raw.contains('الشروق')) return 'sunrise';
    if (s.contains('dhuhr') || s.contains('duhr') || s.contains('zuhr') || raw.contains('الظهر')) return 'dhuhr';
    if (s.contains('asr') || raw.contains('العصر')) return 'asr';
    if (s.contains('maghrib') || raw.contains('المغرب')) return 'maghrib';
    if (s.contains('isha') || raw.contains('العشاء')) return 'isha';
    return null;
  }

  static String _l(String lang) => (lang == 'en' || lang == 'fr') ? lang : 'ar';

  static String title(String lang) => _title[_l(lang)]!;

  static String stop(String lang) => _stop[_l(lang)]!;

  /// ar -> "الفجر"   |   en/fr -> "Fajr • الفجر"
  static String body(String raw, String lang) {
    final key = _canon(raw);
    if (key == null) return raw;
    final l = _l(lang);
    final name = _names[key]![l]!;
    if (l == 'ar' || key == 'test') return name;
    return '$name • ${_names[key]!['ar']}';
  }
}

// -------------------------------------------------------------
// STANDALONE BACKGROUND CALLBACK (ANDROID ONLY)
// -------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> playBackgroundAdhanCallback(int id) async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('stopAdhan', false);

  final reciterId = prefs.getString('adhanReciter') ?? 'mishary';
  final isWholeAdhan = prefs.getBool('isWholeAdhan') ?? true;
  final prayerName = prefs.getString('prayerName_$id') ?? 'Prayer';
  final lang = prefs.getString('locale') ?? 'ar';

  final notifications = FlutterLocalNotificationsPlugin();
  await notifications.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveNotificationResponse: onNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: onNotificationResponse,
  );

  final androidDetails = AndroidNotificationDetails(
    'adhan_channel',
    'Adhan',
    importance: Importance.max,
    priority: Priority.high,
    category: AndroidNotificationCategory.alarm,
    playSound: false, // just_audio plays the mp3
    enableVibration: true,
    ongoing: true, // can't be swiped away while playing
    autoCancel: true, // tapping it closes it (and stops the adhan)
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        'stop_adhan',
        _AdhanL10n.stop(lang),
        cancelNotification: true,
        showsUserInterface: false,
      ),
    ],
  );

  await notifications.show(
    id,
    _AdhanL10n.title(lang),
    _AdhanL10n.body(prayerName, lang),
    NotificationDetails(android: androidDetails),
  );

  const paths = {
    'mishary': 'assets/adhan/afasiadhan',
    'nasser': 'assets/adhan/qatamiadhan',
    'qassas': 'assets/adhan/moqassas',
    'refaat': 'assets/adhan/refaatadhan',
    'tobar': 'assets/adhan/adhantobar',
  };
  final basePath = paths[reciterId] ?? 'assets/adhan/afasiadhan';
  final assetPath = isWholeAdhan ? '$basePath.mp3' : '${basePath}_takbeer.mp3';

  final player = AudioPlayer();
  final stopPort = ReceivePort();
  IsolateNameServer.removePortNameMapping(_stopPortName);
  IsolateNameServer.registerPortWithName(stopPort.sendPort, _stopPortName);
  stopPort.listen((msg) async {
    if (msg == 'stop') await player.stop(); // makes play() below return
  });

  final poller = Timer.periodic(const Duration(milliseconds: 500), (_) async {
    await prefs.reload();
    if (prefs.getBool('stopAdhan') ?? false) {
      await player.stop();
    }
  });

  try {
    await player.setAsset(assetPath);
    await player.play(); // AWAIT: completes when finished or stopped
  } catch (e) {
    debugPrint('Background audio error: $e');
  } finally {
    poller.cancel();
    await notifications.cancel(id);
    IsolateNameServer.removePortNameMapping(_stopPortName);
    stopPort.close();
    await player.dispose();
  }
}