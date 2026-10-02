import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah_advanced/flutter_qiblah_advanced.dart';
import 'package:provider/provider.dart';

import '../services/theme_service.dart';

// ============================================================================
//  ENTRY SCREEN
// ============================================================================

class QiblahFinderScreen extends StatefulWidget {
  const QiblahFinderScreen({super.key});

  @override
  State<QiblahFinderScreen> createState() => _QiblahFinderScreenState();
}

class _QiblahFinderScreenState extends State<QiblahFinderScreen> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final palette = _CompassPalette.of(context);

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          backgroundColor: palette.bg,
          appBar: AppBar(
            title: Text(
              isArabic ? 'اتجاه القبلة' : 'Qiblah Compass',
              style: themeService.getTextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: palette.gold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: palette.gold,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: FutureBuilder<bool?>(
            future: _deviceSupport,
            builder: (_, AsyncSnapshot<bool?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                );
              }
              if (snapshot.hasError) {
                return _ErrorState(
                  message: '${snapshot.error}',
                  palette: palette,
                  themeService: themeService,
                );
              }
              if (snapshot.data == true) {
                return QiblahCompassWidget(
                  isArabic: isArabic,
                  themeService: themeService,
                );
              }
              return _ErrorState(
                message: isArabic
                    ? 'جهازك لا يدعم حساس البوصلة.'
                    : 'Your device does not support the compass sensor.',
                palette: palette,
                themeService: themeService,
              );
            },
          ),
        );
      },
    );
  }
}

// ============================================================================
//  COMPASS WIDGET
// ============================================================================

class QiblahCompassWidget extends StatefulWidget {
  final bool isArabic;
  final ThemeService themeService;

  const QiblahCompassWidget({
    super.key,
    required this.isArabic,
    required this.themeService,
  });

  @override
  State<QiblahCompassWidget> createState() => _QiblahCompassWidgetState();
}

class _QiblahCompassWidgetState extends State<QiblahCompassWidget> {
  // -------- Alignment state --------
  bool _isAligned = false;
  bool _hapticFired = false;
  double _smoothedDiff = 0;
  bool _hasFirstReading = false;

  // -------- Thresholds (degrees) --------
  // Enter aligned within 10°, stay aligned until 18° off.
  static const double _enterDeg = 10.0;
  static const double _exitDeg = 18.0;

