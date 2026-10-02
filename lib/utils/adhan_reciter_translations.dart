/// Global translations for Adhan Reciters
class AdhanReciterTranslations {
  static const Map<String, Map<String, String>> reciters = {
    'mishary': {
      'ar': 'مشاري بن راشد العفاسي',
      'en': 'Mishary Al-Afasi',
      'fr': 'Mishary Al-Afasi',
    },
    'nasser': {
      'ar': 'ناصر القطامي',
      'en': 'Nasser Al-Qattami',
      'fr': 'Nasser Al-Qatami',
    },
    'qassas': {
      'ar': 'محمد مروان قصاص',
      'en': 'Mohamed Marawan Qassas',
      'fr': 'Mohamed Al-Qassas',
    },
    'refaat': {
      'ar': 'محمد رفعت',
      'en': 'Mohamed Refaat',
      'fr': 'Mohamed Refaat',
    },
    'tobar': {
      'ar': 'نصر الدين طوبار',
      'en': 'Nasser Al-Tobar',
      'fr': 'Nasser Al-Tobar',
    },
    'basset': {
      'ar': 'عبد الباسط عبد الصمد',
      'en': 'Abdul Basit Abdul Samad',
      'fr': 'Abdul Basit Abdul Samad',
    },
    'hosari': {
      'ar': 'محمود خليل الحصري',
      'en': 'Mahmoud Khalil Al-Hussary',
      'fr': 'Mahmoud Khalil Al-Hussary',
    },
  };

  /// Get reciter name in specified language
  static String getReciterName(String reciterId, String languageCode) {
    const defaultLang = 'en';
    final lang = languageCode.isEmpty ? defaultLang : languageCode;
    
    if (!reciters.containsKey(reciterId)) {
      return reciterId; // Fallback to ID if not found
    }
    
    return reciters[reciterId]?[lang] ?? 
           reciters[reciterId]?[defaultLang] ?? 
           reciterId;
  }

  /// Get all reciters with translations
  static List<Map<String, String>> getAllReciters() {
    return [
      reciters['mishary']!,
      reciters['nasser']!,
      reciters['qassas']!,
      reciters['refaat']!,
      reciters['tobar']!,
      reciters['basset']!,
      reciters['hosari']!,
    ];
  }
}