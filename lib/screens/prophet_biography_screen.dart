import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../data/prophet_biography_data.dart';

class ProphetBiographyScreen extends StatefulWidget {
  const ProphetBiographyScreen({super.key});

  @override
  State<ProphetBiographyScreen> createState() => _ProphetBiographyScreenState();
}

class _ProphetBiographyScreenState extends State<ProphetBiographyScreen> {
  late ProphetBiographyService service;
  late List<ProphetBiography> allProphets;
  late List<ProphetBiography> filteredProphets;
  TextEditingController searchController = TextEditingController();
  ProphetBiography? selectedProphet;

  @override
  void initState() {
    super.initState();
    service = ProphetBiographyService();
    allProphets = [];
    filteredProphets = [];
    searchController.addListener(_filterProphets);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch the correct language list whenever the screen builds or language changes
    final langCode = Localizations.localeOf(context).languageCode;
    allProphets = service.getAllProphets(langCode);
    _filterProphets();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterProphets() {
    final langCode = Localizations.localeOf(context).languageCode;
    setState(() {
      if (searchController.text.isEmpty) {
        filteredProphets = allProphets;
      } else {
        filteredProphets = service.searchProphets(searchController.text, langCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedProphet != null) {
      return _buildDetailScreen(context);
    }

    return _buildListScreen(context);
  }

  Widget _buildListScreen(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';

        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            isArabic ? 'سيرة الأنبياء' : 'Prophet Biographies',
                            textAlign: TextAlign.center,
                            style: themeService.getTextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                        const SizedBox(width: 56),
                      ],
                    ),
                  ),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: TextField(
                      controller: searchController,
                      style: themeService.getTextStyle(
                        fontSize: 16,
                        color: AppTheme.getOnBackgroundColor(context),
                      ),
                      decoration: InputDecoration(
                        hintText: isArabic ? 'ابحث عن نبي...' : 'Search for a prophet...',
                        hintStyle: themeService.getTextStyle(
                          fontSize: 14,
                          color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFD4AF37),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Prophets List
                  Expanded(
                    child: filteredProphets.isEmpty
                        ? Center(
                            child: Text(
                              isArabic ? 'لا توجد نتائج' : 'No results found',
                              style: themeService.getTextStyle(
                                fontSize: 16,
                                color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            itemCount: filteredProphets.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ProphetCard(
                                  prophet: filteredProphets[index],
                                  onTap: () => setState(
                                    () => selectedProphet = filteredProphets[index],
                                  ),
                                  themeService: themeService,
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

  Widget _buildDetailScreen(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';
        final prophet = selectedProphet!;

        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header
                  SliverAppBar(
                    leading: IconButton(
                      icon: Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back),
                      onPressed: () => setState(() => selectedProphet = null),
                    ),
                    title: Text(
                      prophet.name,
                      style: themeService.getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD4AF37),
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.8),
                    pinned: true,
                  ),

                  // Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Prophet Card Header
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withValues(alpha: 0.5),
                              border: Border.all(
                                color: const Color(0xFFD4AF37)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      prophet.arabicName,
                                      style: themeService.getTextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFD4AF37),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        color: const Color(0xFFD4AF37)
                                            .withValues(alpha: 0.2),
                                      ),
                                      child: Text(
                                        prophet.title,
                                        style: themeService.getTextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFD4AF37),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  prophet.speciality,
                                  style: themeService.getTextStyle(
                                    fontSize: 14,
                                    color: AppTheme.getOnBackgroundColor(
                                            context)
                                        .withValues(alpha: 0.8),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Info Grid
                          GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              mainAxisExtent: 85,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _InfoCard(
                                title: isArabic ? 'الفترة الزمنية' : 'Lifespan',
                                value: prophet.lifespan,
                                themeService: themeService,
                              ),
                              _InfoCard(
                                title: isArabic ? 'مكان المولد' : 'Birth Place',
                                value: prophet.birthPlace,
                                themeService: themeService,
                              ),
                              _InfoCard(
                                title: isArabic ? 'مكان الوفاة' : 'Death Place',
                                value: prophet.deathPlace,
                                themeService: themeService,
                              ),
                              _InfoCard(
                                title: isArabic
                                    ? 'الذكر في القرآن'
                                    : 'Mentioned in',
                                value: isArabic
                                    ? '${prophet.mentionedInSurahs} سورة'
                                    : '${prophet.mentionedInSurahs} Surahs',
                                themeService: themeService,
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Biography
                          Text(
                            isArabic ? 'السيرة' : 'Biography',
                            style: themeService.getTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            prophet.description,
                            style: themeService.getTextStyle(
                              fontSize: 14,
                              height: 1.8,
                              color: AppTheme.getOnBackgroundColor(context),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Key Achievements
                          Text(
                            isArabic ? 'الإنجازات الرئيسية' : 'Key Achievements',
                            style: themeService.getTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...prophet.keyAchievements.map((achievement) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFFD4AF37),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      achievement,
                                      style: themeService.getTextStyle(
                                        fontSize: 14,
                                        height: 1.6,
                                        color: AppTheme.getOnBackgroundColor(
                                            context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 32),

                          // Quranic Mentions
                          Text(
                            isArabic ? 'الآيات القرآنية' : 'Quranic Mentions',
                            style: themeService.getTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...prophet.quranicMentions.map((mention) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withValues(alpha: 0.3),
                                  border: Border.all(
                                    color: const Color(0xFFD4AF37)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${mention.surahName} (${mention.surahNumber}:${mention.verseNumber})',
                                      style: themeService.getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFD4AF37),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      mention.verseText,
                                      style: themeService.getTextStyle(
                                        fontSize: 14,
                                        height: 1.8,
                                        color: AppTheme.getOnBackgroundColor(
                                            context),
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      mention.verseTranslation,
                                      style: themeService.getTextStyle(
                                        fontSize: 13,
                                        height: 1.6,
                                        fontStyle: FontStyle.italic,
                                        color: AppTheme.getOnBackgroundColor(
                                                context)
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 24),
                        ],
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

class _ProphetCard extends StatefulWidget {
  final ProphetBiography prophet;
  final VoidCallback onTap;
  final ThemeService themeService;

  const _ProphetCard({
    required this.prophet,
    required this.onTap,
    required this.themeService,
  });

  @override
  State<_ProphetCard> createState() => _ProphetCardState();
}

class _ProphetCardState extends State<_ProphetCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _isHovered
                  ? Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.7)
                  : Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.4),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(
                  alpha: _isHovered ? 0.8 : 0.3,
                ),
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: const Color(0xFFD4AF37)
                        .withValues(alpha: 0.15),
                    blurRadius: 20,
                  ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFD4AF37)
                            .withValues(alpha: 0.3),
                        const Color(0xFFD4AF37)
                            .withValues(alpha: 0.1),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.prophet.arabicName.isNotEmpty
                          ? widget.prophet.arabicName[0]
                          : widget.prophet.name[0],
                      style: widget.themeService.getTextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD4AF37),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prophet.name,
                        style: widget.themeService.getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.prophet.title,
                        style: widget.themeService.getTextStyle(
                          fontSize: 12,
                          color: AppTheme.getOnBackgroundColor(context)
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.prophet.speciality,
                        style: widget.themeService.getTextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.getOnBackgroundColor(context)
                              .withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  isArabic
                      ? Icons.arrow_back_rounded
                      : Icons.arrow_forward_rounded,
                  color: const Color(0xFFD4AF37),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final ThemeService themeService;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context)
            .colorScheme
            .surface
            .withValues(alpha: 0.3),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: themeService.getTextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: themeService.getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.getOnBackgroundColor(context),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}