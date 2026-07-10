
class HijriDate {
  final int year;
  final int month;
  final int day;

  HijriDate({required this.year, required this.month, required this.day});

  @override
  String toString() => '$day/$month/$year H';

  /// Convert Hijri to Gregorian using arithmetic tabular calendar (Kuwaiti algorithm)
  DateTime toGregorian() {
    // Based on the arithmetic calendar with 30-year cycle
    // Each year: 354 or 355 days, leap years in cycle: 2,5,7,10,13,16,18,21,24,26,29
    int getDaysInYear(int y) {
      final cycle = y % 30;
      final leapYears = [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29];
      return leapYears.contains(cycle) ? 355 : 354;
    }

    // Calculate total days from Hijri epoch (1/1/1 AH) to given date
    int totalDays = 0;
    for (int y = 1; y < year; y++) {
      totalDays += getDaysInYear(y);
    }
    for (int m = 1; m < month; m++) {
      totalDays += (m % 2 == 1) ? 30 : 29; // odd months: 30, even: 29
    }
    totalDays += day - 1;

    // Julian Day of 1/1/1 AH = 1948439.5 (we use integer)
    // Add 0.5 to get noon, but we'll work with integers for day count.
    // Known reference: 1 Muharram 1443 AH = 9 August 2021 (Julian Day 2459451)
    // So we can compute using difference.
    const refHijriYear = 1443;
    const refHijriMonth = 1;
    const refHijriDay = 1;
    const refJulianDay = 2459436; // Julian Day for 9 Aug 2021

    // Compute days from 1/1/1 to reference
    int refTotalDays = 0;
    for (int y = 1; y < refHijriYear; y++) {
      refTotalDays += getDaysInYear(y);
    }
    for (int m = 1; m < refHijriMonth; m++) {
      refTotalDays += (m % 2 == 1) ? 30 : 29;
    }
    refTotalDays += refHijriDay - 1;

    // Now difference from ref to target
    final targetTotalDays = totalDays;
    final diffDays = targetTotalDays - refTotalDays;
    final julianDay = refJulianDay + diffDays;

    // Convert Julian Day to Gregorian DateTime
    return _julianDayToGregorian(julianDay);
  }

  /// Days until this Hijri date from today (non-negative)
  int daysUntil() {
    final target = toGregorian();
    final now = DateTime.now();
    if (target.isAfter(now) || target.isAtSameMomentAs(now)) {
      return target.difference(now).inDays;
    }
    // If past, try next year
    final nextYear = HijriDate(year: year + 1, month: month, day: day);
    return nextYear.toGregorian().difference(now).inDays;
  }

  // ---- Helper conversion from Julian Day to DateTime ----
  static DateTime _julianDayToGregorian(int jd) {
    final a = jd + 32044;
    final b = (4 * a + 3) ~/ 146097;
    final c = a - (146097 * b ~/ 4);
    final d = (4 * c + 3) ~/ 1461;
    final e = c - (1461 * d ~/ 4);
    final m = (5 * e + 2) ~/ 153;
    final day = e - (153 * m + 2) ~/ 5 + 1;
    final month = m + 3 - 12 * (m ~/ 10);
    final year = 100 * b + d - 4800 + (m ~/ 10);
    return DateTime(year, month, day);
  }
}

class HijriCalendarService {
  /// Convert Gregorian DateTime to Hijri (approximate)
  static HijriDate gregorianToHijri(DateTime date) {
    // Use a known reference: 1 Muharram 1443 AH = 9 August 2021
    const refHijriYear = 1443;
    const refHijriMonth = 1;
    const refHijriDay = 1;
    const refJulianDay = 2459436; // Julian Day for 9 Aug 2021

    final julianDay = _gregorianToJulianDay(date.year, date.month, date.day);
    final diffDays = julianDay - refJulianDay;

    // Compute Hijri date by iteratively subtracting days per year/month
    int hijriYear = refHijriYear;
    int hijriMonth = refHijriMonth;
    int hijriDay = refHijriDay + diffDays;

    // Adjust to the correct year/month/day
    while (hijriDay > 0) {
      // Get days in current Hijri year
      int daysInYear = _isLeapYear(hijriYear) ? 355 : 354;
      if (hijriDay <= daysInYear) {
        // Now find month
        int monthDays;
        for (int m = 1; m <= 12; m++) {
          monthDays = (m % 2 == 1) ? 30 : 29;
          if (hijriDay <= monthDays) {
            hijriMonth = m;
            hijriDay = hijriDay.toInt();
            break;
          }
          hijriDay -= monthDays;
        }
        break;
      }
      hijriDay -= daysInYear;
      hijriYear++;
    }

    return HijriDate(
      year: hijriYear,
      month: hijriMonth,
      day: hijriDay.toInt(),
    );
  }

  static bool _isLeapYear(int year) {
    final cycle = year % 30;
    const leapYears = [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29];
    return leapYears.contains(cycle);
  }

  /// Get next occurrence of a given Hijri date (month/day) as DateTime
  static DateTime getNextHijriDate(int hijriMonth, int hijriDay) {
    final now = DateTime.now();
    final hijriNow = gregorianToHijri(now);

    // Try this year
    var target = HijriDate(
      year: hijriNow.year,
      month: hijriMonth,
      day: hijriDay,
    );
    var targetGreg = target.toGregorian();

    if (targetGreg.isAfter(now) || targetGreg.isAtSameMomentAs(now)) {
      return targetGreg;
    }

    // Try next year
    target = HijriDate(
      year: hijriNow.year + 1,
      month: hijriMonth,
      day: hijriDay,
    );
    return target.toGregorian();
  }

  static bool isCurrentlyRamadan() {
    final hijri = gregorianToHijri(DateTime.now());
    return hijri.month == 9;
  }

  static int daysUntilRamadan() {
    final now = DateTime.now();
    final hijriNow = gregorianToHijri(now);
    if (hijriNow.month < 9 || (hijriNow.month == 9 && hijriNow.day < 1)) {
      final start = HijriDate(year: hijriNow.year, month: 9, day: 1);
      return start.daysUntil();
    } else {
      final start = HijriDate(year: hijriNow.year + 1, month: 9, day: 1);
      return start.daysUntil();
    }
  }

  static int _gregorianToJulianDay(int year, int month, int day) {
    final a = (14 - month) ~/ 12;
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    return day + ((153 * m + 2) ~/ 5) + 365 * y + (y ~/ 4) - (y ~/ 100) + (y ~/ 400) - 32045;
  }
}