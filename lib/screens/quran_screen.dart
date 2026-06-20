import 'package:flutter/material.dart';
import '../data/quran_data.dart';

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

  // Helper function to remove Tashkeel (diacritics) for accurate Arabic searching
  String _removeDiacritics(String text) {
    return text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _searchResults.clear();

      if (query.trim().isEmpty) return;

      final cleanQuery = _removeDiacritics(query.toLowerCase().trim());

      // Search through all parts, surahs, and verses
      for (var juz in QuranData.parts) {
        for (var surah in juz.surahs) {
          for (int i = 0; i < surah.versesAr.length; i++) {
            final cleanVerseAr = _removeDiacritics(surah.versesAr[i]);
            final verseEn = i < surah.versesEn.length ? surah.versesEn[i].toLowerCase() : '';

            // If the Arabic or English verse contains the search query
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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'القرآن الكريم',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── SEARCH BOX ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              style: const TextStyle(color: Colors.white),
              textDirection: TextDirection.rtl, // Better for Arabic typing
              decoration: InputDecoration(
                hintText: 'ابحث عن آية أو كلمة... (Search)',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1B5E3F).withValues(alpha: 0.3),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                ),
              ),
            ),
          ),

          // ── DYNAMIC BODY (SHOWS GRID OR SEARCH RESULTS) ────────────
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildPartsGrid() // Show the normal 30 parts if not searching
                : _buildSearchResults(), // Show results if typing
          ),
        ],
      ),
    );
  }

  // The original 30-part GridView extracted into a method
  Widget _buildPartsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: QuranData.parts.length,
      itemBuilder: (context, index) {
        final juz = QuranData.parts[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JuzScreen(juz: juz)),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFD4AF37).withValues(alpha: 0.05),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${juz.id}',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الجزء',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
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

  // The new Search Results list view
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد نتائج (No results found)',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.2)),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final QuranSurah surah = result['surah'];
        final int verseNum = result['verseIndex'] + 1;
        final String searchQuery = result['searchQuery'];

        return InkWell(
          onTap: () {
            // Navigate to the Surah and scroll to the found verse with highlighting
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurahReaderScreen(
                  surah: surah,
                  highlightVerseIndex: result['verseIndex'],
                  searchQuery: searchQuery,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF1B5E3F).withValues(alpha: 0.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Surah Name + Verse Number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سورة ${surah.nameAr}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Verse $verseNum',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Arabic Match
                Text(
                  result['verseAr'],
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.6,
                    fontFamily: 'Amiri',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // English Match (if available)
                if (result['verseEn'].toString().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    result['verseEn'],
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13, fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// SCREEN 2: THE SURAHS IN A SPECIFIC PART
// ==========================================
class JuzScreen extends StatelessWidget {
  final QuranJuz juz;
  const JuzScreen({super.key, required this.juz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          juz.titleAr,
          style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: juz.surahs.isEmpty
          ? const Center(
              child: Text(
                'قريباً إن شاء الله\n(Coming Soon)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 18),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: juz.surahs.length,
              separatorBuilder: (context, index) => Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.2)),
              itemBuilder: (context, index) {
                final surah = juz.surahs[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  leading: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        // Uses a standard circle if you don't have a specific star asset
                        image: AssetImage('assets/star_icon.png'), 
                      ),
                      shape: BoxShape.circle,
                      color: Color(0xFF1B5E3F),
                    ),
                    child: Text(
                      '${surah.id}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    surah.nameAr,
                    style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SurahReaderScreen(surah: surah),
                    ));
                  },
                );
              },
            ),
    );
  }
}

// ==========================================
// SCREEN 3: THE ACTUAL READER (With Basmallah)
// ==========================================
class SurahReaderScreen extends StatefulWidget {
  final QuranSurah surah;
  final int? highlightVerseIndex;
  final String? searchQuery;

  const SurahReaderScreen({
    super.key,
    required this.surah,
    this.highlightVerseIndex,
    this.searchQuery,
  });

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // If we have a verse to highlight, scroll to it after the frame is rendered
    if (widget.highlightVerseIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToVerse(widget.highlightVerseIndex!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToVerse(int verseIndex) {
    // Approximate scroll position based on verse index
    // Each verse takes roughly 200 pixels (adjust if needed)
    final scrollOffset = verseIndex * 200.0;
    _scrollController.animateTo(
      scrollOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  bool _isVerseHighlighted(int verseIndex) {
    return widget.highlightVerseIndex == verseIndex;
  }

  bool _doesVerseContainQuery(int verseIndex) {
    if (widget.searchQuery == null) return false;
    
    final cleanQuery = widget.searchQuery!
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .toLowerCase();
    
    final verseAr = widget.surah.versesAr[verseIndex]
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .toLowerCase();
    
    final verseEn = verseIndex < widget.surah.versesEn.length
        ? widget.surah.versesEn[verseIndex].toLowerCase()
        : '';
    
    return verseAr.contains(cleanQuery) || verseEn.contains(cleanQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'سورة ${widget.surah.nameAr}',
          style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Show Basmallah for all Surahs EXCEPT Al-Fatihah (id: 1) and At-Tawbah (id: 9)
          if (widget.surah.id != 1 && widget.surah.id != 9)
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri',
                ),
              ),
            ),
          if (widget.surah.id != 1 && widget.surah.id != 9)
            const Divider(color: Color(0xFFD4AF37), indent: 60, endIndent: 60, thickness: 1),
          
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.surah.versesAr.length,
              itemBuilder: (context, index) {
                final isHighlighted = _isVerseHighlighted(index);
                final containsQuery = _doesVerseContainQuery(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isHighlighted 
                          ? const Color(0xFF1B5E3F).withValues(alpha: 0.4)
                          : (containsQuery ? const Color(0xFF1B5E3F).withValues(alpha: 0.2) : Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                      border: isHighlighted
                          ? Border.all(color: const Color(0xFFD4AF37), width: 2)
                          : null,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ARABIC TEXT ROW
                        Row(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(top: 4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                widget.surah.versesAr[index],
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: isHighlighted ? const Color(0xFFD4AF37) : Colors.white,
                                  height: 1.8,
                                  fontFamily: 'Amiri',
                                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // ENGLISH TRANSLATION ROW
                        if (index < widget.surah.versesEn.length)
                          Text(
                            widget.surah.versesEn[index],
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 16,
                              color: isHighlighted 
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.7),
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          
                        const SizedBox(height: 16),
                        Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.2)),
                      ],
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