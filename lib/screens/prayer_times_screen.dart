import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../models/country_data.dart';
import '../models/prayer_times.dart';
import '../services/prayer_times_service.dart';
import '../services/adhan_service.dart';
import '../services/notification_service.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/geo_translations.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../widgets/prayer_notification_popup.dart';
import 'package:flutter/foundation.dart';
import 'settings_screen.dart' show AdhanSettingsScreen;
import '../utils/adhan_reciter_translations.dart';

class PrayerTimesScreen extends StatefulWidget {
  final CountryData country;
  final String region;

  const PrayerTimesScreen({
    super.key,
    required this.country,
    required this.region,
  });

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen>
    with TickerProviderStateMixin {
  PrayerTimes? _times;
  String? _error;
  bool _loading = true;
  Timer? _clockTimer;

  Duration? _timeUntilNext;
  String? _nextPrayerName;
  double _progressToNextPrayer = 0.0;

  String _selectedReciter = 'mishary';
  bool _isWholeAdhan = true;
  bool _adhanPlaying = false;

  String? _activePrayerPopup;
  String? _lastNotifiedPrayer;

  AudioPlayer? _webTestPlayer;
  StreamSubscription<PlayerState>? _adhanSub;

  late AnimationController _entranceController;

  static const Map<String, String> _adhanReciterImages = {
    'mishary': 'afasiad.jpg',
    'nasser': 'qatamiad.jpg',
    'qassas': 'qassasad.jpg',
    'refaat': 'refaatad.jpg',
    'tobar': 'tobarad.jpg',
    'basset': 'bassetad.jpg',
    'hosari': 'hosariad.jpg',
  };

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _loadPreferences();
    _load();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _selectedReciter = prefs.getString('adhanReciter') ?? 'mishary';
      _isWholeAdhan = prefs.getBool('isWholeAdhan') ?? true;
    });
  }

  @override
  void dispose() {
    _webTestPlayer?.dispose();
    _clockTimer?.cancel();
    _adhanSub?.cancel();
    _entranceController.dispose();
    AdhanService.stopAdhan();
    super.dispose();
  }

  // ─────────────────────────────── LOAD ───────────────────────────────

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await PrayerTimesService.fetchByCity(
        city: widget.region,
        country: widget.country.name,
      );
      if (!mounted) return;
      setState(() {
        _times = result;
        _loading = false;
      });
      _startCountdown();
      _entranceController.forward(from: 0);
      _scheduleNotifications();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _startCountdown() {
    _clockTimer?.cancel();
    _updateCountdown();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  // ─────────────────────────────── COUNTDOWN ───────────────────────────────

  DateTime? _parseToday(String hhmm, DateTime now) {
    final cleanTime = hhmm.split(' ')[0];
    final parts = cleanTime.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return DateTime(now.year, now.month, now.day, h, m);
  }

  void _updateCountdown() {
    if (_times == null) return;
    final now = DateTime.now();
    final entries = _times!.asOrderedList();

    // Detect prayer entry moment → show popup + play adhan
    for (final entry in entries) {
      final dt = _parseToday(entry.value, now);
      if (dt != null) {
        final diff = dt.difference(now);
        if (diff.inSeconds <= 0 &&
            diff.inSeconds > -2 &&
            _lastNotifiedPrayer != entry.key) {
          _lastNotifiedPrayer = entry.key;
          if (mounted) {
            setState(() => _activePrayerPopup = entry.key);
            _playAdhan();
          }
        }
      }
    }

    // Compute next prayer + progress
    DateTime? nextTime;
    String? nextName;
    final List<DateTime> dates = [];
    for (final e in entries) {
      final dt = _parseToday(e.value, now);
      if (dt != null) dates.add(dt);
    }

    for (final entry in entries) {
      final dt = _parseToday(entry.value, now);
      if (dt == null) continue;
      if (dt.isAfter(now)) {
        nextTime = dt;
        nextName = entry.key;
        break;
      }
    }
    if (nextTime == null && dates.isNotEmpty) {
      nextTime = dates.first.add(const Duration(days: 1));
      nextName = entries.first.key;
    }

    double progress = _progressToNextPrayer;
    if (dates.isNotEmpty && nextTime != null) {
      DateTime? prev;
      for (final d in dates) {
        if (d.isBefore(now)) prev = d;
      }
      prev ??= dates.last.subtract(const Duration(days: 1));
      final total = nextTime.difference(prev).inSeconds.toDouble();
      final elapsed = now.difference(prev).inSeconds.toDouble();
      progress = total > 0 ? (elapsed / total).clamp(0.0, 1.0) : 0.0;
    }

    if (nextTime != null && mounted) {
      setState(() {
        _timeUntilNext = nextTime!.difference(now);
        _nextPrayerName = nextName;
        _progressToNextPrayer = progress;
      });
    }
  }

  Future<void> _scheduleNotifications() async {
    if (_times == null) return;
    final now = DateTime.now();
    final entries = _times!.asOrderedList();

    for (final entry in entries) {
      final dt = _parseToday(entry.value, now);
      if (dt != null && dt.isAfter(now)) {
        await NotificationService.schedulePrayerNotification(entry.key, dt);
      }
    }
  }

  // ─────────────────────────────── HELPERS ───────────────────────────────

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _formatTimeUntil(String timeStr) {
    final now = DateTime.now();
    final dt = _parseToday(timeStr, now);
    if (dt == null) return '';
    var target = dt;
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    final diff = target.difference(now);
    if (diff.inHours >= 1) {
      return '${diff.inHours}h ${diff.inMinutes % 60}m';
    }
    return '${diff.inMinutes}m';
  }

  String _format12Hour(String time24, bool isArabic) {
    final cleanTime = time24.split(' ')[0];
    final parts = cleanTime.split(':');
    if (parts.length != 2) return cleanTime;
    final h = int.tryParse(parts[0]);
    if (h == null) return cleanTime;

    final isPm = h >= 12;
    int displayH = h % 12;
    if (displayH == 0) displayH = 12;

    final amPm = isArabic ? (isPm ? 'م' : 'ص') : (isPm ? 'PM' : 'AM');
    final displayHStr = displayH.toString().padLeft(2, '0');
    return '$displayHStr:${parts[1]} $amPm';
  }

  IconData _iconFor(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.brightness_4_rounded;
      case 'Dhuhr':
        return Icons.wb_sunny_rounded;
      case 'Asr':
        return Icons.wb_twilight_rounded;
      case 'Maghrib':
        return Icons.brightness_5_rounded;
      case 'Isha':
        return Icons.nightlight_round;
      default:
        return Icons.access_time_rounded;
    }
  }

  String _getLocalizedPrayerName(String name, AppLocalizations l10n) {
    switch (name.toLowerCase()) {
      case 'fajr':
        return l10n.fajr;
      case 'dhuhr':
        return l10n.dhuhr;
      case 'asr':
        return l10n.asr;
      case 'maghrib':
        return l10n.maghrib;
      case 'isha':
        return l10n.isha;
      default:
        return name;
    }
  }

  // ─────────────────────────────── AUDIO ───────────────────────────────

  Future<void> _playAdhan() async {
  // ─── Always re-read the user's latest choice from Settings ───
  final prefs = await SharedPreferences.getInstance();
  final reciter = prefs.getString('adhanReciter') ?? 'mishary';
  final whole   = prefs.getBool('isWholeAdhan') ?? true;

  if (!mounted) return;

  // Sync local state so the panel/UI reflects the current choice
  setState(() {
    _selectedReciter = reciter;
    _isWholeAdhan = whole;
  });

  try {
    await AdhanService.stopAdhan();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    setState(() => _adhanPlaying = true);

    // ─── Pass BOTH reciter AND length — this is what was missing ───
    await AdhanService.playAdhan(reciter, isWholeAdhan: whole);

    _adhanSub?.cancel();
    _adhanSub = AdhanService.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() => _adhanPlaying = false);
      }
    });
  } catch (e) {
    debugPrint('Audio Error: $e');
    if (mounted) {
      setState(() => _adhanPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio failed to play: $e'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}

  Future<void> _stopAdhan() async {
    await AdhanService.stopAdhan();
    if (mounted) setState(() => _adhanPlaying = false);
  }

  // ─────────────────────────────── BUILD ───────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: Stack(
            children: [
              IslamicPatternBackground(
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildCustomHeader(context, l10n, isArabic, themeService),
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeIn,
                              child: _loading
                                  ? _buildLoading(l10n, themeService)
                                  : _error != null
                                      ? _buildError(l10n, themeService)
                                      : _buildContent(
                                          l10n, isArabic, themeService),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_activePrayerPopup != null)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: PrayerNotificationPopup(
                      prayerName: _activePrayerPopup!,
                      onDismiss: () {
                        if (mounted) {
                          setState(() => _activePrayerPopup = null);
                        }
                      },
                      onStopAdhan: () {
                        _webTestPlayer?.stop();
                        NotificationService.stopAdhan();
                        _stopAdhan();
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────── HEADER ───────────────────────────────

  Widget _buildCustomHeader(BuildContext context, AppLocalizations? l10n,
      bool isArabic, ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          _GlassIconButton(
  icon: Icons.notifications_active_outlined,
  tooltip: isArabic ? 'تجربة الإشعار' : 'Test Notification',
  onTap: () async {
    // ─── Reload prefs so we always use the latest settings ───
    await _loadPreferences();
    if (!mounted) return;

    setState(() => _activePrayerPopup = 'Fajr');

    if (kIsWeb) {
      // ─── Full 7-reciter map (matches SettingsScreen._adhanReciterImages) ───
      const paths = {
        'mishary': 'adhan/afasiadhan',
        'nasser' : 'adhan/qatamiadhan',
        'qassas' : 'adhan/moqassas',
        'refaat' : 'adhan/refaatadhan',
        'tobar'  : 'adhan/adhantobar',
        'basset' : 'adhan/bassetadhan',
        'hosari' : 'adhan/hosariadhan',
      };
      final basePath = paths[_selectedReciter];
      if (basePath == null) {
        debugPrint('⚠️ Unknown reciter "$_selectedReciter" — aborting test.');
        return;
      }
      final fileName =
          _isWholeAdhan ? '$basePath.mp3' : '${basePath}_takbeer.mp3';

      try {
        _webTestPlayer?.stop();
        _webTestPlayer = AudioPlayer();
        await _webTestPlayer!.play(AssetSource(fileName));
      } catch (e) {
        debugPrint('❌ Web test adhan failed ($fileName): $e');
      }
    } else {
      await NotificationService.showTestAdhan(
        reciter: _selectedReciter,
        isWholeAdhan: _isWholeAdhan,
      );
    }
  },
),
          Expanded(
            child: Column(
              children: [
                Text(
                  l10n?.prayerTimes ?? 'Prayer Times',
                  textAlign: TextAlign.center,
                  style: themeService.getTextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isArabic
                      ? 'مواقيت الصلاة والعدّ التنازلي'
                      : 'Prayer schedule & countdown',
                  textAlign: TextAlign.center,
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    letterSpacing: 0.5,
                    color:
                        AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          _GlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            tooltip: isArabic ? 'رجوع' : 'Back',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────── LOADING / ERROR ───────────────────────────────

  Widget _buildLoading(AppLocalizations? l10n, ThemeService themeService) {
    return Column(
      key: const ValueKey('loading'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n?.fetchingPrayerTimes ?? 'Loading...',
          style: themeService.getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildError(AppLocalizations? l10n, ThemeService themeService) {
    return Padding(
      key: const ValueKey('error'),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.cloud_off_rounded,
                color: Colors.redAccent, size: 48),
          ),
          const SizedBox(height: 20),
          Text(
            l10n?.errorLoadingPrayerTimes ?? 'Failed to load prayer times',
            style: themeService.getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.getOnBackgroundColor(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? '',
            style: themeService.getTextStyle(
              fontSize: 12,
              color:
                  AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(
              l10n?.retry ?? 'Retry',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: const Color(0xFF0B3D2E),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────── CONTENT ───────────────────────────────

  Widget _buildContent(
      AppLocalizations? l10n, bool isArabic, ThemeService themeService) {
    if (_times == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      key: const ValueKey('content'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        children: [
          // ── 1. Location hero card
          _AnimatedSection(
            index: 0,
            controller: _entranceController,
            child: _buildLocationCard(context, isArabic, themeService),
          ),
          const SizedBox(height: 20),

          // ── 2. Countdown with progress ring
          _AnimatedSection(
            index: 1,
            controller: _entranceController,
            child: _buildCountdownCard(l10n, isArabic, themeService),
          ),
          const SizedBox(height: 24),

          // ── 3. Section header for prayer list
          _AnimatedSection(
            index: 2,
            controller: _entranceController,
            child: _SectionLabel(
              icon: Icons.schedule_rounded,
              title: isArabic ? 'جدول الصلوات' : 'Prayer Schedule',
              subtitle: isArabic
                  ? 'المواقيت الرسمية لهذا اليوم حسب منطقتك'
                  : 'Today\'s official prayer times for your location',
              themeService: themeService,
            ),
          ),
          const SizedBox(height: 12),

          // ── 4. Prayer list
          ..._times!.asOrderedList().asMap().entries.map((e) {
            final index = e.key;
            final entry = e.value;
            final isNext = entry.key == _nextPrayerName;
            final until = _formatTimeUntil(entry.value);
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 320 + (index * 70)),
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 22),
                    child: child,
                  ),
                );
              },
              child: _PrayerRow(
                name: _getLocalizedPrayerName(entry.key, l10n!),
                time: _format12Hour(entry.value, isArabic),
                timeUntil: until,
                icon: _iconFor(entry.key),
                isNext: isNext,
                l10n: l10n,
                isArabic: isArabic,
                themeService: themeService,
              ),
            );
          }),

          const SizedBox(height: 24),

          // ── 5. Adhan control panel (reciter avatar + play + settings)
          _AnimatedSection(
            index: 3,
            controller: _entranceController,
            child: _buildAdhanControlPanel(l10n, isArabic, themeService),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────── LOCATION CARD ───────────────────────────────

  Widget _buildLocationCard(
      BuildContext context, bool isArabic, ThemeService themeService) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A5F3E).withValues(alpha: 0.55),
                  const Color(0xFF0E3824).withValues(alpha: 0.45),
                ]
              : [
                  const Color(0xFFE8F5EE).withValues(alpha: 0.9),
                  const Color(0xFFD3E9DC).withValues(alpha: 0.7),
                ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
            blurRadius: 18,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.35),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(Icons.place_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'الموقع الحالي' : 'Current Location',
                  style: themeService.getTextStyle(
                    fontSize: 11,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${GeoTranslations.translate(context, widget.country.name)} • ${GeoTranslations.translate(context, widget.region)}',
                  style: themeService.getTextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getOnBackgroundColor(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _GlassIconButton(
            icon: Icons.refresh_rounded,
            tooltip: isArabic ? 'تحديث' : 'Refresh',
            onTap: _load,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────── COUNTDOWN CARD ───────────────────────────────

  Widget _buildCountdownCard(
      AppLocalizations? l10n, bool isArabic, ThemeService themeService) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = Theme.of(context).colorScheme.secondary;

    final nextLabel = _nextPrayerName != null
        ? _getLocalizedPrayerName(_nextPrayerName!, l10n!)
        : '--';
    final untilLabel = isArabic ? 'متبقٍ حتى' : 'Remaining until';

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0B3D2E).withValues(alpha: 0.7)
                : const Color(0xFFF0F8F4).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: secondary.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: secondary.withValues(alpha: 0.14),
                blurRadius: 22,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _nextPrayerName != null
                        ? _iconFor(_nextPrayerName!)
                        : Icons.access_time_rounded,
                    color: secondary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    untilLabel,
                    style: themeService.getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color:
                          AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    nextLabel,
                    style: themeService.getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Progress ring with timer inside
              SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: _progressToNextPrayer,
                        strokeWidth: 9,
                        strokeCap: StrokeCap.round,
                        backgroundColor: secondary.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(secondary),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _timeUntilNext != null
                              ? _formatDuration(_timeUntilNext!)
                              : '--:--:--',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic ? 'ساعة : دقيقة : ثانية' : 'H : M : S',
                          style: themeService.getTextStyle(
                            fontSize: 11,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.getOnBackgroundColor(context)
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: secondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded, size: 14, color: secondary),
                    const SizedBox(width: 6),
                    Text(
                      '${(_progressToNextPrayer * 100).toStringAsFixed(0)}% ${isArabic ? 'من الوقت المنقضي' : 'elapsed'}',
                      style: themeService.getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────── ADHAN CONTROL PANEL ───────────────────────────────

  Widget _buildAdhanControlPanel(
      AppLocalizations? l10n, bool isArabic, ThemeService themeService) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = Theme.of(context).colorScheme.secondary;
    final langCode = Localizations.localeOf(context).languageCode;

    final fileName = _adhanReciterImages[_selectedReciter];
    final reciterName =
        AdhanReciterTranslations.getReciterName(_selectedReciter, langCode);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF144D32).withValues(alpha: 0.55)
                : const Color(0xFFF0F8F4).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: secondary.withValues(alpha: 0.28),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.mic_rounded, color: secondary, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'الأذان المفضّل' : 'Preferred Adhan',
                    style: themeService.getTextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getOnBackgroundColor(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          secondary.withValues(alpha: 0.35),
                          secondary.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: secondary.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: secondary.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: fileName == null
                          ? Icon(Icons.person,
                              color: secondary, size: 32)
                          : Image.asset(
                              'assets/images/adhan_reciters/$fileName',
                              fit: BoxFit.cover,
                              cacheWidth: 160,
                              cacheHeight: 160,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.person,
                                      color: secondary, size: 32),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'المقرئ الحالي' : 'Current Reciter',
                          style: themeService.getTextStyle(
                            fontSize: 11,
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w600,
                            color: secondary.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reciterName,
                          style: themeService.getTextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getOnBackgroundColor(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    _adhanPlaying ? Colors.green : secondary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _adhanPlaying
                                  ? (isArabic ? 'قيد التشغيل' : 'Playing')
                                  : (isArabic ? 'متوقف' : 'Idle'),
                              style: themeService.getTextStyle(
                                fontSize: 12,
                                color: AppTheme.getOnBackgroundColor(context)
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                const AdhanSettingsScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var tween = Tween(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero)
                                  .chain(CurveTween(
                                      curve: Curves.easeOutCubic));
                              return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child);
                            },
                          ),
                        ).then((_) => _loadPreferences());
                      },
                      icon: const Icon(Icons.settings_rounded, size: 18),
                      label: Text(
                        isArabic ? 'الإعدادات' : 'Settings',
                        style: themeService.getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondary,
                        foregroundColor: const Color(0xFF0B3D2E),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _adhanPlaying ? _stopAdhan : () => _playAdhan(),
                      icon: Icon(
                        _adhanPlaying
                            ? Icons.stop_rounded
                            : Icons.play_arrow_rounded,
                        size: 20,
                      ),
                      label: Text(
                        _adhanPlaying
                            ? (isArabic ? 'إيقاف' : 'Stop')
                            : (isArabic ? 'تجربة' : 'Preview'),
                        style: themeService.getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _adhanPlaying
                            ? Colors.redAccent.withValues(alpha: 0.9)
                            : secondary.withValues(alpha: 0.15),
                        foregroundColor: _adhanPlaying
                            ? Colors.white
                            : secondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: _adhanPlaying
                                ? Colors.transparent
                                : secondary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────── SHARED WIDGETS ───────────────────────────────

class _GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final button = MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _hover
                ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)
                : (isDark
                    ? const Color(0xFF144D32).withValues(alpha: 0.55)
                    : const Color(0xFFE8F3EE).withValues(alpha: 0.75)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: _hover ? 0.6 : 0.3),
            ),
          ),
          child: Icon(
            widget.icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 22,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeService themeService;

  const _SectionLabel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .secondary
                .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              color: Theme.of(context).colorScheme.secondary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: themeService.getTextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getOnBackgroundColor(context),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: themeService.getTextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppTheme.getOnBackgroundColor(context)
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  final int index;
  final Widget child;
  final AnimationController controller;

  const _AnimatedSection({
    required this.index,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final startDelay = (index * 0.10).clamp(0.0, 0.85);
    final endDelay = (startDelay + 0.30).clamp(0.0, 1.0);

    final slide = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(startDelay, endDelay, curve: Curves.easeOutCubic),
    ));

    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(startDelay, endDelay, curve: Curves.easeOut),
    ));

    final scale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startDelay, endDelay, curve: Curves.easeOutCubic),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Opacity(
        opacity: fade.value,
        child: Transform.translate(
          offset: Offset(0, slide.value.dy * 100),
          child: Transform.scale(
            scale: scale.value,
            child: child,
          ),
        ),
      ),
      child: child,
    );
  }
}

class _PrayerRow extends StatefulWidget {
  final String name;
  final String time;
  final String timeUntil;
  final IconData icon;
  final bool isNext;
  final AppLocalizations l10n;
  final bool isArabic;
  final ThemeService themeService;

  const _PrayerRow({
    required this.name,
    required this.time,
    required this.timeUntil,
    required this.icon,
    required this.isNext,
    required this.l10n,
    required this.isArabic,
    required this.themeService,
  });

  @override
  State<_PrayerRow> createState() => _PrayerRowState();
}

class _PrayerRowState extends State<_PrayerRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                gradient: widget.isNext
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          secondaryColor.withValues(alpha: isDark ? 0.28 : 0.22),
                          secondaryColor.withValues(alpha: isDark ? 0.15 : 0.12),
                        ],
                      )
                    : null,
                color: widget.isNext
                    ? null
                    : (_isHovered
                        ? (isDark
                            ? const Color(0xFF144D32).withValues(alpha: 0.65)
                            : Colors.white.withValues(alpha: 0.92))
                        : (isDark
                            ? const Color(0xFF0B3D2E).withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.78))),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: widget.isNext
                      ? secondaryColor
                      : (_isHovered
                          ? secondaryColor.withValues(alpha: 0.6)
                          : secondaryColor.withValues(alpha: 0.18)),
                  width: widget.isNext ? 2 : 1,
                ),
                boxShadow: widget.isNext
                    ? [
                        BoxShadow(
                          color: secondaryColor.withValues(alpha: 0.28),
                          blurRadius: 14,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  // Icon circle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: widget.isNext
                          ? LinearGradient(
                              colors: [
                                secondaryColor,
                                secondaryColor.withValues(alpha: 0.7),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                secondaryColor.withValues(alpha: 0.22),
                                secondaryColor.withValues(alpha: 0.08),
                              ],
                            ),
                      boxShadow: widget.isNext
                          ? [
                              BoxShadow(
                                color: secondaryColor.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                              )
                            ]
                          : [],
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.isNext
                          ? (isDark
                              ? const Color(0xFF0B3D2E)
                              : Colors.white)
                          : secondaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Name + time-until
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.name,
                                style: widget.themeService.getTextStyle(
                                  fontSize: 17,
                                  fontWeight: widget.isNext
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: widget.isNext
                                      ? secondaryColor
                                      : AppTheme.getOnBackgroundColor(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.isNext) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      secondaryColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: secondaryColor.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  widget.isArabic ? 'القادمة' : 'Next',
                                  style: widget.themeService.getTextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.timeUntil.isNotEmpty
                              ? (widget.isArabic
                                  ? 'متبقٍ ${widget.timeUntil}'
                                  : 'in ${widget.timeUntil}')
                              : (widget.isArabic ? 'اليوم' : 'Today'),
                          style: widget.themeService.getTextStyle(
                            fontSize: 12,
                            color: widget.isNext
                                ? secondaryColor.withValues(alpha: 0.85)
                                : AppTheme.getOnBackgroundColor(context)
                                    .withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Time
                  Text(
                    widget.time,
                    style: widget.themeService.getTextStyle(
                      fontSize: 18,
                      fontWeight: widget.isNext
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: widget.isNext
                          ? secondaryColor
                          : AppTheme.getOnBackgroundColor(context),
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