import 'dart:ui';
import 'package:flutter/material.dart';

class PrayerNotificationPopup extends StatefulWidget {
  final String prayerName;
  final VoidCallback onDismiss;
  final VoidCallback onStopAdhan;

  const PrayerNotificationPopup({
    super.key,
    required this.prayerName,
    required this.onDismiss,
    required this.onStopAdhan,
  });

  @override
  State<PrayerNotificationPopup> createState() =>
      _PrayerNotificationPopupState();
}

class _PrayerNotificationPopupState extends State<PrayerNotificationPopup>
    with TickerProviderStateMixin {
  late AnimationController _enterCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _progressCtrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _goldLight = Color(0xFFE8C547);
  static const Duration _visibleDuration = Duration(seconds: 8);

  @override
  void initState() {
    super.initState();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _progressCtrl = AnimationController(
      vsync: this,
      duration: _visibleDuration,
    )..forward();

    _slide = Tween<Offset>(
      begin: const Offset(0, -1.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutBack));

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut),
    );

    _enterCtrl.forward();

    _progressCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _pulseCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (!mounted) return;
    _progressCtrl.stop();
    _enterCtrl.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  // ─────────────────────────── Localization ───────────────────────────

  String _localizedPrayerName(String prayer, String lang) {
    final p = prayer.toLowerCase();
    if (lang == 'ar') {
      if (p.contains('fajr')) return 'الفجر';
      if (p.contains('sunrise') || p.contains('shurooq')) return 'الشروق';
      if (p.contains('dhuhr') || p.contains('zuhr')) return 'الظهر';
      if (p.contains('asr')) return 'العصر';
      if (p.contains('maghrib')) return 'المغرب';
      if (p.contains('isha')) return 'العشاء';
      if (p.contains('test')) return 'تجربة';
      return prayer;
    }
    if (lang == 'fr') {
      if (p.contains('fajr')) return 'Fajr';
      if (p.contains('sunrise') || p.contains('shurooq')) return 'Chourouk';
      if (p.contains('dhuhr') || p.contains('zuhr')) return 'Dhohr';
      if (p.contains('asr')) return 'Asr';
      if (p.contains('maghrib')) return 'Maghrib';
      if (p.contains('isha')) return 'Icha';
      if (p.contains('test')) return 'Test';
      return prayer;
    }
    if (p.contains('test')) return 'Test';
    return prayer;
  }

  String _title(String lang) {
    if (lang == 'ar') return 'وقت الصلاة';
    if (lang == 'fr') return 'HEURE DE LA PRIÈRE';
    return 'PRAYER TIME';
  }

  String _body(String lang, String prayer) {
    final name = _localizedPrayerName(prayer, lang);
    if (lang == 'ar') return 'حان الآن وقت صلاة $name';
    if (lang == 'fr') return "Il est l'heure de la prière de $name";
    return "It's time for $name";
  }

  String _stopText(String lang) {
    if (lang == 'ar') return 'إيقاف الأذان';
    if (lang == 'fr') return "Arrêter";
    return 'Stop Adhan';
  }

  String _gotItText(String lang) {
    if (lang == 'ar') return 'حسناً';
    if (lang == 'fr') return 'Compris';
    return 'Got It';
  }

  IconData _prayerIcon(String prayer) {
    final p = prayer.toLowerCase();
    if (p.contains('fajr')) return Icons.wb_twilight_rounded;
    if (p.contains('sunrise') || p.contains('shurooq')) {
      return Icons.wb_sunny_outlined;
    }
    if (p.contains('dhuhr') || p.contains('zuhr')) {
      return Icons.wb_sunny_rounded;
    }
    if (p.contains('asr')) return Icons.filter_drama_rounded;
    if (p.contains('maghrib')) return Icons.brightness_medium_rounded;
    if (p.contains('isha')) return Icons.nightlight_round;
    return Icons.notifications_active_rounded;
  }

  // ─────────────────────────── Build ───────────────────────────

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0B3D2E),
                      Color(0xFF082D22),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _gold.withValues(alpha: 0.55),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _gold.withValues(alpha: 0.28),
                      blurRadius: 26,
                      spreadRadius: 1,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ─── Auto-dismiss progress bar ───
                    SizedBox(
                      height: 3,
                      child: AnimatedBuilder(
                        animation: _progressCtrl,
                        builder: (context, _) {
                          final remaining =
                              (1.0 - _progressCtrl.value).clamp(0.0, 1.0);
                          return Align(
                            alignment: isArabic
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: remaining,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [_gold, _goldLight],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      child: Directionality(
                        textDirection: isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ─── Pulsing prayer icon ───
                                AnimatedBuilder(
                                  animation: _pulseCtrl,
                                  builder: (context, _) {
                                    final v = _pulseCtrl.value;
                                    final scale = 1.0 + (v * 0.12);
                                    return Transform.scale(
                                      scale: scale,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              _gold.withValues(alpha: 0.35),
                                              _gold.withValues(alpha: 0.12),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: _gold.withValues(alpha: 0.6),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _gold.withValues(
                                                  alpha: 0.3 + v * 0.25),
                                              blurRadius: 12 + (v * 8),
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          _prayerIcon(widget.prayerName),
                                          color: _gold,
                                          size: 26,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _title(lang),
                                        style: const TextStyle(
                                          color: _gold,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.6,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _localizedPrayerName(
                                            widget.prayerName, lang),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _body(lang, widget.prayerName),
                                        style: TextStyle(
                                          color:
                                              Colors.white.withValues(alpha: 0.75),
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ─── Close (X) ───
                                GestureDetector(
                                  onTap: _dismiss,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.white.withValues(alpha: 0.08),
                                      border: Border.all(
                                        color: _gold.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: _gold.withValues(alpha: 0.9),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // ─── Action buttons ───
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      widget.onStopAdhan();
                                      _dismiss();
                                    },
                                    icon: const Icon(
                                        Icons.stop_circle_rounded,
                                        size: 20),
                                    label: Text(_stopText(lang)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.redAccent.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _dismiss,
                                    icon: const Icon(
                                        Icons.check_circle_rounded,
                                        size: 20),
                                    label: Text(_gotItText(lang)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _gold,
                                      foregroundColor: const Color(0xFF0B3D2E),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}