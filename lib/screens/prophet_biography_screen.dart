import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../data/prophet_biography_data.dart';

const Color _kGold = Color(0xFFD4AF37);
const Color _kGoldDeep = Color(0xFFB5952F);
const Color _kGoldSoft = Color(0xFFE8CD7A);

enum _ProphetFilter { all, major, mostMentioned }

class ProphetBiographyScreen extends StatefulWidget {
  const ProphetBiographyScreen({super.key});

  @override
  State<ProphetBiographyScreen> createState() => _ProphetBiographyScreenState();
}

class _ProphetBiographyScreenState extends State<ProphetBiographyScreen> {
  late ProphetBiographyService service;
  late List<ProphetBiography> allProphets;
  late List<ProphetBiography> filteredProphets;
  final TextEditingController searchController = TextEditingController();
  _ProphetFilter _filter = _ProphetFilter.all;

  @override
  void initState() {
    super.initState();
    service = ProphetBiographyService();
    allProphets = [];
    filteredProphets = [];
    searchController.addListener(_applyFilters);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final langCode = Localizations.localeOf(context).languageCode;
    allProphets = service.getAllProphets(langCode);
    _applyFilters();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final langCode = Localizations.localeOf(context).languageCode;
    setState(() {
      List<ProphetBiography> base = searchController.text.isEmpty
          ? allProphets
          : service.searchProphets(searchController.text, langCode);

      switch (_filter) {
        case _ProphetFilter.all:
          filteredProphets = base;
          break;
        case _ProphetFilter.major:
          filteredProphets = base.where((p) => p.isMajor).toList();
          break;
        case _ProphetFilter.mostMentioned:
          filteredProphets = base.where((p) => p.mentionedInSurahs >= 10).toList();
          break;
      }
    });
  }

  void _openDetail(ProphetBiography prophet) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 520),
        reverseTransitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProphetDetailScreen(prophet: prophet),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0.02),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  // ---- Header ----
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        _CircleIconButton(
                          icon: isArabic ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            _t(isArabic, ar: 'سيرة الأنبياء', en: 'Prophet Biographies', fr: 'Biographies des Prophètes'),
                            textAlign: TextAlign.center,
                            style: themeService.getTextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _kGold,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // ---- Hero header ----
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 6, 24, 18),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_kGold.withValues(alpha: 0.7), _kGold.withValues(alpha: 0.05)],
                            ),
                          ),
                          child: Container(
                            width: 92,
                            height: 92,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: const Icon(Icons.menu_book_rounded, color: _kGold, size: 46),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _t(isArabic, ar: 'قصص وسير أنبياء الله', en: 'Stories & Lives of Allah\'s Prophets', fr: 'Histoires et vies des Prophètes'),
                          textAlign: TextAlign.center,
                          style: themeService.getTextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.getOnBackgroundColor(context),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _t(isArabic, ar: 'تأمل في حياتهم واستخلص الدروس والعبر', en: 'Reflect on their lives and draw timeless lessons', fr: 'Méditez sur leurs vies et tirez des leçons intemporelles'),
                          textAlign: TextAlign.center,
                          style: themeService.getTextStyle(
                            fontSize: 13,
                            color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---- Search ----
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: searchController,
                      style: themeService.getTextStyle(
                        fontSize: 15,
                        color: AppTheme.getOnBackgroundColor(context),
                      ),
                      decoration: InputDecoration(
                        hintText: _t(isArabic, ar: 'ابحث عن نبي...', en: 'Search for a prophet...', fr: 'Rechercher un prophète...'),
                        hintStyle: themeService.getTextStyle(
                          fontSize: 14,
                          color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.5),
                        ),
                        prefixIcon: Icon(Icons.search_rounded, color: _kGold.withValues(alpha: 0.7)),
                        suffixIcon: searchController.text.isEmpty ? null : IconButton(
                          icon: Icon(Icons.close_rounded, color: _kGold.withValues(alpha: 0.7)),
                          onPressed: () => searchController.clear(),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.25),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: _kGold.withValues(alpha: 0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: _kGold.withValues(alpha: 0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: _kGold, width: 2),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ---- Filter chips ----
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildFilterChip(
                          label: _t(isArabic, ar: 'الكل', en: 'All', fr: 'Tous'),
                          isSelected: _filter == _ProphetFilter.all,
                          onTap: () { setState(() => _filter = _ProphetFilter.all); _applyFilters(); },
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: _t(isArabic, ar: 'كبار الأنبياء', en: 'Major Prophets', fr: 'Grands Prophètes'),
                          isSelected: _filter == _ProphetFilter.major,
                          onTap: () { setState(() => _filter = _ProphetFilter.major); _applyFilters(); },
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: _t(isArabic, ar: 'الأكثر ذكراً', en: 'Most Mentioned', fr: 'Les Plus Cité'),
                          isSelected: _filter == _ProphetFilter.mostMentioned,
                          onTap: () { setState(() => _filter = _ProphetFilter.mostMentioned); _applyFilters(); },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ---- Result count ----
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        _t(isArabic, ar: '${filteredProphets.length} نبي', en: '${filteredProphets.length} prophets', fr: '${filteredProphets.length} prophètes'),
                        style: themeService.getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.55),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ---- List ----
                  Expanded(
                    child: filteredProphets.isEmpty
                        ? _buildEmptyState(context, themeService)
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
                            itemCount: filteredProphets.length,
                            itemBuilder: (context, index) {
                              final p = filteredProphets[index];
                              return _StaggeredEntrance(
                                index: index,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _ProphetCard(
                                    prophet: p,
                                    onTap: () => _openDetail(p),
                                    themeService: themeService,
                                  ),
                                ),
                              );
                            },
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

  Widget _buildFilterChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? _kGold.withValues(alpha: 0.2) : Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? _kGold.withValues(alpha: 0.75) : _kGold.withValues(alpha: 0.2),
                width: isSelected ? 1.6 : 1,
              ),
            ),
            child: Text(
              label,
              style: themeService.getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? _kGold : AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.75),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeService themeService) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 72, color: _kGold.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              _t(isArabic, ar: 'لا توجد نتائج', en: 'No results found', fr: 'Aucun résultat'),
              style: themeService.getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _t(isArabic, ar: 'جرّب تعديل البحث أو اختيار فلتر مختلف', en: 'Try adjusting your search or selecting a different filter', fr: 'Essayez d\'ajuster votre recherche ou un autre filtre'),
              textAlign: TextAlign.center,
              style: themeService.getTextStyle(
                fontSize: 13,
                color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.5),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _t(bool isArabic, {required String ar, required String en, required String fr}) {
    if (isArabic) return ar;
    if (Localizations.localeOf(context).languageCode == 'fr') return fr;
    return en;
  }
}

