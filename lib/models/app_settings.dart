import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';

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
  AppLanguage _language   = AppLanguage.arabic;
  String      _callerId   = 'mishary';

  AppLanguage  get language      => _language;
  String       get callerId      => _callerId;
  AppStrings   get str           => AppStrings(_language);
  AdhanCaller  get selectedCaller =>
      kAdhanCallers.firstWhere((c) => c.id == _callerId, orElse: () => kAdhanCallers.first);

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final code = p.getString('lang') ?? 'ar';
    _language = AppLanguage.values.firstWhere((l) => l.code == code, orElse: () => AppLanguage.arabic);
    _callerId = p.getString('adhan_caller') ?? 'mishary';
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    (await SharedPreferences.getInstance()).setString('lang', lang.code);
    notifyListeners();
  }

  Future<void> setAdhanCaller(String id) async {
    _callerId = id;
    (await SharedPreferences.getInstance()).setString('adhan_caller', id);
    notifyListeners();
  }
}
