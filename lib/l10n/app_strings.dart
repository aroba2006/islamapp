import 'package:flutter/material.dart';

/// Language configuration and localization strings
class AppLanguage {
  final String code;
  final String name;
  final String fontFamily;
  final TextDirection textDirection;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.fontFamily,
    required this.textDirection,
  });
}

/// Main strings class for the application
class AppStrings {
  late AppLanguage lang;

  // Prayer Times Screen
  late String prayerTimesTitle;
  late String fajr;
  late String sunrise;
  late String dhuhr;
  late String asr;
  late String maghrib;
  late String isha;
  late String location;
  late String selectCity;

  // Azkar Screen
  late String azkarTitle;
  late String morningAzkar;
  late String eveningAzkar;
  late String noAzkar;

  // Quran Screen
  late String quranTitle;
  late String searchSurah;
  late String surah;
  late String ayah;
  late String translation;

  // Home Screen
  late String homeTitle;
  late String settings;
  late String about;

  // General
  late String ok;
  late String cancel;
  late String save;
  late String delete;
  late String edit;
  late String loading;
  late String error;

  AppStrings({required String languageCode}) {
    _initializeLanguage(languageCode);
  }

  void _initializeLanguage(String languageCode) {
    if (languageCode == 'ar') {
      _setArabic();
    } else if (languageCode == 'fr') {
      _setFrench();
    } else {
      _setEnglish();
    }
  }

  void _setArabic() {
    lang = const AppLanguage(
      code: 'ar',
      name: 'العربية',
      fontFamily: 'Cairo',
      textDirection: TextDirection.rtl,
    );

    // Prayer Times
    prayerTimesTitle = 'أوقات الصلاة';
    fajr = 'الفجر';
    sunrise = 'الشروق';
    dhuhr = 'الظهر';
    asr = 'العصر';
    maghrib = 'المغرب';
    isha = 'العشاء';
    location = 'الموقع';
    selectCity = 'اختر المدينة';

    // Azkar
    azkarTitle = 'الأذكار';
    morningAzkar = 'أذكار الصباح';
    eveningAzkar = 'أذكار المساء';
    noAzkar = 'لا توجد أذكار';

    // Quran
    quranTitle = 'القرآن الكريم';
    searchSurah = 'ابحث عن سورة';
    surah = 'السورة';
    ayah = 'الآية';
    translation = 'الترجمة';

    // Home
    homeTitle = 'الإسلامية';
    settings = 'الإعدادات';
    about = 'حول التطبيق';

    // General
    ok = 'حسناً';
    cancel = 'إلغاء';
    save = 'حفظ';
    delete = 'حذف';
    edit = 'تعديل';
    loading = 'جاري التحميل...';
    error = 'حدث خطأ';
  }

  void _setEnglish() {
    lang = const AppLanguage(
      code: 'en',
      name: 'English',
      fontFamily: 'Roboto',
      textDirection: TextDirection.ltr,
    );

    // Prayer Times
    prayerTimesTitle = 'Prayer Times';
    fajr = 'Fajr';
    sunrise = 'Sunrise';
    dhuhr = 'Dhuhr';
    asr = 'Asr';
    maghrib = 'Maghrib';
    isha = 'Isha';
    location = 'Location';
    selectCity = 'Select City';

    // Azkar
    azkarTitle = 'Azkar';
    morningAzkar = 'Morning Azkar';
    eveningAzkar = 'Evening Azkar';
    noAzkar = 'No Azkar Available';

    // Quran
    quranTitle = 'Holy Quran';
    searchSurah = 'Search Surah';
    surah = 'Surah';
    ayah = 'Ayah';
    translation = 'Translation';

    // Home
    homeTitle = 'Islamic App';
    settings = 'Settings';
    about = 'About';

    // General
    ok = 'OK';
    cancel = 'Cancel';
    save = 'Save';
    delete = 'Delete';
    edit = 'Edit';
    loading = 'Loading...';
    error = 'Error occurred';
  }

  void _setFrench() {
    lang = const AppLanguage(
      code: 'fr',
      name: 'Français',
      fontFamily: 'Roboto',
      textDirection: TextDirection.ltr,
    );

    // Prayer Times
    prayerTimesTitle = 'Horaires de Prière';
    fajr = 'Fajr';
    sunrise = 'Lever du Soleil';
    dhuhr = 'Dhouhr';
    asr = 'Asr';
    maghrib = 'Maghreb';
    isha = 'Icha';
    location = 'Lieu';
    selectCity = 'Sélectionner une Ville';

    // Azkar
    azkarTitle = 'Azkar';
    morningAzkar = 'Azkar du Matin';
    eveningAzkar = 'Azkar du Soir';
    noAzkar = 'Aucun Azkar Disponible';

    // Quran
    quranTitle = 'Saint Coran';
    searchSurah = 'Rechercher une Sourate';
    surah = 'Sourate';
    ayah = 'Verset';
    translation = 'Traduction';

    // Home
    homeTitle = 'Application Islamique';
    settings = 'Paramètres';
    about = 'À Propos';

    // General
    ok = 'OK';
    cancel = 'Annuler';
    save = 'Enregistrer';
    delete = 'Supprimer';
    edit = 'Modifier';
    loading = 'Chargement...';
    error = 'Une erreur est survenue';
  }
}