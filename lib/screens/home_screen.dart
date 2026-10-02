import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../widgets/outlined_text_widget.dart';
import '../l10n/app_localizations.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../services/auth_service.dart';
import 'login_signup_screen.dart';
import 'country_selection_screen.dart';
import 'azkar_screen.dart';
import 'settings_screen.dart';
import 'quran_screen.dart';
import 'duaa_screen.dart';
import 'good_deeds_screen.dart';
import 'islamic_goals_screen.dart';
import 'qiblah_finder_screen.dart';
import 'mosque_finder_screen.dart';
import 'quiz_screen.dart';
import 'prophet_biography_screen.dart';
import 'hadiths_screen.dart';
import 'ramadan_mode_screen.dart';
import 'hijri_calendar_screen.dart';
import 'ai_question_answer_screen.dart';
import '../services/hijri_calendar_service.dart';
import '../models/islamic_event.dart';
import 'teach_screen.dart';

import 'dart:async';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/prayer_times.dart';
import '../services/prayer_times_service.dart';
import 'prayer_times_screen.dart';
import '../models/country_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _logoFloatCtrl;
  late AnimationController _ringRotateCtrl;
  late AnimationController _badgePulseCtrl;

  late bool _isRamadan;
  late int _ramadanCountdown;

  // Upcoming prayer state
  String? _currentCity;
  String? _currentCountry;
  String? _nextPrayerName;
  String? _nextPrayerTimeFormatted;
  Duration? _timeRemaining;
  bool _loadingPrayer = true;
  Timer? _countdownTimer;
  PrayerTimes? _prayerTimes;

  @override
