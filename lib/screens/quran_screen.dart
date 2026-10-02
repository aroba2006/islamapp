import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
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
import '../services/timing_service.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../services/tafseer_api_service.dart';

// ==========================================================
// PREMIUM PAGE TRANSITIONS LIBRARY
// ==========================================================
class AppPageTransitions {
  AppPageTransitions._();

  static Route<T> sharedAxisVertical<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 520),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  static Route<T> sharedAxisHorizontal<T>({
    required Widget page,
    bool reverse = false,
    Duration duration = const Duration(milliseconds: 520),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final beginX = reverse ? -0.12 : 0.12;
        final slide = Tween<Offset>(
          begin: Offset(beginX, 0),
          end: Offset.zero,
        ).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  static Route<T> zoomIn<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 560),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
          reverseCurve: Curves.easeInQuart,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

// ==========================================================
// STATIC LOOKUP MAPS — SURAH NAME TRANSLATIONS
// ==========================================================
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

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _isSearchFocused = false;

  late final AnimationController _hintRotator;
  int _hintIndex = 0;
  static const List<String> _searchHintsAr = [
    'ابحث عن سورة بالاسم…',
    'ابحث عن كلمة داخل الآيات…',
    'مثال: "الصبر" أو "الرحمن"…',
    'ابحث بالفرنسية أو الإنجليزية…',
  ];
  static const List<String> _searchHintsEn = [
    'Search for a surah by name…',
    'Search for a word inside verses…',
    'Try: "patience", "mercy", "light"…',
    'Search in Arabic, French or English…',
  ];

  int _viewMode = 0;

  bool _isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).height < 760;

  @override
  void initState() {
    super.initState();
    _hintRotator = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            setState(
                () => _hintIndex = (_hintIndex + 1) % _searchHintsAr.length);
          }
          _hintRotator
            ..reset()
            ..forward();
        }
      });
    _hintRotator.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _hintRotator.dispose();
    super.dispose();
  }

  String _normalizeArabic(String text) {
    String cleaned = text.toLowerCase().trim();
    cleaned = cleaned.replaceAll(
        RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    cleaned = cleaned.replaceAll(RegExp(r'[ىي]'), 'ي');
    cleaned = cleaned.replaceAll('ة', 'ه');
    cleaned = cleaned.replaceAll('ـ', '');
    cleaned = cleaned.replaceAll('صلوة', 'صلاه');
    cleaned = cleaned.replaceAll('زكوة', 'زكاه');
    cleaned = cleaned.replaceAll('حيوة', 'حياه');
    cleaned = cleaned.replaceAll('مشكوة', 'مشكاه');
    cleaned = cleaned.replaceAll('ابراهيم', 'ابرهيم');
    cleaned = cleaned.replaceAll('اسماعيل', 'اسمعيل');
    cleaned = cleaned.replaceAll('اسحاق', 'اسحق');
    cleaned = cleaned.replaceAll('سليمان', 'سليمن');
    cleaned = cleaned.replaceAll('هارون', 'هرون');
    cleaned = cleaned.replaceAll('داوود', 'داود');
    cleaned = cleaned.replaceAll('ياسين', 'يس');
    cleaned = cleaned.replaceAll('سماوات', 'سموت');
    cleaned = cleaned.replaceAll('سموات', 'سموت');
    return cleaned;
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _searchQuery = query;
      _searchResults.clear();
      _isSearching = true;
    });

    if (query.trim().isEmpty) {
      setState(() => _isSearching = false);
      return;
    }

    final results = _executeSearch(query);

    if (mounted) {
      setState(() {
        _searchResults.addAll(results);
        _isSearching = false;
      });
    }
  }

  List<Map<String, dynamic>> _executeSearch(String query) {
    final cleanQuery = _normalizeArabic(query);
    final cleanQueryLower = query.toLowerCase().trim();
    final results = <Map<String, dynamic>>[];

    if (cleanQuery.isEmpty) return results;

    for (var juz in QuranData.parts) {
      for (var surah in juz.surahs) {
        int startNumber = surah.startingVerseNumber;

        final cleanSurahNameAr = _normalizeArabic(surah.nameAr);
        final surahNameEn = surah.nameEn.toLowerCase();
        final surahNameFr = (surahNamesFr[surah.id] ?? '').toLowerCase();
        final surahNameEnTrans =
            (surahNamesEnTrans[surah.id] ?? '').toLowerCase();

        bool surahNameMatches = cleanSurahNameAr.contains(cleanQuery) ||
            surahNameEn.contains(cleanQueryLower) ||
            surahNameFr.contains(cleanQueryLower) ||
            surahNameEnTrans.contains(cleanQueryLower);

        List<Map<String, dynamic>> matchedVersesForSurah = [];

        for (int i = 0; i < surah.versesAr.length; i++) {
          final cleanVerseAr = _normalizeArabic(surah.versesAr[i]);
          final verseEn =
              i < surah.versesEn.length ? surah.versesEn[i].toLowerCase() : '';
          final verseFr =
              i < surah.versesFr.length ? surah.versesFr[i].toLowerCase() : '';

          bool verseMatches = cleanVerseAr.contains(cleanQuery) ||
              (verseEn.isNotEmpty && verseEn.contains(cleanQueryLower)) ||
              (verseFr.isNotEmpty && verseFr.contains(cleanQueryLower));

          if (verseMatches) {
            final trueVerseNumber = i + startNumber;
            final pageNumber = QuranPageMetadata.getPageForVerse(
                surah.id, trueVerseNumber);

            matchedVersesForSurah.add({
              'verseIndex': i,
              'trueVerseNumber': trueVerseNumber,
              'verseAr': surah.versesAr[i],
              'verseEn': i < surah.versesEn.length ? surah.versesEn[i] : '',
              'pageNumber': pageNumber,
            });
          }
        }

        if (surahNameMatches &&
            matchedVersesForSurah.isEmpty &&
            surah.versesAr.isNotEmpty) {
          final pageNumber =
              QuranPageMetadata.getPageForVerse(surah.id, startNumber);
          matchedVersesForSurah.add({
            'verseIndex': 0,
            'trueVerseNumber': startNumber,
            'verseAr': surah.versesAr[0],
            'verseEn': surah.versesEn.isNotEmpty ? surah.versesEn[0] : '',
            'pageNumber': pageNumber,
          });
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

  Widget _buildToggleSegment(
    int modeValue,
    IconData icon,
    String titleAr,
    String titleEn,
    String titleFr,
    bool isArabic,
    String lang,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final isSelected = _viewMode == modeValue;
    final displayTitle =
        isArabic ? titleAr : (lang == 'fr' ? titleFr : titleEn);
    final compact = _isCompact(context);

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _viewMode = modeValue);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: compact ? 7 : 9, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: compact ? 13 : 15,
                    color: isSelected
                        ? (isDarkMode
                            ? const Color(0xFF0B3D2E)
                            : Colors.white)
                        : (isDarkMode ? Colors.white70 : Colors.black54),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      displayTitle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: themeService.getTextStyle(
                        fontSize: compact ? 11 : 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? (isDarkMode
                                ? const Color(0xFF0B3D2E)
                                : Colors.white)
                            : (isDarkMode ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
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
          backgroundColor: isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : const Color(0xFFF5F5F5),
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      _buildHeader(context, isArabic, isDarkMode, themeService,
                          l10n),
                      _buildSearchBar(
                          isArabic, lang, isDarkMode, themeService),
                      _buildModeToggle(
                          isArabic, lang, isDarkMode, themeService),
                      const SizedBox(height: 4),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 360),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.04),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: _searchQuery.isNotEmpty
                              ? (_isSearching
                                  ? _buildSearchLoadingState(
                                      context, isDarkMode, themeService)
                                  : _buildSearchResults(
                                      context, lang, isDarkMode, themeService))
                              : (_viewMode == 0
                                  ? _buildWholeQuranCover(
                                      context, lang, isDarkMode, themeService)
                                  : _buildPartsGrid(context, lang, isDarkMode,
                                      themeService)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isArabic,
    bool isDarkMode,
    ThemeService themeService,
    AppLocalizations l10n,
  ) {
    final compact = _isCompact(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, compact ? 6 : 8, 16, 2),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFD4AF37), size: 22),
                tooltip: isArabic ? 'رجوع' : 'Back',
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              Expanded(
                child: Text(
                  l10n.quranTitle,
                  textAlign: TextAlign.center,
                  style: themeService.getTextStyle(
                    fontSize: compact ? 22 : 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD4AF37),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          SizedBox(height: compact ? 6 : 10),
          _buildBigLogo(context, isArabic, isDarkMode, themeService),
          SizedBox(height: compact ? 8 : 12),
          _buildStatsStrip(isArabic, isDarkMode, themeService),
        ],
      ),
    );
  }

  Widget _buildBigLogo(
    BuildContext context,
    bool isArabic,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final compact = _isCompact(context);
    final outer = compact ? 68.0 : 84.0;
    final inner = outer - 8;
    final ring = outer - 12;
    final iconSize = outer * (compact ? 0.42 : 0.45);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: Container(
        height: outer,
        width: outer,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: isDarkMode
                ? [const Color(0xFF1B5E3F), const Color(0xFF0B3D2E)]
                : [Colors.white, const Color(0xFFF0E6C8)],
            radius: 0.9,
          ),
          border: Border.all(color: const Color(0xFFD4AF37), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 30),
              builder: (context, t, _) {
                return Transform.rotate(
                  angle: t * 2 * math.pi,
                  child: Container(
                    width: ring,
                    height: ring,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              width: inner,
              height: inner,
              alignment: Alignment.center,
              child: Icon(
                Icons.menu_book_rounded,
                size: iconSize,
                color: isDarkMode ? Colors.white : const Color(0xFF0B3D2E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsStrip(
      bool isArabic, bool isDarkMode, ThemeService themeService) {
    Widget stat(IconData icon, String value, String label) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFD4AF37), size: 15),
            const SizedBox(height: 2),
            Text(
              value,
              style: themeService.getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              label,
              style: themeService.getTextStyle(
                fontSize: 9,
                color: isDarkMode ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF0B3D2E).withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          stat(Icons.book_outlined, '114', isArabic ? 'سورة' : 'Surahs'),
          _statDivider(),
          stat(Icons.format_list_numbered_rounded, '6236',
              isArabic ? 'آية' : 'Verses'),
          _statDivider(),
          stat(Icons.grid_view_rounded, '30', isArabic ? 'جزء' : 'Juz'),
          _statDivider(),
          stat(Icons.translate_rounded, '3', isArabic ? 'لغات' : 'Langs'),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(
      width: 1,
      height: 26,
      color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
    );
  }

  Widget _buildSearchBar(
    bool isArabic,
    String lang,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final compact = _isCompact(context);
    final hints = isArabic ? _searchHintsAr : _searchHintsEn;
    final currentHint = hints[_hintIndex % hints.length];

    return Padding(
      padding: EdgeInsets.fromLTRB(20, compact ? 4 : 8, 20, compact ? 4 : 8),
      child: Column(
        children: [
          Focus(
            onFocusChange: (f) => setState(() => _isSearchFocused = f),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _isSearchFocused
                        ? [
                            BoxShadow(
                              color: const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _performSearch,
                    style: themeService.getTextStyle(
                      fontSize: 15,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      hintText: currentHint,
                      hintStyle: themeService.getTextStyle(
                        fontSize: 13,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.55)
                            : Colors.black54,
                      ),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: Color(0xFFD4AF37), size: 20),
                      prefixIconConstraints: const BoxConstraints(
                          minWidth: 40, minHeight: 40),
                      filled: true,
                      fillColor: isDarkMode
                          ? const Color(0xFF0B3D2E).withValues(alpha: 0.75)
                          : Colors.white.withValues(alpha: 0.9),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded,
                                  size: 18,
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black45),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFFD4AF37), width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isSearchFocused || _searchQuery.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              isArabic
                  ? 'البحث يعمل بدون تشكيل — اكتب كلمة من الآية أو اسم السورة.'
                  : 'Search works without diacritics — type a word from the verse or a Surah name.',
              textAlign: TextAlign.center,
              style: themeService.getTextStyle(
                fontSize: 10,
                color: isDarkMode ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeToggle(
    bool isArabic,
    String lang,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final compact = _isCompact(context);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 20, vertical: compact ? 4 : 6),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.black.withValues(alpha: 0.25)
              : const Color(0xFFD4AF37).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            _buildToggleSegment(
              0,
              Icons.auto_stories_rounded,
              'المصحف',
              'Mushaf',
              'Coran',
              isArabic,
              lang,
              isDarkMode,
              themeService,
            ),
            _buildToggleSegment(
              1,
              Icons.menu_book_rounded,
              'سورة',
              'Surah',
              'Sourate',
              isArabic,
              lang,
              isDarkMode,
              themeService,
            ),
            _buildToggleSegment(
              2,
              Icons.format_list_bulleted_rounded,
              'آية',
              'Verse',
              'Verset',
              isArabic,
              lang,
              isDarkMode,
              themeService,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWholeQuranCover(BuildContext context, String lang,
      bool isDarkMode, ThemeService themeService) {
    final isArabic = lang == 'ar';
    final compact = _isCompact(context);
    final cardH =
        MediaQuery.sizeOf(context).height * (compact ? 0.34 : 0.38);
    final iconSize = compact ? 40.0 : 48.0;
    final titleSize = compact ? 20.0 : 22.0;
    final bodySize = compact ? 11.0 : 12.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  AppPageTransitions.zoomIn(
                    page: const MushafViewerScreen(initialPage: 1),
                  ),
                );
              },
              child: Hero(
                tag: 'whole_quran_cover',
                child: Container(
                  width: double.infinity,
                  height: cardH,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDarkMode
                          ? [
                              const Color(0xFF0B3D2E),
                              const Color(0xFF1B5E3F)
                            ]
                          : [Colors.white, const Color(0xFFF5EFD8)],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border:
                        Border.all(color: const Color(0xFFD4AF37), width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.22),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Icon(Icons.star_border_rounded,
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.4),
                            size: 16),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Icon(Icons.star_border_rounded,
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.4),
                            size: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFD4AF37)
                                    .withValues(alpha: 0.15),
                                border: Border.all(
                                    color: const Color(0xFFD4AF37), width: 2),
                              ),
                              child: Icon(Icons.menu_book_rounded,
                                  size: iconSize,
                                  color: const Color(0xFFD4AF37)),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isArabic
                                  ? 'المصحف الشريف كاملاً'
                                  : (lang == 'fr'
                                      ? 'Le Saint Coran Complet'
                                      : 'The Holy Quran'),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.amiri(
                                fontSize: titleSize,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Flexible(
                              child: Text(
                                isArabic
                                    ? 'تصفّح مستمر لجميع السور من الفاتحة إلى الناس، مع حفظ آخر موضع قراءة.'
                                    : (lang == 'fr'
                                        ? 'Lecture continue de toutes les sourates, de la Fatiha aux Hommes.'
                                        : 'Continuous reading of all 114 surahs from Al-Fatiha to An-Nas.'),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: themeService.getTextStyle(
                                  fontSize: bodySize,
                                  height: 1.45,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD4AF37)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isArabic
                                        ? 'ابدأ القراءة'
                                        : (lang == 'fr'
                                            ? 'Commencer'
                                            : 'Start Reading'),
                                    style: themeService.getTextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? const Color(0xFF0B3D2E)
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_rounded,
                                      size: 15,
                                      color: isDarkMode
                                          ? const Color(0xFF0B3D2E)
                                          : Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _featureChip(
                  Icons.bookmark_added_rounded,
                  isArabic
                      ? 'حفظ تلقائي'
                      : (lang == 'fr' ? 'Reprise' : 'Auto resume'),
                  isDarkMode,
                  themeService),
              const SizedBox(width: 8),
              _featureChip(
                  Icons.graphic_eq_rounded,
                  isArabic
                      ? 'تلاوة صوتية'
                      : (lang == 'fr' ? 'Audio' : 'Audio'),
                  isDarkMode,
                  themeService),
              const SizedBox(width: 8),
              _featureChip(
                  Icons.lightbulb_outline_rounded,
                  isArabic
                      ? 'تفسير ميسّر'
                      : (lang == 'fr' ? 'Tafsir' : 'Tafsir'),
                  isDarkMode,
                  themeService),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureChip(IconData icon, String text, bool isDarkMode,
      ThemeService themeService) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF0B3D2E).withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: const Color(0xFFD4AF37)),
            const SizedBox(height: 3),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: themeService.getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartsGrid(BuildContext context, String lang, bool isDarkMode,
      ThemeService themeService) {
    final compact = _isCompact(context);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: compact ? 175 : 200,
        crossAxisSpacing: compact ? 12 : 16,
        mainAxisSpacing: compact ? 12 : 16,
        mainAxisExtent: compact ? 150 : 165,
      ),
      itemCount: QuranData.parts.length,
      itemBuilder: (context, index) {
        final part = QuranData.parts[index];
        return _JuzGlassCard(
          part: part,
          lang: lang,
          isDarkMode: isDarkMode,
          onTap: () {
            HapticFeedback.selectionClick();
            _navigateToPartSurahs(context, part, lang);
          },
          themeService: themeService,
        );
      },
    );
  }

  Widget _buildSearchLoadingState(
      BuildContext context, bool isDarkMode, ThemeService themeService) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFFD4AF37).withValues(alpha: 0.35)),
                ),
              ),
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                ),
              ),
              const Icon(Icons.search_rounded,
                  color: Color(0xFFD4AF37), size: 20),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            isArabic ? 'جاري البحث في المصحف…' : 'Searching the Quran…',
            style: themeService.getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isArabic
                ? 'نطابق الكلمات بدون تشكيل لتغطية أوسع'
                : 'Matching words without diacritics for wider coverage',
            style: themeService.getTextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.white38 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, String lang,
      bool isDarkMode, ThemeService themeService) {
    final isArabic = lang == 'ar';

    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                  border: Border.all(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.4)),
                ),
                child: const Icon(Icons.search_off_rounded,
                    color: Color(0xFFD4AF37), size: 42),
              ),
              const SizedBox(height: 18),
              Text(
                isArabic
                    ? 'لم يتم العثور على نتائج'
                    : (lang == 'fr'
                        ? 'Aucun résultat trouvé'
                        : 'No results found'),
                style: themeService.getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'جرّب كلمات أقل، أو تحقق من الإملاء، أو ابحث باسم السورة.'
                    : 'Try fewer words, verify spelling, or search by Surah name.',
                textAlign: TextAlign.center,
                style: themeService.getTextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    int totalVerses = 0;
    for (final g in _searchResults) {
      totalVerses += (g['verses'] as List).length;
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      itemCount: _searchResults.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: Color(0xFFD4AF37), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isArabic
                        ? 'تم إيجاد ${_searchResults.length} سورة و $totalVerses آية مطابقة'
                        : 'Found ${_searchResults.length} surah(s) · $totalVerses matching verse(s)',
                    style: themeService.getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final group = _searchResults[index - 1];
        final surah = group['surah'] as QuranSurah;
        final startVerseNumber = group['startVerseNumber'] as int;
        final verses = group['verses'] as List<Map<String, dynamic>>;

        String surahHeaderTitle =
            isArabic ? 'سورة ${surah.nameAr}' : surah.nameEn;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      AppPageTransitions.sharedAxisVertical(
                        page: SurahReaderScreen(
                          surah: surah,
                          lang: lang,
                          startVerseNumber: surah.startingVerseNumber,
                          viewMode: _viewMode == 0 ? 1 : _viewMode,
                          themeService: themeService,
                          searchQuery: _searchQuery,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.15),
                            border: Border.all(
                                color: const Color(0xFFD4AF37)
                                    .withValues(alpha: 0.5)),
                          ),
                          child: const Icon(Icons.menu_book_rounded,
                              color: Color(0xFFD4AF37), size: 16),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          surahHeaderTitle,
                          style: themeService.getTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${verses.length})',
                          style: themeService.getTextStyle(
                            fontSize: 13,
                            color:
                                isDarkMode ? Colors.white54 : Colors.black45,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right_rounded,
                            color: Color(0xFFD4AF37), size: 22),
                      ],
                    ),
                  ),
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
                onTap: () {
                  HapticFeedback.selectionClick();
                  if (_viewMode == 0 && pageNumber != null) {
                    Navigator.push(
                      context,
                      AppPageTransitions.zoomIn(
                        page: MushafViewerScreen(
                          initialPage: pageNumber,
                          highlightSurahId: surah.id,
                          highlightVerseNum: verse['trueVerseNumber'],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      AppPageTransitions.sharedAxisVertical(
                        page: SurahReaderScreen(
                          surah: surah,
                          lang: lang,
                          highlightedVerseIndex: verseIndex,
                          startVerseNumber: startVerseNumber,
                          viewMode: _viewMode == 1 ? 1 : 2,
                          themeService: themeService,
                        ),
                      ),
                    );
                  }
                },
                themeService: themeService,
              );
            }),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Colors.white10, thickness: 1),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPartSurahs(BuildContext context, QuranJuz part, String lang) {
    Navigator.push(
      context,
      AppPageTransitions.sharedAxisVertical(
        page: PartSurahsScreen(part: part, lang: lang, viewMode: _viewMode),
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
    final compact = MediaQuery.sizeOf(context).height < 760;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          backgroundColor: isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : const Color(0xFFF5F5F5),
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Color(0xFFD4AF37),
                                  size: 22),
                              tooltip: isArabic ? 'رجوع' : 'Back',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 40, minHeight: 40),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Expanded(
                              child: Text(
                                isArabic
                                    ? widget.part.titleAr
                                    : widget.part.titleEn,
                                textAlign: TextAlign.center,
                                style: themeService.getTextStyle(
                                  fontSize: compact ? 22 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFD4AF37),
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF0B3D2E)
                                    .withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0xFFD4AF37)
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFD4AF37)
                                      .withValues(alpha: 0.15),
                                  border: Border.all(
                                      color: const Color(0xFFD4AF37)),
                                ),
                                child: Text(
                                  '${widget.part.id}',
                                  style: const TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isArabic
                                          ? 'الجزء ${widget.part.id} من 30'
                                          : 'Juz ${widget.part.id} of 30',
                                      style: themeService.getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      isArabic
                                          ? '${widget.part.surahs.length} سورة'
                                          : '${widget.part.surahs.length} surah(s)',
                                      style: themeService.getTextStyle(
                                        fontSize: 11,
                                        color: isDarkMode
                                            ? Colors.white60
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 36,
                                height: 36,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(
                                      begin: 0, end: widget.part.id / 30),
                                  duration:
                                      const Duration(milliseconds: 900),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, _) {
                                    return CircularProgressIndicator(
                                      value: value,
                                      strokeWidth: 3.5,
                                      backgroundColor: const Color(0xFFD4AF37)
                                          .withValues(alpha: 0.15),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xFFD4AF37)),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: compact ? 175 : 200,
                            crossAxisSpacing: compact ? 12 : 16,
                            mainAxisSpacing: compact ? 12 : 16,
                            mainAxisExtent: compact ? 158 : 175,
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
                              heroTag:
                                  'surah_${widget.part.id}_${widget.part.surahs[index].id}',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
  final String heroTag;

  const _SurahGlassCard({
    required this.surah,
    required this.lang,
    required this.part,
    required this.isDarkMode,
    required this.viewMode,
    required this.themeService,
    required this.heroTag,
  });

  @override
  State<_SurahGlassCard> createState() => _SurahGlassCardState();
}

