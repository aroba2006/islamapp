import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as Math;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../l10n/app_localizations.dart';

class QiblahFinderScreen extends StatefulWidget {
  const QiblahFinderScreen({super.key});

  @override
  State<QiblahFinderScreen> createState() => _QiblahFinderScreenState();
}

class _QiblahFinderScreenState extends State<QiblahFinderScreen> {
  double _qiblahAngle = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeQiblahFinder();
  }

  Future<void> _initializeQiblahFinder() async {
    // TODO: Implement location and compass logic here
    // For now, this is a placeholder
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
      _qiblahAngle = 0.0; // Replace with actual qiblah calculation
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        ),
                        Expanded(
                          child: Text(
                            isArabic ? 'اتجاه القبلة' : 'Qiblah Finder',
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
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF0B3D2E).withValues(alpha: 0.7)
                                    : const Color(0xFFF0F8F4).withValues(alpha: 0.7),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withValues(alpha: 0.3),
                                ),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              padding: const EdgeInsets.all(40),
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFD4AF37),
                                      ),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Compass circle
                                        Container(
                                          width: 250,
                                          height: 250,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2,
                                            ),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Compass dial
                                              CustomPaint(
                                                size: const Size(250, 250),
                                                painter: CompassPainter(
                                                  angle: _qiblahAngle,
                                                  isDark: isDark,
                                                ),
                                              ),
                                              // Qiblah indicator arrow
                                              Transform.rotate(
                                                angle:
                                                    _qiblahAngle * 3.14159 / 180,
                                                child: const Icon(
                                                  Icons.arrow_upward,
                                                  size: 40,
                                                  color: Color(0xFFD4AF37),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        Text(
                                          isArabic
                                              ? 'وجه هاتفك نحو هذا الاتجاه'
                                              : 'Point your phone toward this direction',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.elMessiri(
                                            color: AppTheme.getOnBackgroundColor(
                                                context),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          '${_qiblahAngle.toStringAsFixed(1)}°',
                                          style: GoogleFonts.elMessiri(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CompassPainter extends CustomPainter {
  final double angle;
  final bool isDark;

  CompassPainter({required this.angle, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.3)
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw cardinal directions
    const directions = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * 3.14159 / 180;
      final x = center.dx + radius * 0.85 * Math.cos(angle);
      final y = center.dy + radius * 0.85 * Math.sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: directions[i],
          style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // Draw circle
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CompassPainter oldDelegate) =>
      oldDelegate.angle != angle || oldDelegate.isDark != isDark;
}