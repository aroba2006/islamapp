import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'home_screen.dart'; // Ensure this points to your actual home_screen.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _lightGold = Color(0xFFFFF3B0);
  static const Color _deepGold = Color(0xFF8A6B1F);

  late final AnimationController _introController; // one-time entrance
  late final AnimationController _shimmerController; // looping gold sweep
  late final AnimationController _ambientController; // slow ambient loop

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _glow;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _letterSpacing;
  late final Animation<double> _dividerWidth;
  late final Animation<double> _taglineFade;

  late final List<_Particle> _particles;

  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Slow, seamless 20s ambient loop: ornament ring orbit + gold dust drift.
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Deterministic scatter of floating gold specks.
    final rnd = math.Random(7);
    _particles = List.generate(
      20,
      (_) => _Particle(
        x: rnd.nextDouble(),
        size: 0.9 + rnd.nextDouble() * 2.4,
        speed: 0.35 + rnd.nextDouble() * 0.7,
        phase: rnd.nextDouble(),
        sway: 6 + rnd.nextDouble() * 20,
      ),
    );

    // 1) Logo: pops in with a soft bounce and fades in
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _logoFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
    );

    // 2) Golden glow behind the logo grows in
    _glow = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
    );

    // 3) Text: slides up, fades in, and letters tighten
    _textFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.4, 0.75, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _letterSpacing = Tween<double>(begin: 14, end: 3).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    // 4) Gold divider line grows from the center
    _dividerWidth = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
    );

    // 5) Arabic wordmark settles in last
    _taglineFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
    );

    _introController.forward().whenComplete(() {
      if (mounted) _shimmerController.repeat();
    });

    // Go to Home after the animation has had time to play
    _navTimer = Timer(const Duration(milliseconds: 3200), _goToHome);
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final reveal = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          final fade = CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          );
          // A soft golden bloom that dissolves as the reveal expands.
          final flash = 1.0 -
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
              ).value;

          return AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  ClipPath(
                    // Home page expands out from the center like a ripple
                    clipper: _CircleRevealClipper(reveal.value),
                    child: Opacity(
                      opacity: fade.value,
                      // Home page settles in from slightly zoomed (1.08 → 1.0)
                      child: Transform.scale(
                        scale: 1.08 - 0.08 * reveal.value,
                        child: child,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: flash * 0.35,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Color(0x99FFF3B0),
                                Color(0x00D4AF37),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _introController.dispose();
    _shimmerController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // -------- Theme-aware palette --------
    // Dark: deep emerald canvas with bright gold accents.
    // Light: warm ivory canvas with deeper, higher-contrast gold accents so
    // the shimmer, ring, and text remain legible on a bright background.
    final background = isDark
        ? const Color(0xFF0B3D2E)
        : const Color(0xFFFDFBF5);

    final primaryGold = isDark
        ? const Color(0xFFD4AF37) // classic gold on dark
        : const Color(0xFFB8860B); // darkened gold for contrast on light

    final shimmerHighlight = isDark
        ? const Color(0xFFFFF3B0) // bright cream highlight
        : const Color(0xFFD4AF37); // classic gold highlight

    final shimmerBase = isDark
        ? const Color(0xFFD4AF37)
        : const Color(0xFF8A6B1F); // deep gold so the sweep reads on ivory

    final auraColor = isDark
        ? const Color(0xFFD4AF37)
        : const Color(0xFFC9A227);

    final particleColor = isDark
        ? const Color(0xFFFFF3B0)
        : const Color(0xFFB8860B);

    final ringGold = primaryGold;
    final ringLightGold = isDark
        ? const Color(0xFFFFF3B0)
        : const Color(0xFFD4AF37);

    // Aura alpha is slightly stronger in light mode because gold-on-ivory
    // has less natural contrast than gold-on-emerald.
    final auraAlpha = isDark ? 0.16 : 0.13;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---------- AMBIENT RADIAL AURA ----------
          AnimatedBuilder(
            animation: _introController,
            builder: (context, _) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 0.95,
                    colors: [
                      auraColor.withValues(alpha: auraAlpha * _glow.value),
                      auraColor.withValues(
                        alpha: auraAlpha * 0.32 * _glow.value,
                      ),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              );
            },
          ),

          // ---------- FLOATING GOLD DUST ----------
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _ambientController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ParticlesPainter(
                      particles: _particles,
                      time: _ambientController.value * 4.0,
                      color: particleColor,
                    ),
                  );
                },
              ),
            ),
          ),

          // ---------- CONTENT ----------
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ---------- LOGO + ORNAMENT ----------
                AnimatedBuilder(
                  animation:
                      Listenable.merge([_introController, _ambientController]),
                  builder: (context, child) {
                    // Gentle vertical breathing float (4s cycle).
                    final float =
                        math.sin(_ambientController.value * math.pi * 2 * 5) *
                            3.0;

                    return Opacity(
                      opacity: _logoFade.value,
                      child: Transform.translate(
                        offset: Offset(0, float * _glow.value),
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: SizedBox(
                            width: 220,
                            height: 220,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Rotating geometric ornament ring
                                Opacity(
                                  opacity: 0.95 * _glow.value,
                                  child: Transform.rotate(
                                    angle: _ambientController.value *
                                        2 *
                                        math.pi,
                                    child: CustomPaint(
                                      size: const Size(220, 220),
                                      painter: _OrnamentRingPainter(
                                        gold: ringGold,
                                        lightGold: ringLightGold,
                                        // Light mode needs slightly stronger
                                        // alphas to keep the faint tracks visible.
                                        trackAlpha: isDark ? 0.22 : 0.35,
                                        innerTrackAlpha:
                                            isDark ? 0.12 : 0.22,
                                      ),
                                    ),
                                  ),
                                ),

                                // Golden halo behind the logo
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isDark
                                                ? const Color(0xFFD4AF37)
                                                : const Color(0xFFC9A227))
                                            .withValues(
                                          alpha: 0.35 * _glow.value,
                                        ),
                                        blurRadius: 60 * _glow.value,
                                        spreadRadius: 12 * _glow.value,
                                      ),
                                    ],
                                  ),
                                ),

                                child!,
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 140,
                    height: 140,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.mosque,
                        size: 96,
                        color: primaryGold,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),

                // ---------- APP NAME ----------
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: AnimatedBuilder(
                      animation: Listenable.merge(
                        [_introController, _shimmerController],
                      ),
                      builder: (context, _) {
                        // Sweep position of the shimmer highlight (-0.3 → 1.3)
                        final t = _shimmerController.value * 1.6 - 0.3;
                        return ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              shimmerBase,
                              shimmerHighlight,
                              shimmerBase,
                            ],
                            stops: [
                              (t - 0.25).clamp(0.0, 1.0),
                              t.clamp(0.0, 1.0),
                              (t + 0.25).clamp(0.0, 1.0),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Islamy',
                            style: TextStyle(
                              color: Colors.white, // replaced by the gradient
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Amiri',
                              letterSpacing: _letterSpacing.value,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- DIVIDER WITH CENTER ORNAMENT ----------
                AnimatedBuilder(
                  animation: _dividerWidth,
                  builder: (context, _) {
                    final v = _dividerWidth.value;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _DividerLine(
                          grow: v,
                          alignEnd: false,
                          color: primaryGold,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10 * v),
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Container(
                              width: 7 * v,
                              height: 7 * v,
                              decoration: BoxDecoration(
                                color: primaryGold,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryGold.withValues(
                                      alpha: 0.6 * v,
                                    ),
                                    blurRadius: 10 * v,
                                    spreadRadius: 1 * v,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _DividerLine(
                          grow: v,
                          alignEnd: true,
                          color: primaryGold,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 14),

                // ---------- ARABIC WORDMARK ----------
                FadeTransition(
                  opacity: _taglineFade,
                  child: Text(
                    'إسلامي',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      // Deeper in light mode so it stays readable on ivory.
                      color: primaryGold.withValues(
                        alpha: isDark ? 0.85 : 0.95,
                      ),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single half of the gold divider line, growing outward from the center.
class _DividerLine extends StatelessWidget {
  final double grow;
  final bool alignEnd;
  final Color color;

  const _DividerLine({
    required this.grow,
    required this.alignEnd,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60 * grow,
      height: 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          colors: alignEnd
              ? [color.withValues(alpha: 0), color]
              : [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

/// A slowly orbiting geometric ornament ring drawn around the logo.
class _OrnamentRingPainter extends CustomPainter {
  final Color gold;
  final Color lightGold;
  final double trackAlpha;
  final double innerTrackAlpha;

  const _OrnamentRingPainter({
    required this.gold,
    required this.lightGold,
    this.trackAlpha = 0.22,
    this.innerTrackAlpha = 0.12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 10;

    // Faint outer track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = gold.withValues(alpha: trackAlpha),
    );

    // Fainter inner track
    canvas.drawCircle(
      center,
      radius - 12,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6
        ..color = gold.withValues(alpha: innerTrackAlpha),
    );

    // 8 gradient arc segments
    const segments = 8;
    const gap = 0.30; // radians of empty space between arcs
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    for (var i = 0; i < segments; i++) {
      final start = i * (2 * math.pi / segments) + gap / 2;
      final sweep = (2 * math.pi / segments) - gap;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: start,
          endAngle: start + sweep,
          colors: [
            gold.withValues(alpha: 0.0),
            lightGold,
            gold.withValues(alpha: 0.0),
          ],
        ).createShader(arcRect);

      canvas.drawArc(arcRect, start, sweep, false, paint);
    }

    // Tiny bright dots on the cardinal points
    final dotPaint = Paint()..color = lightGold.withValues(alpha: 0.9);
    for (var i = 0; i < 4; i++) {
      final a = i * math.pi / 2;
      canvas.drawCircle(
        center + Offset(math.cos(a), math.sin(a)) * radius,
        2.2,
        dotPaint,
      );
    }

    // Smaller dim dots on the diagonals
    final diagPaint = Paint()..color = gold.withValues(alpha: 0.55);
    for (var i = 0; i < 4; i++) {
      final a = i * math.pi / 2 + math.pi / 4;
      canvas.drawCircle(
        center + Offset(math.cos(a), math.sin(a)) * (radius - 12),
        1.4,
        diagPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_OrnamentRingPainter oldDelegate) => false;
}

/// A single drifting gold speck.
class _Particle {
  final double x; // 0..1 horizontal position
  final double size; // radius in px
  final double speed; // cycles per ambient unit
  final double phase; // 0..1 start offset
  final double sway; // horizontal sway amplitude in px

  const _Particle({
    required this.x,
    required this.size,
    required this.speed,
    required this.phase,
    required this.sway,
  });
}

/// Paints the rising, twinkling gold dust.
class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;
  final Color color;

  const _ParticlesPainter({
    required this.particles,
    required this.time,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final p in particles) {
      final t = (p.phase + time * p.speed) % 1.0;
      final y = (1.0 - t) * size.height;
      final x = p.x * size.width +
          math.sin((t + p.phase) * math.pi * 2) * p.sway;
      final life = math.sin(t * math.pi); // fade in / fade out

      paint.color = color.withValues(alpha: 0.45 * life);
      canvas.drawCircle(Offset(x, y), p.size * (0.6 + 0.4 * life), paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) =>
      oldDelegate.time != time;
}

/// Clips the page to a circle that grows from the screen center
/// until it covers the whole screen (fraction: 0.0 → 1.0).
class _CircleRevealClipper extends CustomClipper<Path> {
  final double fraction;

  const _CircleRevealClipper(this.fraction);

  @override
  Path getClip(Size size) {
    final center = size.center(Offset.zero);
    // Distance from the center to a corner = radius needed to cover everything
    final maxRadius = math.sqrt(
      center.dx * center.dx + center.dy * center.dy,
    );
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: maxRadius * fraction));
  }

  @override
  bool shouldReclip(_CircleRevealClipper oldClipper) =>
      oldClipper.fraction != fraction;
}