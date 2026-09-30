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

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  PrayerTimes? _times;
  String? _error;
  bool _loading = true;
  Timer? _clockTimer;
  Duration? _timeUntilNext;
  String? _nextPrayerName;
  String _selectedReciter = 'mishary';
  bool _isWholeAdhan = true;
  bool _adhanPlaying = false;
  
  String? _activePrayerPopup;
  String? _lastNotifiedPrayer;
  AudioPlayer? _webTestPlayer;

  @override
  void initState() {
    super.initState();
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
    AdhanService.stopAdhan();
    super.dispose();
  }

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
      setState(() {
        _times = result;
        _loading = false;
      });
      _startCountdown();
      _scheduleNotifications();
    } catch (e) {
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

  void _updateCountdown() {
    if (_times == null) return;
    final now = DateTime.now();
    final entries = _times!.asOrderedList();
    
    DateTime? parseToday(String hhmm) {
      // FIX: Strip timezone tags like "(EEST)" before parsing
      final cleanTime = hhmm.split(' ')[0];
      final parts = cleanTime.split(':');
      if (parts.length != 2) return null;
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null) return null;
      return DateTime(now.year, now.month, now.day, h, m);
    }

    for (final entry in entries) {
      final dt = parseToday(entry.value);
      if (dt != null) {
        final diff = dt.difference(now);
        if (diff.inSeconds <= 0 && diff.inSeconds > -2 && _lastNotifiedPrayer != entry.key) {
          _lastNotifiedPrayer = entry.key;
          if (mounted) {
            setState(() => _activePrayerPopup = entry.key);
            _playAdhan(); 
          }
        }
      }
    }

    DateTime? nextTime;
    String? nextName;
    for (final entry in entries) {
      final dt = parseToday(entry.value);
      if (dt == null) continue;
      if (dt.isAfter(now)) {
        nextTime = dt;
        nextName = entry.key;
        break;
      }
    }
    if (nextTime == null) {
      final fajrDt = parseToday(entries.first.value);
      if (fajrDt != null) {
        nextTime = fajrDt.add(const Duration(days: 1));
        nextName = entries.first.key;
      }
    }

    if (nextTime != null && mounted) {
      setState(() {
        _timeUntilNext = nextTime!.difference(now);
        _nextPrayerName = nextName;
      });
    }
  }

  Future<void> _scheduleNotifications() async {
    if (_times == null) return;
    final now = DateTime.now();
    final entries = _times!.asOrderedList();

    DateTime? parseToday(String hhmm) {
      final parts = hhmm.split(':');
      if (parts.length != 2) return null;
      return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
    }

    for (final entry in entries) {
      final dt = parseToday(entry.value);
      if (dt != null && dt.isAfter(now)) {
        await NotificationService.schedulePrayerNotification(entry.key, dt);
      }
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  IconData _iconFor(String prayer) {
    switch (prayer) {
      case 'Fajr': return Icons.brightness_4;
      case 'Dhuhr': return Icons.wb_sunny;
      case 'Asr': return Icons.wb_twilight;
      case 'Maghrib': return Icons.brightness_5;
      case 'Isha': return Icons.nightlight_round;
      default: return Icons.access_time;
    }
  }

  Future<void> _playAdhan() async {
    try {
      await AdhanService.stopAdhan();
      await Future.delayed(const Duration(milliseconds: 200));

      setState(() => _adhanPlaying = true);
      await AdhanService.playAdhan(_selectedReciter);
      
      AdhanService.onPlayerStateChanged.listen((state) {
        if (!mounted) return;
        if (state == PlayerState.completed || state == PlayerState.stopped) {
          setState(() => _adhanPlaying = false);
        }
      });
    } catch (e) {
      debugPrint('Web Audio Error: $e');
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
                      _buildCustomHeader(context, l10n!, isArabic, themeService),
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              child: _loading
                                  ? _buildLoading(l10n, themeService)
                                  : _error != null
                                      ? _buildError(l10n, themeService)
                                      : _buildContent(l10n, isArabic, themeService),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- IN-APP NOTIFICATION POPUP ---
              if (_activePrayerPopup != null)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: PrayerNotificationPopup(
                      prayerName: _activePrayerPopup!,
                      onDismiss: () {
                        // ONLY closes the UI popup. 
                        // The audio will keep playing undisturbed.
                        if (mounted) {
                          setState(() => _activePrayerPopup = null);
                        }
                      },
                      onStopAdhan: () {
                        // THIS explicitly stops all audio when RED button is clicked
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

  Widget _buildCustomHeader(BuildContext context, AppLocalizations l10n, bool isArabic, ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          // 1. SMART TEST BELL
          IconButton(
            icon: Icon(Icons.notifications_active_outlined, color: Theme.of(context).colorScheme.secondary),
            tooltip: isArabic ? 'تجربة الإشعار' : 'Test Notification',
            onPressed: () async {
              setState(() => _activePrayerPopup = 'Fajr');
              
              if (kIsWeb) {
                const paths = {
                  'mishary': 'adhan/afasiadhan',
                  'nasser': 'adhan/qatamiadhan',
                  'qassas': 'adhan/moqassas',
                  'refaat': 'adhan/refaatadhan',
                  'tobar': 'adhan/adhantobar',
                };
                
                final basePath = paths[_selectedReciter] ?? 'adhan/afasiadhan';
                final fileName = _isWholeAdhan ? '$basePath.mp3' : '${basePath}_takbeer.mp3';

                _webTestPlayer?.stop();
                _webTestPlayer = AudioPlayer();
                await _webTestPlayer!.play(AssetSource(fileName));
              } else {
                await NotificationService.showTestAdhan(
                  reciter: _selectedReciter,
                  isWholeAdhan: _isWholeAdhan, 
                );
              }
            },
          ),
          
          // 2. TITLE
          Expanded(
            child: Text(
              l10n.prayerTimes,
              textAlign: TextAlign.center,
              style: themeService.getTextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          
          // 3. BACK ARROW
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).colorScheme.secondary),
            tooltip: isArabic ? 'رجوع' : 'Back',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(AppLocalizations l10n, ThemeService themeService) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 16),
        Text(
          l10n.fetchingPrayerTimes,
          style: themeService.getTextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildError(AppLocalizations l10n, ThemeService themeService) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
        const SizedBox(height: 16),
        Text(
          l10n.errorLoadingPrayerTimes,
          style: themeService.getTextStyle(
            fontSize: 18,
            color: Colors.redAccent,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _load,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: const Color(0xFF0B3D2E),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: Text(l10n.retry, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildContent(AppLocalizations l10n, bool isArabic, ThemeService themeService) {
    if (_times == null) return const SizedBox.shrink();

    String format12Hour(String time24) {
      // FIX: Strip timezone tags here as well so the UI looks clean
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
    
    // ... rest of the method stays the same

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        children: [
          Text(
            "${GeoTranslations.translate(context, widget.country.name)} - ${GeoTranslations.translate(context, widget.region)}",
            style: themeService.getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildCountdownCard(l10n, isArabic, themeService),
          const SizedBox(height: 24),
          
          // 1. PRAYER TIMES LIST NOW COMES FIRST
          ..._times!.asOrderedList().asMap().entries.map((e) {
            final index = e.key;
            final entry = e.value;
            final isNext = entry.key == _nextPrayerName;
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 80)),
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(offset: Offset(0, (1 - value) * 20), child: child),
                );
              },
              child: _PrayerRow(
                name: _getLocalizedPrayerName(entry.key, l10n),
                time: format12Hour(entry.value),
                icon: _iconFor(entry.key),
                isNext: isNext,
                l10n: l10n,
                isArabic: isArabic,
                themeService: themeService,
              ),
            );
          }),

          // 2. ADHAN SETTINGS MOVED TO THE BOTTOM
          const SizedBox(height: 24),
          _buildAdhanControlPanel(l10n, isArabic, themeService),
        ],
      ),
    );
  }

  String _getLocalizedPrayerName(String name, AppLocalizations l10n) {
    switch (name.toLowerCase()) {
      case 'fajr': return l10n.fajr;
      case 'dhuhr': return l10n.dhuhr;
      case 'asr': return l10n.asr;
      case 'maghrib': return l10n.maghrib;
      case 'isha': return l10n.isha;
      default: return name;
    }
  }

  Widget _buildCountdownCard(AppLocalizations l10n, bool isArabic, ThemeService themeService) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            color: isDark 
                ? const Color(0xFF0B3D2E).withValues(alpha: 0.65)
                : const Color(0xFFE8F3EE).withValues(alpha: 0.75), 
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(
                "${l10n.timeUntil} ${_nextPrayerName != null ? _getLocalizedPrayerName(_nextPrayerName!, l10n) : '--'}",
                style: themeService.getTextStyle(
                  fontSize: 18,
                  color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _timeUntilNext != null ? _formatDuration(_timeUntilNext!) : "--:--:--",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdhanControlPanel(AppLocalizations l10n, bool isArabic, ThemeService themeService) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark 
                ? const Color(0xFF144D32).withValues(alpha: 0.4)
                : const Color(0xFFF0F8F4).withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const AdhanSettingsScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                  ),
                ).then((_) => _loadPreferences());
              },
              icon: const Icon(Icons.settings_rounded, size: 24),
              label: Text(
                isArabic ? 'إعدادات الأذان' : 'Adhan Settings',
                style: themeService.getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: const Color(0xFF0B3D2E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrayerRow extends StatefulWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isNext;
  final AppLocalizations l10n;
  final bool isArabic;
  final ThemeService themeService;

  const _PrayerRow({
    required this.name,
    required this.time,
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
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: widget.isNext
                    ? secondaryColor.withValues(alpha: isDark ? 0.25 : 0.2)
                    : (_isHovered
                        ? (isDark ? const Color(0xFF144D32).withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.9))
                        : (isDark ? const Color(0xFF0B3D2E).withValues(alpha: 0.45) : Colors.white.withValues(alpha: 0.75))),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isNext
                      ? secondaryColor
                      : (_isHovered ? secondaryColor.withValues(alpha: 0.6) : secondaryColor.withValues(alpha: 0.2)),
                  width: widget.isNext ? 2 : 1,
                ),
                boxShadow: widget.isNext
                    ? [
                        BoxShadow(
                          color: secondaryColor.withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isNext
                          ? secondaryColor
                          : secondaryColor.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.isNext
                          ? (isDark ? const Color(0xFF0B3D2E) : Colors.white)
                          : secondaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.name,
                    style: widget.themeService.getTextStyle(
                      fontSize: 18,
                      fontWeight: widget.isNext ? FontWeight.bold : FontWeight.w600,
                      color: widget.isNext
                          ? secondaryColor
                          : AppTheme.getOnBackgroundColor(context),
                    ),
                  ),
                  if (widget.isNext) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: secondaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: secondaryColor.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        widget.isArabic ? 'القادمة' : 'Next',
                        style: widget.themeService.getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    widget.time,
                    style: widget.themeService.getTextStyle(
                      fontSize: 18,
                      fontWeight: widget.isNext ? FontWeight.bold : FontWeight.w500,
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