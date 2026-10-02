import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../data/countries_data.dart';
import '../models/country_data.dart';
import '../widgets/islamic_pattern_background.dart';
import '../services/theme_service.dart';
import 'prayer_times_screen.dart';
import '../data/geo_translations.dart';
import '../app_theme.dart';

class RegionSelectionScreen extends StatefulWidget {
  final CountryData country;
  const RegionSelectionScreen({super.key, required this.country});

  @override
  State<RegionSelectionScreen> createState() => _RegionSelectionScreenState();
}

class _RegionSelectionScreenState extends State<RegionSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    // If this country has no hardcoded regions, skip straight to prayer
    // times using the capital city fallback.
    if (widget.country.regions.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final capital =
            countryCapitals[widget.country.name] ?? widget.country.name;
        Navigator.of(context).pushReplacement(
          _buildRoute(PrayerTimesScreen(
            country: widget.country,
            region: capital,
          )),
        );
      });
    }
  }

  Route _buildRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.country.regions.isEmpty) {
      // Brief loading state while we redirect to prayer times with capital city.
      return const Scaffold(
        body: IslamicPatternBackground(
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          ),
        ),
      );
    }

    final langCode = Localizations.localeOf(context).languageCode;
    final isArabic = langCode == 'ar';
    final isFrench = langCode == 'fr';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    // ── TOP BAR + HERO (entrance animation) ──
                    FadeTransition(
                      opacity: _headerController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.10),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _headerController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: Column(
                          children: [
                            _buildTopBar(context, themeService),
                            _buildHeroSection(
                              context,
                              isArabic,
                              isFrench,
                              themeService,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── INFO BANNER ──────────────────────
                    _buildInfoBanner(context, isArabic, isFrench),

                    // ── SECTION HEADER ───────────────────
                    _buildSectionHeader(context, isArabic, isFrench),

                    // ── REGION GRID ──────────────────────
                    _buildRegionGrid(context, themeService),

                    const SizedBox(height: 26),

                    // ── FOOTER ───────────────────────────
                    _buildFooter(context, isArabic, isFrench),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // TOP BAR
  // ─────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context, ThemeService themeService) {
    const gold = Color(0xFFD4AF37);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 20, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: gold,
              size: 22,
            ),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            splashRadius: 22,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              GeoTranslations.translate(context, widget.country.name),
              overflow: TextOverflow.ellipsis,
              style: themeService.getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: gold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HERO — big flag medallion + country name + subtitle
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeroSection(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    ThemeService themeService,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    final String heroTitle = isArabic
        ? 'اختر منطقتك'
        : (isFrench ? 'Choisissez votre région' : 'Choose your region');

    final String heroSubtitle = isArabic
        ? 'حدّد المنطقة التي تقع فيها للحصول على مواقيت صلاة دقيقة حسب إحداثيات موقعك.'
        : (isFrench
            ? 'Indiquez votre région pour obtenir des horaires de prière précis selon vos coordonnées.'
            : 'Select the region you are in to get accurate prayer times based on your location coordinates.');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Big decorative medallion with flag emoji
          SizedBox(
            width: 168,
            height: 168,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft glow
                Container(
                  width: 168,
                  height: 168,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        gold.withValues(alpha: 0.30),
                        gold.withValues(alpha: 0.0),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
                // Outer ring
                Container(
                  width: 148,
                  height: 148,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: gold.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                ),
                // Middle ring
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: gold.withValues(alpha: 0.55),
                      width: 1.5,
                    ),
                  ),
                ),
                // Inner medallion with flag emoji
                Container(
                  width: 96,
                  height: 96,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        gold.withValues(alpha: 0.28),
                        gold.withValues(alpha: 0.06),
                      ],
                    ),
                    border: Border.all(
                      color: gold.withValues(alpha: 0.85),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gold.withValues(alpha: 0.28),
                        blurRadius: 22,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.country.flagEmoji,
                    style: const TextStyle(fontSize: 46),
                  ),
                ),
                // Accents
                Positioned(
                  top: 10,
                  right: 18,
                  child: Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: gold.withValues(alpha: 0.9),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Icon(
                    Icons.star_rounded,
                    size: 11,
                    color: gold.withValues(alpha: 0.75),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 20,
                  child: Icon(
                    Icons.nightlight_round,
                    size: 13,
                    color: gold.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Country name in large gold
          Text(
            GeoTranslations.translate(context, widget.country.name),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: gold,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),

          // Hero title
          Text(
            heroTitle,
            textAlign: TextAlign.center,
            style: themeService.getTextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: gold,
            ),
          ),
          const SizedBox(height: 8),

          // Hero subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              heroSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onBg.withValues(alpha: 0.68),
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // INFO BANNER — explains why region matters
  // ─────────────────────────────────────────────────────────────
  Widget _buildInfoBanner(
    BuildContext context,
    bool isArabic,
    bool isFrench,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    final String heading = isArabic
        ? 'لماذا نطلب تحديد المنطقة؟'
        : (isFrench
            ? 'Pourquoi choisir une région ?'
            : 'Why choose a region?');

    final String body = isArabic
        ? 'تعتمد دقة مواقيت الصلاة على الموقع الجغرافي. اختيار المنطقة الصحيحة يضمن لك مواقيت دقيقة وفق خط الطول والعرض الخاص بمدينتك.'
        : (isFrench
            ? 'La précision des horaires de prière dépend de la situation géographique. Choisir la bonne région vous garantit des horaires précis selon les coordonnées de votre ville.'
            : 'Prayer time accuracy depends on your geographic location. Choosing the right region ensures precise timings based on your city\'s latitude and longitude.');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gold.withValues(alpha: 0.10),
              gold.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: gold.withValues(alpha: 0.30),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gold.withValues(alpha: 0.18),
                border: Border.all(
                  color: gold.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: gold,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: TextStyle(
                      color: onBg.withValues(alpha: 0.72),
                      fontSize: 12.5,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
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

  // ─────────────────────────────────────────────────────────────
  // SECTION HEADER — title + count chip + subtitle
  // ─────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(
    BuildContext context,
    bool isArabic,
    bool isFrench,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);
    final count = widget.country.regions.length;

    final String title = isArabic
        ? 'المناطق المتاحة'
        : (isFrench ? 'Régions disponibles' : 'Available regions');

    final String subtitle = isArabic
        ? '$count منطقة متاحة — اختر الأقرب إليك للحصول على أدق المواقيت.'
        : (isFrench
            ? '$count régions disponibles — choisissez la plus proche pour des horaires précis.'
            : '$count regions available — pick the one closest to you for the most accurate times.');

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      gold.withValues(alpha: 0.28),
                      gold.withValues(alpha: 0.06),
                    ],
                  ),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.45),
                    width: 1.2,
                  ),
                ),
                child: const Icon(Icons.map_rounded, color: gold, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: gold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 42, right: 4),
            child: Text(
              subtitle,
              style: TextStyle(
                color: onBg.withValues(alpha: 0.6),
                fontSize: 12,
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // REGION GRID — responsive Wrap with staggered entrance
  // ─────────────────────────────────────────────────────────────
  Widget _buildRegionGrid(BuildContext context, ThemeService themeService) {
    final regions = widget.country.regions;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: List.generate(regions.length, (index) {
          final region = regions[index];
          return SizedBox(
            width: 260,
            height: 110,
            child: TweenAnimationBuilder<double>(
              duration:
                  Duration(milliseconds: 220 + (index * 20).clamp(0, 380)),
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: child,
                  ),
                );
              },
              child: _RegionGlassCard(
                label: region,
                onTap: () {
                  Navigator.of(context).push(
                    _buildRoute(PrayerTimesScreen(
                      country: widget.country,
                      region: region,
                    )),
                  );
                },
                themeService: themeService,
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // FOOTER
  // ─────────────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext context, bool isArabic, bool isFrench) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _gradientLine()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.favorite_rounded,
                  size: 14,
                  color: gold.withValues(alpha: 0.8),
                ),
              ),
              Expanded(child: _gradientLine()),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isArabic
                ? 'نسأل الله أن يتقبل منك صلاتك'
                : (isFrench
                    ? 'Qu\'Allah accepte votre prière'
                    : 'May Allah accept your prayer'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: gold,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isArabic
                ? 'اختر منطقتك لتبدأ رحلتك مع مواقيت الصلاة بدقة'
                : (isFrench
                    ? 'Choisissez votre région pour commencer votre parcours de prière'
                    : 'Choose your region to begin your prayer journey'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: onBg.withValues(alpha: 0.5),
              fontSize: 11,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientLine() {
    return Container(
      height: 1.2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD4AF37).withValues(alpha: 0),
            const Color(0xFFD4AF37).withValues(alpha: 0.45),
            const Color(0xFFD4AF37).withValues(alpha: 0),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

// ── FROSTED GLASS REGION CARD ──────────────────────────────────
class _RegionGlassCard extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final ThemeService themeService;

  const _RegionGlassCard({
    required this.label,
    required this.onTap,
    required this.themeService,
  });

  @override
  State<_RegionGlassCard> createState() => _RegionGlassCardState();
}

class _RegionGlassCardState extends State<_RegionGlassCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || _isPressed;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const gold = Color(0xFFD4AF37);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: isActive ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isActive
                      ? (isDark
                          ? const Color(0xFF144D32).withValues(alpha: 0.85)
                          : const Color(0xFFE8F3EE).withValues(alpha: 0.85))
                      : (isDark
                          ? const Color(0xFF0B3D2E).withValues(alpha: 0.65)
                          : const Color(0xFFF0F8F4).withValues(alpha: 0.65)),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isActive
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.2),
                    width: isActive ? 2 : 1,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Location pin medallion
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: gold.withValues(alpha: isActive ? 0.25 : 0.15),
                        border: Border.all(
                          color: gold.withValues(alpha: isActive ? 0.6 : 0.35),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: gold,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Region label
                    Expanded(
                      child: Text(
                        GeoTranslations.translate(context, widget.label),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: widget.themeService.getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Theme.of(context).colorScheme.secondary
                              : (isDark
                                  ? Theme.of(context).colorScheme.secondary
                                  : const Color(0xFF1B5E3F)),
                        ),
                      ),
                    ),
                    // Chevron
                    Icon(
                      Icons.chevron_right_rounded,
                      color: gold.withValues(alpha: isActive ? 1.0 : 0.5),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}