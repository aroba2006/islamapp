import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/tafseer_data.dart'; // Make sure this points to your actual data file

class TafseerApiService {
  // The base URL pointing to the fast jsDelivr CDN
  static const String _baseUrl =
      'https://cdn.jsdelivr.net/gh/spa5k/tafsir_api@main/tafsir/ar-tafsir-ibn-kathir';

  /// Fetches an Ayah's Tafseer from Ibn Kathir on-demand
  static Future<TafseerVerse?> fetchIbnKathirVerse({
    required int surahNumber,
    required int verseNumber,
  }) async {
    try {
      // This automatically creates the link (e.g. .../1/1.json)
      final url = Uri.parse('$_baseUrl/$surahNumber/$verseNumber.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the response (UTF-8 ensures the Arabic letters don't turn into gibberish)
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        
        return TafseerVerse(
          verseNumber: verseNumber,
          tafseerAr: data['text'] ?? '',
          tafseerEn: '',
          scholar: 'Ibn Kathir',
        );
      }
    } catch (e) {
      print('Network error fetching Tafseer: $e');
    }
    return null; // Returns null if there's no internet
  }
}