// ===========================================================================
// PROPHET DETAIL SCREEN
// ===========================================================================
class ProphetDetailScreen extends StatefulWidget {
  final ProphetBiography prophet;
  const ProphetDetailScreen({super.key, required this.prophet});

  @override
  State<ProphetDetailScreen> createState() => _ProphetDetailScreenState();
}

class _ProphetDetailScreenState extends State<ProphetDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  List<ProphetBiography> relatedProphets = <ProphetBiography>[];
  bool _bioExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final langCode = Localizations.localeOf(context).languageCode;
    final service = ProphetBiographyService();
    final related = service.getRelatedProphets(widget.prophet, langCode);
    if (!_listEqualsById(related, relatedProphets)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          relatedProphets = related;
        });
      });
    }
  }

  bool _listEqualsById(List<ProphetBiography> a, List<ProphetBiography> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';
        final p = widget.prophet;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: IslamicPatternBackground(
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ---- Hero header ----
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    surfaceTintColor: Colors.transparent,
                    leading: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                          border: Border.all(color: _kGold.withValues(alpha: 0.25)),
                        ),
                        child: IconButton(
                          icon: Icon(isArabic ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded, color: _kGold),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                      title: Text(
                        p.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _kGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          shadows: [Shadow(offset: Offset(0, 2), blurRadius: 6, color: Colors.black54)],
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [_kGold.withValues(alpha: 0.18), _kGold.withValues(alpha: 0.04), Theme.of(context).scaffoldBackgroundColor],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                        child: Center(
                          child: Hero(
                            tag: 'prophet_${p.id}',
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(colors: [_kGold.withValues(alpha: 0.22), _kGold.withValues(alpha: 0.03)]),
                                border: Border.all(color: _kGold.withValues(alpha: 0.45), width: 2),
                                boxShadow: [BoxShadow(color: _kGold.withValues(alpha: 0.28), blurRadius: 40, spreadRadius: 2)],
                              ),
                              child: Center(
                                child: Container(
                                  width: 144,
                                  height: 144,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: _kGold.withValues(alpha: 0.3), width: 1.2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      p.initials,
                                      style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: _kGold, height: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ---- Content ----
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 26, 20, 48),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _animated(0, _buildNameHeader(context, themeService)),
                        _animated(1, const SizedBox(height: 20)),
                        _animated(2, _buildInfoGrid(context, themeService)),
                        _animated(3, const SizedBox(height: 28)),
                        _animated(4, _buildBiography(context, themeService)),
                        _animated(5, const SizedBox(height: 28)),
                        if (p.timeline.isNotEmpty) _animated(6, _buildTimeline(context, themeService)),
                        if (p.timeline.isNotEmpty) _animated(7, const SizedBox(height: 28)),
                        if (p.miracles.isNotEmpty) _animated(8, _buildBullets(context: context, themeService: themeService, title: _t(isArabic, ar: 'المعجزات', en: 'Miracles', fr: 'Miracles'), icon: Icons.auto_awesome_rounded, items: p.miracles)),
                        if (p.miracles.isNotEmpty) _animated(9, const SizedBox(height: 28)),
                        if (p.keyAchievements.isNotEmpty) _animated(10, _buildBullets(context: context, themeService: themeService, title: _t(isArabic, ar: 'الإنجازات الرئيسية', en: 'Key Achievements', fr: 'Réalisations Clés'), icon: Icons.emoji_events_rounded, items: p.keyAchievements)),
                        if (p.keyAchievements.isNotEmpty) _animated(11, const SizedBox(height: 28)),
                        if (p.lessons.isNotEmpty) _animated(12, _buildBullets(context: context, themeService: themeService, title: _t(isArabic, ar: 'دروس وعبر', en: 'Lessons & Wisdom', fr: 'Leçons & Sagesse'), icon: Icons.lightbulb_outline_rounded, items: p.lessons)),
                        if (p.lessons.isNotEmpty) _animated(13, const SizedBox(height: 28)),
                        if (p.quranicMentions.isNotEmpty) _animated(14, _buildQuranicMentions(context, themeService)),
                        if (p.quranicMentions.isNotEmpty) _animated(15, const SizedBox(height: 28)),
                        if (relatedProphets.isNotEmpty) _animated(16, _buildRelated(context, themeService, isArabic)),
                        const SizedBox(height: 24),
                      ]),
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

  Widget _animated(int index, Widget child) {
    final start = (index * 0.05).clamp(0.0, 0.55);
    final end = (start + 0.45).clamp(0.0, 1.0);
    final animation = CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeOutCubic));
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(offset: Offset(0, 24 * (1 - animation.value)), child: child),
        );
      },
    );
  }

  Widget _buildNameHeader(BuildContext context, ThemeService themeService) {
  final p = widget.prophet;
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  return Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_kGold.withValues(alpha: 0.14), _kGold.withValues(alpha: 0.02)],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: _kGold.withValues(alpha: 0.35), width: 1.4),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1) Arabic name — its own line
        Text(
          p.arabicName.isNotEmpty ? p.arabicName : p.name,
          style: themeService.getTextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: _kGold,
            height: 1.1,
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 8),

        // 2) English name — under the Arabic
        Text(
          p.name,
          style: themeService.getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.85),
          ),
        ),

        // 3) Title chip — now BELOW the name, aligned start
        if (p.title.isNotEmpty) ...[
          const SizedBox(height: 14),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _kGold.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kGold.withValues(alpha: 0.45), width: 1),
              ),
              child: Text(
                p.title,
                style: themeService.getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _kGold,
                  letterSpacing: 0.3,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],

        // 4) Speciality
        if (p.speciality.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            p.speciality,
            style: themeService.getTextStyle(
              fontSize: 13.5,
              fontStyle: FontStyle.italic,
              height: 1.55,
              color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.72),
            ),
          ),
        ],

        // 5) Quranic name
        if (p.quranicName.isNotEmpty) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.book_rounded, size: 14, color: _kGold.withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isArabic
                      ? 'الاسم في القرآن: ${p.quranicName}'
                      : 'In the Quran: ${p.quranicName}',
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _kGold.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

  // 🔥 FIXED: GridView using mainAxisExtent to prevent HUGE boxes on wide screens
  Widget _buildInfoGrid(BuildContext context, ThemeService themeService) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final p = widget.prophet;

  final items = <Map<String, dynamic>>[
    {'label': _t(isArabic, ar: 'الفترة الزمنية', en: 'Lifespan', fr: 'Durée de vie'), 'value': p.lifespan, 'icon': Icons.hourglass_bottom_rounded},
    {'label': _t(isArabic, ar: 'مكان المولد', en: 'Birth Place', fr: 'Lieu de naissance'), 'value': p.birthPlace, 'icon': Icons.place_rounded},
    {'label': _t(isArabic, ar: 'مكان الوفاة', en: 'Death Place', fr: 'Lieu de décès'), 'value': p.deathPlace, 'icon': Icons.location_on_rounded},
    {'label': _t(isArabic, ar: 'الذكر في القرآن', en: 'Mentioned in', fr: 'Mentionné dans'), 'value': isArabic ? '${p.mentionedInSurahs} سورة' : '${p.mentionedInSurahs} Surahs', 'icon': Icons.book_rounded},
  ];

  if (p.tribe.isNotEmpty) {
    items.add({'label': _t(isArabic, ar: 'القوم', en: 'People', fr: 'Peuple'), 'value': p.tribe, 'icon': Icons.groups_rounded});
  }

  // Build 2-column rows manually — this guarantees a fixed, content-sized height.
  final rows = <Widget>[];
  for (int i = 0; i < items.length; i += 2) {
    final left = items[i];
    final right = (i + 1 < items.length) ? items[i + 1] : null;

    rows.add(
      Padding(
        padding: EdgeInsets.only(bottom: i + 2 < items.length ? 12 : 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InfoTile(
                title: left['label'] as String,
                value: left['value'] as String,
                icon: left['icon'] as IconData,
                themeService: themeService,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: right != null
                  ? _InfoTile(
                      title: right['label'] as String,
                      value: right['value'] as String,
                      icon: right['icon'] as IconData,
                      themeService: themeService,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  return Column(children: rows);
}

  Widget _buildBiography(BuildContext context, ThemeService themeService) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final p = widget.prophet;
    final longText = p.fullDescription.isNotEmpty ? p.fullDescription : p.description;
    final needsExpansion = longText.length > 260;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, themeService, _t(isArabic, ar: 'السيرة الكاملة', en: 'Full Biography', fr: 'Biographie Complète')),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kGold.withValues(alpha: 0.18), width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 14, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                child: Text(
                  needsExpansion && !_bioExpanded ? '${longText.substring(0, 240).trimRight()}…' : longText,
                  style: themeService.getTextStyle(fontSize: 14.5, height: 1.85, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.88)),
                ),
              ),
              if (needsExpansion) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _bioExpanded = !_bioExpanded),
                    icon: Icon(_bioExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: _kGold, size: 18),
                    label: Text(
                      _bioExpanded ? _t(isArabic, ar: 'عرض أقل', en: 'Show less', fr: 'Voir moins') : _t(isArabic, ar: 'اقرأ المزيد', en: 'Read more', fr: 'Lire la suite'),
                      style: themeService.getTextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _kGold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context, ThemeService themeService) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final events = widget.prophet.timeline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, themeService, _t(isArabic, ar: 'محطات حياته', en: 'Life Timeline', fr: 'Chronologie de sa vie')),
        const SizedBox(height: 16),
        ...List.generate(events.length, (i) {
          final e = events[i];
          final isLast = i == events.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _kGold.withValues(alpha: 0.18),
                        border: Border.all(color: _kGold.withValues(alpha: 0.7), width: 1.6),
                      ),
                      child: Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: _kGold))),
                    ),
                    if (!isLast) Expanded(child: Container(width: 2, color: _kGold.withValues(alpha: 0.3))),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _kGold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _kGold.withValues(alpha: 0.3), width: 0.8),
                          ),
                          child: Text(e.year, style: themeService.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _kGold, letterSpacing: 0.3)),
                        ),
                        const SizedBox(height: 8),
                        Text(e.event, style: themeService.getTextStyle(fontSize: 14, height: 1.6, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.85))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBullets({required BuildContext context, required ThemeService themeService, required String title, required IconData icon, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, themeService, title),
        const SizedBox(height: 14),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _kGold.withValues(alpha: 0.15), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: _kGold.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _kGold.withValues(alpha: 0.3), width: 0.8),
                    ),
                    child: Icon(icon, color: _kGold, size: 15),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item, style: themeService.getTextStyle(fontSize: 14, height: 1.65, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.87)))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuranicMentions(BuildContext context, ThemeService themeService) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final mentions = widget.prophet.quranicMentions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, themeService, _t(isArabic, ar: 'الآيات القرآنية', en: 'Quranic Mentions', fr: 'Mentions Coraniques')),
        const SizedBox(height: 14),
        ...mentions.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_kGold.withValues(alpha: 0.1), _kGold.withValues(alpha: 0.02)]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _kGold.withValues(alpha: 0.32), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, color: _kGold.withValues(alpha: 0.85), size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text('${m.surahName} (${m.surahNumber}:${m.verseNumber})', style: themeService.getTextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _kGold, letterSpacing: 0.3))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _kGold.withValues(alpha: 0.2), width: 1),
                    ),
                    child: Text(
                      m.verseText,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: themeService.getTextStyle(fontSize: 18, height: 2.0, fontWeight: FontWeight.w600, color: _kGold.withValues(alpha: 0.95)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2, right: 8),
                        child: Icon(Icons.format_quote_rounded, color: _kGold.withValues(alpha: 0.5), size: 16),
                      ),
                      Expanded(child: Text(m.verseTranslation, style: themeService.getTextStyle(fontSize: 13, height: 1.7, fontStyle: FontStyle.italic, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.75)))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelated(BuildContext context, ThemeService themeService, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, themeService, _t(isArabic, ar: 'أنبياء ذوو صلة', en: 'Related Prophets', fr: 'Prophètes Associés')),
        const SizedBox(height: 14),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: relatedProphets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final rp = relatedProphets[i];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 450),
                      pageBuilder: (_, __, ___) => ProphetDetailScreen(prophet: rp),
                      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _kGold.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [_kGold.withValues(alpha: 0.25), _kGold.withValues(alpha: 0.08)]),
                          border: Border.all(color: _kGold.withValues(alpha: 0.5), width: 1),
                        ),
                        child: Center(child: Text(rp.initials, style: themeService.getTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _kGold))),
                      ),
                      const SizedBox(height: 10),
                      Text(rp.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: themeService.getTextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _kGold, height: 1.3)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, ThemeService themeService, String title) {
    return Row(
      children: [
        Container(
          width: 4, height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_kGold, _kGoldSoft]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: themeService.getTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _kGold, letterSpacing: 0.3))),
      ],
    );
  }

  String _t(bool isArabic, {required String ar, required String en, required String fr}) {
    if (isArabic) return ar;
    if (Localizations.localeOf(context).languageCode == 'fr') return fr;
    return en;
  }
}

