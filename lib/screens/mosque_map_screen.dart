import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';

class _MapConstants {
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color deepGold = Color(0xFFB8860B);
  static const Color softGold = Color(0xFFF0D774);
}

class MosqueMapScreen extends StatefulWidget {
  final double userLat;
  final double userLng;
  final double mosqueLat;
  final double mosqueLng;
  final String mosqueName;
  final double? distanceKm;

  const MosqueMapScreen({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.mosqueLat,
    required this.mosqueLng,
    required this.mosqueName,
    this.distanceKm,
  });

  @override
  State<MosqueMapScreen> createState() => _MosqueMapScreenState();
}

class _MosqueMapScreenState extends State<MosqueMapScreen> {
  final MapController _mapController = MapController();
  static const double _defaultZoom = 15;
  static const double _minZoom = 3;
  static const double _maxZoom = 18;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  double get _distanceKm {
    if (widget.distanceKm != null) return widget.distanceKm!;
    return const Distance().as(
          LengthUnit.Kilometer,
          LatLng(widget.userLat, widget.userLng),
          LatLng(widget.mosqueLat, widget.mosqueLng),
        );
  }

  String _walkTimeText(bool isArabic) {
    final minutes = (_distanceKm / 5.0 * 60).round();
    if (minutes < 1) return isArabic ? 'أقل من دقيقة' : 'less than a minute';
    if (minutes < 60) return isArabic ? '$minutes دقيقة' : '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return isArabic ? '$h س $m د' : '${h}h ${m}m';
  }

  void _zoom(double delta) {
    final camera = _mapController.camera;
    final nextZoom = (camera.zoom + delta).clamp(_minZoom, _maxZoom);
    _mapController.move(camera.center, nextZoom);
  }

  void _recenter() {
    final userPoint = LatLng(widget.userLat, widget.userLng);
    final mosquePoint = LatLng(widget.mosqueLat, widget.mosqueLng);
    try {
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints([userPoint, mosquePoint]),
          padding: const EdgeInsets.all(70),
          maxZoom: 17,
        ),
      );
    } catch (_) {
      _mapController.move(userPoint, _defaultZoom);
    }
  }

  Future<void> _openInMaps(BuildContext context, bool isArabic) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${widget.userLat},${widget.userLng}'
      '&destination=${widget.mosqueLat},${widget.mosqueLng}'
      '&travelmode=walking',
    );

    bool ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? 'تعذر فتح الخرائط' : 'Could not open Maps',
          ),
        ),
      );
    }
  }

  Future<void> _shareLocation(BuildContext context, bool isArabic) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${widget.mosqueLat},${widget.mosqueLng}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic ? 'تعذر فتح الرابط' : 'Could not open link',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final userPoint = LatLng(widget.userLat, widget.userLng);
    final mosquePoint = LatLng(widget.mosqueLat, widget.mosqueLng);

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.mosqueName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: themeService.getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  isArabic ? 'الاتجاهات على الخريطة' : 'Directions on the map',
                  style: themeService.getTextStyle(
                    fontSize: 11,
                    color: AppTheme.getOnBackgroundColor(context)
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).colorScheme.secondary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                tooltip: isArabic ? 'مشاركة' : 'Share',
                icon: const Icon(Icons.share_outlined),
                onPressed: () => _shareLocation(context, isArabic),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCameraFit: CameraFit.bounds(
                    bounds: LatLngBounds.fromPoints([userPoint, mosquePoint]),
                    padding: const EdgeInsets.all(70),
                    maxZoom: 17,
                  ),
                  minZoom: _minZoom,
                  maxZoom: _maxZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                    userAgentPackageName: 'com.example.islamy_app',
                    maxZoom: _maxZoom,
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [userPoint, mosquePoint],
                        color: _MapConstants.primaryGold.withValues(alpha: 0.85),
                        strokeWidth: 4,
                        borderColor: Colors.black.withValues(alpha: 0.25),
                        borderStrokeWidth: 1.5,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: userPoint,
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        child: _MarkerPin(
                          icon: Icons.my_location_rounded,
                          color: Colors.blue,
                          pulse: true,
                        ),
                      ),
                      Marker(
                        point: mosquePoint,
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        child: const _MarkerPin(
                          icon: Icons.mosque_rounded,
                          color: _MapConstants.primaryGold,
                          pulse: false,
                          large: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Zoom / recenter controls
              Positioned(
                right: 14,
                bottom: 220,
                child: Column(
                  children: [
                    _MapControlButton(
                      icon: Icons.add_rounded,
                      onTap: () => _zoom(1),
                      tooltip: isArabic ? 'تكبير' : 'Zoom in',
                    ),
                    const SizedBox(height: 8),
                    _MapControlButton(
                      icon: Icons.remove_rounded,
                      onTap: () => _zoom(-1),
                      tooltip: isArabic ? 'تصغير' : 'Zoom out',
                    ),
                    const SizedBox(height: 8),
                    _MapControlButton(
                      icon: Icons.center_focus_strong_rounded,
                      onTap: _recenter,
                      tooltip: isArabic ? 'توسيط' : 'Recenter',
                      highlight: true,
                    ),
                  ],
                ),
              ),

              // Bottom info card
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: _BottomInfoCard(
                  isArabic: isArabic,
                  mosqueName: widget.mosqueName,
                  distanceKm: _distanceKm,
                  walkTime: _walkTimeText(isArabic),
                  onNavigate: () => _openInMaps(context, isArabic),
                  themeService: themeService,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ───────────────────────── Marker pin ─────────────────────────

class _MarkerPin extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool pulse;
  final bool large;

  const _MarkerPin({
    required this.icon,
    required this.color,
    this.pulse = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = large ? 40.0 : 30.0;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (pulse)
          Container(
            width: size + 16,
            height: size + 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.18),
            ),
          ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color, width: 2.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: size * 0.55),
        ),
      ],
    );
  }
}

