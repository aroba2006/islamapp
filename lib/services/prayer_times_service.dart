import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';

class PrayerTimesService {
  
  // Maps common Arabic region names to English for the API
  static String _normalizeCity(String city) {
    final c = city.trim();
    switch (c) {
      // Egypt
      case 'القاهرة': return 'Cairo';
      case 'الإسكندرية': return 'Alexandria';
      case 'الجيزة': return 'Giza';
      case 'القليوبية': return 'Qalyubia';
      case 'الشرقية': return 'Sharqia';
      case 'الدقهلية': return 'Dakahlia';
      case 'البحيرة': return 'Beheira';
      case 'المنيا': return 'Minya';
      case 'الغربية': return 'Gharbia';
      case 'أسيوط': return 'Asyut';
      case 'الموفية': case 'المنوفية': return 'Monufia';
      case 'الفيوم': return 'Faiyum';
      case 'كفر الشيخ': return 'Kafr El Sheikh';
      case 'بني سويف': return 'Beni Suef';
      case 'دمياط': return 'Damietta';
      case 'أسوان': return 'Aswan';
      case 'السويس': return 'Suez';
      case 'الإسماعيلية': return 'Ismailia';
      case 'الأقصر': return 'Luxor';
      case 'قنا': return 'Qena';
      case 'سوهاج': return 'Sohag';
      case 'بورسعيد': return 'Port Said';
      case 'البحر الأحمر': return 'Red Sea';
      case 'الوادي الجديد': return 'New Valley';
      case 'مطروح': return 'Matrouh';
      case 'شمال سيناء': return 'North Sinai';
      case 'جنوب سيناء': return 'South Sinai';
      default: return c;
    }
  }

  static int? _getMethodForCountry(String country) {
    final c = country.toLowerCase();
    if (c.contains('egypt') || c.contains('مصر')) return 5;
    if (c.contains('saudi') || c.contains('سعودية')) return 4;
    if (c.contains('emirates') || c.contains('gulf') || c.contains('qatar') || c.contains('bahrain') || c.contains('kuwait') || c.contains('إمارات')) return 8;
    if (c.contains('pakistan') || c.contains('india') || c.contains('bangladesh')) return 1;
    if (c.contains('turkey') || c.contains('germany')) return 13;
    if (c.contains('france')) return 12;
    if (c.contains('uk') || c.contains('kingdom')) return 2;
    if (c.contains('states') || c.contains('canada')) return 2;
    return null; 
  }

  static Future<PrayerTimes> fetchByCity({required String city, required String country}) async {
    final englishCity = _normalizeCity(city);
    final method = _getMethodForCountry(country);
    
    // Using standard timingsByCity endpoint with reliable English city strings
    String urlString = 'https://api.aladhan.com/v1/timingsByCity?city=${Uri.encodeComponent(englishCity)}&country=${Uri.encodeComponent(country)}';
    
    if (method != null) {
      urlString += '&method=$method';
    }

    final url = Uri.parse(urlString);
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PrayerTimes.fromAladhanJson(data['data']);
    } else {
      throw Exception('Failed to load prayer times: ${response.statusCode}');
    }
  }
}