  @override
  Widget build(BuildContext context) {
    final palette = _CompassPalette.of(context);

    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          );
        }

        final data = snapshot.data;
        if (data == null) {
          return Center(
            child: Text(
              widget.isArabic
                  ? 'بانتظار بيانات البوصلة...'
                  : 'Waiting for compass data...',
              style: widget.themeService.getTextStyle(
                fontSize: 16,
                color: palette.text.withValues(alpha: 0.7),
              ),
            ),
          );
        }

        // ---------- Angles (unchanged math) ----------
        final compassAngle = data.direction * (math.pi / 180) * -1;
        final qiblahLocal =
            (data.qiblah - data.direction) * (math.pi / 180) * -1;

        // ---------- Alignment detection ----------
        final rawDiff = _wrap180(data.qiblah - data.direction);

        if (!_hasFirstReading) {
          _smoothedDiff = rawDiff;
          _hasFirstReading = true;
        } else {
          // Smooth *in angle space* so we correctly handle the ±180 wrap.
          final delta = _shortestDelta(_smoothedDiff, rawDiff);
          _smoothedDiff = _wrap180(_smoothedDiff + delta * 0.35);
        }

        final absDiff = _smoothedDiff.abs();

        // Hysteresis: harder to enter, easier to leave → no flicker.
        if (_isAligned) {
          if (absDiff > _exitDeg) _isAligned = false;
        } else {
          if (absDiff < _enterDeg) _isAligned = true;
        }
        final aligned = _isAligned;

        // Haptic once per alignment session.
        if (aligned && !_hapticFired) {
          HapticFeedback.heavyImpact();
          _hapticFired = true;
        } else if (!aligned) {
          _hapticFired = false;
        }

        // Proximity 0..1 (1.0 = dead-on, 0.0 = 60°+ off).
        final proximity = (1.0 - (absDiff / 60.0)).clamp(0.0, 1.0);
        final turnRight = _smoothedDiff > 0;

        return Stack(
          fit: StackFit.expand,
          children: [
            // ---------- FULL-SCREEN GREEN FLASH WHEN ALIGNED ----------
            IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: aligned
                        ? [
                            palette.accent.withValues(alpha: 0.22),
                            palette.accent.withValues(alpha: 0.06),
                            Colors.transparent,
                          ]
                        : [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.transparent,
                          ],
                  ),
                ),
              ),
            ),

            // ---------- MAIN COLUMN ----------
            SafeArea(
              child: Column(
                children: [
                  // -------- CELEBRATION BANNER (always occupies top) --------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: _AlignedBanner(
                      visible: aligned,
                      isArabic: widget.isArabic,
                      palette: palette,
                      themeService: widget.themeService,
                    ),
                  ),

                  // -------- COMPASS --------
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _ProximityRing(
                            proximity: proximity,
                            aligned: aligned,
                            palette: palette,
                          ),
                          _AlignedHalo(aligned: aligned, palette: palette),
                          _SmoothAngle(
                            target: compassAngle,
                            builder: (context, angle) => Transform.rotate(
                              angle: angle,
                              child: _CompassBody(
                                palette: palette,
                                qiblahLocal: qiblahLocal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // -------- DIRECTION HINT (hidden while aligned) --------
                  AnimatedSize(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    child: aligned
                        ? const SizedBox(width: double.infinity, height: 0)
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _DirectionalHint(
                              degreesOff: absDiff,
                              turnRight: turnRight,
                              isArabic: widget.isArabic,
                              palette: palette,
                              themeService: widget.themeService,
                            ),
                          ),
                  ),

                  // -------- INFO BAR --------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: _InfoBar(
                      qiblah: data.qiblah,
                      direction: data.direction,
                      offset: absDiff,
                      aligned: aligned,
                      palette: palette,
                      themeService: widget.themeService,
                      isArabic: widget.isArabic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Wraps an angle in degrees to (-180, 180].
  double _wrap180(double deg) {
    double d = deg % 360;
    if (d > 180) d -= 360;
    if (d <= -180) d += 360;
    return d;
  }

  /// Signed shortest arc from `from` to `to` in degrees, range (-180, 180].
  double _shortestDelta(double from, double to) {
    return _wrap180(to - from);
  }
}

// ============================================================================
//  PROXIMITY RING
// ============================================================================

class _ProximityRing extends StatelessWidget {
  final double proximity;
  final bool aligned;
  final _CompassPalette palette;

  const _ProximityRing({
    required this.proximity,
    required this.aligned,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 356,
      height: 356,
      child: CustomPaint(
        painter: _ProximityRingPainter(
          proximity: proximity,
          aligned: aligned,
          color: palette.accent,
          trackColor: palette.gold.withValues(alpha: 0.18),
        ),
      ),
    );
  }
}

class _ProximityRingPainter extends CustomPainter {
  final double proximity;
  final bool aligned;
  final Color color;
  final Color trackColor;

  const _ProximityRingPainter({
    required this.proximity,
    required this.aligned,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = trackColor,
    );

    if (proximity > 0.005) {
      final sweep = 2 * math.pi * proximity;

      // Soft outer glow.
      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = aligned ? 14 : 8
          ..strokeCap = StrokeCap.round
          ..color = color.withValues(alpha: aligned ? 0.40 : 0.22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      // Solid arc.
      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = aligned ? 6 : 5
          ..strokeCap = StrokeCap.round
          ..shader = SweepGradient(
            startAngle: -math.pi / 2,
            endAngle: -math.pi / 2 + 2 * math.pi,
            colors: [
              color.withValues(alpha: 0.55),
              color,
              color.withValues(alpha: 0.55),
            ],
          ).createShader(rect),
      );
    }
  }

  @override
  bool shouldRepaint(_ProximityRingPainter old) =>
      old.proximity != proximity || old.aligned != aligned;
}

// ============================================================================
//  DIRECTIONAL HINT
// ============================================================================

class _DirectionalHint extends StatelessWidget {
  final double degreesOff;
  final bool turnRight;
  final bool isArabic;
  final _CompassPalette palette;
  final ThemeService themeService;

  const _DirectionalHint({
    required this.degreesOff,
    required this.turnRight,
    required this.isArabic,
    required this.palette,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    final label = isArabic
        ? (turnRight ? 'لفّ يميناً' : 'لفّ يساراً')
        : (turnRight ? 'Turn right' : 'Turn left');
    final arrow = turnRight
        ? Icons.turn_right_rounded
        : Icons.turn_left_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: palette.chipBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.gold.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(arrow, color: palette.gold, size: 20),
          const SizedBox(width: 8),
          Text(
            '$label  ${degreesOff.toStringAsFixed(0)}°',
            style: themeService.getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: palette.gold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
//  ALIGNED CELEBRATION BANNER  (full-width, unmissable)
// ============================================================================

class _AlignedBanner extends StatefulWidget {
  final bool visible;
  final bool isArabic;
  final _CompassPalette palette;
  final ThemeService themeService;

  const _AlignedBanner({
    required this.visible,
    required this.isArabic,
    required this.palette,
    required this.themeService,
  });

  @override
  State<_AlignedBanner> createState() => _AlignedBannerState();
}

class _AlignedBannerState extends State<_AlignedBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (widget.visible) _shimmer.repeat();
  }

  @override
  void didUpdateWidget(covariant _AlignedBanner old) {
    super.didUpdateWidget(old);
    if (widget.visible && !old.visible) {
      _shimmer.value = 0;
      _shimmer.repeat();
    } else if (!widget.visible && old.visible) {
      _shimmer.stop();
      _shimmer.value = 0;
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;

    // Sized container so the layout doesn't jump on visibility change.
    return AnimatedSize(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 260),
        opacity: widget.visible ? 1.0 : 0.0,
        child: widget.visible
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      p.accent.withValues(alpha: 0.95),
                      p.accent.withValues(alpha: 0.75),
                    ],
                  ),
                  border: Border.all(
                    color: p.gold.withValues(alpha: 0.9),
                    width: 1.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: p.accent.withValues(alpha: 0.55),
                      blurRadius: 32,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: p.gold.withValues(alpha: 0.35),
                      blurRadius: 16,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mini Kaaba
                    Container(
                      width: 26,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: p.gold.withValues(alpha: 0.85),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Spacer(),
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [p.gold, p.goldSoft, p.gold],
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Shimmering text
                    Flexible(
                      child: AnimatedBuilder(
                        animation: _shimmer,
                        builder: (context, _) {
                          final t = _shimmer.value * 1.6 - 0.3;
                          return ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                              colors: const [
                                Colors.white,
                                Color(0xFFFFF3B0),
                                Colors.white,
                              ],
                              stops: [
                                (t - 0.25).clamp(0.0, 1.0),
                                t.clamp(0.0, 1.0),
                                (t + 0.25).clamp(0.0, 1.0),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              widget.isArabic
                                  ? 'أنت متجه إلى القبلة 🕋'
                                  : "You're facing the Qiblah!",
                              textAlign: TextAlign.center,
                              style: widget.themeService.getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Check badge
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: p.gold.withValues(alpha: 0.7),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: p.accent,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(width: double.infinity, height: 0),
      ),
    );
  }
}

// ============================================================================
//  COMPASS BODY
// ============================================================================

class _CompassBody extends StatelessWidget {
  final _CompassPalette palette;
  final double qiblahLocal;

  const _CompassBody({required this.palette, required this.qiblahLocal});

  @override
  Widget build(BuildContext context) {
    const size = 320.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(size, size),
            painter: _CompassRingPainter(
              gold: palette.gold,
              goldSoft: palette.goldSoft,
            ),
          ),
          Image.asset(
            'assets/compass-icon.png',
            width: 286,
            height: 286,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
          _SmoothAngle(
            target: qiblahLocal,
            builder: (context, angle) => Transform.rotate(
              angle: angle,
              child: _KaabaNeedle(palette: palette),
            ),
          ),
          _CenterPin(palette: palette),
        ],
      ),
    );
  }
}

// ============================================================================
//  SMOOTH ROTATION HELPER
// ============================================================================

class _SmoothAngle extends StatefulWidget {
  final double target;
  final Widget Function(BuildContext context, double angle) builder;

  const _SmoothAngle({required this.target, required this.builder});

  @override
  State<_SmoothAngle> createState() => _SmoothAngleState();
}

class _SmoothAngleState extends State<_SmoothAngle>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final ValueNotifier<double> _value = ValueNotifier<double>(0);
  double _target = 0;

  @override
  void initState() {
    super.initState();
    _value.value = widget.target;
    _target = widget.target;
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration _) {
    final delta = _shortestDelta(_value.value, _target);
    if (delta.abs() < 0.0006) return;
    _value.value = _value.value + delta * 0.18;
  }

  double _shortestDelta(double from, double to) {
    double d = (to - from) % (2 * math.pi);
    if (d > math.pi) d -= 2 * math.pi;
    if (d < -math.pi) d += 2 * math.pi;
    return d;
  }

  @override
  void didUpdateWidget(covariant _SmoothAngle old) {
    super.didUpdateWidget(old);
    _target = widget.target;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _value,
      builder: (context, angle, _) => widget.builder(context, angle),
    );
  }
}

// ============================================================================
//  NEEDLE + KAABA + PIN
// ============================================================================

class _KaabaNeedle extends StatelessWidget {
  final _CompassPalette palette;
  const _KaabaNeedle({required this.palette});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 320,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _KaabaIcon(palette: palette),
              const SizedBox(height: 2),
              Container(
                width: 3,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      palette.goldSoft,
                      palette.gold,
                      palette.gold.withValues(alpha: 0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.gold.withValues(alpha: 0.55),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KaabaIcon extends StatelessWidget {
  final _CompassPalette palette;
  const _KaabaIcon({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: palette.gold.withValues(alpha: 0.55),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: palette.gold.withValues(alpha: 0.35),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Spacer(),
          Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [palette.gold, palette.goldSoft, palette.gold],
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.gold.withValues(alpha: 0.65),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _CenterPin extends StatelessWidget {
  final _CompassPalette palette;
  const _CenterPin({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [palette.goldSoft, palette.gold],
        ),
        boxShadow: [
          BoxShadow(
            color: palette.gold.withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
//  ALIGNED HALO
// ============================================================================

class _AlignedHalo extends StatelessWidget {
  final bool aligned;
  final _CompassPalette palette;

  const _AlignedHalo({required this.aligned, required this.palette});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      width: aligned ? 350 : 330,
      height: aligned ? 350 : 330,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: palette.gold.withValues(alpha: 0.14),
            blurRadius: 50,
            spreadRadius: 6,
          ),
          BoxShadow(
            color: palette.accent.withValues(alpha: aligned ? 0.5 : 0.0),
            blurRadius: 80,
            spreadRadius: 14,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
//  INFO BAR
// ============================================================================

class _InfoBar extends StatelessWidget {
  final double qiblah;
  final double direction;
  final double offset;
  final bool aligned;
  final _CompassPalette palette;
  final ThemeService themeService;
  final bool isArabic;

  const _InfoBar({
    required this.qiblah,
    required this.direction,
    required this.offset,
    required this.aligned,
    required this.palette,
    required this.themeService,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = aligned ? palette.accent : palette.gold;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        color: palette.chipBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.65),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.28),
            blurRadius: 22,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _InfoItem(
            label: isArabic ? 'القبلة' : 'Qiblah',
            value: '${qiblah.toStringAsFixed(1)}°',
            palette: palette,
            themeService: themeService,
            highlight: aligned,
          ),
          Container(
            width: 1,
            height: 28,
            margin: const EdgeInsets.symmetric(horizontal: 18),
            color: palette.gold.withValues(alpha: 0.35),
          ),
          _InfoItem(
            label: isArabic ? 'الاتجاه' : 'Heading',
            value: '${direction.toStringAsFixed(1)}°',
            palette: palette,
            themeService: themeService,
            highlight: aligned,
          ),
          Container(
            width: 1,
            height: 28,
            margin: const EdgeInsets.symmetric(horizontal: 18),
            color: palette.gold.withValues(alpha: 0.35),
          ),
          _InfoItem(
            label: isArabic ? 'الفرق' : 'Offset',
            value: aligned
                ? (isArabic ? 'متوافق ✓' : 'Aligned ✓')
                : '${offset.toStringAsFixed(0)}°',
            palette: palette,
            themeService: themeService,
            highlight: aligned,
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final _CompassPalette palette;
  final ThemeService themeService;
  final bool highlight;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.palette,
    required this.themeService,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = highlight ? palette.accent : palette.gold;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: themeService.getTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: palette.text.withValues(alpha: 0.65),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: themeService.getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
//  ERROR STATE
// ============================================================================

class _ErrorState extends StatelessWidget {
  final String message;
  final _CompassPalette palette;
  final ThemeService themeService;

  const _ErrorState({
    required this.message,
    required this.palette,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.explore_off_rounded,
              size: 56,
              color: palette.gold.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: themeService.getTextStyle(
                fontSize: 15,
                color: palette.text.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
//  RING PAINTER
// ============================================================================

class _CompassRingPainter extends CustomPainter {
  final Color gold;
  final Color goldSoft;

  const _CompassRingPainter({required this.gold, required this.goldSoft});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outerR = size.width / 2 - 6;

    canvas.drawCircle(
      center,
      outerR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = gold.withValues(alpha: 0.45),
    );

    const totalTicks = 72;
    for (var i = 0; i < totalTicks; i++) {
      final isCardinal = i % 18 == 0;
      final isMedium = i % 6 == 0;
      final tickLen = isCardinal ? 14.0 : (isMedium ? 9.0 : 5.0);
      final tickWidth = isCardinal ? 2.4 : (isMedium ? 1.6 : 1.0);
      final angle = (i * 5) * math.pi / 180 - math.pi / 2;

      final dir = Offset(math.cos(angle), math.sin(angle));
      final start = center + dir * outerR;
      final end = center + dir * (outerR - tickLen);

      canvas.drawLine(
        start,
        end,
        Paint()
          ..strokeWidth = tickWidth
          ..strokeCap = StrokeCap.round
          ..color = (isCardinal ? goldSoft : gold)
              .withValues(alpha: isCardinal ? 0.95 : 0.45),
      );
    }

    const labels = ['N', 'E', 'S', 'W'];
    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2 - math.pi / 2;
      final dir = Offset(math.cos(angle), math.sin(angle));
      final pos = center + dir * (outerR - 26);

      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: i == 0 ? goldSoft : gold,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_CompassRingPainter old) =>
      old.gold != gold || old.goldSoft != goldSoft;
}

// ============================================================================
//  THEME PALETTE
// ============================================================================

class _CompassPalette {
  final Color bg;
  final Color gold;
  final Color goldSoft;
  final Color accent;
  final Color text;
  final Color chipBg;

  const _CompassPalette({
    required this.bg,
    required this.gold,
    required this.goldSoft,
    required this.accent,
    required this.text,
    required this.chipBg,
  });

  static _CompassPalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _CompassPalette(
        bg: Color(0xFF0B3D2E),
        gold: Color(0xFFD4AF37),
        goldSoft: Color(0xFFFFF3B0),
        accent: Color(0xFF4ADE80),
        text: Colors.white,
        chipBg: Color(0xCC000000),
      );
    }
    return const _CompassPalette(
      bg: Color(0xFFFDFBF5),
      gold: Color(0xFFB8860B),
      goldSoft: Color(0xFFD4AF37),
      accent: Color(0xFF16A34A),
      text: Color(0xFF1A1A1A),
      chipBg: Color(0xE6FFFFFF),
    );
  }
}