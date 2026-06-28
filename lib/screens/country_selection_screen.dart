import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
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
          final translatedName = GeoTranslations.translate(context, c.name).toLowerCase();
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
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      ),
    );
  }

  // ── AUTO DETECT LOCATION LOGIC (WEB + MOBILE SAFE) ───────────────────────
  Future<void> _detectLocation(String lang) async {
    setState(() => _isDetecting = true);

    try {
      String detectedCountry = 'Unknown';
      String detectedCity = 'Unknown';

      if (kIsWeb) {
        // 🌐 WEB FALLBACK: Browsers block reverse-geocoding without API keys.
        // We use a free IP-based location API for seamless web testing!
        final response = await http.get(Uri.parse('https://get.geojs.io/v1/ip/geo.json'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          detectedCountry = data['country'] ?? 'Unknown';
          detectedCity = data['city'] ?? 'Unknown';
        } else {
          throw Exception(lang == 'ar' ? 'فشل تحديد الموقع على المتصفح' : 'Web location failed.');
        }
      } else {
        // 📱 NATIVE MOBILE LOGIC: Uses physical GPS hardware
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) throw Exception(lang == 'ar' ? 'خدمات الموقع معطلة' : 'Location services are disabled.');

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) throw Exception(lang == 'ar' ? 'تم رفض إذن الموقع' : 'Location permissions denied.');
        }
        
        if (permission == LocationPermission.deniedForever) {
          throw Exception(lang == 'ar' ? 'أذونات الموقع مرفوضة نهائياً' : 'Location permissions are permanently denied.');
        }

        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        
        if (placemarks.isEmpty) throw Exception('Location unreadable.');

        Placemark place = placemarks.first;
        detectedCountry = place.country ?? 'Unknown';
        detectedCity = place.locality ?? place.administrativeArea ?? 'Unknown';
      }

      // Find matching CountryData from your local list
      CountryData matchedCountry = countries.firstWhere(
        (c) => c.name.toLowerCase() == detectedCountry.toLowerCase(),
        orElse: () => CountryData(name: detectedCountry, flagEmoji: '📍', regions: []),
      );

      if (!mounted) return;

      // Teleport straight to Prayer Times!
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => PrayerTimesScreen(country: matchedCountry, region: detectedCity),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString().replaceAll('Exception: ', ''), style: GoogleFonts.elMessiri()),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      if (mounted) setState(() => _isDetecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              FadeTransition(
                opacity: _headerController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.15),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic)),
                  child: _buildHeader(context, l10n!, isArabic),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildSearchField(context, l10n!, isArabic),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildAutoDetectButton(lang),
                        ),
                        const SizedBox(height: 16),
                        Expanded(child: _buildCountryList(context, l10n, isArabic)),
                      ],
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).colorScheme.secondary, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.selectCountry,
                  style: isArabic 
                      ? GoogleFonts.amiri(color: Theme.of(context).colorScheme.secondary, fontSize: 32, fontWeight: FontWeight.bold)
                      : GoogleFonts.arefRuqaa(color: Theme.of(context).colorScheme.secondary, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, AppLocalizations l10n, bool isArabic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppTheme.getOnBackgroundColor(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: l10n.searchCountries,
            hintStyle: TextStyle(color: textColor.withValues(alpha: 0.6)),
            prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
            filled: true,
            fillColor: isDark
                ? const Color(0xFF0B3D2E).withValues(alpha: 0.65)
                : const Color(0xFFF0F8F4).withValues(alpha: 0.65),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAutoDetectButton(String lang) {
    String btnText = 'Auto-Detect Location';
    if (lang == 'ar') btnText = 'تحديد موقعي تلقائياً';
    if (lang == 'fr') btnText = 'Détecter ma position';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppTheme.getOnBackgroundColor(context);

    return GestureDetector(
      onTap: _isDetecting ? null : () => _detectLocation(lang),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isDetecting)
              SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary, strokeWidth: 2),
              )
            else
              Icon(Icons.my_location_rounded, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 12),
            Text(
              _isDetecting 
                  ? (lang == 'ar' ? 'جاري التحديد...' : (lang == 'fr' ? 'Détection...' : 'Detecting...'))
                  : btnText,
              style: GoogleFonts.elMessiri(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryList(BuildContext context, AppLocalizations l10n, bool isArabic) {
    if (_filtered.isEmpty) {
      return Center(
        child: Text(
          l10n.noCountriesFound,
          style: GoogleFonts.elMessiri(
            color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.7),
            fontSize: 18,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final country = _filtered[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 250 + (index * 18).clamp(0, 400)),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(opacity: value, child: Transform.translate(offset: Offset((1 - value) * 24, 0), child: child)),
          child: _CountryTile(country: country, isArabic: isArabic, onTap: () => _onCountryTap(country)),
        );
      },
    );
  }
}

class _CountryTile extends StatefulWidget {
  final CountryData country;
  final bool isArabic;
  final VoidCallback onTap;
  
  const _CountryTile({required this.country, required this.isArabic, required this.onTap});

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
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? (isDark ? const Color(0xFF144D32).withValues(alpha: 0.85) : const Color(0xFFE8F3EE).withValues(alpha: 0.85))
                        : (isDark ? const Color(0xFF0B3D2E).withValues(alpha: 0.65) : const Color(0xFFF0F8F4).withValues(alpha: 0.65)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(widget.country.flagEmoji, style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          GeoTranslations.translate(context, widget.country.name),
                          style: GoogleFonts.elMessiri(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: isActive ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5)),
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