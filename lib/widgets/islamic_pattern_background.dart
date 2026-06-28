import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../app_theme.dart';

/// A repeating Islamic 8-point star geometric pattern, drawn with CustomPainter.
/// Automatically adapts colors based on light/dark theme.
class IslamicPatternBackground extends StatelessWidget {
  final Widget child;
  final bool showPattern;

  const IslamicPatternBackground({
    super.key,
    required this.child,
    this.showPattern = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-aware colors
    final baseColor = isDark
        ? const Color(0xFF0B3D2E)  // Dark green for dark mode
        : const Color(0xFFFFFBF5); // Warm white for light mode
    
    final patternColor = isDark
        ? const Color(0xFF1B5E3F)  // Lighter green for dark mode
        : const Color(0xFFE8C547); // Light gold for light mode
    
    final opacity = isDark ? 0.18 : 0.12; // Adjust opacity based on mode

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                baseColor,
                Color.lerp(baseColor, isDark ? Colors.black : Colors.white, 0.15)!,
              ],
            ),
          ),
        ),
        if (showPattern)
          Positioned.fill(
            child: Opacity(
              opacity: opacity,
              child: CustomPaint(
                painter: _IslamicStarPatternPainter(color: patternColor),
              ),
            ),
          ),
        child,
      ],
    );
  }
}

class _IslamicStarPatternPainter extends CustomPainter {
  final Color color;
  _IslamicStarPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    const double tile = 70;
    final cols = (size.width / tile).ceil() + 1;
    final rows = (size.height / tile).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final offsetX = (r.isOdd ? tile / 2 : 0.0);
        final center = Offset(c * tile + offsetX, r * tile);
        _drawEightPointStar(canvas, center, tile * 0.42, paint);
      }
    }
  }

  void _drawEightPointStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 8;
    final outerR = radius;
    final innerR = radius * 0.5;
    for (int i = 0; i < points * 2; i++) {
      final angle = (math.pi / points) * i - math.pi / 2;
      final r = i.isEven ? outerR : innerR;
      final pt = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A smaller decorative star divider, e.g. used between header and list.
class IslamicDivider extends StatelessWidget {
  final Color? color;
  const IslamicDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AppTheme.getOnBackgroundColor(context);
    
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _line(dividerColor),
          const SizedBox(width: 8),
          Icon(Icons.star, size: 14, color: dividerColor.withValues(alpha: 0.8)),
          const SizedBox(width: 8),
          _line(dividerColor),
        ],
      ),
    );
  }

  Widget _line(Color color) {
    return Container(
      width: 50,
      height: 1,
      color: color.withValues(alpha: 0.4),
    );
  }
}