// ───────────────────────── Map control ─────────────────────────

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool highlight;

  const _MapControlButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: highlight
            ? _MapConstants.primaryGold
            : Theme.of(context).scaffoldBackgroundColor,
        elevation: 3,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(
              icon,
              size: 20,
              color: highlight ? Colors.black : _MapConstants.primaryGold,
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Bottom info card ─────────────────────────

class _BottomInfoCard extends StatelessWidget {
  final bool isArabic;
  final String mosqueName;
  final double distanceKm;
  final String walkTime;
  final VoidCallback onNavigate;
  final ThemeService themeService;

  const _BottomInfoCard({
    required this.isArabic,
    required this.mosqueName,
    required this.distanceKm,
    required this.walkTime,
    required this.onNavigate,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    final onBg = AppTheme.getOnBackgroundColor(context);
    final gold = _MapConstants.primaryGold;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: gold.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
  width: 44,
  height: 44,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: const LinearGradient(
      colors: [
        _MapConstants.softGold,
        _MapConstants.primaryGold,
        _MapConstants.deepGold,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: gold.withValues(alpha: 0.4),
        blurRadius: 10,
      ),
    ],
  ),                                    // <-- BoxDecoration closes here
  padding: const EdgeInsets.all(2),     // <-- padding belongs to Container
  child: Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Theme.of(context).scaffoldBackgroundColor,
    ),
    child: Icon(
      Icons.mosque_rounded,
      color: _MapConstants.primaryGold,
      size: 22,
    ),
  ),
),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mosqueName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: themeService.getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: onBg,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isArabic
                          ? 'أقرب مسار مشي متاح'
                          : 'Fastest walking route',
                      style: themeService.getTextStyle(
                        fontSize: 11,
                        color: onBg.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.straighten_rounded,
                  label: isArabic ? 'المسافة' : 'Distance',
                  value: '${distanceKm.toStringAsFixed(2)} ${isArabic ? 'كم' : 'km'}',
                  themeService: themeService,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricTile(
                  icon: Icons.directions_walk_rounded,
                  label: isArabic ? 'زمن المشي' : 'Walking',
                  value: walkTime,
                  themeService: themeService,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNavigate,
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.directions_rounded),
              label: Text(
                isArabic ? 'ابدأ الاتجاهات' : 'Start Directions',
                style: themeService.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeService themeService;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    final onBg = AppTheme.getOnBackgroundColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: _MapConstants.primaryGold.withValues(alpha: 0.08),
        border: Border.all(
          color: _MapConstants.primaryGold.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _MapConstants.primaryGold),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: themeService.getTextStyle(
                    fontSize: 10,
                    color: onBg.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: themeService.getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: onBg,
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