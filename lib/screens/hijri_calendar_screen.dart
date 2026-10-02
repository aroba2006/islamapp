import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/hijri_calendar_service.dart';
import '../models/islamic_event.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import '../services/theme_service.dart';
import '../app_theme.dart';

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen>
    with SingleTickerProviderStateMixin {
  late int _year;
  late int _month;
  late int _currentDay;
  late int _currentYear;
  late int _currentMonth;

  late AnimationController _entranceCtrl;
  bool _monthChanged = false;

  @override
  void initState() {
    super.initState();
    final now = HijriCalendarService.gregorianToHijri(DateTime.now());
    _year = now.year;
    _month = now.month;
    _currentDay = now.day;
    _currentYear = now.year;
    _currentMonth = now.month;

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // DATA HELPERS
  // ─────────────────────────────────────────────────────────────
  List<String> _getMonthNames(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    if (langCode == 'ar') {
      return [
        'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني', 'جمادى الأولى', 'جمادى الثانية',
        'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
      ];
    } else if (langCode == 'fr') {
      return [
        'Muharram', 'Safar', 'Rabi I', 'Rabi II', 'Jumada I', 'Jumada II',
        'Rajab', 'Sha\'ban', 'Ramadan', 'Shawwal', 'Dhu al-Qa\'dah', 'Dhu al-Hijjah'
      ];
    }
    return [
      'Muharram', 'Safar', 'Rabi I', 'Rabi II', 'Jumada I', 'Jumada II',
      'Rajab', 'Sha\'ban', 'Ramadan', 'Shawwal', 'Dhu al-Qa\'dah', 'Dhu al-Hijjah'
    ];
  }

  List<String> _getDayNames(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    if (langCode == 'ar') {
      return ['أحد', 'إثن', 'ثلث', 'أرب', 'خميس', 'جمعة', 'سبت'];
    } else if (langCode == 'fr') {
      return ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
    }
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  }

  int _getFirstDayOfMonth(int year, int month) {
    final hijriDate = HijriDate(year: year, month: month, day: 1);
    final gregorian = hijriDate.toGregorian();
    return gregorian.weekday % 7;
  }

  void _changeMonth(int delta) {
    setState(() {
      _monthChanged = true;
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

  // ─────────────────────────────────────────────────────────────
  // EVENT DIALOG
  // ─────────────────────────────────────────────────────────────
  void _showEventDetails(
    List<IslamicEvent> events,
    BuildContext context,
    ThemeService themeService,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    final isArabic = langCode == 'ar';
    final onBg = AppTheme.getOnBackgroundColor(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.celebration_rounded,
                color: Color(0xFFD4AF37), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isArabic
                    ? 'المناسبات الإسلامية'
                    : (langCode == 'fr'
                        ? 'Événements Islamiques'
                        : 'Islamic Events'),
                style: themeService.getTextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: events.map((event) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.getName(langCode),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    if (event.getDescription(langCode).isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.getDescription(langCode),
                        style: TextStyle(
                          fontSize: 13,
                          color: onBg.withValues(alpha: 0.75),
                          height: 1.45,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Divider(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
                      thickness: 0.6,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.close,
              style: themeService.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // GREGORIAN DIALOG
  // ─────────────────────────────────────────────────────────────
  void _showGregorianDateDialog(
    BuildContext context,
    int day,
    AppLocalizations l10n,
    bool isArabic,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final gregorianDateStr = _getGregorianDate(_year, _month, day);
    final langCode = Localizations.localeOf(context).languageCode;
    final onBg = AppTheme.getOnBackgroundColor(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                color: Color(0xFFD4AF37), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isArabic
                    ? 'تفاصيل التاريخ'
                    : (langCode == 'fr'
                        ? 'Détails de la date'
                        : 'Date Details'),
                style: themeService.getTextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dialogInfoRow(
              context: context,
              icon: Icons.nightlight_round,
              label: isArabic
                  ? 'التاريخ الهجري'
                  : (langCode == 'fr' ? 'Date Hégirienne' : 'Hijri Date'),
              value: isArabic
                  ? '$day/$_month/$_year هـ'
                  : (langCode == 'fr'
                      ? '$day/$_month/$_year AH'
                      : '$day/$_month/$_year AH'),
              onBg: onBg,
            ),
            const SizedBox(height: 10),
            _dialogInfoRow(
              context: context,
              icon: Icons.event_rounded,
              label: isArabic
                  ? 'التاريخ الميلادي'
                  : (langCode == 'fr'
                      ? 'Date Grégorienne'
                      : 'Gregorian Date'),
              value: gregorianDateStr,
              onBg: onBg,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.close,
              style: themeService.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color onBg,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFFD4AF37)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: onBg.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: onBg.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ],
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

  // ─────────────────────────────────────────────────────────────
  // HERO MEDALLION
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeroMedallion() {
    const gold = Color(0xFFD4AF37);
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    gold.withValues(alpha: 0.28),
                    gold.withValues(alpha: 0.0),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: gold.withValues(alpha: 0.35),
                  width: 1.2,
                ),
              ),
            ),
            Container(
              width: 106,
              height: 106,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: gold.withValues(alpha: 0.55),
                  width: 1.5,
                ),
              ),
            ),
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    gold.withValues(alpha: 0.30),
                    gold.withValues(alpha: 0.06),
                  ],
                ),
                border: Border.all(
                  color: gold.withValues(alpha: 0.85),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gold.withValues(alpha: 0.28),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: gold,
                size: 40,
              ),
            ),
            Positioned(
              top: 10,
              right: 18,
              child: Icon(
                Icons.star_rounded,
                size: 13,
                color: gold.withValues(alpha: 0.9),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 16,
              child: Icon(
                Icons.star_rounded,
                size: 10,
                color: gold.withValues(alpha: 0.75),
              ),
            ),
            Positioned(
              top: 16,
              left: 20,
              child: Icon(
                Icons.nightlight_round,
                size: 13,
                color: gold.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HERO SECTION
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeroSection(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    ThemeService themeService,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    final String title = isArabic
        ? 'التقويم الهجري'
        : (isFrench ? 'Calendrier Hégirien' : 'Hijri Calendar');

    final String subtitle = isArabic
        ? 'تابع الأشهر الهجرية والمناسبات الإسلامية، وتعرّف على التاريخ الهجري لكل يوم من أيام السنة.'
        : (isFrench
            ? 'Suivez les mois hégiriens et les événements islamiques, et découvrez la date hégirienne de chaque jour.'
            : 'Follow the Hijri months and Islamic events, and discover the Hijri date for every day of the year.');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildHeroMedallion(),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: themeService.getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: gold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onBg.withValues(alpha: 0.68),
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STATS ROW
  // ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    int daysInMonth,
    int eventsCount,
  ) {
    const gold = Color(0xFFD4AF37);

    final String todayLabel = isArabic
        ? 'اليوم'
        : (isFrench ? 'Aujourd\'hui' : 'Today');
    final String eventsLabel = isArabic
        ? 'مناسبات'
        : (isFrench ? 'Événements' : 'Events');
    final String daysLabel = isArabic
        ? 'يوم'
        : (isFrench ? 'Jours' : 'Days');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: _buildStatChip(
              context: context,
              icon: Icons.today_rounded,
              label: todayLabel,
              value: '$_currentDay / $_currentMonth',
              gold: gold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatChip(
              context: context,
              icon: Icons.celebration_rounded,
              label: eventsLabel,
              value: '$eventsCount',
              gold: gold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatChip(
              context: context,
              icon: Icons.calendar_view_month_rounded,
              label: daysLabel,
              value: '$daysInMonth',
              gold: gold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color gold,
  }) {
    final onBg = AppTheme.getOnBackgroundColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gold.withValues(alpha: 0.12),
            gold.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: gold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: gold, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: gold,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: onBg.withValues(alpha: 0.6),
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // INFO BANNER
  // ─────────────────────────────────────────────────────────────
  Widget _buildInfoBanner(
    BuildContext context,
    bool isArabic,
    bool isFrench,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    final String heading = isArabic
        ? 'ما هو التقويم الهجري؟'
        : (isFrench
            ? 'Qu\'est-ce que le calendrier hégirien ?'
            : 'What is the Hijri calendar?');

    final String body = isArabic
        ? 'التقويم الهجري هو التقويم القمري الذي يعتمد على دورة القمر، ويُستخدم لتحديد الأشهر الإسلامية مثل رمضان وذو الحجة. السنة الهجرية أقصر من الميلادية بنحو 11 يوماً.'
        : (isFrench
            ? 'Le calendrier hégirien est un calendrier lunaire basé sur le cycle de la lune, utilisé pour déterminer les mois islamiques comme Ramadan et Dhu al-Hijjah. Il est environ 11 jours plus court que l\'année grégorienne.'
            : 'The Hijri calendar is a lunar calendar based on the moon\'s cycle, used to determine Islamic months like Ramadan and Dhu al-Hijjah. It is roughly 11 days shorter than the Gregorian year.');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gold.withValues(alpha: 0.10),
              gold.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: gold.withValues(alpha: 0.30), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gold.withValues(alpha: 0.18),
                border: Border.all(
                  color: gold.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: gold,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: TextStyle(
                      color: onBg.withValues(alpha: 0.72),
                      fontSize: 12.5,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // MONTH NAVIGATOR (FIXED OVERFLOW)
  // ─────────────────────────────────────────────────────────────
  Widget _buildMonthNavigator(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    ThemeService themeService,
    List<String> monthNames,
  ) {
    const gold = Color(0xFFD4AF37);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gold.withValues(alpha: 0.08),
              gold.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: gold.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Prev
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, color: gold),
              onPressed: () => _changeMonth(-1),
              iconSize: 28,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              tooltip: isArabic
                  ? 'الشهر السابق'
                  : (isFrench ? 'Mois précédent' : 'Previous month'),
            ),
            const SizedBox(width: 4),

            // Month dropdown
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: gold.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _month,
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  style: themeService.getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: gold),
                  items: List.generate(12, (index) {
                    final monthIndex = index + 1;
                    return DropdownMenuItem<int>(
                      value: monthIndex,
                      child: Text(
                        monthNames[index],
                        overflow: TextOverflow.ellipsis,
                        style: themeService.getTextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _monthChanged = true;
                        _month = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Year dropdown
            Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: gold.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _year,
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  style: themeService.getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: gold),
                  items: List.generate(30, (index) {
                    final yearValue = _year - 15 + index;
                    return DropdownMenuItem<int>(
                      value: yearValue,
                      child: Text(
                        '$yearValue ${isArabic ? 'هـ' : 'AH'}',
                        overflow: TextOverflow.ellipsis,
                        style: themeService.getTextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _monthChanged = true;
                        _year = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Next
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, color: gold),
              onPressed: () => _changeMonth(1),
              iconSize: 28,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              tooltip: isArabic
                  ? 'الشهر التالي'
                  : (isFrench ? 'Mois suivant' : 'Next month'),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // MONTH TITLE
  // ─────────────────────────────────────────────────────────────
  Widget _buildMonthTitle(
    BuildContext context,
    bool isArabic,
    List<String> monthNames,
    ThemeService themeService,
  ) {
    const gold = Color(0xFFD4AF37);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: gold.withValues(alpha: 0.35)),
        ),
        child: Text(
          '${monthNames[_month - 1]} $_year ${isArabic ? 'هـ' : 'AH'}',
          style: themeService.getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: gold,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // WEEKDAY HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _buildWeekdayHeader(
    BuildContext context,
    List<String> dayNames,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    const gold = Color(0xFFD4AF37);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dayNames
            .map(
              (d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: themeService.getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? gold : Colors.black54,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // LEGEND
  // ─────────────────────────────────────────────────────────────
  Widget _buildLegend(
    BuildContext context,
    bool isArabic,
    bool isFrench,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    final items = [
      {
        'color': gold.withValues(alpha: 0.35),
        'border': gold,
        'label': isArabic ? 'اليوم' : (isFrench ? 'Aujourd\'hui' : 'Today'),
      },
      {
        'color': gold.withValues(alpha: 0.15),
        'border': gold.withValues(alpha: 0.6),
        'label': isArabic
            ? 'مناسبة'
            : (isFrench ? 'Événement' : 'Event'),
      },
      {
        'color': onBg.withValues(alpha: 0.08),
        'border': onBg.withValues(alpha: 0.25),
        'label': isArabic ? 'يوم عادي' : (isFrench ? 'Normal' : 'Normal'),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Wrap(
        spacing: 14,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: items.map((item) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: item['border'] as Color,
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                item['label'] as String,
                style: TextStyle(
                  color: onBg.withValues(alpha: 0.65),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // EVENTS LIST FOR CURRENT MONTH
  // ─────────────────────────────────────────────────────────────
  Widget _buildEventsThisMonth(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    ThemeService themeService,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);
    final langCode = Localizations.localeOf(context).languageCode;

    // Collect all events in the displayed month
    final List<IslamicEvent> monthEvents = [];
    final daysInMonth = HijriCalendarService.getDaysInMonth(_year, _month);
    for (int d = 1; d <= daysInMonth; d++) {
      final evts = IslamicEventsService.getEventsOnDate(_month, d);
      monthEvents.addAll(evts);
    }

    if (monthEvents.isEmpty) return const SizedBox.shrink();

    final String heading = isArabic
        ? 'مناسبات هذا الشهر'
        : (isFrench ? 'Événements du mois' : 'Events this month');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      gold.withValues(alpha: 0.28),
                      gold.withValues(alpha: 0.06),
                    ],
                  ),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.45),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.event_note_rounded,
                  color: gold,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${monthEvents.length}',
                  style: const TextStyle(
                    color: gold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...monthEvents.map(
            (event) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gold.withValues(alpha: 0.10),
                    gold.withValues(alpha: 0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: gold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gold.withValues(alpha: 0.18),
                      border: Border.all(
                        color: gold.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: gold,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.getName(langCode),
                          style: const TextStyle(
                            color: gold,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (event.getDescription(langCode).isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            event.getDescription(langCode),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: onBg.withValues(alpha: 0.65),
                              fontSize: 11.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '${event.hijriDay}',
                    style: TextStyle(
                      color: gold.withValues(alpha: 0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // FOOTER
  // ─────────────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext context, bool isArabic, bool isFrench) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _gradientLine()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.favorite_rounded,
                  size: 14,
                  color: gold.withValues(alpha: 0.8),
                ),
              ),
              Expanded(child: _gradientLine()),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isArabic
                ? 'تقبّل الله منا ومنكم صالح الأعمال'
                : (isFrench
                    ? 'Qu\'Allah accepte nos bonnes actions'
                    : 'May Allah accept our good deeds'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: gold,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isArabic
                ? 'اضغط على أي يوم لمعرفة تاريخه الميلادي ومناسباته'
                : (isFrench
                    ? 'Appuyez sur un jour pour voir sa date grégorienne'
                    : 'Tap any day to see its Gregorian date and events'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: onBg.withValues(alpha: 0.5),
              fontSize: 11,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientLine() {
    return Container(
      height: 1.2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD4AF37).withValues(alpha: 0),
            const Color(0xFFD4AF37).withValues(alpha: 0.45),
            const Color(0xFFD4AF37).withValues(alpha: 0),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    final isArabic = langCode == 'ar';
    final isFrench = langCode == 'fr';
    final monthNames = _getMonthNames(context);
    final dayNames = _getDayNames(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final daysInMonth = HijriCalendarService.getDaysInMonth(_year, _month);
    final firstDayOffset = _getFirstDayOfMonth(_year, _month);

    // Count events in the current month for the stats chip
    int eventsInMonth = 0;
    for (int d = 1; d <= daysInMonth; d++) {
      eventsInMonth += IslamicEventsService.getEventsOnDate(_month, d).length;
    }

    List<Widget> dayWidgets = [];

    for (int i = 0; i < firstDayOffset; i++) {
      dayWidgets.add(
        Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final isToday =
          (day == _currentDay && _month == _currentMonth && _year == _currentYear);
      final isCurrentMonth =
          (_month == _currentMonth && _year == _currentYear);
      final events = IslamicEventsService.getEventsOnDate(_month, day);
      final hasEvent = events.isNotEmpty;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            if (hasEvent) {
              _showEventDetails(
                  events, context, context.read<ThemeService>());
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
              borderRadius: BorderRadius.circular(10),
              border: isToday
                  ? Border.all(color: const Color(0xFFD4AF37), width: 2)
                  : hasEvent
                      ? Border.all(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.5),
                          width: 1,
                        )
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
                        fontSize: 17,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday
                            ? const Color(0xFFD4AF37)
                            : hasEvent
                                ? const Color(0xFFD4AF37)
                                : (isDarkMode
                                    ? (isCurrentMonth
                                        ? Colors.white
                                        : Colors.grey[500])
                                    : (isCurrentMonth
                                        ? Colors.black87
                                        : Colors.grey[400])),
                      ),
                ),
                if (hasEvent)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 5,
                    height: 5,
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFFD4AF37),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: Color(0xFFD4AF37)),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.today_rounded,
                    color: Color(0xFFD4AF37)),
                onPressed: _goToToday,
                tooltip: isArabic
                    ? 'اليوم'
                    : (isFrench ? 'Aujourd\'hui' : 'Today'),
              ),
            ],
          ),
          body: IslamicPatternBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    // Hero + info + stats wrapped in entrance fade
                    FadeTransition(
                      opacity: _entranceCtrl,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.05),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _entranceCtrl,
                          curve: Curves.easeOutCubic,
                        )),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _buildHeroSection(
                              context,
                              isArabic,
                              isFrench,
                              themeService,
                            ),
                            const SizedBox(height: 12),
                            _buildStatsRow(
                              context,
                              isArabic,
                              isFrench,
                              daysInMonth,
                              eventsInMonth,
                            ),
                            _buildInfoBanner(context, isArabic, isFrench),
                          ],
                        ),
                      ),
                    ),

                    // Month navigator
                    _buildMonthNavigator(
                      context,
                      isArabic,
                      isFrench,
                      isDarkMode,
                      themeService,
                      monthNames,
                    ),

                    const SizedBox(height: 6),
                    _buildMonthTitle(
                      context,
                      isArabic,
                      monthNames,
                      themeService,
                    ),
                    const SizedBox(height: 12),
                    _buildWeekdayHeader(
                      context,
                      dayNames,
                      isDarkMode,
                      themeService,
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color:
                            const Color(0xFFD4AF37).withValues(alpha: 0.25),
                        thickness: 1,
                      ),
                    ),

                    // Calendar grid — animated in on month change
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 380),
                      transitionBuilder: (child, animation) {
                        final curved = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        );
                        return FadeTransition(
                          opacity: curved,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.02, 0),
                              end: Offset.zero,
                            ).animate(curved),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        key: ValueKey('$_year-$_month'),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 7,
                          childAspectRatio: 1.0,
                          padding: const EdgeInsets.all(8),
                          children: dayWidgets,
                        ),
                      ),
                    ),

                    // Legend
                    _buildLegend(context, isArabic, isFrench),

                    // Events list for current month
                    _buildEventsThisMonth(
                      context,
                      isArabic,
                      isFrench,
                      themeService,
                    ),

                    // Footer
                    _buildFooter(context, isArabic, isFrench),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}