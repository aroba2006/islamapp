import 'package:flutter/material.dart';

class GeoTranslations {
  static const Map<String, String> _ar = {
    // === COUNTRIES ===
    'egypt': 'مصر',
    'syria': 'سوريا',
    'saudi arabia': 'السعودية',
    'united arab emirates': 'الإمارات',
    'uae': 'الإمارات',
    'palestine': 'فلسطين',
    'algeria': 'الجزائر',
    'morocco': 'المغرب',
    'iraq': 'العراق',
    'jordan': 'الأردن',
    'lebanon': 'لبنان',
    'yemen': 'اليمن',
    'kuwait': 'الكويت',
    'qatar': 'قطر',
    'oman': 'عُمان',
    'bahrain': 'البحرين',
    'tunisia': 'تونس',
    'libya': 'ليبيا',
    'sudan': 'السودان',

    // === CITIES & REGIONS ===
    'cairo': 'القاهرة',
    'alexandria': 'الإسكندرية',
    'giza': 'الجيزة',
    'damascus': 'دمشق',
    'aleppo': 'حلب',
    'makkah': 'مكة المكرمة',
    'madinah': 'المدينة المنورة',
    'riyadh': 'الرياض',
    'jeddah': 'جدة',
    'dubai': 'دبي',
    'abu dhabi': 'أبو ظبي',
    'sharjah': 'الشارقة',
    'jerusalem': 'القدس',
    'gaza': 'غزة',
    'amman': 'عمان',
    'baghdad': 'بغداد',
    'beirut': 'بيروت',
    'sanaa': 'صنعاء',
    'kuwait city': 'مدينة الكويت',
    'doha': 'الدوحة',
    'muscat': 'مسقط',
    'manama': 'المنامة',
  };

  static const Map<String, String> _fr = {
    // === COUNTRIES ===
    'egypt': 'Égypte',
    'syria': 'Syrie',
    'saudi arabia': 'Arabie Saoudite',
    'united arab emirates': 'Émirats Arabes Unis',
    'uae': 'Émirats',
    'palestine': 'Palestine',
    'algeria': 'Algérie',
    'morocco': 'Maroc',
    'iraq': 'Irak',
    'jordan': 'Jordanie',
    'lebanon': 'Liban',
    'yemen': 'Yémen',

    // === CITIES & REGIONS ===
    'cairo': 'Le Caire',
    'alexandria': 'Alexandrie',
    'damascus': 'Damas',
    'aleppo': 'Alep',
    'makkah': 'La Mecque',
    'madinah': 'Médine',
    'riyadh': 'Riyad',
    'jerusalem': 'Jérusalem',
  };

  /// Translates an English place name to the current app language.
  static String translate(BuildContext context, String englishName) {
    final lang = Localizations.localeOf(context).languageCode;
    final key = englishName.trim().toLowerCase();

    if (lang == 'ar') {
      return _ar[key] ?? englishName; // Returns original English if not found
    }
    if (lang == 'fr') {
      return _fr[key] ?? englishName;
    }
    
    return englishName; // Default to English
  }
}