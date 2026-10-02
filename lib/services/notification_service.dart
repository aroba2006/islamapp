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
import 'package:wakelock_plus/wakelock_plus.dart';
//import 'package:sound_mode/sound_mode.dart';
//import 'package:sound_mode/utils/ringer_mode_statuses.dart';

import 'package:sound_mode_advanced/sound_mode_advanced.dart';

const String _stopPortName = 'adhan_stop_port';

// --- THE TRACKER ---
// This guarantees no "zombie" players can escape being stopped
final List<AudioPlayer> _activeBackgroundPlayers = [];

@pragma('vm:entry-point')
void onNotificationResponse(NotificationResponse response) async {
  DartPluginRegistrant.ensureInitialized();
  debugPrint('Adhan stop pressed, action: ${response.actionId}');

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('stopAdhan', true);

  IsolateNameServer.lookupPortByName(_stopPortName)?.send('stop');
}

class AdhanReciter {
  final String name;
  final String assetPath;

  AdhanReciter({
    required this.name,
    required this.assetPath,
  });
}

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static Timer? _adhanStopTimer;

  static bool _notificationsEnabled = true;

  // ─────────────────────────────────────────────────────────────
  // ADHAN RECITERS — must stay in sync with SettingsScreen's
  // `_adhanReciterImages` map (7 entries).
  // ─────────────────────────────────────────────────────────────
  static final List<AdhanReciter> adhanReciters = [
    AdhanReciter(name: 'Al-Afasi', assetPath: 'assets/adhan/afasiadhan.mp3'),
    AdhanReciter(name: 'Tobar', assetPath: 'assets/adhan/adhantobar.mp3'),
    AdhanReciter(name: 'Moqassas', assetPath: 'assets/adhan/moqassas.mp3'),
    AdhanReciter(name: 'Qatami', assetPath: 'assets/adhan/qatamiadhan.mp3'),
    AdhanReciter(name: 'Refaat', assetPath: 'assets/adhan/refaatadhan.mp3'),
    AdhanReciter(name: 'Basset', assetPath: 'assets/adhan/bassetadhan.mp3'),
    AdhanReciter(name: 'Hosari', assetPath: 'assets/adhan/hosariadhan.mp3'),
  ];

  static AdhanReciter? selectedReciter;
  static bool _isAppInForeground = true;
  static Function(String prayerName)? onPrayerTimeNotification;

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onNotificationResponse,
    );

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final android = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
      await android?.requestExactAlarmsPermission();
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
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

  static Future<void> _playAdhan(String prayerName, {Duration duration = const Duration(seconds: 30)}) async {
    if (selectedReciter == null) return;
    try {
      await _audioPlayer.setAsset(selectedReciter!.assetPath);
      _audioPlayer.play(); 

      _adhanStopTimer?.cancel();
      _adhanStopTimer = Timer(duration, () async {
        await stopAdhan();
      });
    } catch (e) {
      print('Error playing adhan: $e');
    }
  }

  // --- THE NUCLEAR STOP COMMAND ---
  static Future<void> stopAdhan() async {
    // 1. Kill the static foreground player
    _adhanStopTimer?.cancel();
    try { await _audioPlayer.stop(); } catch (_) {}

    // 2. Kill ANY zombie players spawned by the Test button in the foreground
    for (var player in _activeBackgroundPlayers) {
      try { await player.stop(); } catch (_) {}
    }

    // 3. Command the background isolates to kill their players
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('stopAdhan', true);
      await prefs.reload(); // Force write
      IsolateNameServer.lookupPortByName(_stopPortName)?.send('stop');
    } catch (_) {}
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
        'prayer_channel', 'Prayer Times',
        importance: Importance.max, priority: Priority.high,
        enableVibration: true, playSound: true,
      );
      const iosDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
      const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
      await _notifications.show(0, title, body, details);
    }

    if (playAdhan) {
      _playAdhan(title, duration: adhanDuration);
    }
  }

  static Future<void> schedulePrayerNotification(String prayerName, DateTime prayerTime, {bool playAdhan = true}) async {
    if (!_notificationsEnabled) return;
    if (prayerTime.isBefore(DateTime.now())) return;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final id = prayerName.hashCode & 0x7FFFFFFF;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('prayerName_$id', prayerName);
      await prefs.setInt('prayerTime_$id', prayerTime.millisecondsSinceEpoch);

      await AndroidAlarmManager.oneShotAt(
        prayerTime, id, playBackgroundAdhanCallback,
        exact: true, wakeup: true, allowWhileIdle: true, rescheduleOnReboot: true,
      );
    } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      final scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);
      const iosDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
      const details = NotificationDetails(iOS: iosDetails);
      final iosPrefs = await SharedPreferences.getInstance();
      final iosLang = iosPrefs.getString('locale') ?? 'ar';

      await _notifications.zonedSchedule(
        prayerName.hashCode, _AdhanL10n.title(iosLang), _AdhanL10n.body(prayerName, iosLang),
        scheduledTime, details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static Future<void> showTestAdhan({required String reciter, required bool isWholeAdhan}) async {
    if (!_notificationsEnabled) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhanReciter', reciter);
    await prefs.setBool('isWholeAdhan', isWholeAdhan);
    await prefs.setString('prayerName_0', 'Test');
    await playBackgroundAdhanCallback(0);
  }

  static Future<void> cancelAll() async {
    await stopAdhan();
    await _notifications.cancelAll();
    
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final prayerNames = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
      for (var name in prayerNames) {
        await AndroidAlarmManager.cancel(name.hashCode & 0x7FFFFFFF);
      }
    }
  }

  static Future<void> cancelPrayerNotification(String prayerName) async {
    final id = prayerName.hashCode & 0x7FFFFFFF;
    await _notifications.cancel(id);
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await AndroidAlarmManager.cancel(id);
    }
  }

  static Future<void> cancelAdhan() async {
    await stopAdhan();
  }

  static List<String> getAvailableReciters() {
    return adhanReciters.map((r) => r.name).toList();
  }

  static Future<void> dispose() async {
    _adhanStopTimer?.cancel();
    await _audioPlayer.dispose();
  }
}