// ===========================================================================
// REUSABLE WIDGETS
// ===========================================================================

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
        border: Border.all(color: _kGold.withValues(alpha: 0.25), width: 1),
      ),
      child: IconButton(padding: EdgeInsets.zero, icon: Icon(icon, color: _kGold, size: 22), onPressed: onTap),
    );
  }
}

class _ProphetCard extends StatefulWidget {
  final ProphetBiography prophet;
  final VoidCallback onTap;
  final ThemeService themeService;
  const _ProphetCard({required this.prophet, required this.onTap, required this.themeService});

  @override
  State<_ProphetCard> createState() => _ProphetCardState();
}

class _ProphetCardState extends State<_ProphetCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final p = widget.prophet;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 160),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Theme.of(context).cardColor, Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.4)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kGold.withValues(alpha: _hovered ? 0.75 : 0.28), width: _hovered ? 1.8 : 1.2),
              boxShadow: [BoxShadow(color: _kGold.withValues(alpha: _hovered ? 0.18 : 0.06), blurRadius: _hovered ? 20 : 12, offset: const Offset(0, 6))],
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'prophet_${p.id}',
                  child: Container(
                    width: 62, height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_kGold.withValues(alpha: 0.3), _kGold.withValues(alpha: 0.08)]),
                      border: Border.all(color: _kGold.withValues(alpha: 0.6), width: 1.4),
                    ),
                    child: Center(child: Text(p.initials, style: widget.themeService.getTextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _kGold, height: 1.0))),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(p.name, style: widget.themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _kGold, height: 1.2))),
                          if (p.isMajor)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(color: _kGold.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(8)),
                              child: Text(isArabic ? 'كبير' : 'Major', style: widget.themeService.getTextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _kGold, letterSpacing: 0.5)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (p.title.isNotEmpty)
                        Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: widget.themeService.getTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.75))),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.hourglass_bottom_rounded, size: 11, color: _kGold.withValues(alpha: 0.65)),
                          const SizedBox(width: 4),
                          Expanded(child: Text(p.lifespan, maxLines: 1, overflow: TextOverflow.ellipsis, style: widget.themeService.getTextStyle(fontSize: 11, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.55)))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded, color: _kGold.withValues(alpha: 0.7), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final ThemeService themeService;
  const _InfoTile({required this.title, required this.value, required this.icon, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kGold.withValues(alpha: 0.25), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: _kGold.withValues(alpha: 0.85), size: 14),
              const SizedBox(width: 6),
              Expanded(child: Text(title, style: themeService.getTextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _kGold, letterSpacing: 0.3), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: themeService.getTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.85), height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _StaggeredEntrance extends StatefulWidget {
  final int index;
  final Widget child;
  const _StaggeredEntrance({required this.index, required this.child});

  @override
  State<_StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<_StaggeredEntrance> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    final delay = Duration(milliseconds: 60 * (widget.index.clamp(0, 12)));
    Future.delayed(delay, () { if (mounted) _c.forward(); });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child: widget.child));
  }
}