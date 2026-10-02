import 'package:flutter/material.dart';
import '../app_theme.dart';

// ---------------------------------------------------------------------------
// Design tokens
// ---------------------------------------------------------------------------
const Color _kGold = Color(0xFFD4AF37);
const Color _kGoldDeep = Color(0xFFB5952F);
const Color _kGoldSoft = Color(0xFFE8CD7A);

// ===========================================================================
// TEACH ME — CATEGORY LIST SCREEN
// ===========================================================================
class TeachMeScreen extends StatefulWidget {
  final String lang;
  const TeachMeScreen({super.key, required this.lang});

  @override
  State<TeachMeScreen> createState() => _TeachMeScreenState();
}

class _TeachMeScreenState extends State<TeachMeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Data
  // -------------------------------------------------------------------------
  List<Map<String, dynamic>> get _categories => [
        {
          'id': 'wudu',
          'titleEn': 'Wudu (Ablution)',
          'titleAr': 'الوضوء',
          'titleFr': 'Ablution (Wudu)',
          'subEn': 'The complete step-by-step guide to ritual purification',
          'subAr': 'دليل تفصيلي خطوة بخطوة للطهارة',
          'subFr': 'Le guide complet étape par étape de la purification',
          'badgeEn': '7 Steps',
          'badgeAr': '٧ خطوات',
          'badgeFr': '7 Étapes',
          'icon': Icons.water_drop_rounded,
        },
        {
          'id': 'salah',
          'titleEn': 'Salah (Prayer)',
          'titleAr': 'الصلاة',
          'titleFr': 'Prière (Salah)',
          'subEn': 'Pillars, positions, conditions and nullifiers of prayer',
          'subAr': 'الأركان والهيئات والشروط والنواقض',
          'subFr': 'Piliers, positions, conditions et annulatifs',
          'badgeEn': '7 Steps',
          'badgeAr': '٧ خطوات',
          'badgeFr': '7 Étapes',
          'icon': Icons.self_improvement_rounded,
        },
        {
          'id': 'hijab',
          'titleEn': 'Islamic Dress Code',
          'titleAr': 'الملبس الإسلامي',
          'titleFr': 'Code Vestimentaire Islamique',
          'subEn': 'Modesty, conditions of Hijab and attire for both genders',
          'subAr': 'الحجاب وشروط اللباس الشرعي للرجل والمرأة',
          'subFr': 'Pudeur, conditions du Hijab et tenue des deux sexes',
          'badgeEn': '4 Guides',
          'badgeAr': '٤ أدلة',
          'badgeFr': '4 Guides',
          'icon': Icons.checkroom_rounded,
        },
        {
          'id': 'dua',
          'titleEn': 'Essential Daily Duas',
          'titleAr': 'الأدعية اليومية',
          'titleFr': 'Invocations Quotidiennes',
          'subEn': 'Authentic supplications for every moment of your day',
          'subAr': 'أدعية مأثورة لكل لحظة من يومك',
          'subFr': 'Invocations authentiques pour chaque instant de la journée',
          'badgeEn': '8 Duas',
          'badgeAr': '٨ أدعية',
          'badgeFr': '8 Invocations',
          'icon': Icons.favorite_rounded,
        },
        {
          'id': 'etiquette',
          'titleEn': 'Islamic Etiquette & Manners',
          'titleAr': 'الآداب والأخلاق الإسلامية',
          'titleFr': 'Étiquette et Manières Islamiques',
          'subEn': 'Adab of the home, the parents and the community',
          'subAr': 'آداب البيت والوالدين والمجتمع',
          'subFr': 'Adab de la maison, des parents et de la communauté',
          'badgeEn': '6 Manners',
          'badgeAr': '٦ آداب',
          'badgeFr': '6 Manières',
          'icon': Icons.handshake_rounded,
        },
        {
          'id': 'tawheed',
          'titleEn': 'Foundations of Tawheed',
          'titleAr': 'أساسيات وعقيدة التوحيد',
          'titleFr': "Fondements de l'Unicité",
          'subEn': 'The three categories of monotheism and their meanings',
          'subAr': 'أقسام التوحيد الثلاثة ومعانيها',
          'subFr': 'Les trois catégories du monothéisme et leurs sens',
          'badgeEn': '3 Categories',
          'badgeAr': '٣ أقسام',
          'badgeFr': '3 Catégories',
          'icon': Icons.mosque_rounded,
        },
      ];

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isArabic = widget.lang == 'ar';
    final isFrench = widget.lang == 'fr';
    final categories = _categories;

    final headerTitle = isArabic
        ? 'علمني الإسلام'
        : (isFrench ? "Apprends-moi l'Islam" : 'Teach Me Islam');
    final headerSubtitle = isArabic
        ? 'دروس مبسطة وموثوقة لتتعلم أساسيات دينك خطوة بخطوة'
        : (isFrench
            ? 'Des leçons simples et fiables pour apprendre votre religion pas à pas'
            : 'Simple, reliable lessons to learn your religion step by step');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ---------------------------------------------------------------
          // App Bar
          // ---------------------------------------------------------------
          SliverAppBar(
            pinned: true,
            elevation: 0,
            centerTitle: true,
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.92),
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _kGold.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    isArabic
                        ? Icons.arrow_forward_rounded
                        : Icons.arrow_back_rounded,
                    color: _kGold,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            title: Text(
              headerTitle,
              style: const TextStyle(
                color: _kGold,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.4,
              ),
            ),
          ),

          // ---------------------------------------------------------------
          // Hero header
          // ---------------------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _kGold.withValues(alpha: 0.7),
                          _kGold.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: _kGold,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    headerTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: _kGold,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    headerSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getOnBackgroundColor(context)
                              .withValues(alpha: 0.7),
                          height: 1.6,
                          fontSize: 15,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 4,
                    width: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_kGold, _kGoldSoft],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------------------------------------------------------
          // Category cards
          // ---------------------------------------------------------------
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverList.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final title = isArabic
                    ? category['titleAr']
                    : (isFrench ? category['titleFr'] : category['titleEn']);
                final subtitle = isArabic
                    ? category['subAr']
                    : (isFrench ? category['subFr'] : category['subEn']);
                final badge = isArabic
                    ? category['badgeAr']
                    : (isFrench ? category['badgeFr'] : category['badgeEn']);

                return _buildAnimatedTile(
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _buildCategoryCard(
                      context: context,
                      category: category,
                      title: title as String,
                      subtitle: subtitle as String,
                      badge: badge as String,
                      isArabic: isArabic,
                      isFrench: isFrench,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Staggered entrance wrapper
  // -------------------------------------------------------------------------
  Widget _buildAnimatedTile({required int index, required Widget child}) {
    final start = (index * 0.07).clamp(0.0, 0.55);
    final end = (start + 0.45).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 34 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // Category card
  // -------------------------------------------------------------------------
  Widget _buildCategoryCard({
    required BuildContext context,
    required Map<String, dynamic> category,
    required String title,
    required String subtitle,
    required String badge,
    required bool isArabic,
    required bool isFrench,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        splashColor: _kGold.withValues(alpha: 0.08),
        highlightColor: _kGold.withValues(alpha: 0.04),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 520),
              reverseTransitionDuration: const Duration(milliseconds: 380),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TeachMeDetailScreen(
                category: category,
                isArabic: isArabic,
                isFrench: isFrench,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final curved = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                  reverseCurve: Curves.easeInCubic,
                );
                return FadeTransition(
                  opacity: curved,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.06, 0.02),
                      end: Offset.zero,
                    ).animate(curved),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _kGold.withValues(alpha: 0.28),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: _kGold.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // ---- Hero icon ----
              Hero(
                tag: 'icon_${category['id']}',
                flightShuttleBuilder: (_, animation, __, ___, ____) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 1.0).animate(animation),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _kGold.withValues(alpha: 0.35),
                            _kGold.withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: _kGold,
                        size: 48,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _kGold.withValues(alpha: 0.28),
                        _kGold.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: _kGold.withValues(alpha: 0.45),
                      width: 1.6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _kGold.withValues(alpha: 0.14),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: _kGold,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              // ---- Text ----
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: _kGold,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            height: 1.25,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.getOnBackgroundColor(context)
                                .withValues(alpha: 0.65),
                            height: 1.45,
                            fontSize: 13,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _kGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _kGold.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: _kGold,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isArabic
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.arrow_forward_ios_rounded,
                color: _kGold.withValues(alpha: 0.7),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// TEACH ME — DETAIL SCREEN
// ===========================================================================
class TeachMeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> category;
  final bool isArabic;
  final bool isFrench;

  const TeachMeDetailScreen({
    super.key,
    required this.category,
    required this.isArabic,
    required this.isFrench,
  });

  @override
  State<TeachMeDetailScreen> createState() => _TeachMeDetailScreenState();
}

class _TeachMeDetailScreenState extends State<TeachMeDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get isArabic => widget.isArabic;
  bool get isFrench => widget.isFrench;
  Map<String, dynamic> get category => widget.category;

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final title = isArabic
        ? category['titleAr']
        : (isFrench ? category['titleFr'] : category['titleEn']);
    final content = _getTeachingContent(context, category['id'] as String);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ---------------------------------------------------------------
          // Collapsing hero app bar
          // ---------------------------------------------------------------
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            stretch: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withValues(alpha: 0.75),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _kGold.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    isArabic
                        ? Icons.arrow_forward_rounded
                        : Icons.arrow_back_rounded,
                    color: _kGold,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              titlePadding:
                  const EdgeInsets.only(bottom: 18, left: 20, right: 20),
              title: Text(
                title as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _kGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _kGold.withValues(alpha: 0.18),
                      _kGold.withValues(alpha: 0.05),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'icon_${category['id']}',
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _kGold.withValues(alpha: 0.22),
                            _kGold.withValues(alpha: 0.04),
                          ],
                        ),
                        border: Border.all(
                          color: _kGold.withValues(alpha: 0.45),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _kGold.withValues(alpha: 0.28),
                            blurRadius: 40,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _kGold.withValues(alpha: 0.3),
                              width: 1.2,
                            ),
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: _kGold,
                            size: 92,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ---------------------------------------------------------------
          // Content
          // ---------------------------------------------------------------
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 48),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _animatedItem(index, content[index]),
                childCount: content.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Staggered content entrance
  // -------------------------------------------------------------------------
  Widget _animatedItem(int index, Widget child) {
    final start = (index * 0.06).clamp(0.0, 0.55);
    final end = (start + 0.45).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 28 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // Content router
  // -------------------------------------------------------------------------
  List<Widget> _getTeachingContent(BuildContext context, String categoryId) {
    switch (categoryId) {
      case 'wudu':
        return _buildWuduContent(context);
      case 'salah':
        return _buildSalahContent(context);
      case 'hijab':
        return _buildHijabContent(context);
      case 'dua':
        return _buildDuaContent(context);
      case 'etiquette':
        return _buildEtiquetteContent(context);
      case 'tawheed':
        return _buildTawheedContent(context);
      default:
        return [];
    }
  }

  // =========================================================================
  // WUDU
  // =========================================================================
  List<Widget> _buildWuduContent(BuildContext context) {
    final steps = <Map<String, dynamic>>[
      {
        'number': '1',
        'titleEn': 'Intention & Bismillah',
        'titleAr': 'النية والبسملة',
        'titleFr': "L'Intention et Bismillah",
        'descEn':
            'Begin by silently establishing the sincere intention (Niyyah) in your heart to perform Wudu purely for the sake of Allah and to attain a state of ritual purity. The intention is not uttered aloud — it is an act of the heart. Then, verbally say "Bismillah" (In the name of Allah) before you begin washing, seeking blessings and protection in this act of worship. If you forget the Bismillah at the start, it does not invalidate the Wudu, but it does reduce its reward.',
        'descAr':
            'ابدأ باستحضار النية الخالصة في قلبك لأداء الوضوء طلباً للطهارة وابتغاء وجه الله تعالى. والنية محلها القلب ولا يُشرع التلفظ بها. ثم قل "بسم الله" قبل البدء بالغسل تبركاً وتوكلًا على الله. فإن نسيت البسملة في أوله فلا يبطل الوضوء، لكن يفوتك ثوابها وأجرها.',
        'descFr':
            "Commencez par établir silencieusement l'intention sincère (Niyyah) dans votre cœur d'accomplir le Wudu uniquement pour Allah, afin d'atteindre un état de pureté rituelle. L'intention se fait dans le cœur et n'est pas prononcée à voix haute. Ensuite, dites verbalement « Bismillah » (Au nom d'Allah) avant de commencer le lavage. Si vous oubliez le Bismillah au début, cela n'invalide pas le Wudu, mais vous en perdez la récompense.",
        'icon': Icons.favorite_rounded,
      },
      {
        'number': '2',
        'titleEn': 'Wash Both Hands',
        'titleAr': 'غسل اليدين',
        'titleFr': 'Laver les Deux Mains',
        'descEn':
            'Wash both hands thoroughly up to the wrists, three times each. Ensure that water reaches between all fingers, under the nails, and across the entire surface of the hand. Begin with the right hand, then the left. This step is performed first because the hands are the tool of washing — purifying them first ensures that the water used for the rest of the Wudu is not contaminated.',
        'descAr':
            'اغسل كلتا يديك جيداً إلى الرسغين ثلاث مرات لكل يد، وابدأ باليمنى ثم اليسرى. تأكد من تخليل الأصابع ووصول الماء بينها وتحت الأظافر وجميع أجزاء اليد. وتُقدَّم هذه الخطوة أولاً لأن اليدين آلة الغسل، فتطهيرهما أولاً يضمن عدم تلوث الماء المستخدم في بقية الوضوء.',
        'descFr':
            "Lavez soigneusement les deux mains jusqu'aux poignets, trois fois chacune, en commençant par la droite puis la gauche. Assurez-vous que l'eau atteint l'espace entre tous les doigts, sous les ongles et toute la surface de la main. Cette étape vient en premier car les mains sont l'outil du lavage : les purifier d'abord garantit que l'eau utilisée pour le reste du Wudu n'est pas contaminée.",
        'icon': Icons.pan_tool_rounded,
      },
      {
        'number': '3',
        'titleEn': 'Rinse the Mouth (Madmadah)',
        'titleAr': 'المضمضة',
        'titleFr': 'Rincer la Bouche (Madmadah)',
        'descEn':
            'Take a handful of water into your mouth and swirl it around thoroughly, reaching every corner of the mouth, then spit it out. Perform this three times. If you are fasting, be careful not to let the water reach the throat. Rinsing the mouth cleanses the tongue and the palate, and it is a preparation for the remembrance of Allah that follows in prayer and daily life.',
        'descAr':
            'خذ حفنة من الماء في فمك وحرّكه جيداً حتى يصل إلى جميع أطراف الفم ثم مضمض وأخرجه، وكرر ذلك ثلاث مرات. وإن كنت صائماً فاحترس من أن يصل الماء إلى الحلق. والمضمضة تنظف اللسان والفم وتعدّ لذكر الله الذي يلي في الصلاة وسائر اليوم.',
        'descFr':
            "Prenez une poignée d'eau dans votre bouche, faites-la circuler soigneusement dans tous les coins, puis recrachez. Répétez trois fois. Si vous jeûnez, veillez à ce que l'eau n'atteigne pas la gorge. Le rinçage de la bouche purifie la langue et le palais et prépare au rappel d'Allah.",
        'icon': Icons.sentiment_satisfied_rounded,
      },
      {
        'number': '4',
        'titleEn': 'Inhale Water into the Nose (Istinshaq)',
        'titleAr': 'الاستنشاق والاستنثار',
        'titleFr': "Aspirer l'Eau dans le Nez (Istinshaq)",
        'descEn':
            'Sniff a small amount of water gently into your nose and then blow it out, repeating three times. This clears the nasal passage and removes any dust or impurities. If you are fasting, sniff very lightly to avoid the water reaching the throat. The right hand is used for inhaling and the left for blowing out.',
        'descAr':
            'استنشق الماء برفق في أنفك ثم استنثره، وكرر ذلك ثلاث مرات. فإن الاستنشاق يطهّر الممر الأنفي ويزيل ما علق به من غبار أو أذى. وإن كنت صائماً فبالغ في الرفق حتى لا يصل الماء إلى الحلق. ويكون الاستنشاق باليد اليمنى والاستنثار باليد اليسرى.',
        'descFr':
            "Aspirez doucement un peu d'eau dans votre nez puis rejetez-la, en répétant trois fois. Cela nettoie les fosses nasales et élimine poussières et impuretés. Si vous jeûnez, aspirez très légèrement. La main droite sert à aspirer, la gauche à rejeter.",
        'icon': Icons.air_rounded,
      },
      {
        'number': '5',
        'titleEn': 'Wash the Entire Face',
        'titleAr': 'غسل الوجه بالكامل',
        'titleFr': 'Laver Tout le Visage',
        'descEn':
            'Wash your entire face three times. The boundaries of the face extend from the normal hairline down to the bottom of the chin, and from the right earlobe across to the left earlobe. Ensure that water reaches the eyebrows, the corners of the eyes, the eyelashes, and every part of the skin. Use both hands to spread the water from the forehead downward.',
        'descAr':
            'اغسل وجهك بالكامل ثلاث مرات. وحدود الوجه تمتد من منبت الشعر المعتاد إلى أسفل الذقن، ومن شحمة الأذن اليمنى إلى شحمة الأذن اليسرى. وتأكد من وصول الماء إلى الحاجبين وأطراف العينين والأشفار وجميع أجزاء البشرة، وامسح الماء بيديك من الجبهة إلى الأسفل.',
        'descFr':
            "Lavez tout votre visage trois fois. Les limites du visage vont de la racine des cheveux jusqu'au bas du menton, et du lobe de l'oreille droite à celui de l'oreille gauche. Assurez-vous que l'eau atteint les sourcils, les coins des yeux, les cils et chaque partie de la peau.",
        'icon': Icons.face_rounded,
      },
      {
        'number': '6',
        'titleEn': 'Wash the Forearms to the Elbows',
        'titleAr': 'غسل الذراعين إلى المرفقين',
        'titleFr': 'Laver les Avant-bras jusqu aux Coudes',
        'descEn':
            'Wash your right arm completely, starting from the fingertips and continuing up to and including the elbow, three times. Rub the arm with your other hand so the water reaches every part. Then repeat the exact same process for the left arm. Pay special attention to the elbow itself, the inner bend of the elbow, and the areas around the wrist, as these are commonly missed.',
        'descAr':
            'اغسل ذراعك الأيمن بالكامل من أطراف الأصابع حتى المرفق (الكوع) ثلاث مرات، مع دلك الذراع بيدك الأخرى حتى يصل الماء إلى كل جزء. ثم كرر نفس الخطوات مع الذراع الأيسر. واحرص على العناية بموضع المرفق وباطنه والمنطقة حول الرسغ فإنها من المواضع التي يكثر تفويتها.',
        'descFr':
            "Lavez complètement votre bras droit, du bout des doigts jusqu'au coude inclus, trois fois. Frottez le bras avec l'autre main pour que l'eau atteigne chaque partie. Répétez ensuite pour le bras gauche. Accordez une attention particulière au coude et au poignet.",
        'icon': Icons.sports_gymnastics_rounded,
      },
      {
        'number': '7',
        'titleEn': 'Wipe the Head & Ears',
        'titleAr': 'مسح الرأس والأذنين',
        'titleFr': 'Essuyer la Tête et les Oreilles',
        'descEn':
            'With freshly wet hands (without taking new water if possible), wipe over your head starting from the front hairline to the back, then return to the front. This is done once. Then, using your index fingers, wipe the inside of the ears, and using your thumbs, wipe the back of the ears. The head is wiped, not washed, and the ears are considered part of the head.',
        'descAr':
            'بيدين مبللتين بماء جديد، امسح رأسك بدءاً من مقدمة الشعر إلى الخلف ثم عد إلى المقدمة، ويكون ذلك مرة واحدة. ثم امسح أذنيك بإدخال السبابتين في صماخ الأذنين ومسح ظاهرهما بالإبهامين. والرأس يُمسح ولا يُغسل، والأذنان من الرأس حكماً.',
        'descFr':
            "Avec des mains fraîchement mouillées, essuyez votre tête de l'avant vers l'arrière puis revenez vers l'avant. Cela se fait une fois. Ensuite, avec vos index, essuyez l'intérieur des oreilles, et avec vos pouces l'arrière. La tête s'essuie, elle ne se lave pas, et les oreilles font partie de la tête.",
        'icon': Icons.person_outline_rounded,
      },
      {
        'number': '8',
        'titleEn': 'Wash the Feet to the Ankles',
        'titleAr': 'غسل القدمين إلى الكعبين',
        'titleFr': 'Laver les Pieds jusqu aux Chevilles',
        'descEn':
            'Wash your right foot completely, up to and including the ankles, three times, making sure to wash between the toes and the sole of the foot. Then repeat the same process for your left foot. Use your little finger to pass between the toes. This is the final act of Wudu and completes the purification of the body.',
        'descAr':
            'اغسل قدمك اليمنى بالكامل حتى الكعبين ثلاث مرات، مع الحرص على تخليل الأصابع وغسل باطن القدم. ثم كرر نفس العملية للقدم اليسرى. ويمكنك استخدام الخنصر لتخليل ما بين الأصابع. وهذه آخر خطوة في الوضوء وتكمل طهارة البدن.',
        'descFr':
            "Lavez complètement votre pied droit, jusqu'aux chevilles incluses, trois fois, en veillant à laver entre les orteils et la plante du pied. Répétez ensuite pour le pied gauche. Utilisez votre petit doigt pour passer entre les orteils. C'est le dernier acte du Wudu.",
        'icon': Icons.emoji_people_rounded,
      },
    ];

    final sunnahActs = [
      isArabic
          ? 'البدء بالبسملة عند غسل كل عضو من أعضاء الوضوء.'
          : (isFrench
              ? 'Dire « Bismillah » au début du lavage de chaque membre.'
              : 'Saying "Bismillah" at the beginning of washing each limb.'),
      isArabic
          ? 'استخدام السواك أو فرشاة الأسنان قبل الوضوء لتنظيف الفم.'
          : (isFrench
              ? "Utiliser le Siwak ou une brosse à dents avant le Wudu pour nettoyer la bouche."
              : 'Using the Siwak or a toothbrush before Wudu to clean the mouth.'),
      isArabic
          ? 'التيامن: البدء بالعضو الأيمن قبل الأيسر في اليدين والرجلين.'
          : (isFrench
              ? "Commencer par le membre droit avant le gauche pour les mains et les pieds."
              : 'Starting with the right limb before the left for the hands and feet.'),
      isArabic
          ? 'الدلك: تمرير اليد على العضو لضمان وصول الماء إلى كل جزء.'
          : (isFrench
              ? "Frotter le membre avec la main pour que l'eau atteigne chaque partie."
              : 'Rubbing the limb with the hand so water reaches every part.'),
      isArabic
          ? 'الاقتصاد في الماء وعدم الإسراف فيه ولو كان على نهر جارٍ.'
          : (isFrench
              ? "Économiser l'eau et ne pas la gaspiller, même au bord d'une rivière."
              : 'Being economical with water and not wasting it, even beside a flowing river.'),
      isArabic
          ? 'قول الشهادتين بعد إتمام الوضوء: أشهد أن لا إله إلا الله وأشهد أن محمداً رسول الله.'
          : (isFrench
              ? "Réciter les deux témoignages après le Wudu : « Ach-hadou an lâ ilâha illa Allah, wa ach-hadou anna Muhammadan rasûl Allah »."
              : 'Reciting the two testimonies after completing Wudu: "Ash-hadu an la ilaha illa Allah, wa ash-hadu anna Muhammadan rasul Allah."'),
    ];

    final nullifiers = [
      isArabic
          ? 'كل ما يخرج من السبيلين من بول أو غائط أو ريح.'
          : (isFrench
              ? "Tout ce qui sort des deux voies naturelles : urine, selles ou gaz."
              : 'Anything that exits the two private parts: urine, stool, or wind.'),
      isArabic
          ? 'زوال العقل بنوم عميق أو إغماء أو سكر أو جنون.'
          : (isFrench
              ? "La perte de la raison par un sommeil profond, un évanouissement, l'ivresse ou la folie."
              : 'Loss of reason through deep sleep, fainting, intoxication, or insanity.'),
      isArabic
          ? 'لمس الفرج بلا حائل عند بعض الفقهاء، ويُترك الأمر على مذهبك.'
          : (isFrench
              ? "Toucher les parties intimes sans barrière selon certains juristes — suivez votre école."
              : 'Touching the private parts without a barrier according to some jurists — follow your school.'),
      isArabic
          ? 'أكل لحم الإبل عند بعض الفقهاء، والأفضل الوضوء بعده احتياطاً.'
          : (isFrench
              ? "Manger de la viande de chameau selon certains juristes — par précaution, refaites le Wudu."
              : 'Eating camel meat according to some jurists — out of precaution, renew your Wudu.'),
      isArabic
          ? 'الردة عن الإسلام (والعياذ بالله) تُبطل الوضوء بالإجماع.'
          : (isFrench
              ? "L'apostasie (qu'Allah nous en préserve) annule le Wudu par consensus."
              : 'Apostasy (may Allah protect us) invalidates Wudu by consensus.'),
    ];

    final conditions = <Map<String, dynamic>>[
      {
        'situationEn': 'Absence of Water (Tayammum)',
        'situationAr': 'انعدام الماء (التيمم)',
        'situationFr': "Absence d'Eau (Tayammum)",
        'solutionEn':
            'If water is unavailable, or if using it would cause medical harm, or if it is too far to reach without hardship, then Tayammum (dry purification) is performed. Strike clean earth, dust, or sand lightly with both hands, blow off any excess, then wipe the entire face once, then strike again and wipe the hands up to the wrists. Tayammum remains valid until water becomes available or the ability to use it returns.',
        'solutionAr':
            'إذا لم يتوفر الماء، أو كان استخدامه يسبب ضرراً صحياً، أو كان بعيداً لا يُستطاع الوصول إليه بلا مشقة، شُرع التيمم. وهو أن تضرب الصعيد الطاهر (التراب أو الرمل) بيديك ضربة خفيفة، ثم تمسح وجهك بالكامل مرة واحدة، ثم تضرب ضربة ثانية وتمسح كفيك إلى الرسغين. ويبقى التيمم صحيحاً حتى يوجد الماء أو تزول المانع من استعماله.',
        'solutionFr':
            "Si l'eau est indisponible, ou si son utilisation cause un dommage médical, ou si elle est trop éloignée, le Tayammum (purification sèche) est prescrit. Frappez légèrement de la terre ou du sable propre avec les deux mains, soufflez l'excédent, essuyez tout le visage une fois, puis frappez de nouveau et essuyez les mains jusqu'aux poignets. Le Tayammum reste valide jusqu'à ce que l'eau redevienne disponible.",
        'icon': Icons.terrain_rounded,
      },
      {
        'situationEn': 'Wounds, Bandages & Plaster',
        'situationAr': 'الجروح والجبائر واللصقات',
        'situationFr': 'Blessures, Pansements et Plâtres',
        'solutionEn':
            'If you have an open wound, a burn, or a medical bandage on a limb that must be washed, you should not remove it and cause harm. Instead, gently wipe over the bandage with wet hands. If wiping would also cause harm, then you may leave that limb and continue washing the rest of the limbs, and perform Tayammum for the affected area. Islam does not burden a soul beyond its capacity.',
        'solutionAr':
            'إذا كان لديك جرح مفتوح أو حرق أو جبيرة طبية على عضو من أعضاء الوضوء، فلا يجوز نزعها وإلحاق الضرر بالنفس، بل يكفي المسح عليها برفق بيد مبللة. وإن كان المسح يضر أيضاً، فتترك ذلك العضو وتغسل بقية الأعضاء وتتيمم للعضو المصاب. فالدين يسر ولا يكلف الله نفساً إلا وسعها.',
        'solutionFr':
            "Si vous avez une plaie ouverte, une brûlure ou un pansement médical sur un membre à laver, ne le retirez pas et ne vous causez pas de tort. Essuyez doucement le pansement avec des mains mouillées. Si même l'essuyage nuit, laissez ce membre, lavez les autres et faites le Tayammum pour la zone atteinte. Allah n'impose à aucune âme une charge supérieure à sa capacité.",
        'icon': Icons.health_and_safety_rounded,
      },
    ];

    return [
      _buildIntroCard(
        context,
        title: isArabic
            ? 'فضل الوضوء ومكانته'
            : (isFrench ? 'Vertu et Statut du Wudu' : 'The Virtue of Wudu'),
        body: isArabic
            ? 'الوضوء شرط أساسي لصحة الصلاة وطواف الكعبة ومس المصحف. وقد أخبر النبي صلى الله عليه وسلم أن من توضأ فأحسن الوضوء خرجت خطاياه مع الماء أو مع آخر قطرة من قطر الماء، حتى تصبح خطاياه مغفورة. وهو نور يوم القيامة، ودليل على حب العبد للطهارة التي يحبها الله.'
            : (isFrench
                ? "Le Wudu est une condition essentielle pour la validité de la prière, la circumambulation de la Kaaba et le toucher du Coran. Le Prophète (PSL) a informé que celui qui accomplit parfaitement le Wudu voit ses péchés sortir avec l'eau, jusqu'à ce qu'il en soit purifié. C'est une lumière au Jour du Jugement et un signe de l'amour du serviteur pour la pureté qu'Allah aime."
                : 'Wudu is a fundamental condition for the validity of prayer, the circumambulation of the Kaaba, and touching the Quran. The Prophet (PBUH) informed us that whoever performs Wudu perfectly, his sins depart with the water — or with the last drop of water — until he emerges purified. It is a light on the Day of Judgment and a sign of the servant\'s love for the purity that Allah loves.'),
        icon: Icons.auto_awesome_rounded,
      ),
      const SizedBox(height: 12),
      _buildSectionTitle(
        context,
        isArabic
            ? 'خطوات الوضوء التفصيلية'
            : (isFrench ? 'Étapes Détaillées du Wudu' : 'Detailed Steps of Wudu'),
      ),
...steps.asMap().entries.map(
  (e) => _buildStep(context, e.value, 'wudu_${e.key + 1}'),
),      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'سنن الوضوء'
            : (isFrench ? 'Sunnas du Wudu' : 'Sunnah Acts of Wudu'),
      ),
      _buildBulletList(
        context,
        items: sunnahActs,
        icon: Icons.star_rounded,
      ),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'نواقض الوضوء'
            : (isFrench ? 'Annulatifs du Wudu' : 'Nullifiers of Wudu'),
      ),
      _buildBulletList(
        context,
        items: nullifiers,
        icon: Icons.warning_amber_rounded,
      ),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'حالات وأحكام خاصة'
            : (isFrench
                ? 'Circonstances et Règles Spéciales'
                : 'Special Circumstances & Rules'),
      ),
      ...conditions.map((cond) => _buildCondition(context, cond)),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'دعاء بعد الوضوء'
            : (isFrench ? 'Invocation après le Wudu' : 'Du\'a After Wudu'),
      ),
      _buildDuaCard(
        context,
        {
          'titleEn': 'After Completing Wudu',
          'titleAr': 'دعاء بعد إتمام الوضوء',
          'titleFr': 'Après avoir accompli le Wudu',
          'contentEn':
              'Ash-hadu an la ilaha illa Allah, wahdahu la sharika lah, wa ash-hadu anna Muhammadan abduhu wa rasuluh. Allahumma ij\'alni min at-tawwabin, waj\'alni min al-mutatahhirin.\n\n"I bear witness that there is no deity except Allah, alone, without any partner, and I bear witness that Muhammad is His servant and messenger. O Allah, make me among those who repent and make me among those who purify themselves."',
          'contentAr':
              'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ، اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ، وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',
          'contentFr':
              "J'atteste qu'il n'y a de divinité qu'Allah, Seul, sans associé, et j'atteste que Muhammad est Son serviteur et messager. Ô Allah, fais-moi parmi ceux qui se repentent et parmi ceux qui se purifient.",
        },
      ),
      const SizedBox(height: 32),
    ];
  }

  // =========================================================================
  // SALAH
  // =========================================================================
  List<Widget> _buildSalahContent(BuildContext context) {
    final steps = <Map<String, dynamic>>[
      {
        'number': '1',
        'titleEn': 'Purity, Covering & Facing the Qiblah',
        'titleAr': 'الطهارة والستر واستقبال القبلة',
        'titleFr': 'Pureté, Couverture et Orientation vers la Qiblah',
        'descEn':
            'Before you begin, ensure three essential conditions: (1) You are in a state of ritual purity — perform Wudu if needed. (2) Your body, clothes, and place of prayer are free from impurity. (3) Your Awrah is properly covered — for men from the navel to the knee, and for women the entire body except the face and hands. Then, stand facing the Qiblah (the direction of the Kaaba in Makkah).',
        'descAr':
            'قبل البدء تأكد من ثلاثة شروط أساسية: (١) الطهارة من الحدث بالوضوء أو الغسل. (٢) طهارة البدن والثياب والمكان من النجاسة. (٣) ستر العورة، وهي للرجل من السرة إلى الركبة، وللمرأة جميع البدن عدا الوجه والكفين. ثم استقبل القبلة (اتجاه الكعبة في مكة).',
        'descFr':
            "Avant de commencer, assurez trois conditions : (1) être en état de pureté rituelle — faites le Wudu si nécessaire. (2) Votre corps, vos vêtements et le lieu de prière doivent être exempts d'impuretés. (3) Votre Awrah doit être couverte — pour l'homme du nombril aux genoux, pour la femme tout le corps sauf le visage et les mains. Puis tenez-vous face à la Qiblah.",
        'icon': Icons.explore_rounded,
      },
      {
        'number': '2',
        'titleEn': 'Intention & Takbiratul Ihram',
        'titleAr': 'النية وتكبيرة الإحرام',
        'titleFr': "Intention et Takbiratul Ihram",
        'descEn':
            'Stand with a sincere intention in your heart for the specific prayer you are establishing (e.g., "I intend to pray the Fajr prayer for Allah"). Raise your hands to ear or shoulder level and say "Allahu Akbar" (Allah is the Greatest). This moment marks your entry into the sacred state of prayer — from this point, worldly speech is forbidden and you are in direct communication with your Lord.',
        'descAr':
            'قف مستحضراً النية الخالصة في قلبك للصلاة التي تؤديها (مثلاً: نويت أن أصلي صلاة الفجر لله تعالى). ارفع يديك حذو منكبيك أو أذنيك وقل "الله أكبر". وبهذه اللحظة تدخل في حرمة الصلاة، فيُمنع الكلام الدنيوي وتصبح في مناجاة مباشرة مع ربك.',
        'descFr':
            "Tenez-vous debout avec une intention sincère dans votre cœur pour la prière spécifique que vous accomplissez. Levez les mains au niveau des oreilles ou des épaules et dites « Allahu Akbar ». Ce moment marque votre entrée dans l'état sacré de la prière — à partir de là, la parole mondaine est interdite et vous êtes en communication directe avec votre Seigneur.",
        'icon': Icons.favorite_rounded,
      },
      {
        'number': '3',
        'titleEn': 'Standing & Recitation (Qiyam)',
        'titleAr': 'القيام والقراءة',
        'titleFr': 'Position Debout et Récitation (Qiyam)',
        'descEn':
            'Place your right hand over your left hand on your chest. Lower your gaze towards the place of prostration. Begin by reciting the opening supplication (Istiftah), then Surah Al-Fatiha in every unit (Rak\'ah). After Al-Fatiha, recite another portion of the Quran in the first two units — a short Surah or several verses. Recite slowly, with reflection (Tadabbur), for this is a conversation between you and Allah.',
        'descAr':
            'ضع يدك اليمنى على اليسرى على صدرك وانظر إلى موضع سجودك. ابدأ بدعاء الاستفتاح، ثم اقرأ سورة الفاتحة في كل ركعة. وبعد الفاتحة تقرأ سورة أو آيات أخرى في الركعتين الأولى والثانية. واقرأ بتأنٍّ وتدبر، فإن الصلاة مناجاة بينك وبين الله.',
        'descFr':
            "Placez votre main droite sur votre main gauche sur la poitrine. Baissez le regard vers le lieu de prosternation. Récitez la sourate Al-Fatiha dans chaque unité (Rak'ah). Après Al-Fatiha, récitez une autre portion du Coran dans les deux premières unités. Récitez lentement, avec réflexion (Tadabbur), car c'est une conversation entre vous et Allah.",
        'icon': Icons.menu_book_rounded,
      },
      {
        'number': '4',
        'titleEn': 'Bowing (Ruku)',
        'titleAr': 'الركوع',
        'titleFr': "L'Inclinaison (Ruku)",
        'descEn':
            'Say "Allahu Akbar" and bow down, placing your hands firmly on your knees with fingers spread. Keep your back completely straight and parallel to the floor, and your head level with your back — neither raised nor lowered. While bowing, say "Subhana Rabbi al-Azeem" (Glory be to my Lord, the Great) three times, with calmness and humility.',
        'descAr':
            'كبر واركع واضعاً يديك على ركبتيك بقوة مع تفريج الأصابع. واجعل ظهرك مستوياً وموازياً للأرض، ورأسك على مستوى ظهرك لا مرفوعاً ولا منخفضاً. وقل في ركوعك "سبحان ربي العظيم" ثلاث مرات بخشوع وطمأنينة.',
        'descFr':
            "Dites « Allahu Akbar » et inclinez-vous, mains fermement sur les genoux, doigts écartés. Gardez le dos droit et parallèle au sol, la tête au niveau du dos. Pendant l'inclinaison, dites « Subhana Rabbi al-Azeem » trois fois, avec sérénité et humilité.",
        'icon': Icons.downhill_skiing_rounded,
      },
      {
        'number': '5',
        'titleEn': 'Rising & Standing (I\'tidal)',
        'titleAr': 'الاعتدال من الركوع',
        'titleFr': 'Se Relever du Ruku',
        'descEn':
            'Rise from the bowing position saying "Sami\'a Allahu liman hamidah" (Allah hears the one who praises Him). When fully upright, say "Rabbana wa lakal-hamd" (Our Lord, and to You belongs all praise). Stand completely upright with tranquility before moving to prostration, filling this moment with praise and gratitude.',
        'descAr':
            'ارفع رأسك من الركوع قائلاً "سمع الله لمن حمده"، فإذا اعتدلت قائماً فقل "ربنا ولك الحمد". واعتدل واقفاً مطمئناً قبل السجود، واملأ هذه اللحظة بالحمد والشكر لله تعالى.',
        'descFr':
            "Relevez-vous en disant « Sami'a Allahu liman hamidah ». Une fois droit, dites « Rabbana wa lakal-hamd ». Tenez-vous complètement droit avec tranquillité avant de passer à la prosternation, en remplissant ce moment de louange et de gratitude.",
        'icon': Icons.arrow_upward_rounded,
      },
      {
        'number': '6',
        'titleEn': 'Prostration (Sujud)',
        'titleAr': 'السجود',
        'titleFr': 'La Prosternation (Sujud)',
        'descEn':
            'Say "Allahu Akbar" and prostrate. Ensure seven bones touch the ground: the forehead along with the nose, both palms, both knees, and the toes of both feet. Your forearms should not rest flat on the ground (for men), and your stomach should be separated from your thighs. Say "Subhana Rabbi al-Aala" (Glory be to my Lord, the Most High) three times. Sujud is the closest you come to Allah — make abundant du\'a here.',
        'descAr':
            'كبر واسجد، وتأكد من تمكين أعضاء السجود السبعة من الأرض: الجبهة مع الأنف، والكفان، والركبتان، وأطراف أصابع القدمين. ولا تفترش ذراعيك (للرجال) وباعد بطنك عن فخذيك. وقل "سبحان ربي الأعلى" ثلاث مرات. والسجود أقرب ما يكون العبد من ربه، فأكثر فيه من الدعاء. ثم تقوم من السجود بعد التكبير قائلا "رب اغفر لي" ثم اسجد مرة اخرى بالتكبير وكرر ما سبق',
        'descFr':
            "Dites « Allahu Akbar » et prosternez-vous. Assurez-vous que sept os touchent le sol : le front avec le nez, les deux paumes, les deux genoux et les orteils des deux pieds. Dites « Subhana Rabbi al-Aala » trois fois. Le Sujud est le moment où vous êtes le plus proche d'Allah — multipliez les invocations.",
        'icon': Icons.terrain_rounded,
      },
      {
        'number': '7',
        'titleEn': 'Final Sitting, Tashahhud & Salam',
        'titleAr': 'التشهد الأخير والسلام',
        'titleFr': 'Assise Finale, Tashahhud et Salut',
        'descEn':
            'Sit for the final Tashahhud, reciting the prescribed testimony of faith, then the Salawat upon Prophet Muhammad (PBUH) and Prophet Ibrahim (PBUH). Conclude the prayer by turning your head to the right saying "Assalamu alaikum wa rahmatullah", then to the left with the same words. With these two salutations, the prayer ends and you return to ordinary life — carrying the light of your prayer with you.',
        'descAr':
            'اجلس للتشهد الأخير واقرأ التحيات، ثم الصلاة الإبراهيمية على النبي محمد صلى الله عليه وسلم والنبي إبراهيم عليه السلام. واختم الصلاة بالالتفات يميناً قائلاً "السلام عليكم ورحمة الله"، ثم يساراً بمثلها. وبهاتين التسليمتين تنتهي الصلاة وتعود إلى حياتك حاملاً نور صلاتك.',
        'descFr':
            "Asseyez-vous pour le Tashahhud final, récitez le témoignage prescrit, puis les Salawat sur le Prophète Muhammad (PSL) et le Prophète Ibrahim (PSL). Concluez la prière en tournant la tête à droite en disant « Assalamu alaikum wa rahmatullah », puis à gauche. Avec ces deux salutations, la prière se termine.",
        'icon': Icons.waving_hand_rounded,
      },
    ];

    final dailyPrayers = [
      isArabic
          ? 'الفجر: ركعتان، ووقتها من طلوع الفجر الصادق إلى طلوع الشمس.'
          : (isFrench
              ? "Fajr : 2 rak'ahs, de l'aube véritable jusqu'au lever du soleil."
              : 'Fajr: 2 rak\'ahs, from true dawn until sunrise.'),
      isArabic
          ? 'الظهر: أربع ركعات، ووقتها من زوال الشمس إلى دخول وقت العصر.'
          : (isFrench
              ? "Dhuhr : 4 rak'ahs, du déclin du soleil jusqu'à l'Asr."
              : 'Dhuhr: 4 rak\'ahs, from the sun\'s decline until Asr.'),
      isArabic
          ? 'العصر: أربع ركعات، ووقتها من دخول وقت العصر إلى غروب الشمس.'
          : (isFrench
              ? "Asr : 4 rak'ahs, de l'après-midi jusqu'au coucher du soleil."
              : 'Asr: 4 rak\'ahs, from mid-afternoon until sunset.'),
      isArabic
          ? 'المغرب: ثلاث ركعات، ووقتها من غروب الشمس إلى مغيب الشفق الأحمر.'
          : (isFrench
              ? "Maghrib : 3 rak'ahs, du coucher du soleil jusqu'à la disparition du crépuscule rouge."
              : 'Maghrib: 3 rak\'ahs, from sunset until the red twilight disappears.'),
      isArabic
          ? 'العشاء: أربع ركعات، ووقتها من مغيب الشفق إلى ثلث الليل أو نصفه.'
          : (isFrench
              ? "Isha : 4 rak'ahs, de la fin du crépuscule jusqu'au tiers ou à la moitié de la nuit."
              : 'Isha: 4 rak\'ahs, from the end of twilight until the third or half of the night.'),
    ];

    final conditions = [
      isArabic
          ? 'الإسلام: فلا تصح الصلاة من غير المسلم.'
          : (isFrench
              ? "L'Islam : la prière n'est pas valide pour un non-musulman."
              : 'Islam: prayer is not valid from a non-Muslim.'),
      isArabic
          ? 'العقل: فلا تصح من مجنون أو فاقد الأهلية.'
          : (isFrench
              ? "La raison : elle n'est pas valide pour une personne privée de raison."
              : 'Reason: it is not valid from one lacking mental capacity.'),
      isArabic
          ? 'الطهارة من الحدث الأكبر والأصغر بالوضوء أو الغسل.'
          : (isFrench
              ? "La pureté de l'impureté majeure et mineure par le Wudu ou le Ghusl."
              : 'Purity from major and minor impurity through Wudu or Ghusl.'),
      isArabic
          ? 'طهارة البدن والثياب والمكان من النجاسة.'
          : (isFrench
              ? "La pureté du corps, des vêtements et du lieu d'impuretés."
              : 'Purity of body, clothing, and place from impurities.'),
      isArabic
          ? 'ستر العورة بما لا يصف ولا يشف.'
          : (isFrench
              ? "Couvrir l'Awrah avec un vêtement ni transparent ni moulant."
              : 'Covering the Awrah with clothing that is neither transparent nor tight.'),
      isArabic
          ? 'استقبال القبلة، ودخول الوقت، والنية.'
          : (isFrench
              ? "L'orientation vers la Qiblah, l'entrée du temps, et l'intention."
              : 'Facing the Qiblah, the entry of the time, and the intention.'),
    ];

    final nullifiers = [
      isArabic
          ? 'الكلام العمد في الصلاة لغير مصلحة شرعية.'
          : (isFrench
              ? 'Parler volontairement pendant la prière sans nécessité légale.'
              : 'Speaking intentionally during prayer without a legal necessity.'),
      isArabic
          ? 'الأكل أو الشرب، ولو كان قليلاً.'
          : (isFrench
              ? 'Manger ou boire, même en petite quantité.'
              : 'Eating or drinking, even a small amount.'),
      isArabic
          ? 'فعل حركات كثيرة متوالية من غير جنس الصلاة.'
          : (isFrench
              ? "Effectuer de nombreux mouvements successifs étrangers à la prière."
              : 'Performing many successive movements foreign to prayer.'),
      isArabic
          ? 'انكشاف العورة عمداً مع القدرة على سترها.'
          : (isFrench
              ? "Révéler l'Awrah volontairement tout en étant capable de la couvrir."
              : 'Uncovering the Awrah intentionally while able to cover it.'),
      isArabic
          ? 'ترك ركن من أركان الصلاة أو شرط من شروطها بلا عذر.'
          : (isFrench
              ? "Omettre un pilier ou une condition de la prière sans excuse."
              : 'Omitting a pillar or condition of prayer without an excuse.'),
    ];

    return [
      _buildIntroCard(
        context,
        title: isArabic
            ? 'مكانة الصلاة في الإسلام'
            : (isFrench ? 'Statut de la Prière en Islam' : 'The Status of Prayer in Islam'),
        body: isArabic
            ? 'الصلاة هي الركن الثاني من أركان الإسلام، وأول ما يُحاسب عليه العبد يوم القيامة. هي صلة العبد بربه خمس مرات في اليوم، تطهر القلب وتغسل الذنوب وتحفظ المسلم من الفحشاء والمنكر. قال تعالى: ﴿إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ﴾.'
            : (isFrench
                ? "La prière est le deuxième pilier de l'Islam et la première chose sur laquelle le serviteur sera interrogé au Jour du Jugement. C'est le lien du serviteur avec son Seigneur cinq fois par jour ; elle purifie le cœur, efface les péchés et protège le musulman de l'indécence et du mal."
                : 'Prayer is the second pillar of Islam and the first thing the servant will be questioned about on the Day of Judgment. It is the servant\'s connection with his Lord five times a day; it purifies the heart, washes away sins, and protects the Muslim from indecency and wrongdoing. Allah says: "Indeed, prayer prohibits immorality and wrongdoing."'),
        icon: Icons.self_improvement_rounded,
      ),
      const SizedBox(height: 12),
      _buildSectionTitle(
        context,
        isArabic
            ? 'أركان وخطوات الصلاة'
            : (isFrench ? 'Piliers et Étapes de la Prière' : 'Pillars & Steps of Salah'),
      ),
...steps.asMap().entries.map(
  (e) => _buildStep(context, e.value, 'salah_${e.key + 1}'),
),      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'الصلوات الخمس المفروضة'
            : (isFrench ? 'Les Cinq Prières Obligatoires' : 'The Five Obligatory Prayers'),
      ),
      _buildBulletList(
        context,
        items: dailyPrayers,
        icon: Icons.schedule_rounded,
      ),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'شروط صحة الصلاة'
            : (isFrench ? 'Conditions de Validité de la Prière' : 'Conditions of Valid Prayer'),
      ),
      _buildBulletList(
        context,
        items: conditions,
        icon: Icons.check_circle_outline_rounded,
      ),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'مبطلات الصلاة'
            : (isFrench ? 'Annulatifs de la Prière' : 'Nullifiers of Prayer'),
      ),
      _buildBulletList(
        context,
        items: nullifiers,
        icon: Icons.warning_amber_rounded,
      ),
      const SizedBox(height: 32),
    ];
  }

  // =========================================================================
  // HIJAB / DRESS CODE
  // =========================================================================
  List<Widget> _buildHijabContent(BuildContext context) {
    final hijabConditions = [
      isArabic
          ? 'أن يستر جميع البدن ما عدا الوجه والكفين.'
          : (isFrench
              ? 'Couvrir tout le corps sauf le visage et les mains.'
              : 'It must cover the entire body except the face and the hands.'),
      isArabic
          ? 'أن يكون الثوب فضفاضاً لا يصف حجم الجسم أو تفاصيله.'
          : (isFrench
              ? 'Le vêtement doit être ample et ne pas décrire la forme du corps.'
              : 'The garment must be loose-fitting and not describe the shape of the body.'),
      isArabic
          ? 'أن يكون سميكاً لا يشف عما تحته.'
          : (isFrench
              ? "Il doit être épais et non transparent."
              : 'It must be thick enough not to be transparent.'),
      isArabic
          ? 'ألا يكون زينة في نفسه يلفت الأنظار.'
          : (isFrench
              ? "Il ne doit pas être en soi un ornement attirant les regards."
              : 'It must not itself be an adornment that attracts attention.'),
      isArabic
          ? 'ألا يكون معطراً أو مبخراً عند الخروج.'
          : (isFrench
              ? "Il ne doit pas être parfumé ou encensé à la sortie."
              : 'It must not be perfumed or scented when going out.'),
      isArabic
          ? 'ألا يشبه لباس الرجال ولا لباس الكافرات المخصوص.'
          : (isFrench
              ? "Il ne doit pas imiter les vêtements des hommes ni ceux propres aux non-croyantes."
              : 'It must not imitate men\'s clothing or the distinctive dress of non-believing women.'),
    ];

    final etiquette = [
      isArabic
          ? 'البدء بالثوب الأيمن عند اللبس، وبالأيسر عند الخلع، مع التسمية.'
          : (isFrench
              ? 'Commencer par le côté droit en s\'habillant et par le gauche en se déshabillant, avec Bismillah.'
              : 'Starting with the right side when dressing and the left when undressing, with Bismillah.'),
      isArabic
          ? 'الدعاء عند لبس الثوب الجديد: اللهم لك الحمد أنت كسوتنيه...'
          : (isFrench
              ? 'Invoquer Allah en portant un vêtement neuf : « Allahumma lakal-hamd, Anta kasawtanihi... »'
              : 'Supplicating when wearing a new garment: "Allahumma lakal-hamd, Anta kasawtanihi..."'),
      isArabic
          ? 'الاقتصاد في اللباس وعدم الإسراف أو الخيلاء.'
          : (isFrench
              ? "Être modéré dans l'habillement, sans gaspillage ni vanité."
              : 'Being moderate in dress, without wastefulness or vanity.'),
      isArabic
          ? 'النظافة والعناية بالمظهر فإن الطهور شطر الإيمان.'
          : (isFrench
              ? 'La propreté et le soin de son apparence, car la pureté est la moitié de la foi.'
              : 'Cleanliness and care for one\'s appearance, for purity is half of faith.'),
      isArabic
          ? 'البدء بالسلام والدعاء لمن لبس ثوباً جديداً.'
          : (isFrench
              ? "Saluer et invoquer pour celui qui porte un nouveau vêtement."
              : 'Greeting and supplicating for the one wearing a new garment.'),
    ];

    return [
      _buildIntroCard(
        context,
        title: isArabic
            ? 'حقيقة اللباس الإسلامي'
            : (isFrench ? 'La Réalité du Vêtement Islamique' : 'The Reality of Islamic Dress'),
        body: isArabic
            ? 'اللباس في الإسلام ليس مجرد غطاء جسدي، بل هو تعبير عن الهوية والقيمة والكرامة. فالهدف منه تحقيق الحياء والعفة، وصيانة المجتمع من الفتنة، وإظهار الاحترام لله وللنفس. واللباس الشرعي يجمع بين الستر والجمال، والأصالة والاعتدال.'
            : (isFrench
                ? "Le vêtement en Islam n'est pas un simple couvre-corps, il est l'expression d'une identité, d'une valeur et d'une dignité. Il vise à réaliser la pudeur et la chasteté, à préserver la société de la tentation et à manifester le respect d'Allah et de soi-même. Le vêtement légal allie pudeur et beauté, authenticité et modération."
                : 'Clothing in Islam is not merely a physical covering; it is an expression of identity, value, and dignity. Its purpose is to achieve modesty and chastity, to protect society from temptation, and to display respect for Allah and for oneself. Islamic dress combines modesty and beauty, authenticity and moderation.'),
        icon: Icons.auto_awesome_rounded,
      ),
      const SizedBox(height: 12),
      _buildSectionTitle(
        context,
        isArabic
            ? 'فقه اللباس الإسلامي'
            : (isFrench ? 'Règles du Vêtement Islamique' : 'Islamic Dress Code Ethics'),
      ),
      _buildInfoCard(
        context: context,
        title: isArabic
            ? 'لباس المرأة المسلمة (الحجاب)'
            : (isFrench
                ? 'Vêtement de la Femme Musulmane (Hijab)'
                : 'Attire for Muslim Women (Hijab)'),
        content: isArabic
            ? 'الحجاب الشرعي يهدف إلى صيانة المرأة وحفظ كرامتها ورفعتها. يجب أن يستر جميع البدن باستثناء الوجه والكفين عند جمهور الفقهاء. والغرض الأسمى من الحجاب ليس مجرد تغطية الجسد، بل هو عبادة عظيمة تُتقرب بها المرأة إلى ربها، وتُحقق لها الحرية من قيود المظاهر، وتجعل الناس يقدرونها بعقلها وأخلاقها لا بمظهرها.'
            : (isFrench
                ? "Le Hijab vise à protéger la dignité et l'élévation de la femme. Il doit couvrir tout le corps à l'exception du visage et des mains selon la majorité des juristes. Son but suprême n'est pas seulement de couvrir le corps, c'est un acte d'adoration par lequel la femme se rapproche de son Seigneur, se libère des chaînes des apparences, et amène les gens à l'apprécier pour son esprit et son caractère et non pour son apparence."
                : 'The Hijab aims to protect a woman\'s dignity and honor. It must cover the entire body with the exception of the face and hands according to the majority of jurists. Its highest purpose is not merely covering the body — it is a great act of worship through which a woman draws closer to her Lord, freeing her from the chains of appearances, and leading people to value her for her mind and character rather than her looks.'),
        icon: Icons.woman_rounded,
      ),
      const SizedBox(height: 20),
      _buildBulletList(
        context,
        title: isArabic
            ? 'شروط الحجاب الشرعي'
            : (isFrench ? 'Conditions du Hijab Légal' : 'Conditions of the Legal Hijab'),
        items: hijabConditions,
        icon: Icons.check_circle_outline_rounded,
      ),
      const SizedBox(height: 24),
      _buildInfoCard(
        context: context,
        title: isArabic
            ? 'لباس الرجل المسلم'
            : (isFrench ? "Vêtement de l'Homme Musulman" : 'Attire for Muslim Men'),
        content: isArabic
            ? 'الإسلام يوجب على الرجل ستر عورته التي تمتد من السرة إلى الركبة كحد أدنى. ويُستحب له ارتداء الملابس المحتشمة والفضفاضة والنظيفة التي تعكس الوقار والرزانة. ويحرم على الرجال لبس الحرير الخالص والذهب، كما يحرم التشبه بالنساء في اللباس أو الزينة. ومن كمال أدب المسلم ألا يكون لباسه لباس شهرة يلفت الأنظار.'
            : (isFrench
                ? "L'Islam exige que l'homme couvre son Awrah, qui s'étend du nombril aux genoux au minimum. Il est recommandé de porter des vêtements pudiques, amples et propres qui reflètent la dignité et la sobriété. Le port de la soie pure et de l'or est interdit aux hommes, tout comme l'imitation des vêtements ou des parures des femmes. Il convient également d'éviter les vêtements ostentatoires."
                : 'Islam requires men to cover their Awrah, which extends from the navel to the knee at minimum. It is recommended to wear modest, loose-fitting, clean clothing that reflects dignity and sobriety. It is forbidden for men to wear pure silk or gold, and to imitate women\'s clothing or adornment. It is also part of a Muslim\'s etiquette to avoid ostentatious clothing that attracts attention.'),
        icon: Icons.man_rounded,
      ),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'آداب اللباس'
            : (isFrench ? "Étiquette de l'Habillement" : 'Etiquette of Dress'),
      ),
      _buildBulletList(
        context,
        items: etiquette,
        icon: Icons.star_rounded,
      ),
      const SizedBox(height: 32),
    ];
  }

  // =========================================================================
  // DUA
  // =========================================================================
  List<Widget> _buildDuaContent(BuildContext context) {
    final duas = <Map<String, String>>[
      {
        'titleEn': 'Upon Waking Up',
        'titleAr': 'دعاء الاستيقاظ من النوم',
        'titleFr': 'Au Réveil',
        'contentEn':
            'Alhamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur.\n\n"All praise is due to Allah who brought us to life after having given us death, and to Him is the resurrection."',
        'contentAr': 'الْحَمْدُ للهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        'contentFr':
            "La louange est à Allah qui nous a rendu la vie après nous avoir fait mourir, et vers Lui est la résurrection.",
      },
      {
        'titleEn': 'Before Sleeping',
        'titleAr': 'دعاء قبل النوم',
        'titleFr': 'Avant de Dormir',
        'contentEn':
            'Bismika Allahumma amutu wa ahya.\n\n"In Your Name, O Allah, I die and I live."',
        'contentAr': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        'contentFr': 'En Ton Nom, Ô Allah, je meurs et je vis.',
      },
      {
        'titleEn': 'Entering the Home',
        'titleAr': 'دعاء دخول المنزل',
        'titleFr': 'En Entrant à la Maison',
        'contentEn':
            'Bismillahi walajna, wa bismillahi kharajna, wa \'ala Rabbina tawakkalna.\n\n"In the name of Allah we enter and in the name of Allah we leave, and upon our Lord we place our trust."',
        'contentAr': 'بِسْمِ اللهِ وَلَجْنَا، وَبِسْمِ اللهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا',
        'contentFr':
            "Au nom d'Allah nous entrons, et au nom d'Allah nous sortons, et en notre Seigneur nous plaçons notre confiance.",
      },
      {
        'titleEn': 'Leaving the Home',
        'titleAr': 'دعاء الخروج من المنزل',
        'titleFr': 'En Sortant de la Maison',
        'contentEn':
            'Bismillah, tawakkaltu \'ala Allah, wa la hawla wa la quwwata illa billah.\n\n"In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah."',
        'contentAr': 'بِسْمِ اللهِ، تَوَكَّلْتُ عَلَى اللهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
        'contentFr':
            "Au nom d'Allah, je place ma confiance en Allah, et il n'y a de force ni de puissance qu'en Allah.",
      },
      {
        'titleEn': 'Before Eating',
        'titleAr': 'دعاء قبل الطعام',
        'titleFr': 'Avant de Manger',
        'contentEn':
            'Bismillah. (If you forget at the beginning, say: Bismillahi awwalahu wa akhirahu.)\n\n"In the name of Allah." — "In the name of Allah at its beginning and its end."',
        'contentAr': 'بِسْمِ اللهِ. وإن نسيت في أوله فقل: بِسْمِ اللهِ أَوَّلَهُ وَآخِرَهُ',
        'contentFr':
            "Au nom d'Allah. (Si vous oubliez au début, dites : Bismillahi awwalahu wa akhirahu.)",
      },
      {
        'titleEn': 'After Eating',
        'titleAr': 'دعاء بعد الطعام',
        'titleFr': 'Après avoir Mangé',
        'contentEn':
            'Alhamdu lillahil-ladhi at\'amana wa saqana wa ja\'alana minal-muslimin.\n\n"All praise is due to Allah who fed us, gave us drink, and made us among the Muslims."',
        'contentAr': 'الْحَمْدُ للهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِينَ',
        'contentFr':
            "Louange à Allah qui nous a nourris, désaltérés et faits parmi les musulmans.",
      },
      {
        'titleEn': 'Entering the Bathroom',
        'titleAr': 'دعاء دخول الخلاء',
        'titleFr': 'En Entrant aux Toilettes',
        'contentEn':
            'Allahumma inni a\'udhu bika minal-khubuthi wal-khaba\'ith.\n\n"O Allah, I seek refuge with You from male and female devils."',
        'contentAr': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
        'contentFr':
            "Ô Allah, je cherche refuge auprès de Toi contre les démons mâles et femelles.",
      },
      {
        'titleEn': 'Leaving the Bathroom',
        'titleAr': 'دعاء الخروج من الخلاء',
        'titleFr': 'En Sortant des Toilettes',
        'contentEn': 'Ghufranak.\n\n"I seek Your forgiveness, O Allah."',
        'contentAr': 'غُفْرَانَكَ',
        'contentFr': 'Je cherche Ton pardon, Ô Allah.',
      },
    ];

    return [
      _buildIntroCard(
        context,
        title: isArabic
            ? 'الدعاء: عبادة القلب واللسان'
            : (isFrench ? 'L\'Invocation : Adoration du Cœur et de la Langue' : 'Du\'a: Worship of the Heart and Tongue'),
        body: isArabic
            ? 'الدعاء هو العبادة كما أخبر النبي صلى الله عليه وسلم، وهو صلة مباشرة بين العبد وربه لا يحتاج فيها إلى وسيط. والأدعية المأثورة عن النبي صلى الله عليه وسلم هي أفضلها وأجمعها للخير، فهي كلمات قليلة تحمل معاني عظيمة وتُحصّن المسلم في كل لحظة من لحظات يومه.'
            : (isFrench
                ? "L'invocation est l'adoration elle-même, comme l'a informé le Prophète (PSL). C'est un lien direct entre le serviteur et son Seigneur, sans intermédiaire. Les invocations rapportées du Prophète (PSL) sont les meilleures et les plus complètes : peu de mots, de grands sens, qui protègent le musulman à chaque instant de sa journée."
                : 'Du\'a is worship itself, as the Prophet (PBUH) informed us. It is a direct link between the servant and his Lord with no intermediary. The supplications narrated from the Prophet (PBUH) are the best and most comprehensive — few words carrying great meanings, fortifying the Muslim in every moment of the day.'),
        icon: Icons.favorite_rounded,
      ),
      const SizedBox(height: 12),
      _buildSectionTitle(
        context,
        isArabic
            ? 'أدعية وأذكار يومية'
            : (isFrench ? 'Invocations Quotidiennes' : 'Essential Daily Supplications'),
      ),
      ...duas.map((dua) => _buildDuaCard(context, dua)),
      const SizedBox(height: 32),
    ];
  }

  // =========================================================================
  // ETIQUETTE
  // =========================================================================
  List<Widget> _buildEtiquetteContent(BuildContext context) {
    final peaceEtiquette = [
      isArabic
          ? 'إفشاء السلام بين الناس، فيبدأ الصغير بالكبير، والراكب بالماشي، والقليل بالكثير.'
          : (isFrench
              ? "Répandre le salut : le plus jeune salue l'aîné, le cavalier le piéton, le petit groupe le plus grand."
              : 'Spreading the greeting: the younger greets the elder, the rider the pedestrian, the smaller group the larger.'),
      isArabic
          ? 'رد السلام بمثله أو بأحسن منه: "وعليكم السلام ورحمة الله وبركاته".'
          : (isFrench
              ? "Rendre le salut par mieux : « Wa alaikum as-salam wa rahmatullahi wa barakatuh »."
              : 'Returning the greeting with something better: "Wa alaikum as-salam wa rahmatullahi wa barakatuh."'),
      isArabic
          ? 'التبسم في وجه أخيك المسلم صدقة، والكلمة الطيبة صدقة.'
          : (isFrench
              ? "Sourire à ton frère est une aumône, et une bonne parole est une aumône."
              : 'Smiling at your brother is charity, and a good word is charity.'),
      isArabic
          ? 'المصافحة بين الرجال، وبين النساء، مع مراعاة الأحكام الشرعية.'
          : (isFrench
              ? "La poignée de main entre hommes, et entre femmes, dans le respect des règles."
              : 'Shaking hands between men, and between women, observing the legal rulings.'),
    ];

    final communityEtiquette = [
      isArabic
          ? 'حسن الجوار: كف الأذى، وإكرام الجار، وتفقد أحواله.'
          : (isFrench
              ? "Le bon voisinage : ne pas nuire, honorer son voisin, prendre de ses nouvelles."
              : 'Good neighborliness: refraining from harm, honoring the neighbor, checking on him.'),
      isArabic
          ? 'إكرام الضيف، فقد كان النبي صلى الله عليه وسلم يكرم الضيوف.'
          : (isFrench
              ? "Honorer l'invité : le Prophète (PSL) honorait ses hôtes."
              : 'Honoring the guest: the Prophet (PBUH) used to honor his guests.'),
      isArabic
          ? 'الصدق في الحديث، وأداء الأمانة، والوفاء بالوعد.'
          : (isFrench
              ? "La sincérité dans la parole, le respect du dépôt et de la promesse."
              : 'Truthfulness in speech, fulfilling trusts, and keeping promises.'),
      isArabic
          ? 'اجتناب الغيبة والنميمة والسخرية بالناس.'
          : (isFrench
              ? "Éviter la médisance, les ragots et la moquerie."
              : 'Avoiding backbiting, gossiping, and mocking people.'),
      isArabic
          ? 'الإحسان إلى الجار ولو كان غير مسلم، فالإسلام يحفظ حق الجوار.'
          : (isFrench
              ? "Être bon envers le voisin, même non-musulman : l'Islam préserve le droit du voisinage."
              : 'Being kind to the neighbor even if non-Muslim — Islam preserves the right of the neighbor.'),
    ];

    return [
      _buildIntroCard(
        context,
        title: isArabic
            ? 'الأخلاق: جوهر الرسالة'
            : (isFrench ? 'Le Caractère : Essence du Message' : 'Character: The Essence of the Message'),
        body: isArabic
            ? 'قال النبي صلى الله عليه وسلم: «إنما بُعثت لأتمم مكارم الأخلاق». فالأخلاق الحسنة هي ثمرة الإيمان وعلامة صدقه، وهي أثقل ما يوضع في ميزان العبد المؤمن يوم القيامة. والمجتمع المسلم يقوم على أدب متبادل بين الأفراد، يبدأ من البيت وينتشر إلى الجيران والمجتمع كله.'
            : (isFrench
                ? "Le Prophète (PSL) a dit : « Je n'ai été envoyé que pour parfaire les nobles caractères. » Le bon caractère est le fruit de la foi et sa preuve, et c'est ce qui pèse le plus lourd dans la balance du croyant au Jour du Jugement. La société musulmane repose sur une étiquette mutuelle, du foyer aux voisins jusqu'à toute la communauté."
                : 'The Prophet (PBUH) said: "I was only sent to perfect noble character." Good character is the fruit of faith and its proof, and it is the heaviest thing placed in the balance of the believing servant on the Day of Judgment. Muslim society is built upon mutual etiquette, starting from the home and spreading to neighbors and the entire community.'),
        icon: Icons.handshake_rounded,
      ),
      const SizedBox(height: 12),
      _buildSectionTitle(
        context,
        isArabic
            ? 'الآداب والأخلاق الإسلامية'
            : (isFrench ? 'Étiquette et Manières Islamiques' : 'Islamic Etiquette & Manners'),
      ),
      _buildInfoCard(
        context: context,
        title: isArabic
            ? 'بر الوالدين (الإحسان إليهما)'
            : (isFrench ? 'Bonté envers les Parents' : 'Righteousness to Parents'),
        content: isArabic
            ? 'بر الوالدين من أعظم القربات إلى الله بعد التوحيد، وقد قرن الله حق الوالدين بحقه في القرآن الكريم. ويتضمن ذلك التحدث معهما بأدب وصوت خفيض، وطاعتهما في غير معصية، وخدمتهما عند الكبر، وكثرة الدعاء لهما بالرحمة والمغفرة، والإحسان إليهما حتى بعد موتهما بالصدقة والدعاء وصلة أرحامهما.'
            : (isFrench
                ? "La bonté envers les parents est l'un des actes les plus nobles après le Tawhid. Allah a joint le droit des parents à Son droit dans le Coran. Cela implique leur parler avec respect et douceur, obéir à leurs demandes justes, prendre soin d'eux dans leur vieillesse, prier continuellement pour eux, et être bon envers eux même après leur mort par l'aumône, l'invocation et le maintien des liens familiaux."
                : 'Kindness to parents is among the highest virtues after Tawheed. Allah joined the right of parents to His own right in the Quran. It involves speaking to them with respect and a gentle voice, obeying them in what is not disobedience, serving them in their old age, praying continuously for their mercy and forgiveness, and being good to them even after their death through charity, supplication, and maintaining family ties.'),
        icon: Icons.family_restroom_rounded,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        context: context,
        title: isArabic
            ? 'إفشاء السلام وحسن الخلق'
            : (isFrench
                ? 'Répandre la Paix et le Bon Caractère'
                : 'Spreading Peace & Good Character'),
        content: isArabic
            ? 'حث الإسلام على إفشاء السلام بين الناس بكلمة "السلام عليكم ورحمة الله وبركاته". كما يؤكد على التبسم في وجه أخيك المسلم، والكلمة الطيبة، والصدق في الحديث، وتجنب الغيبة والنميمة. والسلام ليس مجرد تحية، بل هو عهد أمان ومحبة بين أفراد المجتمع المسلم.'
            : (isFrench
                ? "L'Islam encourage à répandre la salutation de paix. Il met l'accent sur le sourire, la parole douce, l'honnêteté et l'évitement strict de la médisance et des ragots. Le salut n'est pas qu'une salutation, c'est un pacte de sécurité et d'amour entre les membres de la communauté musulmane."
                : 'Islam heavily promotes spreading the greeting of peace. It emphasizes the charity of a smile, speaking gentle words, maintaining absolute honesty, and strictly avoiding backbiting or gossiping. The greeting is not merely a salutation — it is a pact of safety and love between members of the Muslim community.'),
        icon: Icons.forum_rounded,
      ),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'آداب السلام'
            : (isFrench ? 'Étiquette du Salut' : 'Etiquette of the Greeting'),
      ),
      _buildBulletList(
        context,
        items: peaceEtiquette,
        icon: Icons.record_voice_over_rounded,
      ),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'آداب المجتمع والجوار'
            : (isFrench ? 'Étiquette de la Société et du Voisinage' : 'Etiquette of Society & Neighbors'),
      ),
      _buildBulletList(
        context,
        items: communityEtiquette,
        icon: Icons.people_alt_rounded,
      ),
      const SizedBox(height: 32),
    ];
  }

  // =========================================================================
  // TAWHEED
  // =========================================================================
  List<Widget> _buildTawheedContent(BuildContext context) {
    final shirkCategories = [
      isArabic
          ? 'الشرك الأكبر: صرف أي نوع من العبادة لغير الله كالدعاء والذبح والاستغاثة، وهو مخرج من الملة.'
          : (isFrench
              ? "Le grand polythéisme : diriger un acte d'adoration vers autre qu'Allah (invocation, sacrifice, imploration). Il fait sortir de la religion."
              : 'Major shirk: directing any act of worship to other than Allah, such as supplication, sacrifice, or seeking help. It exits one from the religion.'),
      isArabic
          ? 'الشرك الأصغر: كالرياء والسمعة، والحلف بغير الله، وقول "ما شاء الله وشئت".'
          : (isFrench
              ? "Le petit polythéisme : l'ostentation, jurer par autre qu'Allah, dire « ce qu'Allah et toi voulez »."
              : 'Minor shirk: such as showing off, swearing by other than Allah, and saying "what Allah and you will."'),
      isArabic
          ? 'الشرك الخفي: كحب الرياسة والظهور، وهو أخفى من دبيب النمل على الصفا في الليلة الظلماء.'
          : (isFrench
              ? "Le polythéisme caché : l'amour de la notoriété et de la direction, plus subtil qu'une fourmi noire sur une pierre noire dans une nuit obscure."
              : 'Hidden shirk: such as love of leadership and prominence — subtler than a black ant on a black stone on a dark night.'),
      isArabic
          ? 'الوقاية من الشرك: بتجديد التوحيد، والإخلاص، وكثرة الدعاء بالثبات على الدين.'
          : (isFrench
              ? "Se protéger du polythéisme : renouveler le Tawhid, la sincérité, et invoquer Allah pour la constance."
              : 'Protection from shirk: renewing Tawheed, sincerity, and supplicating Allah for steadfastness in the religion.'),
    ];

    final benefits = [
      isArabic
          ? 'الأمن والهداية في الدنيا والآخرة: ﴿الَّذِينَ آمَنُوا وَلَمْ يَلْبِسُوا إِيمَانَهُم بِظُلْمٍ أُولَٰئِكَ لَهُمُ الْأَمْنُ وَهُم مُّهْتَدُونَ﴾.'
          : (isFrench
              ? "La sécurité et la guidée ici-bas et dans l'au-delà : « Ceux qui ont la foi et n'ont pas entaché leur foi d'injustice... »"
              : 'Security and guidance in this life and the next: "Those who believe and have not mixed their faith with wrongdoing — for them is security and they are guided."'),
      isArabic
          ? 'دخول الجنة بغير حساب ولا عذاب لمن حقق التوحيد وأخلص لله.'
          : (isFrench
              ? "L'entrée au Paradis sans jugement ni châtiment pour celui qui réalise le Tawhid."
              : 'Entering Paradise without reckoning or punishment for the one who realizes Tawheed.'),
      isArabic
          ? 'غفران الذنوب: فمن مات موحداً غير مشرك بالله دخل الجنة وإن عُذب بذنوبه.'
          : (isFrench
              ? "Le pardon des péchés : quiconque meurt monothéiste sans associer à Allah entre au Paradis."
              : 'Forgiveness of sins: whoever dies upon Tawheed without associating partners with Allah enters Paradise.'),
      isArabic
          ? 'بركة في العمر والرزق، وطمأنينة في القلب، وسعة في الصدر.'
          : (isFrench
              ? "La bénédiction dans la vie et la subsistance, la tranquillité du cœur et la sérénité."
              : 'Blessing in life and provision, tranquility of the heart, and expansion of the chest.'),
      isArabic
          ? 'تحقيق العبودية لله وحده، والتحرر من عبادة المخلوقين والأهواء.'
          : (isFrench
              ? "Réaliser l'adoration d'Allah seul et se libérer de l'adoration des créatures et des passions."
              : 'Realizing worship of Allah alone and freeing oneself from worshipping creatures and desires.'),
    ];

    return [
      _buildIntroCard(
        context,
        title: isArabic
            ? 'التوحيد: أساس الدين وأصل الإيمان'
            : (isFrench
                ? "Le Tawhid : Fondement de la Religion"
                : 'Tawheed: The Foundation of the Religion'),
        body: isArabic
            ? 'التوحيد هو إفراد الله بالربوبية والألوهية والأسماء والصفات، وهو الغاية التي خُلق من أجلها الجن والإنس، وأُرسلت بها الرسل، وأُنزلت الكتب. وهو أول ما يدخل به المرء الإسلام، وأول ما يُسأل عنه في القبر. فمن حققه دخل الجنة بغير حساب، ومن ضيّعه خسر الدنيا والآخرة.'
            : (isFrench
                ? "Le Tawhid consiste à unifier Allah dans Sa Seigneurie, Son adoration, Ses Noms et Attributs. C'est le but pour lequel les djinns et les hommes ont été créés, les messagers envoyés et les livres révélés. C'est la première chose par laquelle on entre en Islam et la première sur laquelle on est interrogé dans la tombe."
                : 'Tawheed is singling out Allah in His Lordship, His worship, His Names, and His Attributes. It is the purpose for which jinn and mankind were created, the messengers were sent, and the books were revealed. It is the first thing by which one enters Islam and the first thing one is asked about in the grave. Whoever realizes it enters Paradise without reckoning; whoever wastes it loses this world and the next.'),
        icon: Icons.mosque_rounded,
      ),
      const SizedBox(height: 12),
      _buildSectionTitle(
        context,
        isArabic
            ? 'أقسام التوحيد الثلاثة'
            : (isFrench ? 'Les Trois Catégories du Tawhid' : 'The Three Categories of Tawheed'),
      ),
      _buildInfoCard(
        context: context,
        title: isArabic
            ? '١. توحيد الربوبية'
            : (isFrench ? '1. Unicité de la Seigneurie' : '1. Tawheed Ar-Rububiyyah (Lordship)'),
        content: isArabic
            ? 'هو الإقرار الجازم بأن الله تعالى وحده هو الخالق لكل شيء، والمالك للملك، والمدبر لشؤون الكون بأسره. لا شريك له في خلقه ولا في تدبيره، فهو المحيي والمميت والرازق، وبيده النفع والضر، وهو على كل شيء قدير. وهذا القسم كان معترفاً به حتى المشركون في الجاهلية، لكنه وحده لا يكفي لدخول الإسلام.'
            : (isFrench
                ? "La croyance ferme qu'Allah seul est le Créateur, le Maître et le Contrôleur de l'univers. Il n'a pas d'associé dans la création ou l'administration de toutes choses. Il donne la vie et la mort, pourvoit à la subsistance, détient le bien et le mal. Ce type de Tawhid était reconnu même par les polythéistes de l'époque pré-islamique, mais il ne suffit pas à lui seul pour entrer en Islam."
                : 'The firm belief and acknowledgment that Allah alone is the Creator, Master, and Sustainer of the entire universe. He has no partners in His dominion; He alone provides sustenance, brings life, and causes death. In His hand is benefit and harm, and He is over all things competent. Even the polytheists of the pre-Islamic era acknowledged this category — yet it alone is not sufficient to enter Islam.'),
        icon: Icons.public_rounded,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        context: context,
        title: isArabic
            ? '٢. توحيد الألوهية'
            : (isFrench ? "2. Unicité de l'Adoration" : '2. Tawheed Al-Uluhiyyah (Worship)'),
        content: isArabic
            ? 'هو إفراد الله سبحانه وتعالى بجميع أنواع العبادة الظاهرة والباطنة، كالدعاء والخوف والرجاء والتوكل والصلاة والذبح والنذر. فلا يُصرف شيء من العبادة لغير الله مطلقاً. وهذا هو التوحيد الذي بُعثت به الرسل، وعليه مدار الرسالة، وهو أول ما يجب على المسلم تعلمه وتعليمه.'
            : (isFrench
                ? "Diriger toutes les formes d'adoration vers Allah seul : qu'il s'agisse de la prière, des invocations, du jeûne, de la peur, de l'espoir, de la confiance, du sacrifice ou du vœu. Rien de tout cela ne doit être adressé à autre qu'Allah. C'est le Tawhid pour lequel les messagers ont été envoyés, et c'est la première chose que le musulman doit apprendre et enseigner."
                : 'Singling out Allah alone for all acts of worship, both outward and inward — such as supplication, fear, hope, reliance, prayer, sacrifice, and vows. Nothing of worship is directed to other than Allah. This is the Tawheed for which the messengers were sent; it is the axis of the message and the first thing a Muslim must learn and teach.'),
        icon: Icons.volunteer_activism_rounded,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        context: context,
        title: isArabic
            ? '٣. توحيد الأسماء والصفات'
            : (isFrench
                ? '3. Unicité des Noms et Attributs'
                : '3. Tawheed Al-Asma was-Sifat (Names & Attributes)'),
        content: isArabic
            ? 'الإيمان الجازم بكل ما أثبته الله لنفسه في القرآن الكريم أو أثبته له رسوله من الأسماء الحسنى والصفات العلى، من غير تحريف ولا تعطيل ولا تكييف ولا تمثيل. قال تعالى: ﴿لَيْسَ كَمِثْلِهِ شَيْءٌ وَهُوَ السَّمِيعُ الْبَصِيرُ﴾. فالله له الأسماء الحسنى والصفات الكاملة التي تليق بجلاله، ولا تُشبه صفات المخلوقين.'
            : (isFrench
                ? "Croire en tous les Noms et Attributs magnifiques qu'Allah s'est donnés dans le Coran et la Sunnah, sans les modifier, les nier, les interpréter de manière erronée ou les comparer à Sa création. « Rien ne Lui ressemble, et Il est l'Audient, le Clairvoyant. » Allah possède les Noms les plus beaux et les Attributs parfaits qui conviennent à Sa majesté."
                : 'Believing in all the Beautiful Names and Perfect Attributes Allah has affirmed for Himself in the Quran and Sunnah, without altering their meaning, denying them, asking how they are, or likening them to creation. Allah says: "There is nothing like unto Him, and He is the Hearing, the Seeing." Allah has the most beautiful Names and perfect Attributes that befit His majesty, and they do not resemble the attributes of creation.'),
        icon: Icons.auto_awesome_rounded,
      ),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'أقسام الشرك المحرم'
            : (isFrench ? 'Les Catégories du Polythéisme' : 'Categories of Shirk (Polytheism)'),
      ),
      _buildBulletList(
        context,
        items: shirkCategories,
        icon: Icons.warning_amber_rounded,
      ),
      const SizedBox(height: 24),
      _buildSectionTitle(
        context,
        isArabic
            ? 'ثمرات التوحيد وفوائده'
            : (isFrench ? 'Fruits et Bienfaits du Tawhid' : 'Fruits & Benefits of Tawheed'),
      ),
      _buildBulletList(
        context,
        items: benefits,
        icon: Icons.star_rounded,
      ),
      const SizedBox(height: 32),
    ];
  }

  // =========================================================================
  // REUSABLE WIDGETS
  // =========================================================================
  Widget _buildStep(
    BuildContext context, Map<String, dynamic> step, String poseKey) {
  final String title = isArabic
      ? step['titleAr'] as String
      : (isFrench ? step['titleFr'] as String : step['titleEn'] as String);
  final String desc = isArabic
      ? step['descAr'] as String
      : (isFrench ? step['descFr'] as String : step['descEn'] as String);

  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: _kGold.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _kGold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Illustration on the left ──
          _StepIllustration(poseKey: poseKey, size: 100),
          const SizedBox(width: 16),
          // ── Content on the right ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_kGold, _kGoldDeep],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _kGold.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          step['number'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: _kGold,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                    height: 1.3,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  desc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.getOnBackgroundColor(context)
                            .withValues(alpha: 0.85),
                        height: 1.75,
                        fontSize: 15,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildCondition(BuildContext context, Map<String, dynamic> condition) {
    final String situation = isArabic
        ? condition['situationAr'] as String
        : (isFrench
            ? condition['situationFr'] as String
            : condition['situationEn'] as String);
    final String solution = isArabic
        ? condition['solutionAr'] as String
        : (isFrench
            ? condition['solutionFr'] as String
            : condition['solutionEn'] as String);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _kGold.withValues(alpha: 0.07),
              _kGold.withValues(alpha: 0.01),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _kGold.withValues(alpha: 0.3),
            width: 1.4,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: _kGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _kGold.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    condition['icon'] as IconData,
                    color: _kGold,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    situation,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _kGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          height: 1.3,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Text(
                solution,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.getOnBackgroundColor(context)
                          .withValues(alpha: 0.82),
                      height: 1.75,
                      fontSize: 15,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: _kGold.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _kGold.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _kGold.withValues(alpha: 0.2),
                      _kGold.withValues(alpha: 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _kGold.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: _kGold, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _kGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        height: 1.3,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getOnBackgroundColor(context)
                      .withValues(alpha: 0.85),
                  height: 1.8,
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard(
    BuildContext context, {
    required String title,
    required String body,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _kGold.withValues(alpha: 0.14),
            _kGold.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _kGold.withValues(alpha: 0.35),
          width: 1.4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _kGold, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _kGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        height: 1.3,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getOnBackgroundColor(context)
                      .withValues(alpha: 0.88),
                  height: 1.8,
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletList(
    BuildContext context, {
    String? title,
    required List<String> items,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _kGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 14),
        ],
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: _kGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _kGold.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Icon(icon, color: _kGold, size: 16),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getOnBackgroundColor(context)
                              .withValues(alpha: 0.85),
                          height: 1.75,
                          fontSize: 15,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDuaCard(BuildContext context, Map<String, String> dua) {
    final title = isArabic
        ? dua['titleAr']!
        : (isFrench ? dua['titleFr']! : dua['titleEn']!);
    final content = isArabic
        ? dua['contentAr']!
        : (isFrench ? dua['contentFr']! : dua['contentEn']!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: _kGold.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: _kGold.withValues(alpha: 0.22),
            width: 1.4,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: _kGold.withValues(alpha: 0.7),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _kGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.3,
                        ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: _kGold, thickness: 0.6, height: 1),
            ),
            Text(
              content,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.getOnBackgroundColor(context),
                    height: 1.9,
                    fontSize: 16,
                    fontWeight: isArabic ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: _kGold,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  fontSize: 22,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 4,
            width: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_kGold, _kGoldSoft],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  
}

// ═══════════════════════════════════════════════════════════════════════
// STEP ILLUSTRATION — pictogram figures drawn with CustomPainter
// ═══════════════════════════════════════════════════════════════════════

class _StepIllustration extends StatelessWidget {
  final String poseKey;
  final double size;

  const _StepIllustration({required this.poseKey, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _kGold.withValues(alpha: 0.16),
            _kGold.withValues(alpha: 0.03),
          ],
        ),
        border: Border.all(
          color: _kGold.withValues(alpha: 0.38),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: _kGold.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: CustomPaint(
          painter: _PosePainter(poseKey: poseKey, color: _kGold),
        ),
      ),
    );
  }
}

class _PosePainter extends CustomPainter {
  final String poseKey;
  final Color color;

  _PosePainter({required this.poseKey, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    Offset p(double x, double y) => Offset(x * s, y * s);

    final main = Paint()
      ..color = color
      ..strokeWidth = 4.0 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final soft = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..strokeWidth = 3.0 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final softFill = Paint()
      ..color = color.withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;

    // Helper: draw a teardrop (water drop)
    void drop(Offset c, double sz, Paint paint) {
      final path = Path()
        ..moveTo(c.dx, c.dy - sz)
        ..quadraticBezierTo(
            c.dx + sz, c.dy - sz * 0.2, c.dx + sz * 0.7, c.dy + sz * 0.5)
        ..quadraticBezierTo(
            c.dx, c.dy + sz * 1.1, c.dx - sz * 0.7, c.dy + sz * 0.5)
        ..quadraticBezierTo(
            c.dx - sz, c.dy - sz * 0.2, c.dx, c.dy - sz)
        ..close();
      canvas.drawPath(path, paint);
    }

    // Helper: draw head (circle)
    void head(Offset c) => canvas.drawCircle(c, 8 * s, fill);

    // Helper: prayer mat
    void mat(double cx, double cy) {
      final r = Rect.fromLTWH(
          (cx - 32) * s, cy * s, 64 * s, 12 * s);
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, Radius.circular(3 * s)),
        softFill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, Radius.circular(3 * s)),
        soft,
      );
    }

    switch (poseKey) {
      // ─────────────── WUDU ───────────────
      case 'wudu_1':
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 22),
            hipPos: p(50, 60),
            armR: [p(50, 38), p(58, 45), p(50, 50)],
            armL: [p(50, 38), p(42, 45), p(50, 50)],
            legR: [p(50, 60), p(46, 78), p(44, 92)],
            legL: [p(50, 60), p(54, 78), p(56, 92)]);
        // small heart above head
        final hp = Path()
          ..moveTo(50 * s, 8 * s)
          ..cubicTo(46 * s, 4 * s, 42 * s, 8 * s, 50 * s, 14 * s)
          ..cubicTo(58 * s, 8 * s, 54 * s, 4 * s, 50 * s, 8 * s)
          ..close();
        canvas.drawPath(hp, fill);
        break;

      case 'wudu_2':
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 20),
            hipPos: p(50, 58),
            armR: [p(50, 38), p(60, 42), p(68, 48)],
            armL: [p(50, 38), p(40, 42), p(32, 48)],
            legR: [p(50, 58), p(46, 76), p(44, 92)],
            legL: [p(50, 58), p(54, 76), p(56, 92)]);
        drop(p(68, 42), 4 * s, fill);
        drop(p(32, 42), 4 * s, fill);
        drop(p(60, 36), 3 * s, softFill);
        drop(p(40, 36), 3 * s, softFill);
        break;

      case 'wudu_3':
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 26),
            hipPos: p(50, 62),
            armR: [p(50, 42), p(58, 46), p(60, 40)],
            armL: [p(50, 42), p(42, 46), p(40, 40)],
            legR: [p(50, 62), p(46, 78), p(44, 92)],
            legL: [p(50, 62), p(54, 78), p(56, 92)]);
        drop(p(50, 6), 5 * s, softFill);
        drop(p(50, 14), 4 * s, fill);
        break;

      case 'wudu_4':
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 26),
            hipPos: p(50, 62),
            armR: [p(50, 42), p(60, 42), p(64, 38)],
            armL: [p(50, 42), p(40, 42), p(36, 38)],
            legR: [p(50, 62), p(46, 78), p(44, 92)],
            legL: [p(50, 62), p(54, 78), p(56, 92)]);
        drop(p(50, 8), 5 * s, softFill);
        drop(p(50, 18), 4 * s, fill);
        break;

      case 'wudu_5':
        // Face washing: water streams on both sides of head
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 24),
            hipPos: p(50, 60),
            armR: [p(50, 40), p(58, 40), p(63, 34)],
            armL: [p(50, 40), p(42, 40), p(37, 34)],
            legR: [p(50, 60), p(46, 78), p(44, 92)],
            legL: [p(50, 60), p(54, 78), p(56, 92)]);
        drop(p(32, 22), 4 * s, fill);
        drop(p(68, 22), 4 * s, fill);
        drop(p(36, 30), 3 * s, softFill);
        drop(p(64, 30), 3 * s, softFill);
        break;

      case 'wudu_6':
        // Arm washing: one arm extended to the side
        _drawFigure(canvas, s, main, fill,
            headPos: p(46, 22),
            hipPos: p(46, 60),
            armR: [p(46, 38), p(60, 40), p(74, 38)],
            armL: [p(46, 38), p(38, 46), p(40, 54)],
            legR: [p(46, 60), p(42, 78), p(40, 92)],
            legL: [p(46, 60), p(50, 78), p(52, 92)]);
        drop(p(66, 32), 3.5 * s, fill);
        drop(p(72, 44), 3 * s, softFill);
        drop(p(58, 30), 3 * s, softFill);
        break;

      case 'wudu_7':
        // Hands on head
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 26),
            hipPos: p(50, 62),
            armR: [p(50, 42), p(58, 34), p(53, 20)],
            armL: [p(50, 42), p(42, 34), p(47, 20)],
            legR: [p(50, 62), p(46, 78), p(44, 92)],
            legL: [p(50, 62), p(54, 78), p(56, 92)]);
        drop(p(36, 18), 3 * s, softFill);
        drop(p(64, 18), 3 * s, softFill);
        break;

      case 'wudu_8':
        // Foot washing: one leg raised forward
        _drawFigure(canvas, s, main, fill,
            headPos: p(44, 20),
            hipPos: p(44, 58),
            armR: [p(44, 36), p(56, 44), p(66, 58)],
            armL: [p(44, 36), p(34, 42), p(30, 52)],
            legR: [p(44, 58), p(60, 70), p(74, 76)],
            legL: [p(44, 58), p(42, 76), p(40, 92)]);
        drop(p(70, 68), 3.5 * s, fill);
        drop(p(76, 62), 3 * s, softFill);
        break;

      // ─────────────── SALAH ───────────────
      case 'salah_1':
        // Facing Qiblah
        _drawFigure(canvas, s, main, fill,
            headPos: p(40, 22),
            hipPos: p(40, 60),
            armR: [p(40, 38), p(48, 48), p(46, 58)],
            armL: [p(40, 38), p(32, 48), p(34, 58)],
            legR: [p(40, 60), p(36, 78), p(34, 92)],
            legL: [p(40, 60), p(44, 78), p(46, 92)]);
        // Kaaba cube
        final k = Rect.fromLTWH(70 * s, 44 * s, 22 * s, 22 * s);
        canvas.drawRect(k, softFill);
        canvas.drawRect(k, soft);
        // strip
        canvas.drawLine(Offset(70 * s, 52 * s), Offset(92 * s, 52 * s), soft);
        break;

      case 'salah_2':
        // Takbir: hands raised to ears
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 22),
            hipPos: p(50, 60),
            armR: [p(50, 38), p(62, 28), p(58, 14)],
            armL: [p(50, 38), p(38, 28), p(42, 14)],
            legR: [p(50, 60), p(46, 78), p(44, 92)],
            legL: [p(50, 60), p(54, 78), p(56, 92)]);
        break;

      case 'salah_3':
        // Qiyam: arms folded on chest
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 22),
            hipPos: p(50, 60),
            armR: [p(50, 38), p(58, 44), p(50, 50)],
            armL: [p(50, 38), p(42, 44), p(50, 50)],
            legR: [p(50, 60), p(46, 78), p(44, 92)],
            legL: [p(50, 60), p(54, 78), p(56, 92)]);
        break;

      case 'salah_4':
        // Ruku: bent forward
        mat(50, 94);
        // Head at (72, 52) - bent over
        head(p(74, 52));
        // Torso bent: hip at (46, 60) to neck at (66, 50)
        canvas.drawLine(p(46, 60), p(66, 50), main);
        // Arms from neck down to knees
        canvas.drawLine(p(64, 52), p(58, 68), main);
        canvas.drawLine(p(58, 68), p(48, 68), main);
        // Legs
        canvas.drawLine(p(46, 60), p(42, 78), main);
        canvas.drawLine(p(42, 78), p(40, 92), main);
        canvas.drawLine(p(46, 60), p(52, 78), main);
        canvas.drawLine(p(52, 78), p(56, 92), main);
        break;

      case 'salah_5':
        // I'tidal: standing upright, arms at side
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 22),
            hipPos: p(50, 60),
            armR: [p(50, 38), p(58, 48), p(60, 60)],
            armL: [p(50, 38), p(42, 48), p(40, 60)],
            legR: [p(50, 60), p(46, 78), p(44, 92)],
            legL: [p(50, 60), p(54, 78), p(56, 92)]);
        break;

      case 'salah_6':
        // Sujud: prostrated on ground
        mat(50, 86);
        // Head low, near ground
        head(p(30, 74));
        // Body line from head to hips (low flat)
        canvas.drawLine(p(38, 78), p(64, 74), main);
        // Hips up to knee point
        canvas.drawLine(p(64, 74), p(72, 82), main);
        // Legs from knee to ground
        canvas.drawLine(p(72, 82), p(66, 88), main);
        canvas.drawLine(p(72, 82), p(82, 88), main);
        // Arms reaching forward
        canvas.drawLine(p(42, 78), p(34, 86), main);
        canvas.drawLine(p(46, 78), p(50, 86), main);
        break;

      case 'salah_7':
        // Tashahhud / Salaam: kneeling, head turned
        mat(50, 92);
        // Head slightly turned to side
        head(p(50, 30));
        // Torso
        canvas.drawLine(p(50, 38), p(50, 62), main);
        // Arms on thighs
        canvas.drawLine(p(50, 44), p(60, 60), main);
        canvas.drawLine(p(50, 44), p(40, 60), main);
        // Kneeling legs (folded)
        canvas.drawLine(p(50, 62), p(66, 76), main);
        canvas.drawLine(p(66, 76), p(58, 88), main);
        canvas.drawLine(p(50, 62), p(40, 78), main);
        canvas.drawLine(p(40, 78), p(48, 88), main);
        break;

      // Default: person with a book
      default:
        _drawFigure(canvas, s, main, fill,
            headPos: p(50, 24),
            hipPos: p(50, 62),
            armR: [p(50, 40), p(60, 48), p(66, 56)],
            armL: [p(50, 40), p(40, 48), p(34, 56)],
            legR: [p(50, 62), p(46, 78), p(44, 92)],
            legL: [p(50, 62), p(54, 78), p(56, 92)]);
        // small book
        final b = Rect.fromLTWH(62 * s, 52 * s, 22 * s, 16 * s);
        canvas.drawRRect(
            RRect.fromRectAndRadius(b, Radius.circular(2 * s)), softFill);
        canvas.drawRRect(
            RRect.fromRectAndRadius(b, Radius.circular(2 * s)), soft);
    }
  }

  void _drawFigure(
    Canvas canvas,
    double s,
    Paint stroke,
    Paint fill, {
    required Offset headPos,
    required Offset hipPos,
    required List<Offset> armR,
    required List<Offset> armL,
    required List<Offset> legR,
    required List<Offset> legL,
  }) {
    // Head
    canvas.drawCircle(headPos, 8 * s, fill);
    // Neck to hip (torso)
    final neck = Offset(headPos.dx, headPos.dy + 9 * s);
    canvas.drawLine(neck, hipPos, stroke);
    // Arms
    canvas.drawPath(
      Path()
        ..moveTo(armR[0].dx, armR[0].dy)
        ..lineTo(armR[1].dx, armR[1].dy)
        ..lineTo(armR[2].dx, armR[2].dy),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(armL[0].dx, armL[0].dy)
        ..lineTo(armL[1].dx, armL[1].dy)
        ..lineTo(armL[2].dx, armL[2].dy),
      stroke,
    );
    // Legs
    canvas.drawPath(
      Path()
        ..moveTo(legR[0].dx, legR[0].dy)
        ..lineTo(legR[1].dx, legR[1].dy)
        ..lineTo(legR[2].dx, legR[2].dy),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(legL[0].dx, legL[0].dy)
        ..lineTo(legL[1].dx, legL[1].dy)
        ..lineTo(legL[2].dx, legL[2].dy),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _PosePainter old) =>
      old.poseKey != poseKey || old.color != color;
}