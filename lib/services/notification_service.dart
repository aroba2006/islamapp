import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

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

    // Request iOS permissions
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

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
      _notificationsEnabled = true; // Default to enabled on error
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

  /// Set the app foreground/background state
  static void setAppInForeground(bool inForeground) {
    _isAppInForeground = inForeground;
  }

  /// Select which adhan reciter to use
  static void selectAdhanReciter(AdhanReciter reciter) {
    selectedReciter = reciter;
  }

  /// Play adhan audio for a specific duration
  static Future<void> _playAdhan(
    String prayerName, {
    Duration duration = const Duration(seconds: 30),
  }) async {
    if (selectedReciter == null) {
      print('No adhan reciter selected');
      return;
    }

    try {
      // Load from local assets
      await _audioPlayer.setAsset(selectedReciter!.assetPath);
      await _audioPlayer.play();

      // Stop after specified duration
      _adhanStopTimer?.cancel();
      _adhanStopTimer = Timer(duration, () async {
        await _audioPlayer.stop();
      });
    } catch (e) {
      print('Error playing adhan: $e');
    }
  }

  /// Stop adhan playback
  static Future<void> stopAdhan() async {
    _adhanStopTimer?.cancel();
    await _audioPlayer.stop();
  }

  /// Show instant notification with optional adhan playback
  /// Only shows if notifications are enabled
  static Future<void> showInstantNotification(
    String title,
    String body, {
    bool playAdhan = false,
    Duration adhanDuration = const Duration(seconds: 30),
  }) async {
    // CHECK IF NOTIFICATIONS ARE ENABLED
    if (!_notificationsEnabled) {
      print('Notifications disabled - skipping notification');
      return;
    }

    // Show notification or in-app popup FIRST (don't wait for adhan)
    if (_isAppInForeground) {
      // App is in foreground - show in-app popup immediately
      onPrayerTimeNotification?.call(title);
    } else {
      // App is in background - show system notification
      const androidDetails = AndroidNotificationDetails(
        'prayer_channel',
        'Prayer Times',
        channelDescription: 'Notifications for prayer times',
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

    // Play adhan in background (after popup is shown)
    if (playAdhan) {
      _playAdhan(title, duration: adhanDuration); // Don't await
    }
  }

  /// Schedule prayer notification with adhan playback
  /// Only schedules if notifications are enabled
  static Future<void> schedulePrayerNotification(
    String prayerName,
    DateTime prayerTime, {
    bool playAdhan = true,
    Duration adhanDuration = const Duration(seconds: 30),
  }) async {
    // CHECK IF NOTIFICATIONS ARE ENABLED
    if (!_notificationsEnabled) {
      print('Notifications disabled - skipping scheduled notification for $prayerName');
      return;
    }

    final scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);

    if (scheduledTime.isBefore(DateTime.now())) {
      return; // Don't schedule past times
    }

    // Create a callback that will be triggered at prayer time
    // Note: This requires native platform-specific setup for background execution

    const androidDetails = AndroidNotificationDetails(
      'prayer_channel',
      'Prayer Times',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      fullScreenIntent: true, // Show full-screen notification on Android
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

    await _notifications.zonedSchedule(
      prayerName.hashCode,
      'Time for $prayerName',
      'It\'s time to pray $prayerName',
      scheduledTime,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidAllowWhileIdle: true, // Allow notification even if device is in Doze mode
    );
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await cancelAdhan();
    await _notifications.cancelAll();
  }

  /// Cancel specific prayer notification
  static Future<void> cancelPrayerNotification(String prayerName) async {
    await _notifications.cancel(prayerName.hashCode);
  }

  /// Cancel adhan playback
  static Future<void> cancelAdhan() async {
    _adhanStopTimer?.cancel();
    await _audioPlayer.stop();
  }

  /// Get list of available reciters
  static List<String> getAvailableReciters() {
    return adhanReciters.map((r) => r.name).toList();
  }

  /// Dispose resources
  static Future<void> dispose() async {
    _adhanStopTimer?.cancel();
    await _audioPlayer.dispose();
  }
}