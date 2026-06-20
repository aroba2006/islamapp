import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Adhan callers ─────────────────────────────────────────────────────────────

class AdhanCaller {
  final String id;
  final String nameAr;
  final String nameEn;
  final String origin;
  const AdhanCaller({required this.id, required this.nameAr, required this.nameEn, required this.origin});
}

const List<AdhanCaller> kAdhanCallers = [
  AdhanCaller(id: 'mishary',    nameAr: 'مشاري راشد العفاسي',       nameEn: 'Mishary Rashid Alafasy',     origin: 'Kuwait'),
  AdhanCaller(id: 'nasser',     nameAr: 'ناصر القطامي',              nameEn: 'Nasser Al-Qatami',           origin: 'Saudi Arabia'),
  AdhanCaller(id: 'ali_mulla',  nameAr: 'علي الملا',                 nameEn: 'Ali Mulla',                  origin: 'Bahrain'),
  AdhanCaller(id: 'abdelbasset',nameAr: 'عبد الباسط عبد الصمد',     nameEn: 'Abdelbasset Abdelsamad',     origin: 'Egypt'),
  AdhanCaller(id: 'maher',      nameAr: 'ماهر المعيقلي',             nameEn: 'Maher Al-Muaiqly',           origin: 'Saudi Arabia · Haram'),
  AdhanCaller(id: 'sudais',     nameAr: 'عبد الرحمن السديس',         nameEn: 'Abdul Rahman Al-Sudais',     origin: 'Saudi Arabia · Haram'),
  AdhanCaller(id: 'shuraim',    nameAr: 'سعود الشريم',               nameEn: 'Saud Al-Shuraim',            origin: 'Saudi Arabia'),
  AdhanCaller(id: 'hussary',    nameAr: 'محمود خليل الحصري',         nameEn: 'Mahmoud Khalil Al-Hussary',  origin: 'Egypt'),
];

// ── AppSettings ChangeNotifier ────────────────────────────────────────────────

class AppSettings extends ChangeNotifier {
  String _languageCode = 'ar';
  String _callerId     = 'mishary';

  String       get languageCode  => _languageCode;
  String       get callerId      => _callerId;
  AdhanCaller  get selectedCaller =>
      kAdhanCallers.firstWhere((c) => c.id == _callerId, orElse: () => kAdhanCallers.first);

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _languageCode = p.getString('lang') ?? 'ar';
    _callerId = p.getString('adhan_caller') ?? 'mishary';
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _languageCode = languageCode;
    (await SharedPreferences.getInstance()).setString('lang', languageCode);
    notifyListeners();
  }

  Future<void> setAdhanCaller(String id) async {
    _callerId = id;
    (await SharedPreferences.getInstance()).setString('adhan_caller', id);
    notifyListeners();
  }
}