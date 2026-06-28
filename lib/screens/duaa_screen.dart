import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import '../data/duaa_data.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';

class DuaaScreen extends StatefulWidget {
  const DuaaScreen({super.key});

  @override
  State<DuaaScreen> createState() => _DuaaScreenState();
}

class _DuaaScreenState extends State<DuaaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: DuaaData.categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedCategoryIndex = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getFrenchCategory(String englishText) {
    final Map<String, String> categoryFrMap = {
      'Worry & Grief': 'Inquiétude et Chagrin', 'Knowledge & Education': 'Savoir et Éducation',
      'Sickness & Healing': 'Maladie et Guérison', 'Travel & Protection': 'Voyage et Protection',
      'Success & Guidance': 'Succès et Guidance', 'Completing the Quran': 'Achèvement du Coran',
      'Life & Sustenance': 'Vie et Subsistance', 'Family & Friends': 'Famille et Amis',
      'Sleep & Rest': 'Sommeil et Repos', 'Fear & Security': 'Peur et Sécurité',
    };
    return categoryFrMap[englishText] ?? englishText;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, l10n, isArabic),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: isDarkMode
                          ? BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0B3D2E).withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                                ),
                                child: _buildTabBar(isDarkMode),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                              ),
                              child: _buildTabBar(isDarkMode),
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: TabBarView(
                      controller: _tabController,
                      children: DuaaData.categories.map((category) {
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                          itemCount: category.duaas.length,
                          itemBuilder: (context, index) => _DuaaCard(duaa: category.duaas[index], lang: lang, index: index),
                        );
                      }).toList(),
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

  Widget _buildTabBar(bool isDarkMode) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: isDarkMode ? const Color(0xFFD4AF37) : Colors.black,
      unselectedLabelColor: isDarkMode ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
      indicatorColor: const Color(0xFFD4AF37),
      indicatorWeight: 3,
      dividerColor: Colors.transparent,
      labelStyle: GoogleFonts.elMessiri(fontSize: 16, fontWeight: FontWeight.bold),
      tabs: DuaaData.categories.map((category) {
        String tabText = category.categoryEn;
        if (Localizations.localeOf(context).languageCode == 'ar') {
          tabText = category.categoryAr;
        } else if (Localizations.localeOf(context).languageCode == 'fr') {
          tabText = _getFrenchCategory(category.categoryEn);
        }
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4), child: Tab(text: tabText));
      }).toList(),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations? l10n, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 24),
          ),
          Expanded(
            child: Text(
              l10n?.duaaTitle ?? 'الأدعية',
              textAlign: TextAlign.center,
              style: isArabic 
                  ? GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold)
                  : GoogleFonts.arefRuqaa(color: const Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _DuaaCard extends StatefulWidget {
  final Duaa duaa;
  final String lang;
  final int index;
  const _DuaaCard({required this.duaa, required this.lang, required this.index});
  
  @override
  State<_DuaaCard> createState() => _DuaaCardState();
}

class _DuaaCardState extends State<_DuaaCard> {
  bool _isExpanded = false;
  double _scale = 1.0;

  void _toggleExpand() => setState(() => _isExpanded = !_isExpanded);

  String _translateToFrench(String englishText) {
    if (englishText.isEmpty) return englishText;
    final Map<String, String> frTranslations = {
      'Dua for Distress': 'Douâa pour la Détresse', 
      'Dua for Anxiety & Sorrow': 'Douâa pour l\'Anxiété et le Chagrin',
      'There is no deity except You, exalted are You. Indeed, I have been of the wrongdoers.': 
          'Il n\'y a de divinité que Toi, exalté sois-Tu. J\'ai été vraiment du nombre des injustes.',
    };
    return frTranslations[englishText.trim()] ?? englishText;
  }

  Future<void> _copyToClipboard(String arabic, String translation) async {
    final textToCopy = "$arabic\n\n$translation";
    await Clipboard.setData(ClipboardData(text: textToCopy));
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.lang == 'ar' ? 'تم النسخ' : 'Copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.lang == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    String cardTitle = isArabic ? widget.duaa.titleAr : (widget.lang == 'fr' ? _translateToFrench(widget.duaa.titleEn) : widget.duaa.titleEn);
    String translatedDuaaText = widget.lang == 'fr' ? _translateToFrench(widget.duaa.duaaEn) : widget.duaa.duaaEn;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (widget.index * 50).clamp(0, 300)),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value, 
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 24), 
          child: child
        ),
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.98),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: _toggleExpand,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isDarkMode
                  ? BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: _buildDarkCard(cardTitle, translatedDuaaText),
                    )
                  : _buildLightCard(cardTitle, translatedDuaaText),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDarkCard(String cardTitle, String translatedDuaaText) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isExpanded ? const Color(0xFF144D32).withValues(alpha: 0.8) : const Color(0xFF0B3D2E).withValues(alpha: 0.65),
        border: Border.all(
          color: _isExpanded ? const Color(0xFFD4AF37).withValues(alpha: 0.8) : const Color(0xFFD4AF37).withValues(alpha: 0.3), 
          width: _isExpanded ? 2 : 1
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: _buildCardContent(cardTitle, translatedDuaaText, true),
    );
  }

  Widget _buildLightCard(String cardTitle, String translatedDuaaText) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isExpanded ? const Color(0xFFF5F5F5) : Colors.white,
        border: Border.all(
          color: _isExpanded ? const Color(0xFFD4AF37).withValues(alpha: 1) : const Color(0xFFD4AF37).withValues(alpha: 0.5),
          width: _isExpanded ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: _isExpanded ? 0.15 : 0.05),
            blurRadius: _isExpanded ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildCardContent(cardTitle, translatedDuaaText, false),
    );
  }

  Widget _buildCardContent(String cardTitle, String translatedDuaaText, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                cardTitle,
                style: GoogleFonts.elMessiri(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _isExpanded
                      ? (isDarkMode ? Colors.white : Colors.black)
                      : const Color(0xFFD4AF37),
                ),
              ),
            ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.expand_more_rounded,
                color: _isExpanded ? (isDarkMode ? Colors.white : Colors.black) : const Color(0xFFD4AF37),
                size: 28,
              ),
            ),
          ],
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF0F2D22)
                  : const Color(0xFFFDFBF7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.duaa.duaaAr,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD4AF37),
                    height: 2.0,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text(
                  translatedDuaaText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.elMessiri(
                    fontSize: 18,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.black87,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _copyToClipboard(widget.duaa.duaaAr, translatedDuaaText),
                icon: const Icon(Icons.copy_rounded),
                color: const Color(0xFFD4AF37),
                tooltip: widget.lang == 'ar' ? 'نسخ' : 'Copy',
              ),
            ],
          )
        ],
      ],
    );
  }
}