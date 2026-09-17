import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // FIX: Added foundation for web-safe platform checks
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

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

  // Track if app is in foreground (default to true since app is running)
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

    await _notifications.initialize(initSettings);

    // FIX: Web-safe check for iOS
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

    // Setup audio session
    await _setupAudioSession();

    // Load notification enabled state from SharedPreferences
    await _loadNotificationState();
  }

  static Future<void> _setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  /// Load notification enabled state from SharedPreferences
  static Future<void> _loadNotificationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    } catch (e) {
      print('Error loading notification state: $e');
      _notificationsEnabled = true;
    }
  }

  /// Check if notifications are enabled
  static bool areNotificationsEnabled() {
    return _notificationsEnabled;
  }

  /// Set notification enabled/disabled state and persist to SharedPreferences
  static Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsEnabled', enabled);
      _notificationsEnabled = enabled;

      // If disabling, cancel all pending notifications
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

  /// Play adhan audio for a specific duration
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

  /// Schedule prayer notification with adhan playback
  static Future<void> schedulePrayerNotification(
    String prayerName,
    DateTime prayerTime, {
    bool playAdhan = true,
    Duration adhanDuration = const Duration(seconds: 30),
  }) async {
    if (!_notificationsEnabled) return;
    if (prayerTime.isBefore(DateTime.now())) return;

    // FIX: Web-safe check for Android
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nextPrayerName', prayerName);

      await AndroidAlarmManager.oneShotAt(
        prayerTime,
        prayerName.hashCode,
        playBackgroundAdhanCallback,
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
        rescheduleOnReboot: true,
      );
    } 
    // FIX: Web-safe check for iOS
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

      await _notifications.zonedSchedule(
        prayerName.hashCode,
        'Time for $prayerName',
        'It\'s time to pray $prayerName',
        scheduledTime,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
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
// STANDALONE BACKGROUND CALLBACK (ANDROID ONLY)
// -------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> playBackgroundAdhanCallback() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  final reciterId = prefs.getString('adhanReciter') ?? 'mishary';
  final duration = prefs.getInt('notificationAdhanDuration') ?? 30;
  final prayerName = prefs.getString('nextPrayerName') ?? 'Prayer';
  
  // Initialize notifications for background isolate
  final notifications = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await notifications.initialize(const InitializationSettings(android: androidInit));

  const androidDetails = AndroidNotificationDetails(
    'prayer_channel', 
    'Prayer Times',
    importance: Importance.max,
    priority: Priority.high,
    playSound: false, // Keep silent, we play audio manually below!
    enableVibration: true,
  );
  
  await notifications.show(
    prayerName.hashCode, 
    'Time for $prayerName', 
    'It is time to pray $prayerName', 
    const NotificationDetails(android: androidDetails)
  );

  final player = AudioPlayer();
  
  final paths = {
    'mishary': 'assets/adhan/afasiadhan.mp3',
    'nasser':  'assets/adhan/qatamiadhan.mp3',
    'qassas':  'assets/adhan/moqassas.mp3',
    'refaat':  'assets/adhan/refaatadhan.mp3',
    'tobar':   'assets/adhan/adhantobar.mp3',
  };
  
  try {
    await player.setAsset(paths[reciterId] ?? 'assets/adhan/afasiadhan.mp3');
    
    player.play(); 
    
    // Start cutoff timer
    if (duration < 300) { 
      Timer(Duration(seconds: duration), () async {
        await player.stop();
        await player.dispose();
      });
    }
  } catch (e) {
    debugPrint("Background audio error: $e");
  }
}