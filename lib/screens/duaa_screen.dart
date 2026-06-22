import 'package:flutter/material.dart';
import 'dart:ui';
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
    _tabController = TabController(
      length: DuaaData.categories.length,
      vsync: this,
    );
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
    };
    return categoryFrMap[englishText] ?? englishText;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, l10n, isArabic),
              
              // ── Floating Glass TabBar ──
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B3D2E).withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: const Color(0xFFD4AF37),
                            unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                            indicatorColor: const Color(0xFFD4AF37),
                            indicatorWeight: 3,
                            dividerColor: Colors.transparent,
                            labelStyle: GoogleFonts.elMessiri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            tabs: DuaaData.categories.map((category) {
                              String tabText = category.categoryEn;
                              if (isArabic) {
                                tabText = category.categoryAr;
                              } else if (lang == 'fr') {
                                tabText = _getFrenchCategory(category.categoryEn);
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                                child: Tab(text: tabText),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Tab Views ──
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: TabBarView(
                      controller: _tabController,
                      children: DuaaData.categories.map((category) {
                        return _buildCategoryContent(context, category, lang);
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isArabic) {
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
              l10n.duaaTitle,
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

  Widget _buildCategoryContent(BuildContext context, DuaaCategory category, String lang) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      itemCount: category.duaas.length,
      itemBuilder: (context, index) {
        return _DuaaCard(
          duaa: category.duaas[index],
          lang: lang,
          index: index,
        );
      },
    );
  }
}

class _DuaaCard extends StatefulWidget {
  final Duaa duaa;
  final String lang;
  final int index;

  const _DuaaCard({
    required this.duaa,
    required this.lang,
    required this.index,
  });

  @override
  State<_DuaaCard> createState() => _DuaaCardState();
}

class _DuaaCardState extends State<_DuaaCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
  }

  String _translateToFrench(String englishText) {
    if (englishText.isEmpty) return englishText;

    final Map<String, String> frTranslations = {
      'Dua for Distress': 'Douâa pour la Détresse',
      'Dua for Anxiety & Sorrow': 'Douâa pour l\'Anxiété et le Chagrin',
      'Dua for Knowledge': 'Douâa pour le Savoir',
      'Dua for Understanding': 'Douâa pour la Compréhension',
      'Dua for Memorization': 'Douâa pour la Mémorisation',
      'Dua for Healing': 'Douâa pour la Guérison',
      'Dua When Visiting the Sick': 'Douâa en Visitant un Malade',
      'Traveler\'s Dua': 'Douâa du Voyageur',
      'Travel Remembrances': 'Invocations de Voyage',
      'Dua for Divine Help': 'Douâa pour l\'Aide Divine',
      'Istikhara Dua': 'Douâa de l\'Istikhara',
      'Dua Upon Completing Quran': 'Douâa à l\'Achèvement du Coran',
      'Dua for Sustenance': 'Douâa pour la Subsistance',
      'Dua for Good Character': 'Douâa pour le Bon Comportement',
      'Dua for Parents': 'Douâa pour les Parents',
      'Dua for a Righteous Spouse': 'Douâa pour un Conjoint Pieux',
      'Dua for Children': 'Douâa pour les Enfants',
      'Sleep Dua': 'Douâa du Sommeil',
      'Waking Up Dua': 'Douâa du Réveil',
      'Dua Against Fear': 'Douâa contre la Peur',
      'Protection Dua': 'Douâa de Protection',
      'There is no deity except You, exalted are You. Indeed, I have been of the wrongdoers.': 'Il n\'y a de divinité que Toi, exalté sois-Tu. J\'ai été vraiment du nombre des injustes.',
      'O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts, and from being overpowered by men.': 'Ô Allah, je cherche refuge auprès de Toi contre l\'anxiété et le chagrin, la faiblesse et la paresse, l\'avarice et la lâcheté, le poids des dettes et la domination des hommes.',
      'My Lord, expand for me my breast and ease for me my task and loosen the knot from my tongue that they may understand my speech.': 'Seigneur, ouvre-moi ma poitrine, et facilite ma mission, et dénoue un nœud en ma langue, afin qu\'ils comprennent mes paroles.',
      'O Allah, I ask You for understanding in the religion and immediate success.': 'Ô Allah, je Te demande la compréhension de la religion et un succès immédiat.',
      'O Allah, expand my chest, ease my matters, and help me memorize Your Book.': 'Ô Allah, ouvre ma poitrine, facilite mes affaires et aide-moi à mémoriser Ton Livre.',
      'O Lord of the people, remove the harm and cure it. You are the Healer. There is no cure except Your cure, a cure that leaves no illness.': 'Ô Seigneur des hommes, dissipe le mal et guéris. Tu es le Guérisseur. Il n\'y a de guérison que la Tienne, une guérison qui ne laisse aucune maladie.',
      'No worries, it will be a purification, Allah willing.': 'Pas de mal, ce sera une purification, si Allah le veut.',
      'O Allah, in this journey of mine, I ask You for goodness and piety, and deeds that please You. O Allah, make this journey easy for me and shorten its distance.': 'Ô Allah, dans ce voyage, je Te demande la bonté et la piété, et des actes qui Te plaisent. Ô Allah, rends-moi ce voyage facile et raccourcis-en la distance.',
      'Exalted is He who has subjected this to us, and we could not have [otherwise] subdued it.': 'Gloire à Celui qui a mis ceci à notre service, alors que nous n\'étions pas capables de le dominer.',
      'O Allah, grant me success and do not oppose me. Grant me success through Your mercy, O Most Merciful.': 'Ô Allah, accorde-moi le succès et ne t\'oppose pas à moi. Accorde-moi le succès par Ta miséricorde, Ô le plus Miséricordieux.',
      'O Allah, I seek Your guidance by virtue of Your knowledge and ability by virtue of Your power, and I ask You for Your immense grace. Surely You have power; I have none. You know; I know not. You are the Knower of hidden things.': 'Ô Allah, je Te consulte par Ta connaissance et je T\'implore de m\'accorder la capacité par Ton pouvoir, et je Te demande de Ton immense grâce. Car Tu es Capable et je ne le suis pas. Tu sais et je ne sais pas. Tu es le Connaisseur des choses cachées.',
      'O Allah, You have honored me in this chapter with Your Noble Word, so make it a light in my heart, wisdom in my chest, and light in my grave.': 'Ô Allah, Tu m\'as honoré dans ce chapitre par Ta Noble Parole, fais-en donc une lumière dans mon cœur, une sagesse dans ma poitrine, et une lumière dans ma tombe.',
      'O Allah, suffice me with what is lawful to protect me from what is forbidden, and make me rich through Your grace, so that I am not in need of anyone but You.': 'Ô Allah, suffis-moi par ce qui est licite pour me protéger de ce qui est interdit, et rends-moi riche par Ta grâce, afin que je n\'aie besoin de personne d\'autre que Toi.',
      'O Allah, guide me to the best of manners. None can guide to the best of them except You. And turn away from me the worst of manners. None can turn away the worst of them except You.': 'Ô Allah, guide-moi vers les meilleurs comportements. Nul ne peut guider vers les meilleurs d\'entre eux sauf Toi. Et éloigne de moi les pires comportements. Nul ne peut les éloigner de moi sauf Toi.',
      'My Lord, forgive me and my parents and whoever enters my house believing, and all believing men and women.': 'Seigneur, pardonne-moi, ainsi qu\'à mes parents, à quiconque entre dans ma maison en tant que croyant, et à tous les croyants et croyantes.',
      'O Allah, I ask You for a righteous wife who will be a comfort to my eyes and with whom my eyes are pleased.': 'Ô Allah, je Te demande une épouse pieuse qui sera le réconfort de mes yeux et avec qui mes yeux seront apaisés.',
      'My Lord, make my family and offspring good and protect them from all evil and envy.': 'Seigneur, rends ma famille et ma descendance bonnes et protège-les de tout mal et de toute envie.',
      'In Your name, O Allah, I die and live.': 'En Ton nom, Ô Allah, je meurs et je vis.',
      'All praise is for Allah, who has given us life after death, and to Him is the return.': 'Toute louange est à Allah, qui nous a redonné la vie après la mort, et c\'est vers Lui qu\'est le retour.',
      'I seek refuge in the perfect words of Allah from the evil of what He has created.': 'Je cherche refuge dans les paroles parfaites d\'Allah contre le mal de ce qu\'Il a créé.',
      'Sufficient for us is Allah, and He is the best disposer of affairs.': 'Allah nous suffit, et Il est le meilleur garant.',
      'For severe distress and sorrow': 'Pour la détresse sévère et le chagrin',
      'Prophet\'s dua to dispel anxiety and sadness': 'Douâa du Prophète pour dissiper l\'anxiété et la tristesse',
      'Dua of Prophet Musa - for understanding and knowledge': 'Douâa du Prophète Moussa - pour la compréhension et le savoir',
      'Dua of Sahl ibn Hunayf (may Allah be pleased with him)': 'Douâa de Sahl ibn Hunayf (qu\'Allah soit satisfait de lui)',
      'Dua for studying and memorization': 'Douâa pour l\'étude et la mémorisation',
      'Prophet\'s dua for recovery from illness': 'Douâa du Prophète pour la guérison de la maladie',
      'What to say when visiting the sick': 'Ce qu\'il faut dire en visitant un malade',
      'Traveler\'s dua before departure': 'Douâa du voyageur avant le départ',
      'What to say when boarding transport': 'Ce qu\'il faut dire en montant dans un moyen de transport',
      'Dua for success and divine guidance': 'Douâa pour le succès et la guidance divine',
      'Istikhara dua - for choosing the right path': 'Douâa de l\'Istikhara - pour choisir le bon chemin',
      'Dua upon finishing the Holy Quran': 'Douâa à l\'achèvement du Saint Coran',
      'Dua for provision and sufficiency': 'Douâa pour la provision et la suffisance',
      'Prophet\'s dua for excellent character': 'Douâa du Prophète pour un excellent comportement',
      'Dua for honoring parents': 'Douâa pour honorer ses parents',
      'Dua for a righteous spouse': 'Douâa pour un conjoint pieux',
      'Dua for children\'s righteousness': 'Douâa pour la droiture des enfants',
      'Dua before sleeping': 'Douâa avant de dormir',
      'Dua upon waking from sleep': 'Douâa au réveil',
      'Dua for protection and safety': 'Douâa pour la protection et la sécurité',
      'Dua for reliance and protection': 'Douâa pour la confiance et la protection',
    };

    return frTranslations[englishText.trim()] ?? englishText;
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final isArabic = lang == 'ar';
    
    String cardTitle = widget.duaa.titleEn;
    if (isArabic) {
      cardTitle = widget.duaa.titleAr;
    } else if (lang == 'fr') cardTitle = _translateToFrench(widget.duaa.titleEn); 

    String translatedDuaaText = widget.duaa.duaaEn;
    if (lang == 'fr') translatedDuaaText = _translateToFrench(widget.duaa.duaaEn);

    String benefitText = widget.duaa.benefitEn ?? '';
    if (isArabic && widget.duaa.benefitAr != null) {
      benefitText = widget.duaa.benefitAr!;
    } else if (lang == 'fr' && widget.duaa.benefitEn != null) benefitText = _translateToFrench(widget.duaa.benefitEn!);
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (widget.index * 50).clamp(0, 300)),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * 24, 0),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isExpanded
                    ? const Color(0xFF144D32).withValues(alpha: 0.8)
                    : const Color(0xFF0B3D2E).withValues(alpha: 0.65),
                border: Border.all(
                  color: _isExpanded
                      ? const Color(0xFFD4AF37).withValues(alpha: 0.8)
                      : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                  width: _isExpanded ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _toggleExpand,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            cardTitle, 
                            style: GoogleFonts.elMessiri(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _isExpanded ? Colors.white : const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.expand_more_rounded,
                            color: _isExpanded ? Colors.white : const Color(0xFFD4AF37),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_isExpanded) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.duaa.duaaAr,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.amiri(
                              fontSize: 24,
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
                            textAlign: TextAlign.left,
                            style: GoogleFonts.elMessiri(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.6,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (widget.duaa.benefitAr != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lightbulb_outline, color: Color(0xFFD4AF37), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    lang == 'ar' ? 'الفائدة' : (lang == 'fr' ? 'Bénéfice' : 'Benefit'),
                                    style: GoogleFonts.elMessiri(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD4AF37),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              benefitText, 
                              style: GoogleFonts.elMessiri(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.copy_rounded,
                          label: lang == 'ar' ? 'نسخ' : (lang == 'fr' ? 'Copier' : 'Copy'),
                          onPressed: () => _copyDuaa(lang),
                        ),
                        _buildActionButton(
                          icon: Icons.share_rounded,
                          label: lang == 'ar' ? 'مشاركة' : (lang == 'fr' ? 'Partager' : 'Share'),
                          onPressed: () => _shareDuaa(lang),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: GoogleFonts.elMessiri(fontSize: 16, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: const Color(0xFF0B3D2E),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _copyDuaa(String lang) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(lang == 'ar' ? 'تم نسخ الدعاء' : (lang == 'fr' ? 'Douâa copié' : 'Duaa copied'), style: GoogleFonts.elMessiri()),
      duration: const Duration(milliseconds: 800),
      backgroundColor: const Color(0xFF0B3D2E),
    ));
  }

  void _shareDuaa(String lang) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(lang == 'ar' ? 'تمت مشاركة الدعاء' : (lang == 'fr' ? 'Douâa partagé' : 'Duaa shared'), style: GoogleFonts.elMessiri()),
      duration: const Duration(milliseconds: 800),
      backgroundColor: const Color(0xFF0B3D2E),
    ));
  }
}