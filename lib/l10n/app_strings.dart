// ── Language enum ─────────────────────────────────────────────────────────────

enum AppLanguage { arabic, english, spanish, urdu, persian, italian, french, german, russian }

extension AppLanguageExt on AppLanguage {
  String get displayName {
    switch (this) {
      case AppLanguage.arabic:  return 'العربية';
      case AppLanguage.english: return 'English';
      case AppLanguage.spanish: return 'Español';
      case AppLanguage.urdu:    return 'اردو';
      case AppLanguage.persian: return 'فارسی';
      case AppLanguage.italian: return 'Italiano';
      case AppLanguage.french:  return 'Français';
      case AppLanguage.german:  return 'Deutsch';
      case AppLanguage.russian: return 'Русский';
    }
  }

  String get code {
    switch (this) {
      case AppLanguage.arabic:  return 'ar';
      case AppLanguage.english: return 'en';
      case AppLanguage.spanish: return 'es';
      case AppLanguage.urdu:    return 'ur';
      case AppLanguage.persian: return 'fa';
      case AppLanguage.italian: return 'it';
      case AppLanguage.french:  return 'fr';
      case AppLanguage.german:  return 'de';
      case AppLanguage.russian: return 'ru';
    }
  }

  bool get isRtl => this == AppLanguage.arabic || this == AppLanguage.urdu || this == AppLanguage.persian;

  /// Best Google Font for this language (must be declared in pubspec).
  String get fontFamily {
    switch (this) {
      case AppLanguage.arabic:
      case AppLanguage.persian: return 'Scheherazade New';
      case AppLanguage.urdu:    return 'Noto Nastaliq Urdu';
      case AppLanguage.russian: return 'Roboto';
      default:                  return 'Lato';
    }
  }
}

// ── Strings ───────────────────────────────────────────────────────────────────

class AppStrings {
  final AppLanguage lang;
  const AppStrings(this.lang);

  String get appTitle {
    const m = {
      AppLanguage.arabic:  'أوقات الصلاة',
      AppLanguage.english: 'Prayer Times',
      AppLanguage.spanish: 'Tiempos de Oración',
      AppLanguage.urdu:    'نماز کے اوقات',
      AppLanguage.persian: 'اوقات نماز',
      AppLanguage.italian: 'Orari di Preghiera',
      AppLanguage.french:  'Horaires de Prière',
      AppLanguage.german:  'Gebetszeiten',
      AppLanguage.russian: 'Время молитв',
    };
    return m[lang]!;
  }

  String get selectCountry {
    const m = {
      AppLanguage.arabic:  'اختر دولتك للبدء',
      AppLanguage.english: 'Select your country to begin',
      AppLanguage.spanish: 'Selecciona tu país para comenzar',
      AppLanguage.urdu:    'شروع کرنے کے لیے اپنا ملک منتخب کریں',
      AppLanguage.persian: 'کشور خود را برای شروع انتخاب کنید',
      AppLanguage.italian: 'Seleziona il tuo paese per iniziare',
      AppLanguage.french:  'Sélectionnez votre pays pour commencer',
      AppLanguage.german:  'Wähle dein Land, um zu beginnen',
      AppLanguage.russian: 'Выберите страну для начала',
    };
    return m[lang]!;
  }

  String get searchCountries {
    const m = {
      AppLanguage.arabic:  'ابحث عن دولة...',
      AppLanguage.english: 'Search countries...',
      AppLanguage.spanish: 'Buscar países...',
      AppLanguage.urdu:    'ممالک تلاش کریں...',
      AppLanguage.persian: 'جستجوی کشور...',
      AppLanguage.italian: 'Cerca paesi...',
      AppLanguage.french:  'Rechercher des pays...',
      AppLanguage.german:  'Länder suchen...',
      AppLanguage.russian: 'Поиск стран...',
    };
    return m[lang]!;
  }

  String get noCountriesFound {
    const m = {
      AppLanguage.arabic:  'لا توجد دول تطابق بحثك.',
      AppLanguage.english: 'No countries match your search.',
      AppLanguage.spanish: 'Ningún país coincide con tu búsqueda.',
      AppLanguage.urdu:    'آپ کی تلاش سے کوئی ملک مطابقت نہیں رکھتا۔',
      AppLanguage.persian: 'هیچ کشوری با جستجوی شما مطابقت ندارد.',
      AppLanguage.italian: 'Nessun paese corrisponde alla ricerca.',
      AppLanguage.french:  'Aucun pays ne correspond à votre recherche.',
      AppLanguage.german:  'Kein Land entspricht Ihrer Suche.',
      AppLanguage.russian: 'Нет стран, соответствующих поиску.',
    };
    return m[lang]!;
  }

  String get chooseRegion {
    const m = {
      AppLanguage.arabic:  'اختر المنطقة / المحافظة',
      AppLanguage.english: 'Choose your state / governorate',
      AppLanguage.spanish: 'Elige tu estado / provincia',
      AppLanguage.urdu:    'اپنی ریاست / صوبہ منتخب کریں',
      AppLanguage.persian: 'استان / منطقه خود را انتخاب کنید',
      AppLanguage.italian: 'Scegli la tua regione / provincia',
      AppLanguage.french:  'Choisissez votre état / gouvernorat',
      AppLanguage.german:  'Wähle deinen Staat / Bezirk',
      AppLanguage.russian: 'Выберите штат / область',
    };
    return m[lang]!;
  }

