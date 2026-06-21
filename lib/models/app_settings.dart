import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/quran_reciter_service.dart';

// ── Adhan callers ─────────────────────────────────────────────────────────────

class AdhanCaller {
  final String id;
  final String nameAr;
  final String nameEn;
  final String origin;
  const AdhanCaller({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.origin,
  });
}

const List<AdhanCaller> kAdhanCallers = [
  AdhanCaller(
    id: 'mishary',
    nameAr: 'مشاري راشد العفاسي',
    nameEn: 'Mishary Rashid Alafasy',
    origin: 'Kuwait',
  ),
  AdhanCaller(
    id: 'nasser',
    nameAr: 'ناصر القطامي',
    nameEn: 'Nasser Al-Qatami',
    origin: 'Saudi Arabia',
  ),
  AdhanCaller(
    id: 'ali_mulla',
    nameAr: 'علي الملا',
    nameEn: 'Ali Mulla',
    origin: 'Bahrain',
  ),
  AdhanCaller(
    id: 'abdelbasset',
    nameAr: 'عبد الباسط عبد الصمد',
    nameEn: 'Abdelbasset Abdelsamad',
    origin: 'Egypt',
  ),
  AdhanCaller(
    id: 'maher',
    nameAr: 'ماهر المعيقلي',
    nameEn: 'Maher Al-Muaiqly',
    origin: 'Saudi Arabia · Haram',
  ),
  AdhanCaller(
    id: 'sudais',
    nameAr: 'عبد الرحمن السديس',
    nameEn: 'Abdul Rahman Al-Sudais',
    origin: 'Saudi Arabia · Haram',
  ),
  AdhanCaller(
    id: 'shuraim',
    nameAr: 'سعود الشريم',
    nameEn: 'Saud Al-Shuraim',
    origin: 'Saudi Arabia',
  ),
  AdhanCaller(
    id: 'hussary',
    nameAr: 'محمود خليل الحصري',
    nameEn: 'Mahmoud Khalil Al-Hussary',
    origin: 'Egypt',
  ),
];

// ── AppSettings ChangeNotifier ────────────────────────────────────────────────

/// Enhanced AppSettings with Quran player preferences
class AppSettings extends ChangeNotifier {
  String _languageCode = 'ar';
  String _adhanCallerId = 'mishary';
  String _quranReciterId = 'mishary'; // NEW: Preferred Quran reciter

  String get languageCode => _languageCode;
  String get adhanCallerId => _adhanCallerId;
  String get quranReciterId => _quranReciterId;

  AdhanCaller get selectedAdhanCaller =>
      kAdhanCallers.firstWhere(
        (c) => c.id == _adhanCallerId,
        orElse: () => kAdhanCallers.first,
      );

  /// NEW: Get selected Quran reciter
  QuranReciter? get selectedQuranReciter =>
      QuranReciterService.getReciter(_quranReciterId);

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _languageCode = p.getString('lang') ?? 'ar';
    _adhanCallerId = p.getString('adhan_caller') ?? 'mishary';
    _quranReciterId = p.getString('quran_reciter') ?? 'mishary'; // NEW
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _languageCode = languageCode;
    (await SharedPreferences.getInstance()).setString('lang', languageCode);
    notifyListeners();
  }

  Future<void> setAdhanCaller(String id) async {
    _adhanCallerId = id;
    (await SharedPreferences.getInstance()).setString('adhan_caller', id);
    notifyListeners();
  }

  /// NEW: Set preferred Quran reciter
  Future<void> setQuranReciter(String id) async {
    _quranReciterId = id;
    (await SharedPreferences.getInstance()).setString('quran_reciter', id);
    notifyListeners();
  }
}