import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/adhan_service.dart';
import '../services/notification_service.dart';
import '../services/theme_service.dart' show ThemeService, AppThemeMode, TextScaleFactor;
import '../app_theme.dart';
import '../widgets/islamic_pattern_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/adhan_reciter_translations.dart';
// Add this to your existing imports

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedReciter;
  late String _selectedLanguage;
  bool _notificationsEnabled = true;
  bool _adhanPlaying = false;
  late Duration _notificationAdhanDuration;

  final List<Duration> _durationOptions = const [
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 30),
    Duration(minutes: 5), // Whole Adhan
  ];

  @override
  void initState() {
    super.initState();
    _selectedReciter = 'mishary';
    _selectedLanguage = 'ar';
    _notificationAdhanDuration = const Duration(seconds: 30);
    _loadSavedSettings();
    _loadNotificationState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedReciter = prefs.getString('adhanReciter') ?? 'mishary';
      _selectedLanguage = prefs.getString('locale') ?? 'ar';
      
      final durationSeconds = prefs.getInt('notificationAdhanDuration') ?? 30;
      _notificationAdhanDuration = Duration(seconds: durationSeconds);
    });
  }

  Future<void> _loadNotificationState() async {
    setState(() {
      _notificationsEnabled = NotificationService.areNotificationsEnabled();
    });
  }

  Future<void> _selectDuration(Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notificationAdhanDuration', duration.inSeconds);
    
    setState(() {
      _notificationAdhanDuration = duration;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLanguage = Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = _selectedLanguage == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, l10n, isArabic),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0B3D2E).withValues(alpha: 0.7)
                                : const Color(0xFFF0F8F4).withValues(alpha: 0.7),
                            border: Border(
                              top: BorderSide(
                                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
                            children: [
                              _buildThemeSection(context, l10n),
                              const SizedBox(height: 32),
                              _buildTextScaleSection(context, l10n),
                              const SizedBox(height: 32),
                              _buildLanguageSection(context, l10n),
                              const SizedBox(height: 32),
                              _buildAdhanSection(context, l10n),
                              const SizedBox(height: 32),
                              _buildNotificationDurationSection(context),
                              const SizedBox(height: 32),
                              _buildNotificationSection(context, l10n),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              l10n.settings,
              textAlign: TextAlign.center,
              style: isArabic
                  ? GoogleFonts.amiri(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    )
                  : GoogleFonts.arefRuqaa(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  /// ── THEME SECTION ──
  Widget _buildThemeSection(BuildContext context, AppLocalizations l10n) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.brightness_4_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  _getThemeLabel(l10n),
                  style: GoogleFonts.elMessiri(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getOnBackgroundColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ThemeOptionCard(
              label: _getSystemDefaultLabel(l10n),
              isSelected: themeService.themeMode == AppThemeMode.system,
              onTap: () => themeService.setThemeMode(AppThemeMode.system),
              icon: Icons.brightness_auto_rounded,
            ),
            const SizedBox(height: 12),
            _ThemeOptionCard(
              label: _getLightModeLabel(l10n),
              isSelected: themeService.themeMode == AppThemeMode.light,
              onTap: () => themeService.setThemeMode(AppThemeMode.light),
              icon: Icons.brightness_7_rounded,
            ),
            const SizedBox(height: 12),
            _ThemeOptionCard(
              label: _getDarkModeLabel(l10n),
              isSelected: themeService.themeMode == AppThemeMode.dark,
              onTap: () => themeService.setThemeMode(AppThemeMode.dark),
              icon: Icons.brightness_4_rounded,
            ),
          ],
        );
      },
    );
  }

  /// ── TEXT SCALE SECTION (SEGMENTED SLIDER) ──
  Widget _buildTextScaleSection(BuildContext context, AppLocalizations l10n) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final lang = Localizations.localeOf(context).languageCode;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.text_fields_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  _getTextScaleLabel(lang),
                  style: GoogleFonts.elMessiri(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getOnBackgroundColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _FontSizeSlider(
              current: themeService.textScaleFactor,
              language: lang,
              onChanged: themeService.setTextScaleFactor,
            ),
          ],
        );
      },
    );
  }

  // Theme translation helpers
  String _getThemeLabel(AppLocalizations l10n) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'ar') return 'المظهر';
    if (lang == 'fr') return 'Thème';
    return 'Theme';
  }

  String _getTextScaleLabel(String lang) {
    if (lang == 'ar') return 'حجم النص';
    if (lang == 'fr') return 'Taille du texte';
    return 'Text Size';
  }

  String _getSystemDefaultLabel(AppLocalizations l10n) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'ar') return 'النظام الافتراضي';
    if (lang == 'fr') return 'Par défaut du système';
    return 'System Default';
  }

  String _getLightModeLabel(AppLocalizations l10n) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'ar') return 'وضع فاتح';
    if (lang == 'fr') return 'Mode clair';
    return 'Light Mode';
  }

  String _getDarkModeLabel(AppLocalizations l10n) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'ar') return 'وضع مظلم';
    if (lang == 'fr') return 'Mode sombre';
    return 'Dark Mode';
  }

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.language_rounded, color: Theme.of(context).colorScheme.secondary, size: 24),
            const SizedBox(width: 12),
            Text(
              l10n.language,
              style: GoogleFonts.elMessiri(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.getOnBackgroundColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InteractiveOptionCard(
          label: l10n.arabic,
          isSelected: _selectedLanguage == 'ar',
          onTap: () {
            setState(() => _selectedLanguage = 'ar');
            IslamicApp.of(context)?.setLocale('ar');
          },
        ),
        const SizedBox(height: 12),
        _InteractiveOptionCard(
          label: l10n.english,
          isSelected: _selectedLanguage == 'en',
          onTap: () {
            setState(() => _selectedLanguage = 'en');
            IslamicApp.of(context)?.setLocale('en');
          },
        ),
        const SizedBox(height: 12),
        _InteractiveOptionCard(
          label: l10n.french,
          isSelected: _selectedLanguage == 'fr',
          onTap: () {
            setState(() => _selectedLanguage = 'fr');
            IslamicApp.of(context)?.setLocale('fr');
          },
        ),
      ],
    );
  }

  Widget _buildAdhanSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.mosque_rounded, color: Theme.of(context).colorScheme.secondary, size: 24),
            const SizedBox(width: 12),
            Text(
              l10n.adhan,
              style: GoogleFonts.elMessiri(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.getOnBackgroundColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.selectAdhanReciter,
          style: GoogleFonts.elMessiri(
            fontSize: 16,
            color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 16),
        _InteractiveOptionCard(
          label: AdhanReciterTranslations.getReciterName('mishary', _selectedLanguage),
          isSelected: _selectedReciter == 'mishary',
          onTap: () => _updateReciter('mishary'),
        ),
        const SizedBox(height: 12),
        _InteractiveOptionCard(
          label: AdhanReciterTranslations.getReciterName('nasser', _selectedLanguage),
          isSelected: _selectedReciter == 'nasser',
          onTap: () => _updateReciter('nasser'),
        ),
        const SizedBox(height: 12),
        _InteractiveOptionCard(
          label: AdhanReciterTranslations.getReciterName('qassas', _selectedLanguage),
          isSelected: _selectedReciter == 'qassas',
          onTap: () => _updateReciter('qassas'),
        ),
        const SizedBox(height: 12),
        _InteractiveOptionCard(
          label: AdhanReciterTranslations.getReciterName('refaat', _selectedLanguage),
          isSelected: _selectedReciter == 'refaat',
          onTap: () => _updateReciter('refaat'),
        ),
        const SizedBox(height: 12),
        _InteractiveOptionCard(
          label: AdhanReciterTranslations.getReciterName('tobar', _selectedLanguage),
          isSelected: _selectedReciter == 'tobar',
          onTap: () => _updateReciter('tobar'),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _adhanPlaying ? null : () => _playAdhan(l10n),
                icon: const Icon(Icons.play_arrow_rounded, size: 24),
                label: Text(l10n.playAdhan, style: GoogleFonts.elMessiri(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: const Color(0xFF0B3D2E),
                  disabledBackgroundColor: Colors.black.withValues(alpha: 0.3),
                  disabledForegroundColor: Colors.white54,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _adhanPlaying ? () => _stopAdhan() : null,
                icon: const Icon(Icons.stop_rounded, size: 24),
                label: Text(l10n.stop, style: GoogleFonts.elMessiri(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.black.withValues(alpha: 0.3),
                  disabledForegroundColor: Colors.white54,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _updateReciter(String reciterId) {
    setState(() => _selectedReciter = reciterId);
    IslamicApp.of(context)?.setAdhanReciter(reciterId);
  }

 /// ── NEW: NOTIFICATION ADHAN DURATION SECTION ──
  Widget _buildNotificationDurationSection(BuildContext context) {
    final lang = _selectedLanguage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.timer_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              lang == 'ar' ? 'مدة الأذان في الإشعار' : (lang == 'fr' ? 'Durée de l\'Adhan' : 'Adhan Duration'),
              style: GoogleFonts.elMessiri(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.getOnBackgroundColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          lang == 'ar'
              ? 'اختر مدة تشغيل الأذان عند استلام الإشعار'
              : (lang == 'fr' ? 'Choisissez la durée de lecture de l\'adhan' : 'Choose how long the adhan plays when notification arrives'),
          style: GoogleFonts.elMessiri(
            fontSize: 14,
            color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        ..._durationOptions.map((duration) {
          String label;
          if (duration.inMinutes >= 5) {
            label = lang == 'ar' ? 'الأذان كاملاً' : (lang == 'fr' ? 'Adhan complet' : 'Whole Adhan');
          } else {
            if (lang == 'ar') {
              // Proper Arabic grammar rules for plural vs singular
              label = duration.inSeconds <= 10 
                  ? '${duration.inSeconds} ثوان' 
                  : '${duration.inSeconds} ثانية';
            } else {
              label = '${duration.inSeconds} sec';
            }
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _InteractiveOptionCard(
              label: label,
              isSelected: _notificationAdhanDuration == duration,
              onTap: () => _selectDuration(duration),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_active_rounded, color: Theme.of(context).colorScheme.secondary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              l10n.adhanNotifications,
              style: GoogleFonts.elMessiri(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.getOnBackgroundColor(context),
              ),
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (value) async {
              // Update local state
              setState(() => _notificationsEnabled = value);

              // Persist to NotificationService (which saves to SharedPreferences)
              await NotificationService.setNotificationsEnabled(value);

              // Show confirmation snackbar
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value 
                        ? 'الإشعارات مفعلة' 
                        : 'الإشعارات معطلة',
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: value ? Colors.green : Colors.orange,
                  ),
                );
              }
            },
            activeThumbColor: Theme.of(context).colorScheme.secondary,
            activeTrackColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.black.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Future<void> _playAdhan(AppLocalizations l10n) async {
    try {
      await AdhanService.stopAdhan();
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _adhanPlaying = true);
      await AdhanService.playAdhan(_selectedReciter);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.errorMessage}: $e',
              style: GoogleFonts.elMessiri(),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() => _adhanPlaying = false);
      }
    }
  }

  Future<void> _stopAdhan() async {
    try {
      await AdhanService.stopAdhan();
      setState(() => _adhanPlaying = false);
    } catch (e) {}
  }
}

/// ── FONT SIZE SLIDER (3-segment toggle) ──
class _FontSizeSlider extends StatefulWidget {
  final TextScaleFactor current;
  final String language;
  final ValueChanged<TextScaleFactor> onChanged;

  const _FontSizeSlider({
    required this.current,
    required this.language,
    required this.onChanged,
  });

  @override
  State<_FontSizeSlider> createState() => _FontSizeSliderState();
}

class _FontSizeSliderState extends State<_FontSizeSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _thumbCtrl;
  late Animation<double> _thumbAnim;
  int _prevIndex = 1;

  static const _scales = [
    TextScaleFactor.small,
    TextScaleFactor.medium,
    TextScaleFactor.large,
  ];

  int get _currentIndex => _scales.indexOf(widget.current);

  String _label(TextScaleFactor s) {
    final lang = widget.language;
    switch (s) {
      case TextScaleFactor.small:
        return lang == 'ar' ? 'صغير' : (lang == 'fr' ? 'Petit' : 'Small');
      case TextScaleFactor.medium:
        return lang == 'ar' ? 'عادي' : (lang == 'fr' ? 'Moyen' : 'Medium');
      case TextScaleFactor.large:
        return lang == 'ar' ? 'كبير' : (lang == 'fr' ? 'Grand' : 'Large');
    }
  }

  @override
  void initState() {
    super.initState();
    _prevIndex = _currentIndex;
    _thumbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _thumbAnim = Tween<double>(
      begin: _currentIndex.toDouble(),
      end: _currentIndex.toDouble(),
    ).animate(CurvedAnimation(parent: _thumbCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(_FontSizeSlider old) {
    super.didUpdateWidget(old);
    if (old.current != widget.current) {
      _thumbAnim = Tween<double>(
        begin: _prevIndex.toDouble(),
        end: _currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _thumbCtrl, curve: Curves.easeOutCubic));
      _thumbCtrl.forward(from: 0);
      _prevIndex = _currentIndex;
    }
  }

  @override
  void dispose() {
    _thumbCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gold = Theme.of(context).colorScheme.secondary;

    return Column(
      children: [
        // Preview row – shows three "A" letters at each size
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // For Arabic RTL, reverse the visual order of sizes
            _SizePreviewLetter(
              size: widget.language == 'ar' ? 28 : 14,
              active: _currentIndex == (widget.language == 'ar' ? 2 : 0),
            ),
            const SizedBox(width: 12),
            _SizePreviewLetter(size: 20, active: _currentIndex == 1),
            const SizedBox(width: 12),
            _SizePreviewLetter(
              size: widget.language == 'ar' ? 14 : 28,
              active: _currentIndex == (widget.language == 'ar' ? 0 : 2),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Pill track with animated sliding thumb
        LayoutBuilder(
          builder: (context, constraints) {
            final trackW = constraints.maxWidth;
            final segW = trackW / 3;
            final thumbW = segW - 8;
            return GestureDetector(
              onTapDown: (d) {
                var tappedSeg = (d.localPosition.dx / segW).floor().clamp(0, 2);
                widget.onChanged(_scales[tappedSeg]);
              },
              onHorizontalDragUpdate: (d) {
                var seg = (d.localPosition.dx / segW).floor().clamp(0, 2);
                if (_scales[seg] != widget.current) {
                  widget.onChanged(_scales[seg]);
                }
              },
              child: Container(
                height: 56,
                width: trackW,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: isDark
                      ? const Color(0xFF0B3D2E).withValues(alpha: 0.7)
                      : const Color(0xFFE8F3EE),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated gold thumb
                    AnimatedBuilder(
                      animation: _thumbAnim,
                      builder: (context, _) {
                        final thumbIndex = widget.language == 'ar' 
                            ? 2 - _thumbAnim.value 
                            : _thumbAnim.value;
                        final left = widget.language == 'ar'
                            ? 4 + (2 - thumbIndex) * segW
                            : 4 + thumbIndex * segW;
                        return Positioned(
                          left: left,
                          child: Container(
                            width: thumbW,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFD4AF37), Color(0xFFB5952F)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Labels row
                    Row(
                      children: widget.language == 'ar'
                          ? List.generate(3, (i) {
                              final scaleIndex = widget.language == 'ar' ? 2 - i : i;
                              final isActive = _currentIndex == scaleIndex;
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    _label(_scales[scaleIndex]),
                                    style: GoogleFonts.elMessiri(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? Colors.white
                                          : (isDark
                                              ? Colors.white.withValues(alpha: 0.55)
                                              : const Color(0xFF1B5E3F).withValues(alpha: 0.65)),
                                    ),
                                  ),
                                ),
                              );
                            }).toList()
                          : List.generate(3, (i) {
                              final scaleIndex = i;
                              final isActive = _currentIndex == scaleIndex;
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    _label(_scales[scaleIndex]),
                                    style: GoogleFonts.elMessiri(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? Colors.white
                                          : (isDark
                                              ? Colors.white.withValues(alpha: 0.55)
                                              : const Color(0xFF1B5E3F).withValues(alpha: 0.65)),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SizePreviewLetter extends StatelessWidget {
  final double size;
  final bool active;
  const _SizePreviewLetter({required this.size, required this.active});

  @override
  Widget build(BuildContext context) {
    final gold = Theme.of(context).colorScheme.secondary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 250),
      style: GoogleFonts.elMessiri(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: active
            ? gold
            : (isDark
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.2)),
      ),
      child: const Text('A'),
    );
  }
}

/// ── THEME OPTION CARD ──
class _ThemeOptionCard extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  const _ThemeOptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  State<_ThemeOptionCard> createState() => _ThemeOptionCardState();
}

class _ThemeOptionCardState extends State<_ThemeOptionCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.97),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: widget.isSelected || _isHovered
                  ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15)
                  : isDark
                      ? const Color(0xFF144D32).withValues(alpha: 0.5)
                      : const Color(0xFFE8F3EE).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected || _isHovered
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                width: widget.isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.5),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: GoogleFonts.elMessiri(
                      fontSize: 18,
                      fontWeight: widget.isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: widget.isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : AppTheme.getOnBackgroundColor(context),
                    ),
                  ),
                ),
                if (widget.isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ── INTERACTIVE OPTION CARD (RADIO BUTTON) ──
class _InteractiveOptionCard extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InteractiveOptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_InteractiveOptionCard> createState() => _InteractiveOptionCardState();
}

class _InteractiveOptionCardState extends State<_InteractiveOptionCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.97),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: widget.isSelected || _isHovered
                  ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15)
                  : isDark
                      ? const Color(0xFF144D32).withValues(alpha: 0.5)
                      : const Color(0xFFE8F3EE).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected || _isHovered
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                width: widget.isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: widget.isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.5),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: GoogleFonts.elMessiri(
                      fontSize: 18,
                      fontWeight: widget.isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: widget.isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : AppTheme.getOnBackgroundColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}