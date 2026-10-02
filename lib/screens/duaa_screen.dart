import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import '../data/duaa_data.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import '../utils/share_image_generator.dart';
import '../services/theme_service.dart';

class DuaaScreen extends StatefulWidget {
  const DuaaScreen({super.key});

  @override
  State<DuaaScreen> createState() => _DuaaScreenState();
}

class _DuaaScreenState extends State<DuaaScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _entranceCtrl;

  static const Color _gold = Color(0xFFD4AF37);

  // Category → icon map (keyed by English category name for stability)
  static const Map<String, IconData> _categoryIcons = {
    'Worry & Grief': Icons.sentiment_dissatisfied_rounded,
    'Knowledge & Education': Icons.school_rounded,
    'Sickness & Healing': Icons.healing_rounded,
    'Travel & Protection': Icons.flight_takeoff_rounded,
    'Success & Guidance': Icons.emoji_events_rounded,
    'Completing the Quran': Icons.menu_book_rounded,
    'Life & Sustenance': Icons.spa_rounded,
    'Family & Friends': Icons.family_restroom_rounded,
    'Sleep & Rest': Icons.bedtime_rounded,
    'Fear & Security': Icons.security_rounded,
    'Morning & Evening': Icons.wb_twilight_rounded,
    'Forgiveness & Repentance': Icons.volunteer_activism_rounded,
    'Ramadan & Fasting': Icons.nightlight_round,
    'Prayer & Worship': Icons.mosque_rounded,
    'Entering & Leaving Home': Icons.home_rounded,
    'Food & Drink': Icons.restaurant_rounded,
    'Weather & Nature': Icons.thunderstorm_rounded,
    'Gratitude & Barakah': Icons.favorite_rounded,
    'Hajj & Umrah': Icons.mosque_outlined,
  };

  // French translations for category names + titles (extend as needed)
  static const Map<String, String> _frenchCategories = {
    'Worry & Grief': 'Inquiétude et Chagrin',
    'Knowledge & Education': 'Savoir et Éducation',
    'Sickness & Healing': 'Maladie et Guérison',
    'Travel & Protection': 'Voyage et Protection',
    'Success & Guidance': 'Succès et Guidance',
    'Completing the Quran': 'Achèvement du Coran',
    'Life & Sustenance': 'Vie et Subsistance',
    'Family & Friends': 'Famille et Amis',
    'Sleep & Rest': 'Sommeil et Repos',
    'Fear & Security': 'Peur et Sécurité',
    'Morning & Evening': 'Matin et Soir',
    'Forgiveness & Repentance': 'Pardon et Repentir',
    'Ramadan & Fasting': 'Ramadan et Jeûne',
    'Prayer & Worship': 'Prière et Adoration',
    'Entering & Leaving Home': 'Entrer et Sortir de la Maison',
    'Food & Drink': 'Nourriture et Boisson',
    'Weather & Nature': 'Météo et Nature',
    'Gratitude & Barakah': 'Gratitude et Bénédiction',
    'Hajj & Umrah': 'Hajj et Umrah',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: DuaaData.categories.length,
      vsync: this,
    );
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  String _categoryLabel(DuaaCategory c, String lang) {
    if (lang == 'ar') return c.categoryAr;
    if (lang == 'fr') {
      return _frenchCategories[c.categoryEn] ?? c.categoryEn;
    }
    return c.categoryEn;
  }

  IconData _categoryIcon(DuaaCategory c) =>
      _categoryIcons[c.categoryEn] ?? Icons.menu_book_rounded;

  int get _totalDuaas => DuaaData.categories
      .fold<int>(0, (sum, cat) => sum + cat.duaas.length);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context, l10n, isArabic),
                  _buildHeroHeader(context, lang, isArabic, isDarkMode,
                      themeService),
                  const SizedBox(height: 6),
                  _buildTabBarStrip(isDarkMode, lang, themeService),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: TabBarView(
                          controller: _tabController,
                          children: DuaaData.categories
                              .map(
                                (category) => _CategoryList(
                                  category: category,
                                  lang: lang,
                                  themeService: themeService,
                                  categoryLabel: _categoryLabel(category, lang),
                                  categoryIcon: _categoryIcon(category),
                                ),
                              )
                              .toList(),
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

  // ─────────────────── TOP BAR ───────────────────

  Widget _buildTopBar(
      BuildContext context, AppLocalizations? l10n, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            tooltip: isArabic ? 'رجوع' : 'Back',
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          _GlassIconButton(
            icon: Icons.share_outlined,
            tooltip: isArabic ? 'مشاركة التطبيق' : 'Share app',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ─────────────────── HERO HEADER ───────────────────

  Widget _buildHeroHeader(
    BuildContext context,
    String lang,
    bool isArabic,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final title = isArabic
        ? 'الأدعية والأذكار'
        : (lang == 'fr' ? 'Invocations & Rappels' : 'Duas & Remembrances');
    final subtitle = isArabic
        ? 'مجموعة منتقاة من الأدعية المأثورة من الكتاب والسنة، مرتّبة بحسب المناسبات والحالات.'
        : (lang == 'fr'
            ? 'Une collection soigneusement sélectionnée d\'invocations du Coran et de la Sunna, organisée par thème.'
            : 'A carefully curated collection of authentic supplications from the Quran and Sunnah, organized by theme.');

    final categoriesLabel =
        isArabic ? 'فئة' : (lang == 'fr' ? 'catégories' : 'categories');
    final duasLabel = isArabic ? 'دعاء' : (lang == 'fr' ? 'invocations' : 'duas');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF1A5F3E).withValues(alpha: 0.75),
                    const Color(0xFF0E3824).withValues(alpha: 0.6),
                  ]
                : [
                    const Color(0xFFF7EFD3).withValues(alpha: 0.9),
                    const Color(0xFFEADAA0).withValues(alpha: 0.65),
                  ],
          ),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: _gold.withValues(alpha: 0.55),
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: _gold.withValues(alpha: 0.18),
              blurRadius: 22,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Big hero logo ──
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [_gold, Color(0xFFE6C200)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _gold.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: isArabic
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: themeService.getTextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF3A2E0E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: themeService.getTextStyle(
                          fontSize: 12.5,
                          height: 1.55,
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.75)
                              : Colors.black.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // ── Stat pills ──
            Row(
              children: [
                Expanded(
                  child: _StatPill(
                    icon: Icons.category_rounded,
                    value: '${DuaaData.categories.length}',
                    label: categoriesLabel,
                    themeService: themeService,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatPill(
                    icon: Icons.format_quote_rounded,
                    value: '$_totalDuaas',
                    label: duasLabel,
                    themeService: themeService,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatPill(
                    icon: Icons.verified_rounded,
                    value: isArabic
                        ? 'موثّق'
                        : (lang == 'fr' ? 'Authentique' : 'Authentic'),
                    label: isArabic
                        ? 'المصادر'
                        : (lang == 'fr' ? 'Sources' : 'Sources'),
                    themeService: themeService,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── TAB BAR ───────────────────

  Widget _buildTabBarStrip(
      bool isDarkMode, String lang, ThemeService themeService) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF0B3D2E).withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _gold.withValues(alpha: 0.35),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: isDarkMode
                ? BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: _buildTabBar(isDarkMode, lang, themeService),
                  )
                : _buildTabBar(isDarkMode, lang, themeService),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(
      bool isDarkMode, String lang, ThemeService themeService) {
    final labelColor = isDarkMode ? _gold : const Color(0xFF3A2E0E);
    final unselectedColor =
        isDarkMode ? Colors.white.withValues(alpha: 0.6) : Colors.black54;

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: labelColor,
      unselectedLabelColor: unselectedColor,
      indicatorColor: _gold,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      labelStyle: themeService.getTextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: themeService.getTextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
      ),
      tabAlignment: TabAlignment.start,
      tabs: DuaaData.categories.map((category) {
        final icon = _categoryIcon(category);
        final label = _categoryLabel(category, lang);
        return Tab(
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(label, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────── CATEGORY LIST ───────────────────

class _CategoryList extends StatelessWidget {
  final DuaaCategory category;
  final String lang;
  final ThemeService themeService;
  final String categoryLabel;
  final IconData categoryIcon;

  const _CategoryList({
    required this.category,
    required this.lang,
    required this.themeService,
    required this.categoryLabel,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = lang == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final count = category.duaas.length;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      itemCount: category.duaas.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _CategoryBanner(
            icon: categoryIcon,
            title: categoryLabel,
            count: count,
            isArabic: isArabic,
            lang: lang,
            isDarkMode: isDarkMode,
            themeService: themeService,
          );
        }
        final i = index - 1;
        return _DuaaCard(
          duaa: category.duaas[i],
          lang: lang,
          index: i,
          themeService: themeService,
        );
      },
    );
  }
}

// ─────────────────── CATEGORY BANNER ───────────────────

class _CategoryBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final bool isArabic;
  final String lang;
  final bool isDarkMode;
  final ThemeService themeService;

  const _CategoryBanner({
    required this.icon,
    required this.title,
    required this.count,
    required this.isArabic,
    required this.lang,
    required this.isDarkMode,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    final countLabel = isArabic
        ? '$count دعاء'
        : (lang == 'fr'
            ? '$count invocation${count > 1 ? 's' : ''}'
            : '$count dua${count > 1 ? 's' : ''}');

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4AF37).withValues(alpha: 0.9),
                  const Color(0xFFE6C200).withValues(alpha: 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: themeService.getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF3A2E0E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  countLabel,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: themeService.getTextStyle(
                    fontSize: 12.5,
                    letterSpacing: 0.4,
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────── DUAA CARD ───────────────────

class _DuaaCard extends StatefulWidget {
  final Duaa duaa;
  final String lang;
  final int index;
  final ThemeService themeService;

  const _DuaaCard({
    required this.duaa,
    required this.lang,
    required this.index,
    required this.themeService,
  });

  @override
  State<_DuaaCard> createState() => _DuaaCardState();
}

class _DuaaCardState extends State<_DuaaCard> {
  bool _isExpanded = false;
  double _scale = 1.0;

  static const Color _gold = Color(0xFFD4AF37);

  void _toggleExpand() => setState(() => _isExpanded = !_isExpanded);

  Future<void> _copyToClipboard(String text, {String? label}) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    final isArabic = widget.lang == 'ar';
    final isFrench = widget.lang == 'fr';
    final msg = label ??
        (isArabic
            ? 'تم النسخ إلى الحافظة'
            : (isFrench ? 'Copié dans le presse-papiers' : 'Copied to clipboard'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(msg)),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFF0B3D2E),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.lang == 'ar';
    final isFrench = widget.lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Resolve title & translation text (mirrors original behaviour)
    final String title;
    if (isArabic) {
      title = widget.duaa.titleAr;
    } else if (isFrench) {
      title = widget.duaa.titleEn;
    } else {
      title = widget.duaa.titleEn;
    }

    final String translation;
    if (isArabic) {
      translation = widget.duaa.duaaEn;
    } else {
      translation = widget.duaa.duaaEn;
    }

    final String benefit;
    if (isArabic) {
      benefit = widget.duaa.benefitAr ?? '';
    } else {
      benefit = widget.duaa.benefitEn ?? '';
    }

    return TweenAnimationBuilder<double>(
      duration:
          Duration(milliseconds: 300 + (widget.index * 55).clamp(0, 350)),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 26),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.985),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: _toggleExpand,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 140),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: isDarkMode
                    ? BackdropFilter(
                        filter:
                            ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: _buildCard(title, translation, benefit,
                            isArabic, isFrench, isDarkMode, true),
                      )
                    : _buildCard(title, translation, benefit, isArabic,
                        isFrench, isDarkMode, false),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    String title,
    String translation,
    String benefit,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    bool useBlur,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? (_isExpanded
                ? const Color(0xFF144D32).withValues(alpha: 0.82)
                : const Color(0xFF0B3D2E).withValues(alpha: 0.68))
            : (_isExpanded ? const Color(0xFFFFFDF6) : Colors.white),
        border: Border.all(
          color: _isExpanded
              ? _gold.withValues(alpha: 0.95)
              : _gold.withValues(alpha: 0.3),
          width: _isExpanded ? 2 : 1.2,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: _gold.withValues(alpha: _isExpanded ? 0.18 : 0.06),
                  blurRadius: _isExpanded ? 18 : 8,
                  spreadRadius: _isExpanded ? 1 : 0,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number badge
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      _gold.withValues(alpha: _isExpanded ? 1 : 0.75),
                      const Color(0xFFE6C200)
                          .withValues(alpha: _isExpanded ? 0.85 : 0.55),
                    ],
                  ),
                  boxShadow: _isExpanded
                      ? [
                          BoxShadow(
                            color: _gold.withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  '${widget.index + 1}',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    title,
                    style: widget.themeService.getTextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _isExpanded
                          ? (isDarkMode ? Colors.white : const Color(0xFF3A2E0E))
                          : _gold,
                    ),
                  ),
                ),
              ),
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.expand_more_rounded,
                  color: _isExpanded
                      ? (isDarkMode ? Colors.white : const Color(0xFF3A2E0E))
                      : _gold,
                  size: 28,
                ),
              ),
            ],
          ),

          // ── Expanded content ──
          if (_isExpanded) ...[
            const SizedBox(height: 20),
            _buildArabicBlock(isDarkMode),
            const SizedBox(height: 20),
            _buildSectionLabel(
              icon: Icons.translate_rounded,
              label: isArabic
                  ? 'الترجمة'
                  : (isFrench ? 'Traduction' : 'Translation'),
              themeService: widget.themeService,
            ),
            const SizedBox(height: 8),
            Text(
              translation,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: widget.themeService.getTextStyle(
                fontSize: 15.5,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.black87,
                height: 1.65,
                fontStyle: FontStyle.italic,
              ),
            ),
            if (benefit.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionLabel(
                icon: Icons.info_outline_rounded,
                label: isArabic
                    ? 'السياق والفضل'
                    : (isFrench ? 'Contexte & mérite' : 'Context & Virtue'),
                themeService: widget.themeService,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: isDarkMode ? 0.12 : 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _gold.withValues(alpha: 0.28),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded,
                        color: _gold, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        benefit,
                        textAlign:
                            isArabic ? TextAlign.right : TextAlign.left,
                        style: widget.themeService.getTextStyle(
                          fontSize: 13,
                          height: 1.55,
                          color: isDarkMode
                              ? Colors.white70
                              : Colors.black.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            _buildActionRow(isArabic, isFrench, isDarkMode, translation),
          ],
        ],
      ),
    );
  }

  Widget _buildArabicBlock(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF0F2D22),
                  const Color(0xFF08221A),
                ]
              : [
                  const Color(0xFFFDFBF3),
                  const Color(0xFFF5ECD0),
                ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _gold.withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _gold.withValues(alpha: 0.12),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome_rounded,
                  color: _gold.withValues(alpha: 0.8), size: 14),
              const SizedBox(width: 6),
              Text(
                '﷽',
                style: TextStyle(
                  fontSize: 16,
                  color: _gold.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.auto_awesome_rounded,
                  color: _gold.withValues(alpha: 0.8), size: 14),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.duaa.duaaAr,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: widget.themeService.getTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _gold,
              height: 2.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel({
    required IconData icon,
    required String label,
    required ThemeService themeService,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15, color: _gold.withValues(alpha: 0.9)),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: themeService.getTextStyle(
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: _gold.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(
      bool isArabic, bool isFrench, bool isDarkMode, String translation) {
    final copyArLabel = isArabic
        ? 'نسخ العربية'
        : (isFrench ? 'Copier (ar)' : 'Copy Arabic');
    final copyTrLabel = isArabic
        ? 'نسخ الترجمة'
        : (isFrench ? 'Copier traduction' : 'Copy translation');
    final shareLabel = isArabic
        ? 'مشاركة'
        : (isFrench ? 'Partager' : 'Share');

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
      children: [
        _PillButton(
          icon: Icons.copy_rounded,
          label: copyArLabel,
          onTap: () => _copyToClipboard(widget.duaa.duaaAr),
          isDarkMode: isDarkMode,
        ),
        _PillButton(
          icon: Icons.translate_rounded,
          label: copyTrLabel,
          onTap: () => _copyToClipboard(translation),
          isDarkMode: isDarkMode,
        ),
        _PillButton(
          icon: Icons.share_rounded,
          label: shareLabel,
          onTap: () {
            ShareImageGenerator.generateAndShareImageWithWidget(
              title: widget.duaa.duaaAr,
              subtitle: translation,
              isDarkMode: isDarkMode,
              lang: widget.lang,
              context: context,
            );
          },
          isDarkMode: isDarkMode,
          primary: true,
        ),
      ],
    );
  }
}

// ─────────────────── SHARED WIDGETS ───────────────────

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
                ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                : (isDark
                    ? const Color(0xFF144D32).withValues(alpha: 0.55)
                    : Colors.white.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFD4AF37)
                  .withValues(alpha: _hover ? 0.6 : 0.3),
            ),
          ),
          child: Icon(widget.icon,
              color: const Color(0xFFD4AF37), size: 20),
        ),
      ),
    );
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final ThemeService themeService;
  final bool isDarkMode;

  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.themeService,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: isDarkMode ? 0.15 : 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: themeService.getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF3A2E0E),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: themeService.getTextStyle(
              fontSize: 10,
              letterSpacing: 0.3,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDarkMode;
  final bool primary;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDarkMode,
    this.primary = false,
  });

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    final bg = widget.primary
        ? (_hover
            ? const Color(0xFFE6C200)
            : gold)
        : (_hover
            ? gold.withValues(alpha: 0.18)
            : gold.withValues(alpha: 0.08));
    final fg = widget.primary
        ? Colors.white
        : gold;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: gold.withValues(alpha: widget.primary ? 0 : 0.4),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 14, color: fg),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}