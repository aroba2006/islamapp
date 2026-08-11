import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/quran_data.dart';
import '../data/tafseer_data.dart';
import '../l10n/app_localizations.dart';
import '../services/quran_reciter_service.dart';
import '../widgets/islamic_pattern_background.dart';
import 'package:flutter/gestures.dart';
import '../screens/mushaf_viewer_screen.dart';
import '../models/quran_page_model.dart';
import '../utils/share_image_generator.dart';
import '../services/theme_service.dart';

// Helper Map for French Surah Translations
final Map<int, String> surahNamesFr = {
  1: "L'Ouverture", 2: "La Vache", 3: "La Famille d'Imran", 4: "Les Femmes",
  5: "La Table Servie", 6: "Les Bestiaux", 7: "Al-A'raf", 8: "Le Butin",
  9: "Le Repentir", 10: "Jonas", 11: "Hud", 12: "Joseph", 13: "Le Tonnerre",
  14: "Abraham", 15: "Al-Hijr", 16: "Les Abeilles", 17: "Le Voyage Nocturne",
  18: "La Caverne", 19: "Marie", 20: "Ta-Ha", 21: "Les Prophètes",
  22: "Le Pèlerinage", 23: "Les Croyants", 24: "La Lumière", 25: "Le Discernement",
  26: "Les Poètes", 27: "Les Fourmis", 28: "Le Récit", 29: "L'Araignée",
  30: "Les Romains", 31: "Luqman", 32: "La Prosternation", 33: "Les Coalisés",
  34: "Saba", 35: "Le Créateur", 36: "Ya-Sin", 37: "Les Rangs", 38: "Sad",
  39: "Les Groupes", 40: "Le Pardonneur", 41: "Les Versets Détaillés",
  42: "La Consultation", 43: "L'Ornement", 44: "La Fumée", 45: "L'Agenouillée",
  46: "Al-Ahqaf", 47: "Muhammad", 48: "La Victoire", 49: "Les Appartements",
  50: "Qaf", 51: "Qui Éparpillent", 52: "Le Mont", 53: "L'Étoile",
  54: "La Lune", 55: "Le Miséricordieux", 56: "L'Événement", 57: "Le Fer",
  58: "La Plaideuse", 59: "L'Exode", 60: "L'Éprouvée", 61: "Le Rang",
  62: "Le Vendredi", 63: "Les Hypocrites", 64: "La Grande Perte",
  65: "Le Divorce", 66: "L'Interdiction", 67: "La Royauté", 68: "La Plume",
  69: "Celle qui montre la vérité", 70: "Les Voies d'Ascension", 71: "Noé",
  72: "Les Djinns", 73: "L'Enveloppé", 74: "Le Revêtu d'un Manteau",
  75: "La Résurrection", 76: "L'Homme", 77: "Les Envoyés", 78: "La Nouvelle",
  79: "Les Anges qui Arrachent", 80: "Il s'est Renfrogné", 81: "L'Obscurcissement",
  82: "La Rupture", 83: "Les Fraudeurs", 84: "La Déchirure",
  85: "Les Constellations", 86: "L'Astre Nocturne", 87: "Le Très-Haut",
  88: "L'Enveloppante", 89: "L'Aube", 90: "La Cité", 91: "Le Soleil",
  92: "La Nuit", 93: "Le Jour", 94: "L'Éclat", 95: "Le Figuier",
  96: "L'Adhérence", 97: "La Destinée", 98: "La Preuve", 99: "Le Séisme",
  100: "Les Coursiers", 101: "Le Fracas", 102: "La Course aux Richesses",
  103: "Le Temps", 104: "Les Calomniateurs", 105: "L'Éléphant",
  106: "Quraysh", 107: "L'Ustensile", 108: "L'Abondance", 109: "Les Infidèles",
  110: "Le Secours Divin", 111: "Les Fibres", 112: "Le Monothéisme Pur",
  113: "L'Aube Naissante", 114: "Les Hommes"
};

// Helper Map for English Surah Translations
final Map<int, String> surahNamesEnTrans = {
  1: "The Opening", 2: "The Cow", 3: "Family of Imran", 4: "The Women",
  5: "The Table Spread", 6: "The Cattle", 7: "The Heights", 8: "The Spoils of War",
  9: "The Repentance", 10: "Jonah", 11: "Hud", 12: "Joseph", 13: "The Thunder",
  14: "Abraham", 15: "The Rocky Tract", 16: "The Bees", 17: "The Night Journey",
  18: "The Cave", 19: "Mary", 20: "Ta-Ha", 21: "The Prophets",
  22: "The Pilgrimage", 23: "The Believers", 24: "The Light", 25: "The Criterion",
  26: "The Poets", 27: "The Ants", 28: "The Stories", 29: "The Spider",
  30: "The Romans", 31: "Luqman", 32: "The Prostration", 33: "The Combined Forces",
  34: "Sheba", 35: "The Originator", 36: "Ya-Sin", 37: "Those who set the Ranks",
  38: "Sad", 39: "The Troops", 40: "The Forgiver", 41: "Explained in Detail",
  42: "The Consultation", 43: "The Ornaments of Gold", 44: "The Smoke", 45: "The Crouching",
  46: "The Wind-Curved Sandhills", 47: "Muhammad", 48: "The Victory", 49: "The Rooms",
  50: "Qaf", 51: "The Winnowing Winds", 52: "The Mount", 53: "The Star",
  54: "The Moon", 55: "The Beneficent", 56: "The Inevitable", 57: "The Iron",
  58: "The Pleading Woman", 59: "The Exile", 60: "She that is to be examined", 61: "The Ranks",
  62: "The Congregation", 63: "The Hypocrites", 64: "The Mutual Disillusion",
  65: "The Divorce", 66: "The Prohibition", 67: "The Sovereignty", 68: "The Pen",
  69: "The Reality", 70: "The Ascending Stairways", 71: "Noah",
  72: "The Jinn", 73: "The Enshrouded One", 74: "The Cloaked One",
  75: "The Resurrection", 76: "The Man", 77: "The Emissaries", 78: "The Tidings",
  79: "Those who drag forth", 80: "He Frowned", 81: "The Overthrowing",
  82: "The Cleaving", 83: "The Defrauding", 84: "The Sundering",
  85: "The Mansions of the Stars", 86: "The Nightcommer", 87: "The Most High",
  88: "The Overwhelming", 89: "The Dawn", 90: "The City", 91: "The Sun",
  92: "The Night", 93: "The Morning Hours", 94: "The Relief", 95: "The Fig",
  96: "The Clot", 97: "The Power", 98: "The Clear Proof", 99: "The Earthquake",
  100: "The Courser", 101: "The Calamity", 102: "The Rivalry",
  103: "The Declining Day", 104: "The Traducer", 105: "The Elephant",
  106: "Quraysh", 107: "The Small Kindnesses", 108: "The Abundance", 109: "The Disbelievers",
  110: "The Divine Support", 111: "The Palm Fiber", 112: "The Sincerity",
  113: "The Daybreak", 114: "The Mankind"
};

