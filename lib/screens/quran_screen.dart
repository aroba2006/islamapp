import 'package:flutter/material.dart';
import 'dart:ui'; // Required for BackdropFilter (Glassmorphism)
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/quran_data.dart';
import '../l10n/app_localizations.dart';
import '../services/quran_reciter_service.dart';
import '../widgets/islamic_pattern_background.dart';

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

  String _removeDiacritics(String text) {
    return text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _searchResults.clear();

      if (query.trim().isEmpty) return;

      final cleanQuery = _removeDiacritics(query.toLowerCase().trim());

      for (var juz in QuranData.parts) {
        for (var surah in juz.surahs) {
          for (int i = 0; i < surah.versesAr.length; i++) {
            final cleanVerseAr = _removeDiacritics(surah.versesAr[i]);
            final verseEn = i < surah.versesEn.length ? surah.versesEn[i].toLowerCase() : '';

            if (cleanVerseAr.contains(cleanQuery) || verseEn.contains(cleanQuery)) {
              _searchResults.add({
                'surah': surah,
                'verseIndex': i,
                'verseAr': surah.versesAr[i],
                'verseEn': i < surah.versesEn.length ? surah.versesEn[i] : '',
                'searchQuery': query,
              });
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';

    return Scaffold(
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
                        style: isArabic 
                            ? GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold)
                            : GoogleFonts.arefRuqaa(color: const Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _performSearch,
                      style: const TextStyle(color: Colors.white),
                      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                      decoration: InputDecoration(
                        hintText: isArabic 
                            ? 'ابحث عن آية أو كلمة...' 
                            : (lang == 'fr' ? 'Rechercher un verset ou mot...' : 'Search for a verse or word...'),
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                        filled: true,
                        fillColor: const Color(0xFF0B3D2E).withValues(alpha: 0.65),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white54),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: _searchQuery.isEmpty
                        ? _buildPartsGrid(context, lang)
                        : _buildSearchResults(context, lang),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartsGrid(BuildContext context, String lang) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemCount: QuranData.parts.length,
      itemBuilder: (context, index) {
        final part = QuranData.parts[index];
        return _JuzGlassCard(
          part: part,
          lang: lang,
          onTap: () => _navigateToPartSurahs(context, part, lang),
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context, String lang) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          lang == 'ar' 
              ? 'لم يتم العثور على نتائج'
              : (lang == 'fr' ? 'Aucun résultat trouvé' : 'No results found'),
          style: GoogleFonts.elMessiri(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final surah = result['surah'] as QuranSurah;
        final verseIndex = result['verseIndex'] as int;

        return _SearchResultGlassCard(
          surah: surah,
          verseIndex: verseIndex,
          verseAr: result['verseAr'] as String,
          lang: lang,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurahReaderScreen(
                  surah: surah,
                  lang: lang,
                  highlightedVerseIndex: verseIndex,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToPartSurahs(BuildContext context, QuranJuz part, String lang) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PartSurahsScreen(part: part, lang: lang),
      ),
    );
  }
}

// ── NEW: FROSTED GLASS SEARCH RESULT CARD ────────────────────────
class _SearchResultGlassCard extends StatefulWidget {
  final QuranSurah surah;
  final int verseIndex;
  final String verseAr;
  final String lang;
  final VoidCallback onTap;

  const _SearchResultGlassCard({
    required this.surah,
    required this.verseIndex,
    required this.verseAr,
    required this.lang,
    required this.onTap,
  });

  @override
  State<_SearchResultGlassCard> createState() => _SearchResultGlassCardState();
}

class _SearchResultGlassCardState extends State<_SearchResultGlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final verseNum = widget.verseIndex + 1;
    String cardLabel = '';
    
    if (widget.lang == 'ar') {
      cardLabel = '${widget.surah.nameAr} - الآية $verseNum';
    } else if (widget.lang == 'fr') {
      cardLabel = '${widget.surah.nameEn} - Verset $verseNum';
    } else {
      cardLabel = '${widget.surah.nameEn} - Verse $verseNum';
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isHovered 
                        ? const Color(0xFF144D32).withValues(alpha: 0.8) 
                        : const Color(0xFF1B5E3F).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isHovered 
                          ? const Color(0xFFD4AF37) 
                          : const Color(0xFFD4AF37).withValues(alpha: 0.4), 
                      width: _isHovered ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardLabel,
                        style: GoogleFonts.elMessiri(
                          color: const Color(0xFFD4AF37),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.verseAr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          color: Colors.white, 
                          fontSize: 22, 
                          height: 1.8,
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


// ── FROSTED GLASS JUZ SQUARE ──────────────────────────────────
class _JuzGlassCard extends StatefulWidget {
  final QuranJuz part;
  final String lang;
  final VoidCallback onTap;
  
  const _JuzGlassCard({required this.part, required this.lang, required this.onTap});

  @override
  State<_JuzGlassCard> createState() => _JuzGlassCardState();
}

class _JuzGlassCardState extends State<_JuzGlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? const Color(0xFF144D32).withValues(alpha: 0.8)
                      : const Color(0xFF0B3D2E).withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered 
                        ? const Color(0xFFD4AF37).withValues(alpha: 0.8)
                        : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                    width: _isHovered ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'الجزء', 
                        style: GoogleFonts.amiri(
                          color: _isHovered ? Colors.white : const Color(0xFFD4AF37), 
                          fontSize: 20
                        )
                      ),
                      Text(
                        '${widget.part.id}', 
                        style: TextStyle(
                          color: _isHovered ? const Color(0xFFD4AF37) : Colors.white, 
                          fontSize: 42, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.lang == 'ar' ? widget.part.titleAr : widget.part.titleEn,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.elMessiri(
                          color: Colors.white.withValues(alpha: 0.8), 
                          fontSize: 15
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
// SCREEN 2: SURAHS IN A PART
// ==========================================
class PartSurahsScreen extends StatefulWidget {
  final QuranJuz part;
  final String lang;

  const PartSurahsScreen({
    super.key,
    required this.part,
    required this.lang,
  });

  @override
  State<PartSurahsScreen> createState() => _PartSurahsScreenState();
}

class _PartSurahsScreenState extends State<PartSurahsScreen> {
  @override
  Widget build(BuildContext context) {
    final isArabic = widget.lang == 'ar';
    
    return Scaffold(
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
                        isArabic ? widget.part.titleAr : widget.part.titleEn,
                        textAlign: TextAlign.center,
                        style: isArabic
                            ? GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 28, fontWeight: FontWeight.bold)
                            : GoogleFonts.arefRuqaa(color: const Color(0xFFD4AF37), fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                        maxCrossAxisExtent: 250, 
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.0, 
                      ),
                      itemCount: widget.part.surahs.length,
                      itemBuilder: (context, index) {
                        final surah = widget.part.surahs[index];
                        return _SurahGlassCard(surah: surah, lang: widget.lang);
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

class _SurahGlassCard extends StatefulWidget {
  final QuranSurah surah;
  final String lang;
  
  const _SurahGlassCard({required this.surah, required this.lang});

  @override
  State<_SurahGlassCard> createState() => _SurahGlassCardState();
}

class _SurahGlassCardState extends State<_SurahGlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahReaderScreen(surah: widget.surah, lang: widget.lang),
            ),
          );
        },
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? const Color(0xFF144D32).withValues(alpha: 0.8)
                      : const Color(0xFF0B3D2E).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered 
                        ? const Color(0xFFD4AF37).withValues(alpha: 0.8)
                        : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                    width: _isHovered ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                      ),
                      child: Text(
                        '${widget.surah.id}',
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.surah.nameAr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        color: _isHovered ? Colors.white : const Color(0xFFD4AF37),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.surah.nameEn,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.elMessiri(
                        color: Colors.white.withValues(alpha: 0.7), 
                        fontSize: 14
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

  const SurahReaderScreen({
    super.key,
    required this.surah,
    required this.lang,
    this.highlightedVerseIndex = -1,
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

  // Dictionary to store the layout keys for accurate scrolling
  final Map<int, GlobalKey> _verseKeys = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedReciter = QuranReciterService.reciters.first;
    _setupAudioListeners();

    if (widget.highlightedVerseIndex != -1) {
      _scrollToVerse(widget.highlightedVerseIndex);
    }
  }

  void _setupAudioListeners() {
    QuranReciterService.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });
    QuranReciterService.onDurationChanged.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });
    QuranReciterService.onPositionChanged.listen((position) {
      if (mounted) setState(() => _position = position);
    });
  }

  // FIXED: Flawless layout scrolling
  void _scrollToVerse(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = _verseKeys[index]?.currentContext;
      if (targetContext != null) {
        Scrollable.ensureVisible(
          targetContext, 
          duration: const Duration(milliseconds: 800), 
          curve: Curves.easeInOutCubic, 
          alignment: 0.15, // Places the verse comfortably below the top edge
        );
      }
    });
  }

  bool _isVerseHighlighted(int index) {
    return index == widget.highlightedVerseIndex;
  }

  Future<void> _playAudio() async {
    if (_selectedReciter == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await QuranReciterService.playSurah(
        reciter: _selectedReciter!,
        surahNumber: widget.surah.id,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load audio. Please check your connection.';
      });
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

  String _getFrenchVerse(int surahId, int verseIndex, String fallbackEn) {
    final frenchQuran = <int, Map<int, String>>{}; // Populate if needed
    if (frenchQuran.containsKey(surahId) && frenchQuran[surahId]!.containsKey(verseIndex)) {
      return frenchQuran[surahId]![verseIndex]!;
    }
    return fallbackEn;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    QuranReciterService.stopAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      onPopInvokedWithResult: (didPop, result) {
        QuranReciterService.stopAudio();
      },
      child: Scaffold(
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
                        onPressed: () {
                          QuranReciterService.stopAudio();
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Text(
                          appBarTitle,
                          textAlign: TextAlign.center,
                          style: widget.lang == 'ar'
                              ? GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 26, fontWeight: FontWeight.bold)
                              : GoogleFonts.arefRuqaa(color: const Color(0xFFD4AF37), fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      // FIXED: Switched to synchronous SingleChildScrollView so flutter builds all verses instantly
                      // This ensures that the Scrollable.ensureVisible function will never fail!
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          children: [
                            if (widget.surah.id != 1 && widget.surah.id != 9)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Text(
                                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                                  style: GoogleFonts.amiri(
                                    fontSize: 32,
                                    color: const Color(0xFFD4AF37),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (widget.surah.id != 1 && widget.surah.id != 9)
                              Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), indent: 80, endIndent: 80, thickness: 1.5),
                            
                            const SizedBox(height: 16),

                            // Generate all verses
                            ...List.generate(widget.surah.versesAr.length, (index) {
                              final isHighlighted = _isVerseHighlighted(index);
                              final verseKey = _verseKeys.putIfAbsent(index, () => GlobalKey());

                              String translatedVerse = '';
                              if (index < widget.surah.versesEn.length) {
                                if (widget.lang == 'fr') {
                                  translatedVerse = _getFrenchVerse(widget.surah.id, index, widget.surah.versesEn[index]);
                                } else {
                                  translatedVerse = widget.surah.versesEn[index];
                                }
                              }

                              return Container(
                                key: verseKey,
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: isHighlighted 
                                      ? const Color(0xFF1B5E3F).withValues(alpha: 0.7)
                                      : const Color(0xFF0B3D2E).withValues(alpha: 0.4), // Removed heavy BackdropFilter for smooth scrolling
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isHighlighted ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withValues(alpha: 0.15), 
                                    width: isHighlighted ? 2 : 1
                                  ),
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
                                          width: 40,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                                          ),
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Text(
                                            widget.surah.versesAr[index],
                                            textDirection: TextDirection.rtl,
                                            style: GoogleFonts.amiri(
                                              fontSize: 28,
                                              color: isHighlighted ? const Color(0xFFD4AF37) : Colors.white,
                                              height: 2.0,
                                              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    if (translatedVerse.isNotEmpty)
                                      Text(
                                        translatedVerse,
                                        textDirection: TextDirection.ltr,
                                        style: GoogleFonts.elMessiri(
                                          fontSize: 16,
                                          color: isHighlighted ? Colors.white : Colors.white.withValues(alpha: 0.75),
                                          height: 1.6,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Player Section (Glassmorphic)
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B3D2E).withValues(alpha: 0.8),
                        border: Border(top: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3))),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<QuranReciter>(
                                dropdownColor: const Color(0xFF0B3D2E),
                                value: _selectedReciter,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4AF37)),
                                items: QuranReciterService.reciters.map((reciter) {
                                  return DropdownMenuItem(
                                    value: reciter,
                                    child: Text(
                                      widget.lang == 'ar' ? reciter.nameAr : reciter.nameEn,
                                      style: GoogleFonts.elMessiri(color: const Color(0xFFD4AF37), fontSize: 16),
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
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red, width: 1),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _isLoading
                                    ? null
                                    : (_playerState == PlayerState.playing
                                        ? () => QuranReciterService.pauseAudio()
                                        : (_playerState == PlayerState.paused
                                            ? () => QuranReciterService.resumeAudio()
                                            : _playAudio)),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _playerState == PlayerState.playing ? const Color(0xFFD4AF37).withValues(alpha: 0.2) : const Color(0xFFD4AF37),
                                    border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                                  ),
                                  child: _isLoading
                                      ? const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0B3D2E)), strokeWidth: 2),
                                        )
                                      : Icon(
                                          _playerState == PlayerState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                          color: _playerState == PlayerState.playing ? const Color(0xFFD4AF37) : const Color(0xFF0B3D2E),
                                          size: 32,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => QuranReciterService.stopAudio(),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                                  ),
                                  child: const Icon(Icons.stop_rounded, color: Color(0xFFD4AF37), size: 26),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_duration != Duration.zero)
                            Column(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: const Color(0xFFD4AF37),
                                    inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                                    thumbColor: const Color(0xFFD4AF37),
                                    overlayColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                                    trackHeight: 4,
                                  ),
                                  child: Slider(
                                    value: _position.inSeconds.toDouble(),
                                    max: _duration.inSeconds.toDouble(),
                                    onChanged: (value) => QuranReciterService.seek(Duration(seconds: value.toInt())),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_formatDuration(_position), style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                      Text(_formatDuration(_duration), style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                    ],
                                  ),
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