import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/adhan_service.dart';
import '../services/notification_service.dart';
import '../services/theme_service.dart'
    show ThemeService, AppThemeMode, TextScaleFactor;
import '../app_theme.dart';
import '../widgets/islamic_pattern_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/adhan_reciter_translations.dart';
import '../services/auth_service.dart';
import '../services/quran_reciter_service.dart';
import '../services/reciter_preferences.dart';


// ═══════════════════════════════════════════════════════════════════════
// SETTINGS SCREEN
// ═══════════════════════════════════════════════════════════════════════

class SettingsScreen extends StatefulWidget {
  final int initialTab;

  const SettingsScreen({super.key, this.initialTab = 1});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late String _selectedLanguage;
  late String _selectedFont;
  late TabController _tabController;
  late AnimationController _animationController;
  QuranReciter? _defaultReciter;

  final Map<String, String> _fontOptions = const {
    'amiri': 'Amiri (أميري)',
    'elMessiri': 'El Messiri (المسيري)',
    'arefRuqaa': 'Aref Ruqaa (عارف رقعة)',
    'cairo': 'Cairo (القاهرة)',
    'tajawal': 'Tajawal (تجول)',
    'almarai': 'Almarai (المراعي)',
    'reemKufi': 'Reem Kufi (ريم كوفي)',
    'changa': 'Changa (تشانجا)',
    'lateef': 'Lateef (لطيف)',
    'ibmPlexSansArabic': 'IBM Plex (آي بي إم)',
    'readexPro': 'Readex Pro (ريدكس برو)',
    'rakkas': 'Rakkas (رقاص)',
    'kufam': 'Kufam (كوفام)',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _animationController.forward(from: 0.0);
      }
    });

    _selectedLanguage = 'ar';
    _selectedFont = 'amiri';
    _loadSavedSettings();
    _loadDefaultReciter();
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _selectedLanguage = prefs.getString('locale') ?? 'ar';
      _selectedFont = prefs.getString('fontFamily') ?? 'amiri';
    });
  }

  Future<void> _loadDefaultReciter() async {
    final reciter = await QuranReciterService.getDefaultReciter();
    if (!mounted) return;
    setState(() => _defaultReciter = reciter);
  }

  Future<void> _setDefaultReciter(QuranReciter reciter) async {
    
    await QuranReciterService.setDefaultReciter(reciter.id);
    if (!mounted) return;
    setState(() => _defaultReciter = reciter);
  }

  Future<void> _updateFont(String fontKey) async {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    await themeService.setFontFamily(fontKey);
    if (!mounted) return;
    setState(() => _selectedFont = fontKey);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLanguage = Localizations.localeOf(context).languageCode;
  }

  void _showAboutApp(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final isArabic = langCode == 'ar';
    final isFrench = langCode == 'fr';

    showAboutDialog(
      context: context,
      applicationName: isArabic
          ? 'تطبيق إسلامي'
          : (isFrench ? 'Application Islamique' : 'Islamy App'),
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.mosque_rounded, size: 40, color: Colors.white),
      ),
      applicationLegalese: '© 2026 Abdullah Hesham. All rights reserved.',
      children: [
        const SizedBox(height: 16),
        Text(
          isArabic
              ? 'رفيقك الإسلامي الشامل في حياتك اليومية. يوفّر لك مواقيت الصلاة، القرآن الكريم، الأذان، والأدعية في تطبيق واحد أنيق ومتكامل.'
              : 'Your comprehensive Islamic companion for everyday life — prayer times, the Holy Quran, adhan, and supplications, all in one elegant app.',
          style: TextStyle(
            color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.8),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = _selectedLanguage == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String profileLabel = isArabic
        ? 'الملف الشخصي'
        : (_selectedLanguage == 'fr' ? 'Profil' : 'Profile');
    final String systemLabel = isArabic
        ? 'النظام'
        : (_selectedLanguage == 'fr' ? 'Système' : 'System');

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, l10n, isArabic, themeService),
                  _buildTabBar(
                      context, themeService, profileLabel, systemLabel, isDark),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildProfileTab(
                            context, l10n, isArabic, isDark, themeService),
                        _buildSystemTab(
                            context, l10n, isArabic, isDark, themeService),
                      ],
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

  Widget _buildTabBar(
      BuildContext context,
      ThemeService themeService,
      String profileLabel,
      String systemLabel,
      bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0B3D2E).withValues(alpha: 0.55)
            : const Color(0xFFF0F8F4).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.secondary,
        unselectedLabelColor:
            AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.55),
        indicator: BoxDecoration(
          color:
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(6),
        dividerColor: Colors.transparent,
        labelStyle: themeService.getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: themeService.getTextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_outline_rounded, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    profileLabel,
                    overflow: TextOverflow.ellipsis,
                    style: themeService.getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Tab(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tune_rounded, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    systemLabel,
                    overflow: TextOverflow.ellipsis,
                    style: themeService.getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n,
      bool isArabic, ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  l10n.settings,
                  textAlign: TextAlign.center,
                  style: themeService
                      .getTextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                      .copyWith(
                        fontFamily:
                            Theme.of(context).textTheme.bodyLarge?.fontFamily,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  isArabic
                      ? 'خصِّص تجربتك الروحية بالكامل'
                      : 'Personalize your spiritual experience',
                  textAlign: TextAlign.center,
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    letterSpacing: 0.5,
                    color: AppTheme.getOnBackgroundColor(context)
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          _GlassIconButton(
            icon: Icons.help_outline_rounded,
            onTap: () => _showAboutApp(context),
          ),
        ],
      ),
    );
  }

  BoxDecoration _getMainContainerDecoration(BuildContext context, bool isDark) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                const Color(0xFF0B3D2E).withValues(alpha: 0.8),
                const Color(0xFF082D22).withValues(alpha: 0.9),
              ]
            : [
                const Color(0xFFF0F8F4).withValues(alpha: 0.8),
                const Color(0xFFE4F1EB).withValues(alpha: 0.9),
              ],
      ),
      border: Border(
        top: BorderSide(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
    );
  }

  BoxDecoration _getSectionDecoration(BuildContext context, bool isDark) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                const Color(0xFF144D32).withValues(alpha: 0.5),
                const Color(0xFF0E3824).withValues(alpha: 0.4),
              ]
            : [
                const Color(0xFFE8F3EE).withValues(alpha: 0.7),
                const Color(0xFFDDF0E6).withValues(alpha: 0.5),
              ],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
          blurRadius: 15,
          spreadRadius: 2,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _buildProfileTab(BuildContext context, AppLocalizations l10n,
      bool isArabic, bool isDark, ThemeService themeService) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: _getMainContainerDecoration(context, isDark),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
                children: [
                  _AnimatedSection(
                    index: 0,
                    controller: _animationController,
                    child:
                        _buildHeroProfileCard(context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 1,
                    controller: _animationController,
                    child: _buildProfileInfoSection(
                        context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 2,
                    controller: _animationController,
                    child:
                        _buildPasswordSection(context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 3,
                    controller: _animationController,
                    child:
                        _buildBirthdaySection(context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 4,
                    controller: _animationController,
                    child: _buildDeleteAccountSection(context, themeService),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemTab(BuildContext context, AppLocalizations l10n,
      bool isArabic, bool isDark, ThemeService themeService) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: _getMainContainerDecoration(context, isDark),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
                children: [
                  _AnimatedSection(
                    index: 0,
                    controller: _animationController,
                    child: _buildQuickSummaryCard(
                        context, themeService, isDark, isArabic),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 1,
                    controller: _animationController,
                    child: _buildAdhanSystemSection(
                        context, l10n, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 2,
                    controller: _animationController,
                    child:
                        _buildDefaultReciterSection(context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 3,
                    controller: _animationController,
                    child: _buildTextScaleSection(
                        context, l10n, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 4,
                    controller: _animationController,
                    child: _buildFontSection(context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 5,
                    controller: _animationController,
                    child: _buildThemeSection(
                        context, l10n, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 6,
                    controller: _animationController,
                    child: _buildLanguageSection(
                        context, l10n, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 7,
                    controller: _animationController,
                    child: _buildMoreInfoSection(
                        context, l10n, themeService, isDark, isArabic),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroProfileCard(
      BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final authService = Provider.of<AuthService>(context);
    final String userName = authService.userName ?? 'Guest';
    final String userEmail = authService.userEmail ?? 'no-email@example.com';
    final String initial = userName.trim().isNotEmpty
        ? userName.trim().substring(0, 1).toUpperCase()
        : '?';

    final String memberSinceLabel = lang == 'ar'
        ? 'عضو منذ'
        : (lang == 'fr' ? 'Membre depuis' : 'Member since');
    final String memberSinceValue = lang == 'ar'
        ? 'يناير 2026'
        : (lang == 'fr' ? 'Janvier 2026' : 'January 2026');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A5F3E).withValues(alpha: 0.75),
                  const Color(0xFF0E3824).withValues(alpha: 0.65),
                ]
              : [
                  const Color(0xFFE8F5EE).withValues(alpha: 0.9),
                  const Color(0xFFD3E9DC).withValues(alpha: 0.7),
                ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.45),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundColor: isDark
                  ? const Color(0xFF0B3D2E)
                  : const Color(0xFFF0F8F4),
              child: Text(
                initial,
                style: themeService.getTextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: themeService.getTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.getOnBackgroundColor(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            userEmail,
            textAlign: TextAlign.center,
            style: themeService.getTextStyle(
              fontSize: 14,
              color: AppTheme.getOnBackgroundColor(context)
                  .withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _PillChip(
                icon: Icons.verified_user_rounded,
                label: lang == 'ar'
                    ? 'حساب موثَّق'
                    : (lang == 'fr' ? 'Compte vérifié' : 'Verified account'),
                themeService: themeService,
              ),
              _PillChip(
                icon: Icons.calendar_today_rounded,
                label: '$memberSinceLabel $memberSinceValue',
                themeService: themeService,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSummaryCard(BuildContext context, ThemeService themeService,
      bool isDark, bool isArabic) {
    final themeLabel = themeService.themeMode == AppThemeMode.light
        ? (isArabic ? 'فاتح' : 'Light')
        : themeService.themeMode == AppThemeMode.dark
            ? (isArabic ? 'داكن' : 'Dark')
            : (isArabic ? 'تلقائي' : 'Auto');
    final scaleLabel = themeService.textScaleFactor == TextScaleFactor.small
        ? (isArabic ? 'صغير' : 'Small')
        : themeService.textScaleFactor == TextScaleFactor.large
            ? (isArabic ? 'كبير' : 'Large')
            : (isArabic ? 'عادي' : 'Medium');
    final langLabel = _selectedLanguage == 'ar'
        ? 'العربية'
        : _selectedLanguage == 'fr'
            ? 'Français'
            : 'English';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _getSectionDecoration(context, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                child: Icon(Icons.auto_awesome_rounded,
                    color: Theme.of(context).colorScheme.secondary, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                isArabic ? 'إعداداتك الحالية' : 'Your Current Setup',
                style: themeService.getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getOnBackgroundColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _PillChip(
                icon: Icons.palette_outlined,
                label: themeLabel,
                themeService: themeService,
              ),
              _PillChip(
                icon: Icons.text_fields_rounded,
                label: scaleLabel,
                themeService: themeService,
              ),
              _PillChip(
                icon: Icons.language_rounded,
                label: langLabel,
                themeService: themeService,
              ),
              _PillChip(
                icon: Icons.font_download_outlined,
                label: _fontOptions[_selectedFont] ?? _selectedFont,
                themeService: themeService,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoreInfoSection(BuildContext context, AppLocalizations l10n,
      ThemeService themeService, bool isDark, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.menu_book_rounded,
          title: isArabic ? 'معلومات إضافية' : 'Additional Information',
          subtitle: isArabic
              ? 'اطّلع على معلومات التطبيق وسياساته وشروطه'
              : 'Review app information, privacy practices, and terms of use',
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            children: [
              _InfoTile(
                icon: Icons.verified_rounded,
                title: isArabic ? 'إصدار التطبيق' : 'App Version',
                subtitle: 'v1.0.0  •  Build 100',
                themeService: themeService,
              ),
              _divider(context),
              _InfoTile(
                icon: Icons.privacy_tip_outlined,
                title: isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
                subtitle: isArabic
                    ? 'تعرّف على كيفية حماية بياناتك الشخصية'
                    : 'Learn how we protect your personal data',
                themeService: themeService,
                onTap: () {},
              ),
              _divider(context),
              _InfoTile(
                icon: Icons.description_outlined,
                title: isArabic ? 'شروط الاستخدام' : 'Terms of Service',
                subtitle: isArabic
                    ? 'اقرأ شروط وأحكام استخدام التطبيق'
                    : 'Read the terms and conditions for using this app',
                themeService: themeService,
                onTap: () {},
              ),
              _divider(context),
              _InfoTile(
                icon: Icons.mail_outline_rounded,
                title: isArabic ? 'تواصل معنا' : 'Contact Support',
                subtitle: isArabic
                    ? 'لديك سؤال أو ملاحظة؟ يسعدنا خدمتك'
                    : 'Have a question or feedback? We\'re here to help',
                themeService: themeService,
                onTap: () {},
              ),
              _divider(context),
              _InfoTile(
                icon: Icons.star_outline_rounded,
                title: isArabic ? 'قيّم التطبيق' : 'Rate the App',
                subtitle: isArabic
                    ? 'ساعدنا بتقييمك على المتجر لدعم تطوير التطبيق'
                    : 'Support our development with a quick rating',
                themeService: themeService,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider(BuildContext context) => Divider(
        height: 1,
        thickness: 0.6,
        indent: 60,
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
      );

  Widget _buildProfileInfoSection(
      BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final authService = Provider.of<AuthService>(context);
    final String userName = authService.userName ?? 'Guest';
    final String userEmail = authService.userEmail ?? 'No email provided';
    final String profileTitle = lang == 'ar'
        ? 'معلومات الملف الشخصي'
        : (lang == 'fr' ? 'Informations du profil' : 'Profile Information');
    final String profileSubtitle = lang == 'ar'
        ? 'بياناتك الأساسية المستخدمة لتخصيص تجربتك في التطبيق'
        : (lang == 'fr'
            ? 'Vos informations de base utilisées pour personnaliser votre expérience'
            : 'Your primary account details used to personalize your experience');
    final String usernameLabel = lang == 'ar'
        ? 'اسم المستخدم'
        : (lang == 'fr' ? 'Nom d\'utilisateur' : 'Username');
    final String emailLabel =
        lang == 'ar' ? 'البريد الإلكتروني' : (lang == 'fr' ? 'E-mail' : 'Email');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.person_outline_rounded,
          title: profileTitle,
          subtitle: profileSubtitle,
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(usernameLabel,
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: 0.5,
                  )),
              const SizedBox(height: 8),
              Text(userName,
                  style: themeService.getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getOnBackgroundColor(context),
                  )),
              const SizedBox(height: 24),
              Text(emailLabel,
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: 0.5,
                  )),
              const SizedBox(height: 8),
              Text(userEmail,
                  style: themeService.getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getOnBackgroundColor(context),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordSection(
      BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String passwordTitle = lang == 'ar'
        ? 'كلمة المرور'
        : (lang == 'fr' ? 'Mot de passe' : 'Password');
    final String passwordSubtitle = lang == 'ar'
        ? 'حافظ على أمان حسابك من خلال تحديث كلمة المرور بانتظام'
        : (lang == 'fr'
            ? 'Sécurisez votre compte en mettant à jour régulièrement votre mot de passe'
            : 'Keep your account safe by updating your password regularly');
    final String changePassword = lang == 'ar'
        ? 'تغيير كلمة المرور'
        : (lang == 'fr' ? 'Changer le mot de passe' : 'Change Password');
    final String forgotPassword = lang == 'ar'
        ? 'هل نسيت كلمة المرور؟'
        : (lang == 'fr' ? 'Mot de passe oublié?' : 'Forgot Password?');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.lock_outline_rounded,
          title: passwordTitle,
          subtitle: passwordSubtitle,
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('••••••••••',
                  style: themeService.getTextStyle(
                    fontSize: 18,
                    color: AppTheme.getOnBackgroundColor(context),
                    letterSpacing: 6,
                  )),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor: isDark ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 2,
                      ),
                      child: Text(changePassword,
                          style: themeService.getTextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.6),
                            width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(forgotPassword,
                          style: themeService.getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBirthdaySection(
      BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String birthdayTitle = lang == 'ar'
        ? 'تاريخ الميلاد'
        : (lang == 'fr' ? 'Date de naissance' : 'Birthday');
    final String birthdaySubtitle = lang == 'ar'
        ? 'نستخدم هذا التاريخ لتذكيرك بمناسباتك الخاصة وإرسال التهاني'
        : (lang == 'fr'
            ? 'Utilisé pour vous rappeler vos occasions spéciales et vous envoyer des vœux'
            : 'Used to remind you of special occasions and send you greetings');
    final String editButton =
        lang == 'ar' ? 'تعديل' : (lang == 'fr' ? 'Modifier' : 'Edit');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.cake_outlined,
          title: birthdayTitle,
          subtitle: birthdaySubtitle,
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _getSectionDecoration(context, isDark),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('01/01/2000',
                  style: themeService.getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getOnBackgroundColor(context),
                  )),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: isDark ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  elevation: 2,
                ),
                child: Text(editButton,
                    style: themeService.getTextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountSection(
      BuildContext context, ThemeService themeService) {
    final lang = _selectedLanguage;
    final String deleteTitle = lang == 'ar'
        ? 'حذف الحساب'
        : (lang == 'fr' ? 'Supprimer le compte' : 'Delete Account');
    final String deleteWarning = lang == 'ar'
        ? 'سيؤدي هذا الإجراء إلى حذف حسابك وجميع بياناتك (المفضلة، الإعدادات، السجل) نهائياً. لا يمكن التراجع عن هذا الإجراء بعد التأكيد.'
        : (lang == 'fr'
            ? 'Cette action supprimera définitivement votre compte et toutes vos données (favoris, paramètres, historique). Cette action est irréversible.'
            : 'This action will permanently delete your account and all related data (favorites, settings, history). This action cannot be undone.');
    final String deleteButton = lang == 'ar'
        ? 'حذف الحساب نهائياً'
        : (lang == 'fr' ? 'Supprimer définitivement' : 'Delete Account Permanently');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: Colors.red, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(deleteTitle,
                  style: themeService.getTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red.withValues(alpha: 0.08),
                Colors.red.withValues(alpha: 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: Colors.red.withValues(alpha: 0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.1),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(deleteWarning,
                  style: themeService.getTextStyle(
                    fontSize: 14,
                    color: AppTheme.getOnBackgroundColor(context)
                        .withValues(alpha: 0.8),
                    height: 1.6,
                  )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  child: Text(deleteButton,
                      style: themeService.getTextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdhanSystemSection(BuildContext context, AppLocalizations l10n,
      ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String adhanTitle = lang == 'ar'
        ? 'نظام الأذان'
        : (lang == 'fr' ? 'Système d\'Adhan' : 'Adhan System');
    final String manageButton = lang == 'ar'
        ? 'فتح إعدادات الأذان'
        : (lang == 'fr' ? 'Ouvrir les paramètres' : 'Open Adhan Settings');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.notifications_outlined,
          title: adhanTitle,
          subtitle: lang == 'ar'
              ? 'تحكم كامل في إشعارات الأذان والمقرئ المفضّل وتنبيهات الصلوات'
              : (lang == 'fr'
                  ? 'Contrôle total des notifications d\'adhan, du récitant et des alarmes de prière'
                  : 'Full control over adhan notifications, reciter, and prayer alarms'),
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Theme.of(context).colorScheme.secondary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lang == 'ar'
                          ? 'تحكّم في الإشعارات، مدة الأذان، المقرئ، والغفوة من صفحة واحدة'
                          : (lang == 'fr'
                              ? 'Gérez les notifications, la durée, le récitant et le rappel depuis une seule page'
                              : 'Manage notifications, duration, reciter, and snooze from one page'),
                      style: themeService.getTextStyle(
                        fontSize: 13,
                        color: AppTheme.getOnBackgroundColor(context)
                            .withValues(alpha: 0.75),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const AdhanSettingsScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var tween = Tween(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeOutCubic));
                          return SlideTransition(
                              position: animation.drive(tween), child: child);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings_rounded, size: 20),
                  label: Text(manageButton,
                      style: themeService.getTextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: isDark ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultReciterSection(
      BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String reciterTitle = lang == 'ar'
        ? 'المقرئ الافتراضي'
        : (lang == 'fr' ? 'Lecteur par défaut' : 'Default Reciter');
    final String reciterDesc = lang == 'ar'
        ? 'اختر المقرئ الذي ترغب في سماع تلاوته افتراضياً عند فتح صفحة القرآن الكريم. سيُستخدم هذا الاختيار في جميع أنحاء التطبيق.'
        : (lang == 'fr'
            ? 'Choisissez le récitant par défaut pour la lecture audio du Saint Coran dans toute l\'application.'
            : 'Choose the default reciter for Quran audio playback throughout the entire app.');
    final String changeButton = lang == 'ar'
        ? 'تغيير المقرئ'
        : (lang == 'fr' ? 'Changer de lecteur' : 'Change Reciter');

    final String reciterName = _defaultReciter != null
        ? (lang == 'ar' ? _defaultReciter!.nameAr : _defaultReciter!.nameEn)
        : (lang == 'ar' ? 'لم يتم اختيار مقرئ' : 'No reciter selected');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.mic_rounded,
          title: reciterTitle,
          subtitle: reciterDesc,
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (_defaultReciter != null)
                    _ReciterAvatar(
                      reciter: _defaultReciter!,
                      size: 84,
                      borderRadius: 20,
                    )
                  else
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.15),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(Icons.headset_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 40),
                    ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'ar' ? 'المقرئ الحالي' : 'Current Reciter',
                          style: themeService.getTextStyle(
                            fontSize: 12,
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          reciterName,
                          style: themeService.getTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getOnBackgroundColor(context),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          lang == 'ar'
                              ? 'الصوت المُستخدم في تشغيل التلاوات'
                              : 'Voice used for playback',
                          style: themeService.getTextStyle(
                            fontSize: 12,
                            color: AppTheme.getOnBackgroundColor(context)
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _showReciterPicker(context, themeService, isDark),
                  icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                  label: Text(changeButton,
                      style: themeService.getTextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: isDark ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showReciterPicker(
      BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.72,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0B3D2E).withValues(alpha: 0.96)
                  : const Color(0xFFF0F8F4).withValues(alpha: 0.98),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        lang == 'ar'
                            ? 'اختر المقرئ الافتراضي'
                            : (lang == 'fr'
                                ? 'Choisissez le lecteur'
                                : 'Select Default Reciter'),
                        style: themeService.getTextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.getOnBackgroundColor(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lang == 'ar'
                            ? 'سيتم استخدام هذا المقرئ افتراضياً في تشغيل التلاوات'
                            : 'This reciter will be used as default for playback',
                        textAlign: TextAlign.center,
                        style: themeService.getTextStyle(
                          fontSize: 13,
                          color: AppTheme.getOnBackgroundColor(context)
                              .withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: QuranReciterService.reciters.length,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemBuilder: (context, index) {
                      final reciter = QuranReciterService.reciters[index];
                      final isSelected = _defaultReciter?.id == reciter.id;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.15),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              _setDefaultReciter(reciter);
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  _ReciterAvatar(
                                    reciter: reciter,
                                    size: 76,
                                    borderRadius: 18,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lang == 'ar'
                                              ? reciter.nameAr
                                              : reciter.nameEn,
                                          style: themeService.getTextStyle(
                                            fontSize: 17,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : AppTheme.getOnBackgroundColor(
                                                    context),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          lang == 'ar'
                                              ? 'قارئ معتمد للقرآن الكريم'
                                              : 'Certified Quran reciter',
                                          style: themeService.getTextStyle(
                                            fontSize: 12,
                                            color: AppTheme.getOnBackgroundColor(
                                                    context)
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedScale(
                                    scale: isSelected ? 1.0 : 0.85,
                                    duration:
                                        const Duration(milliseconds: 200),
                                    child: Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_off_rounded,
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : AppTheme.getOnBackgroundColor(
                                                  context)
                                              .withValues(alpha: 0.35),
                                      size: 26,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildReciterAvatar(QuranReciter reciter,
      {double size = 44.0, double borderRadius = 10.0}) {
    return _ReciterAvatar(
      reciter: reciter,
      size: size,
      borderRadius: borderRadius,
    );
  }

  Widget _buildTextScaleSection(BuildContext context, AppLocalizations l10n,
      ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String fontSizeTitle = lang == 'ar'
        ? 'حجم الخط'
        : (lang == 'fr' ? 'Taille de police' : 'Font Size');
    final String fontSizeDesc = lang == 'ar'
        ? 'اضبط حجم النص في كامل التطبيق بما يناسب راحتك البصرية. يمكنك المعاينة مباشرة بالأسفل.'
        : (lang == 'fr'
            ? 'Ajustez la taille du texte dans toute l\'application selon votre confort visuel.'
            : 'Adjust text size across the app for maximum reading comfort. Preview updates live below.');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.text_fields_rounded,
          title: fontSizeTitle,
          subtitle: fontSizeDesc,
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0B3D2E).withValues(alpha: 0.4)
                      : const Color(0xFFF0F8F4).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SizePreviewLetter(
                        size: 14,
                        active: themeService.textScaleFactor ==
                            TextScaleFactor.small),
                    _SizePreviewLetter(
                        size: 18,
                        active: themeService.textScaleFactor ==
                            TextScaleFactor.medium),
                    _SizePreviewLetter(
                        size: 24,
                        active: themeService.textScaleFactor ==
                            TextScaleFactor.large),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF144D32).withValues(alpha: 0.4)
                      : const Color(0xFFE8F3EE).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    _buildScaleOption(
                        context,
                        themeService,
                        TextScaleFactor.small,
                        lang == 'ar'
                            ? 'صغير'
                            : (lang == 'fr' ? 'Petit' : 'Small'),
                        isDark),
                    const SizedBox(width: 4),
                    _buildScaleOption(
                        context,
                        themeService,
                        TextScaleFactor.medium,
                        lang == 'ar'
                            ? 'عادي'
                            : (lang == 'fr' ? 'Moyen' : 'Medium'),
                        isDark),
                    const SizedBox(width: 4),
                    _buildScaleOption(
                        context,
                        themeService,
                        TextScaleFactor.large,
                        lang == 'ar'
                            ? 'كبير'
                            : (lang == 'fr' ? 'Grand' : 'Large'),
                        isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScaleOption(BuildContext context, ThemeService themeService,
      TextScaleFactor factor, String label, bool isDark) {
    final isActive = themeService.textScaleFactor == factor;
    return Expanded(
      child: GestureDetector(
        onTap: () => themeService.setTextScaleFactor(factor),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: themeService.getTextStyle(
                fontSize: 14,
                color: isActive
                    ? (isDark ? Colors.white : Colors.black)
                    : AppTheme.getOnBackgroundColor(context),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFontSection(
      BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String fontStyleTitle = lang == 'ar'
        ? 'نمط الخط'
        : (lang == 'fr' ? 'Style de police' : 'Font Style');
    final String fontStyleDesc = lang == 'ar'
        ? 'اختر الخط الذي يمنحك أفضل تجربة قراءة. يطبّق الاختيار على كل نصوص التطبيق مباشرة.'
        : (lang == 'fr'
            ? 'Choisissez la police qui vous offre la meilleure expérience de lecture. Elle sera appliquée instantanément partout.'
            : 'Pick the font that gives you the best reading experience. Applied instantly across the whole app.');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.font_download_outlined,
          title: fontStyleTitle,
          subtitle: fontStyleDesc,
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: _getSectionDecoration(context, isDark),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: isDark ? const Color(0xFF144D32) : Colors.white,
              value: _fontOptions.containsKey(_selectedFont)
                  ? _selectedFont
                  : 'amiri',
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down_rounded,
                  color: Theme.of(context).colorScheme.secondary, size: 30),
              items: _fontOptions.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: themeService.getTextStyle(
                      fontSize: 16,
                      color: _selectedFont == entry.key
                          ? Theme.of(context).colorScheme.secondary
                          : AppTheme.getOnBackgroundColor(context),
                      fontWeight: _selectedFont == entry.key
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newFont) {
                if (newFont != null) {
                  _updateFont(newFont);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context, AppLocalizations l10n,
      ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String themeTitle = lang == 'ar'
        ? 'نمط المظهر'
        : (lang == 'fr' ? 'Style du thème' : 'Theme Style');
    final String themeDesc = lang == 'ar'
        ? 'اختر المظهر المريح لعينيك. يمكنك التبديل بين الوضع الفاتح والداكن أو اتباع إعدادات النظام تلقائياً.'
        : (lang == 'fr'
            ? 'Choisissez le thème qui convient le mieux à vos yeux : clair, sombre, ou synchronisé avec le système.'
            : 'Choose the theme that suits your eyes best — light, dark, or synced automatically with your system.');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.palette_outlined,
          title: themeTitle,
          subtitle: themeDesc,
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            children: [
              _ThemeOptionCard(
                label:
                    lang == 'ar' ? 'فاتح' : (lang == 'fr' ? 'Clair' : 'Light'),
                isSelected: themeService.themeMode == AppThemeMode.light,
                onTap: () => themeService.setThemeMode(AppThemeMode.light),
                icon: Icons.light_mode_rounded,
                themeService: themeService,
              ),
              const SizedBox(height: 12),
              _ThemeOptionCard(
                label:
                    lang == 'ar' ? 'داكن' : (lang == 'fr' ? 'Sombre' : 'Dark'),
                isSelected: themeService.themeMode == AppThemeMode.dark,
                onTap: () => themeService.setThemeMode(AppThemeMode.dark),
                icon: Icons.dark_mode_rounded,
                themeService: themeService,
              ),
              const SizedBox(height: 12),
              _ThemeOptionCard(
                label: lang == 'ar'
                    ? 'تلقائي (حسب النظام)'
                    : (lang == 'fr' ? 'Auto (système)' : 'Auto (system)'),
                isSelected: themeService.themeMode == AppThemeMode.system,
                onTap: () => themeService.setThemeMode(AppThemeMode.system),
                icon: Icons.brightness_auto_rounded,
                themeService: themeService,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n,
      ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String languageTitle =
        lang == 'ar' ? 'اللغة' : (lang == 'fr' ? 'Langue' : 'Language');
    final String languageDesc = lang == 'ar'
        ? 'اختر لغة واجهة التطبيق المفضّلة لديك. سيتم تطبيق التغيير على جميع الشاشات فوراً.'
        : (lang == 'fr'
            ? 'Choisissez la langue d\'affichage. Le changement sera appliqué immédiatement à tous les écrans.'
            : 'Choose the app display language. The change will apply instantly across all screens.');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.language_rounded,
          title: languageTitle,
          subtitle: languageDesc,
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            children: [
              _InteractiveOptionCard(
                label: '🇪🇬 العربية',
                isSelected: _selectedLanguage == 'ar',
                onTap: () {
                  IslamicApp.of(context)?.setLocale('ar');
                  setState(() => _selectedLanguage = 'ar');
                },
                themeService: themeService,
              ),
              const SizedBox(height: 12),
              _InteractiveOptionCard(
                label: '🇺🇸 English',
                isSelected: _selectedLanguage == 'en',
                onTap: () {
                  IslamicApp.of(context)?.setLocale('en');
                  setState(() => _selectedLanguage = 'en');
                },
                themeService: themeService,
              ),
              const SizedBox(height: 12),
              _InteractiveOptionCard(
                label: '🇫🇷 Français',
                isSelected: _selectedLanguage == 'fr',
                onTap: () {
                  IslamicApp.of(context)?.setLocale('fr');
                  setState(() => _selectedLanguage = 'fr');
                },
                themeService: themeService,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════

class _GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
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
                    ? const Color(0xFF144D32).withValues(alpha: 0.5)
                    : const Color(0xFFE8F3EE).withValues(alpha: 0.7)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: _hover ? 0.6 : 0.3),
            ),
          ),
          child: Icon(widget.icon,
              color: Theme.of(context).colorScheme.secondary, size: 22),
        ),
      ),
    );
  }
}

class _ReciterAvatar extends StatelessWidget {
  final QuranReciter reciter;
  final double size;
  final double borderRadius;

  const _ReciterAvatar({
    required this.reciter,
    required this.size,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.35),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .secondary
              .withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .secondary
                .withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 2),
        child: Image.asset(
          'assets/images/reciters/${reciter.imageFileName}',
          fit: BoxFit.cover,
          cacheWidth: (size * 2).toInt(),
          cacheHeight: (size * 2).toInt(),
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: size * 0.55,
              color: Theme.of(context).colorScheme.secondary,
            );
          },
        ),
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeService themeService;

  const _PillChip({
    required this.icon,
    required this.label,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 15, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: themeService.getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.getOnBackgroundColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeService themeService;

  const _SectionHeader({
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
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              color: Theme.of(context).colorScheme.secondary, size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: themeService.getTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getOnBackgroundColor(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: themeService.getTextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppTheme.getOnBackgroundColor(context)
                      .withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeService themeService;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.themeService,
    this.onTap,
  });

  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          color: _hover
              ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.06)
              : Colors.transparent,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon,
                    color: Theme.of(context).colorScheme.secondary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: widget.themeService.getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getOnBackgroundColor(context),
                        )),
                    const SizedBox(height: 2),
                    Text(widget.subtitle,
                        style: widget.themeService.getTextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppTheme.getOnBackgroundColor(context)
                              .withValues(alpha: 0.6),
                        )),
                  ],
                ),
              ),
              if (widget.onTap != null)
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
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
    final endDelay = (startDelay + 0.25).clamp(0.0, 1.0);

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
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: active
            ? gold
            : (isDark
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.3)),
      ),
      child: const Text('Aa'),
    );
  }
}

class _ThemeOptionCard extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final ThemeService themeService;

  const _ThemeOptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.themeService,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: widget.isSelected || _isHovered
                  ? Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.15)
                  : isDark
                      ? const Color(0xFF144D32).withValues(alpha: 0.4)
                      : const Color(0xFFE8F3EE).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected || _isHovered
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.15),
                width: widget.isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : AppTheme.getOnBackgroundColor(context)
                          .withValues(alpha: 0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: widget.themeService.getTextStyle(
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
                  Icon(Icons.check_circle_rounded,
                      color: Theme.of(context).colorScheme.secondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InteractiveOptionCard extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeService themeService;

  const _InteractiveOptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.themeService,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: widget.isSelected || _isHovered
                  ? Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.15)
                  : isDark
                      ? const Color(0xFF144D32).withValues(alpha: 0.4)
                      : const Color(0xFFE8F3EE).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected || _isHovered
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.15),
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
                      : AppTheme.getOnBackgroundColor(context)
                          .withValues(alpha: 0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: widget.themeService.getTextStyle(
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

// ═══════════════════════════════════════════════════════════════════════
// ADHAN SETTINGS SCREEN
// ═══════════════════════════════════════════════════════════════════════

class AdhanSettingsScreen extends StatefulWidget {
  const AdhanSettingsScreen({super.key});

  @override
  State<AdhanSettingsScreen> createState() => _AdhanSettingsScreenState();
}

class _AdhanSettingsScreenState extends State<AdhanSettingsScreen>
    with TickerProviderStateMixin {
  late String _selectedReciter;
  bool _isWholeAdhan = true;
  bool _notificationsEnabled = true;
  bool _adhanPlaying = false;

  late AnimationController _animationController;
  late AnimationController _soundWaveController;

  bool _snoozeEnabled = true;
  String _selectedWakeSound = 'chilling_breeze';

  StreamSubscription? _audioSubscription;

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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _soundWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _selectedReciter = 'mishary';
    _loadSettings();

    _audioSubscription = AdhanService.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() => _adhanPlaying = false);
      } else if (state == PlayerState.playing) {
        setState(() => _adhanPlaying = true);
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _audioSubscription?.cancel();
    _animationController.dispose();
    _soundWaveController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _selectedReciter = prefs.getString('adhanReciter') ?? 'mishary';
      _isWholeAdhan = prefs.getBool('isWholeAdhan') ?? true;
      _snoozeEnabled = prefs.getBool('adhanSnoozeEnabled') ?? true;
      _selectedWakeSound =
          prefs.getString('adhanWakeSound') ?? 'chilling_breeze';
      _notificationsEnabled = NotificationService.areNotificationsEnabled();
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhanReciter', _selectedReciter);
    await prefs.setBool('isWholeAdhan', _isWholeAdhan);
    await prefs.setBool('adhanSnoozeEnabled', _snoozeEnabled);
    await prefs.setString('adhanWakeSound', _selectedWakeSound);
  }

  Future<void> _playAdhan(AppLocalizations l10n) async {
    try {
      await AdhanService.stopAdhan();
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      setState(() => _adhanPlaying = true);
      await AdhanService.playAdhan(_selectedReciter);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${l10n.errorMessage}: $e'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ));
      setState(() => _adhanPlaying = false);
    }
  }

  Future<void> _stopAdhan() async {
    try {
      HapticFeedback.selectionClick();
      await AdhanService.stopAdhan();
      if (!mounted) return;
      setState(() => _adhanPlaying = false);
    } catch (_) {}
  }

  Widget _buildAdhanReciterAvatar(String reciterId, {double size = 56}) {
    final fileName = _adhanReciterImages[reciterId];
    final radius = size / 4;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.35),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .secondary
                .withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 2),
        child: fileName == null
            ? Icon(Icons.person,
                color: Theme.of(context).colorScheme.secondary)
            : Image.asset(
                'assets/images/adhan_reciters/$fileName',
                fit: BoxFit.cover,
                cacheWidth: (size * 2).toInt(),
                cacheHeight: (size * 2).toInt(),
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  size: size * 0.55,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
      ),
    );
  }

  void _showHelpDialog() {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final title = isArabic
        ? 'كيف يعمل نظام الأذان؟'
        : (isFrench
            ? 'Comment fonctionne le système d\'Adhan ?'
            : 'How does the Adhan system work?');
    final points = isArabic
        ? [
            'فعّل الإشعارات من الأعلى لتصلك تنبيهات الصلوات.',
            'اختر المقرئ المفضّل لصوت الأذان.',
            'حدّد طول الأذان: التكبيرات الأولى فقط أو الأذان كاملاً.',
            'استمع للأذان مباشرة قبل تفعيله عبر زر الاستماع.',
            'اضبط منبهات منفصلة لكل صلاة لتنبيهك قبل أو بعد الوقت.',
          ]
        : isFrench
            ? [
                'Activez les notifications en haut pour recevoir les alertes de prière.',
                'Choisissez votre récitateur préféré pour la voix de l\'adhan.',
                'Choisissez la longueur : premiers takbeers ou adhan complet.',
                'Prévisualisez l\'adhan directement avant de l\'activer.',
                'Configurez des alarmes distinctes pour chaque prière.',
              ]
            : [
                'Enable notifications at the top to receive prayer alerts.',
                'Choose your preferred reciter for the adhan voice.',
                'Set adhan length: first takbeers only, or the whole adhan.',
                'Preview the adhan directly before enabling it.',
                'Set distinct alarms for each prayer to alert you on time.',
              ];

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.2),
                blurRadius: 26,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.15),
                    ),
                    child: Icon(Icons.help_outline_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ...points.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Text(
                          '${e.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e.value,
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.black87,
                            fontSize: 13.5,
                            height: 1.55,
                          ),
                          textAlign:
                              isArabic ? TextAlign.right : TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: isDark ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    isArabic
                        ? 'حسناً، فهمت'
                        : (isFrench ? 'Compris' : 'Got it'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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

  void _openReciterPicker() {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0B3D2E).withValues(alpha: 0.96)
                  : const Color(0xFFF0F8F4).withValues(alpha: 0.98),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        isArabic
                            ? 'اختر صوت الأذان'
                            : (isFrench
                                ? 'Choisissez la voix de l\'adhan'
                                : 'Choose Adhan Voice'),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isArabic
                            ? 'سيُشغَّل صوت هذا المقرئ عند دخول وقت الصلاة'
                            : 'This reciter will play when prayer time begins',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.getOnBackgroundColor(context)
                              .withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _adhanReciterImages.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    itemBuilder: (context, index) {
                      final reciterId =
                          _adhanReciterImages.keys.elementAt(index);
                      final isSelected = _selectedReciter == reciterId;
                      final name = AdhanReciterTranslations.getReciterName(
                          reciterId, lang);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.15),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedReciter = reciterId);
                              await _saveSettings();
                              if (sheetContext.mounted) {
                                Navigator.pop(sheetContext);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  _buildAdhanReciterAvatar(reciterId,
                                      size: 68),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : AppTheme
                                                    .getOnBackgroundColor(
                                                        context),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          isArabic
                                              ? 'قارئ معتمد للأذان'
                                              : 'Certified adhan reciter',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme
                                                    .getOnBackgroundColor(
                                                        context)
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedScale(
                                    scale: isSelected ? 1.0 : 0.85,
                                    duration:
                                        const Duration(milliseconds: 200),
                                    child: Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_off_rounded,
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : AppTheme.getOnBackgroundColor(
                                                  context)
                                              .withValues(alpha: 0.35),
                                      size: 26,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrayerAlarmsSection(
      BuildContext context, ThemeService themeService, bool isDark) {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    final prayers = <Map<String, dynamic>>[
      {
        'name': isArabic ? 'الفجر' : 'Fajr',
        'icon': Icons.wb_twilight_rounded,
      },
      {
        'name': isArabic ? 'الظهر' : 'Dhuhr',
        'icon': Icons.wb_sunny_rounded,
      },
      {
        'name': isArabic ? 'العصر' : 'Asr',
        'icon': Icons.wb_sunny_outlined,
      },
      {
        'name': isArabic ? 'المغرب' : 'Maghrib',
        'icon': Icons.brightness_5_rounded,
      },
      {
        'name': isArabic ? 'العشاء' : 'Isha',
        'icon': Icons.nightlight_round,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.alarm_add_rounded,
          title: isArabic
              ? 'منبهات الصلوات'
              : (isFrench ? 'Alarmes de prière' : 'Prayer Alarms'),
          subtitle: isArabic
              ? 'أنشئ منبهات مخصّصة لكل صلاة، مع إمكانية إضافة منبه احتياطي قبل الوقت أو بعده.'
              : (isFrench
                  ? 'Créez des alarmes personnalisées pour chaque prière, avec un rappel de secours.'
                  : 'Create custom alarms for each prayer, with an optional backup reminder.'),
          themeService: themeService,
        ),
        const SizedBox(height: 16),
        ...prayers.asMap().entries.map((entry) {
          final idx = entry.key;
          final prayer = entry.value;
          return Padding(
            padding: EdgeInsets.only(
                bottom: idx == prayers.length - 1 ? 0 : 12),
            child: _buildPrayerAlarmTile(
              context,
              themeService,
              isDark,
              lang,
              prayer['name'] as String,
              prayer['icon'] as IconData,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPrayerAlarmTile(
    BuildContext context,
    ThemeService themeService,
    bool isDark,
    String lang,
    String prayerName,
    IconData icon,
  ) {
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF144D32).withValues(alpha: 0.3)
            : const Color(0xFFE8F3EE).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.25),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          leading: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.15),
            ),
            child: Icon(icon,
                color: Theme.of(context).colorScheme.secondary, size: 22),
          ),
          title: Text(
            prayerName,
            style: themeService.getTextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppTheme.getOnBackgroundColor(context),
            ),
          ),
          subtitle: Text(
            isArabic
                ? 'منبهان مضبوطان'
                : (isFrench ? '2 alarmes définies' : '2 alarms configured'),
            style: themeService.getTextStyle(
              fontSize: 12,
              color: AppTheme.getOnBackgroundColor(context)
                  .withValues(alpha: 0.6),
            ),
          ),
          children: [
            _buildAlarmItem(
              themeService,
              icon: Icons.access_time_rounded,
              title: isArabic
                  ? 'في وقت الصلاة تماماً'
                  : (isFrench
                      ? "À l'heure exacte de la prière"
                      : 'At exact Salah time'),
              subtitle: isArabic
                  ? 'التنبيه الأساسي'
                  : (isFrench ? 'Alerte principale' : 'Primary alert'),
              onDelete: () {},
            ),
            _buildAlarmItem(
              themeService,
              icon: Icons.snooze_rounded,
              title: isArabic
                  ? 'بعد ١٥ دقيقة (احتياطي)'
                  : (isFrench
                      ? '15 min après (secours)'
                      : '15 mins after (Backup)'),
              subtitle: isArabic
                  ? 'تنبيه ثانٍ للتذكير'
                  : (isFrench ? 'Rappel secondaire' : 'Secondary reminder'),
              onDelete: () {},
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isArabic
                              ? 'إضافة منبه جديد قريباً'
                              : (isFrench
                                  ? 'Nouvelle alarme bientôt disponible'
                                  : 'Adding new alarms coming soon'),
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(
                    isArabic
                        ? 'إضافة منبه آخر'
                        : (isFrench
                            ? 'Ajouter une autre alarme'
                            : 'Add another alarm'),
                    style: themeService.getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.secondary,
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmItem(
    ThemeService themeService, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onDelete,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(icon,
          color: Theme.of(context).colorScheme.secondary, size: 20),
      title: Text(title, style: themeService.getTextStyle(fontSize: 14)),
      subtitle: Text(
        subtitle,
        style: themeService.getTextStyle(
          fontSize: 11,
          color:
              AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.55),
        ),
      ),
      trailing: IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.remove_circle_outline,
            color: Colors.redAccent, size: 22),
      ),
    );
  }

  BoxDecoration _getSectionDecoration() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                const Color(0xFF144D32).withValues(alpha: 0.5),
                const Color(0xFF0E3824).withValues(alpha: 0.4),
              ]
            : [
                const Color(0xFFE8F3EE).withValues(alpha: 0.7),
                const Color(0xFFDDF0E6).withValues(alpha: 0.5),
              ],
      ),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
        width: 1.4,
      ),
      boxShadow: [
        BoxShadow(
          color:
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
          blurRadius: 15,
          spreadRadius: 2,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: Row(
                      children: [
                        _GlassIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                l10n.adhan,
                                textAlign: TextAlign.center,
                                style: themeService.getTextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isArabic
                                    ? 'خصّص تنبيهات الأذان والصلاة بطريقتك'
                                    : (isFrench
                                        ? 'Personnalisez vos notifications de prière'
                                        : 'Personalize your prayer notifications'),
                                textAlign: TextAlign.center,
                                style: themeService.getTextStyle(
                                  fontSize: 11.5,
                                  letterSpacing: 0.3,
                                  color: AppTheme.getOnBackgroundColor(
                                          context)
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _GlassIconButton(
                          icon: Icons.help_outline_rounded,
                          onTap: _showHelpDialog,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(32)),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: isDark
                                      ? [
                                          const Color(0xFF0B3D2E)
                                              .withValues(alpha: 0.8),
                                          const Color(0xFF082D22)
                                              .withValues(alpha: 0.9),
                                        ]
                                      : [
                                          const Color(0xFFF0F8F4)
                                              .withValues(alpha: 0.8),
                                          const Color(0xFFE4F1EB)
                                              .withValues(alpha: 0.9),
                                        ],
                                ),
                                border: Border(
                                  top: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: ListView(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 24, 20, 40),
                                children: [
                                  _AnimatedSection(
                                    index: 0,
                                    controller: _animationController,
                                    child: _buildNotificationCard(
                                        l10n, themeService, isDark, lang),
                                  ),
                                  const SizedBox(height: 24),
                                  _AnimatedSection(
                                    index: 1,
                                    controller: _animationController,
                                    child: _buildPreviewCard(
                                        l10n, themeService, isDark, lang),
                                  ),
                                  const SizedBox(height: 24),
                                  _AnimatedSection(
                                    index: 2,
                                    controller: _animationController,
                                    child: _buildReciterSection(
                                        themeService, isDark, lang),
                                  ),
                                  const SizedBox(height: 24),
                                  _AnimatedSection(
                                    index: 3,
                                    controller: _animationController,
                                    child: _buildAdhanLengthSection(
                                        themeService, isDark, lang),
                                  ),
                                  const SizedBox(height: 24),
                                  _AnimatedSection(
                                    index: 4,
                                    controller: _animationController,
                                    child: _buildWakeSoundSection(
                                        themeService, isDark, lang),
                                  ),
                                  const SizedBox(height: 24),
                                  _AnimatedSection(
                                    index: 5,
                                    controller: _animationController,
                                    child: _buildPrayerAlarmsSection(
                                        context, themeService, isDark),
                                  ),
                                  const SizedBox(height: 24),
                                  _AnimatedSection(
                                    index: 6,
                                    controller: _animationController,
                                    child: _buildTestNotificationSection(
                                        themeService, isDark, lang),
                                  ),
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
      },
    );
  }

  Widget _buildNotificationCard(
    AppLocalizations l10n,
    ThemeService themeService,
    bool isDark,
    String lang,
  ) {
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.2),
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.05),
                ]
              : [
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.15),
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .secondary
                .withValues(alpha: 0.14),
            blurRadius: 16,
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
                      .withValues(alpha: 0.4),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              _notificationsEnabled
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.adhanNotifications,
                  style: themeService.getTextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getOnBackgroundColor(context),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _notificationsEnabled
                      ? (isArabic
                          ? 'ستصلك تنبيهات مواقيت الصلاة تلقائياً'
                          : (isFrench
                              ? 'Vous recevrez automatiquement les alertes de prière'
                              : 'You\'ll receive automatic prayer alerts'))
                      : (isArabic
                          ? 'الإشعارات معطّلة حالياً'
                          : (isFrench
                              ? 'Notifications désactivées'
                              : 'Notifications currently disabled')),
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    color: AppTheme.getOnBackgroundColor(context)
                        .withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (value) async {
              HapticFeedback.selectionClick();
              setState(() => _notificationsEnabled = value);
              await NotificationService.setNotificationsEnabled(value);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: [
                    Icon(
                      value
                          ? Icons.check_circle_rounded
                          : Icons.info_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        value
                            ? (isArabic
                                ? 'الإشعارات مفعلة'
                                : (isFrench
                                    ? 'Notifications activées'
                                    : 'Notifications enabled'))
                            : (isArabic
                                ? 'الإشعارات معطلة'
                                : (isFrench
                                    ? 'Notifications désactivées'
                                    : 'Notifications disabled')),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor:
                    value ? Colors.green.shade600 : Colors.orange.shade700,
              ));
            },
            activeThumbColor: Theme.of(context).colorScheme.secondary,
            activeTrackColor: Theme.of(context)
                .colorScheme
                .secondary
                .withValues(alpha: 0.4),
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.black.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(
    AppLocalizations l10n,
    ThemeService themeService,
    bool isDark,
    String lang,
  ) {
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final reciterName =
        AdhanReciterTranslations.getReciterName(_selectedReciter, lang);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _getSectionDecoration(),
      child: Column(
        children: [
          Row(
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
                child: Icon(Icons.graphic_eq_rounded,
                    color: Theme.of(context).colorScheme.secondary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isArabic
                      ? 'معاينة الأذان'
                      : (isFrench ? 'Aperçu de l\'adhan' : 'Adhan Preview'),
                  style: themeService.getTextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getOnBackgroundColor(context),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _adhanPlaying
                      ? Colors.green.withValues(alpha: 0.18)
                      : Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _adhanPlaying
                        ? Colors.green.withValues(alpha: 0.6)
                        : Colors.grey.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _adhanPlaying
                            ? Colors.green.shade600
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _adhanPlaying
                          ? (isArabic
                              ? 'قيد التشغيل'
                              : (isFrench ? 'En lecture' : 'Playing'))
                          : (isArabic
                              ? 'جاهز'
                              : (isFrench ? 'Prêt' : 'Ready')),
                      style: themeService.getTextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _adhanPlaying
                            ? Colors.green.shade700
                            : AppTheme.getOnBackgroundColor(context)
                                .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildAdhanReciterAvatar(_selectedReciter, size: 84),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic
                          ? 'المقرئ الحالي'
                          : (isFrench
                              ? 'Récitant actuel'
                              : 'Current Reciter'),
                      style: themeService.getTextStyle(
                        fontSize: 11,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reciterName,
                      style: themeService.getTextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.getOnBackgroundColor(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          _isWholeAdhan
                              ? Icons.queue_music_rounded
                              : Icons.music_note_rounded,
                          size: 13,
                          color: AppTheme.getOnBackgroundColor(context)
                              .withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _isWholeAdhan
                                ? (isArabic
                                    ? 'الأذان كاملاً'
                                    : (isFrench
                                        ? 'Adhan complet'
                                        : 'Full adhan'))
                                : (isArabic
                                    ? 'التكبيرات الأولى فقط'
                                    : (isFrench
                                        ? 'Premiers takbeers'
                                        : 'First takbeers only')),
                            overflow: TextOverflow.ellipsis,
                            style: themeService.getTextStyle(
                              fontSize: 12,
                              color: AppTheme.getOnBackgroundColor(context)
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_adhanPlaying)
                const _SoundWaveIndicator(
                    color: Color(0xFFD4AF37), size: 34),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed:
                      _adhanPlaying ? null : () => _playAdhan(l10n),
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: Text(
                    isArabic
                        ? 'استماع للأذان'
                        : (isFrench ? 'Écouter' : 'Listen to Adhan'),
                    style: themeService.getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    foregroundColor: const Color(0xFF0B3D2E),
                    disabledBackgroundColor:
                        Colors.black.withValues(alpha: 0.2),
                    disabledForegroundColor: Colors.white54,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _adhanPlaying ? _stopAdhan : null,
                  icon: const Icon(Icons.stop_rounded, size: 20),
                  label: Text(
                    isArabic
                        ? 'إيقاف'
                        : (isFrench ? 'Arrêter' : 'Stop'),
                    style: themeService.getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: BorderSide(
                      color: _adhanPlaying
                          ? Colors.redAccent.withValues(alpha: 0.6)
                          : Colors.grey.withValues(alpha: 0.3),
                      width: 1.4,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReciterSection(
      ThemeService themeService, bool isDark, String lang) {
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.mic_rounded,
          title: isArabic
              ? 'المقرئ'
              : (isFrench ? 'Récitant' : 'Reciter'),
          subtitle: isArabic
              ? 'اختر من بين أشهر قرّاء الأذان المعتمدين حول العالم الإسلامي.'
              : (isFrench
                  ? 'Choisissez parmi les récitateurs d\'adhan les plus reconnus.'
                  : 'Pick from some of the most recognised adhan reciters worldwide.'),
          themeService: themeService,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _getSectionDecoration(),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                HapticFeedback.selectionClick();
                _openReciterPicker();
              },
              child: Row(
                children: [
                  _buildAdhanReciterAvatar(_selectedReciter, size: 56),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AdhanReciterTranslations.getReciterName(
                              _selectedReciter, lang),
                          style: themeService.getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getOnBackgroundColor(context),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isArabic
                              ? 'اضغط لتغيير المقرئ'
                              : (isFrench
                                  ? 'Appuyez pour changer'
                                  : 'Tap to change'),
                          style: themeService.getTextStyle(
                            fontSize: 12,
                            color: AppTheme.getOnBackgroundColor(context)
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.15),
                    ),
                    child: Icon(Icons.swap_horiz_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdhanLengthSection(
      ThemeService themeService, bool isDark, String lang) {
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.timer_rounded,
          title: isArabic
              ? 'طول الأذان'
              : (isFrench ? 'Longueur de l\'Adhan' : 'Adhan Length'),
          subtitle: isArabic
              ? 'اختر بين الاستماع إلى التكبيرات الأولى فقط أو الأذان كاملاً مع جميع الجُمل.'
              : (isFrench
                  ? 'Écoutez uniquement les premiers takbeers ou l\'adhan complet.'
                  : 'Hear only the first takbeers, or the whole adhan with all phrases.'),
          themeService: themeService,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _getSectionDecoration(),
          child: Column(
            children: [
              _InteractiveOptionCard(
                label: isArabic
                    ? 'التكبيرات الأولى فقط'
                    : (isFrench
                        ? 'Premiers Takbeers uniquement'
                        : 'First Takbeers Only'),
                isSelected: !_isWholeAdhan,
                onTap: () async {
                  HapticFeedback.selectionClick();
                  setState(() => _isWholeAdhan = false);
                  await _saveSettings();
                },
                themeService: themeService,
              ),
              const SizedBox(height: 12),
              _InteractiveOptionCard(
                label: isArabic
                    ? 'الأذان كاملاً'
                    : (isFrench ? 'Adhan complet' : 'Whole Adhan'),
                isSelected: _isWholeAdhan,
                onTap: () async {
                  HapticFeedback.selectionClick();
                  setState(() => _isWholeAdhan = true);
                  await _saveSettings();
                },
                themeService: themeService,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWakeSoundSection(
      ThemeService themeService, bool isDark, String lang) {
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.bedtime_rounded,
          title: isArabic
              ? 'الاستيقاظ والغفوة'
              : (isFrench
                  ? 'Réveil et rappel'
                  : 'Wake-up & Snooze'),
          subtitle: isArabic
              ? 'اختر نغمة استيقاظ لطيفة تناسب ذوقك، وفعّل الغفوة لتذكيرك إذا نمت بعد الأذان.'
              : (isFrench
                  ? 'Choisissez une sonnerie douce et activez le rappel pour être prévenu après l\'adhan.'
                  : 'Pick a gentle wake-up tone and enable snooze for a reminder after the adhan.'),
          themeService: themeService,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _getSectionDecoration(),
          child: Column(
            children: [
              _InteractiveOptionCard(
                label: isArabic
                    ? 'نسيم هادئ (موصى به)'
                    : (isFrench
                        ? 'Brise apaisante (recommandé)'
                        : 'Chilling Breeze (Recommended)'),
                isSelected: _selectedWakeSound == 'chilling_breeze',
                onTap: () async {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedWakeSound = 'chilling_breeze');
                  await _saveSettings();
                },
                themeService: themeService,
              ),
              const SizedBox(height: 12),
              _InteractiveOptionCard(
                label: isArabic
                    ? 'أذان تقليدي'
                    : (isFrench
                        ? 'Adhan traditionnel'
                        : 'Traditional Adhan'),
                isSelected: _selectedWakeSound == 'traditional',
                onTap: () async {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedWakeSound = 'traditional');
                  await _saveSettings();
                },
                themeService: themeService,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0B3D2E).withValues(alpha: 0.4)
                      : const Color(0xFFF0F8F4).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.15),
                      ),
                      child: Icon(Icons.snooze_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic
                                ? 'تفعيل الغفوة (٥ دقائق)'
                                : (isFrench
                                    ? 'Activer le rappel (5 min)'
                                    : 'Enable Snooze (5 mins)'),
                            style: themeService.getTextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.getOnBackgroundColor(context),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isArabic
                                ? 'تذكير ثانٍ بعد الأذان بخمس دقائق'
                                : (isFrench
                                    ? 'Rappel 5 minutes après l\'adhan'
                                    : 'Second reminder 5 minutes after adhan'),
                            style: themeService.getTextStyle(
                              fontSize: 11.5,
                              color: AppTheme.getOnBackgroundColor(context)
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _snoozeEnabled,
                      onChanged: (val) async {
                        HapticFeedback.selectionClick();
                        setState(() => _snoozeEnabled = val);
                        await _saveSettings();
                      },
                      activeThumbColor:
                          Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestNotificationSection(
      ThemeService themeService, bool isDark, String lang) {
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _getSectionDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.15),
                ),
                child: Icon(Icons.science_rounded,
                    color: Theme.of(context).colorScheme.secondary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isArabic
                      ? 'اختبار الإشعارات'
                      : (isFrench
                          ? 'Tester les notifications'
                          : 'Test Notifications'),
                  style: themeService.getTextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getOnBackgroundColor(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isArabic
                ? 'تأكد من عمل الإشعارات بشكل صحيح عبر إرسال تنبيه تجريبي لصوت الأذان بعد 5 ثوانٍ. تأكد من أن هاتفك غير صامت.'
                : (isFrench
                    ? 'Vérifiez que les notifications fonctionnent en envoyant une alerte test dans 5 secondes. Assurez-vous que votre téléphone n\'est pas en silencieux.'
                    : 'Verify notifications are working by sending a test adhan alert in 5 seconds. Make sure your phone isn\'t on silent.'),
            style: themeService.getTextStyle(
              fontSize: 12.5,
              height: 1.5,
              color:
                  AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                HapticFeedback.selectionClick();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.send_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isArabic
                              ? 'سيصلك إشعار تجريبي بعد 5 ثوانٍ...'
                              : (isFrench
                                  ? 'Notification de test dans 5 secondes...'
                                  : 'Test notification in 5 seconds...'),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  duration: const Duration(seconds: 3),
                ));

                await Future.delayed(const Duration(seconds: 5));

                await NotificationService.showTestAdhan(
                  reciter: _selectedReciter,
                  isWholeAdhan: _isWholeAdhan,
                );
              },
              icon: const Icon(Icons.send_to_mobile_rounded, size: 20),
              label: Text(
                isArabic
                    ? 'إرسال إشعار تجريبي'
                    : (isFrench
                        ? 'Envoyer une notification test'
                        : 'Send Test Notification'),
                style: themeService.getTextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.5),
                  width: 1.4,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// SOUND WAVE INDICATOR
// ═══════════════════════════════════════════════════════════════════════

class _SoundWaveIndicator extends StatefulWidget {
  final Color color;
  final double size;
  const _SoundWaveIndicator({required this.color, this.size = 28});

  @override
  State<_SoundWaveIndicator> createState() => _SoundWaveIndicatorState();
}

class _SoundWaveIndicatorState extends State<_SoundWaveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double _barHeight(int i) {
    final phase = (_ctrl.value + i * 0.2) % 1.0;
    final v = phase < 0.5 ? phase * 2 : (1 - phase) * 2;
    return 0.3 + (v * 0.7);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(4, (i) {
              return Container(
                width: 3.5,
                height: widget.size * _barHeight(i),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}