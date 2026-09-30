import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/adhan_service.dart';
import '../services/notification_service.dart';
import '../services/theme_service.dart' show ThemeService, AppThemeMode, TextScaleFactor;
import '../app_theme.dart';
import '../widgets/islamic_pattern_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/adhan_reciter_translations.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  final int initialTab;
  
  // Set default index to 1 to default to the "System" tab
  const SettingsScreen({super.key, this.initialTab = 1});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late String _selectedLanguage;
  late String _selectedFont;
  late TabController _tabController;
  late AnimationController _animationController;

  void _showAboutApp(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final isArabic = langCode == 'ar';
    final isFrench = langCode == 'fr';

    showAboutDialog(
      context: context,
      applicationName: isArabic ? 'تطبيق إسلامي' : (isFrench ? 'Application Islamique' : 'Islamy App'),
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.mosque_rounded, size: 48, color: Color(0xFFD4AF37)),
      applicationLegalese: '© 2026 Abdullah Hesham. All rights reserved.',
      children: [
        const SizedBox(height: 16),
        Text(
          isArabic 
              ? 'رفيقك الإسلامي في حياتك اليومية.' 
              : 'Your Islamic companion in daily life.',
          style: TextStyle(color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.8)),
        ),
      ],
    );
  }

  final Map<String, String> _fontOptions = const {
    'amiri': 'Amiri (أميري)',
    'elMessiri': 'El Messiri (المسيري)',
    'arefRuqaa': 'Aref Ruqaa (عارف رقعة)',
    'cairo': 'Cairo (القاهرة)',
    'tajawal': 'Tajawal (تجول)',

    // --- NEW FONTS ADDED BELOW ---
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
      duration: const Duration(milliseconds: 800),
    );
    
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _animationController.forward(from: 0.0);
      }
    });

    _selectedLanguage = 'ar';
    _selectedFont = 'amiri';
    _loadSavedSettings();
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
    setState(() {
      _selectedLanguage = prefs.getString('locale') ?? 'ar';
      _selectedFont = prefs.getString('fontFamily') ?? 'amiri';
    });
  }

  Future<void> _updateFont(String fontKey) async {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    await themeService.setFontFamily(fontKey);
    setState(() {
      _selectedFont = fontKey;
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

    final String profileLabel = isArabic ? 'الملف الشخصي' : (isArabic == false && _selectedLanguage == 'fr' ? 'Profil' : 'Profile');
    final String systemLabel = isArabic ? 'النظام' : (isArabic == false && _selectedLanguage == 'fr' ? 'Système' : 'System');

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, l10n, isArabic, themeService),
                  Container(
                    color: isDark
                        ? const Color(0xFF0B3D2E).withValues(alpha: 0.5)
                        : const Color(0xFFF0F8F4).withValues(alpha: 0.5),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).colorScheme.secondary,
                      unselectedLabelColor: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.5),
                      indicatorColor: Theme.of(context).colorScheme.secondary,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(text: profileLabel),
                        Tab(text: systemLabel),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildProfileTab(context, l10n, isArabic, isDark, themeService),
                        _buildSystemTab(context, l10n, isArabic, isDark, themeService),
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isArabic, ThemeService themeService) {
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
              // FIX: Force the text style to inherit the newly selected 
              // global font family from main.dart immediately.
              style: themeService.getTextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ).copyWith(
                fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
              ),
            ),
          ),
          const SizedBox(width: 48),
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

  /// ── PROFILE TAB ──
  Widget _buildProfileTab(BuildContext context, AppLocalizations l10n, bool isArabic, bool isDark, ThemeService themeService) {
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
                    child: _buildProfileInfoSection(context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 1,
                    controller: _animationController,
                    child: _buildPasswordSection(context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 2,
                    controller: _animationController,
                    child: _buildBirthdaySection(context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 3,
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

  /// ── SYSTEM TAB ──
  Widget _buildSystemTab(BuildContext context, AppLocalizations l10n, bool isArabic, bool isDark, ThemeService themeService) {
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
                    child: _buildAdhanSystemSection(context, l10n, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 1,
                    controller: _animationController,
                    child: _buildTextScaleSection(context, l10n, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 2,
                    controller: _animationController,
                    child: _buildFontSection(context, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 3,
                    controller: _animationController,
                    child: _buildThemeSection(context, l10n, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 4,
                    controller: _animationController,
                    child: _buildLanguageSection(context, l10n, themeService, isDark),
                  ),
                  const SizedBox(height: 32),
                  _AnimatedSection(
                    index: 5,
                    controller: _animationController,
                    child: Container(
                      decoration: _getSectionDecoration(context, isDark),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.secondary, size: 26),
                        ),
                        title: Text(
                          isArabic ? 'عن التطبيق' : 'About App',
                          style: themeService.getTextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            color: AppTheme.getOnBackgroundColor(context)
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded, 
                          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5), 
                          size: 16
                        ),
                        onTap: () => _showAboutApp(context),
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

  Widget _buildProfileInfoSection(BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final authService = Provider.of<AuthService>(context);
    final String userName = authService.userName ?? 'Guest'; 
    final String userEmail = authService.userEmail ?? 'No email provided';
    final String profileTitle = lang == 'ar' ? 'معلومات الملف الشخصي' : (lang == 'fr' ? 'Informations du profil' : 'Profile Information');
    final String usernameLabel = lang == 'ar' ? 'اسم المستخدم' : (lang == 'fr' ? 'Nom d\'utilisateur' : 'Username');
    final String emailLabel = lang == 'ar' ? 'البريد الإلكتروني' : (lang == 'fr' ? 'E-mail' : 'Email');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.person_outline_rounded, color: Theme.of(context).colorScheme.secondary, size: 26),
            ),
            const SizedBox(width: 12),
            Text(
              profileTitle,
              style: themeService.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(usernameLabel, style: themeService.getTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Text(userName, style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.getOnBackgroundColor(context))),
              const SizedBox(height: 24),
              Text(emailLabel, style: themeService.getTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Text(userEmail, style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.getOnBackgroundColor(context))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordSection(BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String passwordTitle = lang == 'ar' ? 'كلمة المرور' : (lang == 'fr' ? 'Mot de passe' : 'Password');
    final String changePassword = lang == 'ar' ? 'تغيير كلمة المرور' : (lang == 'fr' ? 'Changer le mot de passe' : 'Change Password');
    final String forgotPassword = lang == 'ar' ? 'هل نسيت كلمة المرور؟' : (lang == 'fr' ? 'Mot de passe oublié?' : 'Forgot Password?');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.lock_outline_rounded, color: Theme.of(context).colorScheme.secondary, size: 26),
            ),
            const SizedBox(width: 12),
            Text(
              passwordTitle,
              style: themeService.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('••••••••••', style: themeService.getTextStyle(fontSize: 18, color: AppTheme.getOnBackgroundColor(context), letterSpacing: 6)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: isDark ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 2,
                      ),
                      child: Text(changePassword, style: themeService.getTextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(forgotPassword, style: themeService.getTextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary)),
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

  Widget _buildBirthdaySection(BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String birthdayTitle = lang == 'ar' ? 'تاريخ الميلاد' : (lang == 'fr' ? 'Date de naissance' : 'Birthday');
    final String editButton = lang == 'ar' ? 'تعديل' : (lang == 'fr' ? 'Modifier' : 'Edit');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.cake_outlined, color: Theme.of(context).colorScheme.secondary, size: 26),
            ),
            const SizedBox(width: 12),
            Text(
              birthdayTitle,
              style: themeService.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _getSectionDecoration(context, isDark),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('01/01/2000', style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.getOnBackgroundColor(context))),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: isDark ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  elevation: 2,
                ),
                child: Text(editButton, style: themeService.getTextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountSection(BuildContext context, ThemeService themeService) {
    final lang = _selectedLanguage;
    final String deleteTitle = lang == 'ar' ? 'حذف الحساب' : (lang == 'fr' ? 'Supprimer le compte' : 'Delete Account');
    final String deleteWarning = lang == 'ar' ? 'حذف حسابك نهائياً. لا يمكن التراجع عن هذا الإجراء.' : (lang == 'fr' ? 'Supprimer votre compte de manière permanente. Cette action ne peut pas être annulée.' : 'Delete your account permanently. This action cannot be undone.');
    final String deleteButton = lang == 'ar' ? 'حذف الحساب' : (lang == 'fr' ? 'Supprimer le compte' : 'Delete Account');

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
              child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 26),
            ),
            const SizedBox(width: 12),
            Text(deleteTitle, style: themeService.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red.withValues(alpha: 0.08), Colors.red.withValues(alpha: 0.03)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.red.withValues(alpha: 0.4), width: 1.5),
            boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.1), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(deleteWarning, style: themeService.getTextStyle(fontSize: 14, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.8), height: 1.6)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  child: Text(deleteButton, style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdhanSystemSection(BuildContext context, AppLocalizations l10n, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String adhanTitle = lang == 'ar' ? 'نظام الأذان' : (lang == 'fr' ? 'Système d\'Adhan' : 'Adhan System');
    final String manageButton = lang == 'ar' ? 'إدارة' : (lang == 'fr' ? 'Gérer' : 'Manage');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.notifications_outlined, color: Theme.of(context).colorScheme.secondary, size: 26),
            ),
            const SizedBox(width: 12),
            Text(adhanTitle, style: themeService.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context))),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang == 'ar' ? 'إدارة إعدادات الأذان والإشعارات والمدة والمقرئ' : (lang == 'fr' ? 'Gérer les paramètres d\'adhan, les notifications, la durée et le récitant' : 'Manage adhan settings, notifications, duration, and reciter'),
                style: themeService.getTextStyle(fontSize: 14, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.8), height: 1.6),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: isDark ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  child: Text(manageButton, style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextScaleSection(BuildContext context, AppLocalizations l10n, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String fontSizeTitle = lang == 'ar' ? 'حجم الخط' : (lang == 'fr' ? 'Taille de police' : 'Font Size');
    final String fontSizeDesc = lang == 'ar' ? 'عدّل حجم النص في جميع أنحاء التطبيق' : (lang == 'fr' ? 'Ajustez la taille du texte dans toute l\'application' : 'Adjust text size across the app');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.text_fields_rounded, color: Theme.of(context).colorScheme.secondary, size: 26),
            ),
            const SizedBox(width: 12),
            Text(fontSizeTitle, style: themeService.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context))),
          ],
        ),
        const SizedBox(height: 8),
        Text(fontSizeDesc, style: themeService.getTextStyle(fontSize: 14, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7))),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SizePreviewLetter(size: 14, active: themeService.textScaleFactor == TextScaleFactor.small),
                  _SizePreviewLetter(size: 18, active: themeService.textScaleFactor == TextScaleFactor.medium),
                  _SizePreviewLetter(size: 24, active: themeService.textScaleFactor == TextScaleFactor.large),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF144D32).withValues(alpha: 0.4) : const Color(0xFFE8F3EE).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    _buildScaleOption(context, themeService, TextScaleFactor.small, lang == 'ar' ? 'صغير' : (lang == 'fr' ? 'Petit' : 'Small'), isDark),
                    const SizedBox(width: 4),
                    _buildScaleOption(context, themeService, TextScaleFactor.medium, lang == 'ar' ? 'عادي' : (lang == 'fr' ? 'Moyen' : 'Medium'), isDark),
                    const SizedBox(width: 4),
                    _buildScaleOption(context, themeService, TextScaleFactor.large, lang == 'ar' ? 'كبير' : (lang == 'fr' ? 'Grand' : 'Large'), isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScaleOption(BuildContext context, ThemeService themeService, TextScaleFactor factor, String label, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: () => themeService.setTextScaleFactor(factor),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: themeService.textScaleFactor == factor ? Theme.of(context).colorScheme.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            boxShadow: themeService.textScaleFactor == factor ? [BoxShadow(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : [],
          ),
          child: Center(
            child: Text(
              label,
              style: themeService.getTextStyle(
                fontSize: 14,
                color: themeService.textScaleFactor == factor ? (isDark ? Colors.white : Colors.black) : AppTheme.getOnBackgroundColor(context),
                fontWeight: themeService.textScaleFactor == factor ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFontSection(BuildContext context, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String fontStyleTitle = lang == 'ar' ? 'نمط الخط' : (lang == 'fr' ? 'Style de police' : 'Font Style');
    final String fontStyleDesc = lang == 'ar' ? 'اختر خط مفضل لديك' : (lang == 'fr' ? 'Choisissez votre police préférée' : 'Select your preferred font');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.font_download_outlined, color: Theme.of(context).colorScheme.secondary, size: 26),
            ),
            const SizedBox(width: 12),
            Text(fontStyleTitle, style: themeService.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context))),
          ],
        ),
        const SizedBox(height: 8),
        Text(fontStyleDesc, style: themeService.getTextStyle(fontSize: 14, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7))),
        const SizedBox(height: 16),
        
        // --- NEW DROPDOWN MENU ---
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: _getSectionDecoration(context, isDark),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: isDark ? const Color(0xFF144D32) : Colors.white,
              // Fallback to amiri if a deleted font is somehow still saved in SharedPreferences
              value: _fontOptions.containsKey(_selectedFont) ? _selectedFont : 'amiri',
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down_rounded, color: Theme.of(context).colorScheme.secondary, size: 30),
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
                      fontWeight: _selectedFont == entry.key ? FontWeight.bold : FontWeight.normal,
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

  Widget _buildThemeSection(BuildContext context, AppLocalizations l10n, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String themeTitle = lang == 'ar' ? 'نمط المظهر' : (lang == 'fr' ? 'Style du thème' : 'Theme Style');
    final String themeDesc = lang == 'ar' ? 'اختر المظهر المفضل لديك' : (lang == 'fr' ? 'Choisissez votre thème préféré' : 'Select your preferred theme');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.palette_outlined, color: Theme.of(context).colorScheme.secondary, size: 26),
            ),
            const SizedBox(width: 12),
            Text(themeTitle, style: themeService.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context))),
          ],
        ),
        const SizedBox(height: 8),
        Text(themeDesc, style: themeService.getTextStyle(fontSize: 14, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7))),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            children: [
              _ThemeOptionCard(label: lang == 'ar' ? 'فاتح' : (lang == 'fr' ? 'Clair' : 'Light'), isSelected: themeService.themeMode == AppThemeMode.light, onTap: () => themeService.setThemeMode(AppThemeMode.light), icon: Icons.light_mode_rounded, themeService: themeService),
              const SizedBox(height: 12),
              _ThemeOptionCard(label: lang == 'ar' ? 'داكن' : (lang == 'fr' ? 'Sombre' : 'Dark'), isSelected: themeService.themeMode == AppThemeMode.dark, onTap: () => themeService.setThemeMode(AppThemeMode.dark), icon: Icons.dark_mode_rounded, themeService: themeService),
              const SizedBox(height: 12),
              _ThemeOptionCard(label: lang == 'ar' ? 'تلقائي' : (lang == 'fr' ? 'Auto' : 'Auto'), isSelected: themeService.themeMode == AppThemeMode.system, onTap: () => themeService.setThemeMode(AppThemeMode.system), icon: Icons.brightness_auto_rounded, themeService: themeService),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n, ThemeService themeService, bool isDark) {
    final lang = _selectedLanguage;
    final String languageTitle = lang == 'ar' ? 'اللغة' : (lang == 'fr' ? 'Langue' : 'Language');
    final String languageDesc = lang == 'ar' ? 'اختر لغتك المفضلة' : (lang == 'fr' ? 'Choisissez votre langue préférée' : 'Select your preferred language');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.language_rounded, color: Theme.of(context).colorScheme.secondary, size: 26),
            ),
            const SizedBox(width: 12),
            Text(languageTitle, style: themeService.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context))),
          ],
        ),
        const SizedBox(height: 8),
        Text(languageDesc, style: themeService.getTextStyle(fontSize: 14, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7))),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _getSectionDecoration(context, isDark),
          child: Column(
            children: [
              _InteractiveOptionCard(label: '🇪🇬 العربية', isSelected: _selectedLanguage == 'ar', onTap: () { IslamicApp.of(context)?.setLocale('ar'); setState(() => _selectedLanguage = 'ar'); }, themeService: themeService),
              const SizedBox(height: 12),
              _InteractiveOptionCard(label: '🇺🇸 English', isSelected: _selectedLanguage == 'en', onTap: () { IslamicApp.of(context)?.setLocale('en'); setState(() => _selectedLanguage = 'en'); }, themeService: themeService),
              const SizedBox(height: 12),
              _InteractiveOptionCard(label: '🇫🇷 Français', isSelected: _selectedLanguage == 'fr', onTap: () { IslamicApp.of(context)?.setLocale('fr'); setState(() => _selectedLanguage = 'fr'); }, themeService: themeService),
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

  const _AnimatedSection({required this.index, required this.child, required this.controller});

  @override
  Widget build(BuildContext context) {
    final startDelay = (index * 0.15).clamp(0.0, 1.0);
    final endDelay = (startDelay + 0.4).clamp(0.0, 1.0);
    final animation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: controller, curve: Interval(startDelay, endDelay, curve: Curves.easeOutCubic)));
    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Interval(startDelay, endDelay, curve: Curves.easeOut)));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Opacity(opacity: fade.value, child: FractionalTranslation(translation: animation.value, child: child)),
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
      style: TextStyle(fontSize: size, fontWeight: FontWeight.bold, color: active ? gold : (isDark ? Colors.white.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.3))),
      child: const Text('A'),
    );
  }
}

