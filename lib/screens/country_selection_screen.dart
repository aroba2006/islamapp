import 'package:flutter/material.dart';
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
      _filtered = query.isEmpty
          ? countries
          : countries
              .where((c) => c.name.toLowerCase().contains(query))
              .toList();
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
    final l10n = AppLocalizations.of(context);
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
                  child: _buildHeader(context, l10n),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: _buildSearchField(context, l10n),
                      ),
                      Expanded(child: _buildCountryList(context, l10n)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                ),
                child: const Icon(Icons.mosque, color: Color(0xFFD4AF37), size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              IconButton(
  icon: const Icon(
    Icons.arrow_back_ios_new_rounded, 
    color: Color(0xFFD4AF37), // Your gold theme color
    size: 24,
  ),
  onPressed: () {
    Navigator.pop(context); // Returns you to the Home Screen
  },
),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.selectCountry,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, AppLocalizations l10n) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: l10n.searchCountries,
        prefixIcon: const Icon(Icons.search, color: Color(0xFF1B5E3F)),
        filled: true,
        fillColor: const Color(0xFFF3F6F4),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCountryList(BuildContext context, AppLocalizations l10n) {
    if (_filtered.isEmpty) {
      return Center(
        child: Text(
          l10n.noCountriesFound,
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
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
            onTap: () => _onCountryTap(country),
          ),
        );
      },
    );
  }
}

class _CountryTile extends StatefulWidget {
  final CountryData country;
  final VoidCallback onTap;
  const _CountryTile({required this.country, required this.onTap});

  @override
  State<_CountryTile> createState() => _CountryTileState();
}

class _CountryTileState extends State<_CountryTile> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAF9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3E9E6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(widget.country.flagEmoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 14),
              Expanded(
             child: Text(
               GeoTranslations.translate(context, widget.country.name),
               style: const TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
                 color: Color(0xFF1A2E25),
               ),
             ),
           ),
              const Icon(Icons.chevron_right, color: Color(0xFF1B5E3F)),
            ],
          ),
        ),
      ),
    );
  }
}