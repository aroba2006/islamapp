import 'package:hijri/hijri_calendar.dart';

class HijriDate {
  final int year;
  final int month;
  final int day;

  HijriDate({required this.year, required this.month, required this.day});

  @override
  String toString() => '$day/$month/$year H';

  DateTime toGregorian() {
    final h = HijriCalendar();
    return h.hijriToGregorian(year, month, day);
  }

  int daysUntil() {
    final target = toGregorian();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (target.isAfter(today) || target.isAtSameMomentAs(today)) {
      return target.difference(today).inDays;
    }
    final nextYear = HijriDate(year: year + 1, month: month, day: day);
    return nextYear.toGregorian().difference(today).inDays;
  }
}

class HijriCalendarService {
  // Reset back to 0. The Umm al-Qura database is extremely accurate out of the box!
  // You can still change this to 1 or -1 later if your local country differs from Saudi Arabia.
  static int hijriAdjustment = 0;

  static HijriDate gregorianToHijri(DateTime date) {
    final adjustedDate = date.add(Duration(days: hijriAdjustment));
    final hDate = HijriCalendar.fromDate(adjustedDate);
    return HijriDate(year: hDate.hYear, month: hDate.hMonth, day: hDate.hDay);
  }

  static DateTime getNextHijriDate(int hijriMonth, int hijriDay) {
    final now = DateTime.now();
    final hijriNow = gregorianToHijri(now);

    var target = HijriDate(year: hijriNow.year, month: hijriMonth, day: hijriDay);
    var targetGreg = target.toGregorian();

    if (targetGreg.isAfter(now) || targetGreg.isAtSameMomentAs(now)) {
      return targetGreg;
    }

    target = HijriDate(year: hijriNow.year + 1, month: hijriMonth, day: hijriDay);
    return target.toGregorian();
  }

  static bool isCurrentlyRamadan() {
    return gregorianToHijri(DateTime.now()).month == 9;
  }

  static int daysUntilRamadan() {
    final now = DateTime.now();
    final hijriNow = gregorianToHijri(now);
    if (hijriNow.month < 9 || (hijriNow.month == 9 && hijriNow.day < 1)) {
      return HijriDate(year: hijriNow.year, month: 9, day: 1).daysUntil();
    } else {
      return HijriDate(year: hijriNow.year + 1, month: 9, day: 1).daysUntil();
    }
  }

  // Gets the exact historical/future length of any month based on moon sightings
  static int getDaysInMonth(int year, int month) {
    // 100% safe calculation: Difference between the 1st of this month and 1st of next month
    final h = HijriCalendar();
    
    final start = h.hijriToGregorian(year, month, 1);
    
    final nextYear = month == 12 ? year + 1 : year;
    final nextMonth = month == 12 ? 1 : month + 1;
    final end = h.hijriToGregorian(nextYear, nextMonth, 1);
    
    return end.difference(start).inDays;
  }
}