import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';

class PrayerTimesService {
  static Future<PrayerTimes> fetchByCity({required String city, required String country}) async {
    
    // FIX: Added '&method=5' to the URL to force the Egyptian General Authority calculation.
    // This calculates Fajr at 19.5 degrees, instantly fixing the 7-minute offset universally!
    final url = Uri.parse(
      'https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=5'
    );
    
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PrayerTimes.fromAladhanJson(data['data']);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}