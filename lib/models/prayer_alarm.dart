class PrayerAlarm {
  final int id;
  final String prayerName; // e.g., 'Fajr'
  final int minutesOffset; // 0 for exact time, -15 for 15 mins before, +10 for after
  final String soundAsset; // e.g., 'assets/sounds/chilling_wake.mp3'
  final bool isSnoozeEnabled;
  final int snoozeDurationMins;

  PrayerAlarm({
    required this.id,
    required this.prayerName,
    this.minutesOffset = 0,
    this.soundAsset = 'assets/sounds/chilling_wake.mp3',
    this.isSnoozeEnabled = true,
    this.snoozeDurationMins = 5,
  });
}