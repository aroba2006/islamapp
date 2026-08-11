import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/hijri_calendar_service.dart';
import '../models/islamic_event.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import '../services/theme_service.dart';

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  late int _year;
  late int _month;
  late int _currentDay;
  late int _currentYear;
  late int _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = HijriCalendarService.gregorianToHijri(DateTime.now());
    _year = now.year;
    _month = now.month;
    _currentDay = now.day;
    _currentYear = now.year;
    _currentMonth = now.month;
  }

  List<String> _getMonthNames(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic
        ? ['محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني', 'جمادى الأولى', 'جمادى الثانية',
           'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة']
        : ['Muharram', 'Safar', 'Rabi I', 'Rabi II', 'Jumada I', 'Jumada II',
           'Rajab', 'Sha\'ban', 'Ramadan', 'Shawwal', 'Dhu al-Qa\'dah', 'Dhu al-Hijjah'];
  }

  List<String> _getDayNames(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic
        ? ['أحد', 'إثن', 'ثلث', 'أرب', 'خميس', 'جمعة', 'سبت']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  }

  int _getFirstDayOfMonth(int year, int month) {
    final hijriDate = HijriDate(year: year, month: month, day: 1);
    final gregorian = hijriDate.toGregorian();
    return gregorian.weekday % 7;
  }

  int _getDaysInMonth(int year, int month) {
    if (month == 12) {
      final cycle = year % 30;
      const leapYears = [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29];
      return leapYears.contains(cycle) ? 30 : 29;
    }
    return month % 2 == 1 ? 30 : 29;
  }

  void _changeMonth(int delta) {
    setState(() {
      _month += delta;
      if (_month > 12) {
        _month = 1;
        _year++;
      } else if (_month < 1) {
        _month = 12;
        _year--;
      }
    });
  }

  void _goToToday() {
    final now = HijriCalendarService.gregorianToHijri(DateTime.now());
    setState(() {
      _year = now.year;
      _month = now.month;
      _currentDay = now.day;
      _currentYear = now.year;
      _currentMonth = now.month;
    });
  }

  void _showEventDetails(List<IslamicEvent> events, BuildContext context, ThemeService themeService) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          isArabic ? 'المناسبات الإسلامية' : 'Islamic Events',
          style: themeService.getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD4AF37),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: events.map((event) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.getName(isArabic ? 'ar' : 'en'),
                    style: themeService.getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (event.descriptionEn.isNotEmpty)
                    Text(
                      event.getDescription(isArabic ? 'ar' : 'en'),
                      style: themeService.getTextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  const Divider(color: Color(0xFFD4AF37), thickness: 0.5),
                ],
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.close,
              style: themeService.getTextStyle(
                fontSize: 14,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGregorianDateDialog(
    BuildContext context, 
    int day, 
    AppLocalizations l10n, 
    bool isArabic, 
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final gregorianDateStr = _getGregorianDate(_year, _month, day);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          isArabic ? 'التاريخ الميلادي' : 'Gregorian Date',
          style: themeService.getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD4AF37),
          ),
        ),
        content: Text(
          isArabic
              ? 'التاريخ الهجري: $day/$_month/$_year هـ\nالتاريخ الميلادي: $gregorianDateStr'
              : 'Hijri: $day/$_month/$_year AH\nGregorian: $gregorianDateStr',
          style: themeService.getTextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.close,
              style: themeService.getTextStyle(
                fontSize: 14,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGregorianDate(int year, int month, int day) {
    final hijriDate = HijriDate(year: year, month: month, day: day);
    final gregorian = hijriDate.toGregorian();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic
        ? '${gregorian.day}/${gregorian.month}/${gregorian.year}'
        : '${gregorian.month}/${gregorian.day}/${gregorian.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final monthNames = _getMonthNames(context);
    final dayNames = _getDayNames(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final daysInMonth = _getDaysInMonth(_year, _month);
    final firstDayOffset = _getFirstDayOfMonth(_year, _month);

    List<Widget> dayWidgets = [];

    for (int i = 0; i < firstDayOffset; i++) {
      dayWidgets.add(
        Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final isToday = (day == _currentDay && _month == _currentMonth && _year == _currentYear);
      final isCurrentMonth = (_month == _currentMonth && _year == _currentYear);
      final events = IslamicEventsService.getEventsOnDate(_month, day);
      final hasEvent = events.isNotEmpty;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            if (hasEvent) {
              _showEventDetails(events, context, context.read<ThemeService>());
            } else {
              _showGregorianDateDialog(
                context, 
                day, 
                l10n, 
                isArabic, 
                isDarkMode,
                context.read<ThemeService>(),
              );
            }
          },
          onLongPress: () => _showGregorianDateDialog(
            context, 
            day, 
            l10n, 
            isArabic, 
            isDarkMode,
            context.read<ThemeService>(),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isToday
                  ? const Color(0xFFD4AF37).withValues(alpha: 0.3)
                  : hasEvent
                      ? const Color(0xFFD4AF37).withValues(alpha: 0.15)
                      : (isDarkMode
                          ? Colors.grey.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.05)),
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(color: const Color(0xFFD4AF37), width: 2)
                  : hasEvent
                      ? Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), width: 1)
                      : Border.all(
                          color: isDarkMode
                              ? Colors.grey.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.15),
                          width: 1,
                        ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: context.read<ThemeService>().getTextStyle(
                    fontSize: 18,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? const Color(0xFFD4AF37)
                        : hasEvent
                            ? const Color(0xFFD4AF37)
                            : (isDarkMode
                                ? (isCurrentMonth ? Colors.white : Colors.grey[500])
                                : (isCurrentMonth ? Colors.black87 : Colors.grey[400])),
                  ),
                ),
                if (hasEvent)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.hijriCalendarTitle,
              style: themeService.getTextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFFD4AF37),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.today_rounded),
                onPressed: _goToToday,
                tooltip: isArabic ? 'اليوم' : 'Today',
              ),
            ],
          ),
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFFD4AF37)),
                            onPressed: () => _changeMonth(-1),
                            iconSize: 32,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<int>(
                              value: _month,
                              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                              style: themeService.getTextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFD4AF37),
                              ),
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4AF37)),
                              items: List.generate(12, (index) {
                                final monthIndex = index + 1;
                                return DropdownMenuItem<int>(
                                  value: monthIndex,
                                  child: Text(
                                    monthNames[index],
                                    style: themeService.getTextStyle(
                                      fontSize: 16,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _month = value);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<int>(
                              value: _year,
                              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                              style: themeService.getTextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFD4AF37),
                              ),
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4AF37)),
                              items: List.generate(30, (index) {
                                final yearValue = _year - 15 + index;
                                return DropdownMenuItem<int>(
                                  value: yearValue,
                                  child: Text(
                                    '$yearValue ${isArabic ? 'هـ' : 'AH'}',
                                    style: themeService.getTextStyle(
                                      fontSize: 16,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _year = value);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFFD4AF37)),
                            onPressed: () => _changeMonth(1),
                            iconSize: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${monthNames[_month - 1]} $_year ${isArabic ? 'هـ' : 'AH'}',
                      style: themeService.getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD4AF37),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: dayNames.map((d) =>
                        Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: themeService.getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? const Color(0xFFD4AF37) : Colors.black54,
                              ),
                            ),
                          ),
                        )
                      ).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 7,
                      childAspectRatio: 1.1,
                      padding: const EdgeInsets.all(8),
                      children: dayWidgets,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}