// ==========================================
// SCREEN 1: THE 30 PARTS GRID + SEARCH BAR
// ==========================================
class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  // 0: Whole Quran (Continuous), 1: Whole Surah, 2: Verse by Verse
  int _viewMode = 0;

  String _removeDiacritics(String text) {
    String cleaned = text.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    cleaned = cleaned.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    cleaned = cleaned.replaceAll('ة', 'ه');
    return cleaned;
  }

  void _performSearch(String query) async {
    setState(() {
      _searchQuery = query;
      _searchResults.clear();
      _isSearching = true;
    });

    if (query.trim().isEmpty) {
      setState(() => _isSearching = false);
      return;
    }

    final results = await Future.microtask(() => _executeSearch(query));

    if (mounted) {
      setState(() {
        _searchResults.addAll(results);
        _isSearching = false;
      });
    }
  }

  List<Map<String, dynamic>> _executeSearch(String query) {
    final cleanQuery = _removeDiacritics(query.toLowerCase().trim());
    final results = <Map<String, dynamic>>[];

    for (var juz in QuranData.parts) {
      for (var surah in juz.surahs) {
        int startNumber = surah.startingVerseNumber;

        final cleanSurahNameAr = _removeDiacritics(surah.nameAr);
        final surahNameEn = surah.nameEn.toLowerCase();
        final surahNameFr = (surahNamesFr[surah.id] ?? '').toLowerCase();
        final surahNameEnTrans = (surahNamesEnTrans[surah.id] ?? '').toLowerCase();

        bool surahNameMatches = cleanSurahNameAr.contains(cleanQuery) ||
                               surahNameEn.contains(cleanQuery) ||
                               surahNameFr.contains(cleanQuery) ||
                               surahNameEnTrans.contains(cleanQuery);

        List<Map<String, dynamic>> matchedVersesForSurah = [];

        for (int i = 0; i < surah.versesAr.length; i++) {
          final cleanVerseAr = _removeDiacritics(surah.versesAr[i]);
          final verseEn = i < surah.versesEn.length ? surah.versesEn[i].toLowerCase() : '';

          if (surahNameMatches || cleanVerseAr.contains(cleanQuery) || verseEn.contains(cleanQuery)) {
            final trueVerseNumber = i + startNumber;
            final pageNumber = QuranPageMetadata.getPageForVerse(surah.id, trueVerseNumber);

            matchedVersesForSurah.add({
              'verseIndex': i,
              'trueVerseNumber': trueVerseNumber,
              'verseAr': surah.versesAr[i],
              'verseEn': i < surah.versesEn.length ? surah.versesEn[i] : '',
              'pageNumber': pageNumber,
            });
          }
        }

        if (matchedVersesForSurah.isNotEmpty) {
          results.add({
            'surah': surah,
            'startVerseNumber': startNumber,
            'verses': matchedVersesForSurah,
          });
        }
      }
    }
    return results;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildToggleSegment(int modeValue, String titleAr, String titleEn, String titleFr, bool isArabic, String lang, bool isDarkMode, ThemeService themeService) {
    final isSelected = _viewMode == modeValue;
    String displayTitle = isArabic ? titleAr : (lang == 'fr' ? titleFr : titleEn);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _viewMode = modeValue),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            displayTitle,
            textAlign: TextAlign.center,
            style: themeService.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? (isDarkMode ? const Color(0xFF0B3D2E) : Colors.white) : (isDarkMode ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          backgroundColor: isDarkMode ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF5F5F5),
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            l10n.quranTitle,
                            textAlign: TextAlign.center,
                            style: themeService.getTextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _performSearch,
                          style: themeService.getTextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                          decoration: InputDecoration(
                            hintText: isArabic
                                ? 'ابحث عن سورة، آية أو كلمة...'
                                : (lang == 'fr' ? 'Rechercher une sourate, verset...' : 'Search for a surah, verse...'),
                            hintStyle: themeService.getTextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
                            ),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                            filled: true,
                            fillColor: isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.65) : Colors.white.withValues(alpha: 0.8),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: isDarkMode ? Colors.white54 : Colors.black45),
                                    onPressed: () {
                                      _searchController.clear();
                                      _performSearch('');
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFD4AF37).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          _buildToggleSegment(0, 'المصحف كامل', 'Whole Book', 'Coran Entier', isArabic, lang, isDarkMode, themeService),
                          _buildToggleSegment(1, 'سورة كاملة', 'Whole Surah', 'Sourate Entière', isArabic, lang, isDarkMode, themeService),
                          _buildToggleSegment(2, 'آية بآية', 'Verse by Verse', 'Verset par Verset', isArabic, lang, isDarkMode, themeService),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: _searchQuery.isNotEmpty
                            ? (_isSearching
                                ? _buildSearchLoadingState(context, isDarkMode, themeService)
                                : _buildSearchResults(context, lang, isDarkMode, themeService))
                            : (_viewMode == 0
                                ? _buildWholeQuranCover(context, lang, isDarkMode, themeService)
                                : _buildPartsGrid(context, lang, isDarkMode, themeService)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWholeQuranCover(BuildContext context, String lang, bool isDarkMode, ThemeService themeService) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MushafViewerScreen(initialPage: 1),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
            ),
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFD4AF37), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book_rounded, size: 80, color: Color(0xFFD4AF37)),
                const SizedBox(height: 24),
                Text(
                  lang == 'ar' ? 'إقرأ المصحف كاملاً' : (lang == 'fr' ? 'Lire le Coran Entier' : 'Read the Entire Quran'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  lang == 'ar' ? 'تصفح مستمر لجميع السور' : (lang == 'fr' ? 'Lecture continue' : 'Continuous reading'),
                  style: themeService.getTextStyle(
                    fontSize: 18,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartsGrid(BuildContext context, String lang, bool isDarkMode, ThemeService themeService) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220, crossAxisSpacing: 20, mainAxisSpacing: 20, mainAxisExtent: 180,
      ),
      itemCount: QuranData.parts.length,
      itemBuilder: (context, index) {
        final part = QuranData.parts[index];
        return _JuzGlassCard(
          part: part, lang: lang, isDarkMode: isDarkMode,
          onTap: () => _navigateToPartSurahs(context, part, lang),
          themeService: themeService,
        );
      },
    );
  }

  Widget _buildSearchLoadingState(BuildContext context, bool isDarkMode, ThemeService themeService) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
          ),
          const SizedBox(height: 16),
          Text(
            'جاري البحث...',
            style: themeService.getTextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, String lang, bool isDarkMode, ThemeService themeService) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          lang == 'ar' ? 'لم يتم العثور على نتائج' : (lang == 'fr' ? 'Aucun résultat trouvé' : 'No results found'),
          style: themeService.getTextStyle(
            fontSize: 18,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final group = _searchResults[index];
        final surah = group['surah'] as QuranSurah;
        final startVerseNumber = group['startVerseNumber'] as int;
        final verses = group['verses'] as List<Map<String, dynamic>>;

        String surahHeaderTitle = lang == 'ar' ? 'سورة ${surah.nameAr}' : surah.nameEn;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahReaderScreen(
                        surah: surah,
                        lang: lang,
                        startVerseNumber: surah.startingVerseNumber,
                        viewMode: _viewMode,
                        themeService: themeService,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: Color(0xFFD4AF37), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      surahHeaderTitle,
                      style: themeService.getTextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD4AF37),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFFD4AF37), size: 20),
                  ],
                ),
              ),
            ),
            ...verses.map((verse) {
              final verseIndex = verse['verseIndex'] as int;
              final pageNumber = verse['pageNumber'] as int?;

              return _SearchResultGlassCard(
                searchResult: {
                  'surah': surah,
                  'trueVerseNumber': verse['trueVerseNumber'],
                  'verseAr': verse['verseAr'],
                  'verseEn': verse['verseEn'],
                  'pageNumber': pageNumber,
                },
                lang: lang,
                isDarkMode: isDarkMode,
                onTapSurah: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SurahReaderScreen(
                    surah: surah,
                    lang: lang,
                    highlightedVerseIndex: verseIndex,
                    startVerseNumber: startVerseNumber,
                    viewMode: 2,
                    themeService: themeService,
                  )));
                },
                onTapMushaf: () {
                  if (pageNumber != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MushafViewerScreen(
                      initialPage: pageNumber,
                    )));
                  }
                },
                themeService: themeService,
              );
            }),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10, thickness: 1)),
          ],
        );
      },
    );
  }

  void _navigateToPartSurahs(BuildContext context, QuranJuz part, String lang) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PartSurahsScreen(
      part: part, lang: lang, viewMode: _viewMode
    )));
  }
}

