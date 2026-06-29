import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../widgets/outlined_text_widget.dart';
import '../l10n/app_localizations.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import 'country_selection_screen.dart';
import 'azkar_screen.dart';
import 'settings_screen.dart';
import 'quran_screen.dart';
import 'duaa_screen.dart';
import 'good_deeds_screen.dart';
import 'islamic_goals_screen.dart';
import 'qiblah_finder_screen.dart';
import 'mosque_finder_screen.dart';

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
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final l10n = AppLocalizations.of(context);
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';

         // Add this here
    final cardHeight = switch (themeService.textScaleFactor) {
  TextScaleFactor.small => 190.0,
  TextScaleFactor.medium => 215.0,
  TextScaleFactor.large => 250.0,
};
            
        // Scale the title size based on text scale setting
        
        final scaledTitleSize = themeService.getScaledSize(44);
        final scaledDescSize = themeService.getScaledSize(16);

        final titleStyle = isArabic
            ? GoogleFonts.amiri(
                color: const Color(0xFFD4AF37),
                fontSize: scaledTitleSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              )
            : GoogleFonts.arefRuqaa(
                color: const Color(0xFFD4AF37),
                fontSize: scaledTitleSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              );

        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeCtrl,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              OutlinedTextTitle(
                                text: isArabic ? 'تطبيق إسلامي' : 'Islamy App',
                                textAlign: TextAlign.center,
                                style: titleStyle,
                              ),
                              Text(
                                'رفيقك الإسلامي في حياتك اليومية',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.amiri(
                                  color: AppTheme.getOnBackgroundColor(context)
                                      .withValues(alpha: 0.60),
                                  fontSize: scaledDescSize,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment:
                                isArabic ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.settings_rounded,
                                    color: Color(0xFFD4AF37), size: 24),
                                onPressed: _openSettings,
                                tooltip: l10n.settings,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(
                              Icons.star_border_rounded,
                              size: 16,
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.8),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: GridView(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 350,
  crossAxisSpacing: 20,
  mainAxisSpacing: 20,
  mainAxisExtent: cardHeight,
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
                              _AnimatedCardWrapper(
                                index: 6,
                                child: _GlassCard(
                                  icon: Icons.explore_rounded,
                                  title: l10n.qiblahFinderTitle,
                                  description: l10n.qiblahFinderDesc,
                                  onTap: () => _navigate(const QiblahFinderScreen()),
                                ),
                              ),
                              _AnimatedCardWrapper(
                                index: 7,
                                child: _GlassCard(
                                  icon: Icons.location_on_rounded,
                                  title: l10n.nearestMosqueTitle,
                                  description: l10n.nearestMosqueDesc,
                                  onTap: () => _navigate(const MosqueFinderScreen()),
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
      },
    );
  }
}

class _AnimatedCardWrapper extends StatelessWidget {
  final Widget child;
  final int index;

  const _AnimatedCardWrapper({required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
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
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        // Scale title and description sizes for the card
        final scaledCardTitleSize = themeService.getScaledSize(20);
        final scaledCardDescSize = themeService.getScaledSize(13);

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
                          ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.85)
                          : Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.65),
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
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isHovered
                ? [const Color(0xFFD4AF37), const Color(0xFFB5952F)]
                : [
                    const Color(0xFFD4AF37).withValues(alpha: 0.1),
                    const Color(0xFFD4AF37).withValues(alpha: 0.05),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFD4AF37)
                .withValues(alpha: _isHovered ? 1.0 : 0.3),
            width: 1.5,
          ),
        ),
        child: Icon(
          widget.icon,
          color: _isHovered
              ? Theme.of(context).scaffoldBackgroundColor
              : const Color(0xFFD4AF37),
          size: 32,
        ),
      ),
    ),

    const SizedBox(height: 14),

    Text(
      widget.title,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.visible,
      style: GoogleFonts.elMessiri(
        color: _isHovered
            ? AppTheme.getOnBackgroundColor(context)
            : const Color(0xFFD4AF37),
        fontSize: scaledCardTitleSize,
        fontWeight: FontWeight.bold,
        height: 1.15,
      ),
    ),

    const SizedBox(height: 8),

    Expanded(
      child: Text(
        widget.description,
        textAlign: TextAlign.center,
        style: GoogleFonts.elMessiri(
          color: AppTheme.getOnBackgroundColor(context)
              .withValues(alpha: _isHovered ? 0.9 : 0.6),
          fontSize: scaledCardDescSize,
          height: 1.3,
        ),
      ),
    ),
  ],
)
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}