import 'package:flutter/material.dart';
import 'package:islamy_app/services/notification_service.dart';

/// In-app notification popup that shows when prayer time arrives
class PrayerNotificationPopup extends StatefulWidget {
  final String prayerName;
  final VoidCallback onDismiss;

  const PrayerNotificationPopup({
    super.key,
    required this.prayerName,
    required this.onDismiss,
  });

  @override
  State<PrayerNotificationPopup> createState() =>
      _PrayerNotificationPopupState();
}

class _PrayerNotificationPopupState extends State<PrayerNotificationPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  // --- Translation Helpers ---
  
  String _getLocalizedPrayerName(String prayer, String lang) {
    final p = prayer.toLowerCase();
    
    if (lang == 'ar') {
      if (p.contains('fajr')) return 'الفجر';
      if (p.contains('sunrise') || p.contains('shurooq')) return 'الشروق';
      if (p.contains('dhuhr') || p.contains('zuhr')) return 'الظهر';
      if (p.contains('asr')) return 'العصر';
      if (p.contains('maghrib')) return 'المغرب';
      if (p.contains('isha')) return 'العشاء';
    } else if (lang == 'fr') {
      if (p.contains('fajr')) return 'Fajr';
      if (p.contains('sunrise') || p.contains('shurooq')) return 'Chourouk';
      if (p.contains('dhuhr') || p.contains('zuhr')) return 'Dhohr';
      if (p.contains('asr')) return 'Asr';
      if (p.contains('maghrib')) return 'Maghrib';
      if (p.contains('isha')) return 'Icha';
    }
    
    // Default fallback
    return prayer;
  }

  String _getTitle(String lang) {
    if (lang == 'ar') return 'وقت الصلاة';
    if (lang == 'fr') return 'Heure de la prière';
    return 'Prayer Time';
  }

  String _getBody(String lang, String prayer) {
    final localizedPrayer = _getLocalizedPrayerName(prayer, lang);
    if (lang == 'ar') return 'حان الآن وقت صلاة $localizedPrayer';
    if (lang == 'fr') return 'Il est l\'heure de la prière de $localizedPrayer';
    return 'It\'s time for $localizedPrayer';
  }

  String _getStopText(String lang) {
    if (lang == 'ar') return 'إيقاف الأذان';
    if (lang == 'fr') return 'Arrêter l\'Adhan';
    return 'Stop Adhan';
  }

  String _getGotItText(String lang) {
    if (lang == 'ar') return 'حسناً';
    if (lang == 'fr') return 'Compris';
    return 'Got It';
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getTitle(lang),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getBody(lang, widget.prayerName),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: _dismiss,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Stop adhan playback
                            NotificationService.stopAdhan();
                            _dismiss();
                          },
                          icon: const Icon(Icons.stop),
                          label: Text(_getStopText(lang)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _dismiss,
                          icon: const Icon(Icons.check),
                          label: Text(_getGotItText(lang)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green.shade700,
                          ),
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
    );
  }
}