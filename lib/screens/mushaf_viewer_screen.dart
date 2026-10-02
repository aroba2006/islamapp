import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:islamy_app/data/quran_data.dart';
import 'package:islamy_app/data/quran_page_mapping.dart';
import '../data/tafseer_data.dart';
import '../app_theme.dart';
import '../models/quran_page_model.dart';
import 'dart:convert';
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

class MushafViewerScreen extends StatefulWidget {
  final int initialPage;
  final int? highlightSurahId;
  final int? highlightVerseNum;

  const MushafViewerScreen({
    super.key,
    this.initialPage = 1,
    this.highlightSurahId,
    this.highlightVerseNum,
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

  bool _isLoadingPage = false;
  bool _showFirstTip = false;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: _currentPage - 1);
    _loadBookmark();
    _loadTipPreference();
    _loadPageCoordinates(
      _currentPage,
      highlightSurahId: widget.highlightSurahId,
      highlightVerseNum: widget.highlightVerseNum,
    );
  }

  Future<void> _loadTipPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dismissed = prefs.getBool('mushaf_tip_dismissed') ?? false;
      if (!dismissed && mounted) {
        setState(() => _showFirstTip = true);
      }
    } catch (_) {}
  }

  Future<void> _dismissTip() async {
    if (mounted) setState(() => _showFirstTip = false);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('mushaf_tip_dismissed', true);
    } catch (_) {}
  }

  Future<void> _loadPageCoordinates(
    int pageNumber, {
    int? highlightSurahId,
    int? highlightVerseNum,
  }) async {
    if (mounted) setState(() => _isLoadingPage = true);

    List<dynamic> ayahs = [];
    final String paddedPage = pageNumber.toString().padLeft(3, '0');

    final List<String> possiblePaths = [
      'assets/json/$paddedPage.json',
      'assets/json/page_$pageNumber.json',
      'assets/json/$pageNumber.json',
      'assets/quran_pages_data_json/page_$pageNumber.json',
    ];

    for (final path in possiblePaths) {
      try {
        final String jsonString = await rootBundle.loadString(path);
        final dynamic decodedData = jsonDecode(jsonString);

        if (decodedData is List) {
          ayahs = decodedData;
          break;
        } else if (decodedData is Map) {
          if (decodedData.containsKey('ayahs')) {
            ayahs = decodedData['ayahs'];
          } else if (decodedData.containsKey('verses')) {
            ayahs = decodedData['verses'];
          }
          break;
        }
      } catch (_) {}
    }

    if (ayahs.isEmpty) {
      for (var juz in QuranData.parts) {
        for (var surah in juz.surahs) {
          for (int i = 0; i < surah.versesAr.length; i++) {
            final int trueAyahNum = i + surah.startingVerseNumber;
            if (QuranPageMetadata.getPageForVerse(surah.id, trueAyahNum) == pageNumber) {
              ayahs.add({
                'sura': surah.id,
                'ayah': trueAyahNum,
              });
            }
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _pageCoordinates = ayahs;
        _isLoadingPage = false;
        _isBookmarked = _bookmarkedPage == pageNumber;

        if (highlightSurahId != null && highlightVerseNum != null) {
          int indexOnPage = 0;
          bool found = false;

          for (var ayah in ayahs) {
            final sId = _getSafeInt(ayah['sura'] ?? ayah['surah'] ?? ayah['chapter']);
            final aNum = _getSafeInt(ayah['ayah'] ?? ayah['aya'] ?? ayah['verse']);

            if (sId == highlightSurahId && aNum == highlightVerseNum) {
              final verseObj = buildVerseObject(sId, aNum, pageNumber);
              if (verseObj != null) {
                verseObj['polygon'] = ayah['polygon'] ?? ayah['bounds'];
                verseObj['indexOnPage'] = indexOnPage;
                verseObj['totalOnPage'] = ayahs.length;
                _highlightedVerse = verseObj;
                found = true;
              }
              break;
            }
            indexOnPage++;
          }

          if (!found) {
            final verseObj =
                buildVerseObject(highlightSurahId, highlightVerseNum, pageNumber);
            if (verseObj != null) {
              verseObj['indexOnPage'] = 0;
              verseObj['totalOnPage'] = ayahs.isNotEmpty ? ayahs.length : 1;
              _highlightedVerse = verseObj;
            }
          }
        }
      });
    }
  }

  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarkedPage = prefs.getInt('saved_quran_page');
      _isBookmarked = _bookmarkedPage == _currentPage;
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    HapticFeedback.selectionClick();
    if (_bookmarkedPage == _currentPage) {
      await prefs.remove('saved_quran_page');
      setState(() {
        _bookmarkedPage = null;
        _isBookmarked = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark removed')),
        );
      }
    } else {
      await prefs.setInt('saved_quran_page', _currentPage);
      setState(() {
        _bookmarkedPage = _currentPage;
        _isBookmarked = true;
      });
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

  void _goToPage(int page, {int? highlightSurahId, int? highlightVerseNum}) {
    if (page < 1 || page > QuranPageMetadata.totalPages) return;
    setState(() {
      _currentPage = page;
      _pageCoordinates = [];
      _highlightedVerse = null;
      _isBookmarked = _bookmarkedPage == page;
    });
    _loadPageCoordinates(
      page,
      highlightSurahId: highlightSurahId,
      highlightVerseNum: highlightVerseNum,
    );
    _pageController.animateToPage(
      page - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() => _goToPage(QuranPageMetadata.getNextPage(_currentPage));
  void _previousPage() => _goToPage(QuranPageMetadata.getPreviousPage(_currentPage));

  int _getSafeInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val.trim()) ?? 0;
    return 0;
  }

  void _handleTap(TapDownDetails details, double actualW, double actualH) {
    if (_pageCoordinates.isEmpty || actualW <= 0 || actualH <= 0) return;

    final double tapX = details.localPosition.dx;
    final double tapY = details.localPosition.dy;
    if (tapY < 0 || tapY > actualH || tapX < 0 || tapX > actualW) return;

    Map<String, dynamic>? selectedVerse =
        _getVerseFromCoordinates(tapX, tapY, actualW, actualH);

    if (selectedVerse == null) {
      final double topMargin = actualH * 0.09;
      final double bottomMargin = actualH * 0.91;
      final double usableHeight = bottomMargin - topMargin;
      final double clampedY = (tapY - topMargin).clamp(0.0, usableHeight);
      final double percentageY = usableHeight > 0 ? (clampedY / usableHeight) : 0.0;

      final int index = (percentageY * _pageCoordinates.length)
          .floor()
          .clamp(0, _pageCoordinates.length - 1);
      final ayahData = _pageCoordinates[index];
      final surahId =
          _getSafeInt(ayahData['sura'] ?? ayahData['surah'] ?? ayahData['chapter']);
      final ayahNum =
          _getSafeInt(ayahData['ayah'] ?? ayahData['aya'] ?? ayahData['verse']);

      selectedVerse = buildVerseObject(surahId, ayahNum, _currentPage);
      if (selectedVerse != null) {
        selectedVerse['polygon'] = ayahData['polygon'] ?? ayahData['bounds'];
        selectedVerse['indexOnPage'] = index;
        selectedVerse['totalOnPage'] = _pageCoordinates.length;
      }
    }

    if (selectedVerse != null) {
      HapticFeedback.selectionClick();
      setState(() {
        _highlightedVerse = selectedVerse;
      });

      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _VerseTafseerSheet(
          verse: selectedVerse!,
          pageAyahs: _pageCoordinates,
          currentPage: _currentPage,
          isArabic: isArabic,
          onSelectVerse: (newVerse) {
            setState(() {
              _highlightedVerse = newVerse;
            });
          },
        ),
      );
    }
  }

  Map<String, dynamic>? _getVerseFromCoordinates(
      double tapX, double tapY, double actualW, double actualH) {
    if (actualW <= 0 || actualH <= 0) return null;
    final double normX = (tapX / actualW) * 1000.0;
    final double normY = (tapY / actualH) * 1500.0;

    for (int index = 0; index < _pageCoordinates.length; index++) {
      var ayah = _pageCoordinates[index];
      final String? polyStr = ayah['polygon'] ?? ayah['bounds'];
      if (polyStr == null) continue;

      final List<Offset> points = polyStr
          .toString()
          .trim()
          .split(RegExp(r'\s+'))
          .map((e) => e.split(","))
          .where((e) => e.length == 2)
          .map((e) => Offset(
                double.tryParse(e[0]) ?? 0,
                double.tryParse(e[1]) ?? 0,
              ))
          .toList();

      if (points.isEmpty) continue;

      bool inside = false;
      int j = points.length - 1;
      for (int i = 0; i < points.length; i++) {
        final xi = points[i].dx, yi = points[i].dy;
        final xj = points[j].dx, yj = points[j].dy;

        final bool intersect = ((yi > normY) != (yj > normY)) &&
            (normX < (xj - xi) * (normY - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
        j = i;
      }

      if (inside) {
        final surahId = _getSafeInt(ayah['sura'] ?? ayah['surah'] ?? ayah['chapter']);
        final ayahNum = _getSafeInt(ayah['ayah'] ?? ayah['aya'] ?? ayah['verse']);

        final verseObject = buildVerseObject(surahId, ayahNum, _currentPage);
        if (verseObject != null) {
          verseObject['polygon'] = polyStr;
          verseObject['indexOnPage'] = index;
          verseObject['totalOnPage'] = _pageCoordinates.length;
        }
        return verseObject;
      }
    }
    return null;
  }

  double get _readingProgress {
    const total = QuranPageMetadata.totalPages;
    if (total <= 0) return 0;
    return (_currentPage / total).clamp(0.0, 1.0);
  }

  void _openQuickJump(bool isArabic) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _QuickJumpSheet(
          isArabic: isArabic,
          currentPage: _currentPage,
          onJumpToPage: (page) {
            Navigator.pop(context);
            _goToPage(page);
          },
          onJumpToSurah: (surahNumber) {
            final surahData = SURAH_PAGE_MAP[surahNumber];
            if (surahData == null) return;
            final page = surahData['startPage'] as int;
            Navigator.pop(context);
            _goToPage(page);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor.withValues(alpha: 0.85),
        elevation: 0,
        titleSpacing: 0,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'المصحف الشريف' : 'The Holy Quran',
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            Text(
              isArabic
                  ? 'تصفّح 604 صفحة — اضغط على أي آية للتفسير'
                  : 'Browse all 604 pages · tap any verse for tafsir',
              style: GoogleFonts.elMessiri(
                fontSize: 11,
                color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
        actions: [
          // Consolidated Dropdown Menu (Top Left in RTL)
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
            tooltip: isArabic ? 'القائمة' : 'Menu',
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Theme.of(context).cardColor,
            elevation: 4,
            onSelected: (value) {
              if (value == 'search') {
                showSearch(
                  context: context,
                  delegate: QuranSearchDelegate(
                    onVerseSelected: (page, surahId, verseNum) {
                      _goToPage(page, highlightSurahId: surahId, highlightVerseNum: verseNum);
                    },
                  ),
                );
              } else if (value == 'bookmark') {
                _toggleBookmark();
              } else if (value == 'index') {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => _buildSurahIndexSheet(isArabic),
                );
              } else if (value == 'quick_jump') {
                _openQuickJump(isArabic);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'search',
                child: ListTile(
                  leading: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
                  title: Text(isArabic ? 'البحث' : 'Search', style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem<String>(
                value: 'bookmark',
                child: ListTile(
                  leading: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(isArabic ? 'حفظ الصفحة' : 'Bookmark Page', style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem<String>(
                value: 'index',
                child: ListTile(
                  leading: Icon(Icons.menu_book_rounded, color: Theme.of(context).colorScheme.secondary),
                  title: Text(isArabic ? 'فهرس السور' : 'Surah Index', style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem<String>(
                value: 'quick_jump',
                child: ListTile(
                  leading: Icon(Icons.grid_view_rounded, color: Theme.of(context).colorScheme.secondary),
                  title: Text(isArabic ? 'انتقال سريع' : 'Quick Jump', style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: _showFirstTip
                ? _buildFirstTipBanner(isArabic)
                : const SizedBox.shrink(),
          ),
          _buildPageHeader(context, isArabic),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index + 1;
                        _pageCoordinates = [];
                        _highlightedVerse = null;
                        _isBookmarked = _bookmarkedPage == _currentPage;
                      });
                      _loadPageCoordinates(index + 1);
                    },
                    itemCount: QuranPageMetadata.totalPages,
                    itemBuilder: (context, index) {
                      return _buildQuranPage(context, index + 1, isArabic);
                    },
                  ),
                  if (_isLoadingPage)
                    Positioned(
                      top: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isArabic
                                    ? 'جارٍ تحميل الصفحة…'
                                    : 'Loading page…',
                                style: GoogleFonts.elMessiri(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.getOnBackgroundColor(context),
                                ),
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
          _buildNavigationControls(context, isArabic),
        ],
      ),
    );
  }

  Widget _buildFirstTipBanner(bool isArabic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.18),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: Theme.of(context).colorScheme.secondary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'طريقة الاستخدام' : 'How to use',
                  style: GoogleFonts.elMessiri(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getOnBackgroundColor(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isArabic
                      ? 'اضغط على أي آية لقراءة تفسيرها. استخدم قرصة الإصبعين للتكبير. اسحب للأعلى والأسفل للتمرير داخل الصفحة.'
                      : 'Tap any verse to read its tafsir. Pinch to zoom. Swipe up/down to scroll within the page.',
                  style: GoogleFonts.elMessiri(
                    fontSize: 11,
                    height: 1.4,
                    color: AppTheme.getOnBackgroundColor(context)
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              size: 18,
              color: isDark ? Colors.white60 : Colors.black45,
            ),
            onPressed: _dismissTip,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // FIXED QURAN PAGE SIZING & LAYOUT (Fill width, scroll vertically)
  // ─────────────────────────────────────────────────────────────
  Widget _buildQuranPage(BuildContext context, int pageNumber, bool isArabic) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        
        // Enforce the standard 1000x1500 (2:3) aspect ratio of the Mushaf page
        // But scale it to fill the full width of the screen for readability
        final double pageWidth = screenWidth;
        final double pageHeight = screenWidth * 1.5;

        return InteractiveViewer(
          // Allow zooming out to see the whole page, and zooming in up to 5x
          minScale: 0.7,
          maxScale: 5.0,
          // Allows panning smoothly when zoomed in or when the page is taller than the screen
          boundaryMargin: const EdgeInsets.all(40),
          // Crucial: allows the child to be larger than the viewport so it can fill the width
          constrained: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: pageWidth,
              height: pageHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) {
                  _handleTap(details, pageWidth, pageHeight);
                },
                child: Stack(
                  children: [
                    // Quran Page Image
                    Positioned.fill(
                      child: Builder(
                        builder: (context) {
                          final String paddedPage = pageNumber.toString().padLeft(3, '0');
                          Widget quranImage = Image.asset(
                            'assets/quran_pages/$paddedPage.png',
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
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
                              colorFilter: const ColorFilter.matrix(<double>[
                                -244 / 255, 0, 0, 0, 255,
                                -194 / 255, 0, 0, 0, 255,
                                -209 / 255, 0, 0, 0, 255,
                                0, 0, 0, 1, 0,
                              ]),
                              child: quranImage,
                            );
                          }
                          return quranImage;
                        },
                      ),
                    ),
                    // Verse Highlight Overlay
                    if (_highlightedVerse != null &&
                        _highlightedVerse!['page'] == pageNumber)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: VerseHighlightPainter(
                              selectedVerse: _highlightedVerse,
                              imageWidth: pageWidth,
                              imageHeight: pageHeight,
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
      },
    );
  }

  Widget _buildSurahIndexSheet(bool isArabic) {
    return _SurahIndexSheet(
      isArabic: isArabic,
      currentPage: _currentPage,
      onSelectPage: (page) {
        _goToPage(page);
      },
    );
  }

  Widget _buildPageHeader(BuildContext context, bool isArabic) {
    final surahData = getSurahInfoFromPage(_currentPage);
    final secondary = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.55),
        border: Border(
          bottom: BorderSide(
            color: secondary.withValues(alpha: 0.25),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: secondary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.description_outlined, size: 14, color: secondary),
                    const SizedBox(width: 6),
                    Text(
                      isArabic ? 'ص $_currentPage' : 'Page $_currentPage',
                      style: GoogleFonts.amiri(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: surahData != null
                    ? Column(
                        children: [
                          Text(
                            isArabic
                                ? 'سورة ${surahData['nameAr']}'
                                : 'Surah ${surahData['nameEn']}',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.amiri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.getOnBackgroundColor(context),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isArabic
                                ? (surahData['type'] == 'Meccan'
                                    ? 'مكية · مكية النزول'
                                    : 'مدنية · مدنية النزول')
                                : '${surahData['type']} revelation',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.elMessiri(
                              fontSize: 11,
                              color: AppTheme.getOnBackgroundColor(context)
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        isArabic ? 'المصحف الشريف' : 'The Holy Quran',
                        style: GoogleFonts.amiri(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.getOnBackgroundColor(context),
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: secondary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '$_currentPage / ${QuranPageMetadata.totalPages}',
                  style: GoogleFonts.amiri(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.auto_stories_rounded, size: 12, color: secondary),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _readingProgress),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    builder: (context, v, _) {
                      return LinearProgressIndicator(
                        value: v,
                        minHeight: 5,
                        backgroundColor: secondary.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(secondary),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(_readingProgress * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.elMessiri(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: secondary,
                ),
              ),
            ],
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
    String jumpText = 'Jump';

    if (lang == 'ar') {
      goMarkText = 'العلامة';
      prevText = 'السابقة';
      nextText = 'التالية';
      jumpText = 'انتقال';
    } else if (lang == 'fr') {
      goMarkText = 'Marque';
      prevText = 'Précédent';
      nextText = 'Suivant';
      jumpText = 'Aller à';
    }

    final canPrevious = _currentPage > 1;
    final canNext = _currentPage < QuranPageMetadata.totalPages;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.55),
        border: Border(
          top: BorderSide(color: secondary.withValues(alpha: 0.25)),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navButton(
                icon: Icons.arrow_back_ios_new_rounded,
                label: prevText,
                enabled: canPrevious,
                onTap: canPrevious ? _previousPage : null,
                isPrimary: false,
              ),
              const SizedBox(width: 8),
              _navButton(
                icon: Icons.grid_view_rounded,
                label: jumpText,
                enabled: true,
                onTap: () => _openQuickJump(isArabic),
                isPrimary: false,
              ),
              const SizedBox(width: 8),
              if (_bookmarkedPage != null) ...[
                _navButton(
                  icon: Icons.bookmark,
                  label: goMarkText,
                  enabled: true,
                  onTap: () => _goToPage(_bookmarkedPage!),
                  isPrimary: true,
                ),
                const SizedBox(width: 8),
              ],
              _navButton(
                icon: Icons.arrow_forward_ios_rounded,
                label: nextText,
                enabled: canNext,
                onTap: canNext ? _nextPage : null,
                isPrimary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton({
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback? onTap,
    required bool isPrimary,
  }) {
    final secondary = Theme.of(context).colorScheme.secondary;
    final bg = isPrimary
        ? (enabled ? secondary : secondary.withValues(alpha: 0.3))
        : secondary.withValues(alpha: enabled ? 0.15 : 0.08);
    final fg = isPrimary
        ? Theme.of(context).scaffoldBackgroundColor
        : secondary.withValues(alpha: enabled ? 1.0 : 0.4);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isPrimary
                  ? secondary.withValues(alpha: enabled ? 0.9 : 0.3)
                  : secondary.withValues(alpha: enabled ? 0.5 : 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.elMessiri(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// QUICK JUMP BOTTOM SHEET
// ==========================================================
class _QuickJumpSheet extends StatefulWidget {
  final bool isArabic;
  final int currentPage;
  final void Function(int page) onJumpToPage;
  final void Function(int surahNumber) onJumpToSurah;

  const _QuickJumpSheet({
    required this.isArabic,
    required this.currentPage,
    required this.onJumpToPage,
    required this.onJumpToSurah,
  });

  @override
  State<_QuickJumpSheet> createState() => _QuickJumpSheetState();
}

class _QuickJumpSheetState extends State<_QuickJumpSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white38 : Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.grid_view_rounded, color: secondary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.isArabic
                        ? 'انتقال سريع — الجزء، السورة، الصفحة'
                        : 'Quick jump — Juz, Surah, Page',
                    style: GoogleFonts.amiri(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getOnBackgroundColor(context),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: secondary.withValues(alpha: 0.3)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: isDark ? const Color(0xFF0B3D2E) : Colors.white,
              unselectedLabelColor: isDark ? Colors.white70 : Colors.black87,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: widget.isArabic ? 'الأجزاء' : 'Juz'),
                Tab(text: widget.isArabic ? 'السور' : 'Surah'),
                Tab(text: widget.isArabic ? 'الصفحات' : 'Page'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildJuzGrid(context),
                _buildSurahGrid(context),
                _buildPageGrid(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJuzGrid(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 90,
      ),
      itemCount: QuranData.parts.length,
      itemBuilder: (context, index) {
        final part = QuranData.parts[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (part.surahs.isNotEmpty) {
                final firstSurah = part.surahs.first;
                final page = QuranPageMetadata.getPageForVerse(
                    firstSurah.id, firstSurah.startingVerseNumber);
                widget.onJumpToPage(page);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    secondary.withValues(alpha: 0.15),
                    secondary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: secondary.withValues(alpha: 0.35)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isArabic ? 'الجزء' : 'Juz',
                    style: GoogleFonts.amiri(
                      fontSize: 12,
                      color: secondary,
                    ),
                  ),
                  Text(
                    '${part.id}',
                    style: GoogleFonts.amiri(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getOnBackgroundColor(context),
                    ),
                  ),
                  Text(
                    '${part.surahs.length} ${widget.isArabic ? "سور" : "surahs"}',
                    style: GoogleFonts.elMessiri(
                      fontSize: 10,
                      color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
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

  Widget _buildSurahGrid(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    final surahNumbers = SURAH_PAGE_MAP.keys.toList()..sort();
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 76,
      ),
      itemCount: surahNumbers.length,
      itemBuilder: (context, index) {
        final surahNum = surahNumbers[index];
        final surah = SURAH_PAGE_MAP[surahNum]!;
        final startPage = surah['startPage'] as int;
        final isCurrent = widget.currentPage >= startPage &&
            widget.currentPage <= (surah['endPage'] as int);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => widget.onJumpToSurah(surahNum),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCurrent
                    ? secondary.withValues(alpha: 0.2)
                    : secondary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: secondary.withValues(alpha: isCurrent ? 0.9 : 0.25),
                  width: isCurrent ? 1.6 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: secondary.withValues(alpha: 0.15),
                      border: Border.all(color: secondary.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '$surahNum',
                      style: GoogleFonts.amiri(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.isArabic
                              ? (surah['nameAr'] as String)
                              : (surah['nameEn'] as String),
                          style: GoogleFonts.amiri(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getOnBackgroundColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${widget.isArabic ? "ص" : "p"} $startPage',
                          style: GoogleFonts.elMessiri(
                            fontSize: 10,
                            color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.55),
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
      },
    );
  }

  Widget _buildPageGrid(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    const totalPages = QuranPageMetadata.totalPages;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 70,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 60,
      ),
      itemCount: totalPages,
      itemBuilder: (context, index) {
        final pageNum = index + 1;
        final isCurrent = pageNum == widget.currentPage;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => widget.onJumpToPage(pageNum),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCurrent ? secondary : secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: secondary.withValues(alpha: isCurrent ? 1 : 0.3),
                ),
              ),
              child: Text(
                '$pageNum',
                style: GoogleFonts.amiri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isCurrent
                      ? Theme.of(context).scaffoldBackgroundColor
                      : AppTheme.getOnBackgroundColor(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==========================================================
// ENHANCED SURAH INDEX SHEET
// ==========================================================
class _SurahIndexSheet extends StatefulWidget {
  final bool isArabic;
  final int currentPage;
  final void Function(int page) onSelectPage;

  const _SurahIndexSheet({
    required this.isArabic,
    required this.currentPage,
    required this.onSelectPage,
  });

  @override
  State<_SurahIndexSheet> createState() => _SurahIndexSheetState();
}

class _SurahIndexSheetState extends State<_SurahIndexSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = Theme.of(context).colorScheme.secondary;

    final allSurahs = SURAH_PAGE_MAP.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final filtered = _searchQuery.trim().isEmpty
        ? allSurahs
        : allSurahs.where((e) {
            final q = _searchQuery.toLowerCase();
            return (e.value['nameAr'] as String).contains(_searchQuery) ||
                (e.value['nameEn'] as String).toLowerCase().contains(q);
          }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white38 : Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
            child: Row(
              children: [
                Icon(Icons.menu_book_rounded, color: secondary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.isArabic ? 'فهرس السور' : 'Surah Index',
                    style: GoogleFonts.amiri(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getOnBackgroundColor(context),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: secondary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${filtered.length} / 114',
                    style: GoogleFonts.elMessiri(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: secondary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: GoogleFonts.elMessiri(
                fontSize: 14,
                color: AppTheme.getOnBackgroundColor(context),
              ),
              decoration: InputDecoration(
                hintText: widget.isArabic
                    ? 'ابحث عن سورة بالاسم…'
                    : 'Search a surah by name…',
                hintStyle: GoogleFonts.elMessiri(
                  fontSize: 13,
                  color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(Icons.search, color: secondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).cardColor.withValues(alpha: 0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondary.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondary.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondary, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48, color: secondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text(
                          widget.isArabic ? 'لا توجد نتائج' : 'No results found',
                          style: GoogleFonts.elMessiri(
                            fontSize: 16,
                            color: AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
                      final surahNumber = entry.key;
                      final surah = entry.value;
                      final startPage = surah['startPage'] as int;
                      final endPage = surah['endPage'] as int;
                      final isCurrent = widget.currentPage >= startPage &&
                          widget.currentPage <= endPage;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pop(context);
                              widget.onSelectPage(startPage);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? secondary.withValues(alpha: 0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: secondary.withValues(
                                      alpha: isCurrent ? 0.7 : 0.15),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: secondary.withValues(alpha: 0.12),
                                      border: Border.all(
                                          color: secondary.withValues(alpha: 0.5)),
                                    ),
                                    child: Text(
                                      '$surahNumber',
                                      style: GoogleFonts.amiri(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: secondary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.isArabic
                                              ? (surah['nameAr'] as String)
                                              : (surah['nameEn'] as String),
                                          style: GoogleFonts.amiri(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.getOnBackgroundColor(context),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          widget.isArabic
                                              ? 'صفحة $startPage — $endPage'
                                              : 'Pages $startPage — $endPage',
                                          style: GoogleFonts.elMessiri(
                                            fontSize: 11,
                                            color: AppTheme.getOnBackgroundColor(context)
                                                .withValues(alpha: 0.55),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isCurrent)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        widget.isArabic ? 'الحالية' : 'Current',
                                        style: GoogleFonts.elMessiri(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: secondary.withValues(alpha: 0.5),
                                    ),
                                ],
                              ),
                            ),
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

Map<String, dynamic>? buildVerseObject(int surahId, int ayahNumber, int pageNum) {
  if (surahId < 1 || surahId > 114) return null;

  for (var juz in QuranData.parts) {
    for (var surah in juz.surahs) {
      if (surah.id == surahId) {
        final int start = surah.startingVerseNumber;
        final int end = start + surah.versesAr.length - 1;

        if (ayahNumber >= start && ayahNumber <= end) {
          final int localIndex = ayahNumber - start;
          return {
            'surahId': surahId,
            'verseNumber': ayahNumber,
            'verseAr': surah.versesAr[localIndex],
            'verseEn': localIndex < surah.versesEn.length
                ? surah.versesEn[localIndex]
                : '',
            'surahNameAr': surah.nameAr,
            'surahNameEn': surah.nameEn,
            'page': pageNum,
          };
        }
      }
    }
  }
  return null;
}

class _VerseTafseerSheet extends StatefulWidget {
  final Map<String, dynamic> verse;
  final List<dynamic> pageAyahs;
  final int currentPage;
  final bool isArabic;
  final Function(Map<String, dynamic>)? onSelectVerse;

  const _VerseTafseerSheet({
    required this.verse,
    required this.pageAyahs,
    required this.currentPage,
    required this.isArabic,
    this.onSelectVerse,
  });

  @override
  State<_VerseTafseerSheet> createState() => _VerseTafseerSheetState();
}

class _VerseTafseerSheetState extends State<_VerseTafseerSheet> {
  late Map<String, dynamic> _currentVerse;
  int _selectedScholar = 0;

  @override
  void initState() {
    super.initState();
    _currentVerse = widget.verse;
  }

  int _safeInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val.trim()) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final verseNumber = _currentVerse['verseNumber'] as int;
    final surahId = _currentVerse['surahId'] as int;

    final tafseerVerse = TafseerData.getTafseerForVerse(surahId, verseNumber);
    final tafseerAr = tafseerVerse?.tafseerAr ?? '';
    final tafseerEn = tafseerVerse?.tafseerEn ?? '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
        ),
      ),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white38 : Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (widget.pageAyahs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.pageAyahs.map((ayahData) {
                    final aNum = _safeInt(ayahData['ayah'] ??
                        ayahData['aya'] ??
                        ayahData['verse']);
                    final isSelected = aNum == _currentVerse['verseNumber'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(
                          widget.isArabic ? 'آية $aNum' : 'Ayah $aNum',
                          style: GoogleFonts.elMessiri(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.black
                                : (isDarkMode ? Colors.white70 : Colors.black87),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFFD4AF37),
                        onSelected: (selected) {
                          if (selected) {
                            final sId = _safeInt(ayahData['sura'] ??
                                ayahData['surah'] ??
                                ayahData['chapter']);
                            final newObj = buildVerseObject(
                                sId, aNum, widget.currentPage);
                            if (newObj != null) {
                              newObj['polygon'] =
                                  ayahData['polygon'] ?? ayahData['bounds'];
                              newObj['indexOnPage'] =
                                  widget.pageAyahs.indexOf(ayahData);
                              newObj['totalOnPage'] = widget.pageAyahs.length;
                              setState(() {
                                _currentVerse = newObj;
                              });
                              widget.onSelectVerse?.call(newObj);
                            }
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          Text(
            _currentVerse['verseAr'],
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 22,
              color: const Color(0xFFD4AF37),
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.isArabic
                      ? 'تفسير الآية $verseNumber — سورة ${_currentVerse['surahNameAr']}'
                      : 'Tafseer of Verse $verseNumber — Surah ${_currentVerse['surahNameEn']}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.elMessiri(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.copy_rounded,
                    size: 18, color: Color(0xFFD4AF37)),
                tooltip: widget.isArabic ? 'نسخ' : 'Copy',
                onPressed: () {
                  final label = widget.isArabic
                      ? 'سورة ${_currentVerse['surahNameAr']} - آية $verseNumber'
                      : 'Surah ${_currentVerse['surahNameEn']} - Verse $verseNumber';
                  Clipboard.setData(ClipboardData(
                      text: '${_currentVerse['verseAr']}\n\n$label'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.isArabic ? 'تم نسخ الآية' : 'Verse copied'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedScholar == 0
                            ? const Color(0xFFD4AF37)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        widget.isArabic ? 'التفسير الميسّر' : 'Al-Muyassar',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.elMessiri(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _selectedScholar == 0
                              ? (isDarkMode ? const Color(0xFF0B3D2E) : Colors.white)
                              : (isDarkMode ? Colors.white70 : Colors.black87),
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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedScholar == 1
                            ? const Color(0xFFD4AF37)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        widget.isArabic ? 'ابن كثير (أونلاين)' : 'Ibn Kathir (Online)',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.elMessiri(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _selectedScholar == 1
                              ? (isDarkMode ? const Color(0xFF0B3D2E) : Colors.white)
                              : (isDarkMode ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFD4AF37)),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedScholar == 0
                ? _buildMuyassarContent(
                    isDarkMode: isDarkMode,
                    tafseerAr: tafseerAr,
                    tafseerEn: tafseerEn,
                  )
                : _buildIbnKathirContent(
                    isDarkMode: isDarkMode,
                    surahId: surahId,
                    verseNumber: verseNumber,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuyassarContent({
    required bool isDarkMode,
    required String tafseerAr,
    required String tafseerEn,
  }) {
    if (tafseerAr.isEmpty && tafseerEn.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book_rounded,
                color: Color(0xFFD4AF37), size: 48),
            const SizedBox(height: 12),
            Text(
              widget.isArabic
                  ? 'التفسير الميسّر غير متوفر لهذه الآية'
                  : 'Al-Muyassar tafseer is not available for this verse',
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(
                color: isDarkMode ? Colors.white54 : Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (tafseerAr.isNotEmpty) ...[
            Text(
              widget.isArabic ? 'التفسير الميسّر:' : 'Al-Muyassar Explanation:',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                color: const Color(0xFFD4AF37),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tafseerAr,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black87,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (tafseerEn.isNotEmpty) ...[
            Text(
              'English Translation:',
              style: GoogleFonts.elMessiri(
                color: const Color(0xFFD4AF37),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tafseerEn,
              textDirection: TextDirection.ltr,
              style: GoogleFonts.elMessiri(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIbnKathirContent({
    required bool isDarkMode,
    required int surahId,
    required int verseNumber,
  }) {
    return FutureBuilder<TafseerVerse?>(
      key: ValueKey('ibn-kathir-$surahId-$verseNumber'),
      future: TafseerApiService.fetchIbnKathirVerse(
        surahNumber: surahId,
        verseNumber: verseNumber,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded,
                    color: Color(0xFFD4AF37), size: 48),
                const SizedBox(height: 12),
                Text(
                  widget.isArabic
                      ? 'تعذر تحميل تفسير ابن كثير.\nيرجى التأكد من اتصالك بالإنترنت.'
                      : 'Could not load Ibn Kathir Tafseer.\nPlease check your connection.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.elMessiri(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isArabic ? 'تفسير ابن كثير:' : 'Ibn Kathir Tafseer:',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  color: const Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                snapshot.data!.tafseerAr,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  height: 1.8,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class QuranSearchDelegate extends SearchDelegate {
  final Function(int page, int surahId, int verseNum) onVerseSelected;
  QuranSearchDelegate({required this.onVerseSelected});

  String _normalize(String text) {
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
    cleaned = cleaned.replaceAll('ابراهيم', 'ابرهيم');
    cleaned = cleaned.replaceAll('اسماعيل', 'اسمعيل');
    cleaned = cleaned.replaceAll('اسحاق', 'اسحق');
    cleaned = cleaned.replaceAll('سليمان', 'سليمن');
    cleaned = cleaned.replaceAll('داوود', 'داود');
    cleaned = cleaned.replaceAll('سماوات', 'سموت');
    return cleaned;
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildSuggestions(BuildContext context) => _buildResultsView(context);

  @override
  Widget buildResults(BuildContext context) => _buildResultsView(context);

  Widget _buildResultsView(BuildContext context) {
    final cleanQuery = _normalize(query);
    final cleanQueryLower = query.toLowerCase().trim();
    if (cleanQuery.isEmpty) return Container();

    final results = <Map<String, dynamic>>[];

    for (var juz in QuranData.parts) {
      for (var surah in juz.surahs) {
        final int startVerse = surah.startingVerseNumber;
        for (int i = 0; i < surah.versesAr.length; i++) {
          final trueVerseNum = startVerse + i;
          final cleanVerseAr = _normalize(surah.versesAr[i]);
          final verseEn =
              i < surah.versesEn.length ? surah.versesEn[i].toLowerCase() : '';

          if (cleanVerseAr.contains(cleanQuery) ||
              (verseEn.isNotEmpty && verseEn.contains(cleanQueryLower))) {
            final page = QuranPageMetadata.getPageForVerse(surah.id, trueVerseNum);
            results.add({
              'surahId': surah.id,
              'verseNum': trueVerseNum,
              'surahName': surah.nameAr,
              'verseText': surah.versesAr[i],
              'page': page,
            });
          }
        }
      }
    }

    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 48, color: Color(0xFFD4AF37)),
            SizedBox(height: 12),
            Text('لا توجد نتائج / No results found'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Text(
              '${item['surahName']} - آية ${item['verseNum']} (ص ${item['page']})'),
          subtitle: Text(item['verseText'],
              maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () {
            onVerseSelected(
                item['page'], item['surahId'], item['verseNum']);
            close(context, null);
          },
        );
      },
    );
  }
}

Map<String, dynamic>? getSurahInfoFromPage(int pageNumber) {
  for (var entry in SURAH_PAGE_MAP.entries) {
    final surahData = entry.value;
    final startPage = surahData['startPage'] as int;
    final endPage = surahData['endPage'] as int;
    if (pageNumber >= startPage && pageNumber <= endPage) {
      return {
        'nameAr': surahData['nameAr'] as String,
        'nameEn': surahData['nameEn'] as String,
        'type': surahData['type'] as String,
      };
    }
  }
  return null;
}

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

    final double w = imageWidth;
    final double h = imageHeight;
    final Path path = Path();

    if (polygon != null) {
      const double imW = 1000.0;
      const double imH = 1500.0;

      final points = polygon
          .toString()
          .trim()
          .split(RegExp(r'\s+'))
          .map((e) => e.split(","))
          .where((e) => e.length == 2)
          .map((e) => Offset(
                ((double.tryParse(e[0]) ?? 0) / imW) * w,
                ((double.tryParse(e[1]) ?? 0) / imH) * h,
              ))
          .toList();

      if (points.isNotEmpty) {
        path.moveTo(points.first.dx, points.first.dy);
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        path.close();
      }
    }

    if (path.getBounds().isEmpty && selectedVerse!['indexOnPage'] != null) {
      final int idx = selectedVerse!['indexOnPage'];
      final int total = (selectedVerse!['totalOnPage'] != null &&
              selectedVerse!['totalOnPage'] > 0)
          ? selectedVerse!['totalOnPage'] as int
          : 1;

      double topMargin = h * 0.09;
      double bottomMargin = h * 0.91;
      double usableHeight = bottomMargin - topMargin;
      double sliceHeight = usableHeight / total;

      double yTop = topMargin + (idx * sliceHeight);
      double yBottom = yTop + sliceHeight;

      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(w * 0.06, yTop, w * 0.94, yBottom),
          const Radius.circular(8),
        ),
      );
    }

    if (path.getBounds().isEmpty) return;

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFD4AF37).withValues(alpha: 0.35)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFD4AF37).withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant VerseHighlightPainter oldDelegate) =>
      oldDelegate.selectedVerse != selectedVerse ||
      oldDelegate.imageWidth != imageWidth ||
      oldDelegate.imageHeight != imageHeight;
}