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

  // ==========================================
  // 🔥 FIX: Added success and error print statements
  // ==========================================
  Future<void> _loadPageCoordinates(int pageNumber) async {
    try {
      final String path = 'assets/json/${pageNumber.toString().padLeft(3, '0')}.json'; 
      final String jsonString = await rootBundle.loadString(path);
      final List<dynamic> coords = jsonDecode(jsonString);
      debugPrint("✅ Loaded coordinates for page $pageNumber (${coords.length} verses)");
      if (mounted) {
        setState(() {
          _pageCoordinates = coords;
        });
      }
    } catch (e) {
      // 🔥 This will print a RED error in Chrome console if the file is missing!
      debugPrint("❌ ERROR: Could not load coordinates for page $pageNumber. Missing 003.json?");
      debugPrint("❌ $e");
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
  // 🎯 FIXED TAP LOGIC: Widened tap detection with 5% upward margin
  // ==========================================================
    // ==========================================================
  // 🎯 FINAL FIX: 5% X/Y Margin & Page 3 Debugging
  // ==========================================================
  void _handleTap(TapUpDetails details) {
    if (_pageCoordinates.isEmpty) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    final double cw = box.size.width;
    final double ch = box.size.height;
    const double imW = 1000.0;
    const double imH = 1500.0;

    double actualW, actualH, offsetX, offsetY;
    if (cw / ch > imW / imH) {
      actualH = ch;
      actualW = ch * (imW / imH);
      offsetX = (cw - actualW) / 2;
      offsetY = 0.0;
    } else {
      actualW = cw;
      actualH = cw * (imH / imW);
      offsetX = 0.0;
      offsetY = (ch - actualH) / 2;
    }

    final double tapX = ((localPosition.dx - offsetX) / actualW) * 100;
    final double tapY = ((localPosition.dy - offsetY) / actualH) * 100;

    for (int i = 0; i < _pageCoordinates.length; i++) {
      var coord = _pageCoordinates[i];
      final polygon = coord["polygon"];
      if (polygon == null) continue;

      final pts = polygon
          .toString()
          .trim()
          .split(" ")
          .map((e) => e.split(","))
          .where((e) => e.length == 2)
          .map((e) => Offset(
                double.parse(e[0]) / 2.30,
                double.parse(e[1]) / 3.30,
              ))
          .toList();

      if (pts.isEmpty) continue;

      // Calculate bounding box
      double xMin = 100, xMax = 0, yMin = 100, yMax = 0;
      for (var p in pts) {
        if (p.dx < xMin) xMin = p.dx;
        if (p.dx > xMax) xMax = p.dx;
        if (p.dy < yMin) yMin = p.dy;
        if (p.dy > yMax) yMax = p.dy;
      }

      // 🟢 GRACE MARGIN: Add 5% to both X and Y so misaligned scans don't break it!
      if (tapX >= (xMin - 5) && tapX <= (xMax + 5) && tapY >= (yMin - 5) && tapY <= (yMax + 5)) {
        debugPrint("✅ MATCH FOUND at verse index $i!");
        
        setState(() {
          _highlightedVerse = {
            ...coord,
            "page": _currentPage,
          };
        });

        // 🔥 AUTO-DETECT SURAH/AYAH if JSON has 0 values (incomplete data)
        int surahId = coord['surahNumber'] ?? 0;
        int ayahNumber = coord['ayahNumber'] ?? 0;

        if (surahId == 0 || ayahNumber == 0) {
          debugPrint("⚠️  Found invalid surah/ayah (0,0), auto-detecting from page...");
          final auto = _autoDetectVerseFromPage(_currentPage, i);
          surahId = auto['surah'] ?? surahId;
          ayahNumber = auto['ayah'] ?? ayahNumber;
          debugPrint("✅ Auto-detected: Surah $surahId, Ayah $ayahNumber");
        }

        final Map<String, dynamic> verseData = {
          'verseNumber': ayahNumber,
          'surahId': surahId,
          'verseAr': _getVerseText(surahId, ayahNumber),
          'surahNameAr': _getSurahName(surahId),
        };
        
        _showActionMenu(context, verseData);
        return;
      }
    }
  }

  String _getVerseText(int surahId, int verseNumber) {
    if (surahId <= 0 || verseNumber <= 0) {
      debugPrint("⚠️  Invalid verse lookup: Surah=$surahId, Verse=$verseNumber");
      return 'عذراً، النص غير متاح حالياً';
    }

    for (var juz in QuranData.parts) {
      for (var surah in juz.surahs) {
        if (surah.id == surahId) {
          int index = verseNumber - surah.startingVerseNumber;
          if (index >= 0 && index < surah.versesAr.length) {
            return surah.versesAr[index];
          }
          // Fallback: return any verse from this Surah if calculation was off
          if (surah.versesAr.isNotEmpty) {
            debugPrint("⚠️  Verse index out of range (calc: $index), returning first verse as fallback");
            return surah.versesAr[0];
          }
        }
      }
    }
    
    debugPrint("❌ Surah $surahId not found in Quran data");
    return 'عذراً، السورة غير متاحة';
  }

  String _getSurahName(int surahId) {
    if (surahId <= 0) {
      // Try to determine Surah from current page
      for (var entry in SURAH_PAGE_MAP.entries) {
        final surahData = entry.value;
        final startPage = surahData['startPage'] as int;
        final endPage = surahData['endPage'] as int;
        if (_currentPage >= startPage && _currentPage <= endPage) {
          return surahData['nameAr'] as String? ?? 'سورة';
        }
      }
      return 'سورة';
    }

    for (var juz in QuranData.parts) {
      for (var surah in juz.surahs) {
        if (surah.id == surahId) return surah.nameAr;
      }
    }
    return 'سورة غير معروفة';
  }

  // 🔥 AUTO-DETECT VERSE when JSON has 0 values
  // Looks up Surah from page, then calculates Ayah from position
  Map<String, int> _autoDetectVerseFromPage(int pageNumber, int verseIndexOnPage) {
    // Find which Surah this page belongs to
    for (var entry in SURAH_PAGE_MAP.entries) {
      final surahId = entry.key;
      final surahData = entry.value;
      final startPage = surahData['startPage'] as int;
      final endPage = surahData['endPage'] as int;

      if (pageNumber >= startPage && pageNumber <= endPage) {
        // Found the Surah! Now calculate which Ayah
        // Get the starting verse of this Surah
        int startingVerseNumber = surahData['startingVerse'] as int? ?? 1;
        
        // Calculate offset from start of Surah
        int versesBeforePage = 0;
        
        // Count verses on all previous pages of this Surah
        for (int p = startPage; p < pageNumber; p++) {
          // Try to load and count verses from that page
          final versesOnPage = _countVersesOnPage(p);
          versesBeforePage += versesOnPage;
        }
        
        // The verse number = starting verse + verses before this page + verse index on page
        int ayahNumber = startingVerseNumber + versesBeforePage + verseIndexOnPage;
        
        debugPrint("📍 Auto-detect: Surah=$surahId, Page=$pageNumber, VerseIndex=$verseIndexOnPage → Ayah=$ayahNumber");
        return {'surah': surahId, 'ayah': ayahNumber};
      }
    }
    
    return {'surah': 0, 'ayah': 0};
  }

  // Helper: Count how many verse regions are on a given page
  int _countVersesOnPage(int pageNumber) {
    // This is a simplified count - in reality you'd load the JSON for that page
    // For now, return a default estimate
    return 5; // Most pages have 5-11 verses, we'll estimate 5
  }

  void _showActionMenu(BuildContext context, Map<String, dynamic> verse) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                verse['verseAr'],
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(fontSize: 18, color: const Color(0xFFD4AF37)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.copy_rounded,
                    label: isArabic ? 'نسخ' : 'Copy',
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: verse['verseAr']));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard!')),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.menu_book_rounded,
                    label: isArabic ? 'تفسير' : 'Tafseer',
                    onTap: () {
                      Navigator.pop(context);
                      _showVerseTafseerSheet(context, verse, isArabic);
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.share_rounded,
                    label: isArabic ? 'مشاركة' : 'Share',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showVerseTafseerSheet(BuildContext context, Map<String, dynamic> verse, bool isArabic) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VerseTafseerSheet(
        verse: verse, 
        isArabic: isArabic
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37)),
            ),
            child: Icon(icon, color: const Color(0xFFD4AF37), size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.elMessiri(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          isArabic ? 'المصحف الشريف' : 'Holy Quran Mushaf',
          style: GoogleFonts.amiri(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _bookmarkedPage == _currentPage ? Icons.bookmark : Icons.bookmark_add_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              showSearch(
                context: context,
                delegate: QuranSearchDelegate(
                  onPageSelected: (pageNumber) {
                    _goToPage(pageNumber);
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.menu_book_rounded, color: Theme.of(context).colorScheme.secondary),
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
            icon: Icon(Icons.format_list_bulleted_rounded, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildPageVersesSheet(isArabic),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPageHeader(context, isArabic),
          Expanded(
            child: GestureDetector(
              onTapUp: _handleTap, 
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
          ),
          _buildNavigationControls(context, isArabic),
        ],
      ),
    );
  }

  // ==========================================================
  // 🔥 DARK THEME LOCATION & SHRUNKEN HIGHLIGHT BOX
  // ==========================================================
  Widget _buildQuranPage(BuildContext context, int pageNumber, bool isArabic) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 3.0,
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
                    // 1. The Image
                    Builder(
                      builder: (context) {
                        Widget quranImage = Image.asset(
                          'assets/quran_pages/$pageNumber.png',
                          width: actualW,
                          height: actualH,
                          fit: BoxFit.fill, // Perfectly calculated
                        );
                        // 👇 HERE IS THE DARK THEME TOGGLE. Change values to customize!
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

                    // 2. The Highlight Box (with shrink applied)
                    if (_highlightedVerse != null && _highlightedVerse!['page'] == pageNumber)
                      Container(
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
                  ],
                );
              },
            ),
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
                  isArabic 
                    ? 'سورة ${surahData['nameAr']}' 
                    : 'Surah ${surahData['nameEn']}',
                  style: GoogleFonts.amiri(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getOnBackgroundColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                    ? surahData['type'] == 'Meccan' ? 'مكية' : 'مدنية'
                    : surahData['type'],
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

  Widget _buildPageVersesSheet(bool isArabic) {
    final verses = QuranPageMetadata.getVersesForPage(_currentPage);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white38 : Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              isArabic ? 'آيات هذه الصفحة' : 'Verses on this page',
              style: GoogleFonts.amiri(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: verses.isEmpty
                ? Center(
                    child: Text(
                      isArabic ? 'تعذر تحميل آيات هذه الصفحة' : 'Could not load verses for this page',
                      style: GoogleFonts.elMessiri(color: isDarkMode ? Colors.white54 : Colors.black54),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: verses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final verse = verses[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: ListTile(
                          tileColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.04),
                          onTap: () {
                            Navigator.pop(context);
                            _showActionMenu(context, verse);
                          },
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                            child: Text(
                              '${verse['verseNumber']}',
                              style: GoogleFonts.amiri(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            verse['verseAr'],
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.amiri(
                              fontSize: 17,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              isArabic ? 'سورة ${verse['surahNameAr']}' : 'Surah ${verse['surahNameEn']}',
                              style: GoogleFonts.elMessiri(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.copy_rounded, size: 20, color: Theme.of(context).colorScheme.secondary),
                            tooltip: isArabic ? 'نسخ الآية' : 'Copy verse',
                            onPressed: () {
                              Navigator.pop(context);
                              _copyVerseText(context, verse, isArabic);
                            },
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

  Widget _buildNavigationControls(BuildContext context, bool isArabic) {
    final lang = Localizations.localeOf(context).languageCode;
    String previousText = 'Previous';
    String nextText = 'Next';
    String goMarkText = 'Go to Mark';
    
    if (lang == 'ar') {
      previousText = 'السابق';
      nextText = 'التالي';
      goMarkText = 'الانتقال للعلامة';
    } else if (lang == 'fr') {
      previousText = 'Précédent';
      nextText = 'Suivant';
      goMarkText = 'Aller à la marque';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _previousPage,
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(previousText),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
              foregroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),

          if (_bookmarkedPage != null)
            ElevatedButton.icon(
              onPressed: () => _goToPage(_bookmarkedPage!),
              icon: const Icon(Icons.bookmark, size: 18),
              label: Text(goMarkText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),

          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
              foregroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(nextText),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
        ],
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
      decoration: BoxDecoration(color: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
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
// 🔥 SHRUNKEN HIGHLIGHT PAINTER (Fixes the border problem)
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
              double.parse(e[0]) / 2.30 * imageWidth / 100.0,
              double.parse(e[1]) / 3.30 * imageHeight / 100.0,
            ))
        .toList();

    if (points.isEmpty) return;
    
    // 🔥 SHRINK THE POLYGON BY 5% SO IT DOESN'T TOUCH THE DECORATIVE BORDERS
    final double scaleFactor = 0.95;
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