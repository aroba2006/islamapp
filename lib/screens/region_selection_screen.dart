import 'package:flutter/material.dart';
import '../data/countries_data.dart';
import '../models/country_data.dart';
import '../widgets/islamic_pattern_background.dart';
import 'prayer_times_screen.dart';

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
      return Scaffold(
        body: IslamicPatternBackground(
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          ),
        ),
      );
    }

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
                  child: _buildHeader(context),
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
                      const SizedBox(height: 12),
                      Expanded(child: _buildRegionGrid(context)),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 6),
          Text(widget.country.flagEmoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.country.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Choose your state / governorate",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionGrid(BuildContext context) {
    final regions = widget.country.regions;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
          child: _RegionButton(
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

class _RegionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _RegionButton({required this.label, required this.onTap});

  @override
  State<_RegionButton> createState() => _RegionButtonState();
}

class _RegionButtonState extends State<_RegionButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B5E3F), Color(0xFF0B3D2E)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B5E3F).withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