// ==========================================
// SCREEN 2: SURAHS IN A PART
// ==========================================
class PartSurahsScreen extends StatefulWidget {
  final QuranJuz part;
  final String lang;
  final int viewMode;

  const PartSurahsScreen({
    super.key,
    required this.part,
    required this.lang,
    required this.viewMode,
  });

  @override
  State<PartSurahsScreen> createState() => _PartSurahsScreenState();
}

class _PartSurahsScreenState extends State<PartSurahsScreen> {
  @override
  Widget build(BuildContext context) {
    final isArabic = widget.lang == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          backgroundColor: isDarkMode ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF5F5F5),
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 24), onPressed: () => Navigator.pop(context)),
                        Expanded(child: Text(
                          isArabic ? widget.part.titleAr : widget.part.titleEn,
                          textAlign: TextAlign.center,
                          style: themeService.getTextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                          ),
                        )),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220, crossAxisSpacing: 16, mainAxisSpacing: 16, mainAxisExtent: 180,
                          ),
                          itemCount: widget.part.surahs.length,
                          itemBuilder: (context, index) {
                            return _SurahGlassCard(
                              surah: widget.part.surahs[index],
                              lang: widget.lang,
                              part: widget.part,
                              isDarkMode: isDarkMode,
                              viewMode: widget.viewMode,
                              themeService: themeService,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SurahGlassCard extends StatefulWidget {
  final QuranSurah surah;
  final String lang;
  final QuranJuz part;
  final bool isDarkMode;
  final int viewMode;
  final ThemeService themeService;

  const _SurahGlassCard({
    required this.surah,
    required this.lang,
    required this.part,
    required this.isDarkMode,
    required this.viewMode,
    required this.themeService,
  });

  @override
  State<_SurahGlassCard> createState() => _SurahGlassCardState();
}

class _SurahGlassCardState extends State<_SurahGlassCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.96),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahReaderScreen(
                surah: widget.surah,
                lang: widget.lang,
                startVerseNumber: widget.surah.startingVerseNumber,
                viewMode: widget.viewMode,
                themeService: widget.themeService,
              ),
            ),
          );
        },
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : _scale,
          duration: const Duration(milliseconds: 150),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? (widget.isDarkMode ? const Color(0xFF144D32).withValues(alpha: 0.8) : Colors.white)
                      : (widget.isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.8)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered ? const Color(0xFFD4AF37).withValues(alpha: 0.8) : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                    width: _isHovered ? 2 : 1
                  ),
                  boxShadow: !widget.isDarkMode ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))] : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD4AF37), width: 1.5), color: const Color(0xFFD4AF37).withValues(alpha: 0.1)),
                      child: Text('${widget.surah.id}', style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.surah.nameAr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiri(
                          color: _isHovered ? (widget.isDarkMode ? Colors.white : Colors.black87) : const Color(0xFFD4AF37),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        widget.surah.nameEn,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: widget.themeService.getTextStyle(
                          fontSize: 13,
                          color: widget.isDarkMode ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 3: SURAH READER WITH PLAYER
// ==========================================
class SurahReaderScreen extends StatefulWidget {
  final QuranSurah surah;
  final String lang;
  final int highlightedVerseIndex;
  final int startVerseNumber;
  final int viewMode;
  final ThemeService themeService;

  const SurahReaderScreen({
    super.key,
    required this.surah,
    required this.lang,
    this.highlightedVerseIndex = -1,
    this.startVerseNumber = 1,
    this.viewMode = 1,
    required this.themeService,
  });

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  late ScrollController _scrollController;
  QuranReciter? _selectedReciter;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = false;
  String? _errorMessage;
  final Map<int, GlobalKey> _verseKeys = {};
  final TextEditingController _surahSearchController = TextEditingController();
  String _surahSearchQuery = '';

  int? _tappedVerseIndex;
  late List<TapGestureRecognizer> _tapRecognizers;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedReciter = QuranReciterService.reciters.first;

    _tapRecognizers = List.generate(
      widget.surah.versesAr.length,
      (index) => TapGestureRecognizer()..onTap = () {
        setState(() => _tappedVerseIndex = index);
        _showTafseerSheet(context, index).whenComplete(() {
          if (mounted) setState(() => _tappedVerseIndex = null);
        });
      }
    );

    _setupAudioListeners();
    if (widget.highlightedVerseIndex != -1) _scrollToVerse(widget.highlightedVerseIndex);
  }

  void _setupAudioListeners() {
    QuranReciterService.onPlayerStateChanged.listen((state) { if (mounted) setState(() => _playerState = state); });
    QuranReciterService.onDurationChanged.listen((duration) { if (mounted) setState(() => _duration = duration); });
    QuranReciterService.onPositionChanged.listen((position) { if (mounted) setState(() => _position = position); });
  }

  void _scrollToVerse(int index) {
    if (widget.viewMode != 2) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = _verseKeys[index]?.currentContext;
      if (targetContext != null) {
        Scrollable.ensureVisible(targetContext, duration: const Duration(milliseconds: 800), curve: Curves.easeInOutCubic, alignment: 0.15);
      } else {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(index * 160.0);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final fallbackContext = _verseKeys[index]?.currentContext;
            if (fallbackContext != null) Scrollable.ensureVisible(fallbackContext, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic, alignment: 0.15);
          });
        }
      }
    });
  }

  bool _isVerseHighlighted(int index) => index == widget.highlightedVerseIndex;

  Future<void> _playAudio() async {
    if (_selectedReciter == null) return;
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      await QuranReciterService.playSurah(reciter: _selectedReciter!, surahNumber: widget.surah.id);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load audio. Please check your connection.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _showTafseerSheet(BuildContext context, int verseIndex) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _TafseerBottomSheet(
          surah: widget.surah,
          verseIndex: verseIndex,
          lang: widget.lang,
          trueVerseNumber: verseIndex + widget.startVerseNumber,
          themeService: widget.themeService,
        );
      },
    );
  }

  @override
  void dispose() {
    for (var recognizer in _tapRecognizers) { recognizer.dispose(); }
    _scrollController.dispose();
    QuranReciterService.stopAudio();
    super.dispose();
  }

  Widget _buildBookNavigation(bool isDarkMode, ThemeService themeService) {
    final prev = _getAdjacentSurah(false);
    final next = _getAdjacentSurah(true);

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (prev != null)
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 16),
              label: Text(
                widget.lang == 'ar' ? 'السابق' : 'Previous',
                style: themeService.getTextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                foregroundColor: const Color(0xFFD4AF37),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                QuranReciterService.stopAudio();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SurahReaderScreen(
                  surah: prev['surah'],
                  lang: widget.lang,
                  startVerseNumber: prev['surah'].startingVerseNumber,
                  viewMode: widget.viewMode,
                  themeService: themeService,
                )));
              },
            )
          else const SizedBox(),

          if (next != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                QuranReciterService.stopAudio();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SurahReaderScreen(
                  surah: next['surah'],
                  lang: widget.lang,
                  startVerseNumber: next['surah'].startingVerseNumber,
                  viewMode: widget.viewMode,
                  themeService: themeService,
                )));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.lang == 'ar' ? 'التالي' : 'Next',
                    style: themeService.getTextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            )
          else const SizedBox(),
        ],
      ),
    );
  }

  Map<String, dynamic>? _getAdjacentSurah(bool getNext) {
    bool foundCurrent = false;
    Map<String, dynamic>? prev;

    for (var juz in QuranData.parts) {
      for (var s in juz.surahs) {
        if (foundCurrent && getNext) return {'juz': juz, 'surah': s};
        if (s.id == widget.surah.id && s.startingVerseNumber == widget.startVerseNumber) {
          if (!getNext) return prev;
          foundCurrent = true;
        }
        prev = {'juz': juz, 'surah': s};
      }
    }
    return null;
  }

  bool _matchesSearch(int index) {
    if (_surahSearchQuery.trim().isEmpty) return true;

    final query = _removeDiacritics(_surahSearchQuery.trim().toLowerCase());
    final cleanAr = _removeDiacritics(widget.surah.versesAr[index]).toLowerCase();

    if (cleanAr.contains(query)) return true;

    if (widget.lang == 'fr' && index < widget.surah.versesFr.length) {
      if (widget.surah.versesFr[index].toLowerCase().contains(query)) return true;
    } else if (index < widget.surah.versesEn.length) {
      if (widget.surah.versesEn[index].toLowerCase().contains(query)) return true;
    }
    return false;
  }

  String _removeDiacritics(String text) {
    String cleaned = text.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    cleaned = cleaned.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    cleaned = cleaned.replaceAll('ة', 'ه');
    return cleaned;
  }

  Widget _buildPageView(bool isDarkMode, ThemeService themeService, {String searchQuery = ''}) {
    List<InlineSpan> spans = [];
    final isSearching = searchQuery.trim().isNotEmpty;
    final cleanQuery = _removeDiacritics(searchQuery.trim().toLowerCase());

    for (int i = 0; i < widget.surah.versesAr.length; i++) {
      final verseNum = i + widget.startVerseNumber;
      final isSearchedHighlight = _isVerseHighlighted(i);
      final isTappedHighlight = _tappedVerseIndex == i;

      final cleanVerse = _removeDiacritics(widget.surah.versesAr[i]).toLowerCase();
      final verseMatches = isSearching && cleanVerse.contains(cleanQuery);

      Color verseColor;
      if (isSearchedHighlight || isTappedHighlight) {
        verseColor = const Color(0xFFD4AF37);
      } else if (verseMatches) {
        verseColor = const Color(0xFFD4AF37);
      } else {
        verseColor = isDarkMode ? Colors.white : Colors.black87;
      }

      spans.add(
        TextSpan(
          text: '${widget.surah.versesAr[i]} ',
          style: GoogleFonts.amiri(
            fontSize: 28,
            color: verseColor,
            backgroundColor: verseMatches
                ? const Color(0xFFD4AF37).withValues(alpha: 0.3)
                : (isTappedHighlight ? const Color(0xFFD4AF37).withValues(alpha: 0.25) : Colors.transparent),
            height: 2.2,
            fontWeight: (isSearchedHighlight || isTappedHighlight || verseMatches) ? FontWeight.bold : FontWeight.normal,
          ),
          recognizer: _tapRecognizers[i],
        ),
      );

      spans.add(
        TextSpan(
          text: ' ﴿$verseNum﴾ ',
          style: TextStyle(
            fontSize: 22,
            color: isTappedHighlight || verseMatches ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withValues(alpha: 0.7),
            backgroundColor: verseMatches
                ? const Color(0xFFD4AF37).withValues(alpha: 0.3)
                : (isTappedHighlight ? const Color(0xFFD4AF37).withValues(alpha: 0.25) : Colors.transparent),
            fontFamily: 'Amiri',
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(children: spans),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeService = widget.themeService;

    String appBarTitle;
    if (widget.lang == 'ar') {
      appBarTitle = 'سورة ${widget.surah.nameAr}';
    } else if (widget.lang == 'fr') {
      appBarTitle = '${widget.surah.nameEn} (${surahNamesFr[widget.surah.id] ?? ''})';
    } else {
      appBarTitle = '${widget.surah.nameEn} (${surahNamesEnTrans[widget.surah.id] ?? ''})';
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) { QuranReciterService.stopAudio(); },
      child: Scaffold(
        backgroundColor: isDarkMode ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF5F5F5),
        body: IslamicPatternBackground(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 24),
                        onPressed: () { QuranReciterService.stopAudio(); Navigator.pop(context); }
                      ),
                      Expanded(
                        child: Text(
                          appBarTitle,
                          textAlign: TextAlign.center,
                          style: themeService.getTextStyle(
                            fontSize: widget.lang == 'ar' ? 26 : 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                          ),
                        )
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          children: [
                            if (widget.viewMode != 0) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: TextField(
                                      controller: _surahSearchController,
                                      onChanged: (val) => setState(() => _surahSearchQuery = val),
                                      style: themeService.getTextStyle(
                                        fontSize: 16,
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                      ),
                                      textDirection: widget.lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                                      decoration: InputDecoration(
                                        hintText: widget.lang == 'ar'
                                            ? 'ابحث داخل السورة...'
                                            : (widget.lang == 'fr' ? 'Rechercher dans la sourate...' : 'Search within Surah...'),
                                        hintStyle: themeService.getTextStyle(
                                          fontSize: 14,
                                          color: isDarkMode ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
                                        ),
                                        prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                                        filled: true,
                                        fillColor: isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.65) : Colors.white.withValues(alpha: 0.8),
                                        suffixIcon: _surahSearchQuery.isNotEmpty
                                            ? IconButton(
                                                icon: Icon(Icons.clear, color: isDarkMode ? Colors.white54 : Colors.black45),
                                                onPressed: () {
                                                  _surahSearchController.clear();
                                                  setState(() => _surahSearchQuery = '');
                                                },
                                              )
                                            : null,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3))),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (widget.surah.id != 1 && widget.surah.id != 9 && widget.startVerseNumber == 1)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', style: GoogleFonts.amiri(fontSize: 32, color: const Color(0xFFD4AF37), fontWeight: FontWeight.bold))
                              ),
                            if (widget.surah.id != 1 && widget.surah.id != 9 && widget.startVerseNumber == 1)
                              Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), indent: 80, endIndent: 80, thickness: 1.5),

                            const SizedBox(height: 16),

                            if (widget.viewMode == 0 || widget.viewMode == 1)
                              _buildPageView(isDarkMode, themeService, searchQuery: _surahSearchQuery)
                            else
                              ...List.generate(widget.surah.versesAr.length, (index) {
                                if (!_matchesSearch(index)) return const SizedBox.shrink();

                                final isHighlighted = _isVerseHighlighted(index);
                                final isTapped = _tappedVerseIndex == index;
                                final verseKey = _verseKeys.putIfAbsent(index, () => GlobalKey());
                                String translatedVerse = '';
                                if (widget.lang == 'fr' && index < widget.surah.versesFr.length) {
                                  translatedVerse = widget.surah.versesFr[index];
                                } else if (index < widget.surah.versesEn.length) {
                                  translatedVerse = widget.surah.versesEn[index];
                                }

                                return GestureDetector(
                                  onTap: () {
                                    setState(() => _tappedVerseIndex = index);
                                    _showTafseerSheet(context, index).whenComplete(() {
                                      if (mounted) setState(() => _tappedVerseIndex = null);
                                    });
                                  },
                                  child: Container(
                                    key: verseKey,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: isHighlighted || isTapped ? (isDarkMode ? const Color(0xFF1B5E3F).withValues(alpha: 0.7) : Colors.white) : (isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.8)),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: isHighlighted || isTapped ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withValues(alpha: 0.15), width: isHighlighted || isTapped ? 2 : 1),
                                      boxShadow: !isDarkMode ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))] : [],
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 40, height: 40, alignment: Alignment.center,
                                              decoration: BoxDecoration(color: const Color(0xFFD4AF37).withValues(alpha: 0.1), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD4AF37), width: 1.5)),
                                              child: Text('${index + widget.startVerseNumber}', style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 16))
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: Text(
                                                widget.surah.versesAr[index], textDirection: TextDirection.rtl,
                                                style: GoogleFonts.amiri(fontSize: 28, color: isHighlighted || isTapped ? const Color(0xFFD4AF37) : (isDarkMode ? Colors.white : Colors.black87), height: 2.0, fontWeight: isHighlighted || isTapped ? FontWeight.bold : FontWeight.normal)
                                              )
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        if (translatedVerse.isNotEmpty)
                                          Text(
                                            translatedVerse,
                                            textDirection: TextDirection.ltr,
                                            style: themeService.getTextStyle(
                                              fontSize: 16,
                                              color: isHighlighted || isTapped ? (isDarkMode ? Colors.white : Colors.black87) : (isDarkMode ? Colors.white.withValues(alpha: 0.75) : Colors.black54),
                                              height: 1.6,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),

                                        const SizedBox(height: 12),
                                        Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.2)),

                                        Row(
                                          mainAxisAlignment: widget.lang == 'ar' ? MainAxisAlignment.start : MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              icon: const Icon(Icons.share_rounded, color: Color(0xFFD4AF37), size: 18),
                                              label: Text(
                                                widget.lang == 'ar' ? 'مشاركة' : 'Share',
                                                style: themeService.getTextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(0xFFD4AF37),
                                                ),
                                              ),
                                              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), backgroundColor: const Color(0xFFD4AF37).withValues(alpha: 0.1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => _ShareVerseDialog(
                                                    surah: widget.surah,
                                                    initialVerseIndex: index,
                                                    lang: widget.lang,
                                                    themeService: themeService,
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 12),
                                            TextButton.icon(
                                              icon: const Icon(Icons.menu_book_rounded, color: Color(0xFFD4AF37), size: 18),
                                              label: Text(
                                                widget.lang == 'ar' ? 'التفسير' : (widget.lang == 'fr' ? 'Tafsir' : 'Tafseer'),
                                                style: themeService.getTextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(0xFFD4AF37),
                                                ),
                                              ),
                                              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), backgroundColor: const Color(0xFFD4AF37).withValues(alpha: 0.1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                              onPressed: () => _showTafseerSheet(context, index),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            if (widget.viewMode == 0)
                              _buildBookNavigation(isDarkMode, themeService),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.95), border: Border(top: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)))),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(color: isDarkMode ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFD4AF37).withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<QuranReciter>(
                                dropdownColor: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
                                value: _selectedReciter,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4AF37)),
                                items: QuranReciterService.reciters.map((reciter) {
                                  return DropdownMenuItem(
                                    value: reciter,
                                    child: Text(
                                      widget.lang == 'ar' ? reciter.nameAr : reciter.nameEn,
                                      style: themeService.getTextStyle(
                                        fontSize: 16,
                                        color: isDarkMode ? const Color(0xFFD4AF37) : Colors.black87,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (reciter) {
                                  if (reciter != null && _playerState == PlayerState.playing) {
                                    QuranReciterService.stopAudio();
                                  }
                                  setState(() => _selectedReciter = reciter);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red, width: 1)),
                              child: Text(_errorMessage!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _isLoading ? null : (_playerState == PlayerState.playing ? () => QuranReciterService.pauseAudio() : (_playerState == PlayerState.paused ? () => QuranReciterService.resumeAudio() : _playAudio)),
                                child: Container(
                                  width: 60, height: 60,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: _playerState == PlayerState.playing ? const Color(0xFFD4AF37).withValues(alpha: 0.2) : const Color(0xFFD4AF37), border: Border.all(color: const Color(0xFFD4AF37), width: 2)),
                                  child: _isLoading ? const Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0B3D2E)), strokeWidth: 2)) : Icon(_playerState == PlayerState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: _playerState == PlayerState.playing ? const Color(0xFFD4AF37) : const Color(0xFF0B3D2E), size: 32),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => QuranReciterService.stopAudio(),
                                child: Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD4AF37), width: 2)), child: const Icon(Icons.stop_rounded, color: Color(0xFFD4AF37), size: 26))
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_duration != Duration.zero)
                            Column(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(activeTrackColor: const Color(0xFFD4AF37), inactiveTrackColor: isDarkMode ? Colors.white.withValues(alpha: 0.2) : Colors.black12, thumbColor: const Color(0xFFD4AF37), overlayColor: const Color(0xFFD4AF37).withValues(alpha: 0.3), trackHeight: 4),
                                  child: Slider(value: _position.inSeconds.toDouble(), max: _duration.inSeconds.toDouble(), onChanged: (value) => QuranReciterService.seek(Duration(seconds: value.toInt())))
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_formatDuration(_position), style: themeService.getTextStyle(fontSize: 13, color: isDarkMode ? Colors.white70 : Colors.black54)),
                                      Text(_formatDuration(_duration), style: themeService.getTextStyle(fontSize: 13, color: isDarkMode ? Colors.white70 : Colors.black54))
                                    ]
                                  )
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TafseerBottomSheet extends StatelessWidget {
  final QuranSurah surah;
  final int verseIndex;
  final String lang;
  final int trueVerseNumber;
  final ThemeService themeService;

  const _TafseerBottomSheet({
    required this.surah,
    required this.verseIndex,
    required this.lang,
    required this.trueVerseNumber,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final tafseerVerse = TafseerData.getTafseerForVerse(surah.id, trueVerseNumber);
    final arabicText = tafseerVerse?.tafseerAr ?? '';
    final englishText = tafseerVerse?.tafseerEn ?? '';
    const frenchText = '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 50, height: 5, margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: isDarkMode ? Colors.white38 : Colors.black26, borderRadius: BorderRadius.circular(10)),
            ),
          ),

          Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Text(
                  lang == 'ar' ? 'تفسير الآية $trueVerseNumber' : (lang == 'fr' ? 'Tafsir du verset $trueVerseNumber' : 'Tafseer of Verse $trueVerseNumber'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(fontSize: 24, color: const Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Color(0xFFD4AF37)),
                tooltip: lang == 'ar' ? 'مشاركة' : 'Share',
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (ctx) => _ShareVerseDialog(
                      surah: surah,
                      initialVerseIndex: verseIndex,
                      lang: lang,
                      themeService: themeService,
                    ),
                  );
                },
              ),
            ],
          ),
          const Divider(color: Color(0xFFD4AF37)),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (arabicText.isNotEmpty) ...[
                    Text('التفسير الميسر:', textDirection: TextDirection.rtl, style: GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(arabicText, textDirection: TextDirection.rtl, style: GoogleFonts.amiri(fontSize: 18, color: isDarkMode ? Colors.white : Colors.black87, height: 1.8)),
                    const SizedBox(height: 24),
                  ],
                  if (englishText.isNotEmpty) ...[
                    Text('English Translation:', style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37))),
                    const SizedBox(height: 8),
                    Text(englishText, textDirection: TextDirection.ltr, style: themeService.getTextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87, height: 1.6)),
                    const SizedBox(height: 24),
                  ],
                  if (frenchText.isNotEmpty) ...[
                    Text('Traduction Française:', style: themeService.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37))),
                    const SizedBox(height: 8),
                    Text(frenchText, textDirection: TextDirection.ltr, style: themeService.getTextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87, height: 1.6)),
                  ],
                  if (arabicText.isEmpty && englishText.isEmpty && frenchText.isEmpty)
                    Center(child: Padding(padding: const EdgeInsets.only(top: 40.0), child: Text(
                      lang == 'ar' ? 'التفسير غير متوفر حالياً' : 'Tafseer is currently unavailable',
                      style: themeService.getTextStyle(fontSize: 18, color: isDarkMode ? Colors.white54 : Colors.black54),
                    ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultGlassCard extends StatefulWidget {
  final Map<String, dynamic> searchResult;
  final String lang;
  final bool isDarkMode;
  final VoidCallback onTapSurah;
  final VoidCallback onTapMushaf;
  final ThemeService themeService;

  const _SearchResultGlassCard({
    required this.searchResult,
    required this.lang,
    required this.isDarkMode,
    required this.onTapSurah,
    required this.onTapMushaf,
    required this.themeService,
  });

  @override
  State<_SearchResultGlassCard> createState() => _SearchResultGlassCardState();
}

class _SearchResultGlassCardState extends State<_SearchResultGlassCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final surah = widget.searchResult['surah'] as QuranSurah;
    final verseNum = widget.searchResult['trueVerseNumber'] as int;
    final verseAr = widget.searchResult['verseAr'] as String;
    final pageNumber = widget.searchResult['pageNumber'] as int?;

    String cardLabel = widget.lang == 'ar'
        ? 'الآية $verseNum'
        : 'Verse $verseNum';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : _scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? (widget.isDarkMode ? const Color(0xFF144D32).withValues(alpha: 0.8) : Colors.white)
                      : (widget.isDarkMode ? const Color(0xFF1B5E3F).withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.8)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovered ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withValues(alpha: 0.4),
                    width: _isHovered ? 2 : 1
                  ),
                  boxShadow: !widget.isDarkMode ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))] : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cardLabel,
                          style: widget.themeService.getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                          ),
                        ),
                        if (pageNumber != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${widget.lang == 'ar' ? 'ص' : 'P'} $pageNumber',
                              style: widget.themeService.getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFD4AF37),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Text(
                      verseAr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.amiri(
                        color: widget.isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 18,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) => setState(() => _scale = 0.96),
                            onTapUp: (_) => setState(() => _scale = 1.0),
                            onTapCancel: () => setState(() => _scale = 1.0),
                            onTap: widget.onTapSurah,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.auto_stories, color: Color(0xFFD4AF37), size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.lang == 'ar' ? 'السورة' : 'Surah',
                                    style: widget.themeService.getTextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD4AF37),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (pageNumber != null)
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (_) => setState(() => _scale = 0.96),
                              onTapUp: (_) => setState(() => _scale = 1.0),
                              onTapCancel: () => setState(() => _scale = 1.0),
                              onTap: widget.onTapMushaf,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.menu_book, color: Color(0xFFD4AF37), size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.lang == 'ar' ? 'المصحف' : 'Mushaf',
                                      style: widget.themeService.getTextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFD4AF37),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JuzGlassCard extends StatefulWidget {
  final QuranJuz part;
  final String lang;
  final bool isDarkMode;
  final VoidCallback onTap;
  final ThemeService themeService;

  const _JuzGlassCard({
    required this.part,
    required this.lang,
    required this.isDarkMode,
    required this.onTap,
    required this.themeService,
  });

  @override
  State<_JuzGlassCard> createState() => _JuzGlassCardState();
}