void initState() {
  super.initState();
  _fadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();

  _logoFloatCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);

  _ringRotateCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 28),
  )..repeat();

  _badgePulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);

  _updateIslamicInfo();
  _initLocationAndPrayers();
}

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _fadeCtrl.dispose();
    _logoFloatCtrl.dispose();
    _ringRotateCtrl.dispose();
    _badgePulseCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // LOCATION + PRAYER LOGIC
  // ─────────────────────────────────────────────────────────────
  Future<void> _initLocationAndPrayers() async {
    setState(() => _loadingPrayer = true);

    String city = 'Cairo';
    String country = 'Egypt';

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 5),
        );

        try {
          final placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            city = place.locality?.isNotEmpty == true
                ? place.locality!
                : (place.subAdministrativeArea ?? 'Cairo');
            country = place.country ?? 'Egypt';
          }
        } catch (e) {
          debugPrint("Geocoding failed (Web fallback active): $e");
        }
      }
    } catch (e) {
      debugPrint("Location access failed: $e. Falling back to default.");
    }

    try {
      final times = await PrayerTimesService.fetchByCity(
        city: city,
        country: country,
      );

      if (!mounted) return;
      setState(() {
        _currentCity = city;
        _currentCountry = country;
        _prayerTimes = times;
        _loadingPrayer = false;
      });

      _calculateNextPrayer();
      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _calculateNextPrayer(),
      );
    } catch (e) {
      debugPrint("Prayer API Error: $e");
      if (mounted) setState(() => _loadingPrayer = false);
    }
  }

  void _calculateNextPrayer() {
    if (_prayerTimes == null) return;
    final now = DateTime.now();
    final entries = _prayerTimes!.asOrderedList();

    DateTime? parseToday(String hhmm) {
      final cleanTime = hhmm.split(' ')[0];
      final parts = cleanTime.split(':');
      if (parts.length != 2) return null;
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null) return null;
      return DateTime(now.year, now.month, now.day, h, m);
    }

    DateTime? nextTime;
    String? nextName;
    String? rawTime;

    for (final entry in entries) {
      final dt = parseToday(entry.value);
      if (dt == null) continue;
      if (dt.isAfter(now)) {
        nextTime = dt;
        nextName = entry.key;
        rawTime = entry.value;
        break;
      }
    }

    if (nextTime == null && entries.isNotEmpty) {
      final fajrDt = parseToday(entries.first.value);
      if (fajrDt != null) {
        nextTime = fajrDt.add(const Duration(days: 1));
        nextName = entries.first.key;
        rawTime = entries.first.value;
      }
    }

    if (nextTime != null && mounted) {
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      final cleanTime = (rawTime ?? '').split(' ')[0];
      final parts = cleanTime.split(':');
      String formattedTime = cleanTime;

      if (parts.length == 2) {
        int h = int.tryParse(parts[0]) ?? 0;
        final m = parts[1];
        final isPm = h >= 12;
        if (h > 12) h -= 12;
        if (h == 0) h = 12;
        final amPm = isAr ? (isPm ? 'م' : 'ص') : (isPm ? 'PM' : 'AM');
        formattedTime = '${h.toString().padLeft(2, '0')}:$m $amPm';
      }

      setState(() {
        _nextPrayerName = nextName;
        _nextPrayerTimeFormatted = formattedTime;
        _timeRemaining = nextTime!.difference(now);
      });
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m ${s}s';
  }

  String _getPrayerLabel(String? name, String langCode) {
    if (name == null) return '--';
    final isAr = langCode == 'ar';
    final isFr = langCode == 'fr';
    switch (name.toLowerCase()) {
      case 'fajr':
        return isAr ? 'الفجر' : (isFr ? 'Fajr' : 'Fajr');
      case 'dhuhr':
        return isAr ? 'الظهر' : (isFr ? 'Dhuhr' : 'Dhuhr');
      case 'asr':
        return isAr ? 'العصر' : (isFr ? 'Asr' : 'Asr');
      case 'maghrib':
        return isAr ? 'المغرب' : (isFr ? 'Maghrib' : 'Maghrib');
      case 'isha':
        return isAr ? 'العشاء' : (isFr ? 'Icha' : 'Isha');
      default:
        return name;
    }
  }

  IconData _iconForPrayer(String? prayer) {
    switch (prayer?.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight_rounded;
      case 'dhuhr':
        return Icons.wb_sunny_rounded;
      case 'asr':
        return Icons.filter_drama_rounded;
      case 'maghrib':
        return Icons.brightness_medium_rounded;
      case 'isha':
        return Icons.nightlight_round;
      default:
        return Icons.access_time_filled;
    }
  }

  void _updateIslamicInfo() {
    setState(() {
      _isRamadan = HijriCalendarService.isCurrentlyRamadan();
      _ramadanCountdown = HijriCalendarService.daysUntilRamadan();
    });
  }

  String _getHijriDateString(BuildContext context) {
    final hijri = HijriCalendarService.gregorianToHijri(DateTime.now());
    final langCode = Localizations.localeOf(context).languageCode;
    final isArabic = langCode == 'ar';

    final monthNamesAr = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
      'جمادى الأول', 'جمادى الثاني', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
    ];
    final monthNamesEn = [
      'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
      'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Sha\'ban',
      'Ramadan', 'Shawwal', 'Dhu al-Qa\'dah', 'Dhu al-Hijjah'
    ];

    final monthNames = isArabic ? monthNamesAr : monthNamesEn;
    if (isArabic) {
      return '${hijri.day} ${monthNames[hijri.month - 1]} ${hijri.year} هـ';
    } else {
      return '${monthNames[hijri.month - 1]} ${hijri.day}, ${hijri.year} AH';
    }
  }

  // ─────────────────────────────────────────────────────────────
  // HERO LOGO (animated)
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeroLogo(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_logoFloatCtrl, _ringRotateCtrl]),
        builder: (context, _) {
          final floatY = -3 + (_logoFloatCtrl.value * 6);
          final pulse = 0.85 + (_logoFloatCtrl.value * 0.15);

          return Transform.translate(
            offset: Offset(0, floatY),
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow (pulsing with float)
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFD4AF37)
                              .withValues(alpha: 0.28 * pulse),
                          const Color(0xFFD4AF37).withValues(alpha: 0.0),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                  // Outer ring
                  Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            const Color(0xFFD4AF37).withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                  ),
                  // Middle ring
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            const Color(0xFFD4AF37).withValues(alpha: 0.55),
                        width: 1.5,
                      ),
                    ),
                  ),
                  // Inner medallion (glow pulse)
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFD4AF37).withValues(alpha: 0.32),
                          const Color(0xFFD4AF37).withValues(alpha: 0.08),
                        ],
                      ),
                      border: Border.all(
                        color:
                            const Color(0xFFD4AF37).withValues(alpha: 0.85),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.22 * pulse),
                          blurRadius: 22 + (pulse * 8),
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFFD4AF37),
                      size: 42,
                    ),
                  ),
                  // Orbiting decorative stars
                  Transform.rotate(
                    angle: _ringRotateCtrl.value * 2 * math.pi,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(52, -52),
                          child: Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.9),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-54, 50),
                          child: Icon(
                            Icons.star_rounded,
                            size: 11,
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.75),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-48, -50),
                          child: Icon(
                            Icons.nightlight_round,
                            size: 13,
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _buildSectionHeader({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final onBg = AppTheme.getOnBackgroundColor(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD4AF37).withValues(alpha: 0.28),
                      const Color(0xFFD4AF37).withValues(alpha: 0.06),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.45),
                    width: 1.2,
                  ),
                ),
                child: Icon(icon, color: const Color(0xFFD4AF37), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Container(
                height: 1.2,
                width: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD4AF37).withValues(alpha: 0.0),
                      const Color(0xFFD4AF37).withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 42, right: 4),
            child: Text(
              subtitle,
              style: TextStyle(
                color: onBg.withValues(alpha: 0.6),
                fontSize: 12,
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // UPCOMING PRAYER CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildUpcomingPrayerCard(BuildContext context, String langCode) {
    if (_loadingPrayer) {
      return Container(
        height: 92,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              langCode == 'ar'
                  ? 'جارٍ تحديد الصلاة القادمة...'
                  : (langCode == 'fr'
                      ? 'Détermination de la prochaine prière...'
                      : 'Determining the next prayer...'),
              style: TextStyle(
                fontSize: 11.5,
                color: AppTheme.getOnBackgroundColor(context)
                    .withValues(alpha: 0.55),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_nextPrayerName == null) return const SizedBox.shrink();

    final isAr = langCode == 'ar';
    final isFr = langCode == 'fr';

    final labelText = isAr
        ? 'الصلاة القادمة'
        : (isFr ? 'Prochaine prière' : 'Next Prayer');
    final remainingText = isAr
        ? 'متبقٍ'
        : (isFr ? 'Restant' : 'Remaining');
    final tapHint = isAr
        ? 'اضغط لعرض كل أوقات الصلاة'
        : (isFr
            ? 'Appuyez pour tous les horaires'
            : 'Tap to view all prayer times');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            if (_currentCountry != null && _currentCity != null) {
              _navigate(
                PrayerTimesScreen(
                  country: CountryData(
                    name: _currentCountry!,
                    flagEmoji: '🌍',
                    regions: [_currentCity!],
                  ),
                  region: _currentCity!,
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4AF37).withValues(alpha: 0.18),
                  const Color(0xFFD4AF37).withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.45),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            const Color(0xFFD4AF37).withValues(alpha: 0.22),
                        border: Border.all(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                      ),
                      child: Icon(
                        _iconForPrayer(_nextPrayerName),
                        color: const Color(0xFFD4AF37),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            labelText,
                            style: TextStyle(
                              color: AppTheme.getOnBackgroundColor(context)
                                  .withValues(alpha: 0.7),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getPrayerLabel(_nextPrayerName, langCode),
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 12,
                                color: Color(0xFFD4AF37),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${_currentCity ?? ''}, ${_currentCountry ?? ''}',
                                  style: TextStyle(
                                    color:
                                        AppTheme.getOnBackgroundColor(context)
                                            .withValues(alpha: 0.65),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _nextPrayerTimeFormatted ?? '--:--',
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
                        if (_timeRemaining != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            remainingText,
                            style: TextStyle(
                              color: AppTheme.getOnBackgroundColor(context)
                                  .withValues(alpha: 0.55),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _formatDuration(_timeRemaining!),
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFD4AF37).withValues(alpha: 0.35),
                              const Color(0xFFD4AF37).withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tapHint,
                      style: TextStyle(
                        color: AppTheme.getOnBackgroundColor(context)
                            .withValues(alpha: 0.5),
                        fontSize: 10.5,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: Color(0xFFD4AF37),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // WELCOME BANNER
  // ─────────────────────────────────────────────────────────────
  Widget _buildWelcomeBanner(BuildContext context, String langCode) {
    final isAr = langCode == 'ar';
    final isFr = langCode == 'fr';

    final String heading = isAr
        ? 'رفيقك الإسلامي الشامل'
        : (isFr
            ? 'Votre compagnon islamique complet'
            : 'Your complete Islamic companion');
    final String body = isAr
        ? 'كل ما تحتاجه في يومك: من مواقيت الصلاة والقرآن الكريم، إلى الأذكار والأدعية، ومتابعة أهدافك وقربك من الله — كل ذلك في مكان واحد.'
        : (isFr
            ? 'Tout ce dont vous avez besoin au quotidien : horaires de prière, Coran, invocations, suivi de vos objectifs et de votre proximité avec Allah — réunis en un seul endroit.'
            : 'Everything you need for your day: prayer times, the Holy Quran, daily remembrances, supplications, and tracking your goals and closeness to Allah — all in one place.');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFD4AF37).withValues(alpha: 0.10),
              const Color(0xFFD4AF37).withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.30),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFFD4AF37),
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
                      color: Color(0xFFD4AF37),
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: TextStyle(
                      color: AppTheme.getOnBackgroundColor(context)
                          .withValues(alpha: 0.72),
                      fontSize: 12,
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
  // DECORATIVE DIVIDER (with slow rotating stars)
  // ─────────────────────────────────────────────────────────────
  Widget _buildDecorativeDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
      child: Row(
        children: [
          Expanded(child: _gradientLine()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _ringRotateCtrl,
                  builder: (_, __) => Transform.rotate(
                    angle: -_ringRotateCtrl.value * 2 * math.pi,
                    child: Icon(
                      Icons.star_border_rounded,
                      size: 14,
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.85),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.circle,
                  size: 5,
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.9),
                ),
                const SizedBox(width: 6),
                AnimatedBuilder(
                  animation: _ringRotateCtrl,
                  builder: (_, __) => Transform.rotate(
                    angle: _ringRotateCtrl.value * 2 * math.pi,
                    child: Icon(
                      Icons.star_border_rounded,
                      size: 14,
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _gradientLine()),
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

  void _navigate(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, animation, __) => screen,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _openSettings() {
    _navigate(const SettingsScreen());
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          width: MediaQuery.of(context).size.width * 0.95,
          color: Colors.transparent,
          child: const LoginScreen(),
        ),
      ),
    );
  }

  void _showRamadanNotAvailableDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        title: Text(
          l10n.ramadan,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          l10n.ramadanNotAvailable,
          style: TextStyle(
            color: AppTheme.getOnBackgroundColor(context)
                .withValues(alpha: 0.75),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.close,
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEventDetailsDialog(BuildContext context, IslamicEvent event) {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    final gregorianDate =
        HijriCalendarService.getNextHijriDate(event.hijriMonth, event.hijriDay);

    final monthNamesAr = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final monthNamesEn = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthNamesFr = [
      'Janv', 'Févr', 'Mars', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sept', 'Oct', 'Nov', 'Déc'
    ];

    final monthList =
        isArabic ? monthNamesAr : (isFrench ? monthNamesFr : monthNamesEn);
    final monthName = monthList[gregorianDate.month - 1];

    final formattedGregorian = isArabic
        ? '${gregorianDate.day} $monthName ${gregorianDate.year}'
        : '$monthName ${gregorianDate.day}, ${gregorianDate.year}';

    final eventLang = isArabic ? 'ar' : (isFrench ? 'fr' : 'en');

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
        title: Text(
          event.getName(eventLang),
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.getDescription(eventLang),
              style: TextStyle(
                color: AppTheme.getOnBackgroundColor(context)
                    .withValues(alpha: 0.85),
                height: 1.55,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 16, color: Color(0xFFD4AF37)),
                const SizedBox(width: 8),
                Text(
                  isArabic
                      ? 'الهجري: ${event.hijriDay}/${event.hijriMonth} هـ'
                      : (isFrench
                          ? 'Hégirien : ${event.hijriDay}/${event.hijriMonth} AH'
                          : 'Hijri: ${event.hijriDay}/${event.hijriMonth} AH'),
                  style: TextStyle(
                    color: AppTheme.getOnBackgroundColor(context)
                        .withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.event_rounded,
                    size: 16, color: Color(0xFFD4AF37)),
                const SizedBox(width: 8),
                Text(
                  isArabic
                      ? 'الميلادي: $formattedGregorian'
                      : (isFrench
                          ? 'Grégorien : $formattedGregorian'
                          : 'Gregorian: $formattedGregorian'),
                  style: TextStyle(
                    color: AppTheme.getOnBackgroundColor(context)
                        .withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (event.isHoliday)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.celebration_rounded,
                        size: 16, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 6),
                    Text(
                      isArabic
                          ? 'يوم عطلة'
                          : (isFrench ? 'Jour Férié' : 'Holiday'),
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isArabic ? 'إغلاق' : (isFrench ? 'Fermer' : 'Close'),
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final langCode = Localizations.localeOf(context).languageCode;
    final isArabic = langCode == 'ar';
    final isFrench = langCode == 'fr';

    final String userName = authService.userName ??
        (isArabic ? 'ضيف' : (isFrench ? 'Invité' : 'Guest'));
    final String? profilePicUrl = authService.profilePicUrl;
    final bool isLoggedIn = authService.isLoggedIn;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final l10n = AppLocalizations.of(context);

        final scaledTitleSize = themeService.getScaledSize(20);
        final scaledDescSize = themeService.getScaledSize(13);

        final titleStyle =
            Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: const Color(0xFFD4AF37),
                  fontSize: scaledTitleSize * 2.2,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ) ??
                TextStyle(
                  color: const Color(0xFFD4AF37),
                  fontSize: scaledTitleSize * 2.2,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                );

        final nearestEvent = IslamicEventsService.getNearestEvent();

        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeCtrl,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      // ── TOP HEADER (Floating Icons + Centered Content) ──
                      Stack(
                        children: [
                          // Center Content Column
                          Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildHeroLogo(context),
                              const SizedBox(height: 14),

                              // ── APP TITLE ────────────────────────────
                              Padding(
                                // Increased horizontal padding to avoid floating icons
                                padding: const EdgeInsets.symmetric(horizontal: 70),
                                child: OutlinedTextTitle(
                                  text: switch (langCode) {
                                    'ar' => 'تطبيق إسلامي',
                                    'fr' => 'Application Islamique',
                                    _ => 'Islamy App',
                                  },
                                  style: titleStyle.copyWith(
                                    fontSize: scaledTitleSize * 1.9,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // ── WELCOME LINE ─────────────────────────
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 70),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [
                                      Color(0xFFD4AF37),
                                      Color(0xFFE8C547),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                                  child: Text(
                                    switch (langCode) {
                                      'ar' => 'مرحباً بك، $userName',
                                      'fr' => 'Bienvenue, $userName',
                                      _ => 'Welcome back, $userName',
                                    },
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // ── TAGLINE ──────────────────────────────
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 70),
                                child: Text(
                                  switch (langCode) {
                                    'ar' =>
                                      'رفيقك الإسلامي الموثوق في كل خطوة من يومك',
                                    'fr' =>
                                      'Votre compagnon islamique de confiance à chaque étape de votre journée',
                                    _ =>
                                      'Your trusted Islamic companion for every step of your day',
                                  },
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color:
                                            AppTheme.getOnBackgroundColor(context)
                                                .withValues(alpha: 0.65),
                                        fontSize: scaledDescSize,
                                        fontWeight: FontWeight.w500,
                                        height: 1.45,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // ── DATE BADGE (pulsing) ─────────
                              GestureDetector(
                                onTap: () => _navigate(const HijriCalendarScreen()),
                                child: AnimatedBuilder(
                                  animation: _badgePulseCtrl,
                                  builder: (context, child) {
                                    final t = _badgePulseCtrl.value;
                                    return Transform.scale(
                                      scale: 1.0 + (t * 0.015),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFFD4AF37)
                                                  .withValues(alpha: 0.12),
                                              const Color(0xFFD4AF37)
                                                  .withValues(alpha: 0.04),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          border: Border.all(
                                            color: const Color(0xFFD4AF37)
                                                .withValues(alpha: 0.35),
                                            width: 1.2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFD4AF37)
                                                  .withValues(
                                                      alpha: 0.05 + (t * 0.10)),
                                              blurRadius: 8 + (t * 8),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_rounded,
                                        color: Color(0xFFD4AF37),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        _getHijriDateString(context),
                                        style: const TextStyle(
                                          color: Color(0xFFD4AF37),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // ── FLOATING VERTICAL ICONS ──
                          Positioned(
                            top: 16,
                            right: isArabic ? 20 : null,
                            left: isArabic ? null : 20,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Avatar
                                _FadeSlideIn(
                                  index: 0,
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: isLoggedIn
                                          ? [
                                              BoxShadow(
                                                color:
                                                    const Color(0xFFD4AF37)
                                                        .withValues(alpha: 0.55),
                                                blurRadius: 18,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: isLoggedIn
                                          ? const Color(0xFFD4AF37)
                                              .withValues(alpha: 0.25)
                                          : const Color(0xFFD4AF37)
                                              .withValues(alpha: 0.15),
                                      backgroundImage: profilePicUrl != null
                                          ? NetworkImage(profilePicUrl)
                                          : null,
                                      child: profilePicUrl == null
                                          ? Icon(
                                              Icons.person_rounded,
                                              color: isLoggedIn
                                                  ? const Color(0xFFD4AF37)
                                                  : const Color(0xFFD4AF37)
                                                      .withValues(alpha: 0.5),
                                              size: 24,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Settings
                                _FadeSlideIn(
                                  index: 1,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.settings_rounded,
                                      color: Color(0xFFD4AF37),
                                      size: 24,
                                    ),
                                    onPressed: _openSettings,
                                    tooltip: l10n.settings,
                                    splashRadius: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                        minWidth: 38, minHeight: 38),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Logout / Login
                                _FadeSlideIn(
                                  index: 2,
                                  child: IconButton(
                                    icon: Icon(
                                      isLoggedIn
                                          ? Icons.logout_rounded
                                          : Icons.login_rounded,
                                      color: isLoggedIn
                                          ? Colors.redAccent
                                          : const Color(0xFFD4AF37),
                                      size: 24,
                                    ),
                                    tooltip: isLoggedIn
                                        ? (isArabic
                                            ? 'تسجيل الخروج'
                                            : (isFrench
                                                ? 'Déconnexion'
                                                : 'Logout'))
                                        : (isArabic
                                            ? 'تسجيل الدخول'
                                            : (isFrench
                                                ? 'Connexion'
                                                : 'Login')),
                                    onPressed: () async {
                                      if (isLoggedIn) {
                                        final bool? confirm =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (dialogContext) =>
                                              AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              side: BorderSide(
                                                color: const Color(0xFFD4AF37)
                                                    .withValues(alpha: 0.3),
                                              ),
                                            ),
                                            title: Text(
                                              isArabic
                                                  ? 'تأكيد الخروج'
                                                  : (isFrench
                                                      ? 'Confirmer la déconnexion'
                                                      : 'Confirm Logout'),
                                              style: const TextStyle(
                                                  color: Color(0xFFD4AF37)),
                                            ),
                                            content: Text(
                                              isArabic
                                                  ? 'هل أنت متأكد من رغبتك في الخروج من الحساب؟'
                                                  : (isFrench
                                                      ? 'Êtes-vous sûr de vouloir vous déconnecter ?'
                                                      : 'Are you sure you want to log out?'),
                                              style: TextStyle(
                                                color:
                                                    AppTheme.getOnBackgroundColor(
                                                            context)
                                                        .withValues(alpha: 0.75),
                                                height: 1.4,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    dialogContext, false),
                                                child: Text(
                                                  isArabic
                                                      ? 'إلغاء'
                                                      : (isFrench
                                                          ? 'Annuler'
                                                          : 'Cancel'),
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    dialogContext, true),
                                                child: Text(
                                                  isArabic
                                                      ? 'نعم، خروج'
                                                      : (isFrench
                                                          ? 'Oui, Déconnexion'
                                                          : 'Yes, Logout'),
                                                  style: const TextStyle(
                                                      color:
                                                          Colors.redAccent),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          await authService.signOut();
                                          if (!context.mounted) return;
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const LoginScreen()),
                                            (route) => false,
                                          );
                                        }
                                      } else {
                                        _showLoginDialog();
                                      }
                                    },
                                    splashRadius: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                        minWidth: 38, minHeight: 38),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ── EVENT CHIP (if any) ─────────────────
                      if (nearestEvent != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 4),
                          child: GestureDetector(
                            onTap: () => _showEventDetailsDialog(
                                context, nearestEvent),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFD4AF37)
                                        .withValues(alpha: 0.16),
                                    const Color(0xFFD4AF37)
                                        .withValues(alpha: 0.06),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFD4AF37)
                                      .withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.event_available_rounded,
                                    color: Color(0xFFD4AF37),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      isArabic
                                          ? '${nearestEvent.getName('ar')} • متبقي ${nearestEvent.daysUntil()} يوم'
                                          : (isFrench
                                              ? '${nearestEvent.getName('fr')} • ${nearestEvent.daysUntil()} jours restants'
                                              : '${nearestEvent.getName('en')} • ${nearestEvent.daysUntil()} days left'),
                                      style: const TextStyle(
                                        color: Color(0xFFD4AF37),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 8),

                      // ── UPCOMING PRAYER CARD ───────────────
                      _buildUpcomingPrayerCard(context, langCode),

                      _buildDecorativeDivider(),

                      // ── WELCOME BANNER ─────────────────────
                      _buildWelcomeBanner(context, langCode),

                      // ═════════════════════════════════════════
                      // SECTION 1 — DAILY WORSHIP
                      // ═════════════════════════════════════════
                      _buildSectionHeader(
                        context: context,
                        icon: Icons.access_time_filled,
                        title: isArabic
                            ? 'العبادات اليومية'
                            : (isFrench
                                ? 'Adoration quotidienne'
                                : 'Daily Worship'),
                        subtitle: isArabic
                            ? 'أساسيات يومك الإيماني: مواقيت الصلاة، القرآن الكريم، الأذكار، الأدعية، والأعمال الصالحة — مرتبة في مكان واحد ليسهل عليك المداومة.'
                            : (isFrench
                                ? 'Les essentiels de votre journée : horaires de prière, Coran, invocations, bonnes actions — organisés pour vous aider à rester constant.'
                                : 'The essentials of your faith day: prayer times, the Holy Quran, remembrances, supplications, and good deeds — arranged to help you stay consistent.'),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Wrap(
                          spacing: 18,
                          runSpacing: 18,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildCard(
                              index: 0,
                              icon: Icons.access_time_filled,
                              title: l10n.prayerTimes,
                              description: isArabic
                                  ? 'اطّلع على مواقيت الصلاة الدقيقة لمدينتك مع عدّاد تنازلي للصلاة القادمة.'
                                  : (isFrench
                                      ? 'Consultez les horaires de prière précis de votre ville avec un compte à rebours.'
                                      : 'View accurate prayer times for your city with a live countdown to the next prayer.'),
                              onTap: () =>
                                  _navigate(const CountrySelectionScreen()),
                            ),
                            _buildCard(
                              index: 1,
                              icon: Icons.auto_stories_rounded,
                              title: l10n.quranTitle,
                              description: isArabic
                                  ? 'اقرأ القرآن الكريم كاملاً مع إمكانية الاستماع والتأمل في معانيه.'
                                  : (isFrench
                                      ? 'Lisez le Saint Coran complet avec écoute et méditation.'
                                      : 'Read the complete Holy Quran with listening and reflection.'),
                              onTap: () => _navigate(const QuranScreen()),
                            ),
                            _buildCard(
                              index: 2,
                              icon: Icons.favorite_rounded,
                              title: l10n.azkarTitle,
                              description: isArabic
                                  ? 'أذكار الصباح والمساء والنوم لتطمئن قلبك وتحصّن يومك.'
                                  : (isFrench
                                      ? 'Invocations du matin, du soir et du sommeil pour apaiser votre cœur.'
                                      : 'Morning, evening, and bedtime remembrances to calm your heart.'),
                              onTap: () => _navigate(const AzkarScreen()),
                            ),
                            _buildCard(
                              index: 3,
                              icon: Icons.front_hand,
                              title: l10n.duaaTitle,
                              description: isArabic
                                  ? 'مجموعة من الأدعية المأثورة من الكتاب والسنة لكل مناسبة.'
                                  : (isFrench
                                      ? 'Une collection d\'invocations du Coran et de la Sunna pour chaque occasion.'
                                      : 'A collection of authentic supplications from the Quran and Sunnah for every occasion.'),
                              onTap: () => _navigate(const DuaaScreen()),
                            ),
                            _buildCard(
                              index: 4,
                              icon: Icons.volunteer_activism_rounded,
                              title: l10n.goodDeedsTitle,
                              description: isArabic
                                  ? 'سجّل أعمالك الصالحة اليومية وتابع تقدمك في الطاعات.'
                                  : (isFrench
                                      ? 'Enregistrez vos bonnes actions quotidiennes et suivez vos progrès.'
                                      : 'Record your daily good deeds and track your progress in worship.'),
                              onTap: () => _navigate(const GoodDeedsScreen()),
                            ),
                            _buildCard(
                              index: 5,
                              icon: Icons.flag_rounded,
                              title: l10n.goalsTitle,
                              description: isArabic
                                  ? 'ضع أهدافاً إسلامية واقعية وتابع إنجازها خطوة بخطوة.'
                                  : (isFrench
                                      ? 'Fixez des objectifs islamiques réalistes et suivez-les étape par étape.'
                                      : 'Set realistic Islamic goals and follow them step by step.'),
                              onTap: () =>
                                  _navigate(const IslamicGoalsScreen()),
                            ),
                          ],
                        ),
                      ),

                      // ═════════════════════════════════════════
                      // SECTION 2 — GUIDANCE & TOOLS
                      // ═════════════════════════════════════════
                      _buildSectionHeader(
                        context: context,
                        icon: Icons.explore_rounded,
                        title: isArabic
                            ? 'الإرشاد والأدوات'
                            : (isFrench
                                ? 'Guidance & outils'
                                : 'Guidance & Tools'),
                        subtitle: isArabic
                            ? 'أدوات عملية تعينك في يومك: تحديد القبلة بدقة، العثور على أقرب مسجد إليك، وتقوية معرفتك عبر الاختبارات التفاعلية.'
                            : (isFrench
                                ? 'Des outils pratiques pour votre journée : localisation précise de la Qibla, mosquées les plus proches, et quiz interactifs.'
                                : 'Practical tools for your day: precise Qibla direction, nearest mosques, and interactive quizzes.'),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Wrap(
                          spacing: 18,
                          runSpacing: 18,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildCard(
                              index: 6,
                              icon: Icons.compass_calibration_rounded,
                              title: l10n.qiblahFinderTitle,
                              description: isArabic
                                  ? 'حدّد اتجاه القبلة بدقة عالية من أي مكان في العالم.'
                                  : (isFrench
                                      ? 'Déterminez précisément la direction de la Qibla depuis n\'importe où.'
                                      : 'Determine the Qibla direction with high accuracy from anywhere.'),
                              onTap: () =>
                                  _navigate(const QiblahFinderScreen()),
                            ),
                            _buildCard(
                              index: 7,
                              icon: Icons.location_on_rounded,
                              title: l10n.nearestMosqueTitle,
                              description: isArabic
                                  ? 'اعثر على أقرب المساجد إليك مع المسافات والاتجاهات.'
                                  : (isFrench
                                      ? 'Trouvez les mosquées les plus proches avec distances et directions.'
                                      : 'Find the nearest mosques to you with distances and directions.'),
                              onTap: () =>
                                  _navigate(const MosqueFinderScreen()),
                            ),
                            _buildCard(
                              index: 8,
                              icon: Icons.quiz_rounded,
                              title: l10n.quizTitle,
                              description: isArabic
                                  ? 'اختبر معلوماتك الإسلامية عبر أسئلة ممتعة ومتدرجة.'
                                  : (isFrench
                                      ? 'Testez vos connaissances islamiques avec des questions variées.'
                                      : 'Test your Islamic knowledge with fun, varied questions.'),
                              onTap: () => _navigate(const QuizScreen()),
                            ),
                          ],
                        ),
                      ),

                      // ═════════════════════════════════════════
                      // SECTION 3 — KNOWLEDGE & REFLECTION
                      // ═════════════════════════════════════════
                      _buildSectionHeader(
                        context: context,
                        icon: Icons.menu_book_rounded,
                        title: isArabic
                            ? 'المعرفة والتأمل'
                            : (isFrench
                                ? 'Savoir & réflexion'
                                : 'Knowledge & Reflection'),
                        subtitle: isArabic
                            ? 'اغتنِ من السيرة النبوية والأحاديث الشريفة، واستعد لشهر رمضان المبارك بكل ما تحتاجه من أدعية وأعمال.'
                            : (isFrench
                                ? 'Nourrissez-vous de la biographie prophétique et des hadiths, et préparez le Ramadan avec tout le nécessaire.'
                                : 'Enrich yourself with the prophetic biography and hadiths, and prepare for Ramadan with everything you need.'),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Wrap(
                          spacing: 18,
                          runSpacing: 18,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildCard(
                              index: 9,
                              icon: Icons.person_rounded,
                              title: l10n.prophetBioTitle,
                              description: isArabic
                                  ? 'تعرّف على سيرة النبي ﷺ بمراحلها المختلفة وتأمل في مواقفه العظيمة.'
                                  : (isFrench
                                      ? 'Découvrez la biographie du Prophète ﷺ et ses grandes étapes.'
                                      : 'Discover the biography of the Prophet ﷺ and its great stages.'),
                              onTap: () =>
                                  _navigate(const ProphetBiographyScreen()),
                            ),
                            _buildCard(
                              index: 10,
                              icon: Icons.book_rounded,
                              title: l10n.hadithsTitle,
                              description: isArabic
                                  ? 'مجموعة مختارة من الأحاديث النبوية الشريفة مع الشرح والتوضيح.'
                                  : (isFrench
                                      ? 'Une sélection de hadiths prophétiques avec explications.'
                                      : 'A curated selection of prophetic hadiths with explanations.'),
                              onTap: () => _navigate(const HadithsScreen()),
                            ),
                            _buildCard(
                              index: 11,
                              icon: Icons.nightlight_round,
                              title: l10n.ramadan,
                              description: _isRamadan
                                  ? l10n.ramadanActiveDesc
                                  : l10n.ramadanInactiveDesc.replaceFirst(
                                      '%d', _ramadanCountdown.toString()),
                              onTap: _isRamadan
                                  ? () =>
                                      _navigate(const RamadanModeScreen())
                                  : () => _showRamadanNotAvailableDialog(
                                      context),
                              isEnabled: _isRamadan,
                            ),
                          ],
                        ),
                      ),

                      // ═════════════════════════════════════════
                      // SECTION 4 — SMART FEATURES
                      // ═════════════════════════════════════════
                      _buildSectionHeader(
                        context: context,
                        icon: Icons.auto_awesome_rounded,
                        title: isArabic
                            ? 'الميزات الذكية'
                            : (isFrench
                                ? 'Fonctionnalités intelligentes'
                                : 'Smart Features'),
                        subtitle: isArabic
                            ? 'استفد من الذكاء الاصطناعي لطرح أسئلتك الدينية، وتعلّم أساسيات الوضوء والصلاة والسنن اليومية خطوة بخطوة.'
                            : (isFrench
                                ? 'Utilisez l\'IA pour vos questions religieuses, et apprenez les ablutions, la prière et les Sunna étape par étape.'
                                : 'Use AI to ask your religious questions, and learn wudu, prayer, and daily Sunnah step by step.'),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Wrap(
                          spacing: 18,
                          runSpacing: 18,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildCard(
                              index: 12,
                              icon: Icons.lightbulb_rounded,
                              title: isArabic
                                  ? 'اسأل الذكاء الاصطناعي'
                                  : (isFrench
                                      ? 'Demander à l\'IA'
                                      : 'Ask AI'),
                              description: isArabic
                                  ? 'اطرح أسئلتك الدينية والشخصية واحصل على إجابات موثوقة ومبسّطة.'
                                  : (isFrench
                                      ? 'Posez vos questions religieuses et personnelles et obtenez des réponses fiables.'
                                      : 'Ask your religious and personal questions and get reliable, simplified answers.'),
                              onTap: () =>
                                  _navigate(const AIQuestionAnswerScreen()),
                            ),
                            _buildCard(
                              index: 13,
                              icon: Icons.school_rounded,
                              title: isArabic
                                  ? 'علّمني'
                                  : (isFrench
                                      ? 'Apprends-moi'
                                      : 'Teach Me'),
                              description: isArabic
                                  ? 'تعلّم الوضوء والصلاة والسنن اليومية خطوة بخطوة مع الشرح والصور.'
                                  : (isFrench
                                      ? 'Apprenez les ablutions, la prière et les Sunna étape par étape.'
                                      : 'Learn wudu, salah, and daily Sunnahs step by step with explanations.'),
                              onTap: () =>
                                  _navigate(TeachMeScreen(lang: langCode)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── FOOTER ────────────────────────────
                      _buildFooter(context, langCode, isArabic, isFrench),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // FOOTER
  // ─────────────────────────────────────────────────────────────
  Widget _buildFooter(
    BuildContext context,
    String langCode,
    bool isArabic,
    bool isFrench,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.8),
                ),
              ),
              Expanded(child: _gradientLine()),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isArabic
                ? 'جُزاك الله خيراً على استخدامك التطبيق'
                : (isFrench
                    ? 'Qu\'Allah vous récompense pour utiliser cette application'
                    : 'May Allah reward you for using this app'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isArabic
                ? 'نسأل الله أن ينفعك به ويجعله في ميزان حسناتك'
                : (isFrench
                    ? 'Nous demandons à Allah qu\'Il vous en fasse bénéficier'
                    : 'We ask Allah to benefit you through it and place it in your scale of good deeds'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.getOnBackgroundColor(context)
                  .withValues(alpha: 0.5),
              fontSize: 11,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // CARD BUILDER
  // ─────────────────────────────────────────────────────────────
  Widget _buildCard({
    required int index,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 260,
        maxWidth: 380,
      ),
      child: _AnimatedCardWrapper(
        index: index,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.65),
                    Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFD4AF37)
                      .withValues(alpha: isEnabled ? 0.42 : 0.15),
                  width: 1.2,
                ),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFD4AF37)
                                .withValues(alpha: 0.18),
                            const Color(0xFFD4AF37)
                                .withValues(alpha: 0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.35),
                          width: 1.5,
                        ),
                        boxShadow: isEnabled
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFD4AF37)
                                      .withValues(alpha: 0.12),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        icon,
                        color: const Color(0xFFD4AF37)
                            .withValues(alpha: isEnabled ? 1.0 : 0.4),
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: isEnabled ? 1.0 : 0.5),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  AppTheme.getOnBackgroundColor(context)
                                      .withValues(
                                          alpha: isEnabled ? 0.72 : 0.35),
                              fontSize: 12.5,
                              height: 1.45,
                              fontWeight: FontWeight.w400,
                            ),
                  ),
                  const SizedBox(height: 14),
                  // Small "open" affordance
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: isEnabled ? 0.4 : 0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? 'افتح'
                                : (Localizations.localeOf(context)
                                            .languageCode ==
                                        'fr'
                                    ? 'Ouvrir'
                                    : 'Open'),
                            style: TextStyle(
                              color: const Color(0xFFD4AF37)
                                  .withValues(alpha: isEnabled ? 1.0 : 0.4),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: isEnabled ? 1.0 : 0.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STAGGERED ENTRANCE WRAPPER (cards)
// ─────────────────────────────────────────────────────────────
class _AnimatedCardWrapper extends StatelessWidget {
  final Widget child;
  final int index;
  const _AnimatedCardWrapper({required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 420 + (index * 90)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 26 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FADE + SLIDE IN (floating corner icons)
// ─────────────────────────────────────────────────────────────
class _FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int index;
  final double offsetY;
  const _FadeSlideIn({
    required this.child,
    this.index = 0,
    this.offsetY = 12,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 110)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, offsetY * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: child,
    );
  }
}