class _AdhanL10n {
  static const Map<String, String> _title = {'ar': 'حان وقت الصلاة', 'en': "It's time to pray", 'fr': "C'est l'heure de la prière"};
  static const Map<String, String> _stop = {'ar': 'إيقاف الأذان', 'en': 'Stop Adhan', 'fr': "Arrêter l'adhan"};
  static const Map<String, Map<String, String>> _names = {
    'fajr': {'ar': 'الفجر', 'en': 'Fajr', 'fr': 'Fajr'},
    'sunrise': {'ar': 'الشروق', 'en': 'Sunrise', 'fr': 'Lever du soleil'},
    'dhuhr': {'ar': 'الظهر', 'en': 'Dhuhr', 'fr': 'Dhuhr'},
    'asr': {'ar': 'العصر', 'en': 'Asr', 'fr': 'Asr'},
    'maghrib': {'ar': 'المغرب', 'en': 'Maghrib', 'fr': 'Maghrib'},
    'isha': {'ar': 'العشاء', 'en': 'Isha', 'fr': 'Isha'},
    'test': {'ar': 'تجربة', 'en': 'Test', 'fr': 'Test'},
  };

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
  
  static String body(String raw, String lang) {
    final key = _canon(raw);
    if (key == null) return raw;
    final l = _l(lang);
    final name = _names[key]![l]!;
    if (l == 'ar' || key == 'test') return name;
    return '$name • ${_names[key]!['ar']}';
  }
}

