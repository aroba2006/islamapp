/// Holds the five daily prayer times plus sunrise, as formatted strings (e.g. "4:12 AM").
class PrayerTimes {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String sunrise;
  final String dateReadable;

  PrayerTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
    required this.dateReadable,
  });

  factory PrayerTimes.fromAladhanJson(Map<String, dynamic> json) {
    final timings = json['timings'] as Map<String, dynamic>;
    final date = json['date'] as Map<String, dynamic>;
    final readable = date['readable'] as String? ?? '';

    String clean(String? raw) {
      if (raw == null) return '--:--';
      // Aladhan returns times like "04:12 (EET)" sometimes; strip timezone suffix.
      return raw.split(' ').first;
    }

    return PrayerTimes(
      fajr: clean(timings['Fajr']),
      dhuhr: clean(timings['Dhuhr']),
      asr: clean(timings['Asr']),
      maghrib: clean(timings['Maghrib']),
      isha: clean(timings['Isha']),
      sunrise: clean(timings['Sunrise']),
      dateReadable: readable,
    );
  }

  /// Returns a list of (name, time24hr) pairs in prayer order, for display/logic.
  List<MapEntry<String, String>> asOrderedList() {
    return [
      MapEntry('Fajr', fajr),
      MapEntry('Dhuhr', dhuhr),
      MapEntry('Asr', asr),
      MapEntry('Maghrib', maghrib),
      MapEntry('Isha', isha),
    ];
  }
}
