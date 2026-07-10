import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import '../data/duaa_data.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import '../utils/share_image_generator.dart';

class DuaaScreen extends StatefulWidget {
  const DuaaScreen({super.key});

  @override
  State<DuaaScreen> createState() => _DuaaScreenState();
}

class _DuaaScreenState extends State<DuaaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;

  // ==================== COMPLETE FRENCH TRANSLATION MAP ====================
  static const Map<String, String> _frenchTranslations = {
    // ---- CATEGORIES ----
    'Worry & Grief': 'Inquiétude et Chagrin',
    'Knowledge & Education': 'Savoir et Éducation',
    'Sickness & Healing': 'Maladie et Guérison',
    'Travel & Protection': 'Voyage et Protection',
    'Success & Guidance': 'Succès et Guidance',
    'Completing the Quran': 'Achèvement du Coran',
    'Life & Sustenance': 'Vie et Subsistance',
    'Family & Friends': 'Famille et Amis',
    'Sleep & Rest': 'Sommeil et Repos',
    'Fear & Security': 'Peur et Sécurité',

    // ---- DUAA TITLES ----
    'Dua for Distress': 'Invocation pour la détresse',
    'Dua for Anxiety & Sorrow': 'Invocation contre l\'anxiété et le chagrin',
    'Dua for Knowledge': 'Invocation pour le savoir',
    'Dua for Understanding': 'Invocation pour la compréhension',
    'Dua for Memorization': 'Invocation pour la mémorisation',
    'Dua for Healing': 'Invocation pour la guérison',
    'Dua When Visiting the Sick': 'Invocation lors de la visite d\'un malade',
    'Traveler\'s Dua': 'Invocation du voyageur',
    'Travel Remembrances': 'Évocations du voyage',
    'Dua for Divine Help': 'Invocation pour l\'aide divine',
    'Istikhara Dua': 'Invocation de consultation (Istikhara)',
    'Dua Upon Completing Quran': 'Invocation lors de l\'achèvement du Coran',
    'Dua for Sustenance': 'Invocation pour la subsistance',
    'Dua for Good Character': 'Invocation pour un bon caractère',
    'Dua for Parents': 'Invocation pour les parents',
    'Dua for a Righteous Spouse': 'Invocation pour un conjoint pieux',
    'Dua for Children': 'Invocation pour les enfants',
    'Sleep Dua': 'Invocation du sommeil',
    'Waking Up Dua': 'Invocation du réveil',
    'Dua Against Fear': 'Invocation contre la peur',
    'Protection Dua': 'Invocation de protection',
    'Dua for Anxiety & Worry': 'Invocation contre l\'anxiété et les soucis',

    // ---- DUAA TEXTS (English) -> French ----
    'There is no deity except You, exalted are You. Indeed, I have been of the wrongdoers.':
        'Il n\'y a de divinité que Toi, gloire à Toi ! J\'ai été parmi les injustes.',

    'O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts and from being overpowered by men.':
        'Ô Allah, je cherche refuge auprès de Toi contre l\'anxiété et le chagrin, la faiblesse et la paresse, l\'avarice et la lâcheté, le fardeau des dettes et le joug des hommes.',

    'O Allah, I ask You for beneficial knowledge, good provision, and accepted deeds.':
        'Ô Allah, je Te demande une science utile, une subsistance licite et une œuvre agréée.',

    'O Allah, I ask You for understanding of the religion and memorization of knowledge.':
        'Ô Allah, je Te demande la compréhension de la religion et la mémorisation du savoir.',

    'O Allah, I ask You for beneficial knowledge.':
        'Ô Allah, je Te demande une science utile.',

    'O Allah, I ask You for healing and I seek refuge in You from all evil.':
        'Ô Allah, je Te demande la guérison et je cherche refuge auprès de Toi contre tout mal.',

    'O Allah, I ask You for healing from this sickness.':
        'Ô Allah, je Te demande la guérison de cette maladie.',

    'I seek refuge in the perfect words of Allah from the evil of what He has created.':
        'Je cherche refuge dans les paroles parfaites d\'Allah contre le mal de ce qu\'Il a créé.',

    'O Allah, I seek refuge in You from the difficulty of the journey and from changing after returning.':
        'Ô Allah, je cherche refuge auprès de Toi contre les difficultés du voyage et contre le changement après le retour.',

    'Allahu Akbar, Allahu Akbar, Allahu Akbar. Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrinin.':
        'Allah est le plus grand, Allah est le plus grand, Allah est le plus grand. Gloire à Celui qui a mis ceci à notre service alors que nous n\'étions pas capables.',

    'O Allah, I ask You for divine help and guidance.':
        'Ô Allah, je Te demande l\'aide et la guidance divines.',

    'O Allah, I ask You to guide me and make my affairs easy for me.':
        'Ô Allah, je Te demande de me guider et de rendre mes affaires faciles pour moi.',

    'O Allah, I ask You for the best in this life and the Hereafter.':
        'Ô Allah, je Te demande le bien dans ce monde et dans l\'au-delà.',

    'O Allah, I ask You for good character and guidance to the best of deeds.':
        'Ô Allah, je Te demande un bon caractère et la guidance vers les meilleures œuvres.',

    'O Allah, have mercy on my parents as they raised me with mercy.':
        'Ô Allah, fais miséricorde à mes parents comme ils m\'ont élevé avec miséricorde.',

    'O Allah, I ask You for a righteous spouse and righteous children.':
        'Ô Allah, je Te demande un conjoint pieux et des enfants pieux.',

    'O Allah, I ask You for righteous children and offspring.':
        'Ô Allah, je Te demande des enfants pieux et une descendance vertueuse.',

    'In Your name, O Allah, I sleep and wake.':
        'En Ton nom, ô Allah, je dors et je me réveille.',

    'Praise be to Allah Who gave us life after death and to Him is the resurrection.':
        'Louange à Allah qui nous a rendus à la vie après la mort et c\'est vers Lui que sera la résurrection.',

    'O Allah, I seek refuge in You from fear and harm.':
        'Ô Allah, je cherche refuge auprès de Toi contre la peur et le mal.',

    'I seek refuge in the perfect words of Allah from all evil and harm.':
        'Je cherche refuge dans les paroles parfaites d\'Allah contre tout mal et tout danger.',

    'O Allah, grant me success and do not oppose me. Grant me success through Your mercy, O Most Merciful.':
        'Ô Allah, accorde-moi le succès et ne Te oppose pas à moi. Accorde-moi le succès par Ta miséricorde, ô le plus Miséricordieux.',

    'O Allah, I seek Your guidance and ask for Your blessing in this matter.':
        'Ô Allah, je Te demande guidance et bénédiction dans cette affaire.',

    'O Allah, I ask You for Your favor and mercy to complete the Quran.':
        'Ô Allah, je Te demande Ta faveur et Ta miséricorde pour achever le Coran.',

    'O Allah, bless us in what You have provided and protect us from the punishment of the Fire.':
        'Ô Allah, bénis-nous dans ce que Tu nous as accordé et protège-nous du châtiment du Feu.',

    'O Allah, improve my character and guide me to the best of manners.':
        'Ô Allah, améliore mon caractère et guide-moi vers la meilleure éthique.',

    'O Allah, forgive my parents and have mercy on them as they raised me with mercy.':
        'Ô Allah, pardonne à mes parents et fais-leur miséricorde comme ils m\'ont élevé avec miséricorde.',

    'O Allah, grant me a pious spouse and righteous children.':
        'Ô Allah, accorde-moi un conjoint pieux et des enfants vertueux.',

    'O Allah, protect me from fear and anxiety and grant me peace of mind.':
        'Ô Allah, protège-moi de la peur et de l\'anxiété et accorde-moi la tranquillité d\'esprit.',

    'I seek refuge in You, O Allah, from all evil and harm.':
        'Je cherche refuge auprès de Toi, ô Allah, contre tout mal et tout danger.',

    // ---- BENEFITS / CONTEXT (English -> French) ----
    'For severe distress and sorrow': 'Pour les grandes détresses et les chagrins',
    'For seeking beneficial knowledge and understanding': 'Pour demander une science utile et la compréhension',
    'For improving memorization and learning': 'Pour améliorer la mémorisation et l\'apprentissage',
    'For healing from sickness and diseases': 'Pour guérir des maladies et des souffrances',
    'When visiting the sick': 'Lors de la visite d\'un malade',
    'For safety during travel': 'Pour la sécurité en voyage',
    'Remembrances to say during travel': 'Évocations à dire pendant le voyage',
    'Dua for success and divine guidance': 'Dua pour le succès et la guidance divine',
    'For seeking Allah\'s guidance in important decisions': 'Pour demander la guidance d\'Allah dans les décisions importantes',
    'Upon completing the Quran recitation': 'Lors de l\'achèvement de la récitation du Coran',
    'For provision and livelihood': 'Pour la subsistance et les moyens de vivre',
    'For developing good character': 'Pour développer un bon caractère',
    'For parents\' well-being and mercy': 'Pour le bien-être et la miséricorde des parents',
    'For finding a righteous spouse': 'Pour trouver un conjoint pieux',
    'For the well-being of children': 'Pour le bien-être des enfants',
    'Before sleeping': 'Avant de dormir',
    'Upon waking up': 'Au réveil',
    'For protection against fear': 'Pour se protéger contre la peur',
    'For general protection from harm': 'Pour une protection générale contre le mal',
    // --- New missing ones from your screenshots ---
    "Traveler's dua before departure": "Dua du voyageur avant le départ",
    "Prophet's dua for recovery from illness": "Dua du Prophète pour la guérison d'une maladie",
    'O Lord of the people, remove the harm and cure it. You are the Healer. There is no cure except Your cure, a cure that leaves no illness.':
        'Ô Seigneur des hommes, ôte le mal et guéris. Tu es le Guérisseur, il n\'y a de guérison que la Tienne, une guérison qui ne laisse aucune maladie.',
    'O Allah, in this journey of mine, I ask You for goodness and piety, and deeds that please You. O Allah, make this journey easy for me and shorten its distance.':
        'Ô Allah, dans mon voyage, je Te demande la bienfaisance et la piété, et des œuvres qui Te plaisent. Ô Allah, rends ce voyage facile pour moi et raccourcis sa distance.',
  };

  // Translation helper
  String _translateToFrench(String text) {
    if (text.isEmpty) return text;
    // Try exact match first
    if (_frenchTranslations.containsKey(text)) {
      return _frenchTranslations[text]!;
    }
    // If not found, return original (will show English)
    // In production you could add a fallback or log missing keys
    return text;
  }

  String _getFrenchCategory(String englishText) {
    return _frenchTranslations[englishText] ?? englishText;
  }

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
                          itemBuilder: (context, index) => _DuaaCard(
                            duaa: category.duaas[index],
                            lang: lang,
                            index: index,
                            translator: _translateToFrench,
                          ),
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