class _JuzGlassCardState extends State<_JuzGlassCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.96),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : _scale,
          duration: const Duration(milliseconds: 150),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? (widget.isDarkMode ? const Color(0xFF144D32).withValues(alpha: 0.8) : Colors.white)
                      : (widget.isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.65) : Colors.white.withValues(alpha: 0.8)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered ? const Color(0xFFD4AF37).withValues(alpha: 0.8) : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                    width: _isHovered ? 2 : 1
                  ),
                  boxShadow: !widget.isDarkMode ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))] : [],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'الجزء',
                        style: GoogleFonts.amiri(
                          color: _isHovered ? (widget.isDarkMode ? Colors.white : Colors.black87) : const Color(0xFFD4AF37),
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${widget.part.id}',
                        style: TextStyle(
                          color: _isHovered ? const Color(0xFFD4AF37) : (widget.isDarkMode ? Colors.white : Colors.black87),
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          widget.lang == 'ar' ? widget.part.titleAr : widget.part.titleEn,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: widget.themeService.getTextStyle(
                            fontSize: 14,
                            color: widget.isDarkMode ? Colors.white.withValues(alpha: 0.8) : Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 4: FULL MUSHAF CONTINUOUS READER
// ==========================================
class FullMushafReaderScreen extends StatefulWidget {
  final String lang;
  final ThemeService themeService;

  const FullMushafReaderScreen({
    super.key,
    required this.lang,
    required this.themeService,
  });

  @override
  State<FullMushafReaderScreen> createState() => _FullMushafReaderScreenState();
}

class _FullMushafReaderScreenState extends State<FullMushafReaderScreen> {
  late ScrollController _scrollController;
  final List<QuranSurah> _allSurahChunks = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    for (var juz in QuranData.parts) {
      _allSurahChunks.addAll(juz.surahs);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isArabic = widget.lang == 'ar';

    return Scaffold(
      backgroundColor: isDarkMode ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF5F5F5),
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 24),
                      onPressed: () => Navigator.pop(context)
                    ),
                    Expanded(
                      child: Text(
                        isArabic ? 'المصحف الشريف' : 'The Holy Quran',
                        textAlign: TextAlign.center,
                        style: widget.themeService.getTextStyle(
                          fontSize: isArabic ? 26 : 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                        ),
                      )
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      itemCount: _allSurahChunks.length,
                      itemBuilder: (context, index) {
                        return _MushafChunkBlock(
                          surahChunk: _allSurahChunks[index],
                          lang: widget.lang,
                          isDarkMode: isDarkMode,
                          themeService: widget.themeService,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MushafChunkBlock extends StatefulWidget {
  final QuranSurah surahChunk;
  final String lang;
  final bool isDarkMode;
  final ThemeService themeService;

  const _MushafChunkBlock({
    required this.surahChunk,
    required this.lang,
    required this.isDarkMode,
    required this.themeService,
  });

  @override
  State<_MushafChunkBlock> createState() => _MushafChunkBlockState();
}

class _MushafChunkBlockState extends State<_MushafChunkBlock> {
  late List<TapGestureRecognizer> _tapRecognizers;
  int? _tappedVerseIndex;

  @override
  void initState() {
    super.initState();
    _tapRecognizers = List.generate(
      widget.surahChunk.versesAr.length,
      (index) => TapGestureRecognizer()..onTap = () {
        setState(() => _tappedVerseIndex = index);
        _showTafseerSheet(context, index).whenComplete(() {
          if (mounted) setState(() => _tappedVerseIndex = null);
        });
      }
    );
  }

  Future<void> _showTafseerSheet(BuildContext context, int verseIndex) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _TafseerBottomSheet(
          surah: widget.surahChunk,
          verseIndex: verseIndex,
          lang: widget.lang,
          trueVerseNumber: verseIndex + widget.surahChunk.startingVerseNumber,
          themeService: widget.themeService,
        );
      },
    );
  }

  @override
  void dispose() {
    for (var recognizer in _tapRecognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];

    for (int i = 0; i < widget.surahChunk.versesAr.length; i++) {
      final verseNum = i + widget.surahChunk.startingVerseNumber;
      final isTappedHighlight = _tappedVerseIndex == i;

      spans.add(
        TextSpan(
          text: '${widget.surahChunk.versesAr[i]} ',
          style: GoogleFonts.amiri(
            fontSize: 28,
            color: widget.isDarkMode ? Colors.white : Colors.black87,
            backgroundColor: isTappedHighlight ? const Color(0xFFD4AF37).withValues(alpha: 0.3) : Colors.transparent,
            height: 2.2,
          ),
          recognizer: _tapRecognizers[i],
        ),
      );

      spans.add(
        TextSpan(
          text: ' ﴿$verseNum﴾ ',
          style: TextStyle(
            fontSize: 22,
            color: isTappedHighlight ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withValues(alpha: 0.7),
            backgroundColor: isTappedHighlight ? const Color(0xFFD4AF37).withValues(alpha: 0.3) : Colors.transparent,
            fontFamily: 'Amiri',
          ),
        ),
      );
    }

    return Column(
      children: [
        if (widget.surahChunk.startingVerseNumber == 1) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
            ),
            child: Text(
              widget.lang == 'ar' ? 'سورة ${widget.surahChunk.nameAr}' : widget.surahChunk.nameEn,
              style: GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.surahChunk.id != 1 && widget.surahChunk.id != 9)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', style: GoogleFonts.amiri(fontSize: 32, color: const Color(0xFFD4AF37), fontWeight: FontWeight.bold))
            ),
        ],

        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(children: spans),
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// RANGE SELECTION SHARE DIALOG
// ==========================================
class _ShareVerseDialog extends StatefulWidget {
  final QuranSurah surah;
  final int initialVerseIndex;
  final String lang;
  final ThemeService themeService;

  const _ShareVerseDialog({
    required this.surah,
    required this.initialVerseIndex,
    required this.lang,
    required this.themeService,
  });

  @override
  State<_ShareVerseDialog> createState() => _ShareVerseDialogState();
}

class _ShareVerseDialogState extends State<_ShareVerseDialog> {
  late int startIdx;
  late int endIdx;

  @override
  void initState() {
    super.initState();
    startIdx = widget.initialVerseIndex;
    endIdx = widget.initialVerseIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    String combinedAr = '';
    String combinedTrans = '';

    for (int i = startIdx; i <= endIdx; i++) {
      int trueVerseNum = i + widget.surah.startingVerseNumber;
      combinedAr += '${widget.surah.versesAr[i]} ﴿$trueVerseNum﴾ ';

      if (widget.lang == 'fr' && i < widget.surah.versesFr.length) {
        combinedTrans += '${widget.surah.versesFr[i]} ';
      } else if (i < widget.surah.versesEn.length) {
        combinedTrans += '${widget.surah.versesEn[i]} ';
      }
    }

    return Dialog(
      backgroundColor: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.lang == 'ar' ? 'مشاركة الآيات' : 'Share Verses',
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(fontSize: 24, color: const Color(0xFFD4AF37), fontWeight: FontWeight.bold),
            ),
            const Divider(color: Color(0xFFD4AF37)),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      widget.lang == 'ar' ? 'من آية' : 'From Verse',
                      style: widget.themeService.getTextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    DropdownButton<int>(
                      dropdownColor: isDarkMode ? const Color(0xFF144D32) : Colors.white,
                      value: startIdx,
                      items: List.generate(widget.surah.versesAr.length, (i) {
                        return DropdownMenuItem(
                          value: i,
                          child: Text(
                            '${i + widget.surah.startingVerseNumber}',
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        );
                      }),
                      onChanged: (val) {
                        setState(() {
                          startIdx = val!;
                          if (endIdx < startIdx) endIdx = startIdx;
                        });
                      },
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_rounded, color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                Column(
                  children: [
                    Text(
                      widget.lang == 'ar' ? 'إلى آية' : 'To Verse',
                      style: widget.themeService.getTextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    DropdownButton<int>(
                      dropdownColor: isDarkMode ? const Color(0xFF144D32) : Colors.white,
                      value: endIdx,
                      items: List.generate(widget.surah.versesAr.length, (i) {
                        return DropdownMenuItem(
                          value: i,
                          child: Text(
                            '${i + widget.surah.startingVerseNumber}',
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        );
                      }).where((item) => item.value! >= startIdx).toList(),
                      onChanged: (val) => setState(() => endIdx = val!),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (endIdx - startIdx > 5)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(
                      widget.lang == 'ar' ? 'تحديد آيات كثيرة قد يؤدي إلى تصغير النص في الصورة.' : 'Selecting many verses may make the text very small in the image.',
                      style: const TextStyle(fontSize: 12, color: Colors.orange),
                    )),
                  ],
                ),
              ),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.share_rounded),
              label: Text(
                widget.lang == 'ar' ? 'مشاركة كصورة' : 'Share as Image',
                style: widget.themeService.getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                ShareImageGenerator.generateAndShareImageWithWidget(
                  title: combinedAr,
                  subtitle: combinedTrans,
                  isDarkMode: isDarkMode,
                  lang: widget.lang,
                  context: context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}