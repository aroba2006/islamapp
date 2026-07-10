import 'package:equatable/equatable.dart';
import 'package:islamy_app/data/quran_data.dart';
import 'package:islamy_app/data/quran_page_mapping.dart';

/// Represents a single page of the Quran Mushaf
class QuranPage extends Equatable {
  final int pageNumber; // 1-604
  final int surahNumber; // 1-114
  final String surahName; // "سورة الفاتحة"
  final String surahNameEn; // "Surah Al-Fatihah"
  final int versesOnPage; // Number of verses on this page
  final String arabicText; // Full Arabic text of the page
  final String englishTranslation; // English translation

  const QuranPage({
    required this.pageNumber,
    required this.surahNumber,
    required this.surahName,
    required this.surahNameEn,
    required this.versesOnPage,
    required this.arabicText,
    required this.englishTranslation,
  });

  @override
  List<Object?> get props => [
    pageNumber,
    surahNumber,
    surahName,
    surahNameEn,
    versesOnPage,
    arabicText,
    englishTranslation,
  ];
}

/// Page metadata for quick lookup
class QuranPageMetadata {
  static const totalPages = 604;

  /// Get verses for a specific page
  /// Returns a list of maps with verse data: {surahNumber, surahNameAr, surahNameEn, verseNumber, verseAr, verseEn, verseFr}
  static List<Map<String, dynamic>> getVersesForPage(int pageNumber) {
    if (pageNumber < 1 || pageNumber > totalPages) return [];

    final verses = <Map<String, dynamic>>[];

    // Find which surahs are on this page
    for (var entry in SURAH_PAGE_MAP.entries) {
      final surahId = entry.key;
      final surahData = entry.value;
      final startPage = surahData['startPage'] as int;
      final endPage = surahData['endPage'] as int;
      final totalVerses = surahData['verses'] as int;

      // Check if this page is within this surah's range
      if (pageNumber >= startPage && pageNumber <= endPage) {
        // Get the surah from QuranData
        final surah = _getSurahFromQuranData(surahId);
        if (surah == null) continue;

        // Calculate which verses appear on this page
        final pagesInSurah = endPage - startPage + 1;
        final pageOffset = pageNumber - startPage;

        // ✅ FIX: Use integer division to avoid boundary gaps
        // This ensures ALL verses are included without gaps or duplicates
        final startVerseIndex = (pageOffset * totalVerses) ~/ pagesInSurah;
        final endVerseIndex = ((pageOffset + 1) * totalVerses) ~/ pagesInSurah;

        // Get the actual verses from the surah
        for (int i = startVerseIndex; i < endVerseIndex && i < surah.versesAr.length; i++) {
          verses.add({
            'surahNumber': surahId,
            'surahNameAr': surah.nameAr,
            'surahNameEn': surah.nameEn,
            'verseNumber': i + 1, // Verse numbering starts at 1
            'verseAr': surah.versesAr[i],
            'verseEn': surah.versesEn.length > i ? surah.versesEn[i] : '',
            'verseFr': surah.versesFr.length > i ? surah.versesFr[i] : '',
          });
        }
      }
    }

    return verses;
  }

  /// Get the surah number for a given page
  static int? getSurahForPage(int pageNumber) {
    if (pageNumber < 1 || pageNumber > totalPages) return null;

    for (var entry in SURAH_PAGE_MAP.entries) {
      final surahId = entry.key;
      final surahData = entry.value;
      if (pageNumber >= surahData['startPage'] && pageNumber <= surahData['endPage']) {
        return surahId;
      }
    }
    return null;
  }