class _SurahGlassCardState extends State<_SurahGlassCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.lang == 'ar';
    final compact = MediaQuery.sizeOf(context).height < 760;
    final verseCount = widget.surah.versesAr.length;
    final revelation = _revelationLabel(widget.surah.id);
    final medSize = compact ? 46.0 : 52.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.96),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.push(
            context,
            AppPageTransitions.sharedAxisVertical(
              page: SurahReaderScreen(
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
          scale: _isHovered ? 1.04 : _scale,
          duration: const Duration(milliseconds: 150),
          child: Hero(
            tag: widget.heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? (widget.isDarkMode
                            ? const Color(0xFF144D32).withValues(alpha: 0.85)
                            : Colors.white)
                        : (widget.isDarkMode
                            ? const Color(0xFF0B3D2E).withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.85)),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _isHovered
                          ? const Color(0xFFD4AF37).withValues(alpha: 0.9)
                          : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                      width: _isHovered ? 2 : 1,
                    ),
                    boxShadow: !widget.isDarkMode
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: medSize,
                        height: medSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFD4AF37), width: 1.8),
                          color:
                              const Color(0xFFD4AF37).withValues(alpha: 0.12),
                        ),
                        child: Text(
                          '${widget.surah.id}',
                          style: TextStyle(
                            color: const Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                            fontSize: compact ? 15 : 17,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.surah.nameAr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.amiri(
                            color: _isHovered
                                ? (widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black87)
                                : const Color(0xFFD4AF37),
                            fontSize: compact ? 20 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.surah.nameEn,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: widget.themeService.getTextStyle(
                            fontSize: 10.5,
                            color: widget.isDarkMode
                                ? Colors.white.withValues(alpha: 0.75)
                                : Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _pill(
                            '$verseCount ${isArabic ? 'آية' : 'v.'}',
                            widget.isDarkMode,
                          ),
                          const SizedBox(width: 4),
                          _pill(revelation, widget.isDarkMode),
                        ],
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

  Widget _pill(String text, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: widget.themeService.getTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  String _revelationLabel(int surahId) {
    const meccan = {
      1, 6, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 25, 26, 27,
      28, 29, 30, 31, 32, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46,
      50, 51, 52, 53, 54, 56, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78,
      79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96,
      97, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 111, 112, 113, 114,
    };
    final isArabic = widget.lang == 'ar';
    if (meccan.contains(surahId)) {
      return isArabic ? 'مكية' : (widget.lang == 'fr' ? 'Mecquoise' : 'Meccan');
    }
    return isArabic ? 'مدنية' : (widget.lang == 'fr' ? 'Médinoise' : 'Medinan');
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
  final bool autoPlay;
  final String searchQuery;

  const SurahReaderScreen({
    super.key,
    required this.surah,
    required this.lang,
    this.highlightedVerseIndex = -1,
    this.startVerseNumber = 1,
    this.viewMode = 1,
    required this.themeService,
    this.autoPlay = false,
    this.searchQuery = '',
  });

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  //static QuranReciter? _globalSelectedReciter;

  static bool _showTranslation = true;

  double _playbackRate = 1.0;
  late ScrollController _scrollController;
  QuranReciter? _selectedReciter;

  int _lastCommittedAyah = -1;
  Duration _lastCommittedPosition = Duration.zero;
  DateTime? _lastUiCommitAt;
  static const Duration _uiCommitInterval = Duration(seconds: 1);

  Timer? _uiCommitTimer;

  late String _surahSearchQuery;

  bool _isBookmarked = false;
  double _userFontScale = 1.0;

  @override
  void dispose() {
    for (var recognizer in _tapRecognizers) {
      recognizer.dispose();
    }
    _scrollController.dispose();
    _uiCommitTimer?.cancel();
    super.dispose();
  }

  void _maybeCommitUiStateNow() {
    final now = DateTime.now();
    if (_lastUiCommitAt == null ||
        now.difference(_lastUiCommitAt!) >= _uiCommitInterval) {
      _lastUiCommitAt = now;
      if (mounted) {
        setState(() {
          _position = _lastCommittedPosition;
          if (_playerState == PlayerState.stopped &&
              _position.inMilliseconds > 0) {
            _playerState = PlayerState.playing;
          }
        });
      }
    }
  }

  void _scheduleUiCommit() {
    if (_uiCommitTimer == null || !_uiCommitTimer!.isActive) {
      _uiCommitTimer = Timer(_uiCommitInterval, _maybeCommitUiStateNow);
    }
  }

  Future<void> _playSpecificVerse(int index, {bool pauseAfter = false}) async {
    final trueVerseNumber = index + widget.startVerseNumber;
    if (_currentTimings.isEmpty) await _loadTimings();

    final targetTiming = _currentTimings.firstWhere(
      (t) => t.ayah == trueVerseNumber,
      orElse: () => AyahTiming(ayah: -1, startTimeMs: 0, endTimeMs: 0),
    );

    if (targetTiming.ayah != -1) {
      if (pauseAfter) {
        _targetPauseEndTimeMs = targetTiming.endTimeMs;
      } else {
        _targetPauseEndTimeMs = null;
      }

      if (_playerState == PlayerState.stopped || _duration == Duration.zero) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
        try {
          await QuranReciterService.playSurah(
            reciter: _selectedReciter!,
            surahNumber: widget.surah.id,
            surahNameAr: widget.lang == 'ar'
                ? 'سورة ${widget.surah.nameAr}'
                : widget.surah.nameEn,
            reciterName: widget.lang == 'ar'
                ? _selectedReciter!.nameAr
                : _selectedReciter!.nameEn,
            startPosition: Duration(milliseconds: targetTiming.startTimeMs),
          );
        } catch (e) {
          setState(() => _errorMessage = 'Failed to load audio.');
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }
      } else if (_playerState == PlayerState.paused) {
        await QuranReciterService.seek(
            Duration(milliseconds: targetTiming.startTimeMs));
        await QuranReciterService.resumeAudio();
      } else {
        await QuranReciterService.seek(
            Duration(milliseconds: targetTiming.startTimeMs));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF0B3D2E),
            content: Text(
              widget.lang == 'ar'
                  ? 'التوقيت غير متوفر لهذا القارئ'
                  : 'Timings not available for this reciter',
              style: const TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
        );
      }
    }
  }

  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  List<AyahTiming> _currentTimings = [];
  int _activeAyah = -1;
  int? _targetPauseEndTimeMs;
  bool _isLoading = false;
  String? _errorMessage;
  final Map<int, GlobalKey> _verseKeys = {};
  final TextEditingController _surahSearchController = TextEditingController();

  int? _tappedVerseIndex;
  late List<TapGestureRecognizer> _tapRecognizers;

  QuranJuz? _currentJuz;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _surahSearchQuery = widget.searchQuery;

    //_selectedReciter = _globalSelectedReciter;

    _tapRecognizers = List.generate(
      widget.surah.versesAr.length,
      (index) => TapGestureRecognizer()
        ..onTap = () {
          setState(() => _tappedVerseIndex = index);
          _showTafseerSheet(context, index).whenComplete(() {
            if (mounted) setState(() => _tappedVerseIndex = null);
          });
        },
    );

    _loadTimings();
    _setupAudioListeners();

    if (widget.highlightedVerseIndex != -1) {
      _scrollToVerse(widget.highlightedVerseIndex);
    }

    _currentJuz = _getCurrentJuz();

    _playerState = QuranReciterService.playerState;
    _position = QuranReciterService.currentPosition;
    _duration = QuranReciterService.currentDuration;
    if (_currentTimings.isNotEmpty) {
      _activeAyah = _findActiveAyahAtMs(_position.inMilliseconds);
    }

    _loadDefaultReciter().then((_) {
      if (widget.autoPlay && mounted && _selectedReciter != null) {
        _playAudio();
      }
    });
  }

  Future<void> _loadDefaultReciter() async {
    final reciterToLoad = await QuranReciterService.getDefaultReciter();
    if (mounted) {
      setState(() {
        _selectedReciter = reciterToLoad;
        //_globalSelectedReciter = _selectedReciter;
      });
    }
  }

  QuranJuz? _getCurrentJuz() {
    for (var juz in QuranData.parts) {
      for (var s in juz.surahs) {
        if (s.id == widget.surah.id &&
            s.startingVerseNumber == widget.startVerseNumber) {
          return juz;
        }
      }
    }
    return null;
  }

  int _findActiveAyahAtMs(int ms) {
    final timings = _currentTimings;
    if (timings.isEmpty) return -1;

    int best = -1;
    int bestStart = -1;
    for (final t in timings) {
      if (t.startTimeMs > ms) break;
      if (ms <= t.endTimeMs) return t.ayah;
      if (t.startTimeMs > bestStart) {
        bestStart = t.startTimeMs;
        best = t.ayah;
      }
    }
    return best;
  }

  void _setupAudioListeners() {
    QuranReciterService.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.stopped &&
          _lastCommittedPosition.inMilliseconds > 0) {
        _lastCommittedPosition = Duration.zero;
        _lastCommittedAyah = -1;
      }
      setState(() => _playerState = state);
    });
    QuranReciterService.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() => _duration = duration);
    });
    QuranReciterService.onPositionChanged.listen((position) {
      if (!mounted) return;

      _lastCommittedPosition = position;
      _scheduleUiCommit();

      if (_currentTimings.isNotEmpty) {
        final currentPositionMs = position.inMilliseconds;

        if (_targetPauseEndTimeMs != null &&
            currentPositionMs >= _targetPauseEndTimeMs!) {
          QuranReciterService.pauseAudio();
          _targetPauseEndTimeMs = null;
        }

        final activeAyah = _findActiveAyahAtMs(currentPositionMs);
        if (activeAyah != -1 && activeAyah != _lastCommittedAyah) {
          _lastCommittedAyah = activeAyah;
          if (mounted) setState(() => _activeAyah = activeAyah);

          final localIndex = activeAyah - widget.startVerseNumber;
          if (localIndex >= widget.surah.versesAr.length) {
            final nextSurah = _getAdjacentSurah(true);
            if (nextSurah != null) {
              Navigator.pushReplacement(
                context,
                AppPageTransitions.sharedAxisHorizontal(
                  page: SurahReaderScreen(
                    surah: nextSurah['surah'],
                    lang: widget.lang,
                    startVerseNumber: nextSurah['surah'].startingVerseNumber,
                    viewMode: widget.viewMode,
                    themeService: widget.themeService,
                    autoPlay: true,
                  ),
                ),
              );
            } else {
              QuranReciterService.stopAudio();
            }
          } else if (localIndex >= 0) {
            _advanceToIndex(localIndex);
          }
        }
      }
    });
  }

  void _scrollToVerse(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted || !_scrollController.hasClients) return;
        if (widget.viewMode != 2) {
          _runWholeSurahScroll(index);
        } else {
          _runVerseKeyScroll(index);
        }
      });
    });
  }

  void _runWholeSurahScroll(int index) {
    final maxScroll = _scrollController.position.maxScrollExtent;

    int totalChars = 0;
    int charsBeforeIndex = 0;
    for (int i = 0; i < widget.surah.versesAr.length; i++) {
      int length = widget.surah.versesAr[i].length;
      if (i < index) charsBeforeIndex += length;
      totalChars += length;
    }

    final proportion = totalChars > 0 ? (charsBeforeIndex / totalChars) : 0.0;
    final target = (maxScroll * proportion) + 150.0;

    _scrollController.animateTo(
      target.clamp(0.0, maxScroll > 0 ? maxScroll : 0.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _runVerseKeyScroll(int index) {
    final targetKey = _verseKeys.putIfAbsent(index, () => GlobalKey());

    int attempts = 0;
    void tryScroll() {
      if (targetKey.currentContext != null) {
        Scrollable.ensureVisible(
          targetKey.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
          alignment: 0.15,
        );
      } else if (attempts < 5) {
        attempts++;
        Future.delayed(const Duration(milliseconds: 50), tryScroll);
      }
    }

    tryScroll();
  }

  bool _isVerseHighlighted(int index) {
    final trueVerseNumber = index + widget.startVerseNumber;
    return index == widget.highlightedVerseIndex ||
        trueVerseNumber == _activeAyah;
  }

  Future<void> _loadTimings() async {
    if (_selectedReciter?.timingId != null) {
      final timings = await TimingService.fetchTimings(
          _selectedReciter!.timingId!, widget.surah.id);
      if (mounted) {
        setState(() {
          _currentTimings = timings;
          if (timings.isNotEmpty) {
            _duration = Duration(milliseconds: timings.last.endTimeMs);

            if (_position.inMilliseconds > 0) {
              _activeAyah = _findActiveAyahAtMs(_position.inMilliseconds);
              _lastCommittedAyah = _activeAyah;

              final localIndex = _activeAyah - widget.startVerseNumber;
              if (localIndex >= 0 &&
                  localIndex < widget.surah.versesAr.length) {
                _scrollToVerse(localIndex);
              }
            }
          }
        });
      }
    } else {
      if (mounted) setState(() => _currentTimings = []);
    }
  }

  void _advanceToIndex(int index) {
    _scrollToVerse(index);
    if (mounted) setState(() => _activeAyah = index + widget.startVerseNumber);
  }

  Future<void> _playAudio() async {
    if (_selectedReciter == null) return;

    if (_playerState == PlayerState.playing &&
        QuranReciterService.currentSurahNumber == widget.surah.id) {
      if (_currentTimings.isEmpty) {
        await _loadTimings();
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await _loadTimings();

      Duration? startPos;
      if (widget.startVerseNumber > 1 && _currentTimings.isNotEmpty) {
        final targetTiming = _currentTimings.firstWhere(
          (t) => t.ayah == widget.startVerseNumber,
          orElse: () => AyahTiming(ayah: -1, startTimeMs: 0, endTimeMs: 0),
        );
        if (targetTiming.ayah != -1) {
          startPos = Duration(milliseconds: targetTiming.startTimeMs);
        }
      }

      await QuranReciterService.playSurah(
        reciter: _selectedReciter!,
        surahNumber: widget.surah.id,
        surahNameAr: widget.lang == 'ar'
            ? 'سورة ${widget.surah.nameAr}'
            : widget.surah.nameEn,
        reciterName: widget.lang == 'ar'
            ? _selectedReciter!.nameAr
            : _selectedReciter!.nameEn,
        startPosition: startPos,
      );
    } catch (e) {
      setState(() =>
          _errorMessage = 'Failed to load audio. Please check your connection.');
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
          onPlayVerse: () => _playSpecificVerse(verseIndex, pauseAfter: true),
        );
      },
    );
  }

  // ---------------------------------------------------------------
  // Display settings bottom sheet — font size slider + translation
  // toggle (verse-by-verse mode only). Replaces the old inline strip
  // that used to consume ~60 dp of vertical space.
  // ---------------------------------------------------------------
  void _showDisplaySettingsSheet(bool isDarkMode) {
    final isArabic = widget.lang == 'ar';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.4)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white38 : Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    isArabic ? 'إعدادات العرض' : 'Display settings',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      fontSize: 20,
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.text_fields_rounded,
                          color: Color(0xFFD4AF37), size: 20),
                      const SizedBox(width: 10),
                      Text(
                        isArabic ? 'حجم الخط' : 'Text size',
                        style: widget.themeService.getTextStyle(
                          fontSize: 13,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(_userFontScale * 100).toStringAsFixed(0)}%',
                        style: widget.themeService.getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      activeTrackColor: const Color(0xFFD4AF37),
                      inactiveTrackColor:
                          const Color(0xFFD4AF37).withValues(alpha: 0.2),
                      thumbColor: const Color(0xFFD4AF37),
                      overlayColor:
                          const Color(0xFFD4AF37).withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      min: 0.85,
                      max: 1.35,
                      divisions: 10,
                      value: _userFontScale,
                      onChanged: (v) {
                        setSheetState(() {});
                        setState(() => _userFontScale = v);
                      },
                    ),
                  ),
                  if (widget.viewMode == 2) ...[
                    Divider(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                      height: 24,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.translate_rounded,
                            color: Color(0xFFD4AF37), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isArabic
                                    ? 'إظهار الترجمة'
                                    : 'Show translation',
                                style: widget.themeService.getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                              Text(
                                isArabic
                                    ? (_showTranslation
                                        ? 'معروضة أسفل كل آية'
                                        : 'مخفية — الآيات فقط')
                                    : (_showTranslation
                                        ? 'Shown below each verse'
                                        : 'Hidden — Arabic only'),
                                style: widget.themeService.getTextStyle(
                                  fontSize: 10.5,
                                  color: isDarkMode
                                      ? Colors.white38
                                      : Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: _showTranslation,
                          activeColor: const Color(0xFFD4AF37),
                          activeTrackColor:
                              const Color(0xFFD4AF37).withValues(alpha: 0.35),
                          inactiveThumbColor: isDarkMode
                              ? Colors.white54
                              : const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.6),
                          inactiveTrackColor: isDarkMode
                              ? Colors.white12
                              : const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.15),
                          onChanged: (v) {
                            HapticFeedback.selectionClick();
                            setSheetState(() {});
                            setState(() => _showTranslation = v);
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBookNavigation(bool isDarkMode, ThemeService themeService) {
    final l10n = AppLocalizations.of(context)!;
    final prev = _getAdjacentSurah(false);
    final next = _getAdjacentSurah(true);
    final isArabic = widget.lang == 'ar';

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 32),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                  child: Divider(color: Color(0xFFD4AF37), thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  isArabic ? 'تنقل بين السور' : 'Navigate Surahs',
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ),
              const Expanded(
                  child: Divider(color: Color(0xFFD4AF37), thickness: 1)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (prev != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 15),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.previous,
                        style: themeService.getTextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isArabic
                            ? prev['surah'].nameAr
                            : prev['surah'].nameEn,
                        style: themeService.getTextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFD4AF37).withValues(alpha: 0.2),
                    foregroundColor: const Color(0xFFD4AF37),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    QuranReciterService.stopAudio();
                    Navigator.pushReplacement(
                      context,
                      AppPageTransitions.sharedAxisHorizontal(
                        reverse: true,
                        page: SurahReaderScreen(
                          surah: prev['surah'],
                          lang: widget.lang,
                          startVerseNumber:
                              prev['surah'].startingVerseNumber,
                          viewMode: widget.viewMode,
                          themeService: themeService,
                        ),
                      ),
                    );
                  },
                )
              else
                const SizedBox(),
              if (next != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor:
                        isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    QuranReciterService.stopAudio();
                    Navigator.pushReplacement(
                      context,
                      AppPageTransitions.sharedAxisHorizontal(
                        page: SurahReaderScreen(
                          surah: next['surah'],
                          lang: widget.lang,
                          startVerseNumber:
                              next['surah'].startingVerseNumber,
                          viewMode: widget.viewMode,
                          themeService: themeService,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.next,
                            style: themeService.getTextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            isArabic
                                ? next['surah'].nameAr
                                : next['surah'].nameEn,
                            style: themeService.getTextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                    ],
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
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
        if (s.id == widget.surah.id &&
            s.startingVerseNumber == widget.startVerseNumber) {
          if (!getNext) return prev;
          foundCurrent = true;
        }
        prev = {'juz': juz, 'surah': s};
      }
    }
    return null;
  }

  String _normalizeArabic(String text) {
    String cleaned = text.toLowerCase().trim();
    cleaned = cleaned.replaceAll(
        RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'[أإآٱء]'), 'ا');
    cleaned = cleaned.replaceAll(RegExp(r'[ىئي]'), 'ي');
    cleaned = cleaned.replaceAll('ؤ', 'و');
    cleaned = cleaned.replaceAll('ة', 'ه');
    cleaned = cleaned.replaceAll('ـ', '');
    cleaned = cleaned.replaceAll('ابراهيم', 'ابرهيم');
    cleaned = cleaned.replaceAll('اسماعيل', 'اسمعيل');
    cleaned = cleaned.replaceAll('اسحاق', 'اسحق');
    cleaned = cleaned.replaceAll('سليمان', 'سليمن');
    cleaned = cleaned.replaceAll('هارون', 'هرون');
    cleaned = cleaned.replaceAll('داوود', 'داود');
    cleaned = cleaned.replaceAll('ياسين', 'يس');
    cleaned = cleaned.replaceAll('سماوات', 'سموت');
    cleaned = cleaned.replaceAll('سموات', 'سموت');
    return cleaned;
  }

  bool _matchesSearch(int index) {
    if (_surahSearchQuery.trim().isEmpty) return true;

    final query = _normalizeArabic(_surahSearchQuery.trim());
    final cleanAr = _normalizeArabic(widget.surah.versesAr[index]);

    if (cleanAr.contains(query)) return true;

    if (widget.lang == 'fr' && index < widget.surah.versesFr.length) {
      if (widget.surah.versesFr[index].toLowerCase().contains(query)) {
        return true;
      }
    } else if (index < widget.surah.versesEn.length) {
      if (widget.surah.versesEn[index].toLowerCase().contains(query)) {
        return true;
      }
    }
    return false;
  }

  Widget _buildPageView(bool isDarkMode, ThemeService themeService,
      {String searchQuery = ''}) {
    List<InlineSpan> spans = [];
    final isSearching = searchQuery.trim().isNotEmpty;
    final cleanQuery = _normalizeArabic(searchQuery.trim());

    final double arabicFontSize =
        themeService.getScaledSize(24) * _userFontScale;
    final double verseNumberFontSize =
        themeService.getScaledSize(18) * _userFontScale;

    for (int i = 0; i < widget.surah.versesAr.length; i++) {
      final verseNum = i + widget.startVerseNumber;
      final isSearchedHighlight = _isVerseHighlighted(i);
      final isTappedHighlight = _tappedVerseIndex == i;

      final cleanVerse = _normalizeArabic(widget.surah.versesAr[i]);
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
            fontSize: arabicFontSize,
            color: verseColor,
            backgroundColor: verseMatches
                ? const Color(0xFFD4AF37).withValues(alpha: 0.3)
                : (isTappedHighlight
                    ? const Color(0xFFD4AF37).withValues(alpha: 0.25)
                    : Colors.transparent),
            height: 2.2,
            fontWeight:
                (isSearchedHighlight || isTappedHighlight || verseMatches)
                    ? FontWeight.bold
                    : FontWeight.normal,
          ),
          recognizer: _tapRecognizers[i],
        ),
      );

      spans.add(
        TextSpan(
          text: ' ﴿$verseNum﴾ ',
          style: TextStyle(
            fontSize: verseNumberFontSize,
            color: isTappedHighlight || verseMatches
                ? const Color(0xFFD4AF37)
                : const Color(0xFFD4AF37).withValues(alpha: 0.7),
            backgroundColor: verseMatches
                ? const Color(0xFFD4AF37).withValues(alpha: 0.3)
                : (isTappedHighlight
                    ? const Color(0xFFD4AF37).withValues(alpha: 0.25)
                    : Colors.transparent),
            fontFamily: 'Amiri',
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF0B3D2E).withValues(alpha: 0.4)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
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

  Widget _buildReadingProgressBar(bool isDarkMode) {
    final total = widget.surah.versesAr.length;
    if (total == 0) return const SizedBox.shrink();
    double progress = 0;
    if (_activeAyah >= 0) {
      progress = ((_activeAyah - widget.startVerseNumber + 1) / total)
          .clamp(0.0, 1.0);
    } else if (widget.highlightedVerseIndex >= 0) {
      progress = (widget.highlightedVerseIndex + 1) / total;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.auto_stories_rounded,
              size: 14, color: Color(0xFFD4AF37)),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) {
                  return LinearProgressIndicator(
                    value: v,
                    minHeight: 6,
                    backgroundColor:
                        const Color(0xFFD4AF37).withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFD4AF37)),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: widget.themeService.getTextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD4AF37),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeService = widget.themeService;
    final isArabic = widget.lang == 'ar';

    final double translationFontSize =
        themeService.getScaledSize(16) * _userFontScale;

    String appBarTitle;
    if (widget.lang == 'ar') {
      appBarTitle = 'سورة ${widget.surah.nameAr}';
    } else if (widget.lang == 'fr') {
      appBarTitle =
          '${widget.surah.nameEn} (${surahNamesFr[widget.surah.id] ?? ''})';
    } else {
      appBarTitle =
          '${widget.surah.nameEn} (${surahNamesEnTrans[widget.surah.id] ?? ''})';
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        QuranReciterService.stopAudio();
      },
      child: Scaffold(
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : const Color(0xFFF5F5F5),
        body: IslamicPatternBackground(
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Color(0xFFD4AF37),
                                size: 22),
                            tooltip: isArabic ? 'رجوع' : 'Back',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: () {
                              QuranReciterService.stopAudio();
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  appBarTitle,
                                  textAlign: TextAlign.center,
                                  style: themeService.getTextStyle(
                                    fontSize: isArabic ? 22 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFD4AF37),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_currentJuz != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD4AF37)
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: const Color(0xFFD4AF37)
                                                  .withValues(alpha: 0.3)),
                                        ),
                                        child: Text(
                                          isArabic
                                              ? _currentJuz!.titleAr
                                              : (widget.lang == 'fr'
                                                  ? 'Juz ${_currentJuz!.id}'
                                                  : _currentJuz!.titleEn),
                                          style: themeService.getTextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFD4AF37),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD4AF37)
                                            .withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                            color: const Color(0xFFD4AF37)
                                                .withValues(alpha: 0.3)),
                                      ),
                                      child: Text(
                                        '${widget.surah.versesAr.length} ${isArabic ? 'آية' : 'verses'}',
                                        style: themeService.getTextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFD4AF37),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ── Display settings (font size + translation) ──
                          IconButton(
                            icon: const Icon(Icons.text_fields_rounded,
                                color: Color(0xFFD4AF37), size: 22),
                            tooltip: isArabic
                                ? 'إعدادات العرض'
                                : 'Display settings',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: () =>
                                _showDisplaySettingsSheet(isDarkMode),
                          ),

                          // ── Bookmark ──
                          IconButton(
                            icon: Icon(
                              _isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: const Color(0xFFD4AF37),
                              size: 22,
                            ),
                            tooltip: _isBookmarked
                                ? (isArabic ? 'إزالة الحفظ' : 'Remove bookmark')
                                : (isArabic ? 'حفظ' : 'Bookmark'),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              setState(() => _isBookmarked = !_isBookmarked);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: const Color(0xFF0B3D2E),
                                  content: Text(
                                    _isBookmarked
                                        ? (isArabic
                                            ? 'تم حفظ موضع القراءة'
                                            : 'Reading position saved')
                                        : (isArabic
                                            ? 'تم إزالة الحفظ'
                                            : 'Bookmark removed'),
                                    style: const TextStyle(
                                        color: Color(0xFFD4AF37)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildReadingProgressBar(isDarkMode),
                    const SizedBox(height: 4),
                    Expanded(
                      child: ListView.builder(
                        cacheExtent: 150000.0, controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        itemCount: widget.viewMode == 2
                            ? widget.surah.versesAr.length + 4
                            : 4,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            if (widget.viewMode == 0) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 8, sigmaY: 8),
                                  child: TextField(
                                    controller: _surahSearchController,
                                    onChanged: (val) => setState(
                                        () => _surahSearchQuery = val),
                                    style: themeService.getTextStyle(
                                      fontSize: 15,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    textDirection: widget.lang == 'ar'
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 8),
                                      hintText: widget.lang == 'ar'
                                          ? 'ابحث داخل السورة…'
                                          : (widget.lang == 'fr'
                                              ? 'Rechercher dans la sourate…'
                                              : 'Search within Surah…'),
                                      hintStyle: themeService.getTextStyle(
                                        fontSize: 13,
                                        color: isDarkMode
                                            ? Colors.white
                                                .withValues(alpha: 0.6)
                                            : Colors.black54,
                                      ),
                                      prefixIcon: const Icon(Icons.search,
                                          color: Color(0xFFD4AF37), size: 20),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 40, minHeight: 40),
                                      filled: true,
                                      fillColor: isDarkMode
                                          ? const Color(0xFF0B3D2E)
                                              .withValues(alpha: 0.65)
                                          : Colors.white
                                              .withValues(alpha: 0.85),
                                      suffixIcon:
                                          _surahSearchQuery.isNotEmpty
                                              ? IconButton(
                                                  icon: Icon(Icons.clear,
                                                      size: 18,
                                                      color: isDarkMode
                                                          ? Colors.white54
                                                          : Colors.black45),
                                                  onPressed: () {
                                                    _surahSearchController
                                                        .clear();
                                                    setState(() =>
                                                        _surahSearchQuery = '');
                                                  },
                                                )
                                              : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                            color: const Color(0xFFD4AF37)
                                                .withValues(alpha: 0.3)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                            color: const Color(0xFFD4AF37)
                                                .withValues(alpha: 0.3)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFD4AF37),
                                            width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          if (index == 1) {
                            if (widget.surah.id != 1 &&
                                widget.surah.id != 9 &&
                                widget.startVerseNumber == 1) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6.0, bottom: 6.0),
                                    child: Text(
                                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                                      style: GoogleFonts.amiri(
                                        fontSize: themeService
                                                .getScaledSize(30) *
                                            _userFontScale,
                                        color: const Color(0xFFD4AF37),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: const Color(0xFFD4AF37)
                                        .withValues(alpha: 0.5),
                                    indent: 60,
                                    endIndent: 60,
                                    thickness: 1.5,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }

                          if (index == 2) {
                            if (widget.viewMode == 0 || widget.viewMode == 1) {
                              return _buildPageView(
                                  isDarkMode, themeService,
                                  searchQuery: _surahSearchQuery);
                            }
                            return const SizedBox.shrink();
                          }

                          if (index ==
                              (widget.viewMode == 2
                                  ? widget.surah.versesAr.length + 3
                                  : 3)) {
                            return _buildBookNavigation(
                                isDarkMode, themeService);
                          }

                          int verseIndex = index - 3;
                          if (verseIndex < 0 ||
                              verseIndex >= widget.surah.versesAr.length) {
                            return const SizedBox.shrink();
                          }

                          if (!_matchesSearch(verseIndex)) {
                            return const SizedBox.shrink();
                          }

                          final isHighlighted =
                              _isVerseHighlighted(verseIndex);
                          final isTapped = _tappedVerseIndex == verseIndex;
                          final verseKey = _verseKeys.putIfAbsent(
                              verseIndex, () => GlobalKey());

                          String translatedVerse = '';
                          if (widget.lang == 'fr' &&
                              verseIndex < widget.surah.versesFr.length) {
                            translatedVerse =
                                widget.surah.versesFr[verseIndex];
                          } else if (verseIndex <
                              widget.surah.versesEn.length) {
                            translatedVerse =
                                widget.surah.versesEn[verseIndex];
                          }

                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _tappedVerseIndex = verseIndex);
                              _showTafseerSheet(context, verseIndex)
                                  .whenComplete(() {
                                if (mounted) {
                                  setState(() => _tappedVerseIndex = null);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              key: verseKey,
                              duration: const Duration(milliseconds: 240),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: isHighlighted || isTapped
                                    ? (isDarkMode
                                        ? const Color(0xFF1B5E3F)
                                            .withValues(alpha: 0.7)
                                        : Colors.white)
                                    : (isDarkMode
                                        ? const Color(0xFF0B3D2E)
                                            .withValues(alpha: 0.4)
                                        : Colors.white.withValues(alpha: 0.85)),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isHighlighted || isTapped
                                      ? const Color(0xFFD4AF37)
                                      : const Color(0xFFD4AF37)
                                          .withValues(alpha: 0.15),
                                  width: isHighlighted || isTapped ? 2 : 1,
                                ),
                                boxShadow: !isDarkMode
                                    ? [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    textDirection: TextDirection.ltr,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD4AF37)
                                              .withValues(alpha: 0.12),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: const Color(0xFFD4AF37),
                                              width: 1.5),
                                        ),
                                        child: Text(
                                          '${verseIndex + widget.startVerseNumber}',
                                          style: TextStyle(
                                            color: const Color(0xFFD4AF37),
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                themeService.getScaledSize(13),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          widget.surah.versesAr[verseIndex],
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          style: GoogleFonts.amiri(
                                            fontSize: themeService
                                                    .getScaledSize(23) *
                                                _userFontScale,
                                            color: isHighlighted || isTapped
                                                ? const Color(0xFFD4AF37)
                                                : (isDarkMode
                                                    ? Colors.white
                                                    : Colors.black87),
                                            height: 1.8,
                                            fontWeight:
                                                isHighlighted || isTapped
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (_showTranslation &&
                                      translatedVerse.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? Colors.black
                                                .withValues(alpha: 0.15)
                                            : const Color(0xFFD4AF37)
                                                .withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.lang == 'fr'
                                                ? 'Traduction'
                                                : 'Translation',
                                            style: themeService.getTextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                              color: const Color(0xFFD4AF37),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            translatedVerse,
                                            textDirection: TextDirection.ltr,
                                            style: themeService.getTextStyle(
                                              fontSize: translationFontSize,
                                              color: isHighlighted || isTapped
                                                  ? (isDarkMode
                                                      ? Colors.white
                                                          .withValues(
                                                              alpha: 0.9)
                                                      : Colors.black87)
                                                  : (isDarkMode
                                                      ? Colors.white
                                                          .withValues(
                                                              alpha: 0.5)
                                                      : Colors.black
                                                          .withValues(
                                                              alpha: 0.55)),
                                              height: 1.6,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Divider(
                                      color: const Color(0xFFD4AF37)
                                          .withValues(alpha: 0.2)),
                                  Wrap(
                                    alignment: widget.lang == 'ar'
                                        ? WrapAlignment.start
                                        : WrapAlignment.end,
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      TextButton.icon(
                                        icon: const Icon(Icons.share_rounded,
                                            color: Color(0xFFD4AF37),
                                            size: 16),
                                        label: Text(
                                          widget.lang == 'ar'
                                              ? 'مشاركة'
                                              : 'Share',
                                          style: themeService.getTextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFD4AF37),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          backgroundColor:
                                              const Color(0xFFD4AF37)
                                                  .withValues(alpha: 0.1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                _ShareVerseDialog(
                                              surah: widget.surah,
                                              initialVerseIndex: verseIndex,
                                              lang: widget.lang,
                                              themeService: themeService,
                                            ),
                                          );
                                        },
                                      ),
                                      TextButton.icon(
                                        icon: const Icon(
                                            Icons.menu_book_rounded,
                                            color: Color(0xFFD4AF37),
                                            size: 16),
                                        label: Text(
                                          widget.lang == 'ar'
                                              ? 'التفسير'
                                              : (widget.lang == 'fr'
                                                  ? 'Tafsir'
                                                  : 'Tafseer'),
                                          style: themeService.getTextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFD4AF37),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          backgroundColor:
                                              const Color(0xFFD4AF37)
                                                  .withValues(alpha: 0.1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        onPressed: () => _showTafseerSheet(
                                            context, verseIndex),
                                      ),
                                      TextButton.icon(
                                        icon: const Icon(
                                            Icons.play_circle_outline_rounded,
                                            color: Color(0xFFD4AF37),
                                            size: 16),
                                        label: Text(
                                          widget.lang == 'ar'
                                              ? 'تشغيل'
                                              : 'Play',
                                          style: themeService.getTextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFD4AF37),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          backgroundColor:
                                              const Color(0xFFD4AF37)
                                                  .withValues(alpha: 0.1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        onPressed: () => _playSpecificVerse(
                                            verseIndex,
                                            pauseAfter: true),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _buildPlayerFooter(isDarkMode, themeService),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerFooter(bool isDarkMode, ThemeService themeService) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF0B3D2E).withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.95),
            border: Border(
                top: BorderSide(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.3))),
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.black.withValues(alpha: 0.2)
                      : const Color(0xFFD4AF37).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<QuranReciter>(
                    dropdownColor:
                        isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
                    value: _selectedReciter,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color(0xFFD4AF37)),
                    items: QuranReciterService.reciters.map((reciter) {
                      return DropdownMenuItem(
                        value: reciter,
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFD4AF37)
                                    .withValues(alpha: 0.15),
                                border: Border.all(
                                    color: const Color(0xFFD4AF37)
                                        .withValues(alpha: 0.5)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/reciters/${reciter.imageFileName}',
                                  fit: BoxFit.cover,
                                  cacheWidth: 110,
                                  cacheHeight: 110,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return const Icon(Icons.person,
                                        size: 20,
                                        color: Color(0xFFD4AF37));
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.lang == 'ar'
                                        ? reciter.nameAr
                                        : reciter.nameEn,
                                    style: themeService.getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDarkMode
                                          ? const Color(0xFFD4AF37)
                                          : Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    widget.lang == 'ar'
                                        ? 'قارئ معتمد'
                                        : 'Verified reciter',
                                    style: themeService.getTextStyle(
                                      fontSize: 9.5,
                                      color: isDarkMode
                                          ? Colors.white54
                                          : Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (reciter) {
                      if (reciter != null &&
                          _playerState == PlayerState.playing) {
                        QuranReciterService.stopAudio();
                      }
                      setState(() {
                        _selectedReciter = reciter;
                       // _globalSelectedReciter = reciter;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_errorMessage!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11)),
                      ),
                    ],
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : (_playerState == PlayerState.playing
                            ? () {
                                HapticFeedback.selectionClick();
                                QuranReciterService.pauseAudio();
                              }
                            : (_playerState == PlayerState.paused
                                ? () {
                                    HapticFeedback.selectionClick();
                                    _targetPauseEndTimeMs = null;
                                    QuranReciterService.resumeAudio();
                                  }
                                : () {
                                    HapticFeedback.mediumImpact();
                                    _targetPauseEndTimeMs = null;
                                    _playAudio();
                                  })),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _playerState == PlayerState.playing
                            ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                            : const Color(0xFFD4AF37),
                        border: Border.all(
                            color: const Color(0xFFD4AF37), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(13.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF0B3D2E)),
                                strokeWidth: 2.5,
                              ),
                            )
                          : Icon(
                              _playerState == PlayerState.playing
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: _playerState == PlayerState.playing
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFF0B3D2E),
                              size: 28,
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      QuranReciterService.stopAudio();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFD4AF37), width: 2),
                      ),
                      child: const Icon(Icons.stop_rounded,
                          color: Color(0xFFD4AF37), size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  PopupMenuButton<double>(
                    initialValue: _playbackRate,
                    tooltip: widget.lang == 'ar'
                        ? 'سرعة القراءة'
                        : 'Playback Speed',
                    color:
                        isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.3)),
                    ),
                    offset: const Offset(0, -240),
                    onSelected: (double rate) {
                      setState(() => _playbackRate = rate);
                      QuranReciterService.setPlaybackRate(rate);
                    },
                    itemBuilder: (BuildContext context) {
                      final speeds = [2.0, 1.5, 1.0, 0.5, 0.25];
                      return speeds.map((speed) {
                        return PopupMenuItem<double>(
                          value: speed,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                speed == 1.0
                                    ? (widget.lang == 'ar'
                                        ? '1.0x (عادي)'
                                        : '1.0x (Normal)')
                                    : '${speed}x',
                                style: themeService.getTextStyle(
                                  fontSize: 13,
                                  fontWeight: _playbackRate == speed
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: _playbackRate == speed
                                      ? const Color(0xFFD4AF37)
                                      : (isDarkMode
                                          ? Colors.white70
                                          : Colors.black87),
                                ),
                              ),
                              if (_playbackRate == speed)
                                const Icon(Icons.check_rounded,
                                    color: Color(0xFFD4AF37), size: 18),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            const Color(0xFFD4AF37).withValues(alpha: 0.1),
                        border: Border.all(
                            color: const Color(0xFFD4AF37), width: 2),
                      ),
                      child: Text(
                        '${_playbackRate}x',
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (_duration != Duration.zero)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: const Color(0xFFD4AF37),
                          inactiveTrackColor: isDarkMode
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.black12,
                          thumbColor: const Color(0xFFD4AF37),
                          overlayColor:
                              const Color(0xFFD4AF37).withValues(alpha: 0.3),
                          trackHeight: 4,
                        ),
                        child: Builder(
                          builder: (context) {
                            double maxSecs = _duration.inSeconds.toDouble();
                            double posSecs = _position.inSeconds.toDouble();

                            if (maxSecs <= 0) maxSecs = 1.0;
                            if (posSecs > maxSecs) posSecs = maxSecs;
                            if (posSecs < 0) posSecs = 0;

                            return Slider(
                              value: posSecs,
                              max: maxSecs,
                              onChanged: (value) => QuranReciterService.seek(
                                  Duration(seconds: value.toInt())),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(_position),
                                style: themeService.getTextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54)),
                            Text(_formatDuration(_duration),
                                style: themeService.getTextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TafseerBottomSheet extends StatefulWidget {
  final QuranSurah surah;
  final int verseIndex;
  final String lang;
  final int trueVerseNumber;
  final ThemeService themeService;
  final VoidCallback? onPlayVerse;

  const _TafseerBottomSheet({
    required this.surah,
    required this.verseIndex,
    required this.lang,
    required this.trueVerseNumber,
    required this.themeService,
    this.onPlayVerse,
  });

  @override
  State<_TafseerBottomSheet> createState() => _TafseerBottomSheetState();
}

class _TafseerBottomSheetState extends State<_TafseerBottomSheet> {
  int _selectedScholar = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isArabic = widget.lang == 'ar';

    final tafseerVerse =
        TafseerData.getTafseerForVerse(widget.surah.id, widget.trueVerseNumber);
    final arabicMuyassar = tafseerVerse?.tafseerAr ?? '';
    final englishText = tafseerVerse?.tafseerEn ?? '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border:
            Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4)),
      ),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 5,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white38 : Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.black.withValues(alpha: 0.2)
                  : const Color(0xFFD4AF37).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
            ),
            child: Text(
              widget.surah.versesAr[widget.verseIndex],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black87,
                height: 1.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: isArabic ? 130.0 : 14.0,
                    right: isArabic ? 14.0 : 130.0,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isArabic
                          ? 'تفسير الآية ${widget.trueVerseNumber}'
                          : (widget.lang == 'fr'
                              ? 'Tafsir du verset ${widget.trueVerseNumber}'
                              : 'Tafseer of Verse ${widget.trueVerseNumber}'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        fontSize: 20,
                        color: const Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: isArabic ? 0 : null,
                  right: isArabic ? null : 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy_rounded,
                            color: Color(0xFFD4AF37), size: 20),
                        tooltip: isArabic ? 'نسخ' : 'Copy',
                        onPressed: () {
                          final verseText =
                              '${widget.surah.versesAr[widget.verseIndex]} ﴿${widget.trueVerseNumber}﴾';
                          Clipboard.setData(ClipboardData(text: verseText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF0B3D2E),
                              content: Text(
                                isArabic ? 'تم نسخ الآية' : 'Verse copied',
                                style: const TextStyle(
                                    color: Color(0xFFD4AF37)),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      if (widget.onPlayVerse != null)
                        IconButton(
                          icon: const Icon(
                              Icons.play_circle_outline_rounded,
                              color: Color(0xFFD4AF37),
                              size: 20),
                          tooltip: isArabic ? 'تشغيل' : 'Play',
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onPlayVerse!();
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.share_rounded,
                            color: Color(0xFFD4AF37), size: 20),
                        tooltip: isArabic ? 'مشاركة' : 'Share',
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (ctx) => _ShareVerseDialog(
                              surah: widget.surah,
                              initialVerseIndex: widget.verseIndex,
                              lang: widget.lang,
                              themeService: widget.themeService,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.black26
                  : const Color(0xFFD4AF37).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedScholar = 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedScholar == 0
                            ? const Color(0xFFD4AF37)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        isArabic
                            ? 'التفسير الميسّر'
                            : (widget.lang == 'fr'
                                ? 'Al-Muyassar'
                                : 'Al-Muyassar'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: _selectedScholar == 0
                              ? (isDarkMode
                                  ? const Color(0xFF0B3D2E)
                                  : Colors.white)
                              : (isDarkMode
                                  ? Colors.white70
                                  : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedScholar = 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedScholar == 1
                            ? const Color(0xFFD4AF37)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        isArabic
                            ? 'ابن كثير'
                            : (widget.lang == 'fr'
                                ? 'Ibn Kathir'
                                : 'Ibn Kathir'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: _selectedScholar == 1
                              ? (isDarkMode
                                  ? const Color(0xFF0B3D2E)
                                  : Colors.white)
                              : (isDarkMode
                                  ? Colors.white70
                                  : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFD4AF37)),
          const SizedBox(height: 6),
          Expanded(
            child: _selectedScholar == 0
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (arabicMuyassar.isNotEmpty) ...[
                          Text(
                            isArabic ? 'التفسير الميسّر:' : 'Al-Muyassar:',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            arabicMuyassar,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.amiri(
                              fontSize: 17,
                              color:
                                  isDarkMode ? Colors.white : Colors.black87,
                              height: 1.85,
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                        if (englishText.isNotEmpty) ...[
                          Text(
                            'English Translation:',
                            style: widget.themeService.getTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            englishText,
                            textDirection: TextDirection.ltr,
                            style: widget.themeService.getTextStyle(
                              fontSize: 15,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                              height: 1.6,
                            ),
                          ),
                        ],
                        if (arabicMuyassar.isEmpty && englishText.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Column(
                                children: [
                                  const Icon(Icons.menu_book_rounded,
                                      color: Color(0xFFD4AF37), size: 42),
                                  const SizedBox(height: 12),
                                  Text(
                                    isArabic
                                        ? 'التفسير الميسّر غير متوفر لهذه الآية'
                                        : 'Al-Muyassar tafseer is not available for this verse',
                                    textAlign: TextAlign.center,
                                    style: widget.themeService.getTextStyle(
                                      fontSize: 15,
                                      color: isDarkMode
                                          ? Colors.white54
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : FutureBuilder<TafseerVerse?>(
                    future: TafseerApiService.fetchIbnKathirVerse(
                      surahNumber: widget.surah.id,
                      verseNumber: widget.trueVerseNumber,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFD4AF37)),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.wifi_off_rounded,
                                    color: Color(0xFFD4AF37), size: 42),
                                const SizedBox(height: 12),
                                Text(
                                  isArabic
                                      ? 'تعذر تحميل تفسير ابن كثير.\nيرجى التأكد من اتصالك بالإنترنت.'
                                      : 'Could not load Ibn Kathir Tafseer.\nPlease check your connection.',
                                  textAlign: TextAlign.center,
                                  style: widget.themeService.getTextStyle(
                                    fontSize: 15,
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Text(
                          snapshot.data!.tafseerAr,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.amiri(
                            fontSize: 17,
                            color:
                                isDarkMode ? Colors.white : Colors.black87,
                            height: 1.85,
                          ),
                        ),
                      );
                    },
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
  final VoidCallback onTap;
  final ThemeService themeService;

  const _SearchResultGlassCard({
    required this.searchResult,
    required this.lang,
    required this.isDarkMode,
    required this.onTap,
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
    final verseNum = widget.searchResult['trueVerseNumber'] as int;
    final verseAr = widget.searchResult['verseAr'] as String;
    final verseEn = widget.searchResult['verseEn'] as String? ?? '';
    final pageNumber = widget.searchResult['pageNumber'] as int?;
    final isArabic = widget.lang == 'ar';

    String cardLabel = isArabic ? 'الآية $verseNum' : 'Verse $verseNum';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.97),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : _scale,
          duration: const Duration(milliseconds: 150),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? (widget.isDarkMode
                            ? const Color(0xFF144D32).withValues(alpha: 0.85)
                            : Colors.white)
                        : (widget.isDarkMode
                            ? const Color(0xFF1B5E3F).withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.85)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isHovered
                          ? const Color(0xFFD4AF37)
                          : const Color(0xFFD4AF37).withValues(alpha: 0.4),
                      width: _isHovered ? 2 : 1,
                    ),
                    boxShadow: !widget.isDarkMode
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
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
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                          if (pageNumber != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: const Color(0xFFD4AF37)
                                        .withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.description_outlined,
                                      size: 11, color: Color(0xFFD4AF37)),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${isArabic ? 'ص' : 'P'} $pageNumber',
                                    style: widget.themeService.getTextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD4AF37),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        verseAr,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 17,
                          height: 1.7,
                        ),
                      ),
                      if (verseEn.isNotEmpty && widget.lang != 'ar') ...[
                        const SizedBox(height: 6),
                        Text(
                          verseEn,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                          style: widget.themeService.getTextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: widget.isDarkMode
                                ? Colors.white60
                                : Colors.black54,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            isArabic ? 'اضغط للفتح' : 'Tap to open',
                            style: widget.themeService.getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded,
                              size: 13, color: Color(0xFFD4AF37)),
                        ],
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
    final isArabic = widget.lang == 'ar';
    final compact = MediaQuery.sizeOf(context).height < 760;
    final medOuter = compact ? 62.0 : 70.0;
    final medInner = medOuter - 14;

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
          scale: _isHovered ? 1.04 : _scale,
          duration: const Duration(milliseconds: 150),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isHovered
                        ? (widget.isDarkMode
                            ? [
                                const Color(0xFF144D32)
                                    .withValues(alpha: 0.9),
                                const Color(0xFF1B5E3F)
                                    .withValues(alpha: 0.8),
                              ]
                            : [Colors.white, const Color(0xFFF7F1DC)])
                        : (widget.isDarkMode
                            ? [
                                const Color(0xFF0B3D2E)
                                    .withValues(alpha: 0.7),
                                const Color(0xFF0B3D2E)
                                    .withValues(alpha: 0.55),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.9),
                                Colors.white.withValues(alpha: 0.75),
                              ]),
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _isHovered
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: !widget.isDarkMode
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: medOuter,
                            height: medOuter,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.08),
                              border: Border.all(
                                  color: const Color(0xFFD4AF37)
                                      .withValues(alpha: 0.6),
                                  width: 1.5),
                            ),
                          ),
                          Container(
                            width: medInner,
                            height: medInner,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFD4AF37), width: 2),
                              color: const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.12),
                            ),
                            child: Text(
                              '${widget.part.id}',
                              style: TextStyle(
                                color: const Color(0xFFD4AF37),
                                fontWeight: FontWeight.bold,
                                fontSize: compact ? 18 : 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isArabic ? 'الجزء' : 'Juz',
                        style: GoogleFonts.amiri(
                          color: _isHovered
                              ? (widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black87)
                              : const Color(0xFFD4AF37),
                          fontSize: compact ? 13 : 14,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          isArabic
                              ? widget.part.titleAr
                              : widget.part.titleEn,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: widget.themeService.getTextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: widget.isDarkMode
                                ? Colors.white.withValues(alpha: 0.85)
                                : Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '${widget.part.surahs.length} ${isArabic ? "سور" : "surahs"}',
                          style: widget.themeService.getTextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
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
      backgroundColor: isDarkMode
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFF5F5F5),
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xFFD4AF37),
                              size: 22),
                          tooltip: isArabic ? 'رجوع' : 'Back',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 40, minHeight: 40),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                isArabic ? 'المصحف الشريف' : 'The Holy Quran',
                                textAlign: TextAlign.center,
                                style: widget.themeService.getTextStyle(
                                  fontSize: isArabic ? 22 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFD4AF37),
                                ),
                              ),
                              Text(
                                isArabic
                                    ? 'قراءة متواصلة بدون توقف'
                                    : 'Continuous uninterrupted reading',
                                style: widget.themeService.getTextStyle(
                                  fontSize: 10.5,
                                  color: isDarkMode
                                      ? Colors.white60
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
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
                ],
              ),
            ),
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
      (index) => TapGestureRecognizer()
        ..onTap = () {
          setState(() => _tappedVerseIndex = index);
          _showTafseerSheet(context, index).whenComplete(() {
            if (mounted) setState(() => _tappedVerseIndex = null);
          });
        },
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

    final double arabicFontSize = widget.themeService.getScaledSize(26);
    final double verseNumberFontSize = widget.themeService.getScaledSize(20);

    for (int i = 0; i < widget.surahChunk.versesAr.length; i++) {
      final verseNum = i + widget.surahChunk.startingVerseNumber;
      final isTappedHighlight = _tappedVerseIndex == i;

      spans.add(
        TextSpan(
          text: '${widget.surahChunk.versesAr[i]} ',
          style: GoogleFonts.amiri(
            fontSize: arabicFontSize,
            color: widget.isDarkMode ? Colors.white : Colors.black87,
            backgroundColor: isTappedHighlight
                ? const Color(0xFFD4AF37).withValues(alpha: 0.3)
                : Colors.transparent,
            height: 2.2,
          ),
          recognizer: _tapRecognizers[i],
        ),
      );

      spans.add(
        TextSpan(
          text: ' ﴿$verseNum﴾ ',
          style: TextStyle(
            fontSize: verseNumberFontSize,
            color: isTappedHighlight
                ? const Color(0xFFD4AF37)
                : const Color(0xFFD4AF37).withValues(alpha: 0.7),
            backgroundColor: isTappedHighlight
                ? const Color(0xFFD4AF37).withValues(alpha: 0.3)
                : Colors.transparent,
            fontFamily: 'Amiri',
          ),
        ),
      );
    }

    final isArabic = widget.lang == 'ar';

    return Column(
      children: [
        if (widget.surahChunk.startingVerseNumber == 1) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4AF37).withValues(alpha: 0.18),
                  const Color(0xFFD4AF37).withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                  width: 2),
            ),
            child: Column(
              children: [
                Text(
                  isArabic
                      ? 'سورة ${widget.surahChunk.nameAr}'
                      : widget.surahChunk.nameEn,
                  style: GoogleFonts.amiri(
                    color: const Color(0xFFD4AF37),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? '${widget.surahChunk.versesAr.length} آية'
                      : '${widget.surahChunk.versesAr.length} verses',
                  style: widget.themeService.getTextStyle(
                    fontSize: 11,
                    color: widget.isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (widget.surahChunk.id != 1 && widget.surahChunk.id != 9)
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: GoogleFonts.amiri(
                  fontSize: widget.themeService.getScaledSize(30),
                  color: const Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? const Color(0xFF0B3D2E).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
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
    final isArabic = widget.lang == 'ar';

    String combinedAr = '';
    String combinedTrans = '';

    for (int i = startIdx;
        i <= endIdx && i < widget.surah.versesAr.length;
        i++) {
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
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.5), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isArabic ? 'مشاركة الآيات' : 'Share Verses',
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 22,
                color: const Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isArabic
                  ? 'اختر نطاق الآيات لتصديرها كصورة أنيقة'
                  : 'Choose the verse range to export as an elegant image',
              textAlign: TextAlign.center,
              style: widget.themeService.getTextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFFD4AF37)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      isArabic ? 'من آية' : 'From verse',
                      style: widget.themeService.getTextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButton<int>(
                      dropdownColor:
                          isDarkMode ? const Color(0xFF144D32) : Colors.white,
                      value: startIdx,
                      items: List.generate(widget.surah.versesAr.length, (i) {
                        return DropdownMenuItem(
                          value: i,
                          child: Text(
                            '${i + widget.surah.startingVerseNumber}',
                            style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
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
                Icon(Icons.arrow_forward_rounded,
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                Column(
                  children: [
                    Text(
                      isArabic ? 'إلى آية' : 'To verse',
                      style: widget.themeService.getTextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButton<int>(
                      dropdownColor:
                          isDarkMode ? const Color(0xFF144D32) : Colors.white,
                      value: endIdx,
                      items: List.generate(widget.surah.versesAr.length, (i) {
                        return DropdownMenuItem(
                          value: i,
                          child: Text(
                            '${i + widget.surah.startingVerseNumber}',
                            style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                          ),
                        );
                      })
                          .where((item) => item.value! >= startIdx)
                          .toList(),
                      onChanged: (val) => setState(() => endIdx = val!),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (endIdx - startIdx > 5)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: Colors.orange.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isArabic
                            ? 'تحديد آيات كثيرة قد يؤدي إلى تصغير النص في الصورة.'
                            : 'Selecting many verses may make the text very small in the image.',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor:
                    isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.share_rounded, size: 20),
              label: Text(
                isArabic ? 'مشاركة كصورة' : 'Share as Image',
                style: widget.themeService.getTextStyle(
                  fontSize: 15,
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