import 'package:flutter/material.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import 'country_selection_screen.dart';
import 'azkar_screen.dart';
import 'settings_screen.dart';
import 'quran_screen.dart';
import 'duaa_screen.dart';

/// Root landing screen — shows the app title at top-centre, then four
/// section cards: Prayer Times, Azkar, Quran, and Duaa.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _navigate(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, animation, __) => screen,
        transitionsBuilder: (_, animation, __, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(1, 0), end: Offset.zero)
                .animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      ),
    );
  }

  void _openSettings() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, animation, __) => const SettingsScreen(),
        transitionsBuilder: (_, animation, __, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0, 1), end: Offset.zero)
                .animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is the variable that grabs the correct language!
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeCtrl,
            child: Column(
              children: [
                // ── Top bar: settings icon on right, title centred ──────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Islamy App',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'بسم الله الرحمن الرحيم',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.50),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.settings,
                              color: Color(0xFFD4AF37), size: 26),
                          onPressed: _openSettings,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Decorative divider ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.star,
                            size: 13,
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.7)),
                      ),
                      Expanded(
                        child: Divider(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Section cards ───────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Prayer Times (Now fully dynamic!)
                        _SectionCard(
                          icon: Icons.access_time_rounded,
                          title: l10n.prayerTimes, 
                          description: l10n.prayerTimesDesc, 
                          buttonLabel: l10n.prayerTimes,
                          onTap: () =>
                              _navigate(const CountrySelectionScreen()),
                        ),

                        const SizedBox(height: 20),

                        // Azkar (Now fully dynamic!)
                        _SectionCard(
                          icon: Icons.auto_stories_rounded,
                          title: l10n.azkarTitle,
                          description: l10n.azkarDesc,
                          buttonLabel: l10n.azkarTitle,
                          onTap: () => _navigate(const AzkarScreen()),
                        ),

                        const SizedBox(height: 20),

                        // Quran (Now fully dynamic!)
                        _SectionCard(
                          icon: Icons.menu_book_rounded,
                          title: l10n.quranTitle,
                          description: l10n.quranDesc,
                          buttonLabel: l10n.quranTitle,
                          onTap: () => _navigate(const QuranScreen()),
                        ),

                        const SizedBox(height: 20),

                        // Duaa (Now fully dynamic!)
                        _SectionCard(
                          icon: Icons.favorite_rounded,
                          title: l10n.duaaTitle,
                          description: l10n.duaaDesc,
                          buttonLabel: l10n.duaaTitle,
                          onTap: () => _navigate(const DuaaScreen()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable section card ─────────────────────────────────────────────────────

class _SectionCard extends StatefulWidget {
  final IconData icon;
  final String title; // Changed to a single dynamic title
  final String description;
  final String buttonLabel;
  final VoidCallback onTap;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E3F), Color(0xFF144D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.30),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon,
                        color: const Color(0xFFD4AF37), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.title, // Render the dynamic title
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Description
              Text(
                widget.description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: const Color(0xFF0B3D2E),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.buttonLabel,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0B3D2E),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: Color(0xFF0B3D2E)),
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
}