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
  late int _currentPage;
  late PageController _pageController;
  int? _bookmarkedPage; 

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: _currentPage - 1);
    _loadBookmark();
  }

  // --- BOOKMARK LOGIC ---
  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarkedPage = prefs.getInt('saved_quran_page');
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_bookmarkedPage == _currentPage) {
      // Remove bookmark if already on the bookmarked page
      await prefs.remove('saved_quran_page');
      setState(() => _bookmarkedPage = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إزالة العلامة / Bookmark removed')),
        );
      }
    } else {
      // Save new bookmark
      await prefs.setInt('saved_quran_page', _currentPage);
      setState(() => _bookmarkedPage = _currentPage);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ العلامة / Bookmark saved')),
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
    
    setState(() => _currentPage = page);
    _pageController.animateToPage(
      page - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() => _goToPage(QuranPageMetadata.getNextPage(_currentPage));
  void _previousPage() => _goToPage(QuranPageMetadata.getPreviousPage(_currentPage));

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
          // Bookmark Toggle Icon
          IconButton(
            icon: Icon(
              _bookmarkedPage == _currentPage ? Icons.bookmark : Icons.bookmark_add_outlined, 
              color: Theme.of(context).colorScheme.secondary,
            ),
            tooltip: isArabic ? 'حفظ العلامة' : 'Save Mark',
            onPressed: _toggleBookmark,
          ),
          // Search Icon
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
    tooltip: isArabic ? 'فهرس السور' : 'Surah Index',
    onPressed: () {
      // Opens the index inside the viewer context
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildSurahIndexSheet(isArabic),
      );
    },
  ),
          // Verse Selector - list the ayat on this page, pick one for Tafseer or Copy
          IconButton(
            icon: Icon(Icons.format_list_bulleted_rounded, color: Theme.of(context).colorScheme.secondary),
            tooltip: isArabic ? 'اختر آية' : 'Select a Verse',
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
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index + 1);
              },
              itemCount: QuranPageMetadata.totalPages,
              itemBuilder: (context, index) {
                return _buildQuranPage(context, index + 1, isArabic);
              },
            ),
          ),
          _buildNavigationControls(context, isArabic),
        ],
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context, bool isArabic) {
    // This accurately pulls from SURAH_PAGE_MAP to fix the Fatihah/Baqarah mismatch
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
          // Left Side - Page Number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
              ),
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

          // Center - Dynamic Surah Name
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

          // Right Side - Total Pages
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
              ),
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
          child: Text(isArabic ? 'فهرس السور' : 'Surah Index', 
              style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold)),
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
                  _goToPage(surah['startPage']); // Jumps to the page
                  Navigator.pop(context); // Closes the index
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

  // --- VERSE SELECTION LOGIC ---

  /// Returns every verse that falls on [pageNumber], in Mushaf reading order.
  /// Reuses QuranPageMetadata.getPageForVerse (the same estimator already
  /// used by search-to-page navigation) so results stay consistent with the
  /// rest of the app, and only scans surahs whose SURAH_PAGE_MAP range
  /// actually touches this page.
  ///
  /// Note: doesn't rely on QuranSurah.startingVerseNumber (not present on
  /// every copy of the model in this project) - instead it tracks how many
  /// verses of each surah have already been walked past, since Juz chunks
  /// for the same surah always appear in order.
  List<Map<String, dynamic>> _getVersesOnPage(int pageNumber) {
    final versesOnPage = <Map<String, dynamic>>[];
    final versesSeenSoFar = <int, int>{};

    for (var juz in QuranData.parts) {
      for (var surahChunk in juz.surahs) {
        final chunkStartVerse = (versesSeenSoFar[surahChunk.id] ?? 0) + 1;
        final surahRange = SURAH_PAGE_MAP[surahChunk.id];

        if (surahRange == null ||
            pageNumber < surahRange['startPage'] ||
            pageNumber > surahRange['endPage']) {
          versesSeenSoFar[surahChunk.id] = chunkStartVerse - 1 + surahChunk.versesAr.length;
          continue;
        }

        for (int i = 0; i < surahChunk.versesAr.length; i++) {
          final verseNumber = chunkStartVerse + i;
          final estimatedPage = QuranPageMetadata.getPageForVerse(surahChunk.id, verseNumber);
          if (estimatedPage == pageNumber) {
            versesOnPage.add({
              'surahId': surahChunk.id,
              'surahNameAr': surahChunk.nameAr,
              'surahNameEn': surahChunk.nameEn,
              'verseNumber': verseNumber,
              'verseAr': surahChunk.versesAr[i],
              'verseEn': i < surahChunk.versesEn.length ? surahChunk.versesEn[i] : '',
              'verseFr': i < surahChunk.versesFr.length ? surahChunk.versesFr[i] : '',
            });
          }
        }

        versesSeenSoFar[surahChunk.id] = chunkStartVerse - 1 + surahChunk.versesAr.length;
      }
    }

    versesOnPage.sort((a, b) {
      final surahCompare = (a['surahId'] as int).compareTo(b['surahId'] as int);
      if (surahCompare != 0) return surahCompare;
      return (a['verseNumber'] as int).compareTo(b['verseNumber'] as int);
    });

    return versesOnPage;
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

  Widget _buildPageVersesSheet(bool isArabic) {
    final verses = _getVersesOnPage(_currentPage);
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
                          onTap: () {
                            Navigator.pop(context);
                            _showVerseTafseerSheet(context, verse, isArabic);
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
                            onPressed: () => _copyVerseText(context, verse, isArabic),
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

  Future<void> _showVerseTafseerSheet(BuildContext context, Map<String, dynamic> verse, bool isArabic) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VerseTafseerSheet(verse: verse, isArabic: isArabic),
    );
  }

  Widget _buildQuranPage(BuildContext context, int pageNumber, bool isArabic) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 3.0,
            child: Builder(
              builder: (context) {
                final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                Widget quranImage = Image.asset(
                  'assets/quran_pages/$pageNumber.png', 
                  fit: BoxFit.contain,
                );

                if (isDarkMode) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      -1,  0,  0, 0, 255, 
                       0, -1,  0, 0, 255, 
                       0,  0, -1, 0, 255, 
                       0,  0,  0, 1,   0, 
                    ]),
                    child: quranImage,
                  );
                }
                return quranImage;
              },
            )
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationControls(BuildContext context, bool isArabic) {
    // Get the current language code to properly translate the buttons
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

    // By REMOVING the forced Directionality widget, Flutter will naturally place the 
    // first item on the Left for English/French, and on the Right for Arabic.
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
          
          // 1. PREVIOUS BUTTON (Leading: Left in LTR, Right in RTL)
          ElevatedButton.icon(
            onPressed: _previousPage,
            // arrow_back_rounded automatically flips based on language direction
            icon: const Icon(Icons.arrow_back_rounded), 
            label: Text(previousText),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
              foregroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // 2. CENTER: Go to Mark Button
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

          // 3. NEXT BUTTON (Trailing: Right in LTR, Left in RTL)
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
                // arrow_forward_rounded automatically flips based on language direction
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
    final tafseerAr = tafseerVerse?.tafseerAr ?? '';
    final tafseerEn = tafseerVerse?.tafseerEn ?? '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white38 : Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Verse text with a Copy shortcut right where you're reading it
          Text(
            verse['verseAr'],
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 22,
              color: const Color(0xFFD4AF37),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isArabic
                    ? 'تفسير الآية $verseNumber - سورة ${verse['surahNameAr']}'
                    : 'Tafseer of Verse $verseNumber - Surah ${verse['surahNameEn']}',
                textAlign: TextAlign.center,
                style: GoogleFonts.elMessiri(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18, color: Color(0xFFD4AF37)),
                tooltip: isArabic ? 'نسخ الآية' : 'Copy verse',
                onPressed: () {
                  final label = isArabic
                      ? 'سورة ${verse['surahNameAr']} - آية $verseNumber'
                      : 'Surah ${verse['surahNameEn']} - Verse $verseNumber';
                  Clipboard.setData(ClipboardData(text: '${verse['verseAr']}\n\n$label'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isArabic ? 'تم نسخ الآية' : 'Verse copied')),
                  );
                },
              ),
            ],
          ),
          const Divider(color: Color(0xFFD4AF37)),
          const SizedBox(height: 8),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (tafseerAr.isNotEmpty) ...[
                    Text(
                      'التفسير الميسر:',
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
                  if (tafseerAr.isEmpty && tafseerEn.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text(
                          isArabic ? 'التفسير غير متوفر حالياً' : 'Tafseer is currently unavailable',
                          style: GoogleFonts.elMessiri(
                            color: isDarkMode ? Colors.white54 : Colors.black54,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuranSearchDelegate extends SearchDelegate {
  final Function(int) onPageSelected;

  QuranSearchDelegate({required this.onPageSelected});

  String _removeDiacritics(String text) {
    return text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  // ✅ FIX: Move logic to buildSuggestions so it updates while typing
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultsView();
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsView();
  }

  Widget _buildResultsView() {
    final results = [];
    final cleanQuery = _removeDiacritics(query.toLowerCase().trim());

    if (query.isEmpty) return Container();

    for (var juz in QuranData.parts) {
      for (var surah in juz.surahs) {
        for (int i = 0; i < surah.versesAr.length; i++) {
          if (_removeDiacritics(surah.versesAr[i]).contains(cleanQuery) || 
              surah.versesEn[i].toLowerCase().contains(cleanQuery)) {
            
            // ✅ FIX: Calculate the page correctly using your SURAH_PAGE_MAP
            // You need to map the Surah ID and verse index to a page number.
            // Using your SURAH_PAGE_MAP logic:
            final page = _getPageForVerse(surah.id, i + 1); 

            results.add({
              'surahName': surah.nameAr, 
              'verseText': surah.versesAr[i], 
              'page': page
            });
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
          onTap: () {
            // ✅ FIX: Navigate to the page and close search
            onPageSelected(results[index]['page']);
            close(context, null);
          },
        );
      },
    );
  }

  // Helper to find the page from the mapping
  int _getPageForVerse(int surahId, int verseIndex) {
    final surahData = SURAH_PAGE_MAP[surahId];
    return surahData?['startPage'] ?? 1;
  }
}