  /// Get the page number for a given surah and verse number
  /// This calculates which page the verse appears on based on verse distribution
  static int getPageForVerse(int surahNumber, int verseNumber) {
    if (surahNumber < 1 || surahNumber > 114) return 1;

    final surahData = SURAH_PAGE_MAP[surahNumber];
    if (surahData == null) return 1;

    final startPage = surahData['startPage'] as int;
    final endPage = surahData['endPage'] as int;
    final totalVerses = surahData['verses'] as int;

    // Clamp verse to valid range
    final clampedVerse = verseNumber.clamp(1, totalVerses);

    // ✅ FIX: Use integer division to match getVersesForPage()
    final pagesInSurah = endPage - startPage + 1;
    final pageOffset = ((clampedVerse - 1) * pagesInSurah) ~/ totalVerses;

    return (startPage + pageOffset).clamp(startPage, endPage);
  }

  /// Get next page number
  static int getNextPage(int currentPage) {
    return currentPage >= totalPages ? totalPages : currentPage + 1;
  }

  /// Get previous page number
  static int getPreviousPage(int currentPage) {
    return currentPage <= 1 ? 1 : currentPage - 1;
  }

  /// Get the starting page of a surah
  static int? getStartPageOfSurah(int surahNumber) {
    return SURAH_PAGE_MAP[surahNumber]?['startPage'];
  }

  /// Get the ending page of a surah
  static int? getEndPageOfSurah(int surahNumber) {
    return SURAH_PAGE_MAP[surahNumber]?['endPage'];
  }

  /// Helper to find a surah in QuranData
  static QuranSurah? _getSurahFromQuranData(int surahId) {
    try {
      for (var juz in QuranData.parts) {
        for (var surah in juz.surahs) {
          if (surah.id == surahId) {
            return surah;
          }
        }
      }
    } catch (e) {
      print('Error finding surah $surahId: $e');
    }
    return null;
  }

  /// Clear any cached data if needed
  static void clearCache() {
    // No caching currently, but keeping for future optimization
  }
}

class SurahInfo {
  final int number;
  final String nameAr;
  final String nameEn;
  final int verseCount;
  final String revelationType;

  const SurahInfo({
    required this.number,
    required this.nameAr,
    required this.nameEn,
    required this.verseCount,
    required this.revelationType,
  });
}

