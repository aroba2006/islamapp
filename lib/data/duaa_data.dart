class Duaa {
  final String titleAr;
  final String titleEn;
  final String duaaAr;
  final String duaaEn;
  final String? benefitAr;
  final String? benefitEn;

  const Duaa({
    required this.titleAr,
    required this.titleEn,
    required this.duaaAr,
    required this.duaaEn,
    this.benefitAr,
    this.benefitEn,
  });
}

class DuaaCategory {
  final String categoryAr;
  final String categoryEn;
  final List<Duaa> duaas;

  const DuaaCategory({
    required this.categoryAr,
    required this.categoryEn,
    required this.duaas,
  });
}

class DuaaData {
  static const List<DuaaCategory> categories = [
    DuaaCategory(
      categoryAr: 'الهم والكرب',
      categoryEn: 'Worry & Grief',
      duaas: [
        Duaa(
          titleAr: 'دعاء الكرب',
          titleEn: 'Dua for Distress',
          duaaAr: 'لا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
          duaaEn: 'There is no deity except You, exalted are You. Indeed, I have been of the wrongdoers.',
          benefitAr: 'دعاء ذو الكرب والهم - قال النبي ﷺ: دعاء ذي النون',
          benefitEn: 'For severe distress and sorrow',
        ),
        Duaa(
          titleAr: 'دعاء الهم والحزن',
          titleEn: 'Dua for Anxiety & Sorrow',
          duaaAr: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ، وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ',
          duaaEn: 'O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts, and from being overpowered by men.',
          benefitAr: 'دعاء النبي ﷺ لطرد الهم والحزن',
          benefitEn: 'Prophet\'s dua to dispel anxiety and sadness',
        ),
      ],
    ),
    DuaaCategory(
      categoryAr: 'العلم والتعليم',
      categoryEn: 'Knowledge & Education',
      duaas: [
        Duaa(
          titleAr: 'دعاء طلب العلم',
          titleEn: 'Dua for Knowledge',
          duaaAr: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي يَفْقَهُوا قَوْلِي',
          duaaEn: 'My Lord, expand for me my breast and ease for me my task and loosen the knot from my tongue that they may understand my speech.',
          benefitAr: 'دعاء موسى عليه السلام - للفهم والعلم',
          benefitEn: 'Dua of Prophet Musa - for understanding and knowledge',
        ),
        Duaa(
          titleAr: 'دعاء الفهم والتفقه',
          titleEn: 'Dua for Understanding',
          duaaAr: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ فِقْهًا فِي الدِّينِ وَتَرْجُمَةً قَرِيبًا',
          duaaEn: 'O Allah, I ask You for understanding in the religion and immediate success.',
          benefitAr: 'دعاء سهل بن حنيف رضي الله عنه',
          benefitEn: 'Dua of Sahl ibn Hunayf (may Allah be pleased with him)',
        ),
        Duaa(
          titleAr: 'دعاء الحفظ والفهم',
          titleEn: 'Dua for Memorization',
          duaaAr: 'اللَّهُمَّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَأَعِنِّي عَلَى حِفْظِ كِتَابِكَ',
          duaaEn: 'O Allah, expand my chest, ease my matters, and help me memorize Your Book.',
          benefitAr: 'دعاء للمذاكرة والحفظ',
          benefitEn: 'Dua for studying and memorization',
        ),
      ],
    ),
    DuaaCategory(
      categoryAr: 'المرض والشفاء',
      categoryEn: 'Sickness & Healing',
      duaas: [
        Duaa(
          titleAr: 'دعاء الشفاء',
          titleEn: 'Dua for Healing',
          duaaAr: 'اللَّهُمَّ يَا رَبَّ النَّاسِ أَذْهِبْ الْبَاسَ اشْفِ أَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا',
          duaaEn: 'O Lord of the people, remove the harm and cure it. You are the Healer. There is no cure except Your cure, a cure that leaves no illness.',
          benefitAr: 'دعاء النبي ﷺ للشفاء من المرض',
          benefitEn: 'Prophet\'s dua for recovery from illness',
        ),
        Duaa(
          titleAr: 'دعاء العائد للمريض',
          titleEn: 'Dua When Visiting the Sick',
          duaaAr: 'لَا بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ',
          duaaEn: 'No worries, it will be a purification, Allah willing.',
          benefitAr: 'ما يقال عند عيادة المريض',
          benefitEn: 'What to say when visiting the sick',
        ),
      ],
    ),
    DuaaCategory(
      categoryAr: 'السفر والحماية',
      categoryEn: 'Travel & Protection',
      duaas: [
        Duaa(
          titleAr: 'دعاء المسافر',
          titleEn: 'Traveler\'s Dua',
          duaaAr: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ فِي سَفَرِي هَذَا الْبِرَّ وَالتَّقْوَىٰ وَمِنَ الْعَمَلِ مَا تَرْضَىٰ، اللَّهُمَّ هَوِّنْ عَلَيَّ سَفَرِي هَذَا وَاطْوِ عَنِّي بُعْدَهُ',
          duaaEn: 'O Allah, in this journey of mine, I ask You for goodness and piety, and deeds that please You. O Allah, make this journey easy for me and shorten its distance.',
          benefitAr: 'دعاء المسافر قبل الخروج',
          benefitEn: 'Traveler\'s dua before departure',
        ),
        Duaa(
          titleAr: 'أذكار السفر',
          titleEn: 'Travel Remembrances',
          duaaAr: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ',
          duaaEn: 'Exalted is He who has subjected this to us, and we could not have [otherwise] subdued it.',
          benefitAr: 'ما يقال عند ركوب المركبة',
          benefitEn: 'What to say when boarding transport',
        ),
      ],
    ),
    DuaaCategory(
      categoryAr: 'التوفيق والنجاح',
      categoryEn: 'Success & Guidance',
      duaas: [
        Duaa(
          titleAr: 'دعاء التوفيق',
          titleEn: 'Dua for Divine Help',
          duaaAr: 'اللَّهُمَّ وَفِّقْنِي وَلَا تُخَالِفْ بِي، وَوَفِّقْنِي بِرَحْمَتِكَ يَا أَرْحَمَ الرَّاحِمِينَ',
          duaaEn: 'O Allah, grant me success and do not oppose me. Grant me success through Your mercy, O Most Merciful.',
          benefitAr: 'دعاء التوفيق والنجاح',
          benefitEn: 'Dua for success and divine guidance',
        ),
        Duaa(
          titleAr: 'دعاء الاستشارة',
          titleEn: 'Istikhara Dua',
          duaaAr: 'اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ وَتَعْلَمُ وَلَا أَعْلَمُ وَأَنْتَ عَلَّامُ الْغُيُوبِ',
          duaaEn: 'O Allah, I seek Your guidance by virtue of Your knowledge and ability by virtue of Your power, and I ask You for Your immense grace. Surely You have power; I have none. You know; I know not. You are the Knower of hidden things.',
          benefitAr: 'دعاء الاستخارة - لاختيار الخير',
          benefitEn: 'Istikhara dua - for choosing the right path',
        ),
      ],
    ),
    DuaaCategory(
      categoryAr: 'ختم القرآن',
      categoryEn: 'Completing the Quran',
      duaas: [
        Duaa(
          titleAr: 'دعاء ختم القرآن',
          titleEn: 'Dua Upon Completing Quran',
          duaaAr: 'اللَّهُمَّ إِنَّكَ أَنْعَمْتَ عَلَيَّ فِي هَذِهِ السُّورَةِ بِكَلَامِكَ الْكَرِيمِ فَاجْعَلْهُ نُورًا فِي قَلْبِي، وَحِكْمَةً فِي صَدْرِي، وَنُورًا فِي قَبْرِي',
          duaaEn: 'O Allah, You have honored me in this chapter with Your Noble Word, so make it a light in my heart, wisdom in my chest, and light in my grave.',
          benefitAr: 'دعاء ختم القرآن الكريم',
          benefitEn: 'Dua upon finishing the Holy Quran',
        ),
      ],
    ),
    DuaaCategory(
      categoryAr: 'الحياة والرزق',
      categoryEn: 'Life & Sustenance',
      duaas: [
        Duaa(
          titleAr: 'دعاء الرزق',
          titleEn: 'Dua for Sustenance',
          duaaAr: 'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
          duaaEn: 'O Allah, suffice me with what is lawful to protect me from what is forbidden, and make me rich through Your grace, so that I am not in need of anyone but You.',
          benefitAr: 'دعاء الرزق والكفاية',
          benefitEn: 'Dua for provision and sufficiency',
        ),
        Duaa(
          titleAr: 'دعاء حسن الخلق',
          titleEn: 'Dua for Good Character',
          duaaAr: 'اللَّهُمَّ اهْدِنِي لِأَحْسَنِ الْأَخْلَاقِ لَا يَهْدِي لِأَحْسَنِهَا إِلَّا أَنْتَ، وَاصْرِفْ عَنِّي سَيِّئَهَا لَا يَصْرِفُ عَنِّي سَيِّئَهَا إِلَّا أَنْتَ',
          duaaEn: 'O Allah, guide me to the best of manners. None can guide to the best of them except You. And turn away from me the worst of manners. None can turn away the worst of them except You.',
          benefitAr: 'دعاء النبي ﷺ لحسن الخلق',
          benefitEn: 'Prophet\'s dua for excellent character',
        ),
      ],
    ),
    DuaaCategory(
      categoryAr: 'الأسرة والأصدقاء',
      categoryEn: 'Family & Friends',
      duaas: [
        Duaa(
          titleAr: 'دعاء الوالدين',
          titleEn: 'Dua for Parents',
          duaaAr: 'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِمَنْ دَخَلَ بَيْتِيَ مُؤْمِنًا وَلِلْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ',
          duaaEn: 'My Lord, forgive me and my parents and whoever enters my house believing, and all believing men and women.',
          benefitAr: 'دعاء برّ الوالدين',
          benefitEn: 'Dua for honoring parents',
        ),
        Duaa(
          titleAr: 'دعاء الزوجة الصالحة',
          titleEn: 'Dua for a Righteous Spouse',
          duaaAr: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ امْرَأَةً صَالِحَةً تُقَرُّ عَيْنِي وَأُقِرُّ عَيْنَهَا',
          duaaEn: 'O Allah, I ask You for a righteous wife who will be a comfort to my eyes and with whom my eyes are pleased.',
          benefitAr: 'دعاء طلب زوجة صالحة',
          benefitEn: 'Dua for a righteous spouse',
        ),
        Duaa(
          titleAr: 'دعاء الأطفال',
          titleEn: 'Dua for Children',
          duaaAr: 'رَبِّ اجْعَلْ أَهْلِي وَذُرِّيَّتِي خَيْرًا وَاحْفَظْهُمْ مِنْ شَرِّ كُلِّ حَاسِدٍ',
          duaaEn: 'My Lord, make my family and offspring good and protect them from all evil and envy.',
          benefitAr: 'دعاء الدعاء للأطفال بالصلاح',
          benefitEn: 'Dua for children\'s righteousness',
        ),
      ],
    ),
    DuaaCategory(
      categoryAr: 'النوم والراحة',
      categoryEn: 'Sleep & Rest',
      duaas: [
        Duaa(
          titleAr: 'دعاء النوم',
          titleEn: 'Sleep Dua',
          duaaAr: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          duaaEn: 'In Your name, O Allah, I die and live.',
          benefitAr: 'دعاء قبل النوم',
          benefitEn: 'Dua before sleeping',
        ),
        Duaa(
          titleAr: 'دعاء الاستيقاظ',
          titleEn: 'Waking Up Dua',
          duaaAr: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          duaaEn: 'All praise is for Allah, who has given us life after death, and to Him is the return.',
          benefitAr: 'دعاء بعد الاستيقاظ من النوم',
          benefitEn: 'Dua upon waking from sleep',
        ),
      ],
    ),
    DuaaCategory(
      categoryAr: 'الخوف والأمان',
      categoryEn: 'Fear & Security',
      duaas: [
        Duaa(
          titleAr: 'دعاء الخوف',
          titleEn: 'Dua Against Fear',
          duaaAr: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ شَرِّ مَا خَلَقَ',
          duaaEn: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
          benefitAr: 'دعاء الخوف والأمان',
          benefitEn: 'Dua for protection and safety',
        ),
        Duaa(
          titleAr: 'دعاء الحماية',
          titleEn: 'Protection Dua',
          duaaAr: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
          duaaEn: 'Sufficient for us is Allah, and He is the best disposer of affairs.',
          benefitAr: 'دعاء التوكل والحماية',
          benefitEn: 'Dua for reliance and protection',
        ),
      ],
    ),
  ];
}