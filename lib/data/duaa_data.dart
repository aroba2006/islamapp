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

        // ─────────────────────────── NEW CATEGORIES ───────────────────────────

    DuaaCategory(
      categoryAr: 'الصباح والمساء',
      categoryEn: 'Morning & Evening',
      duaas: [
        Duaa(
          titleAr: 'دعاء الصباح',
          titleEn: 'Morning Remembrance',
          duaaAr:
              'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
          duaaEn:
              'We have entered the morning and the dominion belongs to Allah. All praise is for Allah. There is no god but Allah alone, without any partner.',
          benefitAr: 'يُقال عند الصباح من كل يوم',
          benefitEn: 'Recited every morning',
        ),
        Duaa(
          titleAr: 'دعاء المساء',
          titleEn: 'Evening Remembrance',
          duaaAr:
              'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
          duaaEn:
              'We have entered the evening and the dominion belongs to Allah. All praise is for Allah. There is no god but Allah alone, without any partner.',
          benefitAr: 'يُقال عند المساء من كل يوم',
          benefitEn: 'Recited every evening',
        ),
        Duaa(
          titleAr: 'تسبيح الصباح والمساء',
          titleEn: 'Morning & Evening Tasbih',
          duaaAr: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          duaaEn: 'Glory be to Allah and praise be to Him.',
          benefitAr: 'من قالها مئة مرة حُطَّت خطاياه',
          benefitEn:
              'Whoever says it 100 times a day, his sins are wiped away',
        ),
      ],
    ),

    DuaaCategory(
      categoryAr: 'الاستغفار والتوبة',
      categoryEn: 'Forgiveness & Repentance',
      duaas: [
        Duaa(
          titleAr: 'سيد الاستغفار',
          titleEn: 'The Master of Seeking Forgiveness',
          duaaAr:
              'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي',
          duaaEn:
              'O Allah, You are my Lord. There is no god but You. You created me and I am Your servant. I keep Your covenant and promise as much as I am able. I seek refuge in You from the evil I have done. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me.',
          benefitAr: 'من قالها موقناً بها حين يصبح أو يمسي فهو من أهل الجنة',
          benefitEn:
              'Whoever says it with certainty in the morning or evening is among the people of Paradise',
        ),
        Duaa(
          titleAr: 'استغفار النبي ﷺ',
          titleEn: 'Prophet\'s Daily Forgiveness',
          duaaAr:
              'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الْغَفُورُ',
          duaaEn:
              'My Lord, forgive me and accept my repentance. You are the Ever-Relenting, the Most Forgiving.',
          benefitAr: 'كان النبي ﷺ يقولها في المجلس مئة مرة',
          benefitEn:
              'The Prophet ﷺ would say it 100 times in a single gathering',
        ),
        Duaa(
          titleAr: 'استغفار التوبة',
          titleEn: 'Dua of Sincere Repentance',
          duaaAr:
              'أَسْتَغْفِرُ اللَّهَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
          duaaEn:
              'I seek forgiveness from Allah, besides whom there is no god, the Ever-Living, the Sustainer, and I turn to Him in repentance.',
          benefitAr: 'من قالها غُفرت ذنوبه وإن كان فرَّ من الزحف',
          benefitEn:
              'Whoever says it, his sins are forgiven even if he fled from battle',
        ),
      ],
    ),

    DuaaCategory(
      categoryAr: 'رمضان والصيام',
      categoryEn: 'Ramadan & Fasting',
      duaas: [
        Duaa(
          titleAr: 'دعاء رؤية الهلال',
          titleEn: 'Dua Upon Seeing the New Moon',
          duaaAr:
              'اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِالْيُمْنِ وَالْإِيمَانِ، وَالسَّلَامَةِ وَالْإِسْلَامِ، رَبِّي وَرَبُّكَ اللَّهُ',
          duaaEn:
              'O Allah, let this moon appear over us with prosperity, faith, safety, and Islam. My Lord and your Lord is Allah.',
          benefitAr: 'يُقال عند رؤية الهلال',
          benefitEn: 'Recited upon sighting the new crescent',
        ),
        Duaa(
          titleAr: 'دعاء الإفطار',
          titleEn: 'Dua When Breaking the Fast',
          duaaAr:
              'ذَهَبَ الظَّمَأُ، وَابْتَلَّتِ الْعُرُوقُ، وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
          duaaEn:
              'The thirst has gone, the veins are moistened, and the reward is confirmed, Allah willing.',
          benefitAr: 'يُقال بعد الإفطار',
          benefitEn: 'Recited after breaking the fast',
        ),
        Duaa(
          titleAr: 'دعاء ليلة القدر',
          titleEn: 'Dua for Laylat al-Qadr',
          duaaAr:
              'اللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيمٌ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
          duaaEn:
              'O Allah, You are Most Forgiving, Most Generous. You love to forgive, so forgive me.',
          benefitAr: 'علَّمها النبي ﷺ لعائشة رضي الله عنها',
          benefitEn:
              'The Prophet ﷺ taught this dua to Aisha (may Allah be pleased with her)',
        ),
      ],
    ),

    DuaaCategory(
      categoryAr: 'الصلاة والعبادة',
      categoryEn: 'Prayer & Worship',
      duaas: [
        Duaa(
          titleAr: 'دعاء بعد الصلاة',
          titleEn: 'Dua After Prayer',
          duaaAr:
              'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
          duaaEn:
              'O Allah, help me to remember You, to thank You, and to worship You in the best manner.',
          benefitAr: 'وصية النبي ﷺ لمعاذ بن جبل رضي الله عنه',
          benefitEn:
              'The Prophet\'s ﷺ advice to Muadh ibn Jabal (may Allah be pleased with him)',
        ),
        Duaa(
          titleAr: 'دعاء إقامة الصلاة',
          titleEn: 'Dua for Establishing Prayer',
          duaaAr:
              'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِنْ ذُرِّيَّتِي، رَبَّنَا وَتَقَبَّلْ دُعَاءِ',
          duaaEn:
              'My Lord, make me an establisher of prayer, and from my offspring. Our Lord, and accept my supplication.',
          benefitAr: 'من دعاء إبراهيم عليه السلام',
          benefitEn: 'From the dua of Prophet Ibrahim (peace be upon him)',
        ),
        Duaa(
          titleAr: 'دعاء القنوت',
          titleEn: 'Dua of Qunut',
          duaaAr:
              'اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ، وَعَافِنِي فِيمَنْ عَافَيْتَ، وَتَوَلَّنِي فِيمَنْ تَوَلَّيْتَ',
          duaaEn:
              'O Allah, guide me among those You have guided, grant me health among those You have granted health, and protect me among those You have protected.',
          benefitAr: 'يُقال في قنوت الوتر',
          benefitEn: 'Recited during the Qunut of Witr',
        ),
      ],
    ),

    DuaaCategory(
      categoryAr: 'الدخول والخروج من المنزل',
      categoryEn: 'Entering & Leaving Home',
      duaas: [
        Duaa(
          titleAr: 'دعاء دخول المنزل',
          titleEn: 'Dua When Entering Home',
          duaaAr:
              'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا',
          duaaEn:
              'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we rely.',
          benefitAr: 'يُقال عند دخول البيت',
          benefitEn: 'Recited upon entering the house',
        ),
        Duaa(
          titleAr: 'دعاء الخروج من المنزل',
          titleEn: 'Dua When Leaving Home',
          duaaAr:
              'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          duaaEn:
              'In the name of Allah, I place my trust in Allah. There is no might nor power except with Allah.',
          benefitAr: 'يُقال عند الخروج من البيت',
          benefitEn: 'Recited upon leaving the house',
        ),
      ],
    ),

    DuaaCategory(
      categoryAr: 'الطعام والشراب',
      categoryEn: 'Food & Drink',
      duaas: [
        Duaa(
          titleAr: 'دعاء قبل الطعام',
          titleEn: 'Dua Before Eating',
          duaaAr: 'بِسْمِ اللَّهِ',
          duaaEn: 'In the name of Allah.',
          benefitAr: 'وإن نسي في أوله فليقل: بسم الله أوله وآخره',
          benefitEn:
              'If forgotten at the beginning, say: In the name of Allah at its beginning and end',
        ),
        Duaa(
          titleAr: 'دعاء بعد الطعام',
          titleEn: 'Dua After Eating',
          duaaAr:
              'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
          duaaEn:
              'All praise is for Allah who fed me this and provided it for me without any might or power from myself.',
          benefitAr: 'من قالها غُفر له ما تقدم من ذنبه',
          benefitEn:
              'Whoever says it, his previous sins are forgiven',
        ),
      ],
    ),

    DuaaCategory(
      categoryAr: 'الطقس والطبيعة',
      categoryEn: 'Weather & Nature',
      duaas: [
        Duaa(
          titleAr: 'دعاء نزول المطر',
          titleEn: 'Dua When It Rains',
          duaaAr: 'اللَّهُمَّ صَيِّبًا نَافِعًا',
          duaaEn: 'O Allah, (make it) a beneficial downpour.',
          benefitAr: 'يُقال عند نزول المطر',
          benefitEn: 'Recited when rain falls',
        ),
        Duaa(
          titleAr: 'دعاء الريح',
          titleEn: 'Dua When Wind Blows',
          duaaAr:
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا، وَخَيْرَ مَا فِيهَا، وَخَيْرَ مَا أُرْسِلَتْ بِهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا',
          duaaEn:
              'O Allah, I ask You for its good, the good within it, and the good with which it is sent. I seek refuge in You from its evil.',
          benefitAr: 'يُقال عند هبوب الرياح',
          benefitEn: 'Recited when strong winds blow',
        ),
        Duaa(
          titleAr: 'دعاء الرعد',
          titleEn: 'Dua Upon Hearing Thunder',
          duaaAr:
              'سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ وَالْمَلَائِكَةُ مِنْ خِيفَتِهِ',
          duaaEn:
              'Glory be to He whom the thunder glorifies with His praise, and the angels too, out of awe of Him.',
          benefitAr: 'يُقال عند سماع الرعد',
          benefitEn: 'Recited upon hearing thunder',
        ),
      ],
    ),

    DuaaCategory(
      categoryAr: 'الشكر والبركة',
      categoryEn: 'Gratitude & Barakah',
      duaas: [
        Duaa(
          titleAr: 'دعاء الشكر',
          titleEn: 'Dua of Gratitude',
          duaaAr:
              'الْحَمْدُ لِلَّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ',
          duaaEn:
              'All praise is for Allah by whose favour good deeds are perfected.',
          benefitAr: 'يُقال عند رؤية ما يسرّ',
          benefitEn: 'Recited upon seeing something pleasing',
        ),
        Duaa(
          titleAr: 'دعاء البركة في الرزق',
          titleEn: 'Dua for Barakah in Provision',
          duaaAr:
              'اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا، وَقِنَا عَذَابَ النَّارِ',
          duaaEn:
              'O Allah, bless us in what You have provided us, and protect us from the punishment of the Fire.',
          benefitAr: 'دعاء جامع للبركة والوقاية',
          benefitEn: 'A comprehensive dua for blessings and protection',
        ),
        Duaa(
          titleAr: 'دعاء جامع للخير',
          titleEn: 'Comprehensive Dua for Good',
          duaaAr:
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',
          duaaEn:
              'O Allah, I ask You for beneficial knowledge, good provision, and accepted deeds.',
          benefitAr: 'دعاء جامع يجمع خيري الدنيا والآخرة',
          benefitEn:
              'A comprehensive dua gathering the good of this life and the Hereafter',
        ),
      ],
    ),

    DuaaCategory(
      categoryAr: 'الحج والعمرة',
      categoryEn: 'Hajj & Umrah',
      duaas: [
        Duaa(
          titleAr: 'التلبية',
          titleEn: 'The Talbiyah',
          duaaAr:
              'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ',
          duaaEn:
              'Here I am, O Allah, here I am. Here I am, You have no partner, here I am. Verily all praise, grace and sovereignty belong to You. You have no partner.',
          benefitAr: 'شعار الحجاج والمعتمرين',
          benefitEn: 'The chant of pilgrims during Hajj and Umrah',
        ),
        Duaa(
          titleAr: 'دعاء عند الصفا والمروة',
          titleEn: 'Dua at Safa and Marwa',
          duaaAr:
              'اللَّهُمَّ اجْعَلْهُ حَجًّا مَبْرُورًا، وَذَنْبًا مَغْفُورًا، وَسَعْيًا مَشْكُورًا',
          duaaEn:
              'O Allah, make it an accepted Hajj, a forgiven sin, and an appreciated effort.',
          benefitAr: 'يُقال عند السعي بين الصفا والمروة',
          benefitEn: 'Recited during the Sa\'i between Safa and Marwa',
        ),
      ],
    ),
  ];
}