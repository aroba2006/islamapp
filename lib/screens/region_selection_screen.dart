import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../data/countries_data.dart';
import '../models/country_data.dart';
import '../widgets/islamic_pattern_background.dart';
import 'prayer_times_screen.dart';
import '../data/geo_translations.dart';

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
      duration: const Duration(milliseconds: 600),
    )..forward();

    // If this country has no hardcoded regions, skip straight to prayer
    // times using the capital city fallback.
    if (widget.country.regions.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final capital = countryCapitals[widget.country.name] ?? widget.country.name;
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
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
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
                  child: _buildHeader(context, isArabic),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: _buildRegionGrid(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).colorScheme.secondary, size: 24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              GeoTranslations.translate(context, widget.country.name),
              style: isArabic 
                  ? GoogleFonts.amiri(color: Theme.of(context).colorScheme.secondary, fontSize: 32, fontWeight: FontWeight.bold)
                  : GoogleFonts.arefRuqaa(color: Theme.of(context).colorScheme.secondary, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionGrid(BuildContext context) {
    final regions = widget.country.regions;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280, 
        childAspectRatio: 2.2, 
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: regions.length,
      itemBuilder: (context, index) {
        final region = regions[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 220 + (index * 20).clamp(0, 380)),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(scale: 0.9 + (0.1 * value), child: child),
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
          ),
        );
      },
    );
  }
}

// ── FROSTED GLASS REGION CARD ──────────────────────────────────
class _RegionGlassCard extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _RegionGlassCard({required this.label, required this.onTap});

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
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isActive 
                      ? (isDark ? const Color(0xFF144D32).withValues(alpha: 0.85) : const Color(0xFFE8F3EE).withValues(alpha: 0.85))
                      : (isDark ? const Color(0xFF0B3D2E).withValues(alpha: 0.65) : const Color(0xFFF0F8F4).withValues(alpha: 0.65)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive 
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                    width: isActive ? 2 : 1,
                  ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  GeoTranslations.translate(context, widget.label),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.elMessiri(
                    // ✅ FIXED: Use proper color based on theme
                    color: isActive 
                        ? Theme.of(context).colorScheme.secondary
                        : (isDark ? Theme.of(context).colorScheme.secondary : const Color(0xFF1B5E3F)),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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