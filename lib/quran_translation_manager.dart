import 'package:shared_preferences/shared_preferences.dart';

/// Model for Quran Surah
class Surah {
  final int number;
  final String name;
  final String nameEnglish;
  final String nameTranslation;
  final int verses;
  final String revelation; // 'Mecca' or 'Medina'
  final String meaning;

  const Surah({
    required this.number,
    required this.name,
    required this.nameEnglish,
    required this.nameTranslation,
    required this.verses,
    required this.revelation,
    required this.meaning,
  });
}

/// Model for Quran Ayah (verse)
class Ayah {
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final String translation;
  final String transliteration;

  const Ayah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.translation,
    required this.transliteration,
  });
}

/// Manager for Quran translation and data
class QuranTranslationManager {
  static final QuranTranslationManager _instance =
      QuranTranslationManager._internal();
  late SharedPreferences _prefs;
  late Map<int, List<Ayah>> _quranData;

  QuranTranslationManager._internal();

  factory QuranTranslationManager() {
    return _instance;
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _quranData = {};
    _initializeQuranData();
  }

  /// Get list of all Surahs
  List<Surah> getAllSurahs() {
    return _getDefaultSurahs();
  }

  /// Get a specific Surah by number
  Surah? getSurah(int surahNumber) {
    final surahs = _getDefaultSurahs();
    try {
      return surahs.firstWhere((s) => s.number == surahNumber);
    } catch (e) {
      return null;
    }
  }

  /// Get all ayahs of a surah
  Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    if (_quranData.containsKey(surahNumber)) {
      return _quranData[surahNumber] ?? [];
    }
    return [];
  }

  /// Get a specific ayah
  Future<Ayah?> getAyah(int surahNumber, int ayahNumber) async {
    final ayahs = await getSurahAyahs(surahNumber);
    try {
      return ayahs.firstWhere((a) => a.ayahNumber == ayahNumber);
    } catch (e) {
      return null;
    }
  }

  /// Search for ayahs by text
  Future<List<Ayah>> searchAyahs(String query) async {
    final results = <Ayah>[];
    for (var surahAyahs in _quranData.values) {
      for (var ayah in surahAyahs) {
        if (ayah.text.contains(query) || ayah.translation.contains(query)) {
          results.add(ayah);
        }
      }
    }
    return results;
  }

  /// Save bookmark
  Future<void> addBookmark(int surahNumber, int ayahNumber) async {
    final bookmarks = getBookmarks();
    final key = '$surahNumber:$ayahNumber';
    bookmarks.add(key);
    await _prefs.setStringList('bookmarks', bookmarks.toList());
  }

  /// Remove bookmark
  Future<void> removeBookmark(int surahNumber, int ayahNumber) async {
    final bookmarks = getBookmarks();
    final key = '$surahNumber:$ayahNumber';
    bookmarks.remove(key);
    await _prefs.setStringList('bookmarks', bookmarks.toList());
  }

  /// Get all bookmarks
  Set<String> getBookmarks() {
    return (_prefs.getStringList('bookmarks') ?? []).toSet();
  }

  /// Check if ayah is bookmarked
  bool isBookmarked(int surahNumber, int ayahNumber) {
    final key = '$surahNumber:$ayahNumber';
    return getBookmarks().contains(key);
  }

  /// Initialize Quran data
  void _initializeQuranData() {
    // This would typically load from a JSON file or API
    // For now, we'll add sample data
    _quranData[1] = [
      const Ayah(
        surahNumber: 1,
        ayahNumber: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'In the name of Allah, the Most Gracious, the Most Merciful',
        transliteration: 'Bismillahi ar-Rahmani ar-Rahim',
      ),
      const Ayah(
        surahNumber: 1,
        ayahNumber: 2,
        text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        translation: 'Praise be to Allah, Lord of the Worlds',
        transliteration: 'Al-hamdu lillahi rabbi al-alamin',
      ),
    ];
  }

  /// Get default Surahs list
  List<Surah> _getDefaultSurahs() {
    return [
      const Surah(
        number: 1,
        name: 'الفاتحة',
        nameEnglish: 'Al-Fatihah',
        nameTranslation: 'The Opening',
        verses: 7,
        revelation: 'Mecca',
        meaning: 'The Opening Chapter',
      ),
      const Surah(
        number: 2,
        name: 'البقرة',
        nameEnglish: 'Al-Baqarah',
        nameTranslation: 'The Cow',
        verses: 286,
        revelation: 'Medina',
        meaning: 'The Cow Chapter',
      ),
      // Add more surahs as needed
    ];
  }
}