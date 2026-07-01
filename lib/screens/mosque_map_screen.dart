import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(mosqueName)),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(mosqueLat, mosqueLng),
          initialZoom: 15,
        ),
        children: [
          // Use Esri WorldImagery (very reliable)
          TileLayer(
            urlTemplate:
                "https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}",
            maxZoom: 18,
          ),
          
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(userLat, userLng),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              Marker(
                point: LatLng(mosqueLat, mosqueLng),
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
          
          // FIX 2: Optional - Add simple routing line between user and mosque
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  LatLng(userLat, userLng),
                  LatLng(mosqueLat, mosqueLng),
                ],
                color: Colors.blue.withValues(alpha: 0.5),
                strokeWidth: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}