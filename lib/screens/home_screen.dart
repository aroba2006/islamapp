import 'package:flutter/material.dart';
import 'dart:ui';
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
import '../services/hijri_calendar_service.dart';
import '../models/islamic_event.dart';

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
        title: Text(l10n.ramadan, style: const TextStyle(color: Color(0xFFD4AF37))),
        content: Text(
          l10n.ramadanNotAvailable,
          style: TextStyle(color: Colors.grey[400]),
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
    final authService = Provider.of<AuthService>(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final String userName = authService.userName ?? (isArabic ? 'ضيف' : 'Guest');
    final String? profilePicUrl = authService.profilePicUrl;
    final bool isLoggedIn = authService.isLoggedIn;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final l10n = AppLocalizations.of(context);

        final scaledTitleSize = themeService.getScaledSize(20);
        final scaledDescSize = themeService.getScaledSize(13);

        final titleStyle = Theme.of(context).textTheme.displayLarge?.copyWith(
              color: const Color(0xFFD4AF37),
              fontSize: scaledTitleSize * 2.2,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ) ?? TextStyle(
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
                      // HEADER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OutlinedTextTitle(
                                    text: isArabic ? 'تطبيق إسلامي' : 'Islamy App',
                                    style: titleStyle.copyWith(fontSize: scaledTitleSize * 1.8),
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [
                                        Color(0xFFD4AF37),
                                        Color(0xFFE8C547),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: Text(
                                      isArabic ? 'مرحباً بك، $userName' : 'Welcome back, $userName',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isArabic ? 'رفيقك الإسلامي في حياتك اليومية' : 'Your Islamic companion in daily life',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.65),
                                      fontSize: scaledDescSize * 0.9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () => _navigate(const HijriCalendarScreen()),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFFD4AF37).withValues(alpha: 0.12),
                                            const Color(0xFFD4AF37).withValues(alpha: 0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.calendar_today_rounded, color: Color(0xFFD4AF37), size: 15),
                                          const SizedBox(width: 8),
                                          Text(
                                            _getHijriDateString(context),
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: const Color(0xFFD4AF37),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(Icons.chevron_right_rounded, color: Color(0xFFD4AF37), size: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (nearestEvent != null) ...[
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () => _showEventDetailsDialog(context, nearestEvent),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFFD4AF37).withValues(alpha: 0.18),
                                              const Color(0xFFD4AF37).withValues(alpha: 0.08),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(
                                            color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.event_available_rounded, color: Color(0xFFD4AF37), size: 15),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                isArabic
                                                    ? '${nearestEvent.getName('ar')}\nمتبقي ${nearestEvent.daysUntil()} يوم'
                                                    : '${nearestEvent.getName('en')}\n${nearestEvent.daysUntil()} days left',
                                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                  color: const Color(0xFFD4AF37),
                                                  fontSize: 11,
                                                  height: 1.25,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
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
                            // HEADER BUTTONS
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: isLoggedIn
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                                              blurRadius: 20,
                                              spreadRadius: 4,
                                            ),
                                            BoxShadow(
                                              color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                                              blurRadius: 40,
                                              spreadRadius: 8,
                                            ),
                                          ]
                                        : [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.2),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: isLoggedIn
                                        ? const Color(0xFFD4AF37).withValues(alpha: 0.25)
                                        : const Color(0xFFD4AF37).withValues(alpha: 0.15),
                                    backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl) : null,
                                    child: profilePicUrl == null 
                                        ? Icon(
                                            Icons.person_rounded, 
                                            color: isLoggedIn 
                                                ? const Color(0xFFD4AF37) 
                                                : const Color(0xFFD4AF37).withValues(alpha: 0.5),
                                            size: 22,
                                          ) 
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  icon: const Icon(Icons.settings_rounded, color: Color(0xFFD4AF37), size: 24),
                                  onPressed: _openSettings,
                                  tooltip: l10n.settings,
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: Icon(
                                    isLoggedIn ? Icons.logout_rounded : Icons.login_rounded, 
                                    color: isLoggedIn ? Colors.redAccent : const Color(0xFFD4AF37), 
                                    size: 24
                                  ),
                                  tooltip: isLoggedIn ? (isArabic ? 'تسجيل الخروج' : 'Logout') : (isArabic ? 'تسجيل الدخول' : 'Login'),
                                  onPressed: () async {
                                    if (isLoggedIn) {
                                      final bool? confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (dialogContext) => AlertDialog(
                                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                          title: Text(
                                            isArabic ? 'تأكيد الخروج' : 'Confirm Logout',
                                            style: const TextStyle(color: Color(0xFFD4AF37)),
                                          ),
                                          content: Text(
                                            isArabic 
                                                ? 'هل أنت متأكد من رغبتك في الخروج؟' 
                                                : 'Are you sure you want to log out?',
                                            style: TextStyle(color: Colors.grey[400]),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(dialogContext, false),
                                              child: Text(
                                                isArabic ? 'إلغاء' : 'Cancel',
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(dialogContext, true),
                                              child: Text(
                                                isArabic ? 'نعم، خروج' : 'Yes, Logout',
                                                style: const TextStyle(color: Colors.redAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await authService.signOut();
                                        if (!context.mounted) return;
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                                          (route) => false,
                                        );
                                      }
                                    } else {
                                      _showLoginDialog();
                                    }
                                  },
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // DECORATIVE DIVIDER
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFD4AF37).withValues(alpha: 0),
                                      const Color(0xFFD4AF37).withValues(alpha: 0.4),
                                      const Color(0xFFD4AF37).withValues(alpha: 0),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Icon(
                                Icons.star_border_rounded,
                                size: 16,
                                color: const Color(0xFFD4AF37).withValues(alpha: 0.85),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFD4AF37).withValues(alpha: 0),
                                      const Color(0xFFD4AF37).withValues(alpha: 0.4),
                                      const Color(0xFFD4AF37).withValues(alpha: 0),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // CARDS GRID (Stable version)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildCard(
                              index: 0,
                              icon: Icons.access_time_filled,
                              title: l10n.prayerTimes,
                              description: l10n.prayerTimesDesc,
                              onTap: () => _navigate(const CountrySelectionScreen()),
                            ),
                            _buildCard(
                              index: 1,
                              icon: Icons.auto_stories_rounded,
                              title: l10n.quranTitle,
                              description: l10n.quranDesc,
                              onTap: () => _navigate(const QuranScreen()),
                            ),
                            _buildCard(
                              index: 2,
                              icon: Icons.favorite_rounded,
                              title: l10n.azkarTitle,
                              description: l10n.azkarDesc,
                              onTap: () => _navigate(const AzkarScreen()),
                            ),
                            _buildCard(
                              index: 3,
                              icon: Icons.front_hand,
                              title: l10n.duaaTitle,
                              description: l10n.duaaDesc,
                              onTap: () => _navigate(const DuaaScreen()),
                            ),
                            _buildCard(
                              index: 4,
                              icon: Icons.favorite_rounded,
                              title: l10n.goodDeedsTitle,
                              description: l10n.goodDeedsDesc,
                              onTap: () => _navigate(const GoodDeedsScreen()),
                            ),
                            _buildCard(
                              index: 5,
                              icon: Icons.flag_rounded,
                              title: l10n.goalsTitle,
                              description: l10n.goalsDesc,
                              onTap: () => _navigate(const IslamicGoalsScreen()),
                            ),
                            _buildCard(
                              index: 6,
                              icon: Icons.compass_calibration_rounded,
                              title: l10n.qiblahFinderTitle,
                              description: l10n.qiblahFinderDesc,
                              onTap: () => _navigate(const QiblahFinderScreen()),
                            ),
                            _buildCard(
                              index: 7,
                              icon: Icons.location_on_rounded,
                              title: l10n.nearestMosqueTitle,
                              description: l10n.nearestMosqueDesc,
                              onTap: () => _navigate(const MosqueFinderScreen()),
                            ),
                            _buildCard(
                              index: 8,
                              icon: Icons.quiz_rounded,
                              title: l10n.quizTitle,
                              description: l10n.quizDesc,
                              onTap: () => _navigate(const QuizScreen()),
                            ),
                            _buildCard(
                              index: 9,
                              icon: Icons.person_rounded,
                              title: l10n.prophetBioTitle,
                              description: l10n.prophetBioDesc,
                              onTap: () => _navigate(const ProphetBiographyScreen()),
                            ),
                            _buildCard(
                              index: 10,
                              icon: Icons.book_rounded,
                              title: l10n.hadithsTitle,
                              description: l10n.hadithsDesc,
                              onTap: () => _navigate(const HadithsScreen()),
                            ),
                            _buildCard(
                              index: 11,
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
                          ],
                        ),
                      ),
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

  // SIMPLE STABLE CARD BUILDER
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
            borderRadius: BorderRadius.circular(28),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
                    Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: isEnabled ? 0.4 : 0.15),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFD4AF37).withValues(alpha: 0.15),
                            const Color(0xFFD4AF37).withValues(alpha: 0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: const Color(0xFFD4AF37),
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFFD4AF37),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7),
                      fontSize: 14,
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