  String get fetchingTimes {
    const m = {
      AppLanguage.arabic:  'جارٍ تحميل أوقات الصلاة...',
      AppLanguage.english: 'Fetching prayer times...',
      AppLanguage.spanish: 'Obteniendo horarios de oración...',
      AppLanguage.urdu:    'نماز کے اوقات لوڈ ہو رہے ہیں...',
      AppLanguage.persian: 'در حال دریافت اوقات نماز...',
      AppLanguage.italian: 'Recupero orari di preghiera...',
      AppLanguage.french:  'Récupération des horaires...',
      AppLanguage.german:  'Gebetszeiten werden geladen...',
      AppLanguage.russian: 'Загрузка времени молитв...',
    };
    return m[lang]!;
  }

  String get tryAgain {
    const m = {
      AppLanguage.arabic:  'حاول مجدداً',
      AppLanguage.english: 'Try again',
      AppLanguage.spanish: 'Intentar de nuevo',
      AppLanguage.urdu:    'دوبارہ کوشش کریں',
      AppLanguage.persian: 'دوباره امتحان کنید',
      AppLanguage.italian: 'Riprova',
      AppLanguage.french:  'Réessayer',
      AppLanguage.german:  'Erneut versuchen',
      AppLanguage.russian: 'Попробовать снова',
    };
    return m[lang]!;
  }

  String get settings {
    const m = {
      AppLanguage.arabic:  'الإعدادات',
      AppLanguage.english: 'Settings',
      AppLanguage.spanish: 'Configuración',
      AppLanguage.urdu:    'ترتیبات',
      AppLanguage.persian: 'تنظیمات',
      AppLanguage.italian: 'Impostazioni',
      AppLanguage.french:  'Paramètres',
      AppLanguage.german:  'Einstellungen',
      AppLanguage.russian: 'Настройки',
    };
    return m[lang]!;
  }

  String get languageLabel {
    const m = {
      AppLanguage.arabic:  'اللغة',
      AppLanguage.english: 'Language',
      AppLanguage.spanish: 'Idioma',
      AppLanguage.urdu:    'زبان',
      AppLanguage.persian: 'زبان',
      AppLanguage.italian: 'Lingua',
      AppLanguage.french:  'Langue',
      AppLanguage.german:  'Sprache',
      AppLanguage.russian: 'Язык',
    };
    return m[lang]!;
  }

  String get adhanCallerLabel {
    const m = {
      AppLanguage.arabic:  'المؤذن',
      AppLanguage.english: 'Adhan Caller',
      AppLanguage.spanish: 'Llamador al Rezo',
      AppLanguage.urdu:    'اذان دینے والا',
      AppLanguage.persian: 'مؤذن',
      AppLanguage.italian: 'Chiamante alla Preghiera',
      AppLanguage.french:  'Appelant à la Prière',
      AppLanguage.german:  'Gebetsrufer',
      AppLanguage.russian: 'Муэдзин',
    };
    return m[lang]!;
  }

  String get adhanNote {
    const m = {
      AppLanguage.arabic:  'سيُشغَّل الأذان عند دخول وقت الصلاة',
      AppLanguage.english: 'Adhan will play when prayer time begins',
      AppLanguage.spanish: 'El adhan sonará al comenzar la oración',
      AppLanguage.urdu:    'نماز کے وقت اذان بجائی جائے گی',
      AppLanguage.persian: 'هنگام فرا رسیدن وقت نماز اذان پخش می‌شود',
      AppLanguage.italian: 'L\'adhan suonerà all\'inizio della preghiera',
      AppLanguage.french:  'L\'adhan jouera au début de la prière',
      AppLanguage.german:  'Der Adhan ertönt bei Gebetsbeginn',
      AppLanguage.russian: 'Азан прозвучит в начале времени молитвы',
    };
    return m[lang]!;
  }

  String get sunriseLabel {
    const m = {
      AppLanguage.arabic:  'الشروق',
      AppLanguage.english: 'Sunrise',
      AppLanguage.spanish: 'Amanecer',
      AppLanguage.urdu:    'طلوع آفتاب',
      AppLanguage.persian: 'طلوع آفتاب',
      AppLanguage.italian: 'Alba',
      AppLanguage.french:  'Lever du soleil',
      AppLanguage.german:  'Sonnenaufgang',
      AppLanguage.russian: 'Восход',
    };
    return m[lang]!;
  }

  String get nextLabel {
    const m = {
      AppLanguage.arabic:  'التالي',
      AppLanguage.english: 'NEXT',
      AppLanguage.spanish: 'PRÓXIMO',
      AppLanguage.urdu:    'اگلا',
      AppLanguage.persian: 'بعدی',
      AppLanguage.italian: 'PROSSIMO',
      AppLanguage.french:  'SUIVANT',
      AppLanguage.german:  'NÄCHSTE',
      AppLanguage.russian: 'СЛЕД',
    };
    return m[lang]!;
  }

  String get timeUntilLabel {
    const m = {
      AppLanguage.arabic:  'الوقت حتى',
      AppLanguage.english: 'Time until',
      AppLanguage.spanish: 'Tiempo hasta',
      AppLanguage.urdu:    'وقت باقی',
      AppLanguage.persian: 'زمان تا',
      AppLanguage.italian: 'Tempo fino a',
      AppLanguage.french:  'Temps jusqu\'à',
      AppLanguage.german:  'Zeit bis',
      AppLanguage.russian: 'Время до',
    };
    return m[lang]!;
  }

  /// Translates a prayer name (English key) into the UI language.
  String prayerName(String en) {
    if (lang == AppLanguage.arabic || lang == AppLanguage.persian || lang == AppLanguage.urdu) {
      const ar = {'Fajr': 'الفجر', 'Dhuhr': 'الظهر', 'Asr': 'العصر', 'Maghrib': 'المغرب', 'Isha': 'العشاء'};
      return ar[en] ?? en;
    }
    return en;
  }
}
