import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../data/countries_data.dart';
import '../models/country_data.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import 'region_selection_screen.dart';
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
          // Translate the country name into the current language (Arabic/French/English)
          final translatedName = GeoTranslations.translate(context, c.name).toLowerCase();
          // Keep the original English name as a fallback
          final englishName = c.name.toLowerCase();
          
          // Check if the search query matches EITHER the translated name OR the English name
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
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
                  ).animate(CurvedAnimation(
                      parent: _headerController, curve: Curves.easeOutCubic)),
                  child: _buildHeader(context, l10n, isArabic),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                          child: _buildSearchField(context, l10n, isArabic),
                        ),
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
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded, 
                  color: Color(0xFFD4AF37),
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.selectCountry,
                  style: isArabic 
                      ? GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold)
                      : GoogleFonts.arefRuqaa(color: const Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, AppLocalizations l10n, bool isArabic) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l10n.searchCountries,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
            filled: true,
            fillColor: const Color(0xFF0B3D2E).withValues(alpha: 0.65),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryList(BuildContext context, AppLocalizations l10n, bool isArabic) {
    if (_filtered.isEmpty) {
      return Center(
        child: Text(
          l10n.noCountriesFound,
          style: GoogleFonts.elMessiri(color: Colors.white70, fontSize: 18),
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
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset((1 - value) * 24, 0),
                child: child,
              ),
            );
          },
          child: _CountryTile(
            country: country,
            isArabic: isArabic,
            onTap: () => _onCountryTap(country),
          ),
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
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
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
          scale: _isHovered ? 1.02 : _scale,
          duration: const Duration(milliseconds: 200),
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
                    color: _isHovered 
                        ? const Color(0xFF144D32).withValues(alpha: 0.85)
                        : const Color(0xFF0B3D2E).withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isHovered 
                          ? const Color(0xFFD4AF37).withValues(alpha: 0.8)
                          : const Color(0xFFD4AF37).withValues(alpha: 0.2),
                      width: _isHovered ? 2 : 1,
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
                            color: _isHovered ? Colors.white : const Color(0xFFD4AF37),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded, 
                        color: _isHovered ? Colors.white : const Color(0xFFD4AF37).withValues(alpha: 0.5),
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