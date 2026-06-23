import 'package:flutter/material.dart';
import 'dart:ui'; // Required for BackdropFilter (Glassmorphism)
import 'package:google_fonts/google_fonts.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import 'country_selection_screen.dart';
import 'azkar_screen.dart';
import 'settings_screen.dart';
import 'quran_screen.dart';
import 'duaa_screen.dart';
import 'good_deeds_screen.dart';
import 'islamic_goals_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => screen,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(opacity: curved, child: child);
        },
      ),
    );
  }

  void _openSettings() {
    _navigate(const SettingsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Detect if the current language is Arabic to apply the best font
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    
    // Dynamic Font Selection
    final titleStyle = isArabic 
        ? GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 44, fontWeight: FontWeight.bold, letterSpacing: 0.5)
        : GoogleFonts.arefRuqaa(color: const Color(0xFFD4AF37), fontSize: 44, fontWeight: FontWeight.bold, letterSpacing: 1.5);

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeCtrl,
            child: Column(
              children: [
                // ── Elegant Header ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            isArabic ? 'تطبيق إسلامي' : 'Islamy App',
                            textAlign: TextAlign.center,
                            style: titleStyle,
                          ),
                          Text(
                            'بسم الله الرحمن الرحيم',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiri(
                              color: Colors.white.withValues(alpha: 0.60),
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.settings_rounded, color: Color(0xFFD4AF37), size: 24),
                            onPressed: _openSettings,
                            tooltip: l10n.settings,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Decorative Divider ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.2), thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.star_border_rounded, size: 16, color: const Color(0xFFD4AF37).withValues(alpha: 0.8)),
                      ),
                      Expanded(child: Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.2), thickness: 1)),
                    ],
                  ),
                ),

                // ── Dashboard Grid (Constrained for Web/Desktop) ────────────
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      // Prevents the grid from stretching infinitely on ultrawide monitors
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: GridView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 350,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 180, // <--- Add this! (Delete childAspectRatio if it is there)
                        ),
                        children: [
                          _AnimatedCardWrapper(
                            index: 0,
                            child: _GlassCard(
                              icon: Icons.access_time_filled, 
                              title: l10n.prayerTimes, 
                              description: l10n.prayerTimesDesc, 
                              onTap: () => _navigate(const CountrySelectionScreen()),
                            ),
                          ),
                          _AnimatedCardWrapper(
                            index: 1,
                            child: _GlassCard(
                              icon: Icons.auto_stories_rounded,
                              title: l10n.azkarTitle,
                              description: l10n.azkarDesc,
                              onTap: () => _navigate(const AzkarScreen()),
                            ),
                          ),
                          _AnimatedCardWrapper(
                            index: 2,
                            child: _GlassCard(
                              icon: Icons.menu_book_rounded,
                              title: l10n.quranTitle,
                              description: l10n.quranDesc,
                              onTap: () => _navigate(const QuranScreen()),
                            ),
                          ),
                          _AnimatedCardWrapper(
                            index: 3,
                            child: _GlassCard(
                              icon: Icons.favorite_rounded,
                              title: l10n.duaaTitle,
                              description: l10n.duaaDesc,
                              onTap: () => _navigate(const DuaaScreen()),
                            ),
                          ),
                          _AnimatedCardWrapper(
                            index: 4,
                            child: _GlassCard(
                              icon: Icons.volunteer_activism_rounded,
                              title: l10n.goodDeedsTitle, 
                              description: l10n.goodDeedsDesc, 
                              onTap: () => _navigate(const GoodDeedsScreen()),
                            ),
                          ),
                          _AnimatedCardWrapper(
                            index: 5,
                            child: _GlassCard(
                              icon: Icons.track_changes_rounded,
                              title: l10n.islamicGoalsTitle, 
                              description: l10n.islamicGoalsDesc, 
                              onTap: () => _navigate(const IslamicGoalsScreen()),
                            ),
                          ),
                        ],
                      ),
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

// ── Wrapper to create staggered slide-up animations ─────────────────────────

class _AnimatedCardWrapper extends StatelessWidget {
  final Widget child;
  final int index;

  const _AnimatedCardWrapper({required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      // Staggers the animation based on the card's index position
      duration: Duration(milliseconds: 500 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ── Glassmorphism Card Design ───────────────────────────────────────────────

class _GlassCard extends StatefulWidget {
  final IconData icon;
  final String title; 
  final String description;
  final VoidCallback onTap;

  const _GlassCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  State<_GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<_GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        onTap: () {
          Future.delayed(const Duration(milliseconds: 100), widget.onTap);
        },
        child: AnimatedScale(
          scale: _isHovered ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? const Color(0xFF144D32).withValues(alpha: 0.85)
                      : const Color(0xFF0B3D2E).withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: _isHovered 
                        ? const Color(0xFFD4AF37).withValues(alpha: 0.8)
                        : const Color(0xFFD4AF37).withValues(alpha: 0.2),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: [
                    if (_isHovered)
                      BoxShadow(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16), // Slightly reduced for perfect fit
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isHovered
                              ? [const Color(0xFFD4AF37), const Color(0xFFB5952F)]
                              : [const Color(0xFFD4AF37).withValues(alpha: 0.1), const Color(0xFFD4AF37).withValues(alpha: 0.05)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withValues(alpha: _isHovered ? 1.0 : 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        color: _isHovered ? const Color(0xFF0B3D2E) : const Color(0xFFD4AF37),
                        size: 32,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.elMessiri(
                        color: _isHovered ? Colors.white : const Color(0xFFD4AF37),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // 🛠️ THE FIX: Replaced Expanded with Flexible so it doesn't force infinite height stretching!
                    Flexible(
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.elMessiri(
                          color: Colors.white.withValues(alpha: _isHovered ? 0.9 : 0.6),
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
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