import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamy_app/data/quran_data.dart';
import 'package:islamy_app/data/quran_page_mapping.dart';
import '../data/tafseer_data.dart';
import '../app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/quran_page_model.dart';
import 'dart:convert';

class MushafViewerScreen extends StatefulWidget {
  final int initialPage;

  const MushafViewerScreen({
    super.key,
    this.initialPage = 1,
  });

  @override
  State<MushafViewerScreen> createState() => _MushafViewerScreenState();
}

class _MushafViewerScreenState extends State<MushafViewerScreen> {
  Map<String, dynamic>? _highlightedVerse;

  late int _currentPage;
  late PageController _pageController;
  int? _bookmarkedPage;

  List<dynamic> _pageCoordinates = [];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: _currentPage - 1);
    _loadBookmark();
    _loadPageCoordinates(_currentPage);
  }

  Future<void> _loadPageCoordinates(int pageNumber) async {
    try {
      final String paddedPage = pageNumber.toString().padLeft(3, '0');
      final String path = 'assets/json/$paddedPage.json';

      final String jsonString = await rootBundle.loadString(path);
      final dynamic decodedData = jsonDecode(jsonString);

      List<dynamic> ayahs = [];
      if (decodedData is List) {
        ayahs = decodedData;
      } else if (decodedData is Map && decodedData.containsKey('ayahs')) {
        ayahs = decodedData['ayahs'];
      }

      if (mounted) {
        setState(() {
          _pageCoordinates = ayahs;
        });
      }
    } catch (e) {
      debugPrint("ERROR loading page $pageNumber: $e");
      if (mounted) {
        setState(() {
          _pageCoordinates = [];
        });
      }
    }
  }

  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarkedPage = prefs.getInt('saved_quran_page');
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    if (_bookmarkedPage == _currentPage) {
      await prefs.remove('saved_quran_page');
      setState(() => _bookmarkedPage = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark removed')),
        );
      }
    } else {
      await prefs.setInt('saved_quran_page', _currentPage);
      setState(() => _bookmarkedPage = _currentPage);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark saved')),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page < 1 || page > QuranPageMetadata.totalPages) return;
    setState(() {
      _currentPage = page;
      _pageCoordinates = [];
      _highlightedVerse = null;
    });
    _loadPageCoordinates(page);
    _pageController.animateToPage(
      page - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() => _goToPage(QuranPageMetadata.getNextPage(_currentPage));
  void _previousPage() => _goToPage(QuranPageMetadata.getPreviousPage(_currentPage));

  // ==========================================================
  // TAP TO SELECT VERSE
  // ==========================================================
  void _handleTap(TapUpDetails details, BoxConstraints constraints) {
    if (_pageCoordinates.isEmpty) return;

    // Check if polygon data even exists
    if (_pageCoordinates.isNotEmpty && _pageCoordinates[0]['polygon'] == null) {
      debugPrint("❌ JSON file lacks 'polygon' coordinate data.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tap-to-select requires polygon coordinates in JSON files.'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Prevent false selections
    }

    final double cw = constraints.maxWidth;
    final double ch = constraints.maxHeight;
    const double imW = 1000.0;
    const double imH = 1500.0;

    double actualW, actualH;
    if (cw / ch > imW / imH) {
      actualH = ch;
      actualW = ch * (imW / imH);
    } else {
      actualW = cw;
      actualH = cw * (imH / imW);
    }

    final double imgX = (details.localPosition.dx - (cw - actualW) / 2) / actualW * 100.0;
    final double imgY = (details.localPosition.dy - (ch - actualH) / 2) / actualH * 100.0;

    // Ignore taps outside the image
    if (imgX < 0 || imgX > 100 || imgY < 0 || imgY > 100) return;

    Map<String, dynamic>? selectedVerse = _getVerseFromCoordinates(imgX, imgY);

    if (selectedVerse != null) {
      setState(() {
        _highlightedVerse = selectedVerse;
      });

      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _VerseTafseerSheet(
          verse: selectedVerse,
          isArabic: isArabic,
        ),
      );
    }
  }

  Map<String, dynamic>? _getVerseFromCoordinates(double x, double y) {
    for (var ayah in _pageCoordinates) {
      final String? polyStr = ayah['polygon'];
      if (polyStr == null) continue;

      final List<Offset> points = polyStr
          .toString()
          .trim()
          .split(" ")
          .map((e) => e.split(","))
          .where((e) => e.length == 2)
          .map((e) => Offset(
                double.parse(e[0]),
                double.parse(e[1]),
              ))
          .toList();

      if (points.isEmpty) continue;

      // Point-in-polygon check (Ray Casting Algorithm)
      bool inside = false;
      int j = points.length - 1;
      for (int i = 0; i < points.length; i++) {
        final xi = points[i].dx, yi = points[i].dy;
        final xj = points[j].dx, yj = points[j].dy;

        final bool intersect = ((yi > y) != (yj > y)) &&
            (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
        j = i;
      }

      if (inside) {
        final surahId = ayah['sura'] ?? 0;
        final ayahNum = ayah['ayah'] ?? 0;

        final verseObject = _buildVerseObject(surahId, ayahNum, _currentPage);
        if (verseObject != null) {
          verseObject['polygon'] = polyStr; // Add back for painter
        }
        return verseObject;
      }
    }
    return null;
  }

  Map<String, dynamic>? _buildVerseObject(int surahId, int ayahNumber, int pageNum) {
    if (surahId < 1 || surahId > 114) return null;

    for (var juz in QuranData.parts) {
      for (var surah in juz.surahs) {
        if (surah.id == surahId) {
          if (ayahNumber >= 1 && ayahNumber <= surah.versesAr.length) {
            return {
              'surahId': surahId,
              'verseNumber': ayahNumber,
              'verseAr': surah.versesAr[ayahNumber - 1],
              'verseEn': surah.versesEn[ayahNumber - 1],
              'surahNameAr': surah.nameAr,
              'surahNameEn': surah.nameEn,
              'page': pageNum,
            };
          }
          return null;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'المصحف الشريف' : 'The Holy Quran',
          style: GoogleFonts.amiri(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            color: _bookmarkedPage == _currentPage
                ? Theme.of(context).colorScheme.secondary
                : null,
            onPressed: _toggleBookmark,
            tooltip: isArabic ? 'حفظ الصفحة' : 'Bookmark page',
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: isArabic ? 'فهرس السور' : 'Surah index',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildSurahIndexSheet(isArabic),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: isArabic ? 'البحث' : 'Search',
            onPressed: () {
              showSearch(
                context: context,
                delegate: QuranSearchDelegate(
                  onPageSelected: (page) => _goToPage(page),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPageHeader(context, isArabic),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index + 1;
                  _pageCoordinates = [];
                  _highlightedVerse = null;
                });
                _loadPageCoordinates(index + 1);
              },
              itemCount: QuranPageMetadata.totalPages,
              itemBuilder: (context, index) {
                return Center(
                  child: _buildQuranPage(context, index + 1, isArabic),
                );
              },
            ),
          ),
          _buildNavigationControls(context, isArabic),
        ],
      ),
    );
  }

      Widget _buildQuranPage(BuildContext context, int pageNumber, bool isArabic) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double cw = constraints.maxWidth;
              final double ch = constraints.maxHeight;
              const double imW = 1000.0;
              const double imH = 1500.0;

              double actualW, actualH;
              if (cw / ch > imW / imH) {
                actualH = ch;
                actualW = ch * (imW / imH);
              } else {
                actualW = cw;
                actualH = cw * (imH / imW);
              }

              return Stack(
                alignment: Alignment.center,
                children: [
                  // ✅ 1. The container that holds the tap and zoom
                  Center(
                    child: SizedBox(
                      width: actualW,
                      height: actualH,
                      child: GestureDetector(
                        onTapUp: (details) {
                          _handleTap(details, constraints);
                        },
                        child: InteractiveViewer(
                          minScale: 0.8,
                          maxScale: 3.0,
                          constrained: false,
                          child: Builder(
                            builder: (context) {
                              final String paddedPage = pageNumber.toString().padLeft(3, '0');
                              Widget quranImage = Image.asset(
                                'assets/quran_pages/$paddedPage.png',
                                width: actualW,
                                height: actualH,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: actualW,
                                    height: actualH,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 64,
                                          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Page $pageNumber not found',
                                          style: GoogleFonts.elMessiri(
                                            fontSize: 16,
                                            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              if (isDarkMode) {
                                return ColorFiltered(
                                  colorFilter: const ColorFilter.matrix([
                                    -1, 0, 0, 0, 255,
                                    0, -1, 0, 0, 255,
                                    0, 0, -1, 0, 255,
                                    0, 0, 0, 1, 0,
                                  ]),
                                  child: quranImage,
                                );
                              }
                              return quranImage;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ✅ 2. Highlight Box (Now matches the exact sized image)
                  if (_highlightedVerse != null && 
                      _highlightedVerse!['page'] == pageNumber &&
                      _highlightedVerse!.containsKey('polygon'))
                    Center(
                      child: SizedBox(
                        width: actualW,
                        height: actualH,
                        child: CustomPaint(
                          painter: VerseHighlightPainter(
                            selectedVerse: _highlightedVerse,
                            imageWidth: actualW,
                            imageHeight: actualH,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSurahIndexSheet(bool isArabic) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              isArabic ? 'فهرس السور' : 'Surah Index',
              style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: SURAH_PAGE_MAP.length,
              itemBuilder: (context, index) {
                final surahNumber = index + 1;
                final surah = SURAH_PAGE_MAP[surahNumber]!;
                return ListTile(
                  title: Text(isArabic ? surah['nameAr'] : surah['nameEn']),
                  trailing: Text('${isArabic ? 'ص' : 'Page'} ${surah['startPage']}'),
                  onTap: () {
                    _goToPage(surah['startPage']);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _copyVerseText(BuildContext context, Map<String, dynamic> verse, bool isArabic) {
    final label = isArabic
        ? 'سورة ${verse['surahNameAr']} - آية ${verse['verseNumber']}'
        : 'Surah ${verse['surahNameEn']} - Verse ${verse['verseNumber']}';
    Clipboard.setData(ClipboardData(text: '${verse['verseAr']}\n\n$label'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isArabic ? 'تم نسخ الآية' : 'Verse copied')),
    );
  }

  Widget _buildPageHeader(BuildContext context, bool isArabic) {
    final surahData = getSurahInfoFromPage(_currentPage);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3)),
            ),
            child: Text(
              isArabic ? 'ص $_currentPage' : 'Page $_currentPage',
              style: GoogleFonts.amiri(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          if (surahData != null)
            Column(
              children: [
                Text(
                  isArabic ? 'سورة ${surahData['nameAr']}' : 'Surah ${surahData['nameEn']}',
                  style: GoogleFonts.amiri(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getOnBackgroundColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic ? (surahData['type'] == 'Meccan' ? 'مكية' : 'مدنية') : surahData['type'],
                  style: GoogleFonts.elMessiri(
                    fontSize: 12,
                    color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3)),
            ),
            child: Text(
              isArabic ? '٦٠٤' : 'of 604',
              style: GoogleFonts.amiri(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(BuildContext context, bool isArabic) {
    final lang = Localizations.localeOf(context).languageCode;
    String goMarkText = 'Go to Mark';
    String prevText = 'Previous';
    String nextText = 'Next';

    if (lang == 'ar') {
      goMarkText = 'الانتقال للعلامة';
      prevText = 'السابقة';
      nextText = 'التالية';
    } else if (lang == 'fr') {
      goMarkText = 'Aller à la marque';
      prevText = 'Précédent';
      nextText = 'Suivant';
    }

    final canPrevious = _currentPage > 1;
    final canNext = _currentPage < QuranPageMetadata.totalPages;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Previous Button
            ElevatedButton.icon(
              onPressed: canPrevious ? _previousPage : null,
              icon: const Icon(Icons.arrow_back, size: 16),
              label: Text(prevText, style: const TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: canPrevious
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                disabledBackgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                disabledForegroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),

            // Bookmark Button (if exists)
            if (_bookmarkedPage != null)
              ElevatedButton.icon(
                onPressed: () => _goToPage(_bookmarkedPage!),
                icon: const Icon(Icons.bookmark, size: 16),
                label: Text(goMarkText, style: const TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),

            // Next Button
            ElevatedButton.icon(
              onPressed: canNext ? _nextPage : null,
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: Text(nextText, style: const TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: canNext
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                disabledBackgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                disabledForegroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerseTafseerSheet extends StatelessWidget {
  final Map<String, dynamic> verse;
  final bool isArabic;
  const _VerseTafseerSheet({required this.verse, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final verseNumber = verse['verseNumber'] as int;
    final tafseerVerse = TafseerData.getTafseerForVerse(verse['surahId'] as int, verseNumber);
    final tafseerAr = tafseerVerse?.tafseerAr ?? '', tafseerEn = tafseerVerse?.tafseerEn ?? '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      child: Column(children: [
        Center(child: Container(width: 50, height: 5, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: isDarkMode ? Colors.white38 : Colors.black26, borderRadius: BorderRadius.circular(10)))),
        Text(verse['verseAr'], textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: GoogleFonts.amiri(fontSize: 22, color: const Color(0xFFD4AF37), height: 1.6)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(isArabic ? 'تفسير الآية $verseNumber - سورة ${verse['surahNameAr']}' : 'Tafseer of Verse $verseNumber - Surah ${verse['surahNameEn']}', textAlign: TextAlign.center, style: GoogleFonts.elMessiri(fontSize: 14, color: isDarkMode ? Colors.white60 : Colors.black54)),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.copy_rounded, size: 18, color: Color(0xFFD4AF37)), onPressed: () {
            final label = isArabic ? 'سورة ${verse['surahNameAr']} - آية $verseNumber' : 'Surah ${verse['surahNameEn']} - Verse $verseNumber';
            Clipboard.setData(ClipboardData(text: '${verse['verseAr']}\n\n$label'));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isArabic ? 'تم نسخ الآية' : 'Verse copied')));
          }),
        ]),
        const Divider(color: Color(0xFFD4AF37)),
        const SizedBox(height: 8),
        Expanded(child: SingleChildScrollView(child: Column(children: [
          if (tafseerAr.isNotEmpty) ...[Text('التفسير الميسر:', textDirection: TextDirection.rtl, style: GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(tafseerAr, textDirection: TextDirection.rtl, style: GoogleFonts.amiri(fontSize: 18, color: isDarkMode ? Colors.white : Colors.black87, height: 1.8)), const SizedBox(height: 24)],
          if (tafseerEn.isNotEmpty) ...[Text('English Translation:', style: GoogleFonts.elMessiri(color: const Color(0xFFD4AF37), fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(tafseerEn, textDirection: TextDirection.ltr, style: GoogleFonts.elMessiri(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87, height: 1.6))],
          if (tafseerAr.isEmpty && tafseerEn.isEmpty) Center(child: Padding(padding: const EdgeInsets.only(top: 40.0), child: Text(isArabic ? 'التفسير غير متوفر حالياً' : 'Tafseer is currently unavailable', style: GoogleFonts.elMessiri(color: isDarkMode ? Colors.white54 : Colors.black54, fontSize: 18)))),
        ]))),
      ]),
    );
  }
}

class QuranSearchDelegate extends SearchDelegate {
  final Function(int) onPageSelected;
  QuranSearchDelegate({required this.onPageSelected});

  String _removeDiacritics(String text) {
    String cleaned = text.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    cleaned = cleaned.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    cleaned = cleaned.replaceAll('ة', 'ه');
    return cleaned;
  }
  @override List<Widget> buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  @override Widget buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  @override Widget buildSuggestions(BuildContext context) => _buildResultsView();
  @override Widget buildResults(BuildContext context) => _buildResultsView();

  Widget _buildResultsView() {
    final results = [];
    final cleanQuery = _removeDiacritics(query.toLowerCase().trim());
    if (query.isEmpty) return Container();

    for (var juz in QuranData.parts) {
      for (var surah in juz.surahs) {
        for (int i = 0; i < surah.versesAr.length; i++) {
          if (_removeDiacritics(surah.versesAr[i]).contains(cleanQuery) || surah.versesEn[i].toLowerCase().contains(cleanQuery)) {
            final page = QuranPageMetadata.getPageForVerse(surah.id, i + 1);
            results.add({'surahName': surah.nameAr, 'verseText': surah.versesAr[i], 'page': page});
          }
        }
      }
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]['surahName']),
          subtitle: Text(results[index]['verseText'], maxLines: 1),
          onTap: () { onPageSelected(results[index]['page']); close(context, null); },
        );
      },
    );
  }
}

Map<String, dynamic>? getSurahInfoFromPage(int pageNumber) {
  for (var entry in SURAH_PAGE_MAP.entries) {
    final surahId = entry.key, surahData = entry.value;
    final startPage = surahData['startPage'] as int, endPage = surahData['endPage'] as int;
    if (pageNumber >= startPage && pageNumber <= endPage) {
      return {'nameAr': surahData['nameAr'] as String, 'nameEn': surahData['nameEn'] as String, 'type': surahData['type'] as String};
    }
  }
  return null;
}

Widget buildWholeBookSection(BuildContext context, AppLocalizations l10n) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3))),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.auto_stories_rounded, size: 48, color: Theme.of(context).colorScheme.secondary),
      const SizedBox(height: 16),
      Text('Read the Entire Quran', style: GoogleFonts.elMessiri(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.getOnBackgroundColor(context))),
      const SizedBox(height: 8),
      Text('Browse all 604 pages in Mushaf format', style: GoogleFonts.elMessiri(fontSize: 14, color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6))),
    ]),
  );
}

// ==========================================================
// HIGHLIGHT PAINTER (Ready for when you get coordinate data)
// ==========================================================
class VerseHighlightPainter extends CustomPainter {
  final Map<String, dynamic>? selectedVerse;
  final double imageWidth;
  final double imageHeight;

  const VerseHighlightPainter({
    required this.selectedVerse,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedVerse == null) return;

    final polygon = selectedVerse!["polygon"];

    if (polygon == null) return;

    final Path path = Path();

    final points = polygon
        .toString()
        .trim()
        .split(" ")
        .map((e) => e.split(","))
        .where((e) => e.length == 2)
        .map((e) => Offset(
              double.parse(e[0]) * imageWidth / 100.0,
              double.parse(e[1]) * imageHeight / 100.0,
            ))
        .toList();

    if (points.isEmpty) return;

    // SHRINK BY 5% so it's inside the box
    const double scaleFactor = 0.95;
    final Offset center = Offset(imageWidth / 2, imageHeight / 2);
    final List<Offset> scaledPoints = points.map((p) {
      final double dx = (p.dx - center.dx) * scaleFactor + center.dx;
      final double dy = (p.dy - center.dy) * scaleFactor + center.dy;
      return Offset(dx, dy);
    }).toList();

    path.moveTo(scaledPoints.first.dx, scaledPoints.first.dy);

    for (int i = 1; i < scaledPoints.length; i++) {
      path.lineTo(scaledPoints[i].dx, scaledPoints[i].dy);
    }

    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0x66FFD54F)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant VerseHighlightPainter oldDelegate) => true;
}