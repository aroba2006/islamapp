import 'dart:convert';
import 'package:http/http.dart' as http;

class NearbyMosque {
  final String name;
  final double latitude;
  final double longitude;

  NearbyMosque({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory NearbyMosque.fromJson(Map<String, dynamic> json) {
    // Safely extract latitude and longitude whether it's a node or a center of a way/relation
    final lat = json['lat'] ?? json['center']?['lat'] ?? 0.0;
    final lon = json['lon'] ?? json['center']?['lon'] ?? 0.0;
    
    return NearbyMosque(
      name: json['tags']?['name'] ?? 'Unnamed Mosque',
      latitude: (lat as num).toDouble(),
      longitude: (lon as num).toDouble(),
    );
  }
}

class OverpassService {
  static Future<List<NearbyMosque>> getNearbyMosques(double lat, double lon) async {
    // Enhanced query to find nodes, ways, and relations, including direct amenity=mosque tags
    final query = """
[out:json];
(
  nwr[amenity=place_of_worship][religion=muslim](around:5000,$lat,$lon);
  nwr[amenity=mosque](around:5000,$lat,$lon);
  nwr[building=mosque](around:5000,$lat,$lon);
);
out center;
""";

    try {
      final response = await http.post(
        Uri.parse("https://overpass-api.de/api/interpreter"),
        headers: {
          // THIS IS THE FIX FOR ERROR 406:
          'User-Agent': 'IslamyApp_Flutter/1.0 (Mobile App)',
          'Accept': '*/*',
        },
        body: query,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception("Server returned code ${response.statusCode}");
      }

      final data = jsonDecode(response.body);
      if (data["elements"] == null) return [];

      return (data["elements"] as List)
          .map((e) => NearbyMosque.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Failed to load mosques: $e");
    }
  }
}