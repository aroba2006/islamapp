import 'package:flutter/material.dart';
import '../widgets/islamic_pattern_background.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class _AzkarCategory {
  final String titleAr;
  final String titleEn;
  final String emoji;
  final Color color;
  final List<_ZikrItem> items;
  const _AzkarCategory({
    required this.titleAr,
    required this.titleEn,
    required this.emoji,
    required this.color,
    required this.items,
  });
}

class _ZikrItem {
  final String arabic;
  final String transliteration;
  final String translation;
  final int count;
  const _ZikrItem({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.count,
  });
}

// ── Azkar data ────────────────────────────────────────────────────────────────

const List<_AzkarCategory> _categories = [
  _AzkarCategory(
    titleAr: 'أذكار الصباح',
    titleEn: 'Morning',
    emoji: '🌅',
    color: Color(0xFFB8860B),
    items: [
      _ZikrItem(
        arabic:
            'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration:
            'Asbahna wa asbahal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay\'in qadir.',
        translation:
            'We have entered the morning and sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without partner.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
        transliteration:
            'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu wa ilaykan-nushur.',
        translation:
            'O Allah, by You we enter the morning and by You we enter the evening. By You we live and by You we die, and unto You is the resurrection.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        transliteration: 'Subhan Allahi wa bihamdih.',
        translation: 'Glory be to Allah and praise Him.',
        count: 100,
      ),
      _ZikrItem(
        arabic:
            'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ',
        transliteration:
            'Allahumma anta rabbi, la ilaha illa ant, khalaqtani wa ana abduk, wa ana ala ahdika wa wa\'dika mastata\'t.',
        translation:
            'O Allah, You are my Lord. None has the right to be worshipped except You. You created me and I am Your servant.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار المساء',
    titleEn: 'Evening',
    emoji: '🌙',
    color: Color(0xFF4A3B8C),
    items: [
      _ZikrItem(
        arabic:
            'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        transliteration:
            'Amsayna wa amsal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah.',
        translation:
            'We have entered the evening and sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone without partner.',
        count: 1,
      ),
      _ZikrItem(
        arabic:
            'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
        transliteration:
            'A\'udhu bikalimatillahit-tammati min sharri ma khalaq.',
        translation:
            'I seek refuge in the perfect words of Allah from the evil of what He has created.',
        count: 3,
      ),
      _ZikrItem(
        arabic:
            'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي',
        transliteration:
            'Allahumma afini fi badani, Allahumma afini fi sam\'i, Allahumma afini fi basari.',
        translation:
            'O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight.',
        count: 3,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الصلاة',
    titleEn: 'After Salah',
    emoji: '🕌',
    color: Color(0xFF1B5E3F),
    items: [
      _ZikrItem(
        arabic: 'أَسْتَغْفِرُ اللَّهَ',
        transliteration: 'Astaghfirullah.',
        translation: 'I seek forgiveness from Allah.',
        count: 3,
      ),
      _ZikrItem(
        arabic:
            'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
        transliteration:
            'Allahumma antas-salam wa minkas-salam, tabarakta ya dhal-jalali wal-ikram.',
        translation:
            'O Allah, You are Peace and from You comes peace. Blessed are You, O Possessor of glory and honour.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'سُبْحَانَ اللَّهِ',
        transliteration: 'Subhan Allah.',
        translation: 'Glory be to Allah.',
        count: 33,
      ),
      _ZikrItem(
        arabic: 'الْحَمْدُ لِلَّهِ',
        transliteration: 'Alhamdu lillah.',
        translation: 'All praise be to Allah.',
        count: 33,
      ),
      _ZikrItem(
        arabic: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allahu Akbar.',
        translation: 'Allah is the Greatest.',
        count: 33,
      ),
      _ZikrItem(
        arabic:
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration:
            'La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay\'in qadir.',
        translation:
            'None has the right to be worshipped except Allah, alone without partner. His is the dominion and His is the praise, and He is capable of all things.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار النوم',
    titleEn: 'Before Sleep',
    emoji: '😴',
    color: Color(0xFF1A3A6B),
    items: [
      _ZikrItem(
        arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        transliteration: 'Bismika Allahumma amutu wa ahya.',
        translation: 'In Your name, O Allah, I die and I live.',
        count: 1,
      ),
      _ZikrItem(
        arabic:
            'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
        transliteration:
            'Allahumma qini adhabaka yawma tab\'athu ibadak.',
        translation:
            'O Allah, protect me from Your punishment on the Day You resurrect Your servants.',
        count: 3,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ بِاسْمِكَ أَحْيَا وَأَمُوتُ',
        transliteration: 'Allahumma bismika ahya wa amut.',
        translation: 'O Allah, in Your name I live and I die.',
        count: 1,
      ),
      _ZikrItem(
        arabic:
            'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ',
        transliteration:
            'Subhanakal-lahumma wa bihamdik, ashhadu an la ilaha illa ant, astaghfiruka wa atubu ilayk.',
        translation:
            'Glory and praise be to You, O Allah. I bear witness that there is none worthy of worship except You. I seek Your forgiveness and repent to You.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار اليوم',
    titleEn: 'Daily',
    emoji: '☀️',
    color: Color(0xFF8B3A10),
    items: [
      _ZikrItem(
        arabic:
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration:
            'La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay\'in qadir.',
        translation:
            'None has the right to be worshipped except Allah, alone without partner. His is the dominion and His is the praise, and He is capable of all things.',
        count: 100,
      ),
      _ZikrItem(
        arabic:
            'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
        transliteration:
            'Subhan Allahi wa bihamdih, subhan Allahil-Azim.',
        translation:
            'Glory be to Allah and praise Him. Glory be to Allah the Almighty.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
        transliteration: 'Hasbiyallahu la ilaha illa huwa, alayhi tawakkaltu wa huwa rabbul-arshil-azim.',
        translation: 'Allah is sufficient for me. None has the right to be worshipped except Him, in Him I put my trust, and He is the Lord of the Mighty Throne.',
        count: 7,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار المسجد',
    titleEn: 'Mosque',
    emoji: '🕋',
    color: Color(0xFF15615E),
    items: [
      _ZikrItem(
        arabic:
            'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
        transliteration: 'Allahumm-aftah li abwaba rahmatik.',
        translation:
            'O Allah, open for me the gates of Your mercy.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
        transliteration: 'Allahumma inni as\'aluka min fadlik.',
        translation: 'O Allah, I ask of You from Your bounty.',
        count: 1,
      ),
      _ZikrItem(
        arabic:
            'أَعُوذُ بِاللَّهِ الْعَظِيمِ، وَبِوَجْهِهِ الْكَرِيمِ، وَسُلْطَانِهِ الْقَدِيمِ، مِنَ الشَّيْطَانِ الرَّجِيمِ',
        transliteration:
            'A\'udhu billahil-azim, wa biwajhihil-karim, wa sultanihil-qadim, minash-shaytanir-rajim.',
        translation:
            'I seek refuge in Allah the Almighty, and in His noble face, and in His eternal power, from the accursed devil.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الحياة',
    titleEn: 'Life',
    emoji: '🌿',
    color: Color(0xFF2E6B34),
    items: [
      _ZikrItem(
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah.',
        translation: 'In the name of Allah.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'الْحَمْدُ لِلَّهِ',
        transliteration: 'Alhamdu lillah.',
        translation: 'All praise be to Allah.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ',
        transliteration: 'Inna lillahi wa inna ilayhi raji\'un.',
        translation:
            'Indeed, to Allah we belong and to Him we shall return.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'مَا شَاءَ اللَّهُ لَا قُوَّةَ إِلَّا بِاللَّهِ',
        transliteration: 'Ma sha\'a Allah, la quwwata illa billah.',
        translation:
            'Whatever Allah wills. There is no power except with Allah.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ',
        transliteration: 'Subhan Allahi wa bihamdih, adada khalqih.',
        translation:
            'Glory be to Allah and praise Him, to the number of His creation.',
        count: 3,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الطعام',
    titleEn: 'Eating',
    emoji: '🍽️',
    color: Color(0xFF7A4F2A),
    items: [
      _ZikrItem(
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah.',
        translation: 'In the name of Allah. (Say before eating)',
        count: 1,
      ),
      _ZikrItem(
        arabic:
            'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
        transliteration:
            'Alhamdu lillahil-ladhi at\'amana wa saqana wa ja\'alana muslimin.',
        translation:
            'All praise is for Allah who fed us and gave us drink and made us Muslims.',
        count: 1,
      ),
      _ZikrItem(
        arabic:
            'بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ',
        transliteration: 'Bismillahi awwalahu wa akhirah.',
        translation:
            'In the name of Allah at its beginning and its end. (If you forget to say it at the start)',
        count: 1,
      ),
    ],
  ),
];

// ── AzkarScreen ───────────────────────────────────────────────────────────────

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
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'الأذكار',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Spacer to balance the back button
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Category grid
              Expanded(
                child: FadeTransition(
                  opacity: _fadeCtrl,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.05,
                    ),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return TweenAnimationBuilder<double>(
                        duration: Duration(
                            milliseconds: 250 + (index * 40).clamp(0, 400)),
                        tween: Tween(begin: 0, end: 1),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: Transform.scale(
                              scale: 0.88 + 0.12 * value, child: child),
                        ),
                        child: _CategoryCard(
                          category: cat,
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 420),
                              pageBuilder: (_, animation, __) =>
                                  _AzkarDetailScreen(category: cat),
                              transitionsBuilder: (_, animation, __, child) {
                                final curved = CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic);
                                return SlideTransition(
                                  position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero)
                                      .animate(curved),
                                  child: FadeTransition(
                                      opacity: curved, child: child),
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

// ── Category card ─────────────────────────────────────────────────────────────

class _CategoryCard extends StatefulWidget {
  final _AzkarCategory category;
  final VoidCallback onTap;
  const _CategoryCard({required this.category, required this.onTap});

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
              colors: [
                cat.color,
                Color.lerp(cat.color, Colors.black, 0.3)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
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
                cat.titleAr,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${cat.items.length} أذكار',
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

// ── Detail screen ─────────────────────────────────────────────────────────────

class _AzkarDetailScreen extends StatefulWidget {
  final _AzkarCategory category;
  const _AzkarDetailScreen({required this.category});

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

  void _resetAll() {
    setState(() {
      _counts = List.filled(widget.category.items.length, 0);
    });
  }

  bool get _allDone =>
      _counts.asMap().entries.every(
        (e) => e.value >= widget.category.items[e.key].count,
      );

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(cat.emoji,
                              style: const TextStyle(fontSize: 22)),
                          Text(
                            cat.titleAr,
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Transliteration toggle
                    Tooltip(
                      message: 'Toggle transliteration',
                      child: IconButton(
                        icon: Icon(
                          _showTransliteration
                              ? Icons.translate
                              : Icons.translate_outlined,
                          color: _showTransliteration
                              ? const Color(0xFFD4AF37)
                              : Colors.white54,
                          size: 22,
                        ),
                        onPressed: () => setState(
                            () => _showTransliteration = !_showTransliteration),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_counts.where((c) => c > 0).length} / ${cat.items.length}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                        if (_allDone)
                          const Text(
                            '✓ اكتمل',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: cat.items.isEmpty
                            ? 0
                            : _counts
                                    .asMap()
                                    .entries
                                    .where((e) =>
                                        e.value >=
                                        cat.items[e.key].count)
                                    .length /
                                cat.items.length,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFD4AF37)),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),

              // Zikr list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: cat.items.length,
                  itemBuilder: (context, index) {
                    final zikr = cat.items[index];
                    final progress = _counts[index];
                    final isDone = progress >= zikr.count;

                    return TweenAnimationBuilder<double>(
                      duration:
                          Duration(milliseconds: 200 + (index * 60).clamp(0, 500)),
                      tween: Tween(begin: 0, end: 1),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child:
                            Transform.translate(offset: Offset(0, (1 - value) * 16), child: child),
                      ),
                      child: _ZikrCard(
                        zikr: zikr,
                        progress: progress,
                        isDone: isDone,
                        showTransliteration: _showTransliteration,
                        onTap: () => _increment(index),
                        onReset: () => _reset(index),
                      ),
                    );
                  },
                ),
              ),

              // Reset all button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: TextButton.icon(
                  onPressed: _resetAll,
                  icon: const Icon(Icons.refresh_rounded,
                      color: Colors.white54, size: 18),
                  label: const Text(
                    'إعادة ضبط الكل',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
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

// ── Zikr card ─────────────────────────────────────────────────────────────────

class _ZikrCard extends StatelessWidget {
  final _ZikrItem zikr;
  final int progress;
  final bool isDone;
  final bool showTransliteration;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const _ZikrCard({
    required this.zikr,
    required this.progress,
    required this.isDone,
    required this.showTransliteration,
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
          color: isDone
              ? const Color(0xFF1B5E3F).withValues(alpha: 0.95)
              : const Color(0xFF144D32),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone
                ? const Color(0xFFD4AF37).withValues(alpha: 0.8)
                : const Color(0xFFD4AF37).withValues(alpha: 0.18),
            width: isDone ? 1.5 : 1,
          ),
          boxShadow: isDone
              ? [
                  BoxShadow(
                    color: const Color(0xFF1B5E3F).withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Arabic text — right-aligned, larger
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
                zikr.translation,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 14),

              // Counter row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reset
                  GestureDetector(
                    onTap: progress > 0 ? onReset : null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 15,
                          color: progress > 0
                              ? Colors.white54
                              : Colors.white24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'إعادة',
                          style: TextStyle(
                            color: progress > 0
                                ? Colors.white54
                                : Colors.white24,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Count badge — tap target
                  GestureDetector(
                    onTap: onTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDone
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF0B3D2E),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isDone
                              ? const Color(0xFFD4AF37)
                              : const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$progress / ${zikr.count}',
                            style: TextStyle(
                              color: isDone
                                  ? const Color(0xFF0B3D2E)
                                  : const Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isDone
                                ? Icons.check_circle_rounded
                                : Icons.touch_app_rounded,
                            size: 16,
                            color: isDone
                                ? const Color(0xFF0B3D2E)
                                : const Color(0xFFD4AF37)
                                    .withValues(alpha: 0.7),
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