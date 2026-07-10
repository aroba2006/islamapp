// QURAN PAGE TO SURAH MAPPING (Egyptian Standard - 604 Pages)
// Fully corrected start and end pages for all 114 Surahs.

const Map<int, Map<String, dynamic>> SURAH_PAGE_MAP = {
  1: {'nameAr': 'الفَاتِحَة', 'nameEn': 'Al-Faatiha', 'type': 'Meccan', 'verses': 7, 'startPage': 1, 'endPage': 1},
  2: {'nameAr': 'البَقَرَة', 'nameEn': 'Al-Baqara', 'type': 'Medinan', 'verses': 286, 'startPage': 2, 'endPage': 49},
  3: {'nameAr': 'آل عِمْرَان', 'nameEn': 'Aal-E-Imraan', 'type': 'Medinan', 'verses': 200, 'startPage': 50, 'endPage': 76},
  4: {'nameAr': 'النِّسَاء', 'nameEn': 'An-Nisa', 'type': 'Medinan', 'verses': 176, 'startPage': 77, 'endPage': 106},
  5: {'nameAr': 'المَائِدَة', 'nameEn': 'Al-Maida', 'type': 'Medinan', 'verses': 120, 'startPage': 106, 'endPage': 127},
  6: {'nameAr': 'الأَنْعَام', 'nameEn': 'Al-Anam', 'type': 'Meccan', 'verses': 165, 'startPage': 128, 'endPage': 150},
  7: {'nameAr': 'الأَعْرَاف', 'nameEn': 'Al-Araf', 'type': 'Meccan', 'verses': 206, 'startPage': 151, 'endPage': 176},
  8: {'nameAr': 'الأَنْفَال', 'nameEn': 'Al-Anfal', 'type': 'Medinan', 'verses': 75, 'startPage': 177, 'endPage': 186},
  9: {'nameAr': 'التَّوْبَة', 'nameEn': 'At-Tawba', 'type': 'Medinan', 'verses': 129, 'startPage': 187, 'endPage': 207},
  10: {'nameAr': 'يُونُس', 'nameEn': 'Yunus', 'type': 'Meccan', 'verses': 109, 'startPage': 208, 'endPage': 221},
  11: {'nameAr': 'هُود', 'nameEn': 'Hood', 'type': 'Meccan', 'verses': 123, 'startPage': 221, 'endPage': 235},
  12: {'nameAr': 'يُوسُف', 'nameEn': 'Yusuf', 'type': 'Meccan', 'verses': 111, 'startPage': 235, 'endPage': 248},
  13: {'nameAr': 'الرَّعْد', 'nameEn': 'Ar-Rad', 'type': 'Medinan', 'verses': 43, 'startPage': 249, 'endPage': 255},
  14: {'nameAr': 'إِبْرَاهِيم', 'nameEn': 'Ibrahim', 'type': 'Meccan', 'verses': 52, 'startPage': 255, 'endPage': 261},
  15: {'nameAr': 'الحِجْر', 'nameEn': 'Al-Hijr', 'type': 'Meccan', 'verses': 99, 'startPage': 262, 'endPage': 267},
  16: {'nameAr': 'النَّحْل', 'nameEn': 'An-Nahl', 'type': 'Meccan', 'verses': 128, 'startPage': 267, 'endPage': 281},
  17: {'nameAr': 'الإِسْرَاء', 'nameEn': 'Al-Isra', 'type': 'Meccan', 'verses': 111, 'startPage': 282, 'endPage': 293},
  18: {'nameAr': 'الكَهْف', 'nameEn': 'Al-Kahf', 'type': 'Meccan', 'verses': 110, 'startPage': 293, 'endPage': 304},
  19: {'nameAr': 'مَرْيَم', 'nameEn': 'Maryam', 'type': 'Meccan', 'verses': 98, 'startPage': 305, 'endPage': 312},
  20: {'nameAr': 'طَه', 'nameEn': 'Taha', 'type': 'Meccan', 'verses': 135, 'startPage': 312, 'endPage': 321},
  21: {'nameAr': 'الأَنْبِيَاء', 'nameEn': 'Al-Anbiya', 'type': 'Meccan', 'verses': 112, 'startPage': 322, 'endPage': 331},
  22: {'nameAr': 'الحَجّ', 'nameEn': 'Al-Hajj', 'type': 'Medinan', 'verses': 78, 'startPage': 332, 'endPage': 341},
  23: {'nameAr': 'المُؤْمِنُون', 'nameEn': 'Al-Muminun', 'type': 'Meccan', 'verses': 118, 'startPage': 342, 'endPage': 349},
  24: {'nameAr': 'النُّور', 'nameEn': 'An-Nur', 'type': 'Medinan', 'verses': 64, 'startPage': 350, 'endPage': 359},
  25: {'nameAr': 'الفُرْقَان', 'nameEn': 'Al-Furqan', 'type': 'Meccan', 'verses': 77, 'startPage': 359, 'endPage': 366},
  26: {'nameAr': 'الشُّعَرَاء', 'nameEn': 'Ash-Shuara', 'type': 'Meccan', 'verses': 227, 'startPage': 367, 'endPage': 376},
  27: {'nameAr': 'النَّمْل', 'nameEn': 'An-Naml', 'type': 'Meccan', 'verses': 93, 'startPage': 377, 'endPage': 385},
  28: {'nameAr': 'القَصَص', 'nameEn': 'Al-Qasas', 'type': 'Meccan', 'verses': 88, 'startPage': 385, 'endPage': 396},
  29: {'nameAr': 'العَنْكَبُوت', 'nameEn': 'Al-Ankabut', 'type': 'Meccan', 'verses': 69, 'startPage': 396, 'endPage': 404},
  30: {'nameAr': 'الرُّوم', 'nameEn': 'Ar-Rum', 'type': 'Meccan', 'verses': 60, 'startPage': 404, 'endPage': 410},
  31: {'nameAr': 'لُقْمَان', 'nameEn': 'Luqman', 'type': 'Meccan', 'verses': 34, 'startPage': 411, 'endPage': 414},
  32: {'nameAr': 'السَّجْدَة', 'nameEn': 'As-Sajda', 'type': 'Meccan', 'verses': 30, 'startPage': 415, 'endPage': 417},
  33: {'nameAr': 'الأَحْزَاب', 'nameEn': 'Al-Ahzab', 'type': 'Medinan', 'verses': 73, 'startPage': 418, 'endPage': 427},
  34: {'nameAr': 'سَبَأ', 'nameEn': 'Saba', 'type': 'Meccan', 'verses': 54, 'startPage': 428, 'endPage': 434},
  35: {'nameAr': 'فَاطِر', 'nameEn': 'Fatir', 'type': 'Meccan', 'verses': 45, 'startPage': 434, 'endPage': 440},
  36: {'nameAr': 'يَس', 'nameEn': 'Ya-Sin', 'type': 'Meccan', 'verses': 83, 'startPage': 440, 'endPage': 445},
  37: {'nameAr': 'الصَّافَّات', 'nameEn': 'As-Saffat', 'type': 'Meccan', 'verses': 182, 'startPage': 446, 'endPage': 452},
  38: {'nameAr': 'ص', 'nameEn': 'Sad', 'type': 'Meccan', 'verses': 88, 'startPage': 453, 'endPage': 458},
  39: {'nameAr': 'الزُّمَر', 'nameEn': 'Az-Zumar', 'type': 'Meccan', 'verses': 75, 'startPage': 458, 'endPage': 467},
  40: {'nameAr': 'غَافِر', 'nameEn': 'Ghafir', 'type': 'Meccan', 'verses': 85, 'startPage': 467, 'endPage': 476},
  41: {'nameAr': 'فُصِّلَت', 'nameEn': 'Fussilat', 'type': 'Meccan', 'verses': 54, 'startPage': 477, 'endPage': 482},
  42: {'nameAr': 'الشُّورَى', 'nameEn': 'Ash-Shura', 'type': 'Meccan', 'verses': 53, 'startPage': 483, 'endPage': 489},
  43: {'nameAr': 'الزُّخْرُف', 'nameEn': 'Az-Zukhruf', 'type': 'Meccan', 'verses': 89, 'startPage': 489, 'endPage': 495},
  44: {'nameAr': 'الدُّخَان', 'nameEn': 'Ad-Dukhan', 'type': 'Meccan', 'verses': 59, 'startPage': 496, 'endPage': 498},
  45: {'nameAr': 'الجَاثِيَة', 'nameEn': 'Al-Jathiyah', 'type': 'Meccan', 'verses': 37, 'startPage': 499, 'endPage': 502},
  46: {'nameAr': 'الأَحْقَاف', 'nameEn': 'Al-Ahqaf', 'type': 'Meccan', 'verses': 35, 'startPage': 502, 'endPage': 506},
  47: {'nameAr': 'مُحَمَّد', 'nameEn': 'Muhammad', 'type': 'Medinan', 'verses': 38, 'startPage': 507, 'endPage': 510},
  48: {'nameAr': 'الفَتْح', 'nameEn': 'Al-Fath', 'type': 'Medinan', 'verses': 29, 'startPage': 511, 'endPage': 515},
  49: {'nameAr': 'الحُجُرَات', 'nameEn': 'Al-Hujurat', 'type': 'Medinan', 'verses': 18, 'startPage': 515, 'endPage': 517},
  50: {'nameAr': 'ق', 'nameEn': 'Qaf', 'type': 'Meccan', 'verses': 45, 'startPage': 518, 'endPage': 520},
  51: {'nameAr': 'الذَّارِيَات', 'nameEn': 'Adh-Dhariyat', 'type': 'Meccan', 'verses': 60, 'startPage': 520, 'endPage': 523},
  52: {'nameAr': 'الطُّور', 'nameEn': 'At-Tur', 'type': 'Meccan', 'verses': 49, 'startPage': 523, 'endPage': 525},
  53: {'nameAr': 'النَّجْم', 'nameEn': 'An-Najm', 'type': 'Meccan', 'verses': 62, 'startPage': 526, 'endPage': 528},
  54: {'nameAr': 'القَمَر', 'nameEn': 'Al-Qamar', 'type': 'Meccan', 'verses': 55, 'startPage': 528, 'endPage': 531},
  55: {'nameAr': 'الرَّحْمَن', 'nameEn': 'Ar-Rahman', 'type': 'Meccan', 'verses': 78, 'startPage': 531, 'endPage': 534},
  56: {'nameAr': 'الوَاقِعَة', 'nameEn': 'Al-Waqiah', 'type': 'Meccan', 'verses': 96, 'startPage': 534, 'endPage': 537},
  57: {'nameAr': 'الحَدِيد', 'nameEn': 'Al-Hadid', 'type': 'Medinan', 'verses': 29, 'startPage': 537, 'endPage': 541},
  58: {'nameAr': 'المُجَادِلَة', 'nameEn': 'Al-Mujadila', 'type': 'Medinan', 'verses': 22, 'startPage': 542, 'endPage': 545},
  59: {'nameAr': 'الحَشْر', 'nameEn': 'Al-Hashr', 'type': 'Medinan', 'verses': 24, 'startPage': 545, 'endPage': 548},
  60: {'nameAr': 'الممْتَحَنَة', 'nameEn': 'Al-Mumtahina', 'type': 'Medinan', 'verses': 13, 'startPage': 549, 'endPage': 551},
  61: {'nameAr': 'الصَّف', 'nameEn': 'As-Saff', 'type': 'Medinan', 'verses': 14, 'startPage': 551, 'endPage': 552},
  62: {'nameAr': 'الجُمُعَة', 'nameEn': 'Al-Jumu\'ah', 'type': 'Medinan', 'verses': 11, 'startPage': 553, 'endPage': 554},
  63: {'nameAr': 'المُنَافِقُون', 'nameEn': 'Al-Munafiqun', 'type': 'Medinan', 'verses': 11, 'startPage': 554, 'endPage': 555},
  64: {'nameAr': 'التَّغَابُن', 'nameEn': 'At-Taghabun', 'type': 'Medinan', 'verses': 18, 'startPage': 556, 'endPage': 557},
  65: {'nameAr': 'الطَّلَاق', 'nameEn': 'At-Talaq', 'type': 'Medinan', 'verses': 12, 'startPage': 558, 'endPage': 559},
  66: {'nameAr': 'التَّحْرِيم', 'nameEn': 'At-Tahrim', 'type': 'Medinan', 'verses': 12, 'startPage': 560, 'endPage': 561},
  67: {'nameAr': 'الْمُلْك', 'nameEn': 'Al-Mulk', 'type': 'Meccan', 'verses': 30, 'startPage': 562, 'endPage': 564},
  68: {'nameAr': 'القَلَم', 'nameEn': 'Al-Qalam', 'type': 'Meccan', 'verses': 52, 'startPage': 564, 'endPage': 566},
  69: {'nameAr': 'الحَاقَّة', 'nameEn': 'Al-Haqqah', 'type': 'Meccan', 'verses': 52, 'startPage': 566, 'endPage': 568},
  70: {'nameAr': 'المَعَارِج', 'nameEn': 'Al-Maarij', 'type': 'Meccan', 'verses': 44, 'startPage': 568, 'endPage': 570},
  71: {'nameAr': 'نُوح', 'nameEn': 'Nuh', 'type': 'Meccan', 'verses': 28, 'startPage': 570, 'endPage': 571},
  72: {'nameAr': 'الجِنّ', 'nameEn': 'Al-Jinn', 'type': 'Meccan', 'verses': 28, 'startPage': 572, 'endPage': 573},
  73: {'nameAr': 'المُزَّمِّل', 'nameEn': 'Al-Muzzammil', 'type': 'Meccan', 'verses': 20, 'startPage': 573, 'endPage': 574},
  74: {'nameAr': 'المُدَّثِّر', 'nameEn': 'Al-Muddassir', 'type': 'Meccan', 'verses': 56, 'startPage': 574, 'endPage': 575},
  75: {'nameAr': 'القِيَامَة', 'nameEn': 'Al-Qiyamah', 'type': 'Meccan', 'verses': 40, 'startPage': 575, 'endPage': 577},
  76: {'nameAr': 'الإِنْسَان', 'nameEn': 'Al-Insan', 'type': 'Medinan', 'verses': 31, 'startPage': 577, 'endPage': 578},
  77: {'nameAr': 'المُرْسَلَات', 'nameEn': 'Al-Mursalat', 'type': 'Meccan', 'verses': 50, 'startPage': 578, 'endPage': 581},
  78: {'nameAr': 'النَّبَأ', 'nameEn': 'An-Naba', 'type': 'Meccan', 'verses': 40, 'startPage': 582, 'endPage': 583},
  79: {'nameAr': 'النَّازِعَات', 'nameEn': 'An-Naziat', 'type': 'Meccan', 'verses': 46, 'startPage': 583, 'endPage': 584},
  80: {'nameAr': 'عَبَسَ', 'nameEn': 'Abasa', 'type': 'Meccan', 'verses': 42, 'startPage': 585, 'endPage': 585},
  81: {'nameAr': 'التَّكْوِير', 'nameEn': 'At-Takwir', 'type': 'Meccan', 'verses': 29, 'startPage': 586, 'endPage': 586},
  82: {'nameAr': 'الإِنْفِطَار', 'nameEn': 'Al-Infitar', 'type': 'Meccan', 'verses': 19, 'startPage': 587, 'endPage': 587},
  83: {'nameAr': 'المُطَفِّفِين', 'nameEn': 'Al-Mutaffifin', 'type': 'Meccan', 'verses': 36, 'startPage': 587, 'endPage': 589},
  84: {'nameAr': 'الإِنْشِقَاق', 'nameEn': 'Al-Inshiqaq', 'type': 'Meccan', 'verses': 25, 'startPage': 589, 'endPage': 589},
  85: {'nameAr': 'البُرُوج', 'nameEn': 'Al-Buruj', 'type': 'Meccan', 'verses': 22, 'startPage': 590, 'endPage': 590},
  86: {'nameAr': 'الطَّارِق', 'nameEn': 'At-Tariq', 'type': 'Meccan', 'verses': 17, 'startPage': 591, 'endPage': 591},
  87: {'nameAr': 'الأَعْلَى', 'nameEn': 'Al-Ala', 'type': 'Meccan', 'verses': 19, 'startPage': 591, 'endPage': 592},
  88: {'nameAr': 'الغَاشِيَة', 'nameEn': 'Al-Ghashiyah', 'type': 'Meccan', 'verses': 26, 'startPage': 592, 'endPage': 592},
  89: {'nameAr': 'الفَجْر', 'nameEn': 'Al-Fajr', 'type': 'Meccan', 'verses': 30, 'startPage': 593, 'endPage': 594},
  90: {'nameAr': 'البَلَد', 'nameEn': 'Al-Balad', 'type': 'Meccan', 'verses': 20, 'startPage': 594, 'endPage': 594},
  91: {'nameAr': 'الشَّمْس', 'nameEn': 'Ash-Shams', 'type': 'Meccan', 'verses': 15, 'startPage': 595, 'endPage': 595},
  92: {'nameAr': 'اللَّيْل', 'nameEn': 'Al-Layl', 'type': 'Meccan', 'verses': 21, 'startPage': 595, 'endPage': 596},
  93: {'nameAr': 'الضُّحَى', 'nameEn': 'Ad-Duha', 'type': 'Meccan', 'verses': 11, 'startPage': 596, 'endPage': 596},
  94: {'nameAr': 'الشَّرْح', 'nameEn': 'Ash-Sharh', 'type': 'Meccan', 'verses': 8, 'startPage': 596, 'endPage': 596},
  95: {'nameAr': 'التِّين', 'nameEn': 'At-Tin', 'type': 'Meccan', 'verses': 8, 'startPage': 597, 'endPage': 597},
  96: {'nameAr': 'العَلَق', 'nameEn': 'Al-Alaq', 'type': 'Meccan', 'verses': 19, 'startPage': 597, 'endPage': 597},
  97: {'nameAr': 'القَدْر', 'nameEn': 'Al-Qadr', 'type': 'Meccan', 'verses': 5, 'startPage': 598, 'endPage': 598},
  98: {'nameAr': 'البَيِّنَة', 'nameEn': 'Al-Bayyinah', 'type': 'Medinan', 'verses': 8, 'startPage': 598, 'endPage': 599},
  99: {'nameAr': 'الزَّلْزَلَة', 'nameEn': 'Az-Zalzalah', 'type': 'Medinan', 'verses': 8, 'startPage': 599, 'endPage': 599},
  100: {'nameAr': 'العَادِيَات', 'nameEn': 'Al-Adiyat', 'type': 'Meccan', 'verses': 11, 'startPage': 599, 'endPage': 599},
  101: {'nameAr': 'القَارِعَة', 'nameEn': 'Al-Qaria', 'type': 'Meccan', 'verses': 11, 'startPage': 600, 'endPage': 600},
  102: {'nameAr': 'التَّكَاثُر', 'nameEn': 'At-Takathur', 'type': 'Meccan', 'verses': 8, 'startPage': 600, 'endPage': 600},
  103: {'nameAr': 'العَصْر', 'nameEn': 'Al-Asr', 'type': 'Meccan', 'verses': 3, 'startPage': 601, 'endPage': 601},
  104: {'nameAr': 'الهُمَزَة', 'nameEn': 'Al-Humaza', 'type': 'Meccan', 'verses': 9, 'startPage': 601, 'endPage': 601},
  105: {'nameAr': 'الفِيل', 'nameEn': 'Al-Fil', 'type': 'Meccan', 'verses': 5, 'startPage': 601, 'endPage': 601},
  106: {'nameAr': 'قُرَيْش', 'nameEn': 'Quraish', 'type': 'Meccan', 'verses': 4, 'startPage': 602, 'endPage': 602},
  107: {'nameAr': 'المَاعُون', 'nameEn': 'Al-Maun', 'type': 'Meccan', 'verses': 7, 'startPage': 602, 'endPage': 602},
  108: {'nameAr': 'الكَوْثَر', 'nameEn': 'Al-Kawthar', 'type': 'Meccan', 'verses': 3, 'startPage': 602, 'endPage': 602},
  109: {'nameAr': 'الكَافِرُون', 'nameEn': 'Al-Kafirun', 'type': 'Meccan', 'verses': 6, 'startPage': 603, 'endPage': 603},
  110: {'nameAr': 'النَّصْر', 'nameEn': 'An-Nasr', 'type': 'Medinan', 'verses': 3, 'startPage': 603, 'endPage': 603},
  111: {'nameAr': 'المَسَد', 'nameEn': 'Al-Masad', 'type': 'Meccan', 'verses': 5, 'startPage': 603, 'endPage': 603},
  112: {'nameAr': 'الإِخْلَاص', 'nameEn': 'Al-Ikhlaas', 'type': 'Meccan', 'verses': 4, 'startPage': 604, 'endPage': 604},
  113: {'nameAr': 'الفَلَق', 'nameEn': 'Al-Falaq', 'type': 'Meccan', 'verses': 5, 'startPage': 604, 'endPage': 604},
  114: {'nameAr': 'النَّاس', 'nameEn': 'An-Naas', 'type': 'Meccan', 'verses': 6, 'startPage': 604, 'endPage': 604},
};