@pragma('vm:entry-point')
Future<void> playBackgroundAdhanCallback(int id) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. ACQUIRE WAKELOCK
  WakelockPlus.enable(); 
  
  final prefs = await SharedPreferences.getInstance();

  if (id != 0) {
    final scheduledTimeMs = prefs.getInt('prayerTime_$id') ?? 0;
    if (scheduledTimeMs == 0) {
      WakelockPlus.disable();
      return;
    }
    final scheduledTime = DateTime.fromMillisecondsSinceEpoch(scheduledTimeMs);
    final now = DateTime.now();
    if (now.difference(scheduledTime).inMinutes > 2) {
      WakelockPlus.disable();
      return;
    }
  }

  await prefs.setBool('stopAdhan', false);

  final reciterId = prefs.getString('adhanReciter') ?? 'mishary';
  final isWholeAdhan = prefs.getBool('isWholeAdhan') ?? true;
  final prayerName = prefs.getString('prayerName_$id') ?? 'Prayer';
  final lang = prefs.getString('locale') ?? 'ar';

  final notifications = FlutterLocalNotificationsPlugin();
  await notifications.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: onNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: onNotificationResponse,
  );

  final androidDetails = AndroidNotificationDetails(
    'adhan_channel', 'Adhan',
    importance: Importance.max, priority: Priority.high, category: AndroidNotificationCategory.alarm,
    playSound: false, enableVibration: true, ongoing: true, autoCancel: false,
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction('stop_adhan', _AdhanL10n.stop(lang), cancelNotification: true, showsUserInterface: false),
    ],
  );

  const iosDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: false);

  await notifications.show(
    id, _AdhanL10n.title(lang), _AdhanL10n.body(prayerName, lang),
    NotificationDetails(android: androidDetails, iOS: iosDetails),
  );

  // ─────────────────────────────────────────────────────────────
  // ADHAN ASSET RESOLUTION — MUST MATCH SettingsScreen's reciter IDs
  // ('mishary', 'nasser', 'qassas', 'refaat', 'tobar', 'basset', 'hosari')
  // ─────────────────────────────────────────────────────────────
  const paths = {
    'mishary': 'assets/adhan/afasiadhan',
    'nasser' : 'assets/adhan/qatamiadhan',
    'qassas' : 'assets/adhan/moqassas',
    'refaat' : 'assets/adhan/refaatadhan',
    'tobar'  : 'assets/adhan/adhantobar',
    'basset' : 'assets/adhan/bassetadhan',
    'hosari' : 'assets/adhan/hosariadhan',
  };

  final basePath = paths[reciterId];
  if (basePath == null) {
    debugPrint('⚠️ Unknown adhan reciter "$reciterId" — defaulting to mishary');
  }
  final resolved = basePath ?? 'assets/adhan/afasiadhan';
  final assetPath = isWholeAdhan ? '$resolved.mp3' : '${resolved}_takbeer.mp3';

  debugPrint('🎧 Adhan playback: reciter=$reciterId whole=$isWholeAdhan asset=$assetPath');

  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration(
    avAudioSessionCategory: AVAudioSessionCategory.playback,
    avAudioSessionMode: AVAudioSessionMode.defaultMode,
    avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
    avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
    androidAudioAttributes: AndroidAudioAttributes(
      contentType: AndroidAudioContentType.sonification,
      flags: AndroidAudioFlags.none,
      usage: AndroidAudioUsage.notification,
    ),
  ));

  final player = AudioPlayer();
  _activeBackgroundPlayers.add(player); 

  final stopPort = ReceivePort();
  IsolateNameServer.removePortNameMapping(_stopPortName);
  IsolateNameServer.registerPortWithName(stopPort.sendPort, _stopPortName);
  
  stopPort.listen((msg) async {
    if (msg == 'stop') {
      for (var p in _activeBackgroundPlayers) {
        try { await p.stop(); } catch (_) {}
      }
    }
  });

  final poller = Timer.periodic(const Duration(milliseconds: 500), (_) async {
    await prefs.reload();
    if (prefs.getBool('stopAdhan') ?? false) {
      for (var p in _activeBackgroundPlayers) {
        try { await p.stop(); } catch (_) {}
      }
    }
  });

  try {
    // 3. CHECK SILENT/VIBRATE MODE
    bool shouldPlaySound = true;
    try {
      final ringerStatus = await SoundMode.ringerModeStatus;
      if (ringerStatus == RingerModeStatus.silent || 
          ringerStatus == RingerModeStatus.vibrate) {
        shouldPlaySound = false;
      }
    } catch (e) {
      debugPrint('Failed to check ringer status: $e');
    } 
    
    // 4. CONDITIONAL PLAYBACK
    if (shouldPlaySound) {
      try {
        await player.setAsset(assetPath);
        await player.play(); // Completes when audio finishes
      } catch (e) {
        debugPrint('❌ Adhan asset missing or failed for "$reciterId" ($assetPath): $e');
        // Graceful fallback so the user still hears *an* adhan
        try {
          final fallback = isWholeAdhan
              ? 'assets/adhan/afasiadhan.mp3'
              : 'assets/adhan/afasiadhan_takbeer.mp3';
          debugPrint('↩️ Falling back to $fallback');
          await player.setAsset(fallback);
          await player.play();
        } catch (e2) {
          debugPrint('❌ Fallback also failed: $e2');
        }
      }
    } else {
      // If silent/vibrate, wait for 3 minutes so the visual notification 
      // stays on screen before auto-canceling, while remaining perfectly quiet.
      await Future.delayed(const Duration(minutes: 3));
    }
  } catch (e) {
    debugPrint('Background audio error: $e');
  } finally {
    // Cleanly wrapped finally block ensures shutdown logic executes exactly once
    poller.cancel();
    _activeBackgroundPlayers.remove(player); 
    
    await prefs.reload();
    final wasStopped = prefs.getBool('stopAdhan') ?? false;
    
    if (wasStopped) {
      await notifications.cancel(id);
    } else {
      const finishedDetails = AndroidNotificationDetails(
        'adhan_channel', 'Adhan',
        importance: Importance.defaultImportance, priority: Priority.defaultPriority,
        playSound: false, enableVibration: false, ongoing: false, autoCancel: true,
      );
      const finishedIosDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: false);
      
      await notifications.show(
        id, _AdhanL10n.title(lang), _AdhanL10n.body(prayerName, lang),
        const NotificationDetails(android: finishedDetails, iOS: finishedIosDetails),
      );
    }

    IsolateNameServer.removePortNameMapping(_stopPortName);
    stopPort.close();
    await player.dispose();
    
    // 5. RELEASE WAKELOCK
    WakelockPlus.disable(); 
  }
}