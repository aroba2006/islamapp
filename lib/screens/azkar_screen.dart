import 'package:flutter/material.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart'; 

class _AzkarCategory {
  final String titleAr;
  final String titleEn;
  final String titleFr; 
  final String emoji;
  final Color color;
  final List<_ZikrItem> items;
  const _AzkarCategory({
    required this.titleAr,
    required this.titleEn,
    required this.titleFr,
    required this.emoji,
    required this.color,
    required this.items,
  });
}

class _ZikrItem {
  final String arabic;
  final String transliteration;
  final String translation;
  final String translationFr; // Added French Field
  final int count;
  const _ZikrItem({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.translationFr,
    required this.count,
  });
}

const List<_AzkarCategory> _categories = [
  _AzkarCategory(
    titleAr: 'أذكار الصباح',
    titleEn: 'Morning',
    titleFr: 'Matin',
    emoji: '🌅',
    color: Color(0xFFB8860B),
    items: [
      _ZikrItem(
        arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration: 'Asbahna wa asbahal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay\'in qadir.',
        translation: 'We have entered the morning and sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without partner.',
        translationFr: 'Nous sommes au matin et la royauté appartient à Allah. Toute louange est à Allah. Nul n\'est digne d\'être adoré en dehors d\'Allah, seul et sans associé.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
        transliteration: 'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu wa ilaykan-nushur.',
        translation: 'O Allah, by You we enter the morning and by You we enter the evening. By You we live and by You we die, and unto You is the resurrection.',
        translationFr: 'Ô Allah, par Toi nous sommes au matin, et par Toi nous sommes au soir. Par Toi nous vivons, et par Toi nous mourons, et vers Toi est la résurrection.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        transliteration: 'Subhan Allahi wa bihamdih.',
        translation: 'Glory be to Allah and praise Him.',
        translationFr: 'Gloire et louange à Allah.',
        count: 100,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ',
        transliteration: 'Allahumma anta rabbi, la ilaha illa ant, khalaqtani wa ana abduk, wa ana ala ahdika wa wa\'dika mastata\'t.',
        translation: 'O Allah, You are my Lord. None has the right to be worshipped except You. You created me and I am Your servant.',
        translationFr: 'Ô Allah, Tu es mon Seigneur. Il n\'y a de divinité que Toi. Tu m\'as créé et je suis Ton serviteur.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار المساء',
    titleEn: 'Evening',
    titleFr: 'Soir',
    emoji: '🌙',
    color: Color(0xFF4A3B8C),
    items: [
      _ZikrItem(
        arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        transliteration: 'Amsayna wa amsal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah.',
        translation: 'We have entered the evening and sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone without partner.',
        translationFr: 'Nous sommes au soir et la royauté appartient à Allah. Toute louange est à Allah. Nul n\'est digne d\'être adoré en dehors d\'Allah, seul et sans associé.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
        transliteration: 'A\'udhu bikalimatillahit-tammati min sharri ma khalaq.',
        translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
        translationFr: 'Je cherche refuge auprès des paroles parfaites d\'Allah contre le mal de ce qu\'Il a créé.',
        count: 3,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي',
        transliteration: 'Allahumma afini fi badani, Allahumma afini fi sam\'i, Allahumma afini fi basari.',
        translation: 'O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight.',
        translationFr: 'Ô Allah, accorde la santé à mon corps. Ô Allah, accorde la santé à mon ouïe. Ô Allah, accorde la santé à ma vue.',
        count: 3,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الصلاة',
    titleEn: 'After Salah',
    titleFr: 'Après la Prière',
    emoji: '🕌',
    color: Color(0xFF1B5E3F),
    items: [
      _ZikrItem(
        arabic: 'أَسْتَغْفِرُ اللَّهَ',
        transliteration: 'Astaghfirullah.',
        translation: 'I seek forgiveness from Allah.',
        translationFr: 'Je demande pardon à Allah.',
        count: 3,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
        transliteration: 'Allahumma antas-salam wa minkas-salam, tabarakta ya dhal-jalali wal-ikram.',
        translation: 'O Allah, You are Peace and from You comes peace. Blessed are You, O Possessor of glory and honour.',
        translationFr: 'Ô Allah, Tu es la Paix et de Toi vient la paix. Béni sois-Tu, Ô Détenteur de la majesté et de la générosité.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'سُبْحَانَ اللَّهِ',
        transliteration: 'Subhan Allah.',
        translation: 'Glory be to Allah.',
        translationFr: 'Gloire à Allah.',
        count: 33,
      ),
      _ZikrItem(
        arabic: 'الْحَمْدُ لِلَّهِ',
        transliteration: 'Alhamdu lillah.',
        translation: 'All praise be to Allah.',
        translationFr: 'Louange à Allah.',
        count: 33,
      ),
      _ZikrItem(
        arabic: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allahu Akbar.',
        translation: 'Allah is the Greatest.',
        translationFr: 'Allah est le plus Grand.',
        count: 33,
      ),
      _ZikrItem(
        arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration: 'La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay\'in qadir.',
        translation: 'None has the right to be worshipped except Allah, alone without partner. His is the dominion and His is the praise, and He is capable of all things.',
        translationFr: 'Nul n\'est en droit d\'être adoré qu\'Allah, seul et sans associé. A Lui la royauté, à Lui la louange, et Il est Omnipotent.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار النوم',
    titleEn: 'Before Sleep',
    titleFr: 'Avant de Dormir',
    emoji: '😴',
    color: Color(0xFF1A3A6B),
    items: [
      _ZikrItem(
        arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        transliteration: 'Bismika Allahumma amutu wa ahya.',
        translation: 'In Your name, O Allah, I die and I live.',
        translationFr: 'En Ton nom, Ô Allah, je meurs et je vis.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
        transliteration: 'Allahumma qini adhabaka yawma tab\'athu ibadak.',
        translation: 'O Allah, protect me from Your punishment on the Day You resurrect Your servants.',
        translationFr: 'Ô Allah, protège-moi de Ton châtiment le jour où Tu ressusciteras Tes serviteurs.',
        count: 3,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ بِاسْمِكَ أَحْيَا وَأَمُوتُ',
        transliteration: 'Allahumma bismika ahya wa amut.',
        translation: 'O Allah, in Your name I live and I die.',
        translationFr: 'Ô Allah, en Ton nom je vis et je meurs.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ',
        transliteration: 'Subhanakal-lahumma wa bihamdik, ashhadu an la ilaha illa ant, astaghfiruka wa atubu ilayk.',
        translation: 'Glory and praise be to You, O Allah. I bear witness that there is none worthy of worship except You. I seek Your forgiveness and repent to You.',
        translationFr: 'Gloire et louange à Toi, Ô Allah. J\'atteste qu\'il n\'y a de divinité que Toi. Je demande Ton pardon et me repens à Toi.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار اليوم',
    titleEn: 'Daily',
    titleFr: 'Quotidien',
    emoji: '☀️',
    color: Color(0xFF8B3A10),
    items: [
      _ZikrItem(
        arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration: 'La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay\'in qadir.',
        translation: 'None has the right to be worshipped except Allah, alone without partner. His is the dominion and His is the praise, and He is capable of all things.',
        translationFr: 'Nul n\'est en droit d\'être adoré qu\'Allah, seul et sans associé. A Lui la royauté, à Lui la louange, et Il est Omnipotent.',
        count: 100,
      ),
      _ZikrItem(
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
        transliteration: 'Subhan Allahi wa bihamdih, subhan Allahil-Azim.',
        translation: 'Glory be to Allah and praise Him. Glory be to Allah the Almighty.',
        translationFr: 'Gloire et louange à Allah. Gloire à Allah l\'Immense.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
        transliteration: 'Hasbiyallahu la ilaha illa huwa, alayhi tawakkaltu wa huwa rabbul-arshil-azim.',
        translation: 'Allah is sufficient for me. None has the right to be worshipped except Him, in Him I put my trust, and He is the Lord of the Mighty Throne.',
        translationFr: 'Allah me suffit. Nulle divinité digne d\'être adorée sauf Lui. En Lui je place ma confiance, et Il est le Seigneur du Trône immense.',
        count: 7,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار المسجد',
    titleEn: 'Mosque',
    titleFr: 'La Mosquée',
    emoji: '🕋',
    color: Color(0xFF15615E),
    items: [
      _ZikrItem(
        arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
        transliteration: 'Allahumm-aftah li abwaba rahmatik.',
        translation: 'O Allah, open for me the gates of Your mercy.',
        translationFr: 'Ô Allah, ouvre-moi les portes de Ta miséricorde.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
        transliteration: 'Allahumma inni as\'aluka min fadlik.',
        translation: 'O Allah, I ask of You from Your bounty.',
        translationFr: 'Ô Allah, je Te demande de Ta grâce.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'أَعُوذُ بِاللَّهِ الْعَظِيمِ، وَبِوَجْهِهِ الْكَرِيمِ، وَسُلْطَانِهِ الْقَدِيمِ، مِنَ الشَّيْطَانِ الرَّجِيمِ',
        transliteration: 'A\'udhu billahil-azim, wa biwajhihil-karim, wa sultanihil-qadim, minash-shaytanir-rajim.',
        translation: 'I seek refuge in Allah the Almighty, and in His noble face, and in His eternal power, from the accursed devil.',
        translationFr: 'Je cherche refuge auprès d\'Allah l\'Immense, de Son noble visage et de Son pouvoir éternel, contre le diable maudit.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الحياة',
    titleEn: 'Life',
    titleFr: 'La Vie',
    emoji: '🌿',
    color: Color(0xFF2E6B34),
    items: [
      _ZikrItem(
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah.',
        translation: 'In the name of Allah.',
        translationFr: 'Au nom d\'Allah.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'الْحَمْدُ لِلَّهِ',
        transliteration: 'Alhamdu lillah.',
        translation: 'All praise be to Allah.',
        translationFr: 'Louange à Allah.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ',
        transliteration: 'Inna lillahi wa inna ilayhi raji\'un.',
        translation: 'Indeed, to Allah we belong and to Him we shall return.',
        translationFr: 'C\'est à Allah que nous appartenons et c\'est vers Lui que nous retournerons.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'مَا شَاءَ اللَّهُ لَا قُوَّةَ إِلَّا بِاللَّهِ',
        transliteration: 'Ma sha\'a Allah, la quwwata illa billah.',
        translation: 'Whatever Allah wills. There is no power except with Allah.',
        translationFr: 'Telle est la volonté d\'Allah. Il n\'y a de force que par Allah.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ',
        transliteration: 'Subhan Allahi wa bihamdih, adada khalqih.',
        translation: 'Glory be to Allah and praise Him, to the number of His creation.',
        translationFr: 'Gloire et louange à Allah, au nombre de Ses créatures.',
        count: 3,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الطعام',
    titleEn: 'Eating',
    titleFr: 'Les Repas',
    emoji: '🍽️',
    color: Color(0xFF7A4F2A),
    items: [
      _ZikrItem(
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah.',
        translation: 'In the name of Allah. (Say before eating)',
        translationFr: 'Au nom d\'Allah. (À dire avant de manger)',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
        transliteration: 'Alhamdu lillahil-ladhi at\'amana wa saqana wa ja\'alana muslimin.',
        translation: 'All praise is for Allah who fed us and gave us drink and made us Muslims.',
        translationFr: 'Louange à Allah qui nous a nourris, abreuvés et fait de nous des musulmans.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ',
        transliteration: 'Bismillahi awwalahu wa akhirah.',
        translation: 'In the name of Allah at its beginning and its end. (If you forget to say it at the start)',
        translationFr: 'Au nom d\'Allah, à son début et à sa fin. (Si on oublie au début)',
        count: 1,
      ),
    ],
  ),
];

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        l10n.azkarTitle, 
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeCtrl,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.05,
                    ),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 250 + (index * 40).clamp(0, 400)),
                        tween: Tween(begin: 0, end: 1),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: Transform.scale(scale: 0.88 + 0.12 * value, child: child),
                        ),
                        child: _CategoryCard(
                          category: cat,
                          lang: lang,
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 420),
                              pageBuilder: (_, animation, __) =>
                                  _AzkarDetailScreen(category: cat, lang: lang),
                              transitionsBuilder: (_, animation, __, child) {
                                final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
                                return SlideTransition(
                                  position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved),
                                  child: FadeTransition(opacity: curved, child: child),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
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

class _CategoryCard extends StatefulWidget {
  final _AzkarCategory category;
  final String lang;
  final VoidCallback onTap;
  const _CategoryCard({required this.category, required this.lang, required this.onTap});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.94),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cat.color, Color.lerp(cat.color, Colors.black, 0.3)!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
            boxShadow: [
              BoxShadow(
                color: cat.color.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cat.emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(height: 8),
              Text(
                widget.lang == 'ar' ? cat.titleAr : (widget.lang == 'fr' ? cat.titleFr : cat.titleEn),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              if (widget.lang == 'ar')
                Text(
                  cat.titleEn,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 11,
                  ),
                ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${cat.items.length} ${widget.lang == 'ar' ? 'أذكار' : (widget.lang == 'fr' ? 'Adhkar' : 'Azkar')}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10,
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

class _AzkarDetailScreen extends StatefulWidget {
  final _AzkarCategory category;
  final String lang;
  const _AzkarDetailScreen({required this.category, required this.lang});

  @override
  State<_AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<_AzkarDetailScreen> {
  late List<int> _counts;
  bool _showTransliteration = true;

  @override
  void initState() {
    super.initState();
    _counts = List.filled(widget.category.items.length, 0);
  }

  void _increment(int index) {
    final max = widget.category.items[index].count;
    setState(() {
      if (_counts[index] < max) _counts[index]++;
    });
  }

  void _reset(int index) => setState(() => _counts[index] = 0);

  void _resetAll() => setState(() => _counts = List.filled(widget.category.items.length, 0));

  bool get _allDone => _counts.asMap().entries.every((e) => e.value >= widget.category.items[e.key].count);

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(cat.emoji, style: const TextStyle(fontSize: 22)),
                          Text(
                            widget.lang == 'ar' ? cat.titleAr : (widget.lang == 'fr' ? cat.titleFr : cat.titleEn),
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _showTransliteration ? Icons.translate : Icons.translate_outlined,
                        color: _showTransliteration ? const Color(0xFFD4AF37) : Colors.white54,
                        size: 22,
                      ),
                      onPressed: () => setState(() => _showTransliteration = !_showTransliteration),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_counts.where((c) => c > 0).length} / ${cat.items.length}',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                        ),
                        if (_allDone)
                          Text(
                            widget.lang == 'ar' ? '✓ اكتمل' : (widget.lang == 'fr' ? '✓ Terminé' : '✓ Done'),
                            style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: cat.items.isEmpty ? 0 : _counts.asMap().entries.where((e) => e.value >= cat.items[e.key].count).length / cat.items.length,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: cat.items.length,
                  itemBuilder: (context, index) {
                    final zikr = cat.items[index];
                    final progress = _counts[index];
                    final isDone = progress >= zikr.count;

                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 200 + (index * 60).clamp(0, 500)),
                      tween: Tween(begin: 0, end: 1),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(offset: Offset(0, (1 - value) * 16), child: child),
                      ),
                      child: _ZikrCard(
                        zikr: zikr,
                        progress: progress,
                        isDone: isDone,
                        showTransliteration: _showTransliteration,
                        lang: widget.lang,
                        onTap: () => _increment(index),
                        onReset: () => _reset(index),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: TextButton.icon(
                  onPressed: _resetAll,
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white54, size: 18),
                  label: Text(
                    widget.lang == 'ar' ? 'إعادة ضبط الكل' : (widget.lang == 'fr' ? 'Tout réinitialiser' : 'Reset All'),
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
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

class _ZikrCard extends StatelessWidget {
  final _ZikrItem zikr;
  final int progress;
  final bool isDone;
  final bool showTransliteration;
  final String lang;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const _ZikrCard({
    required this.zikr,
    required this.progress,
    required this.isDone,
    required this.showTransliteration,
    required this.lang,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: isDone ? const Color(0xFF1B5E3F).withValues(alpha: 0.95) : const Color(0xFF144D32),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone ? const Color(0xFFD4AF37).withValues(alpha: 0.8) : const Color(0xFFD4AF37).withValues(alpha: 0.18),
            width: isDone ? 1.5 : 1,
          ),
          boxShadow: isDone
              ? [BoxShadow(color: const Color(0xFF1B5E3F).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                zikr.arabic,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: isDone ? const Color(0xFFD4AF37) : Colors.white,
                  fontSize: 17,
                  height: 1.9,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (showTransliteration) ...[
                const SizedBox(height: 8),
                Text(
                  zikr.transliteration,
                  style: TextStyle(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.75),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                // Renders the correct translation based on language!
                lang == 'fr' ? zikr.translationFr : zikr.translation,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: progress > 0 ? onReset : null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 15,
                          color: progress > 0 ? Colors.white54 : Colors.white24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          lang == 'ar' ? 'إعادة' : (lang == 'fr' ? 'Réinit.' : 'Reset'),
                          style: TextStyle(
                            color: progress > 0 ? Colors.white54 : Colors.white24,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDone ? const Color(0xFFD4AF37) : const Color(0xFF0B3D2E),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: isDone ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$progress / ${zikr.count}',
                            style: TextStyle(
                              color: isDone ? const Color(0xFF0B3D2E) : const Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isDone ? Icons.check_circle_rounded : Icons.touch_app_rounded,
                            size: 16,
                            color: isDone ? const Color(0xFF0B3D2E) : const Color(0xFFD4AF37).withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}