class _ThemeOptionCard extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final ThemeService themeService;

  const _ThemeOptionCard({required this.label, required this.isSelected, required this.onTap, required this.icon, required this.themeService});

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
              color: widget.isSelected || _isHovered ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15) : isDark ? const Color(0xFF144D32).withValues(alpha: 0.4) : const Color(0xFFE8F3EE).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.isSelected || _isHovered ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15), width: widget.isSelected ? 2 : 1),
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: widget.isSelected ? Theme.of(context).colorScheme.secondary : AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6)),
                const SizedBox(width: 12),
                Expanded(child: Text(widget.label, style: widget.themeService.getTextStyle(fontSize: 18, fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal, color: widget.isSelected ? Theme.of(context).colorScheme.secondary : AppTheme.getOnBackgroundColor(context)))),
                if (widget.isSelected) Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.secondary),
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

  const _InteractiveOptionCard({required this.label, required this.isSelected, required this.onTap, required this.themeService});

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
              color: widget.isSelected || _isHovered ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15) : isDark ? const Color(0xFF144D32).withValues(alpha: 0.4) : const Color(0xFFE8F3EE).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.isSelected || _isHovered ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15), width: widget.isSelected ? 2 : 1),
            ),
            child: Row(
              children: [
                Icon(widget.isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: widget.isSelected ? Theme.of(context).colorScheme.secondary : AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6)),
                const SizedBox(width: 12),
                Expanded(child: Text(widget.label, style: widget.themeService.getTextStyle(fontSize: 18, fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal, color: widget.isSelected ? Theme.of(context).colorScheme.secondary : AppTheme.getOnBackgroundColor(context)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdhanSettingsScreen extends StatefulWidget {
  const AdhanSettingsScreen({super.key});

  @override
  State<AdhanSettingsScreen> createState() => _AdhanSettingsScreenState();
}

class _AdhanSettingsScreenState extends State<AdhanSettingsScreen> with SingleTickerProviderStateMixin {
  late String _selectedReciter;
  bool _isWholeAdhan = true;
  bool _notificationsEnabled = true;
  bool _adhanPlaying = false;
  late AnimationController _animationController;

  bool _snoozeEnabled = true;
  String _selectedWakeSound = 'chilling_breeze';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _selectedReciter = 'mishary';
    _loadSettings();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedReciter = prefs.getString('adhanReciter') ?? 'mishary';
      _isWholeAdhan = prefs.getBool('isWholeAdhan') ?? true;
      _notificationsEnabled = NotificationService.areNotificationsEnabled();
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhanReciter', _selectedReciter);
    await prefs.setBool('isWholeAdhan', _isWholeAdhan);
  }

  Future<void> _playAdhan(AppLocalizations l10n) async {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.errorMessage}: $e'), backgroundColor: Colors.redAccent));
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

  Widget _buildPrayerAlarmsSection(BuildContext context, ThemeService themeService, bool isDark) {
    final lang = Localizations.localeOf(context).languageCode;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.alarm_add_rounded, color: Theme.of(context).colorScheme.secondary, size: 28),
            const SizedBox(width: 12),
            Text(lang == 'ar' ? 'منبهات الصلاة' : (lang == 'fr' ? 'Alarmes de prière' : 'Prayer Alarms'), style: themeService.getTextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context))),
          ],
        ),
        const SizedBox(height: 12),
        Text(lang == 'ar' ? 'إعداد منبهات متعددة، غفوة، وأصوات هادئة للاستيقاظ' : (lang == 'fr' ? 'Configurez plusieurs alarmes, des rappels et des sons de réveil apaisants' : 'Set multiple alarms, snoozes, and chilling wake-up sounds'), style: themeService.getTextStyle(fontSize: 14, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7))),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: isDark ? const Color(0xFF144D32).withValues(alpha: 0.3) : const Color(0xFFE8F3EE).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lang == 'ar' ? 'صوت الاستيقاظ' : (lang == 'fr' ? 'Son de réveil' : 'Wake-up Sound'), style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _InteractiveOptionCard(label: lang == 'ar' ? 'نسيم هادئ (موصى به)' : (lang == 'fr' ? 'Brise apaisante (recommandé)' : 'Chilling Breeze (Recommended)'), isSelected: _selectedWakeSound == 'chilling_breeze', onTap: () => setState(() => _selectedWakeSound = 'chilling_breeze'), themeService: themeService),
              const SizedBox(height: 8),
              _InteractiveOptionCard(label: lang == 'ar' ? 'أذان تقليدي' : (lang == 'fr' ? 'Adhan traditionnel' : 'Traditional Adhan'), isSelected: _selectedWakeSound == 'traditional', onTap: () => setState(() => _selectedWakeSound = 'traditional'), themeService: themeService),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: isDark ? const Color(0xFF144D32).withValues(alpha: 0.3) : const Color(0xFFE8F3EE).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lang == 'ar' ? 'تفعيل الغفوة (٥ دقائق)' : (lang == 'fr' ? 'Activer le rappel (5 min)' : 'Enable Snooze (5 mins)'), style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Switch(value: _snoozeEnabled, onChanged: (val) => setState(() => _snoozeEnabled = val), activeThumbColor: Theme.of(context).colorScheme.secondary),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildPrayerAlarmTile(context, themeService, isDark, lang, 'Fajr', Icons.wb_twilight_rounded),
      ],
    );
  }

  Widget _buildPrayerAlarmTile(BuildContext context, ThemeService themeService, bool isDark, String lang, String prayerName, IconData icon) {
    return ExpansionTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(prayerName, style: themeService.getTextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      subtitle: Text(lang == 'ar' ? 'منبهان مضبوطان' : (lang == 'fr' ? '2 alarmes définies' : '2 alarms set'), style: themeService.getTextStyle(fontSize: 12, color: Colors.grey)),
      children: [
        ListTile(title: Text(lang == 'ar' ? 'في وقت الصلاة تماماً' : (lang == 'fr' ? "À l'heure exacte de la prière" : 'At exact Salah time'), style: themeService.getTextStyle(fontSize: 14)), trailing: const Icon(Icons.remove_circle_outline, color: Colors.redAccent)),
        ListTile(title: Text(lang == 'ar' ? 'بعد ١٥ دقيقة (احتياطي)' : (lang == 'fr' ? '15 min après (secours)' : '15 mins after (Backup)'), style: themeService.getTextStyle(fontSize: 14)), trailing: const Icon(Icons.remove_circle_outline, color: Colors.redAccent)),
        TextButton.icon(onPressed: () {}, icon: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary), label: Text(lang == 'ar' ? 'إضافة منبه آخر' : (lang == 'fr' ? 'Ajouter une autre alarme' : 'Add another alarm'), style: TextStyle(color: Theme.of(context).colorScheme.secondary)))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Row(
                      children: [
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).colorScheme.secondary, size: 24)),
                        Expanded(child: Text(l10n.adhan, textAlign: TextAlign.center, style: themeService.getTextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary))),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: isDark ? [const Color(0xFF0B3D2E).withValues(alpha: 0.8), const Color(0xFF082D22).withValues(alpha: 0.9)] : [const Color(0xFFF0F8F4).withValues(alpha: 0.8), const Color(0xFFE4F1EB).withValues(alpha: 0.9)]),
                                border: Border(top: BorderSide(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4), width: 1.5)),
                              ),
                              child: ListView(
                                padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
                                children: [
                                  _AnimatedSection(
                                    index: 0,
                                    controller: _animationController,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: isDark ? [Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2), Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05)] : [Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15), Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05)]),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.notifications_active_rounded, color: Theme.of(context).colorScheme.secondary, size: 28),
                                          const SizedBox(width: 16),
                                          Expanded(child: Text(l10n.adhanNotifications, style: themeService.getTextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context)))),
                                          Switch(
                                            value: _notificationsEnabled,
                                            onChanged: (value) async {
                                              setState(() => _notificationsEnabled = value);
                                              await NotificationService.setNotificationsEnabled(value);
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'ar' ? (value ? 'الإشعارات مفعلة' : 'الإشعارات معطلة') : (lang == 'fr' ? (value ? 'Notifications activées' : 'Notifications désactivées') : (value ? 'Notifications enabled' : 'Notifications disabled'))), duration: const Duration(seconds: 2), backgroundColor: value ? Colors.green : Colors.orange));
                                              }
                                            },
                                            activeThumbColor: Theme.of(context).colorScheme.secondary,
                                            activeTrackColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4),
                                            inactiveThumbColor: Colors.white54,
                                            inactiveTrackColor: Colors.black.withValues(alpha: 0.3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  _AnimatedSection(
                                    index: 1,
                                    controller: _animationController,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(l10n.selectAdhanReciter, style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7))),
                                        const SizedBox(height: 16),
                                        _InteractiveOptionCard(label: AdhanReciterTranslations.getReciterName('mishary', lang), isSelected: _selectedReciter == 'mishary', onTap: () async { setState(() => _selectedReciter = 'mishary'); await _saveSettings(); }, themeService: themeService),
                                        const SizedBox(height: 12),
                                        _InteractiveOptionCard(label: AdhanReciterTranslations.getReciterName('nasser', lang), isSelected: _selectedReciter == 'nasser', onTap: () async { setState(() => _selectedReciter = 'nasser'); await _saveSettings(); }, themeService: themeService),
                                        const SizedBox(height: 12),
                                        _InteractiveOptionCard(label: AdhanReciterTranslations.getReciterName('qassas', lang), isSelected: _selectedReciter == 'qassas', onTap: () async { setState(() => _selectedReciter = 'qassas'); await _saveSettings(); }, themeService: themeService),
                                        const SizedBox(height: 12),
                                        _InteractiveOptionCard(label: AdhanReciterTranslations.getReciterName('refaat', lang), isSelected: _selectedReciter == 'refaat', onTap: () async { setState(() => _selectedReciter = 'refaat'); await _saveSettings(); }, themeService: themeService),
                                        const SizedBox(height: 12),
                                        _InteractiveOptionCard(label: AdhanReciterTranslations.getReciterName('tobar', lang), isSelected: _selectedReciter == 'tobar', onTap: () async { setState(() => _selectedReciter = 'tobar'); await _saveSettings(); }, themeService: themeService),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 36),
                                  _AnimatedSection(
                                    index: 2,
                                    controller: _animationController,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.timer_rounded, color: Theme.of(context).colorScheme.secondary, size: 24),
                                            const SizedBox(width: 12),
                                            Text(lang == 'ar' ? 'طول الأذان' : (lang == 'fr' ? 'Longueur de l\'Adhan' : 'Adhan Length'), style: themeService.getTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context))),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(lang == 'ar' ? 'اختر بين سماع التكبيرات الأولى فقط أو الأذان كاملاً' : (lang == 'fr' ? 'Choisissez d\'entendre uniquement les premiers takbeers ou l\'adhan complet' : 'Choose to hear only the first takbeers or the whole adhan'), style: themeService.getTextStyle(fontSize: 14, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7))),
                                        const SizedBox(height: 16),
                                        _InteractiveOptionCard(label: lang == 'ar' ? 'التكبيرات الأولى فقط' : (lang == 'fr' ? 'Premiers Takbeers uniquement' : 'First Takbeers Only'), isSelected: !_isWholeAdhan, onTap: () async { setState(() => _isWholeAdhan = false); await _saveSettings(); }, themeService: themeService),
                                        const SizedBox(height: 12),
                                        _InteractiveOptionCard(label: lang == 'ar' ? 'الأذان كاملاً' : (lang == 'fr' ? 'Adhan complet' : 'Whole Adhan'), isSelected: _isWholeAdhan, onTap: () async { setState(() => _isWholeAdhan = true); await _saveSettings(); }, themeService: themeService),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 36),
                                  _AnimatedSection(
                                    index: 3,
                                    controller: _animationController,
                                    child: _buildPrayerAlarmsSection(context, themeService, isDark),
                                  ),
                                  const SizedBox(height: 40),
                                  _AnimatedSection(
                                    index: 4,
                                    controller: _animationController,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: _adhanPlaying ? null : () => _playAdhan(l10n),
                                            icon: const Icon(Icons.play_arrow_rounded, size: 24),
                                            label: Text(l10n.playAdhan, style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary, foregroundColor: const Color(0xFF0B3D2E), disabledBackgroundColor: Colors.black.withValues(alpha: 0.2), disabledForegroundColor: Colors.white54, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 2),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: _adhanPlaying ? () => _stopAdhan() : null,
                                            icon: const Icon(Icons.stop_rounded, size: 24),
                                            label: Text(l10n.stop, style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withValues(alpha: 0.9), foregroundColor: Colors.white, disabledBackgroundColor: Colors.black.withValues(alpha: 0.2), disabledForegroundColor: Colors.white54, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _AnimatedSection(
                                    index: 5,
                                    controller: _animationController,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(lang == 'ar' ? 'سيصلك إشعار تجريبي بعد 5 ثوانٍ...' : (lang == 'fr' ? 'Vous recevrez une notification de test dans 5 secondes...' : 'Test notification arriving in 5 seconds...')),
                                              backgroundColor: Theme.of(context).colorScheme.secondary,
                                              duration: const Duration(seconds: 3),
                                            ),
                                          );
                                          
                                          await Future.delayed(const Duration(seconds: 5));
                                          
                                          await NotificationService.showTestAdhan(
                                            reciter: _selectedReciter,
                                            isWholeAdhan: _isWholeAdhan,
                                          );
                                        },
                                        icon: const Icon(Icons.send_to_mobile_rounded, size: 24),
                                        label: Text(
                                          lang == 'ar' ? 'تجربة إشعار الأذان' : (lang == 'fr' ? "Tester la notification d'adhan" : 'Test Adhan Notification'),
                                          style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDark ? const Color(0xFF144D32).withValues(alpha: 0.5) : const Color(0xFFE8F3EE).withValues(alpha: 0.8),
                                          foregroundColor: Theme.of(context).colorScheme.secondary,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5))),
                                          elevation: 0,
                                        ),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}