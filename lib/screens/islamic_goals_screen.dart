import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../services/goals_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/islamic_pattern_background.dart';
import '../services/theme_service.dart';

class IslamicGoalsScreen extends StatefulWidget {
  const IslamicGoalsScreen({super.key});

  @override
  State<IslamicGoalsScreen> createState() => _IslamicGoalsScreenState();
}

class _IslamicGoalsScreenState extends State<IslamicGoalsScreen>
    with TickerProviderStateMixin {
  List<IslamicGoal> goals = [];
  bool _isLoading = true;

  late AnimationController _entranceCtrl;

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _deepGreen = Color(0xFF1B5E3F);

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _loadGoals();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadGoals() async {
    setState(() => _isLoading = true);
    try {
      final loadedGoals = await GoalsService.getAllGoals();
      if (!mounted) return;
      setState(() {
        goals = loadedGoals;
        _isLoading = false;
      });
      _entranceCtrl.forward(from: 0);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  // ─────────────── COMPUTED STATS ───────────────

  int get _activeCount => goals.where((g) => !g.isCompleted).length;
  int get _completedCount => goals.where((g) => g.isCompleted).length;

  double get _overallProgress {
    if (goals.isEmpty) return 0;
    final sum = goals.fold<double>(
      0,
      (acc, g) => acc + (g.progressPercentage / 100),
    );
    return sum / goals.length;
  }

  // ─────────────── DIALOGS ───────────────

  void _showAddGoalDialog(
      BuildContext context, AppLocalizations l10n, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (_) => _AddGoalDialog(
        l10n: l10n,
        themeService: themeService,
        onGoalCreated: _loadGoals,
        getGoalDescription: _getGoalDescription,
      ),
    );
  }

  String _getGoalDescription(String type, AppLocalizations l10n) {
    switch (type) {
      case 'quran':
        return l10n.goalTypeQuran;
      case 'surah':
        return l10n.goalTypeSurah;
      case 'prayer_streak':
        return l10n.goalTypePrayer;
      default:
        return l10n.islamicGoalsTitle;
    }
  }

  void _showProgressDialog(BuildContext context, IslamicGoal goal,
      AppLocalizations l10n, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (_) => _UpdateProgressDialog(
        goal: goal,
        l10n: l10n,
        themeService: themeService,
        onUpdated: _loadGoals,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, IslamicGoal goal,
      AppLocalizations l10n, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: isDark
              ? const Color(0xFF0B3D2E).withValues(alpha: 0.96)
              : const Color(0xFFF8FAF9),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withValues(alpha: 0.15),
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    color: Colors.redAccent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.deleteGoalTitle,
                  style: themeService.getTextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            '${l10n.deleteGoalDesc}\n\n"${goal.title}"',
            style: themeService.getTextStyle(
              fontSize: 14.5,
              height: 1.55,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                l10n.cancelBtn,
                style: themeService.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white60 : Colors.grey.shade700,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                HapticFeedback.mediumImpact();
                await GoalsService.deleteGoal(goal.id);
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                if (mounted) _loadGoals();
              },
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: Text(
                l10n.deleteBtn,
                style: themeService.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─────────────── BUILD ───────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, l10n, isArabic, isFrench, isDarkMode,
                      themeService),
                  Expanded(
                    child: _isLoading
                        ? _buildLoading()
                        : Center(
                            child: ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxWidth: 820),
                              child: FadeTransition(
                                opacity: _entranceCtrl,
                                child: goals.isEmpty
                                    ? _buildEmptyState(context, l10n,
                                        isArabic, isFrench, isDarkMode,
                                        themeService)
                                    : _buildGoalsList(context, l10n, isArabic,
                                        isFrench, isDarkMode, themeService),
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
            child: FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.selectionClick();
                _showAddGoalDialog(context, l10n, themeService);
              },
              backgroundColor: _gold,
              foregroundColor: const Color(0xFF0B3D2E),
              elevation: 6,
              icon: const Icon(Icons.add_rounded, size: 26),
              label: Text(
                isArabic
                    ? 'هدف جديد'
                    : (isFrench ? 'Nouvel objectif' : 'New goal'),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14.5),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
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
          Text(
            'Loading your goals...',
            style: TextStyle(color: _gold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ─────────────── HEADER ───────────────

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
            onTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  l10n.islamicGoalsTitle,
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
                      ? 'حدّد أهدافك وابنِ عاداتك الروحية بثبات'
                      : (isFrench
                          ? 'Fixez vos objectifs et construisez vos habitudes'
                          : 'Set goals, build spiritual habits steadily'),
                  textAlign: TextAlign.center,
                  style: themeService.getTextStyle(
                    fontSize: 11.5,
                    letterSpacing: 0.3,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.black.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          _GlassIconButton(
            icon: Icons.insights_rounded,
            tooltip: isArabic
                ? 'نظرة عامة'
                : (isFrench ? 'Aperçu' : 'Overview'),
            onTap: () => _showOverviewSheet(context, l10n, isArabic, isFrench,
                isDarkMode, themeService),
          ),
        ],
      ),
    );
  }

  // ─────────────── EMPTY STATE ───────────────

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final hint = isArabic
        ? 'ابدأ بتحديد هدفك الأول — مثل ختم القرآن في شهر، أو المحافظة على الصلوات الخمس لمدة أسبوع.'
        : (isFrench
            ? 'Commencez par définir votre premier objectif — par exemple finir le Coran en un mois.'
            : 'Start by setting your first goal — like finishing the Quran in a month, or praying 5x for a week.');

    final suggestions = isArabic
        ? [
            'ختم القرآن في شهر',
            'قراءة سورة الكهف كل جمعة',
            'المحافظة على الصلوات الخمس',
          ]
        : isFrench
            ? [
                'Finir le Coran en un mois',
                'Lire Al-Kahf chaque vendredi',
                'Maintenir les 5 prières',
              ]
            : [
                'Finish Quran in a month',
                'Read Surat Al-Kahf every Friday',
                'Maintain the 5 daily prayers',
              ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
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
            child: const Icon(Icons.flag_circle_rounded,
                size: 52, color: _gold),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noGoalsTitle,
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
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Divider(color: _gold.withValues(alpha: 0.3)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  isArabic
                      ? 'أفكار مقترحة'
                      : (isFrench ? 'Suggestions' : 'Ideas to start'),
                  style: TextStyle(
                    color: _gold.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: _gold.withValues(alpha: 0.3)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...suggestions.map((s) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SuggestionChip(
                text: s,
                isArabic: isArabic,
                isDarkMode: isDarkMode,
                onTap: () {
                  HapticFeedback.selectionClick();
                  _showAddGoalDialog(
                      context, l10n, themeService);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─────────────── GOALS LIST ───────────────

  Widget _buildGoalsList(
    BuildContext context,
    AppLocalizations l10n,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final activeGoals = goals.where((g) => !g.isCompleted).toList();
    final completedGoals = goals.where((g) => g.isCompleted).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      children: [
        // ── Stats strip ──
        _buildStatsStrip(isArabic, isFrench, isDarkMode, themeService),
        const SizedBox(height: 22),

        if (activeGoals.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.track_changes_rounded,
            title: l10n.activeGoals,
            count: activeGoals.length,
            color: _gold,
            themeService: themeService,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 12),
          ...activeGoals.asMap().entries.map((entry) {
            final idx = entry.key;
            final goal = entry.value;
            return TweenAnimationBuilder<double>(
              duration:
                  Duration(milliseconds: 260 + (idx * 55).clamp(0, 400)),
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: child,
                ),
              ),
              child: _GoalGlassCard(
                goal: goal,
                l10n: l10n,
                isArabic: isArabic,
                isFrench: isFrench,
                isDarkMode: isDarkMode,
                onUpdate: () => _showProgressDialog(
                    context, goal, l10n, themeService),
                onDelete: () => _showDeleteConfirmation(
                    context, goal, l10n, themeService),
                themeService: themeService,
              ),
            );
          }),
        ],

        if (completedGoals.isNotEmpty) ...[
          const SizedBox(height: 32),
          _SectionHeader(
            icon: Icons.emoji_events_rounded,
            title: l10n.completedGoals,
            count: completedGoals.length,
            color: const Color(0xFF4CAF50),
            themeService: themeService,
            isDarkMode: isDarkMode,
            muted: true,
          ),
          const SizedBox(height: 12),
          ...completedGoals.asMap().entries.map((entry) {
            final idx = entry.key;
            final goal = entry.value;
            return TweenAnimationBuilder<double>(
              duration:
                  Duration(milliseconds: 240 + (idx * 50).clamp(0, 400)),
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 18),
                  child: child,
                ),
              ),
              child: _GoalGlassCard(
                goal: goal,
                l10n: l10n,
                isArabic: isArabic,
                isFrench: isFrench,
                isDarkMode: isDarkMode,
                onUpdate: () => _showProgressDialog(
                    context, goal, l10n, themeService),
                onDelete: () => _showDeleteConfirmation(
                    context, goal, l10n, themeService),
                themeService: themeService,
              ),
            );
          }),
        ],
      ],
    );
  }

  // ─────────────── STATS STRIP ───────────────

  Widget _buildStatsStrip(
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final activeLabel =
        isArabic ? 'نشط' : (isFrench ? 'Actifs' : 'Active');
    final completedLabel =
        isArabic ? 'مكتمل' : (isFrench ? 'Terminés' : 'Completed');
    final progressLabel =
        isArabic ? 'التقدم' : (isFrench ? 'Progrès' : 'Overall');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF1A5F3E).withValues(alpha: 0.55),
                  const Color(0xFF0E3824).withValues(alpha: 0.45),
                ]
              : [
                  const Color(0xFFF7EFD3).withValues(alpha: 0.9),
                  const Color(0xFFEADAA0).withValues(alpha: 0.55),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withValues(alpha: 0.4), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: _gold.withValues(alpha: 0.14),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatsPill(
              icon: Icons.track_changes_rounded,
              value: '$_activeCount',
              label: activeLabel,
              color: _gold,
              isDarkMode: isDarkMode,
              themeService: themeService,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatsPill(
              icon: Icons.emoji_events_rounded,
              value: '$_completedCount',
              label: completedLabel,
              color: const Color(0xFF4CAF50),
              isDarkMode: isDarkMode,
              themeService: themeService,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatsPill(
              icon: Icons.trending_up_rounded,
              value: '${(_overallProgress * 100).toStringAsFixed(0)}%',
              label: progressLabel,
              color: const Color(0xFF2196F3),
              isDarkMode: isDarkMode,
              themeService: themeService,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────── OVERVIEW SHEET ───────────────

  void _showOverviewSheet(
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
                  Expanded(
                    child: Text(
                      isArabic
                          ? 'نظرة عامة على الأهداف'
                          : (isFrench
                              ? 'Aperçu de vos objectifs'
                              : 'Your goals overview'),
                      style: themeService.getTextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF3A2E0E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _InsightRow(
                icon: Icons.track_changes_rounded,
                color: _gold,
                label: isArabic
                    ? 'الأهداف النشطة'
                    : (isFrench ? 'Objectifs actifs' : 'Active goals'),
                value: '$_activeCount',
                themeService: themeService,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 10),
              _InsightRow(
                icon: Icons.emoji_events_rounded,
                color: const Color(0xFF4CAF50),
                label: isArabic
                    ? 'الأهداف المكتملة'
                    : (isFrench
                        ? 'Objectifs terminés'
                        : 'Completed goals'),
                value: '$_completedCount',
                themeService: themeService,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 10),
              _InsightRow(
                icon: Icons.trending_up_rounded,
                color: const Color(0xFF2196F3),
                label: isArabic
                    ? 'متوسط التقدم'
                    : (isFrench ? 'Progression moyenne' : 'Average progress'),
                value: '${(_overallProgress * 100).toStringAsFixed(0)}%',
                themeService: themeService,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),
              if (goals.isNotEmpty) ...[
                Text(
                  isArabic
                      ? 'تقدم كل هدف'
                      : (isFrench
                          ? 'Progression par objectif'
                          : 'Progress by goal'),
                  style: themeService.getTextStyle(
                    fontSize: 13,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w700,
                    color: _gold.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 12),
                ...goals.take(6).map((g) {
                  final color =
                      g.isCompleted ? const Color(0xFF4CAF50) : _gold;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                g.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: themeService.getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            Text(
                              '${g.progressPercentage.toStringAsFixed(0)}%',
                              style: themeService.getTextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: g.progressPercentage / 100,
                            minHeight: 5,
                            backgroundColor:
                                color.withValues(alpha: 0.15),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final ThemeService themeService;
  final bool isDarkMode;
  final bool muted;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.themeService,
    required this.isDarkMode,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.15),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: themeService.getTextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? (muted
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.white)
                  : (muted ? Colors.black54 : const Color(0xFF3A2E0E)),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Text(
            '$count',
            style: themeService.getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STATS PILL
// ═══════════════════════════════════════════════════════════════

class _StatsPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDarkMode;
  final ThemeService themeService;

  const _StatsPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDarkMode,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDarkMode ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: themeService.getTextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: themeService.getTextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white70 : Colors.black54,
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
// SUGGESTION CHIP
// ═══════════════════════════════════════════════════════════════

class _SuggestionChip extends StatefulWidget {
  final String text;
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.text,
    required this.isArabic,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<_SuggestionChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hover
                ? const Color(0xFFD4AF37).withValues(alpha: 0.14)
                : (widget.isDarkMode
                    ? const Color(0xFF144D32).withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.65)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFD4AF37)
                  .withValues(alpha: _hover ? 0.65 : 0.28),
              width: _hover ? 1.6 : 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
                ),
                child: const Icon(Icons.flag_rounded,
                    color: Color(0xFFD4AF37), size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.text,
                  textAlign:
                      widget.isArabic ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: widget.isDarkMode
                        ? Colors.grey[200]
                        : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                widget.isArabic
                    ? Icons.arrow_back_rounded
                    : Icons.arrow_forward_rounded,
                color: const Color(0xFFD4AF37).withValues(alpha: 0.7),
                size: 16,
              ),
            ],
          ),
        ),
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
// GOAL GLASS CARD
// ═══════════════════════════════════════════════════════════════

class _GoalGlassCard extends StatefulWidget {
  final IslamicGoal goal;
  final AppLocalizations l10n;
  final bool isArabic;
  final bool isFrench;
  final bool isDarkMode;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final ThemeService themeService;

  const _GoalGlassCard({
    required this.goal,
    required this.l10n,
    required this.isArabic,
    required this.isFrench,
    required this.isDarkMode,
    required this.onUpdate,
    required this.onDelete,
    required this.themeService,
  });

  @override
  State<_GoalGlassCard> createState() => _GoalGlassCardState();
}

class _GoalGlassCardState extends State<_GoalGlassCard> {
  bool _isHovered = false;

  IconData _getGoalIcon(String type) {
    switch (type) {
      case 'quran':
        return Icons.menu_book_rounded;
      case 'surah':
        return Icons.auto_stories_rounded;
      case 'prayer_streak':
        return Icons.repeat_rounded;
      default:
        return Icons.track_changes_rounded;
    }
  }

  Color _getGoalAccent(String type) {
    switch (type) {
      case 'quran':
        return const Color(0xFFD4AF37);
      case 'surah':
        return const Color(0xFF2196F3);
      case 'prayer_streak':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'quran':
        return widget.l10n.goalTypeQuran;
      case 'surah':
        return widget.l10n.goalTypeSurah;
      case 'prayer_streak':
        return widget.l10n.goalTypePrayer;
      default:
        return widget.l10n.islamicGoalsTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final accent = _getGoalAccent(goal.type);
    final progress = goal.progressPercentage / 100;

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
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: goal.isCompleted
                      ? (widget.isDarkMode
                          ? [
                              const Color(0xFF4CAF50)
                                  .withValues(alpha: 0.15),
                              const Color(0xFF0B3D2E)
                                  .withValues(alpha: 0.5),
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.9),
                              const Color(0xFF4CAF50)
                                  .withValues(alpha: 0.06),
                            ])
                      : (widget.isDarkMode
                          ? [
                              accent.withValues(alpha: 0.18),
                              const Color(0xFF0B3D2E)
                                  .withValues(alpha: 0.6),
                            ]
                          : [
                              Colors.white,
                              accent.withValues(alpha: 0.05),
                            ]),
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: goal.isCompleted
                      ? const Color(0xFF4CAF50)
                          .withValues(alpha: 0.4)
                      : (_isHovered
                          ? accent
                          : accent.withValues(alpha: 0.35)),
                  width: _isHovered ? 1.8 : 1.2,
                ),
                boxShadow: !widget.isDarkMode
                    ? [
                        BoxShadow(
                          color: (goal.isCompleted
                                  ? const Color(0xFF4CAF50)
                                  : accent)
                              .withValues(
                                  alpha: _isHovered ? 0.18 : 0.07),
                          blurRadius: _isHovered ? 16 : 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
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
                              accent.withValues(alpha: 0.85),
                              accent.withValues(alpha: 0.5),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.35),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(_getGoalIcon(goal.type),
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: widget.themeService.getTextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: goal.isCompleted
                                    ? (widget.isDarkMode
                                        ? Colors.white54
                                        : Colors.black38)
                                    : (widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black87),
                                decoration: goal.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: widget.isDarkMode
                                    ? Colors.white54
                                    : Colors.black38,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: accent.withValues(alpha: 0.14),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          accent.withValues(alpha: 0.35),
                                    ),
                                  ),
                                  child: Text(
                                    _getTypeLabel(goal.type),
                                    style:
                                        widget.themeService.getTextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: accent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    goal.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        widget.themeService.getTextStyle(
                                      fontSize: 11.5,
                                      color: widget.isDarkMode
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
                      if (goal.isCompleted)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF4CAF50)
                                .withValues(alpha: 0.15),
                            border: Border.all(
                              color: const Color(0xFF4CAF50)
                                  .withValues(alpha: 0.5),
                              width: 1.4,
                            ),
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Color(0xFF4CAF50), size: 18),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Progress bar with percent pill ──
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 9,
                            backgroundColor: widget.isDarkMode
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.grey.withValues(alpha: 0.18),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              goal.isCompleted
                                  ? const Color(0xFF4CAF50)
                                  : accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${goal.progressPercentage.toStringAsFixed(0)}%',
                        style: widget.themeService.getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: goal.isCompleted
                              ? const Color(0xFF4CAF50)
                              : accent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${goal.currentProgress} / ${goal.targetValue}',
                        style: widget.themeService.getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: widget.isDarkMode
                              ? Colors.white.withValues(alpha: 0.65)
                              : Colors.black54,
                        ),
                      ),
                      Text(
                        goal.isCompleted
                            ? (widget.isArabic
                                ? 'مكتمل'
                                : (widget.isFrench
                                    ? 'Terminé'
                                    : 'Completed'))
                            : (widget.isArabic
                                ? 'قيد التقدم'
                                : (widget.isFrench
                                    ? 'En cours'
                                    : 'In progress')),
                        style: widget.themeService.getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: goal.isCompleted
                              ? const Color(0xFF4CAF50)
                              : accent.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),

                  if (!goal.isCompleted) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              widget.onUpdate();
                            },
                            icon: const Icon(Icons.add_task_rounded,
                                size: 18),
                            label: Text(
                              widget.l10n.updateProgressBtn,
                              style: widget.themeService.getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _DeedActionButton(
                          icon: Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          onTap: widget.onDelete,
                          tooltip: widget.isArabic ? 'حذف' : 'Delete',
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _DeedActionButton(
                          icon: Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          onTap: widget.onDelete,
                          tooltip: widget.isArabic ? 'حذف' : 'Delete',
                        ),
                      ],
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

// ═══════════════════════════════════════════════════════════════
// ACTION BUTTON
// ═══════════════════════════════════════════════════════════════

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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hover
                ? widget.color.withValues(alpha: 0.18)
                : widget.color.withValues(alpha: 0.1),
            border: Border.all(
              color:
                  widget.color.withValues(alpha: _hover ? 0.6 : 0.3),
            ),
          ),
          child: Icon(widget.icon, color: widget.color, size: 18),
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
// ADD GOAL DIALOG — REDESIGNED
// ═══════════════════════════════════════════════════════════════

class _AddGoalDialog extends StatefulWidget {
  final AppLocalizations l10n;
  final ThemeService themeService;
  final VoidCallback onGoalCreated;
  final String Function(String, AppLocalizations) getGoalDescription;

  const _AddGoalDialog({
    required this.l10n,
    required this.themeService,
    required this.onGoalCreated,
    required this.getGoalDescription,
  });

  @override
  State<_AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<_AddGoalDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _targetController;
  String _selectedType = 'quran';
  bool _isSubmitting = false;

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _deepGreen = Color(0xFF1B5E3F);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _targetController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'quran':
        return Icons.menu_book_rounded;
      case 'surah':
        return Icons.auto_stories_rounded;
      case 'prayer_streak':
        return Icons.repeat_rounded;
      default:
        return Icons.track_changes_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'quran':
        return _gold;
      case 'surah':
        return const Color(0xFF2196F3);
      case 'prayer_streak':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  List<String> _presetsForType(String type, bool isArabic, bool isFrench) {
    switch (type) {
      case 'quran':
        return isArabic
            ? ['ختم القرآن في شهر', 'ختم القرآن في 3 أشهر', 'قراءة جزء يومياً']
            : isFrench
                ? [
                    'Finir le Coran en un mois',
                    'Finir le Coran en 3 mois',
                    'Lire un juz\' par jour'
                  ]
                : [
                    'Finish Quran in a month',
                    'Finish Quran in 3 months',
                    'Read one juz\' daily'
                  ];
      case 'surah':
        return isArabic
            ? ['قراءة الكهف كل جمعة', 'قراءة يس يومياً', 'قراءة الملك قبل النوم']
            : isFrench
                ? [
                    'Lire Al-Kahf chaque vendredi',
                    'Lire Yassin quotidiennement',
                    'Lire Al-Mulk avant de dormir'
                  ]
                : [
                    'Read Al-Kahf every Friday',
                    'Read Yassin daily',
                    'Read Al-Mulk before sleep'
                  ];
      case 'prayer_streak':
        return isArabic
            ? ['الصلاة في وقتها 30 يوم', 'السنن الرواتب أسبوعياً', 'صلاة الفجر جماعة']
            : isFrench
                ? [
                    'Prières à l\'heure 30 jours',
                    'Sunan rawatib chaque semaine',
                    'Fajr en congrégation'
                  ]
                : [
                    'On-time prayers for 30 days',
                    'Sunan rawatib weekly',
                    'Fajr in congregation'
                  ];
      default:
        return [];
    }
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final target = int.tryParse(_targetController.text.trim()) ?? 0;
    if (title.isEmpty || target <= 0 || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    try {
      final goal = IslamicGoal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedType,
        title: title,
        description: widget.getGoalDescription(_selectedType, widget.l10n),
        targetValue: target,
        currentProgress: 0,
        createdAt: DateTime.now(),
      );
      await GoalsService.saveGoal(goal);
      if (!mounted) return;
      Navigator.pop(context);
      widget.onGoalCreated();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final accent = _colorForType(_selectedType);

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
              color: isDark
                  ? const Color(0xFF0B3D2E).withValues(alpha: 0.96)
                  : const Color(0xFFF8FAF9).withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: _gold.withValues(alpha: 0.45), width: 1.5),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
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
                        child: const Icon(Icons.flag_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.l10n.addGoalTitle,
                              style: widget.themeService.getTextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : _deepGreen,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isArabic
                                  ? 'حدّد هدفك وتابع تقدمك نحو إتمامه'
                                  : (isFrench
                                      ? 'Définissez votre objectif et suivez votre progression'
                                      : 'Set your goal and track your progress'),
                              style: widget.themeService.getTextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.65)
                                    : Colors.black.withValues(alpha: 0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Type picker ──
                  _label('Type', isDark),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _typeChip('quran', widget.l10n.goalTypeQuran,
                          Icons.menu_book_rounded, isDark, isArabic),
                      _typeChip('surah', widget.l10n.goalTypeSurah,
                          Icons.auto_stories_rounded, isDark, isArabic),
                      _typeChip('prayer_streak',
                          widget.l10n.goalTypePrayer,
                          Icons.repeat_rounded, isDark, isArabic),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Title field ──
                  _label(widget.l10n.goalTitleLabel, isDark),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    style: widget.themeService.getTextStyle(
                      fontSize: 15.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: _inputDecoration(
                      hint: widget.l10n.goalTitleHint,
                      icon: Icons.edit_rounded,
                      isDark: isDark,
                      accent: _gold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Target field ──
                  _label(
                    _selectedType == 'surah'
                        ? widget.l10n.surahNumberLabel
                        : widget.l10n.numberOfDaysLabel,
                    isDark,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _targetController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    style: widget.themeService.getTextStyle(
                      fontSize: 15.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: _inputDecoration(
                      hint: _selectedType == 'surah'
                          ? '1-114'
                          : '1-365',
                      icon: Icons.numbers_rounded,
                      isDark: isDark,
                      accent: _gold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Presets ──
                  _label('Quick presets', isDark),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children:
                        _presetsForType(_selectedType, isArabic, isFrench)
                            .map(
                      (p) => GestureDetector(
                        onTap: () {
                          setState(() => _titleController.text = p);
                          HapticFeedback.selectionClick();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: accent
                                .withValues(alpha: isDark ? 0.12 : 0.09),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: accent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            p,
                            style: widget.themeService.getTextStyle(
                              fontSize: 12,
                              color:
                                  isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    )
                            .toList(),
                  ),
                  const SizedBox(height: 24),

                  // ── Actions ──
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                isDark ? Colors.white70 : Colors.black54,
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.black.withValues(alpha: 0.15),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
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
                          onPressed: _isSubmitting ? null : _submit,
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
                            widget.l10n.createGoalBtn,
                            style: widget.themeService.getTextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _deepGreen,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text, bool isDark) {
    return Text(
      text.toUpperCase(),
      style: widget.themeService.getTextStyle(
        fontSize: 11,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w700,
        color: _gold.withValues(alpha: 0.9),
      ),
    );
  }

  Widget _typeChip(
    String type,
    String label,
    IconData icon,
    bool isDark,
    bool isArabic,
  ) {
    final isSelected = _selectedType == type;
    final color = _colorForType(type);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedType = type);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              : (isDark
                  ? Colors.black.withValues(alpha: 0.25)
                  : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark
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
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: widget.themeService.getTextStyle(
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : color)
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool isDark,
    required Color accent,
  }) {
    OutlineInputBorder border(Color c, [double w = 1.2]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: widget.themeService.getTextStyle(
        fontSize: 13.5,
        color: isDark
            ? Colors.white.withValues(alpha: 0.35)
            : Colors.grey.shade400,
      ),
      prefixIcon: Icon(icon, color: accent, size: 20),
      filled: true,
      fillColor: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.white,
      border: border(accent.withValues(alpha: 0.3)),
      enabledBorder: border(accent.withValues(alpha: 0.3)),
      focusedBorder: border(accent, 2),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// UPDATE PROGRESS DIALOG — REDESIGNED
// ═══════════════════════════════════════════════════════════════

class _UpdateProgressDialog extends StatefulWidget {
  final IslamicGoal goal;
  final AppLocalizations l10n;
  final ThemeService themeService;
  final VoidCallback onUpdated;

  const _UpdateProgressDialog({
    required this.goal,
    required this.l10n,
    required this.themeService,
    required this.onUpdated,
  });

  @override
  State<_UpdateProgressDialog> createState() => _UpdateProgressDialogState();
}

class _UpdateProgressDialogState extends State<_UpdateProgressDialog> {
  late final TextEditingController _controller;
  late int _currentValue;

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _deepGreen = Color(0xFF1B5E3F);

  @override
  void initState() {
    super.initState();
    _currentValue = widget.goal.currentProgress;
    _controller =
        TextEditingController(text: _currentValue.toString());
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    final v = int.tryParse(_controller.text) ?? 0;
    if (v != _currentValue) setState(() => _currentValue = v);
  }

  Future<void> _save() async {
    final raw = int.tryParse(_controller.text) ??
        widget.goal.currentProgress;
    final clamped = raw.clamp(0, widget.goal.targetValue);
    HapticFeedback.mediumImpact();
    await GoalsService.updateProgress(widget.goal.id, clamped);
    if (!mounted) return;
    Navigator.pop(context);
    widget.onUpdated();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goal = widget.goal;
    final progressValue = goal.targetValue == 0
        ? 0.0
        : (_currentValue / goal.targetValue).clamp(0.0, 1.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0B3D2E).withValues(alpha: 0.96)
                  : const Color(0xFFF8FAF9).withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: _gold.withValues(alpha: 0.45), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [_gold, Color(0xFFE6C200)],
                        ),
                      ),
                      child: const Icon(Icons.add_task_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.l10n.updateDialogTitle,
                        style: widget.themeService.getTextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : _deepGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  goal.title,
                  style: widget.themeService.getTextStyle(
                    fontSize: 13.5,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Live preview ──
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _gold.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$_currentValue / ${goal.targetValue}',
                            style: widget.themeService.getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _gold,
                            ),
                          ),
                          Text(
                            '${(progressValue * 100).toStringAsFixed(0)}%',
                            style: widget.themeService.getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _gold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 8,
                          backgroundColor: _gold.withValues(alpha: 0.15),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(_gold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(),
                  autofocus: true,
                  style: widget.themeService.getTextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    labelText:
                        '${widget.l10n.progressLabel} (${goal.targetValue} max)',
                    labelStyle: widget.themeService.getTextStyle(
                      fontSize: 13.5,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                    prefixIcon: const Icon(Icons.numbers_rounded,
                        color: _gold, size: 20),
                    filled: true,
                    fillColor: isDark
                        ? Colors.black.withValues(alpha: 0.25)
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: _gold.withValues(alpha: 0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: _gold.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: _gold, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              isDark ? Colors.white70 : Colors.black54,
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.15),
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
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
                        onPressed: _save,
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: Text(
                          widget.l10n.updateBtn,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}