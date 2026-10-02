import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../services/deeds_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/islamic_pattern_background.dart';
import 'package:intl/intl.dart';
import '../services/theme_service.dart';
import '../app_theme.dart';


class GoodDeedsScreen extends StatefulWidget {
  const GoodDeedsScreen({super.key});

  @override
  State<GoodDeedsScreen> createState() => _GoodDeedsScreenState();
}

class _GoodDeedsScreenState extends State<GoodDeedsScreen>
    with TickerProviderStateMixin {
  List<GoodDeed> deeds = [];
  bool _isLoading = true;
  String? _selectedCategory;
  int _currentStreak = 0;
  int _totalDeeds = 0;
  int _todayDeeds = 0;

  late AnimationController _entranceCtrl;

  static const Color _gold = Color(0xFFD4AF37);

  final List<String> categories = [
    'prayer',
    'charity',
    'learning',
    'family',
    'other',
  ];

  final Map<String, IconData> categoryIcons = const {
    'prayer': Icons.self_improvement_rounded,
    'charity': Icons.volunteer_activism_rounded,
    'learning': Icons.school_rounded,
    'family': Icons.family_restroom_rounded,
    'other': Icons.favorite_rounded,
  };

  final Map<String, Color> categoryColors = const {
    'prayer': Color(0xFF4CAF50),
    'charity': Color(0xFFF44336),
    'learning': Color(0xFF2196F3),
    'family': Color(0xFF9C27B0),
    'other': Color(0xFFFF9800),
  };

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _loadData();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final loadedDeeds = await DeedsService.getAllDeeds();
      final streak = await DeedsService.getCurrentStreak();
      final total = await DeedsService.getTotalDeeds();
      final today = await DeedsService.getDeedCountToday();

      if (!mounted) return;
      setState(() {
        deeds = loadedDeeds;
        _currentStreak = streak;
        _totalDeeds = total;
        _todayDeeds = today;
        _isLoading = false;
      });
      _entranceCtrl.forward(from: 0);
    } catch (e, stackTrace) {
      debugPrint('Error loading good deeds: $e\n$stackTrace');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getCategoryName(String cat, AppLocalizations l10n) {
    switch (cat) {
      case 'prayer':
        return l10n.catPrayer;
      case 'charity':
        return l10n.catCharity;
      case 'learning':
        return l10n.catLearning;
      case 'family':
        return l10n.catFamily;
      case 'other':
        return l10n.catOther;
      default:
        return cat;
    }
  }

  void _showAddDeedDialog(
      BuildContext context, AppLocalizations l10n, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddDeedDialog(
        l10n: l10n,
        categories: categories,
        categoryIcons: categoryIcons,
        categoryColors: categoryColors,
        getCategoryName: (cat) => _getCategoryName(cat, l10n),
        onDeedAdded: _loadData,
        themeService: themeService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final filteredDeeds = _selectedCategory == null
        ? deeds
        : deeds.where((d) => d.category == _selectedCategory).toList();

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, l10n, isArabic, isFrench,
                      isDarkMode, themeService),
                  Expanded(
                    child: _isLoading
                        ? _buildLoadingState()
                        : Center(
                            child: ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxWidth: 820),
                              child: FadeTransition(
                                opacity: _entranceCtrl,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: _buildStatsCards(
                                          l10n, isDarkMode, themeService),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: _buildCategoryFilter(
                                          l10n, isDarkMode, themeService),
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: filteredDeeds.isEmpty
                                          ? _buildEmptyState(l10n,
                                              isDarkMode, isArabic, isFrench,
                                              themeService)
                                          : ListView.builder(
                                              padding: const EdgeInsets
                                                  .fromLTRB(20, 4, 20, 120),
                                              itemCount: filteredDeeds.length,
                                              itemBuilder: (context, index) {
                                                final deed =
                                                    filteredDeeds[index];
                                                return TweenAnimationBuilder<
                                                    double>(
                                                  duration: Duration(
                                                      milliseconds: 260 +
                                                          (index * 55)
                                                              .clamp(0, 400)),
                                                  tween: Tween(
                                                      begin: 0, end: 1),
                                                  curve: Curves.easeOutCubic,
                                                  builder:
                                                      (context, value, child) {
                                                    return Opacity(
                                                      opacity: value,
                                                      child:
                                                          Transform.translate(
                                                        offset: Offset(
                                                            0,
                                                            (1 - value) * 20),
                                                        child: child,
                                                      ),
                                                    );
                                                  },
                                                  child: _DeedGlassCard(
                                                    deed: deed,
                                                    l10n: l10n,
                                                    lang: lang,
                                                    color: categoryColors[
                                                            deed.category] ??
                                                        Colors.grey,
                                                    icon: categoryIcons[
                                                            deed.category] ??
                                                        Icons.favorite_rounded,
                                                    categoryName:
                                                        _getCategoryName(
                                                            deed.category,
                                                            l10n),
                                                    onDelete: () async {
                                                      await DeedsService
                                                          .deleteDeed(deed.id);
                                                      _loadData();
                                                    },
                                                    themeService:
                                                        themeService,
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endFloat,
          floatingActionButton: SafeArea(
            child: _buildFab(
                context, l10n, themeService, isArabic, isFrench, isDarkMode),
          ),
        );
      },
    );
  }

  // ─────────────────── HEADER ───────────────────

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            tooltip: isArabic ? 'رجوع' : 'Back',
            onTap: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  l10n.goodDeedsTitle,
                  textAlign: TextAlign.center,
                  style: themeService.getTextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _gold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isArabic
                      ? 'تابع حسناتك وابنِ عاداتك الصالحة'
                      : (isFrench
                          ? 'Suivez vos bonnes actions au quotidien'
                          : 'Track your good deeds, build lasting habits'),
                  textAlign: TextAlign.center,
                  style: themeService.getTextStyle(
                    fontSize: 11.5,
                    letterSpacing: 0.3,
                    color: AppTheme.getOnBackgroundColor(context)
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          _GlassIconButton(
            icon: Icons.insights_rounded,
            tooltip: isArabic
                ? 'نظرة عامة'
                : (isFrench ? 'Aperçu' : 'Insights'),
            onTap: () => _showInsightsSheet(
                context, l10n, isArabic, isFrench, isDarkMode, themeService),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: _gold,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Loading your deeds...',
            style: TextStyle(color: _gold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ─────────────────── STATS ───────────────────

  Widget _buildStatsCards(
      AppLocalizations l10n, bool isDarkMode, ThemeService themeService) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            value: _currentStreak.toString(),
            label: l10n.streakLabel,
            color: const Color(0xFFF44336),
            isDarkMode: isDarkMode,
            themeService: themeService,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.today_rounded,
            value: _todayDeeds.toString(),
            label: l10n.todayLabel,
            color: const Color(0xFF2196F3),
            isDarkMode: isDarkMode,
            themeService: themeService,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up_rounded,
            value: _totalDeeds.toString(),
            label: l10n.totalLabel,
            color: const Color(0xFF4CAF50),
            isDarkMode: isDarkMode,
            themeService: themeService,
          ),
        ),
      ],
    );
  }

  // ─────────────────── FILTER ───────────────────

  Widget _buildCategoryFilter(
      AppLocalizations l10n, bool isDarkMode, ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF0B3D2E).withValues(alpha: 0.45)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withValues(alpha: 0.28), width: 1.3),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: _gold.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterPill(
              l10n.allFilter,
              null,
              isDarkMode,
              themeService,
              icon: Icons.apps_rounded,
            ),
            const SizedBox(width: 8),
            ...categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterPill(
                  _getCategoryName(cat, l10n),
                  cat,
                  isDarkMode,
                  themeService,
                  icon: categoryIcons[cat],
                  color: categoryColors[cat],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(
      String label, String? cat, bool isDarkMode, ThemeService themeService,
      {IconData? icon, Color? color}) {
    final isSelected = _selectedCategory == cat;
    final accentColor = color ?? _gold;
    final count = cat == null
        ? deeds.length
        : deeds.where((d) => d.category == cat).length;

    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.28),
                    accentColor.withValues(alpha: 0.12),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : (isDarkMode
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? accentColor
                : (isDarkMode
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.grey.shade300),
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? accentColor
                    : (isDarkMode ? Colors.white60 : Colors.black54),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: themeService.getTextStyle(
                fontSize: 13.5,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? (isDarkMode ? Colors.white : accentColor)
                    : (isDarkMode ? Colors.white70 : Colors.black87),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.35)
                    : (isDarkMode
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: themeService.getTextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? (isDarkMode ? Colors.white : accentColor)
                      : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── EMPTY ───────────────────

  Widget _buildEmptyState(
    AppLocalizations l10n,
    bool isDarkMode,
    bool isArabic,
    bool isFrench,
    ThemeService themeService,
  ) {
    final hint = isArabic
        ? 'ابدأ بتسجيل أول حسنة لك اليوم، وشاهد سلسلتك تكبر مع الوقت.'
        : (isFrench
            ? 'Commencez par enregistrer votre première bonne action aujourd\'hui.'
            : 'Record your first good deed today and watch your streak grow.');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    _gold.withValues(alpha: 0.22),
                    _gold.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(
                  color: _gold.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.18),
                    blurRadius: 22,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.volunteer_activism_rounded,
                  size: 52, color: _gold),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noDeedsTitle,
              style: themeService.getTextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF3A2E0E),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              hint,
              style: themeService.getTextStyle(
                fontSize: 14,
                height: 1.55,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── FAB ───────────────────

  Widget _buildFab(
    BuildContext context,
    AppLocalizations l10n,
    ThemeService themeService,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
  ) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddDeedDialog(context, l10n, themeService),
      backgroundColor: _gold,
      foregroundColor: const Color(0xFF0B3D2E),
      elevation: 6,
      icon: const Icon(Icons.add_rounded, size: 26),
      label: Text(
        isArabic
            ? 'تسجيل حسنة'
            : (isFrench ? 'Ajouter' : 'Record deed'),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.5,
        ),
      ),
    );
  }

  // ─────────────────── INSIGHTS SHEET ───────────────────

  void _showInsightsSheet(
    BuildContext context,
    AppLocalizations l10n,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF0B3D2E).withValues(alpha: 0.96)
                : const Color(0xFFF8FAF9).withValues(alpha: 0.98),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: _gold.withValues(alpha: 0.35),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                          colors: [_gold, Color(0xFFE6C200)]),
                    ),
                    child: const Icon(Icons.insights_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isArabic
                        ? 'نظرة عامة على حسناتك'
                        : (isFrench
                            ? 'Aperçu de vos bonnes actions'
                            : 'Your deeds insights'),
                    style: themeService.getTextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF3A2E0E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _InsightRow(
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xFFF44336),
                label: isArabic
                    ? 'السلسلة الحالية'
                    : (isFrench ? 'Série actuelle' : 'Current streak'),
                value: isArabic
                    ? '$_currentStreak يوم'
                    : '$_currentStreak day${_currentStreak == 1 ? '' : 's'}',
                themeService: themeService,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 12),
              _InsightRow(
                icon: Icons.today_rounded,
                color: const Color(0xFF2196F3),
                label: isArabic
                    ? 'اليوم'
                    : (isFrench ? 'Aujourd\'hui' : 'Today'),
                value: isArabic
                    ? '$_todayDeeds حسنة'
                    : '$_todayDeeds deed${_todayDeeds == 1 ? '' : 's'}',
                themeService: themeService,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 12),
              _InsightRow(
                icon: Icons.trending_up_rounded,
                color: const Color(0xFF4CAF50),
                label: isArabic
                    ? 'الإجمالي الكلي'
                    : (isFrench ? 'Total général' : 'All-time total'),
                value: isArabic
                    ? '$_totalDeeds حسنة'
                    : '$_totalDeeds deed${_totalDeeds == 1 ? '' : 's'}',
                themeService: themeService,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),
              // Category breakdown
              Text(
                isArabic
                    ? 'التوزيع حسب الفئة'
                    : (isFrench
                        ? 'Répartition par catégorie'
                        : 'Breakdown by category'),
                style: themeService.getTextStyle(
                  fontSize: 13,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                  color: _gold.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 12),
              ...categories.map((cat) {
                final count =
                    deeds.where((d) => d.category == cat).length;
                final color = categoryColors[cat] ?? _gold;
                final ratio = _totalDeeds == 0
                    ? 0.0
                    : count / _totalDeeds;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(categoryIcons[cat], size: 16, color: color),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _getCategoryName(cat, l10n),
                                  style: themeService.getTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                Text(
                                  '$count',
                                  style: themeService.getTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 5,
                                backgroundColor: color
                                    .withValues(alpha: 0.15),
                                valueColor:
                                    AlwaysStoppedAnimation(color),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STAT CARD
// ═══════════════════════════════════════════════════════════════

class _StatCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDarkMode;
  final ThemeService themeService;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDarkMode,
    required this.themeService,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isDarkMode
              ? [
                  widget.color.withValues(alpha: 0.22),
                  const Color(0xFF0B3D2E).withValues(alpha: 0.55),
                ]
              : [
                  Colors.white,
                  widget.color.withValues(alpha: 0.06),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: widget.color.withValues(alpha: 0.35), width: 1.4),
        boxShadow: widget.isDarkMode
            ? []
            : [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.15),
            ),
            child: Icon(widget.icon, color: widget.color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            widget.value,
            style: TextStyle(
              color: widget.color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: widget.themeService.getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.isDarkMode
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// INSIGHT ROW
// ═══════════════════════════════════════════════════════════════

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final ThemeService themeService;
  final bool isDarkMode;

  const _InsightRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.themeService,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDarkMode ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: themeService.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: themeService.getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// GLASS ICON BUTTON
// ═══════════════════════════════════════════════════════════════

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

// ═══════════════════════════════════════════════════════════════
// ADD DEED DIALOG — REDESIGNED
// ═══════════════════════════════════════════════════════════════

class _AddDeedDialog extends StatefulWidget {
  final AppLocalizations l10n;
  final List<String> categories;
  final Map<String, IconData> categoryIcons;
  final Map<String, Color> categoryColors;
  final String Function(String) getCategoryName;
  final VoidCallback onDeedAdded;
  final ThemeService themeService;

  const _AddDeedDialog({
    required this.l10n,
    required this.categories,
    required this.categoryIcons,
    required this.categoryColors,
    required this.getCategoryName,
    required this.onDeedAdded,
    required this.themeService,
  });

  @override
  State<_AddDeedDialog> createState() => _AddDeedDialogState();
}

class _AddDeedDialogState extends State<_AddDeedDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  String _selectedCategory = 'other';
  bool _isSubmitting = false;

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _deepGreen = Color(0xFF1B5E3F);

  // Quick suggestions per category
  static const Map<String, List<String>> _suggestions = {
    'prayer': [
      'Prayed on time',
      'Read Quran',
      'Made dua for someone',
      'Prayed in congregation',
    ],
    'charity': [
      'Gave sadaqah',
      'Helped someone in need',
      'Fed someone',
      'Donated to charity',
    ],
    'learning': [
      'Studied Islamic knowledge',
      'Attended a lesson',
      'Read beneficial book',
      'Taught someone something',
    ],
    'family': [
      'Called parents',
      'Helped family member',
      'Made family happy',
      'Visited relatives',
    ],
    'other': [
      'Smiled at someone',
      'Removed harm from path',
      'Made istighfar 100x',
      'Sent salawat on Prophet',
    ],
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitDeed() async {
    if (_titleController.text.trim().isEmpty || _isSubmitting) return;
    setState(() => _isSubmitting = true);

    HapticFeedback.mediumImpact();

    final deed = GoodDeed(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      category: _selectedCategory,
      timestamp: DateTime.now(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    await DeedsService.addDeed(deed);

    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onDeedAdded();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF0B3D2E).withValues(alpha: 0.96)
                  : const Color(0xFFF8FAF9).withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _gold.withValues(alpha: 0.45),
                width: 1.5,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDialogHeader(isDarkMode),
                  const SizedBox(height: 22),
                  _buildTitleField(isDarkMode),
                  const SizedBox(height: 20),
                  _buildCategoryPicker(isDarkMode),
                  const SizedBox(height: 16),
                  _buildSuggestions(isDarkMode),
                  const SizedBox(height: 20),
                  _buildNotesField(isDarkMode),
                  const SizedBox(height: 22),
                  _buildActions(isDarkMode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [_gold, Color(0xFFE6C200)],
            ),
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.4),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(Icons.volunteer_activism_rounded,
              color: Colors.white, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.l10n.recordDeedTitle,
                style: widget.themeService.getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : _deepGreen,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Record a good deed and earn rewards',
                style: widget.themeService.getTextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.65)
                      : Colors.black.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(bool isDarkMode) {
    return TextField(
      controller: _titleController,
      textInputAction: TextInputAction.next,
      style: widget.themeService.getTextStyle(
        fontSize: 15.5,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: widget.l10n.deedTitleLabel,
        labelStyle: widget.themeService.getTextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
        ),
        hintText: widget.l10n.deedTitleHint,
        hintStyle: widget.themeService.getTextStyle(
          fontSize: 13.5,
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.grey.shade400,
        ),
        prefixIcon: const Icon(Icons.edit_rounded, color: _gold, size: 20),
        filled: true,
        fillColor: isDarkMode
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: _gold.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: _gold.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _gold, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryPicker(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.category_rounded, size: 16, color: _gold),
            const SizedBox(width: 8),
            Text(
              widget.l10n.categoryLabel,
              style: widget.themeService.getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: _gold.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            final color = widget.categoryColors[cat] ?? _gold;

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedCategory = cat);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.28),
                            color.withValues(alpha: 0.12),
                          ],
                        )
                      : null,
                  color: isSelected
                      ? null
                      : (isDarkMode
                          ? Colors.black.withValues(alpha: 0.25)
                          : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? color
                        : (isDarkMode
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.grey.shade300),
                    width: isSelected ? 1.8 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.25),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.categoryIcons[cat],
                      size: 16,
                      color: color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.getCategoryName(cat),
                      style: widget.themeService.getTextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? (isDarkMode ? Colors.white : color)
                            : (isDarkMode ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSuggestions(bool isDarkMode) {
    final suggestions = _suggestions[_selectedCategory] ?? [];
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, size: 14, color: _gold),
            const SizedBox(width: 6),
            Text(
              'Quick suggestions',
              style: widget.themeService.getTextStyle(
                fontSize: 11.5,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                color: _gold.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: suggestions.map((s) {
            return GestureDetector(
              onTap: () {
                setState(() => _titleController.text = s);
                HapticFeedback.selectionClick();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: isDarkMode ? 0.12 : 0.09),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _gold.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  s,
                  style: widget.themeService.getTextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesField(bool isDarkMode) {
    return TextField(
      controller: _notesController,
      maxLines: 2,
      style: widget.themeService.getTextStyle(
        fontSize: 15,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: widget.l10n.notesLabel,
        labelStyle: widget.themeService.getTextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
        ),
        hintText: widget.l10n.notesHint,
        hintStyle: widget.themeService.getTextStyle(
          fontSize: 13.5,
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.grey.shade400,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Icon(Icons.notes_rounded,
              color: _gold.withValues(alpha: 0.85), size: 20),
        ),
        filled: true,
        fillColor: isDarkMode
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: _gold.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: _gold.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _gold, width: 2),
        ),
      ),
    );
  }

  Widget _buildActions(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed:
                _isSubmitting ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDarkMode ? Colors.white70 : Colors.black54,
              side: BorderSide(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              widget.l10n.cancelBtn,
              style: widget.themeService.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submitDeed,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.check_rounded, size: 20),
            label: Text(
              widget.l10n.recordBtn,
              style: widget.themeService.getTextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _deepGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DEED CARD
// ═══════════════════════════════════════════════════════════════

class _DeedGlassCard extends StatefulWidget {
  final GoodDeed deed;
  final AppLocalizations l10n;
  final String lang;
  final Color color;
  final IconData icon;
  final String categoryName;
  final VoidCallback onDelete;
  final ThemeService themeService;

  const _DeedGlassCard({
    required this.deed,
    required this.l10n,
    required this.lang,
    required this.color,
    required this.icon,
    required this.categoryName,
    required this.onDelete,
    required this.themeService,
  });

  @override
  State<_DeedGlassCard> createState() => _DeedGlassCardState();
}

class _DeedGlassCardState extends State<_DeedGlassCard> {
  bool _isHovered = false;

  String _relativeTime(DateTime dt, bool isArabic, bool isFrench) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) {
      return isArabic
          ? 'الآن'
          : (isFrench ? 'À l\'instant' : 'Just now');
    }
    if (diff.inMinutes < 60) {
      return isArabic
          ? 'منذ ${diff.inMinutes} د'
          : (isFrench
              ? 'il y a ${diff.inMinutes}m'
              : '${diff.inMinutes}m ago');
    }
    if (diff.inHours < 24) {
      return isArabic
          ? 'منذ ${diff.inHours} س'
          : (isFrench
              ? 'il y a ${diff.inHours}h'
              : '${diff.inHours}h ago');
    }
    return DateFormat('dd MMM, HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isArabic = widget.lang == 'ar';
    final isFrench = widget.lang == 'fr';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [
                          widget.color.withValues(alpha: 0.2),
                          const Color(0xFF0B3D2E).withValues(alpha: 0.6),
                        ]
                      : [
                          Colors.white,
                          widget.color.withValues(alpha: 0.05),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isHovered
                      ? widget.color
                      : widget.color.withValues(alpha: 0.3),
                  width: _isHovered ? 1.8 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color
                        .withValues(alpha: _isHovered ? 0.18 : 0.07),
                    blurRadius: _isHovered ? 16 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              widget.color.withValues(alpha: 0.85),
                              widget.color.withValues(alpha: 0.5),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withValues(alpha: 0.35),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(widget.icon,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.deed.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: widget.themeService.getTextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: widget.color
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: widget.color
                                          .withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Text(
                                    widget.categoryName,
                                    style:
                                        widget.themeService.getTextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: widget.color,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 11,
                                  color: isDarkMode
                                      ? Colors.white
                                          .withValues(alpha: 0.5)
                                      : Colors.black45,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    _relativeTime(
                                        widget.deed.timestamp,
                                        isArabic,
                                        isFrench),
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        widget.themeService.getTextStyle(
                                      fontSize: 11.5,
                                      color: isDarkMode
                                          ? Colors.white
                                              .withValues(alpha: 0.55)
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _DeedActionButton(
                        icon: Icons.close_rounded,
                        color: Colors.redAccent,
                        onTap: widget.onDelete,
                        tooltip: isArabic ? 'حذف' : 'Delete',
                      ),
                    ],
                  ),
                  if (widget.deed.notes != null &&
                      widget.deed.notes!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.color
                            .withValues(alpha: isDarkMode ? 0.1 : 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.color.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.notes_rounded,
                            size: 14,
                            color: widget.color.withValues(alpha: 0.85),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.deed.notes!,
                              style: widget.themeService.getTextStyle(
                                fontSize: 13,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                                color: isDarkMode
                                    ? Colors.white.withValues(alpha: 0.85)
                                    : Colors.black.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeedActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? tooltip;

  const _DeedActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.tooltip,
  });

  @override
  State<_DeedActionButton> createState() => _DeedActionButtonState();
}

class _DeedActionButtonState extends State<_DeedActionButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hover
                ? widget.color.withValues(alpha: 0.18)
                : widget.color.withValues(alpha: 0.08),
            border: Border.all(
              color: widget.color.withValues(alpha: _hover ? 0.6 : 0.3),
            ),
          ),
          child: Icon(widget.icon, color: widget.color, size: 16),
        ),
      ),
    );
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}