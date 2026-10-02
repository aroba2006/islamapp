import 'dart:convert';
import 'package:http/http.dart' as http;

class AyahTiming {
  final int ayah;
  final int startTimeMs;
  final int endTimeMs;

  AyahTiming({required this.ayah, required this.startTimeMs, required this.endTimeMs});

  factory AyahTiming.fromJson(Map<String, dynamic> json) {
    return AyahTiming(
      ayah: json['ayah'],
      startTimeMs: json['start_time'],
      endTimeMs: json['end_time'],
    );
  }
}

class TimingService {
  static Future<List<AyahTiming>> fetchTimings(int readId, int surahNumber) async {
    final url = Uri.parse('https://mp3quran.net/api/v3/ayat_timing?surah=$surahNumber&read=$readId');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AyahTiming.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching timings: $e');
    }
    return [];
  }
}