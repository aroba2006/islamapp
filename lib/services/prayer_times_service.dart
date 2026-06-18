import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';

class PrayerTimesException implements Exception {
  final String message;
  PrayerTimesException(this.message);
  @override
  String toString() => message;
}

/// Wraps calls to the free Aladhan API (https://aladhan.com/prayer-times-api).
class PrayerTimesService {
  static const String _baseUrl = "https://api.aladhan.com/v1/timingsByCity";

  /// Method 3 = Muslim World League (the standard default).
  static const int _calculationMethod = 3;

  /// Fetches today's prayer times for a given city + country.
  /// [city] should be the region/governorate name or capital fallback.
  static Future<PrayerTimes> fetchByCity({
    required String city,
    required String country,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'city': city,
      'country': country,
      'method': '$_calculationMethod',
    });

    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw PrayerTimesException(
            'Could not load prayer times (server error ${response.statusCode}).');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['code'] != 200 || body['data'] == null) {
        throw PrayerTimesException(
            'Prayer times not found for $city, $country.');
      }

      return PrayerTimes.fromAladhanJson(body['data'] as Map<String, dynamic>);
    } on PrayerTimesException {
      rethrow;
    } catch (e) {
      throw PrayerTimesException(
          'Network error while fetching prayer times. Please check your connection.');
    }
  }
}