// ==================== Duaa Card Widget ====================

class _DuaaCard extends StatefulWidget {
  final Duaa duaa;
  final String lang;
  final int index;
  final String Function(String) translator;

  const _DuaaCard({
    required this.duaa,
    required this.lang,
    required this.index,
    required this.translator,
  });

  @override
  State<_DuaaCard> createState() => _DuaaCardState();
}

class _DuaaCardState extends State<_DuaaCard> {
  bool _isExpanded = false;
  double _scale = 1.0;

  void _toggleExpand() => setState(() => _isExpanded = !_isExpanded);

  Future<void> _copyToClipboard(String arabic) async {
    await Clipboard.setData(ClipboardData(text: arabic));
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

    // Title
    String cardTitle;
    if (isArabic) {
      cardTitle = widget.duaa.titleAr;
    } else if (widget.lang == 'fr') {
      cardTitle = widget.translator(widget.duaa.titleEn);
    } else {
      cardTitle = widget.duaa.titleEn;
    }

    // Duaa text (the actual prayer)
    String translatedText;
    if (isArabic) {
      translatedText = widget.duaa.duaaEn; // fallback for Arabic mode (not used)
    } else if (widget.lang == 'fr') {
      translatedText = widget.translator(widget.duaa.duaaEn);
    } else {
      translatedText = widget.duaa.duaaEn;
    }

    // Benefit / Context
    String benefitText;
    if (isArabic) {
      benefitText = widget.duaa.benefitAr ?? '';
    } else if (widget.lang == 'fr') {
      final englishBenefit = widget.duaa.benefitEn ?? '';
      benefitText = 'Contexte: ${widget.translator(englishBenefit)}';
    } else {
      benefitText = 'Context: ${widget.duaa.benefitEn ?? ''}';
    }

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (widget.index * 50).clamp(0, 300)),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 24),
          child: child,
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
                      child: _buildDarkCard(cardTitle, translatedText, benefitText),
                    )
                  : _buildLightCard(cardTitle, translatedText, benefitText),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDarkCard(String title, String text, String benefit) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isExpanded ? const Color(0xFF144D32).withValues(alpha: 0.8) : const Color(0xFF0B3D2E).withValues(alpha: 0.65),
        border: Border.all(
          color: _isExpanded ? const Color(0xFFD4AF37).withValues(alpha: 0.8) : const Color(0xFFD4AF37).withValues(alpha: 0.3),
          width: _isExpanded ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: _buildCardContent(title, text, benefit, true),
    );
  }

  Widget _buildLightCard(String title, String text, String benefit) {
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
      child: _buildCardContent(title, text, benefit, false),
    );
  }

  Widget _buildCardContent(String title, String text, String benefit, bool isDarkMode) {
    final isArabic = widget.lang == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.elMessiri(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _isExpanded ? (isDarkMode ? Colors.white : Colors.black) : const Color(0xFFD4AF37),
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
              color: isDarkMode ? const Color(0xFF0F2D22) : const Color(0xFFFDFBF7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic text
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
                // Translated text (English or French)
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.elMessiri(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (benefit.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: Color(0xFFD4AF37), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            benefit,
                            style: GoogleFonts.elMessiri(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _copyToClipboard(widget.duaa.duaaAr),
                icon: const Icon(Icons.copy_rounded),
                color: const Color(0xFFD4AF37),
                tooltip: isArabic ? 'نسخ' : 'Copy',
              ),
              IconButton(
                onPressed: () {
                  ShareImageGenerator.generateAndShareImageWithWidget(
                    title: widget.duaa.duaaAr,
                    subtitle: text,
                    isDarkMode: isDarkMode,
                    lang: widget.lang,
                    context: context,
                  );
                },
                icon: const Icon(Icons.share_rounded),
                color: const Color(0xFFD4AF37),
                tooltip: isArabic ? 'مشاركة' : 'Share',
              ),
            ],
          ),
        ],
      ],
    );
  }
}