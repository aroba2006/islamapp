import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../data/countries_data.dart';
import '../models/country_data.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import '../app_theme.dart';
import 'region_selection_screen.dart';
import 'prayer_times_screen.dart';
import '../data/geo_translations.dart';
import '../services/theme_service.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen>
    with SingleTickerProviderStateMixin {
  late List<CountryData> _filtered;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _headerController;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _filtered = countries;
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = countries;
      } else {
        _filtered = countries.where((c) {
          final translatedName =
              GeoTranslations.translate(context, c.name).toLowerCase();
          final englishName = c.name.toLowerCase();
          return translatedName.contains(query) || englishName.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  void _onCountryTap(CountryData country) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            RegionSelectionScreen(country: country),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      ),
    );
  }

  Future<void> _detectLocation(String lang) async {
    setState(() => _isDetecting = true);

    try {
      String detectedCountry = 'Unknown';
      String detectedCity = 'Unknown';

      if (kIsWeb) {
        final response =
            await http.get(Uri.parse('https://get.geojs.io/v1/ip/geo.json'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          detectedCountry = data['country'] ?? 'Unknown';
          detectedCity = data['city'] ?? 'Unknown';
        } else {
          throw Exception(lang == 'ar'
              ? 'فشل تحديد الموقع على المتصفح'
              : 'Web location failed.');
        }
      } else {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception(lang == 'ar'
              ? 'خدمات الموقع معطلة'
              : 'Location services are disabled.');
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception(lang == 'ar'
                ? 'تم رفض إذن الموقع'
                : 'Location permissions denied.');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          throw Exception(lang == 'ar'
              ? 'أذونات الموقع مرفوضة نهائياً'
              : 'Location permissions are permanently denied.');
        }

        Position position = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high),
        );
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isEmpty) throw Exception('Location unreadable.');

        Placemark place = placemarks.first;
        detectedCountry = place.country ?? 'Unknown';
        detectedCity = place.locality ?? place.administrativeArea ?? 'Unknown';
      }

      CountryData matchedCountry = countries.firstWhere(
        (c) => c.name.toLowerCase() == detectedCountry.toLowerCase(),
        orElse: () => CountryData(
            name: detectedCountry, flagEmoji: '📍', regions: []),
      );

      if (!mounted) return;

      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => PrayerTimesScreen(
              country: matchedCountry, region: detectedCity),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString().replaceAll('Exception: ', ''),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      if (mounted) {
        setState(() => _isDetecting = false);
      }
    }
  }

  // ═════════════════════════════════════════════════════════════
  // BUILD
  // ═════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── HEADER BLOCK (animated as a unit) ────────
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _headerController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.15),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _headerController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: Column(
                          children: [
                            _buildTopBar(context, l10n!, themeService),
                            _buildHeroSection(
                              context,
                              isArabic,
                              isFrench,
                              themeService,
                            ),
                            _buildInfoBanner(context, isArabic, isFrench),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── SEARCH + AUTO-DETECT ─────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          _buildSearchField(
                              context, l10n!, isArabic, themeService),
                          const SizedBox(height: 14),
                          _buildAutoDetectButton(lang, themeService),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),

                  // ── SECTION HEADER ───────────────────────────
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                        context, isArabic, isFrench, themeService),
                  ),

                  // ── LIST OR EMPTY ────────────────────────────
                  if (_filtered.isEmpty)
                    SliverToBoxAdapter(
                      child: _buildEmptyState(context, l10n!, themeService),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final country = _filtered[index];
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                  milliseconds:
                                      250 + (index * 18).clamp(0, 400)),
                              tween: Tween(begin: 0, end: 1),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset((1 - value) * 24, 0),
                                  child: child,
                                ),
                              ),
                              child: _CountryTile(
                                country: country,
                                isArabic: isArabic,
                                onTap: () => _onCountryTap(country),
                                themeService: themeService,
                              ),
                            );
                          },
                          childCount: _filtered.length,
                        ),
                      ),
                    ),

                  // ── FOOTER ───────────────────────────────────
                  SliverToBoxAdapter(
                    child: _buildFooter(context, isArabic, isFrench),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ═════════════════════════════════════════════════════════════
  // TOP BAR
  // ═════════════════════════════════════════════════════════════
  Widget _buildTopBar(
      BuildContext context, AppLocalizations l10n, ThemeService themeService) {
    const gold = Color(0xFFD4AF37);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 20, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: gold,
              size: 22,
            ),
            onPressed: () => Navigator.pop(context),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            splashRadius: 22,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              l10n.selectCountry,
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

  // ═════════════════════════════════════════════════════════════
  // HERO — big globe medallion + title + subtitle
  // ═════════════════════════════════════════════════════════════
  Widget _buildHeroSection(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    ThemeService themeService,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    final String heroTitle = isArabic
        ? 'اختر دولتك'
        : (isFrench ? 'Choisissez votre pays' : 'Choose your country');

    final String heroSubtitle = isArabic
        ? 'حدّد الدولة التي تقع فيها للحصول على مواقيت صلاة دقيقة، ومعرفة اتجاه القبلة بدقة متناهية من موقعك.'
        : (isFrench
            ? 'Indiquez votre pays pour obtenir des horaires de prière précis et une direction de Qibla exacte depuis votre position.'
            : 'Select the country you are in to get accurate prayer times and a precise Qibla direction from your location.');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Big globe medallion
          SizedBox(
            width: 168,
            height: 168,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow
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
                // Inner medallion with globe
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
                  child: const Icon(
                    Icons.public_rounded,
                    color: gold,
                    size: 46,
                  ),
                ),
                // Decorative accents
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

          Text(
            heroTitle,
            textAlign: TextAlign.center,
            style: themeService.getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: gold,
            ),
          ),
          const SizedBox(height: 8),

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

  // ═════════════════════════════════════════════════════════════
  // INFO BANNER — why pick a country
  // ═════════════════════════════════════════════════════════════
  Widget _buildInfoBanner(
    BuildContext context,
    bool isArabic,
    bool isFrench,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    final String heading = isArabic
        ? 'لماذا نطلب تحديد الدولة؟'
        : (isFrench
            ? 'Pourquoi choisir un pays ?'
            : 'Why choose a country?');

    final String body = isArabic
        ? 'يختلف وقت الصلاة من دولة إلى أخرى حسب خط الطول والعرض. اختيار الدولة الصحيحة يضمن لك مواقيت دقيقة تماماً لموقعك — ويمكنك لاحقاً تحديد المدينة بدقة أكبر.'
        : (isFrench
            ? 'Les horaires de prière varient selon la latitude et la longitude. Choisir le bon pays vous garantit des horaires précis pour votre position — vous pourrez ensuite affiner par ville.'
            : 'Prayer times differ from one country to another based on latitude and longitude. Choosing the right country guarantees timings accurate to your exact position — and you can later narrow down by city.');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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

  // ═════════════════════════════════════════════════════════════
  // SEARCH FIELD
  // ═════════════════════════════════════════════════════════════
  Widget _buildSearchField(
    BuildContext context,
    AppLocalizations l10n,
    bool isArabic,
    ThemeService themeService,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppTheme.getOnBackgroundColor(context);
    final gold = Theme.of(context).colorScheme.secondary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: TextField(
          controller: _searchController,
          style: themeService.getTextStyle(fontSize: 16, color: textColor),
          decoration: InputDecoration(
            hintText: l10n.searchCountries,
            hintStyle: themeService.getTextStyle(
              fontSize: 15,
              color: textColor.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(Icons.search, color: gold),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: gold.withValues(alpha: 0.8),
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  )
                : null,
            filled: true,
            fillColor: isDark
                ? const Color(0xFF0B3D2E).withValues(alpha: 0.65)
                : const Color(0xFFF0F8F4).withValues(alpha: 0.65),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: gold, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // AUTO-DETECT BUTTON
  // ═════════════════════════════════════════════════════════════
  Widget _buildAutoDetectButton(String lang, ThemeService themeService) {
    final gold = Theme.of(context).colorScheme.secondary;

    String btnText = 'Auto-Detect Location';
    if (lang == 'ar') btnText = 'تحديد موقعي تلقائياً';
    if (lang == 'fr') btnText = 'Détecter ma position';

    return GestureDetector(
      onTap: _isDetecting ? null : () => _detectLocation(lang),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gold.withValues(alpha: 0.18),
              gold.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: gold.withValues(alpha: 0.5), width: 1.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isDetecting)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: gold,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(Icons.my_location_rounded, color: gold),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                _isDetecting
                    ? (lang == 'ar'
                        ? 'جاري تحديد موقعك...'
                        : (lang == 'fr'
                            ? 'Détection en cours...'
                            : 'Detecting your location...'))
                    : btnText,
                textAlign: TextAlign.center,
                style: themeService.getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: gold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // SECTION HEADER — title + count chip + subtitle
  // ═════════════════════════════════════════════════════════════
  Widget _buildSectionHeader(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    ThemeService themeService,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    final int total = countries.length;
    final int showing = _filtered.length;
    final bool isFiltering = _searchController.text.trim().isNotEmpty;

    final String title = isArabic
        ? 'الدول المتاحة'
        : (isFrench ? 'Pays disponibles' : 'Available countries');

    final String subtitle = isFiltering
        ? (isArabic
            ? 'عرض $showing من أصل $total دولة — استمر في الكتابة لتضييق النتائج.'
            : (isFrench
                ? '$showing sur $total pays affichés — continuez à taper pour affiner.'
                : 'Showing $showing of $total countries — keep typing to narrow down.'))
        : (isArabic
            ? '$total دولة متاحة — ابحث أو اختر من القائمة أدناه للبدء.'
            : (isFrench
                ? '$total pays disponibles — recherchez ou choisissez dans la liste ci-dessous.'
                : '$total countries available — search or pick from the list below to begin.'));

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 8),
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
                child: const Icon(Icons.flag_rounded, color: gold, size: 18),
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
                  isFiltering ? '$showing / $total' : '$total',
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

  // ═════════════════════════════════════════════════════════════
  // EMPTY STATE
  // ═════════════════════════════════════════════════════════════
  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    ThemeService themeService,
  ) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gold.withValues(alpha: 0.12),
              border: Border.all(
                color: gold.withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: gold,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noCountriesFound,
            textAlign: TextAlign.center,
            style: themeService.getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: gold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'جرّب البحث باسم آخر أو امسح مربع البحث لعرض كل الدول.'
                : (Localizations.localeOf(context).languageCode == 'fr'
                    ? 'Essayez un autre nom ou effacez la recherche pour voir tous les pays.'
                    : 'Try another name or clear the search to see all countries.'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: onBg.withValues(alpha: 0.6),
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              FocusScope.of(context).unfocus();
            },
            icon: const Icon(Icons.refresh_rounded, color: gold, size: 18),
            label: Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'مسح البحث'
                  : (Localizations.localeOf(context).languageCode == 'fr'
                      ? 'Effacer la recherche'
                      : 'Clear search'),
              style: const TextStyle(color: gold, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // FOOTER
  // ═════════════════════════════════════════════════════════════
  Widget _buildFooter(
      BuildContext context, bool isArabic, bool isFrench) {
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
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
                ? 'اختر دولتك، ثم مدينتك، لنعرض لك المواقيت بدقة حسب موقعك'
                : (isFrench
                    ? 'Choisissez votre pays puis votre ville pour des horaires précis'
                    : 'Choose your country, then your city, for precise timings'),
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

// ═══════════════════════════════════════════════════════════════
// COUNTRY TILE — bigger flag medallion + name + count chip + chevron
// ═══════════════════════════════════════════════════════════════
class _CountryTile extends StatefulWidget {
  final CountryData country;
  final bool isArabic;
  final VoidCallback onTap;
  final ThemeService themeService;

  const _CountryTile({
    required this.country,
    required this.isArabic,
    required this.onTap,
    required this.themeService,
  });

  @override
  State<_CountryTile> createState() => _CountryTileState();
}

class _CountryTileState extends State<_CountryTile> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || _isPressed;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const gold = Color(0xFFD4AF37);
    final onBg = AppTheme.getOnBackgroundColor(context);
    final regionCount = widget.country.regions.length;

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
          scale: isActive ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: gold.withValues(alpha: 0.18),
                              blurRadius: 14,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Big flag medallion
                      Container(
                        width: 54,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              gold.withValues(alpha: isActive ? 0.28 : 0.16),
                              gold.withValues(alpha: 0.04),
                            ],
                          ),
                          border: Border.all(
                            color: gold.withValues(
                              alpha: isActive ? 0.75 : 0.4,
                            ),
                            width: 1.4,
                          ),
                        ),
                        child: Text(
                          widget.country.flagEmoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Name + subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              GeoTranslations.translate(
                                  context, widget.country.name),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: widget.themeService.getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: gold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              regionCount > 0
                                  ? (widget.isArabic
                                      ? '$regionCount منطقة متاحة'
                                      : (Localizations.localeOf(context)
                                                  .languageCode ==
                                              'fr'
                                          ? '$regionCount régions disponibles'
                                          : '$regionCount regions available'))
                                  : (widget.isArabic
                                      ? 'تحديد تلقائي للمدينة'
                                      : (Localizations.localeOf(context)
                                                  .languageCode ==
                                              'fr'
                                          ? 'Détection automatique de la ville'
                                          : 'Auto-detect city')),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: onBg.withValues(alpha: 0.55),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Chevron
                      Icon(
                        Icons.chevron_right_rounded,
                        color: isActive
                            ? gold
                            : gold.withValues(alpha: 0.55),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}