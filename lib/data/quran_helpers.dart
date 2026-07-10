// QURAN HELPER FUNCTIONS & METADATA
// This file contains helper functions and metadata for the Quran app
// Use these functions to properly map pages to surahs and get accurate surah information

import '../data/quran_data.dart';
// TODO: Ensure this import points to the file containing SURAH_PAGE_MAP
import '../data/quran_page_mapping.dart'; 

/// Information about a Surah
class SurahInfo {
  final int surahNumber;
  final String nameAr;
  final String nameEn;
  final int verseCount;
  final String revelationType; // 'Meccan' or 'Medinan'
  final int startPage;
  final int endPage;

  SurahInfo({
    required this.surahNumber,
    required this.nameAr,
    required this.nameEn,
    required this.verseCount,
    required this.revelationType,
    required this.startPage,
    required this.endPage,
  });
}

/// Get surah information for a given page number by reading from SURAH_PAGE_MAP
SurahInfo? getSurahForPage(int pageNumber) {
  if (pageNumber < 1 || pageNumber > 604) return null;

  for (var entry in SURAH_PAGE_MAP.entries) {
    final surahData = entry.value;
    if (pageNumber >= surahData['startPage'] && pageNumber <= surahData['endPage']) {
      return SurahInfo(
        surahNumber: entry.key,
        nameAr: surahData['nameAr'],
        nameEn: surahData['nameEn'],
        verseCount: surahData['verses'],
        revelationType: surahData['type'],
        startPage: surahData['startPage'],
        endPage: surahData['endPage'],
      );
    }
  }
  return null;
}

/// Get surah information by surah number (1-114) by reading from SURAH_PAGE_MAP
SurahInfo? getSurahInfo(int surahNumber) {
  final surahData = SURAH_PAGE_MAP[surahNumber];
  
  if (surahData != null) {
    return SurahInfo(
      surahNumber: surahNumber,
      nameAr: surahData['nameAr'],
      nameEn: surahData['nameEn'],
      verseCount: surahData['verses'],
      revelationType: surahData['type'],
      startPage: surahData['startPage'],
      endPage: surahData['endPage'],
    );
  }
  return null;
}

/// Get the next page (with boundary checking)
int getNextPage(int currentPage) {
  if (currentPage < 604) {
    return currentPage + 1;
  }
  return currentPage; // Stay on last page
}

/// Get the previous page (with boundary checking)
int getPreviousPage(int currentPage) {
  if (currentPage > 1) {
    return currentPage - 1;
  }
  return currentPage; // Stay on first page
}

/// QuranPageMetadata - Static class for page-related queries
class QuranPageMetadata {
  static const int totalPages = 604;

  /// Get the surah number for a given page
  static int? getSurahForPage(int pageNumber) {
    final surah = getSurahInfoForPage(pageNumber);
    return surah?.surahNumber;
  }

  /// Get next page number
  static int getNextPageNumber(int currentPage) {
    return getNextPage(currentPage);
  }

  /// Get previous page number
  static int getPreviousPageNumber(int currentPage) {
    return getPreviousPage(currentPage);
  }

  /// Get the starting page of a surah
  static int? getStartPageOfSurah(int surahNumber) {
    return SURAH_PAGE_MAP[surahNumber]?['startPage'];
  }

  /// Get the ending page of a surah
  static int? getEndPageOfSurah(int surahNumber) {
    return SURAH_PAGE_MAP[surahNumber]?['endPage'];
  }
}

/// Helper function to get current surah info in widget
SurahInfo? getSurahInfoForPage(int pageNumber) {
  return getSurahForPage(pageNumber);
}

/// Extension to easily access QuranData
extension QuranDataHelper on QuranData {
  /// Find surah by number (1-114)
  static QuranSurah? getSurahById(int surahId) {
    try {
      for (var juz in QuranData.parts) {
        for (var surah in juz.surahs) {
          if (surah.id == surahId) {
            return surah;
          }
        }
      }
    } catch (e) {
      print('Error finding surah: $e');
    }
    return null;
  }

  /// Find surah by name (case-insensitive Arabic)
  static QuranSurah? getSurahByNameAr(String nameAr) {
    try {
      for (var juz in QuranData.parts) {
        for (var surah in juz.surahs) {
          if (surah.nameAr.contains(nameAr)) {
            return surah;
          }
        }
      }
    } catch (e) {
      print('Error finding surah by name: $e');
    }
    return null;
  }
}