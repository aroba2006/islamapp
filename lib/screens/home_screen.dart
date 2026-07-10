import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../widgets/outlined_text_widget.dart';
import '../l10n/app_localizations.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
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
import 'ramadan_mode_screen.dart';
import 'hijri_calendar_screen.dart';
import '../services/hijri_calendar_service.dart';
import '../models/islamic_event.dart'; // <-- MUST HAVE THIS IMPORT

// ============================================================
//   H O M E   S C R E E N   (StatefulWidget)
// ============================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late bool _isRamadan;
  late int _ramadanCountdown;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _updateIslamicInfo();

    final hijri = HijriCalendarService.gregorianToHijri(DateTime.now());
    debugPrint('=== Islamic Info ===');
    debugPrint('Hijri Date: ${hijri.day}/${hijri.month}/${hijri.year}');
    debugPrint('Is Ramadan: $_isRamadan');
    debugPrint('Days until Ramadan: $_ramadanCountdown');
    debugPrint('===================');
  }

  void _updateIslamicInfo() {
    setState(() {
      _isRamadan = HijriCalendarService.isCurrentlyRamadan();
      _ramadanCountdown = HijriCalendarService.daysUntilRamadan();
    });
  }

  String _getHijriDateString(BuildContext context) {
    final hijri = HijriCalendarService.gregorianToHijri(DateTime.now());
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

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

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _navigate(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => screen,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(opacity: curved, child: child);
        },
      ),
    );
  }

  void _openSettings() {
    _navigate(const SettingsScreen());
  }

  void _showRamadanNotAvailableDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(l10n.ramadan, style: const TextStyle(color: Color(0xFFD4AF37))),
        content: Text(
          l10n.ramadanNotAvailable,
          style: GoogleFonts.elMessiri(fontSize: 16, color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close, style: const TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
    );
  }

  void _showEventDetailsDialog(BuildContext context, IslamicEvent event) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          event.getName(isArabic ? 'ar' : 'en'),
          style: const TextStyle(color: Color(0xFFD4AF37)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.getDescription(isArabic ? 'ar' : 'en'),
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'التاريخ: ${event.hijriDay}/${event.hijriMonth} هـ'
                  : 'Date: ${event.hijriDay}/${event.hijriMonth} AH',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            if (event.isHoliday)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isArabic ? 'يوم عطلة' : 'Holiday',
                  style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context).close,
              style: const TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final l10n = AppLocalizations.of(context);
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';

        final cardHeight = switch (themeService.textScaleFactor) {
          TextScaleFactor.small => 190.0,
          TextScaleFactor.medium => 215.0,
          TextScaleFactor.large => 250.0,
        };

        final scaledTitleSize = themeService.getScaledSize(44);
        final scaledDescSize = themeService.getScaledSize(16);

        final titleStyle = isArabic
            ? GoogleFonts.amiri(
                color: const Color(0xFFD4AF37),
                fontSize: scaledTitleSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              )
            : GoogleFonts.arefRuqaa(
                color: const Color(0xFFD4AF37),
                fontSize: scaledTitleSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              );

        final nearestEvent = IslamicEventsService.getNearestEvent();

        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeCtrl,
                child: Column(
                  children: [
 // ========== HEADER ==========
    Container(
      width: double.infinity, // Forces the Row to fit exactly inside the screen
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings button (Now it's the first child!)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_rounded, color: Color(0xFFD4AF37), size: 24),
              onPressed: _openSettings,
              tooltip: l10n.settings,
            ),
          ),
          const SizedBox(width: 12), // Space between the icon and the text
          
          // Text Column wrapped in Expanded to take up the remaining space safely
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedTextTitle(
                  text: isArabic ? 'تطبيق إسلامي' : 'Islamy App',
                  style: titleStyle.copyWith(fontSize: scaledTitleSize * 0.9),
                ),
                Text(
                  isArabic ? 'رفيقك الإسلامي في حياتك اليومية' : 'Your Islamic companion in daily life',
                  style: GoogleFonts.elMessiri(
                    color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
                    fontSize: scaledDescSize * 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                // Hijri date (clickable)
                GestureDetector(
                  onTap: () => _navigate(const HijriCalendarScreen()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_rounded, color: const Color(0xFFD4AF37), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          _getHijriDateString(context),
                          style: GoogleFonts.elMessiri(
                            color: const Color(0xFFD4AF37),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.chevron_right_rounded, color: const Color(0xFFD4AF37), size: 16),
                      ],
                    ),
                  ),
                ),
                // Nearest event
                if (nearestEvent != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _showEventDetailsDialog(context, nearestEvent),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event_available_rounded, color: Color(0xFFD4AF37), size: 14),
                          const SizedBox(width: 6),
                          Text(
                            isArabic
                                ? '${nearestEvent.getName('ar')} - متبقي ${nearestEvent.daysUntil()} يوم'
                                : '${nearestEvent.getName('en')} - ${nearestEvent.daysUntil()} days left',
                            style: GoogleFonts.elMessiri(
                              color: const Color(0xFFD4AF37),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),

                    // ========== DIVIDER ==========
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(
                              Icons.star_border_rounded,
                              size: 16,
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.8),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ========== GRID ==========
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: GridView(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 350,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              mainAxisExtent: cardHeight,
                            ),
                            children: [
                              // ---- All cards ----
                              _AnimatedCardWrapper(
                                index: 0,
                                child: _GlassCard(
                                  icon: Icons.access_time_filled,
                                  title: l10n.prayerTimes,
                                  description: l10n.prayerTimesDesc,
                                  onTap: () => _navigate(const CountrySelectionScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 1,
                                child: _GlassCard(
                                  icon: Icons.auto_stories_rounded,
                                  title: l10n.quranTitle,
                                  description: l10n.quranDesc,
                                  onTap: () => _navigate(const QuranScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 2,
                                child: _GlassCard(
                                  icon: Icons.favorite_rounded,
                                  title: l10n.azkarTitle,
                                  description: l10n.azkarDesc,
                                  onTap: () => _navigate(const AzkarScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 3,
                                child: _GlassCard(
                                  icon: Icons.front_hand,
                                  title: l10n.duaaTitle,
                                  description: l10n.duaaDesc,
                                  onTap: () => _navigate(const DuaaScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 4,
                                child: _GlassCard(
                                  icon: Icons.favorite_rounded,
                                  title: l10n.goodDeedsTitle,
                                  description: l10n.goodDeedsDesc,
                                  onTap: () => _navigate(const GoodDeedsScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 5,
                                child: _GlassCard(
                                  icon: Icons.flag_rounded,
                                  title: l10n.goalsTitle,
                                  description: l10n.goalsDesc,
                                  onTap: () => _navigate(const IslamicGoalsScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 6,
                                child: _GlassCard(
                                  icon: Icons.compass_calibration_rounded,
                                  title: l10n.qiblahFinderTitle,
                                  description: l10n.qiblahFinderDesc,
                                  onTap: () => _navigate(const QiblahFinderScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 7,
                                child: _GlassCard(
                                  icon: Icons.location_on_rounded,
                                  title: l10n.nearestMosqueTitle,
                                  description: l10n.nearestMosqueDesc,
                                  onTap: () => _navigate(const MosqueFinderScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 8,
                                child: _GlassCard(
                                  icon: Icons.quiz_rounded,
                                  title: l10n.quizTitle,
                                  description: l10n.quizDesc,
                                  onTap: () => _navigate(const QuizScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 9,
                                child: _GlassCard(
                                  icon: Icons.person_rounded,
                                  title: l10n.prophetBioTitle,
                                  description: l10n.prophetBioDesc,
                                  onTap: () => _navigate(const ProphetBiographyScreen()),
                                  isEnabled: true,
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 10,
                                child: _GlassCard(
                                  icon: Icons.favorite_rounded,
                                  title: l10n.ramadan,
                                  description: _isRamadan
                                      ? l10n.ramadanActiveDesc
                                      : l10n.ramadanInactiveDesc.replaceFirst('%d', _ramadanCountdown.toString()),
                                  onTap: _isRamadan
                                      ? () => _navigate(const RamadanModeScreen())
                                      : () => _showRamadanNotAvailableDialog(context),
                                  isEnabled: _isRamadan,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

// ============================================================
//   R E U S A B L E   W I D G E T S
// ============================================================

class _AnimatedCardWrapper extends StatelessWidget {
  final Widget child;
  final int index;

  const _AnimatedCardWrapper({required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _GlassCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool isEnabled;

  const _GlassCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  State<_GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<_GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final scaledCardTitleSize = themeService.getScaledSize(20);
        final scaledCardDescSize = themeService.getScaledSize(13);

        final opacity = widget.isEnabled ? 1.0 : 0.5;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isHovered = true),
            onTapUp: (_) => setState(() => _isHovered = false),
            onTapCancel: () => setState(() => _isHovered = false),
            onTap: widget.isEnabled ? widget.onTap : null,
            child: Opacity(
              opacity: opacity,
              child: AnimatedScale(
                scale: (_isHovered && widget.isEnabled) ? 0.98 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutBack,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _isHovered && widget.isEnabled
                            ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.85)
                            : Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: _isHovered && widget.isEnabled
                              ? const Color(0xFFD4AF37).withValues(alpha: 0.8)
                              : const Color(0xFFD4AF37).withValues(alpha: 0.2),
                          width: (_isHovered && widget.isEnabled) ? 2 : 1,
                        ),
                        boxShadow: [
                          if (_isHovered && widget.isEnabled)
                            BoxShadow(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                              blurRadius: 30,
                              spreadRadius: 5,
                            )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _isHovered && widget.isEnabled
                                      ? [const Color(0xFFD4AF37), const Color(0xFFB5952F)]
                                      : [
                                          const Color(0xFFD4AF37).withValues(alpha: 0.1),
                                          const Color(0xFFD4AF37).withValues(alpha: 0.05),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD4AF37)
                                      .withValues(alpha: (_isHovered && widget.isEnabled) ? 1.0 : 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                widget.icon,
                                color: _isHovered && widget.isEnabled
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : const Color(0xFFD4AF37),
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.elMessiri(
                              color: _isHovered && widget.isEnabled
                                  ? AppTheme.getOnBackgroundColor(context)
                                  : const Color(0xFFD4AF37),
                              fontSize: scaledCardTitleSize,
                              fontWeight: FontWeight.bold,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              widget.description,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.elMessiri(
                                color: AppTheme.getOnBackgroundColor(context)
                                    .withValues(alpha: (_isHovered && widget.isEnabled) ? 0.9 : 0.6),
                                fontSize: scaledCardDescSize,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}