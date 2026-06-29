import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../l10n/app_localizations.dart';

// Extract constants
class _MosqueFinderConstants {
  static const Color primaryGold = Color(0xFFD4AF37);
  static const double cardBorderRadius = 20;
  static const double cardPadding = 16;
  static const double iconSize = 24;
  static const double hoverScale = 0.98;
  static const Duration hoverDuration = Duration(milliseconds: 150);
  static const Duration containerDuration = Duration(milliseconds: 200);
}

class MosqueFinderScreen extends StatefulWidget {
  const MosqueFinderScreen({super.key});

  @override
  State<MosqueFinderScreen> createState() => _MosqueFinderScreenState();
}

class _MosqueFinderScreenState extends State<MosqueFinderScreen> {
  bool _isLoading = true;
  List<Mosque> _nearbyMosques = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeMosqueFinder();
  }

  Future<void> _initializeMosqueFinder() async {
    try {
      // TODO: Implement location and mosque search logic here
      // For now, this is a placeholder with sample data
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _nearbyMosques = [
          Mosque(
            name: 'Al-Azhar Mosque',
            distance: 0.5,
            direction: 'North',
            prayerTime: '12:30 PM',
          ),
          Mosque(
            name: 'Al-Hakim Mosque',
            distance: 1.2,
            direction: 'Northeast',
            prayerTime: '12:35 PM',
          ),
          Mosque(
            name: 'Ibn Tulun Mosque',
            distance: 2.1,
            direction: 'East',
            prayerTime: '12:40 PM',
          ),
        ];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load nearby mosques';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          tooltip: isArabic ? 'العودة' : 'Back',
                        ),
                        Expanded(
                          child: Text(
                            isArabic ? 'أقرب مسجد' : 'Nearest Mosque',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiri(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: _buildContent(context, isArabic),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, bool isArabic) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: _MosqueFinderConstants.primaryGold,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: _MosqueFinderConstants.primaryGold,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _isLoading = true);
                _initializeMosqueFinder();
              },
              icon: const Icon(Icons.refresh),
              label: Text(isArabic ? 'حاول مجددًا' : 'Retry'),
            ),
          ],
        ),
      );
    }

    if (_nearbyMosques.isEmpty) {
      return Center(
        child: Text(
          isArabic ? 'لم يتم العثور على مساجد قريبة' : 'No nearby mosques found',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _nearbyMosques.length,
      itemBuilder: (context, index) {
        final mosque = _nearbyMosques[index];
        return _MosqueCard(
          mosque: mosque,
          isArabic: isArabic,
        );
      },
    );
  }
}

class _MosqueCard extends StatefulWidget {
  final Mosque mosque;
  final bool isArabic;

  const _MosqueCard({
    required this.mosque,
    required this.isArabic,
  });

  @override
  State<_MosqueCard> createState() => _MosqueCardState();
}

class _MosqueCardState extends State<_MosqueCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Focus(
        onKey: (node, event) {
          // Add keyboard support (Enter to interact)
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // TODO: Navigate to mosque details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tapped: ${widget.mosque.name}',
                  ),
                ),
              );
            },
            child: AnimatedScale(
              scale: _isHovered
                  ? _MosqueFinderConstants.hoverScale
                  : 1.0,
              duration: _MosqueFinderConstants.hoverDuration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  _MosqueFinderConstants.cardBorderRadius,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: AnimatedContainer(
                    duration: _MosqueFinderConstants.containerDuration,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.85)
                          : Theme.of(context)
                              .scaffoldBackgroundColor
                              .withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(
                        _MosqueFinderConstants.cardBorderRadius,
                      ),
                      border: Border.all(
                        color: _MosqueFinderConstants.primaryGold.withValues(
                          alpha: _isHovered ? 0.8 : 0.2,
                        ),
                        width: _isHovered ? 2 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(
                      _MosqueFinderConstants.cardPadding,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _MosqueFinderConstants.primaryGold
                                .withValues(alpha: _isHovered ? 0.9 : 0.2),
                          ),
                          child: Icon(
                            Icons.mosque_rounded,
                            color: _isHovered
                                ? Theme.of(context).scaffoldBackgroundColor
                                : _MosqueFinderConstants.primaryGold,
                            size: _MosqueFinderConstants.iconSize,
                            semanticLabel: widget.isArabic
                                ? 'مسجد'
                                : 'Mosque',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mosque.name,
                                style: GoogleFonts.elMessiri(
                                  color: _isHovered
                                      ? AppTheme.getOnBackgroundColor(context)
                                      : _MosqueFinderConstants.primaryGold,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.mosque.distance} km away • ${widget.mosque.direction}',
                                style: GoogleFonts.elMessiri(
                                  color: AppTheme.getOnBackgroundColor(context)
                                      .withValues(
                                          alpha: _isHovered ? 0.8 : 0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.mosque.prayerTime,
                              style: GoogleFonts.elMessiri(
                                color: _MosqueFinderConstants.primaryGold,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isArabic ? 'وقت الصلاة' : 'Prayer Time',
                              style: GoogleFonts.elMessiri(
                                color: AppTheme.getOnBackgroundColor(context)
                                    .withValues(alpha: 0.5),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

class Mosque {
  final String name;
  final double distance;
  final String direction;
  final String prayerTime;

  Mosque({
    required this.name,
    required this.distance,
    required this.direction,
    required this.prayerTime,
  });
}