/// Helper function to get surah info from page number
Map<String, dynamic>? getSurahInfoFromPage(int pageNumber) {
  if (pageNumber < 1 || pageNumber > 604) return null;

  // IMPORTANT: Iterating in reverse ensures that if a page contains the 
  // end of one Surah and the beginning of another (e.g., Page 312), 
  // the App Bar prioritizes showing the NEW Surah instead of the old one.
  for (var entry in SURAH_PAGE_MAP.entries.toList().reversed) {
    final surahData = entry.value;
    if (pageNumber >= surahData['startPage'] && pageNumber <= surahData['endPage']) {
      return {
        'surahNumber': entry.key,
        ...surahData,
      };
    }
  }
  return null;
}

/// Helper function to get surah info by surah number
Map<String, dynamic>? getSurahInfo(int surahNumber) {
  return SURAH_PAGE_MAP[surahNumber];
}

/// Get the Arabic name of a surah
String? getSurahNameAr(int surahNumber) {
  return SURAH_PAGE_MAP[surahNumber]?['nameAr'];
}

/// Get the English name of a surah
String? getSurahNameEn(int surahNumber) {
  return SURAH_PAGE_MAP[surahNumber]?['nameEn'];
}

/// Get the type (Meccan/Medinan) of a surah
String? getSurahType(int surahNumber) {
  return SURAH_PAGE_MAP[surahNumber]?['type'];
}