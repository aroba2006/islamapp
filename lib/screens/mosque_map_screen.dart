import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/theme_service.dart';

class MosqueMapScreen extends StatelessWidget {
  final double userLat;
  final double userLng;
  final double mosqueLat;
  final double mosqueLng;
  final String mosqueName;

  const MosqueMapScreen({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.mosqueLat,
    required this.mosqueLng,
    required this.mosqueName,
  });

  Future<void> _openInMaps(BuildContext context, bool isArabic) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=$userLat,$userLng'
      '&destination=$mosqueLat,$mosqueLng'
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

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final userPoint = LatLng(userLat, userLng);
    final mosquePoint = LatLng(mosqueLat, mosqueLng);

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              mosqueName,
              style: themeService.getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).colorScheme.secondary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: FlutterMap(
            options: MapOptions(
              // Fit both the user and the mosque on screen
              initialCameraFit: CameraFit.bounds(
                bounds: LatLngBounds.fromPoints([userPoint, mosquePoint]),
                padding: const EdgeInsets.all(60),
                maxZoom: 17,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.example.islamy_app',
                maxZoom: 18,
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [userPoint, mosquePoint],
                    color: Colors.blue.withValues(alpha: 0.5),
                    strokeWidth: 2,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: userPoint,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                  Marker(
                    point: mosquePoint,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openInMaps(context, isArabic),
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.black,
            icon: const Icon(Icons.directions_rounded),
            label: Text(isArabic ? 'الاتجاهات' : 'Directions'),
          ),
        );
      },
    );
  }
}