const surahList = [
  SurahInfo(number: 1, nameAr: 'الفاتحة', nameEn: 'Al-Fatihah', verseCount: 7, revelationType: 'Meccan'),
  SurahInfo(number: 2, nameAr: 'البقرة', nameEn: 'Al-Baqarah', verseCount: 286, revelationType: 'Medinan'),
  SurahInfo(number: 3, nameAr: 'آل عمران', nameEn: 'Ali Imran', verseCount: 200, revelationType: 'Medinan'),
  SurahInfo(number: 4, nameAr: 'النساء', nameEn: 'An-Nisa', verseCount: 176, revelationType: 'Medinan'),
  SurahInfo(number: 5, nameAr: 'المائدة', nameEn: 'Al-Ma\'idah', verseCount: 120, revelationType: 'Medinan'),
  SurahInfo(number: 6, nameAr: 'الأنعام', nameEn: 'Al-An\'am', verseCount: 165, revelationType: 'Meccan'),
  SurahInfo(number: 7, nameAr: 'الأعراف', nameEn: 'Al-A\'raf', verseCount: 206, revelationType: 'Meccan'),
  SurahInfo(number: 8, nameAr: 'الأنفال', nameEn: 'Al-Anfal', verseCount: 75, revelationType: 'Medinan'),
  SurahInfo(number: 9, nameAr: 'التوبة', nameEn: 'At-Taubah', verseCount: 129, revelationType: 'Medinan'),
  SurahInfo(number: 10, nameAr: 'يونس', nameEn: 'Yunus', verseCount: 109, revelationType: 'Meccan'),
  SurahInfo(number: 11, nameAr: 'هود', nameEn: 'Hud', verseCount: 123, revelationType: 'Meccan'),
  SurahInfo(number: 12, nameAr: 'يوسف', nameEn: 'Yusuf', verseCount: 111, revelationType: 'Meccan'),
  SurahInfo(number: 13, nameAr: 'الرعد', nameEn: 'Ar-Ra\'d', verseCount: 43, revelationType: 'Medinan'),
  SurahInfo(number: 14, nameAr: 'إبراهيم', nameEn: 'Ibrahim', verseCount: 52, revelationType: 'Meccan'),
  SurahInfo(number: 15, nameAr: 'الحجر', nameEn: 'Al-Hijr', verseCount: 99, revelationType: 'Meccan'),
  SurahInfo(number: 16, nameAr: 'النحل', nameEn: 'An-Nahl', verseCount: 128, revelationType: 'Meccan'),
  SurahInfo(number: 17, nameAr: 'الإسراء', nameEn: 'Al-Isra', verseCount: 111, revelationType: 'Meccan'),
  SurahInfo(number: 18, nameAr: 'الكهف', nameEn: 'Al-Kahf', verseCount: 110, revelationType: 'Meccan'),
  SurahInfo(number: 19, nameAr: 'مريم', nameEn: 'Maryam', verseCount: 98, revelationType: 'Meccan'),
  SurahInfo(number: 20, nameAr: 'طه', nameEn: 'Ta-Ha', verseCount: 135, revelationType: 'Meccan'),
  SurahInfo(number: 21, nameAr: 'الأنبياء', nameEn: 'Al-Anbiya', verseCount: 112, revelationType: 'Meccan'),
  SurahInfo(number: 22, nameAr: 'الحج', nameEn: 'Al-Hajj', verseCount: 78, revelationType: 'Medinan'),
  SurahInfo(number: 23, nameAr: 'المؤمنون', nameEn: 'Al-Mu\'minun', verseCount: 118, revelationType: 'Meccan'),
  SurahInfo(number: 24, nameAr: 'النور', nameEn: 'An-Nur', verseCount: 64, revelationType: 'Medinan'),
  SurahInfo(number: 25, nameAr: 'الفرقان', nameEn: 'Al-Furqan', verseCount: 77, revelationType: 'Meccan'),
  SurahInfo(number: 26, nameAr: 'الشعراء', nameEn: 'Ash-Shu\'ara', verseCount: 227, revelationType: 'Meccan'),
  SurahInfo(number: 27, nameAr: 'النمل', nameEn: 'An-Naml', verseCount: 93, revelationType: 'Meccan'),
  SurahInfo(number: 28, nameAr: 'القصص', nameEn: 'Al-Qasas', verseCount: 88, revelationType: 'Meccan'),
  SurahInfo(number: 29, nameAr: 'العنكبوت', nameEn: 'Al-\'Ankabut', verseCount: 69, revelationType: 'Meccan'),
  SurahInfo(number: 30, nameAr: 'الروم', nameEn: 'Ar-Rum', verseCount: 60, revelationType: 'Meccan'),
  SurahInfo(number: 31, nameAr: 'لقمان', nameEn: 'Luqman', verseCount: 34, revelationType: 'Meccan'),
  SurahInfo(number: 32, nameAr: 'السجدة', nameEn: 'As-Sajdah', verseCount: 30, revelationType: 'Meccan'),
  SurahInfo(number: 33, nameAr: 'الأحزاب', nameEn: 'Al-Ahzab', verseCount: 73, revelationType: 'Medinan'),
  SurahInfo(number: 34, nameAr: 'سبأ', nameEn: 'Saba', verseCount: 54, revelationType: 'Meccan'),
  SurahInfo(number: 35, nameAr: 'فاطر', nameEn: 'Fatir', verseCount: 45, revelationType: 'Meccan'),
  SurahInfo(number: 36, nameAr: 'يس', nameEn: 'Ya-Sin', verseCount: 83, revelationType: 'Meccan'),
  SurahInfo(number: 37, nameAr: 'الصافات', nameEn: 'As-Saffat', verseCount: 182, revelationType: 'Meccan'),
  SurahInfo(number: 38, nameAr: 'ص', nameEn: 'Sad', verseCount: 88, revelationType: 'Meccan'),
  SurahInfo(number: 39, nameAr: 'الزمر', nameEn: 'Az-Zumar', verseCount: 75, revelationType: 'Meccan'),
  SurahInfo(number: 40, nameAr: 'غافر', nameEn: 'Ghafir', verseCount: 85, revelationType: 'Meccan'),
  SurahInfo(number: 41, nameAr: 'فصلت', nameEn: 'Fussilat', verseCount: 54, revelationType: 'Meccan'),
  SurahInfo(number: 42, nameAr: 'الشورى', nameEn: 'Ash-Shura', verseCount: 53, revelationType: 'Meccan'),
  SurahInfo(number: 43, nameAr: 'الزخرف', nameEn: 'Az-Zukhruf', verseCount: 89, revelationType: 'Meccan'),
  SurahInfo(number: 44, nameAr: 'الدخان', nameEn: 'Ad-Dukhan', verseCount: 59, revelationType: 'Meccan'),
  SurahInfo(number: 45, nameAr: 'الجاثية', nameEn: 'Al-Jathiyah', verseCount: 37, revelationType: 'Meccan'),
  SurahInfo(number: 46, nameAr: 'الأحقاف', nameEn: 'Al-Ahqaf', verseCount: 35, revelationType: 'Meccan'),
  SurahInfo(number: 47, nameAr: 'محمد', nameEn: 'Muhammad', verseCount: 38, revelationType: 'Medinan'),
  SurahInfo(number: 48, nameAr: 'الفتح', nameEn: 'Al-Fath', verseCount: 29, revelationType: 'Medinan'),
  SurahInfo(number: 49, nameAr: 'الحجرات', nameEn: 'Al-Hujurat', verseCount: 18, revelationType: 'Medinan'),
  SurahInfo(number: 50, nameAr: 'ق', nameEn: 'Qaf', verseCount: 45, revelationType: 'Meccan'),
  SurahInfo(number: 51, nameAr: 'الذاريات', nameEn: 'Adh-Dhariyat', verseCount: 60, revelationType: 'Meccan'),
  SurahInfo(number: 52, nameAr: 'الطور', nameEn: 'At-Tur', verseCount: 49, revelationType: 'Meccan'),
  SurahInfo(number: 53, nameAr: 'النجم', nameEn: 'An-Najm', verseCount: 62, revelationType: 'Meccan'),
  SurahInfo(number: 54, nameAr: 'القمر', nameEn: 'Al-Qamar', verseCount: 55, revelationType: 'Meccan'),
  SurahInfo(number: 55, nameAr: 'الرحمن', nameEn: 'Ar-Rahman', verseCount: 78, revelationType: 'Medinan'),
  SurahInfo(number: 56, nameAr: 'الواقعة', nameEn: 'Al-Waqi\'ah', verseCount: 96, revelationType: 'Meccan'),
  SurahInfo(number: 57, nameAr: 'الحديد', nameEn: 'Al-Hadid', verseCount: 29, revelationType: 'Medinan'),
  SurahInfo(number: 58, nameAr: 'المجادلة', nameEn: 'Al-Mujadalah', verseCount: 22, revelationType: 'Medinan'),
  SurahInfo(number: 59, nameAr: 'الحشر', nameEn: 'Al-Hashr', verseCount: 24, revelationType: 'Medinan'),
  SurahInfo(number: 60, nameAr: 'الممتحنة', nameEn: 'Al-Mumtahanah', verseCount: 13, revelationType: 'Medinan'),
  SurahInfo(number: 61, nameAr: 'الصف', nameEn: 'As-Saff', verseCount: 14, revelationType: 'Medinan'),
  SurahInfo(number: 62, nameAr: 'الجمعة', nameEn: 'Al-Jumu\'ah', verseCount: 11, revelationType: 'Medinan'),
  SurahInfo(number: 63, nameAr: 'المنافقون', nameEn: 'Al-Munafiqun', verseCount: 11, revelationType: 'Medinan'),
  SurahInfo(number: 64, nameAr: 'التغابن', nameEn: 'At-Taghabun', verseCount: 18, revelationType: 'Medinan'),
  SurahInfo(number: 65, nameAr: 'الطلاق', nameEn: 'At-Talaq', verseCount: 12, revelationType: 'Medinan'),
  SurahInfo(number: 66, nameAr: 'التحريم', nameEn: 'At-Tahrim', verseCount: 12, revelationType: 'Medinan'),
  SurahInfo(number: 67, nameAr: 'الملك', nameEn: 'Al-Mulk', verseCount: 30, revelationType: 'Meccan'),
  SurahInfo(number: 68, nameAr: 'القلم', nameEn: 'Al-Qalam', verseCount: 52, revelationType: 'Meccan'),
  SurahInfo(number: 69, nameAr: 'الحاقة', nameEn: 'Al-Haqqah', verseCount: 52, revelationType: 'Meccan'),
  SurahInfo(number: 70, nameAr: 'المعارج', nameEn: 'Al-Ma\'arij', verseCount: 44, revelationType: 'Meccan'),
  SurahInfo(number: 71, nameAr: 'نوح', nameEn: 'Nuh', verseCount: 28, revelationType: 'Meccan'),
  SurahInfo(number: 72, nameAr: 'الجن', nameEn: 'Al-Jinn', verseCount: 28, revelationType: 'Meccan'),
  SurahInfo(number: 73, nameAr: 'المزمل', nameEn: 'Al-Muzzammil', verseCount: 20, revelationType: 'Meccan'),
  SurahInfo(number: 74, nameAr: 'المدثر', nameEn: 'Al-Muddaththir', verseCount: 56, revelationType: 'Meccan'),
  SurahInfo(number: 75, nameAr: 'القيامة', nameEn: 'Al-Qiyamah', verseCount: 40, revelationType: 'Meccan'),
  SurahInfo(number: 76, nameAr: 'الإنسان', nameEn: 'Al-Insan', verseCount: 31, revelationType: 'Medinan'),
  SurahInfo(number: 77, nameAr: 'المرسلات', nameEn: 'Al-Mursalat', verseCount: 50, revelationType: 'Meccan'),
  SurahInfo(number: 78, nameAr: 'النبأ', nameEn: 'An-Naba', verseCount: 40, revelationType: 'Meccan'),
  SurahInfo(number: 79, nameAr: 'الناعيات', nameEn: 'An-Nazi\'at', verseCount: 46, revelationType: 'Meccan'),
  SurahInfo(number: 80, nameAr: 'عبس', nameEn: 'Abasa', verseCount: 42, revelationType: 'Meccan'),
  SurahInfo(number: 81, nameAr: 'التكوير', nameEn: 'At-Takwir', verseCount: 29, revelationType: 'Meccan'),
  SurahInfo(number: 82, nameAr: 'الإنفطار', nameEn: 'Al-Infitar', verseCount: 19, revelationType: 'Meccan'),
  SurahInfo(number: 83, nameAr: 'المطففين', nameEn: 'Al-Mutaffifin', verseCount: 36, revelationType: 'Meccan'),
  SurahInfo(number: 84, nameAr: 'الإنشقاق', nameEn: 'Al-Inshiqaq', verseCount: 25, revelationType: 'Meccan'),
  SurahInfo(number: 85, nameAr: 'البروج', nameEn: 'Al-Buruj', verseCount: 22, revelationType: 'Meccan'),
  SurahInfo(number: 86, nameAr: 'الطارق', nameEn: 'At-Tariq', verseCount: 17, revelationType: 'Meccan'),
  SurahInfo(number: 87, nameAr: 'الأعلى', nameEn: 'Al-A\'la', verseCount: 19, revelationType: 'Meccan'),
  SurahInfo(number: 88, nameAr: 'الغاشية', nameEn: 'Al-Ghashiyah', verseCount: 26, revelationType: 'Meccan'),
  SurahInfo(number: 89, nameAr: 'الفجر', nameEn: 'Al-Fajr', verseCount: 30, revelationType: 'Meccan'),
  SurahInfo(number: 90, nameAr: 'البلد', nameEn: 'Al-Balad', verseCount: 20, revelationType: 'Meccan'),
  SurahInfo(number: 91, nameAr: 'الشمس', nameEn: 'Ash-Shams', verseCount: 15, revelationType: 'Meccan'),
  SurahInfo(number: 92, nameAr: 'الليل', nameEn: 'Al-Lail', verseCount: 21, revelationType: 'Meccan'),
  SurahInfo(number: 93, nameAr: 'الضحى', nameEn: 'Ad-Duha', verseCount: 11, revelationType: 'Meccan'),
  SurahInfo(number: 94, nameAr: 'الإنشراح', nameEn: 'Al-Inshirah', verseCount: 8, revelationType: 'Meccan'),
  SurahInfo(number: 95, nameAr: 'التين', nameEn: 'At-Tin', verseCount: 8, revelationType: 'Meccan'),
  SurahInfo(number: 96, nameAr: 'العلق', nameEn: 'Al-Alaq', verseCount: 19, revelationType: 'Meccan'),
  SurahInfo(number: 97, nameAr: 'القدر', nameEn: 'Al-Qadr', verseCount: 5, revelationType: 'Meccan'),
  SurahInfo(number: 98, nameAr: 'البينة', nameEn: 'Al-Bayyinah', verseCount: 8, revelationType: 'Medinan'),
  SurahInfo(number: 99, nameAr: 'الزلزلة', nameEn: 'Az-Zalzalah', verseCount: 8, revelationType: 'Medinan'),
  SurahInfo(number: 100, nameAr: 'العاديات', nameEn: 'Al-Adiyat', verseCount: 11, revelationType: 'Meccan'),
  SurahInfo(number: 101, nameAr: 'القارعة', nameEn: 'Al-Qari\'ah', verseCount: 11, revelationType: 'Meccan'),
  SurahInfo(number: 102, nameAr: 'التكاثر', nameEn: 'At-Takathur', verseCount: 8, revelationType: 'Meccan'),
  SurahInfo(number: 103, nameAr: 'العصر', nameEn: 'Al-Asr', verseCount: 3, revelationType: 'Meccan'),
  SurahInfo(number: 104, nameAr: 'الهمزة', nameEn: 'Al-Humazah', verseCount: 9, revelationType: 'Meccan'),
  SurahInfo(number: 105, nameAr: 'الفيل', nameEn: 'Al-Fil', verseCount: 5, revelationType: 'Meccan'),
  SurahInfo(number: 106, nameAr: 'قريش', nameEn: 'Quraysh', verseCount: 4, revelationType: 'Meccan'),
  SurahInfo(number: 107, nameAr: 'الماعون', nameEn: 'Al-Ma\'un', verseCount: 7, revelationType: 'Meccan'),
  SurahInfo(number: 108, nameAr: 'الكوثر', nameEn: 'Al-Kawthar', verseCount: 3, revelationType: 'Meccan'),
  SurahInfo(number: 109, nameAr: 'الكافرون', nameEn: 'Al-Kafiroon', verseCount: 6, revelationType: 'Meccan'),
  SurahInfo(number: 110, nameAr: 'النصر', nameEn: 'An-Nasr', verseCount: 3, revelationType: 'Medinan'),
  SurahInfo(number: 111, nameAr: 'المسد', nameEn: 'Al-Masad', verseCount: 5, revelationType: 'Meccan'),
  SurahInfo(number: 112, nameAr: 'الإخلاص', nameEn: 'Al-Ikhlas', verseCount: 4, revelationType: 'Meccan'),
  SurahInfo(number: 113, nameAr: 'الفلق', nameEn: 'Al-Falaq', verseCount: 5, revelationType: 'Meccan'),
  SurahInfo(number: 114, nameAr: 'الناس', nameEn: 'An-Nas', verseCount: 6, revelationType: 'Meccan'),
];

/// Get surah info by number
SurahInfo? getSurahInfo(int surahNumber) {
  try {
    return surahList.firstWhere((s) => s.number == surahNumber);
  } catch (e) {
    return null;
  }
}