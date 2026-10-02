// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------
class TimelineEvent {
  final String year;
  final String event;
  const TimelineEvent({required this.year, required this.event});
}

class QuranicMention {
  final String surahName;
  final String surahArabic;
  final int surahNumber;
  final int verseNumber;
  final String verseText;
  final String verseTranslation;
  const QuranicMention({
    required this.surahName,
    required this.surahArabic,
    required this.surahNumber,
    required this.verseNumber,
    required this.verseText,
    required this.verseTranslation,
  });
}

class ProphetBiography {
  final String id;
  final String name;
  final String arabicName;
  final String title;
  final String speciality;
  final String lifespan;
  final String birthPlace;
  final String deathPlace;
  final String tribe;
  final String quranicName;
  final int ageAtDeath;
  final int mentionedInSurahs;
  final bool isMajor;
  final String imageUrl;
  final String description;
  final String fullDescription;
  final List<String> keyAchievements;
  final List<String> miracles;
  final List<String> lessons;
  final List<TimelineEvent> timeline;
  final List<QuranicMention> quranicMentions;
  final List<String> relatedProphetIds;

  const ProphetBiography({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.title,
    required this.speciality,
    required this.lifespan,
    required this.birthPlace,
    required this.deathPlace,
    this.tribe = '',
    this.quranicName = '',
    this.ageAtDeath = 0,
    required this.mentionedInSurahs,
    this.isMajor = false,
    this.imageUrl = '',
    required this.description,
    required this.fullDescription,
    required this.keyAchievements,
    required this.miracles,
    required this.lessons,
    required this.timeline,
    required this.quranicMentions,
    required this.relatedProphetIds,
  });

  String get initials {
    if (arabicName.isNotEmpty) return arabicName[0];
    if (name.isNotEmpty) return name[0];
    return '?';
  }
}

// ---------------------------------------------------------------------------
// Service
// ---------------------------------------------------------------------------
class ProphetBiographyService {
  static final ProphetBiographyService _instance = ProphetBiographyService._internal();
  factory ProphetBiographyService() => _instance;
  ProphetBiographyService._internal();

  static String _s(Map<String, dynamic> m, String key, String lang) {
    final v = m[key];
    if (v == null) return '';
    if (v is Map) return (v[lang] ?? v['en'] ?? '') as String;
    return v as String;
  }

  static List<String> _sl(Map<String, dynamic> m, String key, String lang) {
    final v = m[key];
    if (v == null) return [];
    if (v is Map) {
      final list = v[lang] ?? v['en'] ?? const [];
      return List<String>.from(list);
    }
    return const [];
  }

  static List<Map<String, dynamic>> _sml(Map<String, dynamic> m, String key, String lang) {
    final v = m[key];
    if (v == null) return [];
    if (v is Map) {
      final list = v[lang] ?? v['en'] ?? const [];
      return List<Map<String, dynamic>>.from(list);
    }
    return const [];
  }

  List<ProphetBiography> getAllProphets(String langCode) =>
      _prophetsRaw.map((raw) => _build(raw, langCode)).toList();

  ProphetBiography? getProphetById(String id, String langCode) {
    final raw = _prophetsRaw.where((p) => p['id'] == id).firstOrNull;
    if (raw == null) return null;
    return _build(raw, langCode);
  }

  List<ProphetBiography> searchProphets(String query, String langCode) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return getAllProphets(langCode);
    return getAllProphets(langCode).where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.arabicName.contains(query) ||
          p.title.toLowerCase().contains(q) ||
          p.speciality.toLowerCase().contains(q) ||
          p.quranicName.toLowerCase().contains(q);
    }).toList();
  }

  List<ProphetBiography> getRelatedProphets(ProphetBiography prophet, String langCode) {
    final all = getAllProphets(langCode);
    return prophet.relatedProphetIds
        .map((id) => all.where((p) => p.id == id).firstOrNull)
        .whereType<ProphetBiography>()
        .toList();
  }

  ProphetBiography _build(Map<String, dynamic> raw, String lang) {
    return ProphetBiography(
      id: raw['id'] as String,
      name: _s(raw, 'name', lang),
      arabicName: raw['arabicName'] as String? ?? '',
      title: _s(raw, 'title', lang),
      speciality: _s(raw, 'speciality', lang),
      lifespan: _s(raw, 'lifespan', lang),
      birthPlace: _s(raw, 'birthPlace', lang),
      deathPlace: _s(raw, 'deathPlace', lang),
      tribe: _s(raw, 'tribe', lang),
      quranicName: _s(raw, 'quranicName', lang),
      ageAtDeath: raw['ageAtDeath'] as int? ?? 0,
      mentionedInSurahs: raw['mentionedInSurahs'] as int? ?? 0,
      isMajor: raw['isMajor'] as bool? ?? false,
      imageUrl: raw['imageUrl'] as String? ?? '',
      description: _s(raw, 'description', lang),
      fullDescription: _s(raw, 'fullDescription', lang),
      keyAchievements: _sl(raw, 'keyAchievements', lang),
      miracles: _sl(raw, 'miracles', lang),
      lessons: _sl(raw, 'lessons', lang),
      timeline: _sml(raw, 'timeline', lang)
          .map((e) => TimelineEvent(
                year: e['year'] as String? ?? '',
                event: e['event'] as String? ?? '',
              ))
          .toList(),
      quranicMentions: _sml(raw, 'quranicMentions', lang)
          .map((e) => QuranicMention(
                surahName: e['surahName'] as String? ?? '',
                surahArabic: e['surahArabic'] as String? ?? '',
                surahNumber: e['surahNumber'] as int? ?? 0,
                verseNumber: e['verseNumber'] as int? ?? 0,
                verseText: e['verseText'] as String? ?? '',
                verseTranslation: e['verseTranslation'] as String? ?? '',
              ))
          .toList(),
      relatedProphetIds: List<String>.from(raw['relatedProphetIds'] as List? ?? const []),
    );
  }

  // =========================================================================
  // RAW DATA (Merged Old + New Enhanced Content)
  // =========================================================================
  static final List<Map<String, dynamic>> _prophetsRaw = [
    // ==================== MUHAMMAD ====================
    {
      'id': 'muhammad',
      'name': {'en': 'Prophet Muhammad', 'ar': 'النبي محمد', 'fr': 'Prophète Muhammad'},
      'arabicName': 'محمد ﷺ',
      'title': {'en': 'The Final Messenger', 'ar': 'خاتم الأنبياء والمرسلين', 'fr': 'Le Dernier Messager'},
      'speciality': {'en': 'The Seal of the Prophets - Final messenger of Allah', 'ar': 'خاتم الأنبياء - آخر رسول من الله', 'fr': 'Le Sceau des Prophètes - Dernier messager d\'Allah'},
      'lifespan': {'en': '570 - 632 CE', 'ar': '570 - 632 م', 'fr': '570 - 632 È.C.'},
      'birthPlace': {'en': 'Mecca', 'ar': 'مكة المكرمة', 'fr': 'La Mecque'},
      'deathPlace': {'en': 'Medina', 'ar': 'المدينة المنورة', 'fr': 'Médine'},
      'tribe': {'en': 'Quraysh', 'ar': 'قريش', 'fr': 'Quraysh'},
      'quranicName': {'en': 'Muhammad / Ahmad', 'ar': 'محمد / أحمد', 'fr': 'Muhammad / Ahmad'},
      'ageAtDeath': 63,
      'mentionedInSurahs': 4,
      'isMajor': true,
      'imageUrl': 'assets/images/prophets/muhammad.png',
      'description': {
        'en': 'The final prophet of Allah, sent as a mercy to all the worlds, who received the Quran.',
        'ar': 'خاتم أنبياء الله، أُرسل رحمة للعالمين، وتلقى القرآن.',
        'fr': "Le dernier prophète d'Allah, envoyé comme miséricorde pour l'univers, qui reçut le Coran.",
      },
      'fullDescription': {
        'en': 'Early Life & Background:\nBorn in Mecca in the Year of the Elephant (570 CE), Prophet Muhammad (peace be upon him) was orphaned at a young age. Raised by his grandfather Abdul Muttalib and later his uncle Abu Talib, he became known throughout Mecca for his impeccable honesty, earning the titles Al-Amin (The Trustworthy) and As-Sadiq (The Truthful).\n\nProphethood & Revelation:\nAt the age of 40, while seeking spiritual retreat in the Cave of Hira, he received the first revelation of the Quran through the Angel Jibreel (Gabriel). For 13 years in Mecca, he faced severe persecution, physical abuse, and social boycotts from the Quraysh elite as he tirelessly called people to monotheism (Tawhid), social justice, and moral uprightness.\n\nMigration & Establishment:\nIn 622 CE, following divine instruction, he migrated to Medina (the Hijra), an event that marks the beginning of the Islamic calendar. In Medina, he established a just and unified Islamic society, bringing together warring tribes under a groundbreaking constitution of peace.\n\nLegacy & Passing:\nOver 23 years, the complete Quran was revealed. Before his passing in 632 CE, he performed the Farewell Pilgrimage, delivering a timeless sermon emphasizing equality, human rights, and piety. He left behind the Quran and his Sunnah, completing the religion of Islam as the final messenger to mankind.',
        'ar': 'النشأة والخلفية:\nولد النبي محمد (صلى الله عليه وسلم) في مكة في عام الفيل (570 م) يتيماً. نشأ في رعاية جده عبد المطلب ثم عمه أبي طالب. عُرف في مكة بأمانته المطلقة وصدقه، حتى لُقب بـ "الصادق الأمين". قبل النبوة، عمل راعياً للغنم ثم تاجراً، وبنى سمعة لا مثيل لها في النزاهة.\n\nالنبوة ونزول الوحي:\nفي سن الأربعين، وأثناء اعتكافه في غار حراء للعبادة والتأمل، نزل عليه الوحي لأول مرة عن طريق الملاك جبريل. كان هذا الحدث العظيم بداية لرسالته النبوية. طوال 13 عاماً في مكة، واجه اضطهاداً شديداً وأذى جسدياً ومقاطعة اجتماعية من سادة قريش، بينما كان يدعو الناس بلا كلل إلى التوحيد والعدالة الاجتماعية والأخلاق الكريمة.\n\nالهجرة وبناء الدولة:\nفي عام 622 م، وبأمر إلهي لتجنب مؤامرة اغتياله، هاجر إلى المدينة المنورة (يثرب)، وهو الحدث الذي يمثل بداية التقويم الهجري. في المدينة، أسس مجتمعاً إسلامياً عادلاً وموحداً، وجمع بين القبائل المتناحرة تحت دستور سلام غير مسبوق. أثبت قيادة فذة كرجل دولة، وقاضٍ، ومعلم، وقائد عسكري يدافع عن المجتمع المسلم الناشئ.\n\nالإرث والوفاة:\nعلى مدار 23 عاماً، اكتمل نزول القرآن الكريم ليكون دليلاً شاملاً للبشرية. قبل وفاته في عام 632 م، أدى حجة الوداع وألقى خطبة تاريخية أكدت على المساواة وحقوق الإنسان والتقوى. ترك وراءه القرآن الكريم وسنته النبوية الشريفة، مُكملاً رسالة الإسلام كخاتم للأنبياء والمرسلين.',
        'fr': 'Jeunesse et Origines:\nNé à La Mecque l\'Année de l\'Éléphant (570 È.C.), le Prophète Muhammad (paix soit sur lui) est devenu orphelin très jeune. Élevé par son grand-père puis son oncle, il fut connu pour son honnêteté irréprochable, gagnant les titres d\'Al-Amin (Le Digne de Confiance) et As-Sadiq (Le Véridique).\n\nProphétie et Révélation:\nÀ l\'âge de 40 ans, lors d\'une retraite spirituelle dans la grotte de Hira, il reçut la première révélation du Coran via l\'Ange Jibril (Gabriel). Pendant 13 ans à La Mecque, il fit face à de sévères persécutions tout en appelant inlassablement au monothéisme (Tawhid) et à la justice sociale.\n\nMigration et Établissement:\nEn 622 È.C., il émigra vers Médine (l\'Hégire), marquant le début du calendrier islamique. À Médine, il établit une société islamique juste et unifiée, rassemblant des tribus en guerre sous une constitution de paix sans précédent.\n\nHéritage et Décès:\nSur 23 ans, le Coran complet fut révélé. Avant son décès en 632 È.C., il accomplit le Pèlerinage d\'Adieu, délivrant un sermon intemporel sur l\'égalité et les droits humains. Il laissa derrière lui le Coran et sa Sunnah, achevant la religion de l\'Islam en tant que dernier messager de l\'humanité.',
      },
      'keyAchievements': {
        'en': ['Received the complete Quran over 23 years', 'Established the Islamic state in Medina', 'United the Arabian tribes under Islam', 'Set the example for Islamic life through Sunnah', 'Performed the Farewell Hajj'],
        'ar': ['تلقى القرآن الكريم كاملاً على مدار 23 عاماً', 'أسس الدولة الإسلامية الأولى في المدينة المنورة', 'وحد القبائل العربية تحت راية الإسلام', 'أرسى دعائم الحياة الإسلامية من خلال السنة النبوية', 'أدى حجة الوداع ووضع خطبة حقوق الإنسان'],
        'fr': ['A reçu le Coran complet sur 23 ans', 'A établi l\'État islamique à Médine', 'A unifié les tribus arabes sous l\'Islam', 'A établi l\'exemple de la vie islamique par la Sunnah', 'A accompli le Hajj d\'Adieu'],
      },
      'miracles': {
        'en': ['The Quran — the greatest and everlasting miracle of all time.', 'The Isra and Mi\'raj — the night journey to Jerusalem and ascent to the heavens.', 'Splitting of the moon as a sign requested by the Quraysh.', 'Water flowing from between his fingers to quench his army.', 'Food multiplying to feed large crowds.', 'Trees and stones greeting him.'],
        'ar': ['القرآن — أعظم معجزة خالدة في التاريخ.', 'الإسراء والمعراج — الرحلة الليلية إلى القدس والصعود إلى السماء.', 'انشقاق القمر آية طلبتها قريش.', 'الماء يتفجر من بين أصابعه ليسقي جيشه.', 'تكثير الطعام لإطعام الحشود.', 'سلام الشجر والحجر عليه.'],
        'fr': ['Le Coran — le plus grand et éternel miracle de tous les temps.', 'Al-Isra et Al-Mi\'raj — le voyage nocturne à Jérusalem et l\'ascension aux cieux.', 'Le fendage de la lune comme signe demandé par Quraysh.', 'L\'eau jaillissant entre ses doigts pour désaltérer son armée.', 'La multiplication de la nourriture pour nourrir de grandes foules.', 'Les arbres et les pierres le saluaient.'],
      },
      'lessons': {
        'en': ['The final and complete message of Allah to humanity.', 'Mercy to all creation — even to enemies.', 'Patience and perseverance in the face of hardship.', 'Excellent character is the foundation of the message.', 'Trust in Allah\'s plan, even when the path seems unclear.', 'His life (Sunnah) is the practical application of the Quran.'],
        'ar': ['رسالة الله النهائية والكاملة للبشرية.', 'رحمة بكل الخلق — حتى الأعداء.', 'الصبر والثبات في مواجهة الشدائد.', 'حسن الخلق أساس الرسالة.', 'الثقة بتدبير الله حتى وإن خفي الطريق.', 'سيرته (السنة) هي التطبيق العملي للقرآن.'],
        'fr': ['Le message final et complet d\'Allah à l\'humanité.', 'Miséricorde pour toute la création — même envers les ennemis.', 'Patience et persévérance face à l\'épreuve.', 'Un caractère excellent est le fondement du message.', 'Confiance dans le plan d\'Allah, même quand le chemin semble incertain.', 'Sa vie (Sunnah) est l\'application pratique du Coran.'],
      },
      'timeline': {
        'en': [
          {'year': '571 CE', 'event': 'Born in Makkah in the Year of the Elephant.'},
          {'year': 'Age 6', 'event': 'Becomes an orphan; raised by grandfather then uncle.'},
          {'year': 'Age 25', 'event': 'Marries Khadijah bint Khuwaylid.'},
          {'year': 'Age 40', 'event': 'Receives the first revelation in the cave of Hira.'},
          {'year': '13 years', 'event': 'Calls Makkah to Islam; faces severe persecution.'},
          {'year': '622 CE', 'event': 'Hijrah to Madinah; establishes the first Muslim state.'},
          {'year': '630 CE', 'event': 'Peaceful conquest of Makkah.'},
          {'year': '632 CE', 'event': 'Passes away in Madinah at the age of 63.'},
        ],
        'ar': [
          {'year': '٥٧١ م', 'event': 'يُولد في مكة عام الفيل.'},
          {'year': 'سن ٦', 'event': 'يُيتم ويربيه جده ثم عمه.'},
          {'year': 'سن ٢٥', 'event': 'يتزوج خديجة بنت خويلد.'},
          {'year': 'سن ٤٠', 'event': 'يتلقى الوحي الأول في غار حراء.'},
          {'year': '١٣ سنة', 'event': 'يدعو مكة للإسلام ويواجه الاضطهاد.'},
          {'year': '٦٢٢ م', 'event': 'يهاجر إلى المدينة ويؤسس أول دولة إسلامية.'},
          {'year': '٦٣٠ م', 'event': 'فتح مكة السلمي.'},
          {'year': '٦٣٢ م', 'event': 'يتوفى في المدينة عن ٦٣ سنة.'},
        ],
        'fr': [
          {'year': '571 apr. J.-C.', 'event': 'Né à La Mecque l\'Année de l\'Éléphant.'},
          {'year': '6 ans', 'event': 'Devient orphelin ; élevé par son grand-père puis son oncle.'},
          {'year': '25 ans', 'event': 'Épouse Khadijah bint Khuwaylid.'},
          {'year': '40 ans', 'event': 'Reçoit la première révélation dans la grotte de Hira.'},
          {'year': '13 ans', 'event': 'Appelle La Mecque à l\'Islam ; affronte de sévères persécutions.'},
          {'year': '622 apr. J.-C.', 'event': 'Hégire à Médine ; établit le premier État musulman.'},
          {'year': '630 apr. J.-C.', 'event': 'Conquête pacifique de La Mecque.'},
          {'year': '632 apr. J.-C.', 'event': 'Décède à Médine à l\'âge de 63 ans.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'Al-Ahzab', 'surahArabic': 'الأحزاب', 'surahNumber': 33, 'verseNumber': 40, 'verseText': 'مَّا كَانَ مُحَمَّدٌ أَبَا أَحَدٍ مِّن رِّجَالِكُمْ وَلَٰكِن رَّسُولَ اللَّهِ وَخَاتَمَ النَّبِيِّينَ', 'verseTranslation': 'Muhammad is not the father of any of your men, but he is the Messenger of Allah and the last of the prophets.'},
          {'surahName': 'Al-Anbiya', 'surahArabic': 'الأنبياء', 'surahNumber': 21, 'verseNumber': 107, 'verseText': 'وَمَا أَرْسَلْنَاكَ إِلَّا رَحْمَةً لِّلْعَالَمِينَ', 'verseTranslation': 'And We have not sent you, [O Muhammad], except as a mercy to the worlds.'},
        ],
        'ar': [
          {'surahName': 'الأحزاب', 'surahArabic': 'الأحزاب', 'surahNumber': 33, 'verseNumber': 40, 'verseText': 'مَّا كَانَ مُحَمَّدٌ أَبَا أَحَدٍ مِّن رِّجَالِكُمْ وَلَٰكِن رَّسُولَ اللَّهِ وَخَاتَمَ النَّبِيِّينَ', 'verseTranslation': 'ما كان محمد أبا أحد من رجالكم ولكن رسول الله وخاتم النبيين.'},
          {'surahName': 'الأنبياء', 'surahArabic': 'الأنبياء', 'surahNumber': 21, 'verseNumber': 107, 'verseText': 'وَمَا أَرْسَلْنَاكَ إِلَّا رَحْمَةً لِّلْعَالَمِينَ', 'verseTranslation': 'وما أرسلناك إلا رحمة للعالمين.'},
        ],
        'fr': [
          {'surahName': 'Al-Ahzab', 'surahArabic': 'الأحزاب', 'surahNumber': 33, 'verseNumber': 40, 'verseText': 'مَّا كَانَ مُحَمَّدٌ أَبَا أَحَدٍ مِّن رِّجَالِكُمْ وَلَٰكِن رَّسُولَ اللَّهِ وَخَاتَمَ النَّبِيِّينَ', 'verseTranslation': 'Muhammad n\'est le père d\'aucun de vos hommes, mais il est le Messager d\'Allah et le dernier des prophètes.'},
          {'surahName': 'Al-Anbiya', 'surahArabic': 'الأنبياء', 'surahNumber': 21, 'verseNumber': 107, 'verseText': 'وَمَا أَرْسَلْنَاكَ إِلَّا رَحْمَةً لِّلْعَالَمِينَ', 'verseTranslation': 'Et Nous ne t\'avons envoyé que comme miséricorde pour les mondes.'},
        ],
      },
      'relatedProphetIds': ['isa', 'ibrahim', 'musa', 'ismail'],
    },

    // ==================== IBRAHIM ====================
    {
      'id': 'ibrahim',
      'name': {'en': 'Prophet Ibrahim', 'ar': 'النبي إبراهيم', 'fr': 'Prophète Ibrahim'},
      'arabicName': 'إبراهيم',
      'title': {'en': 'The Friend of Allah', 'ar': 'خليل الله', 'fr': 'L\'Ami d\'Allah'},
      'speciality': {'en': 'Friend of Allah - Built the Kaaba', 'ar': 'خليل الله - باني الكعبة وأبو الأنبياء', 'fr': 'Ami d\'Allah - Bâtisseur de la Kaaba'},
      'lifespan': {'en': 'Approx. 2165 - 2040 BCE', 'ar': 'حوالي 2165 - 2040 قبل الميلاد', 'fr': 'Env. 2165 - 2040 av. J.-C.'},
      'birthPlace': {'en': 'Ur of the Chaldees', 'ar': 'أور (العراق القديم)', 'fr': 'Ur des Chaldéens'},
      'deathPlace': {'en': 'Canaan', 'ar': 'أرض كنعان (فلسطين)', 'fr': 'Canaan'},
      'tribe': {'en': '', 'ar': '', 'fr': ''},
      'quranicName': {'en': 'Ibrahim', 'ar': 'إبراهيم', 'fr': 'Ibrahim'},
      'ageAtDeath': 200,
      'mentionedInSurahs': 25,
      'isMajor': true,
      'imageUrl': 'assets/images/prophets/ibrahim.png',
      'description': {
        'en': 'The friend of Allah, who smashed idols, survived the fire, and built the Kaaba with his son Ismail.',
        'ar': 'خليل الله، حطم الأصنام ونجا من النار وبنى الكعبة مع ابنه إسماعيل.',
        'fr': "L'ami d'Allah, qui brisa les idoles, survécut au feu et bâtit la Kaaba avec son fils Ismail.",
      },
      'fullDescription': {
        'en': 'Early Life & Background:\nProphet Ibrahim (Abraham) was born in a society deeply rooted in idolatry and polytheism. Despite his father Azar being a renowned sculptor of idols, Ibrahim was blessed with innate reasoning and divine guidance from a young age. He rejected the worship of celestial bodies and statues, recognizing that the true Creator must be eternal.\n\nProphetic Mission & Trials:\nHe dedicated his life to calling his people to the absolute oneness of Allah (Tawhid). When he boldly destroyed their temple idols, he was sentenced to be cast into a blazing fire by King Nimrod. However, Allah miraculously commanded the fire to be cool and peaceful for him, saving him entirely.\n\nThe Ultimate Sacrifice & Legacy:\nHis greatest test came years later when Allah commanded him in a dream to sacrifice his beloved son Ismail. Both father and son submitted willingly. Just as he was about to fulfill the command, Allah replaced Ismail with a ram, establishing the tradition of Udhiyah and Hajj. Along with Ismail, he later rebuilt the Kaaba.\n\nStatus in Islam:\nRevered as "Khalil-ullah" (The Friend of Allah) and the patriarch of monotheism, his profound submission makes him one of the greatest prophets in Islam.',
        'ar': 'النشأة والخلفية:\nولد النبي إبراهيم عليه السلام في مجتمع غارق في عبادة الأصنام وتعدد الآلهة. بالرغم من أن والده (أو عمه) آزر كان نحاتاً شهيراً للأصنام، إلا أن الله وهب إبراهيم العقل والفطرة السليمة منذ صغره. رفض عبادة الكواكب والتماثيل، وأدرك من خلال التأمل أن الخالق الحقيقي يجب أن يكون أبدياً لا يزول.\n\nالرسالة النبوية والابتلاءات:\nكرس حياته لدعوة قومه إلى التوحيد المطلق لله. عندما قام بشجاعة بتحطيم أصنام معبدهم ليثبت لهم عجزها، حُكم عليه بالإلقاء في نار عظيمة بأمر من الملك الطاغية النمرود. لكن الله أمر النار بمعجزة أن تكون برداً وسلاماً عليه. بعد ذلك، واجه إبراهيم سلسلة من الابتلاءات الشاقة، منها الأمر بترك زوجته هاجر وابنه الرضيع إسماعيل في وادٍ غير ذي زرع في مكة.\n\nالتضحية العظمى والإرث:\nجاء أعظم ابتلاء له بعد سنوات عندما أمره الله في رؤيا أن يذبح ابنه الحبيب إسماعيل الذي جاءه بعد شوق طويل. استسلم الأب والابن طواعية لأمر الله. وفي لحظة التنفيذ، فداه الله بكبش عظيم، مما أسس شعيرة الأضحية ومناسك الحج. قام لاحقاً مع ابنه إسماعيل برفع قواعد الكعبة المشرفة.\n\nمكانته في الإسلام:\nيُبجل في الإسلام بلقب "خليل الله"، وهو أبو الأنبياء. استسلامه العميق وإيمانه الراسخ جعله من أعظم الأنبياء (أولو العزم). وقد أمر القرآن المسلمين باتباع "ملة إبراهيم حنيفاً".',
        'fr': 'Jeunesse et Origines:\nLe Prophète Ibrahim (Abraham) est né dans une société profondément polythéiste. Bien que son père soit un célèbre sculpteur d\'idoles, Ibrahim rejeta l\'adoration des corps célestes et des statues, reconnaissant que le véritable Créateur doit être éternel.\n\nMission Prophétique et Épreuves:\nIl consacra sa vie à appeler son peuple à l\'unicité absolue d\'Allah. Lorsqu\'il détruisit leurs idoles, il fut condamné à être jeté dans un feu ardent par le roi Nimrod. Cependant, Allah ordonna miraculeusement au feu d\'être fraîcheur et paix pour lui.\n\nLe Sacrifice Ultime et Héritage:\nSon plus grand test fut lorsqu\'Allah lui ordonna en rêve de sacrifier son fils bien-aimé Ismail. Tous deux se soumirent. Juste avant d\'accomplir l\'acte, Allah remplaça Ismail par un bélier, établissant la tradition du sacrifice (Udhiyah) et du Hajj. Il reconstruisit plus tard la Kaaba avec Ismail.\n\nStatut en Islam:\nVénéré comme "Khalil-ullah" (L\'Ami d\'Allah) et le patriarche du monothéisme, sa soumission profonde fait de lui l\'un des plus grands prophètes.',
      },
      'keyAchievements': {
        'en': ['Called people to monotheism', 'Built the Kaaba with his son Ismail', 'Established the tradition of Hajj', 'Demonstrated perfect submission to Allah', 'Passed all of Allah\'s trials'],
        'ar': ['دعا قومه للتوحيد في مجتمع وثني', 'بنى الكعبة المشرفة مع ابنه إسماعيل', 'أرسى مناسك الحج', 'أظهر استسلاماً مطلقاً لأمر الله في قصة الذبح', 'اجتاز جميع الابتلاءات الإلهية بنجاح باهر'],
        'fr': ['A appelé au monothéisme dans une société polythéiste', 'A construit la Kaaba avec son fils Ismail', 'A établi la tradition du Hajj', 'A démontré une soumission parfaite à Allah', 'A réussi toutes les épreuves divines'],
      },
      'miracles': {
        'en': ['The fire became cool and safe — a direct command from Allah.', 'The spring of Zamzam gushed forth in a barren valley for infant Ismail.', 'The ram sent from Paradise to ransom Ismail.', 'Birds that Ibrahim called came back to life by Allah\'s permission.'],
        'ar': ['النار أصبحت برداً وسلاماً بأمر مباشر من الله.', 'بئر زمزم تفجرت في وادٍ غير ذي زرع للرضيع إسماعيل.', 'الكبش أُنزل من الجنة فداءً لإسماعيل.', 'الطيور التي دعاها إبراهيم عادت للحياة بإذن الله.'],
        'fr': ['Le feu devint frais et sûr — un ordre direct d\'Allah.', 'La source de Zamzam jaillit dans une vallée aride pour le petit Ismail.', 'Le bélier envoyé du Paradis pour racheter Ismail.', 'Les oiseaux qu\'Ibrahim appela revinrent à la vie par permission d\'Allah.'],
      },
      'lessons': {
        'en': ['True faith comes from reflection and sincere search for truth.', 'Standing for truth may cost everything, but Allah protects His servants.', 'Migration for the sake of Allah opens doors of blessing.', 'Complete trust in Allah, even when He asks what seems impossible.', 'A father\'s love for Allah must come before every other love.'],
        'ar': ['الإيمان الحقيقي يأتي من التأمل والبحث الصادق عن الحق.', 'الثبات على الحق قد يُكلف كل شيء، لكن الله يحمي عباده.', 'الهجرة في سبيل الله تفتح أبواب البركة.', 'التوكل الكامل على الله حتى فيما يبدو مستحيلاً.', 'محبة الله تتقدم على كل محبة أخرى.'],
        'fr': ['La vraie foi vient de la réflexion et de la recherche sincère de la vérité.', 'Tenir pour la vérité peut tout coûter, mais Allah protège Ses serviteurs.', 'L\'émigration pour Allah ouvre les portes de la bénédiction.', 'Confiance totale en Allah, même quand Il demande ce qui semble impossible.', 'L\'amour d\'Allah doit passer avant tout autre amour.'],
      },
      'timeline': {
        'en': [
          {'year': 'Youth', 'event': 'Reflects on the stars, moon and sun; discovers Tawheed.'},
          {'year': 'Da\'wah', 'event': 'Calls his father and people to abandon idols.'},
          {'year': 'Confrontation', 'event': 'Smashes the idols; thrown into a great fire.'},
          {'year': 'Miracle', 'event': 'Allah commands the fire to be cool and safe.'},
          {'year': 'Migration', 'event': 'Migrates to Sham, then to Egypt, then to Makkah.'},
          {'year': 'Test', 'event': 'Commanded to sacrifice Ismail; both pass the test.'},
          {'year': 'Kaaba', 'event': 'Builds the Kaaba with Ismail as the first house of worship.'},
          {'year': '~ 200 years', 'event': 'Passes away in Hebron, Palestine.'},
        ],
        'ar': [
          {'year': 'شبابه', 'event': 'يتأمل النجوم والقمر والشمس فيكتشف التوحيد.'},
          {'year': 'الدعوة', 'event': 'يدعو أباه وقومه لترك الأصنام.'},
          {'year': 'المواجهة', 'event': 'يحطم الأصنام، فيُلقى في نار عظيمة.'},
          {'year': 'المعجزة', 'event': 'يأمر الله النار أن تكون برداً وسلاماً.'},
          {'year': 'الهجرة', 'event': 'يهاجر إلى الشام ثم مصر ثم مكة.'},
          {'year': 'الاختبار', 'event': 'يُؤمر بذبح إسماعيل، فينجح الأب والابن.'},
          {'year': 'الكعبة', 'event': 'يبني الكعبة مع إسماعيل أول بيت للعبادة.'},
          {'year': 'نحو ٢٠٠ سنة', 'event': 'يتوفى في الخليل بفلسطين.'},
        ],
        'fr': [
          {'year': 'Jeunesse', 'event': 'Réfléchit aux étoiles, à la lune et au soleil ; découvre le Tawhid.'},
          {'year': 'Da\'wah', 'event': 'Appelle son père et son peuple à abandonner les idoles.'},
          {'year': 'Confrontation', 'event': 'Brise les idoles ; jeté dans un grand feu.'},
          {'year': 'Miracle', 'event': 'Allah ordonne au feu d\'être frais et sûr.'},
          {'year': 'Migration', 'event': 'Émigre au Cham, puis en Égypte, puis à La Mecque.'},
          {'year': 'Épreuve', 'event': 'Reçoit l\'ordre de sacrifier Ismail ; tous deux réussissent.'},
          {'year': 'Kaaba', 'event': 'Bâtit la Kaaba avec Ismail comme première maison de culte.'},
          {'year': '~ 200 ans', 'event': 'Décède à Hébron, en Palestine.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'Al-Baqarah', 'surahArabic': 'البقرة', 'surahNumber': 2, 'verseNumber': 124, 'verseText': 'وَإِذِ ابْتَلَىٰ إِبْرَاهِيمَ رَبُّهُ بِكَلِمَاتٍ فَأَتَمَّهُنَّ', 'verseTranslation': 'And when Ibrahim was tested by his Lord with commands, he fulfilled them.'},
        ],
        'ar': [
          {'surahName': 'البقرة', 'surahArabic': 'البقرة', 'surahNumber': 2, 'verseNumber': 124, 'verseText': 'وَإِذِ ابْتَلَىٰ إِبْرَاهِيمَ رَبُّهُ بِكَلِمَاتٍ فَأَتَمَّهُنَّ', 'verseTranslation': 'وإذ ابتلى إبراهيم ربه بكلمات فأتمهن.'},
        ],
        'fr': [
          {'surahName': 'Al-Baqarah', 'surahArabic': 'البقرة', 'surahNumber': 2, 'verseNumber': 124, 'verseText': 'وَإِذِ ابْتَلَىٰ إِبْرَاهِيمَ رَبُّهُ بِكَلِمَاتٍ فَأَتَمَّهُنَّ', 'verseTranslation': 'Et quand Ibrahim fut éprouvé par son Seigneur par certains commandements, et qu\'il les accomplit.'},
        ],
      },
      'relatedProphetIds': ['ismail', 'ishaq', 'yaqub', 'yusuf', 'muhammad'],
    },

    // ==================== MUSA ====================
    {
      'id': 'musa',
      'name': {'en': 'Prophet Musa', 'ar': 'النبي موسى', 'fr': 'Prophète Moussa'},
      'arabicName': 'موسى',
      'title': {'en': 'The Interlocutor', 'ar': 'كليم الله', 'fr': 'L\'Interlocuteur d\'Allah'},
      'speciality': {'en': 'Spoke directly with Allah', 'ar': 'كليم الله - من أولي العزم من الرسل', 'fr': 'L\'Interlocuteur - A parlé directement avec Allah'},
      'lifespan': {'en': 'Approx. 1393 - 1273 BCE', 'ar': 'حوالي 1393 - 1273 قبل الميلاد', 'fr': 'Env. 1393 - 1273 av. J.-C.'},
      'birthPlace': {'en': 'Egypt', 'ar': 'مصر', 'fr': 'Égypte'},
      'deathPlace': {'en': 'Mount Sinai area', 'ar': 'منطقة جبل الطور (سيناء)', 'fr': 'Mont Sinaï'},
      'tribe': {'en': 'Bani Israel', 'ar': 'بني إسرائيل', 'fr': "Banu Isra'il"},
      'quranicName': {'en': 'Musa', 'ar': 'موسى', 'fr': 'Musa'},
      'ageAtDeath': 120,
      'mentionedInSurahs': 36,
      'isMajor': true,
      'imageUrl': 'assets/images/prophets/musa.png',
      'description': {
        'en': 'The one who spoke to Allah, delivered Bani Israel from Pharaoh, and received the Torah.',
        'ar': 'من كلمه الله، أنجى بني إسرائيل من فرعون، وأُعطي التوراة.',
        'fr': "Celui qui parla à Allah, délivra les Banu Isra'il de Pharaon et reçut la Torah.",
      },
      'fullDescription': {
        'en': 'Birth & Early Life:\nProphet Musa (Moses) was born in Egypt during a brutal era when the Pharaoh ordered the execution of newborn Israelite boys. His mother was divinely inspired to place him in a basket on the Nile. Miraculously, he was adopted by Pharaoh\'s own righteous wife, Asiya, allowing him to be raised in the royal palace.\n\nProphethood & The Divine Call:\nAfter fleeing to Midian for several years, Musa experienced a profound divine encounter at Mount Tur (Sinai). Allah spoke directly to him from a burning bush, granting him prophethood and monumental miracles—such as his staff turning into a serpent. He was commanded to return to Egypt to liberate the Children of Israel.\n\nConfrontation & Exodus:\nMusa fiercely confronted Pharaoh\'s tyranny and defeated his greatest magicians. When Pharaoh rejected multiple plagues sent as warnings, Musa led the Israelites in a midnight exodus. Pursued by Pharaoh\'s army, Allah parted the Red Sea, saving Musa while drowning the tyrannical ruler.\n\nGuidance & Legacy:\nMusa received the Tawrat (Torah) containing divine laws on Mount Sinai. Known as "Kalim-ullah" (The One who spoke directly to Allah), he remains the most frequently mentioned prophet in the entire Quran.',
        'ar': 'الولادة والنشأة:\nولد النبي موسى عليه السلام في مصر خلال فترة قاسية أمر فيها فرعون بقتل كل المواليد الذكور من بني إسرائيل. لإنقاذه، أوحى الله إلى أمه أن تضعه في تابوت وتلقيه في نهر النيل. وبمعجزة إلهية، وصل التابوت إلى قصر فرعون، حيث التقطته زوجة فرعون الصالحة (آسية) وربته كابن لها، مما أتاح له النشوء في القصر الملكي.\n\nالنبوة والنداء الإلهي:\nبعد فراره إلى مدين لعدة سنوات إثر حادثة قتل خطأ، شهد موسى تجربة إلهية عظيمة عند جبل الطور (سيناء). كلمه الله تعالى مباشرة من شجرة مشتعلة، واصطفاه للنبوة ومنحه معجزات كبرى، كتحول عصاه إلى ثعبان ضخم وخروج يده بيضاء من غير سوء. أمره الله بالعودة إلى مصر لمواجهة فرعون وتحرير بني إسرائيل.\n\nالمواجهة والخروج:\nواجه موسى طغيان فرعون بشجاعة وهزم كبار سحرته، الذين آمنوا فور رؤيتهم للحق. وعندما استمر فرعون في عناده رغم الآيات والضربات، قاد موسى بني إسرائيل في خروج تاريخي ليلاً. ولما طاردهم جيش فرعون، شق الله البحر الأحمر، فنجا موسى وقومه وغرق فرعون وجنوده.\n\nالتوجيه والإرث:\nصعد موسى جبل سيناء لأربعين ليلة حيث تلقى "التوراة" التي تضمنت الأحكام الإلهية. بالرغم من صبره وتفانيه، عانى كثيراً من تمرد بني إسرائيل وعبادتهم للعجل أثناء تيههم في الصحراء. عُرف بلقب "كليم الله"، وهو النبي الأكثر ذكراً بالاسم في القرآن الكريم.',
        'fr': 'Naissance et Jeunesse:\nLe Prophète Moussa (Moïse) est né en Égypte à une époque où Pharaon ordonnait l\'exécution des garçons nouveau-nés. Sa mère, divinement inspirée, le plaça dans un panier sur le Nil. Miraculeusement, il fut adopté par la femme vertueuse de Pharaon, Asiya.\n\nProphétie et Appel Divin:\nAprès avoir fui vers Madyan, Moussa vécut une rencontre divine profonde au Mont Sinaï. Allah lui parla directement depuis un buisson ardent, lui accordant la prophétie et des miracles majeurs, comme son bâton se transformant en serpent. Il reçut l\'ordre de retourner affronter Pharaon.\n\nConfrontation et Exode:\nMoussa affronta la tyrannie de Pharaon et vainquit ses magiciens. Face au refus de Pharaon, Moussa mena les Israélites lors d\'un exode nocturne. Poursuivis par l\'armée, Allah fendit la mer Rouge, sauvant Moussa et noyant le tyran.\n\nGuidance et Héritage:\nMoussa reçut la Tawrat (Torah) sur le mont Sinaï. Connu sous le nom de "Kalim-ullah" (Celui qui a parlé directement à Allah), il est le prophète le plus fréquemment mentionné dans le Coran.',
      },
      'keyAchievements': {
        'en': ['Received the Torah with divine commandments', 'Performed miraculous signs before Pharaoh', 'Led the Israelites out of Egypt', 'Communicated directly with Allah'],
        'ar': ['تلقى التوراة والألواح التي تحمل الوصايا الإلهية', 'أظهر آيات ومعجزات كبرى أمام فرعون وسحرته', 'قاد بني إسرائيل وأنقذهم من الاستعباد في مصر', 'تكلم مع الله عز وجل مباشرة بدون حجاب'],
        'fr': ['A reçu la Torah avec les commandements divins', 'A accompli des signes miraculeux devant Pharaon', 'A mené les Israélites hors d\'Égypte', 'A communiqué directement avec Allah'],
      },
      'miracles': {
        'en': ['His staff turned into a great serpent and swallowed the magicians\' ropes.', 'His hand shone white without any disease — the "white hand".', 'The sea was parted for him and the Israelites, drowning Pharaoh.', 'Water gushed from a rock when he struck it with his staff.', 'Manna and quails were sent down to his people in the desert.', 'He spoke directly with Allah on Mount Tur.'],
        'ar': ['عصاه تحولت إلى حية عظيمة تبتلع حبال السحرة.', 'يده تبيض من غير سوء — اليد البيضاء.', 'البحر انفلق له ولقومه، وغرق فرعون.', 'الماء تفجر من الحجر حين ضربه بعصاه.', 'المن والسلوى أُنزلا على قومه في الصحراء.', 'كلم الله مباشرة على جبل الطور.'],
        'fr': ['Son bâton se transforma en un grand serpent qui engloutit les cordes des magiciens.', 'Sa main devint blanche sans maladie — la « main blanche ».', 'La mer se fendit pour lui et les Israélites, noyant Pharaon.', 'De l\'eau jaillit d\'un rocher quand il le frappa de son bâton.', 'La manne et les cailles furent envoyées à son peuple dans le désert.', 'Il parla directement avec Allah sur le mont Tur.'],
      },
      'lessons': {
        'en': ['Allah protects His chosen servants even in the house of tyrants.', 'Speaking truth to power is a duty of the believer.', 'Allah\'s help comes at the moment of greatest despair.', 'Miracles are from Allah alone — they do not belong to the prophet.', 'Even after deliverance, people may fall into ingratitude — stay firm.'],
        'ar': ['الله يحمي عباده المختارين حتى في بيت الطغاة.', 'قول الحق أمام السلطة واجب المؤمن.', 'نصر الله يأتي في أشد لحظات اليأس.', 'المعجزات من الله وحده، وليست للأنبياء.', 'حتى بعد النجاة قد يقع الناس في الجحود — فاثبت.'],
        'fr': ['Allah protège Ses serviteurs choisis même dans la maison des tyrans.', 'Dire la vérité au pouvoir est un devoir du croyant.', 'L\'aide d\'Allah vient au moment du plus grand désespoir.', 'Les miracles viennent d\'Allah seul — ils n\'appartiennent pas au prophète.', 'Même après la délivrance, les gens peuvent tomber dans l\'ingratitude — restez fermes.'],
      },
      'timeline': {
        'en': [
          {'year': 'Infancy', 'event': 'Placed in the Nile; raised in Pharaoh\'s palace.'},
          {'year': 'Youth', 'event': 'Flees to Madyan after accidental killing.'},
          {'year': 'Madyan', 'event': 'Marries, works as a shepherd for ten years.'},
          {'year': 'Mount Tur', 'event': 'Allah speaks to him directly and commissions him.'},
          {'year': 'Egypt', 'event': 'Returns to Pharaoh with Harun; performs miracles.'},
          {'year': 'Exodus', 'event': 'Leads Bani Israel out of Egypt; sea parts.'},
          {'year': 'Mount Sinai', 'event': 'Receives the Torah from Allah.'},
          {'year': 'Desert', 'event': 'Leads his people for forty years in the wilderness.'},
          {'year': '~ 120 years', 'event': 'Passes away near the Holy Land.'},
        ],
        'ar': [
          {'year': 'الرضاعة', 'event': 'يُوضع في النيل ويتربى في قصر فرعون.'},
          {'year': 'الشباب', 'event': 'يهاجر إلى مدين بعد قتل خطأ.'},
          {'year': 'مدين', 'event': 'يتزوج ويعمل راعياً عشر سنوات.'},
          {'year': 'جبل الطور', 'event': 'يكلمه الله مباشرة ويكلفه بالرسالة.'},
          {'year': 'مصر', 'event': 'يعود إلى فرعون مع هارون ويجري المعجزات.'},
          {'year': 'الخروج', 'event': 'يخرج بني إسرائيل من مصر وينفلق البحر.'},
          {'year': 'جبل سيناء', 'event': 'يتلقى التوراة من الله.'},
          {'year': 'الصحراء', 'event': 'يقود قومه أربعين سنة في التيه.'},
          {'year': 'نحو ١٢٠ سنة', 'event': 'يتوفى قرب الأرض المقدسة.'},
        ],
        'fr': [
          {'year': 'Nourrisson', 'event': 'Placé dans le Nil ; élevé au palais de Pharaon.'},
          {'year': 'Jeunesse', 'event': 'Fuit à Madyan après un meurtre accidentel.'},
          {'year': 'Madyan', 'event': 'Se marie, travaille comme berger pendant dix ans.'},
          {'year': 'Mont Tur', 'event': 'Allah lui parle directement et le commissionne.'},
          {'year': 'Égypte', 'event': 'Retourne vers Pharaon avec Harun ; accomplit des miracles.'},
          {'year': 'Exode', 'event': 'Conduit les Israélites hors d\'Égypte ; la mer se fend.'},
          {'year': 'Mont Sinaï', 'event': 'Reçoit la Torah d\'Allah.'},
          {'year': 'Désert', 'event': 'Conduit son peuple pendant quarante ans dans le désert.'},
          {'year': '~ 120 ans', 'event': 'Décède près de la Terre Sainte.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'Al-Qasas', 'surahArabic': 'القصص', 'surahNumber': 28, 'verseNumber': 30, 'verseText': 'يَا مُوسَىٰ إِنِّي أَنَا اللَّهُ رَبُّ الْعَالَمِينَ', 'verseTranslation': 'O Musa! Indeed, I am Allah, the Lord of the worlds.'},
        ],
        'ar': [
          {'surahName': 'القصص', 'surahArabic': 'القصص', 'surahNumber': 28, 'verseNumber': 30, 'verseText': 'يَا مُوسَىٰ إِنِّي أَنَا اللَّهُ رَبُّ الْعَالَمِينَ', 'verseTranslation': 'يا موسى إني أنا الله رب العالمين.'},
        ],
        'fr': [
          {'surahName': 'Al-Qasas', 'surahArabic': 'القصص', 'surahNumber': 28, 'verseNumber': 30, 'verseText': 'يَا مُوسَىٰ إِنِّي أَنَا اللَّهُ رَبُّ الْعَالَمِينَ', 'verseTranslation': 'Ô Moussa! C\'est Moi, Allah, le Seigneur de l\'univers.'},
        ],
      },
      'relatedProphetIds': ['harun', 'ibrahim', 'dawud', 'isa', 'muhammad'],
    },

    // ==================== ISA ====================
    {
      'id': 'isa',
      'name': {'en': 'Prophet Isa', 'ar': 'النبي عيسى', 'fr': 'Prophète Isa'},
      'arabicName': 'عيسى',
      'title': {'en': 'The Spirit of Allah', 'ar': 'روح الله وكلمته', 'fr': 'L\'Esprit d\'Allah'},
      'speciality': {'en': 'Born miraculously - The Spirit of Allah', 'ar': 'روح الله وكلمته - وُلد بمعجزة', 'fr': 'Né miraculeusement - L\'Esprit d\'Allah'},
      'lifespan': {'en': 'Approx. 1 - 33 CE', 'ar': 'حوالي 1 - 33 ميلادي', 'fr': 'Env. 1 - 33 È.C.'},
      'birthPlace': {'en': 'Bethlehem', 'ar': 'بيت لحم (فلسطين)', 'fr': 'Bethléem'},
      'deathPlace': {'en': 'Heavens', 'ar': 'رُفع إلى السماء', 'fr': 'Cieux'},
      'tribe': {'en': 'Bani Israel', 'ar': 'بني إسرائيل', 'fr': "Banu Isra'il"},
      'quranicName': {'en': 'Isa', 'ar': 'عيسى', 'fr': 'Isa'},
      'ageAtDeath': 33,
      'mentionedInSurahs': 15,
      'isMajor': true,
      'imageUrl': 'assets/images/prophets/isa.png',
      'description': {
        'en': 'Son of Maryam, born without a father, who performed great miracles and was raised to the heavens.',
        'ar': 'ابن مريم، وُلد بغير أب، أجرى معجزات عظيمة ورُفع إلى السماء.',
        'fr': "Fils de Maryam, né sans père, qui accomplit de grands miracles et fut élevé aux cieux.",
      },
      'fullDescription': {
        'en': 'Miraculous Birth:\nProphet Isa (Jesus) was conceived through a profound miracle, born to the deeply righteous and virgin Maryam (Mary) without a human father. The Quran details that he was created by the direct command of Allah. As a newborn infant, he miraculously spoke from the cradle to defend his mother\'s honor.\n\nProphetic Mission & Miracles:\nIsa was sent to the Children of Israel to confirm the Torah and bring a new scripture, the Injil (Gospel). By Allah\'s explicit permission, he healed the blind, cured lepers, and raised the dead. He called people back to pure monotheism, emphasizing spiritual sincerity.\n\nChallenges & Ascension:\nDespite his clear signs, he faced severe opposition from the religious elite. When they conspired to crucify him, the Quran explicitly states that they neither killed him nor crucified him. Instead, Allah made it appear so to them, and raised Isa up to Himself.\n\nIslamic Perspective & Return:\nIsa is highly revered in Islam as "Ruh-ullah" (The Spirit of Allah). The Quran completely rejects the notion of his divinity. Islamic eschatology holds that he will physically return to earth before the Day of Judgment to restore justice and defeat the false messiah.',
        'ar': 'الولادة المعجزة:\nحُمل بالنبي عيسى (المسيح) بمعجزة إلهية عظيمة، حيث وُلد للسيدة العذراء مريم عليها السلام دون أب بشري. يوضح القرآن أنه خُلق بكلمة الله المباشرة "كُن فيكون"، تماماً كخلق آدم. وفي المهد، نطق رضيعاً بمعجزة ليدافع عن طهارة أمه أمام اتهامات قومها، معلناً نبوته وعبوديته لله.\n\nالرسالة النبوية والمعجزات:\nأُرسل عيسى إلى بني إسرائيل ليصدق ما بين يديه من التوراة ويأتيهم بكتاب جديد هو "الإنجيل" يحمل الهداية والنور. لإثبات نبوته، أيده الله بمعجزات باهرة؛ فكان يُبرئ الأكمه (الأعمى) والأبرص، ويخلق من الطين كهيئة الطير فينفخ فيه فيكون طيراً، ويحيي الموتى، كل ذلك "بإذن الله". دعا الناس إلى التوحيد الخالص والروحانية الصادقة.\n\nالتحديات والرفع إلى السماء:\nرغم آياته الواضحة ورسالته الرحيمة، واجه معارضة شديدة ومؤامرات من النخبة الدينية التي شعرت بتهديد لتعاليمه. وعندما تآمروا لقتله وصلبه، ينص القرآن بوضوح قاطع أنهم (وما قتلوه وما صلبوه ولكن شبه لهم). بل رفعه الله إليه وأنقذه من أعدائه.\n\nالمنظور الإسلامي والعودة:\nيُعظم عيسى في الإسلام كـ "روح الله" و"كلمته" التي ألقاها إلى مريم. لكن القرآن يرفض رفضاً قاطعاً فكرة ألوهيته أو بنوته لله، مؤكداً بشريته كرسول كريم. وتؤكد العقيدة الإسلامية أنه سيعود إلى الأرض قبل يوم القيامة ليقيم العدل ويهزم المسيح الدجال ويملأ الأرض سلاماً.',
        'fr': 'Naissance Miraculeuse:\nLe Prophète Isa (Jésus) fut conçu par un miracle profond, né de la Vierge Marie (Maryam) sans père humain. Le Coran précise qu\'il a été créé par l\'ordre direct d\'Allah. Nouveau-né, il parla miraculeusement depuis son berceau pour défendre l\'honneur de sa mère.\n\nMission Prophétique et Miracles:\nIsa fut envoyé aux Enfants d\'Israël pour confirmer la Torah et apporter une nouvelle Écriture, l\'Injil (Évangile). Par la permission d\'Allah, il guérit les aveugles, les lépreux et ressuscita les morts. Il appela au monothéisme pur.\n\nDéfis et Ascension:\nMalgré ses signes clairs, il fit face à une sévère opposition de l\'élite religieuse. Lorsqu\'ils conspirèrent pour le crucifier, le Coran affirme qu\'ils ne l\'ont ni tué ni crucifié. Allah l\'a élevé vers Lui, le sauvant de ses ennemis.\n\nPerspective Islamique et Retour:\nIsa est vénéré comme "Ruh-ullah" (L\'Esprit d\'Allah). Le Coran rejette la notion de sa divinité. L\'eschatologie islamique soutient qu\'il reviendra physiquement sur terre avant le Jour du Jugement pour restaurer la justice.',
      },
      'keyAchievements': {
        'en': ['Born miraculously without a father', 'Performed miraculous signs by Allah\'s permission', 'Received the Gospel (Injil)', 'Called people to worship Allah alone'],
        'ar': ['وُلد بمعجزة إلهية دون أب بشري', 'أبرأ المرضى وأحيا الموتى بإذن الله', 'تلقى كتاب الإنجيل هدى ونوراً', 'تكلم في المهد صبياً ليدافع عن أمه', 'أحد أنبياء أولي العزم الخمسة'],
        'fr': ['Né miraculeusement sans père', 'A accompli des miracles par la permission d\'Allah', 'A reçu l\'Évangile (Injil)', 'Fait partie des cinq plus grands prophètes (Ouloul Azm)'],
      },
      'miracles': {
        'en': ['Born without a father — a miracle unique in human history.', 'Spoke clearly as an infant in the cradle.', 'Healed the blind and the leper by Allah\'s permission.', 'Revived the dead by Allah\'s permission.', 'Fashioned birds from clay that flew by Allah\'s permission.', 'Was raised alive to the heavens, not crucified.'],
        'ar': ['وُلد بغير أب — معجزة فريدة في تاريخ البشرية.', 'تكلم بوضوح رضيعاً في المهد.', 'شفى الأعمى والأبرص بإذن الله.', 'أحيا الموتى بإذن الله.', 'خلق من الطين طيوراً تطير بإذن الله.', 'رُفع حياً إلى السماء ولم يُصلب.'],
        'fr': ['Né sans père — un miracle unique dans l\'histoire humaine.', 'Parla clairement nourrisson au berceau.', 'Guérit l\'aveugle et le lépreux par permission d\'Allah.', 'Ressuscita les morts par permission d\'Allah.', 'Façonna des oiseaux d\'argile qui volaient.', 'Fut élevé vivant aux cieux, non crucifié.'],
      },
      'lessons': {
        'en': ['Allah\'s power is absolute — He creates as He wills.', 'True honour comes from Allah, not from lineage.', 'Miracles are by Allah\'s permission, not the prophet\'s own power.', 'Isa was a servant and messenger of Allah, not divine.', 'Maryam\'s purity and devotion are a model for all believers.'],
        'ar': ['قدرة الله مطلقة — يخلق كيف يشاء.', 'الشرف الحقيقي من الله لا من النسب.', 'المعجزات بإذن الله لا بقدرة النبي.', 'عيسى عبد الله ورسوله، وليس إلهاً.', 'طهر مريم وعبادتها قدوة لكل مؤمن.'],
        'fr': ['La puissance d\'Allah est absolue — Il crée comme Il veut.', 'Le véritable honneur vient d\'Allah, non de la lignée.', 'Les miracles sont par permission d\'Allah, non par le pouvoir du prophète.', 'Isa était un serviteur et messager d\'Allah, non divin.', 'La pureté et la dévotion de Maryam sont un modèle pour tous les croyants.'],
      },
      'timeline': {
        'en': [
          {'year': 'Birth', 'event': 'Born miraculously to Maryam without a father.'},
          {'year': 'Infancy', 'event': 'Speaks from the cradle defending his mother.'},
          {'year': 'Prophethood', 'event': 'Receives the Injil and begins calling to Tawheed.'},
          {'year': 'Ministry', 'event': 'Performs miracles: heals the blind, raises the dead.'},
          {'year': 'Plot', 'event': 'Disbelievers plot to kill him.'},
          {'year': 'Ascent', 'event': 'Allah raises him to the heavens; not crucified.'},
          {'year': 'Future', 'event': 'Will return before the end of time.'},
        ],
        'ar': [
          {'year': 'الميلاد', 'event': 'يُولد معجزة لمريم بغير أب.'},
          {'year': 'الرضاعة', 'event': 'يتكلم من المهد دفاعاً عن أمه.'},
          {'year': 'النبوة', 'event': 'يتلقى الإنجيل ويبدأ الدعوة للتوحيد.'},
          {'year': 'الرسالة', 'event': 'يجري المعجزات: شفاء الأعمى وإحياء الموتى.'},
          {'year': 'المؤامرة', 'event': 'الكافرون يتآمرون لقتله.'},
          {'year': 'الرفع', 'event': 'يرفعه الله إلى السماء ولم يُصلب.'},
          {'year': 'المستقبل', 'event': 'سيعود قبل نهاية الزمان.'},
        ],
        'fr': [
          {'year': 'Naissance', 'event': 'Né miraculeusement de Maryam sans père.'},
          {'year': 'Nourrisson', 'event': 'Parle du berceau pour défendre sa mère.'},
          {'year': 'Prophétie', 'event': 'Reçoit l\'Injil et commence à appeler au Tawhid.'},
          {'year': 'Ministère', 'event': 'Accomplit des miracles : guérit l\'aveugle, ressuscite les morts.'},
          {'year': 'Complot', 'event': 'Les mécréants complotent pour le tuer.'},
          {'year': 'Ascension', 'event': 'Allah l\'élève aux cieux ; non crucifié.'},
          {'year': 'Futur', 'event': 'Reviendra avant la fin des temps.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'Maryam', 'surahArabic': 'مريم', 'surahNumber': 19, 'verseNumber': 34, 'verseText': 'ذَٰلِكَ عِيسَى ابْنُ مَرْيَمَ ۚ قَوْلَ الْحَقِّ الَّذِي فِيهِ يَمْتَرُونَ', 'verseTranslation': 'That is Isa, son of Maryam, concerning whom they dispute.'},
        ],
        'ar': [
          {'surahName': 'مريم', 'surahArabic': 'مريم', 'surahNumber': 19, 'verseNumber': 34, 'verseText': 'ذَٰلِكَ عِيسَى ابْنُ مَرْيَمَ ۚ قَوْلَ الْحَقِّ الَّذِي فِيهِ يَمْتَرُونَ', 'verseTranslation': 'ذلك عيسى ابن مريم قول الحق الذي فيه يمترون.'},
        ],
        'fr': [
          {'surahName': 'Maryam', 'surahArabic': 'مريم', 'surahNumber': 19, 'verseNumber': 34, 'verseText': 'ذَٰلِكَ عِيسَى ابْنُ مَرْيَمَ ۚ قَوْلَ الْحَقِّ الَّذِي فِيهِ يَمْتَرُونَ', 'verseTranslation': 'Tel est Isa, fils de Maryam, parole de vérité dont ils doutent.'},
        ],
      },
      'relatedProphetIds': ['musa', 'yahya', 'muhammad'],
    },

    // ==================== NUH ====================
    {
      'id': 'nuh',
      'name': {'en': 'Prophet Nuh', 'ar': 'النبي نوح', 'fr': 'Prophète Nouh'},
      'arabicName': 'نوح',
      'title': {'en': 'The First Messenger', 'ar': 'أول رسول إلى أهل الأرض', 'fr': 'Le Premier Messager'},
      'speciality': {'en': 'First Messenger - Preached 950 years', 'ar': 'شيخ المرسلين - صاحب معجزة الطوفان', 'fr': 'Premier Messager - A prêché 950 ans'},
      'lifespan': {'en': 'Approx. 2900+ years', 'ar': 'أكثر من 2900 سنة', 'fr': 'Env. 2900+ ans'},
      'birthPlace': {'en': 'Unknown', 'ar': 'غير محدد', 'fr': 'Inconnu'},
      'deathPlace': {'en': 'Unknown', 'ar': 'غير محدد', 'fr': 'Inconnu'},
      'tribe': {'en': '', 'ar': '', 'fr': ''},
      'quranicName': {'en': 'Nuh', 'ar': 'نوح', 'fr': 'Nuh'},
      'ageAtDeath': 950,
      'mentionedInSurahs': 28,
      'isMajor': true,
      'imageUrl': 'assets/images/prophets/nuh.png',
      'description': {
        'en': 'First messenger sent to a disbelieving people, he called them to Tawheed for 950 years.',
        'ar': 'أول رسول أُرسل إلى قوم كفار، دعاهم إلى التوحيد ٩٥٠ سنة.',
        'fr': "Premier messager envoyé à un peuple mécréant, il les appela au Tawhid pendant 950 ans.",
      },
      'fullDescription': {
        'en': 'Early Life & Society:\nProphet Nuh (Noah) was one of the earliest messengers sent by Allah. He lived in a time when people had deviated far from monotheism, falling into the worship of idols. His society was deeply entrenched in ignorance and polytheism.\n\nUnwavering Mission:\nFor an astonishing 950 years, Nuh tirelessly called his people back to the worship of the One True God. Despite his immense patience and centuries of dedication, only a very small group of people believed in his message, while the tribal elite relentlessly mocked and threatened him.\n\nThe Ark & The Great Flood:\nWhen it became clear that no one else would believe, Allah commanded Nuh to construct a massive Ark. As he built it, his people continued to ridicule him. Upon Allah\'s command, pairs of animals and the devoted believers boarded the ship. A global flood ensued, drowning all the disbelievers.\n\nLegacy & Status:\nTragically, among those who drowned was Nuh\'s own son, who refused to join the believers. Nuh is recognized as the first of the "Ulul-Azm" (Prophets of Strong Resolve). His life stands as the ultimate symbol of perseverance.',
        'ar': 'النشأة والمجتمع:\nيُعد النبي نوح عليه السلام من أوائل الرسل الذين بعثهم الله للبشرية. عاش في حقبة انحرف فيها الناس عن التوحيد الصافي الذي جاء به آدم، وسقطوا في مستنقع عبادة الأصنام التي كانت في الأصل تماثيل لرجال صالحين. كان مجتمعه غارقاً في الجهل والشرك والتكبر.\n\nالمهمة الثابتة والصبر:\nلمدة مذهلة بلغت 950 عاماً، دعا نوح قومه بلا كلل أو ملل للعودة إلى عبادة الله الواحد. وعظهم ليلاً ونهاراً، سراً وجهاراً، مستخدماً كل أساليب الترغيب والترهيب والحجة المنطقية. ورغم صبره الهائل، لم يؤمن معه إلا قلة قليلة جداً، بينما استمرت النخبة في السخرية منه وإيذائه واتهامه بالجنون والضلال.\n\nالسفينة والطوفان العظيم:\nعندما أوحى الله إليه أنه لن يؤمن من قومه إلا من قد آمن، أمره الله ببناء سفينة ضخمة. وبينما كان يصنع الفلك على اليابسة، كان قومه يمرون به ويسخرون منه. وبأمر إلهي، حمل في السفينة من كل زوجين اثنين مع المؤمنين القلائل. ثم انفجرت الأرض عيوناً وانهمرت السماء بماء منهمر، ليحدث طوفان عالمي أغرق كل الكافرين.\n\nالإرث والمكانة:\nمن أشد اللحظات حزناً كان غرق ابن نوح، الذي رفض بعناد الانضمام للمؤمنين ولجأ إلى جبل ظناً أنه سيعصمه من الماء. يُعرف نوح بأنه أول أنبياء "أولو العزم". وحياته هي الرمز الأسمى للمثابرة، مؤكدة أن واجب النبي هو التبليغ بصبر، بينما الهداية بيد الله وحده.',
        'fr': 'Jeunesse et Société:\nLe Prophète Nouh (Noé) est l\'un des premiers messagers envoyés par Allah. Il vécut à une époque où les gens s\'étaient éloignés du monothéisme pour tomber dans l\'idolâtrie.\n\nMission Inébranlable:\nPendant 950 ans, Nouh appela inlassablement son peuple à n\'adorer que le Dieu Unique. Malgré sa patience immense, seul un très petit groupe de personnes crut en son message, tandis que l\'élite tribale se moquait de lui.\n\nL\'Arche et le Grand Déluge:\nLorsqu\'il devint clair que personne d\'autre ne croirait, Allah ordonna à Nouh de construire une arche massive. Sur ordre d\'Allah, des couples d\'animaux et les croyants dévoués embarquèrent. Un déluge mondial s\'ensuivit, noyant tous les mécréants.\n\nHéritage et Statut:\nParmi ceux qui se noyèrent se trouvait le propre fils de Nouh, qui refusa de rejoindre les croyants. Nouh est reconnu comme le premier des "Ouloul Azm" (Prophètes de Forte Résolution). Sa vie est le symbole ultime de la persévérance.',
      },
      'keyAchievements': {
        'en': ['First messenger sent to mankind', 'Preached for 950 years without success', 'Built the ark on Allah\'s command', 'Saved believers from the Great Flood'],
        'ar': ['أول رسول يُبعث لأهل الأرض لمحاربة الشرك', 'دعا قومه لمدة 950 عاماً دون يأس', 'بنى السفينة بوحي من الله لإنقاذ المؤمنين', 'ضرب أروع الأمثلة في الصبر على إيذاء القوم'],
        'fr': ['Premier messager envoyé à l\'humanité', 'A prêché pendant 950 ans sans succès', 'A construit l\'arche sur ordre d\'Allah', 'A sauvé les croyants du Grand Déluge'],
      },
      'miracles': {
        'en': ['Built an ark on dry land by divine command, far from any sea.', 'The great flood that covered the earth was a miracle of judgment and mercy.', 'The ark came to rest on Mount Judi as a sign for all nations.', 'His longevity of 950 years of preaching is itself a miracle.'],
        'ar': ['بناء الفلك على اليابسة بأمر الله بعيداً عن أي بحر.', 'الطوفان العظيم الذي غطى الأرض آية عذاب ورحمة.', 'استواء السفينة على الجودي آية لكل الأمم.', 'طول عمره ٩٥٠ سنة في الدعوة معجزة بحد ذاته.'],
        'fr': ['Construisit une arche sur la terre ferme par ordre divin, loin de toute mer.', 'Le grand déluge qui couvrit la terre fut un miracle de jugement et de miséricorde.', 'L\'arche se posa sur le mont Judi comme signe pour toutes les nations.', 'Sa longévité de 950 ans de prédication est en soi un miracle.'],
      },
      'lessons': {
        'en': ['Patience in da\'wah: 950 years of calling without despair.', 'Results are with Allah — our duty is to convey the message.', 'Obedience to Allah\'s command even when it seems impossible.', 'Faith is not inherited; each soul chooses its path.', 'The ark of salvation is Tawheed — those who refuse it drown.'],
        'ar': ['الصبر في الدعوة: ٩٥٠ سنة من الدعوة دون يأس.', 'النتائج بيد الله، وواجبنا البلاغ.', 'طاعة أمر الله حتى وإن بدا مستحيلاً.', 'الإيمان لا يورث، وكل نفس تختار طريقها.', 'سفينة النجاة هي التوحيد، ومن رفضها غرق.'],
        'fr': ['La patience dans la da\'wah : 950 ans d\'appel sans désespoir.', 'Les résultats appartiennent à Allah — notre devoir est de transmettre.', 'Obéissance à l\'ordre d\'Allah même quand il semble impossible.', 'La foi ne s\'hérite pas ; chaque âme choisit sa voie.', 'L\'arche du salut est le Tawhid — ceux qui la refusent se noient.'],
      },
      'timeline': {
        'en': [
          {'year': 'Early life', 'event': 'Receives prophethood and begins calling his people.'},
          {'year': '950 years', 'event': 'Calls his people to Tawheed day and night.'},
          {'year': 'Command', 'event': 'Builds the ark by Allah\'s command despite mockery.'},
          {'year': 'The Flood', 'event': 'The great flood covers the earth and destroys the disbelievers.'},
          {'year': 'After', 'event': 'The ark rests on Mount Judi; believers disembark.'},
        ],
        'ar': [
          {'year': 'بداية حياته', 'event': 'يُبعث نبياً ويبدأ دعوة قومه.'},
          {'year': '٩٥٠ سنة', 'event': 'يدعو قومه إلى التوحيد ليلاً ونهاراً.'},
          {'year': 'الأمر', 'event': 'يبني الفلك بأمر الله رغم السخرية.'},
          {'year': 'الطوفان', 'event': 'الطوفان العظيم يغطي الأرض ويهلك الكافرين.'},
          {'year': 'بعد الطوفان', 'event': 'ترسو السفينة على الجودي وينزل المؤمنون.'},
        ],
        'fr': [
          {'year': 'Début de vie', 'event': 'Reçoit la prophétie et commence à appeler son peuple.'},
          {'year': '950 ans', 'event': 'Appelle son peuple au Tawhid jour et nuit.'},
          {'year': 'Ordre', 'event': 'Construit l\'arche sur ordre d\'Allah malgré les moqueries.'},
          {'year': 'Le Déluge', 'event': 'Le grand déluge couvre la terre et détruit les mécréants.'},
          {'year': 'Après', 'event': 'L\'arche se pose sur le mont Judi ; les croyants débarquent.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'Nuh', 'surahArabic': 'نوح', 'surahNumber': 71, 'verseNumber': 1, 'verseText': 'إِنَّا أَرْسَلْنَا نُوحًا إِلَىٰ قَوْمِهِ أَنْ أَنذِرْ قَوْمَكَ', 'verseTranslation': 'Indeed, We sent Nuh to his people saying: Warn your people.'},
        ],
        'ar': [
          {'surahName': 'نوح', 'surahArabic': 'نوح', 'surahNumber': 71, 'verseNumber': 1, 'verseText': 'إِنَّا أَرْسَلْنَا نُوحًا إِلَىٰ قَوْمِهِ أَنْ أَنذِرْ قَوْمَكَ', 'verseTranslation': 'إنا أرسلنا نوحا إلى قومه أن أنذر قومك.'},
        ],
        'fr': [
          {'surahName': 'Nouh', 'surahArabic': 'نوح', 'surahNumber': 71, 'verseNumber': 1, 'verseText': 'إِنَّا أَرْسَلْنَا نُوحًا إِلَىٰ قَوْمِهِ أَنْ أَنذِرْ قَوْمَكَ', 'verseTranslation': 'Nous avons envoyé Nouh vers son peuple: "Avertis ton peuple"'},
        ],
      },
      'relatedProphetIds': ['adam', 'hud', 'ibrahim'],
    },

    // ==================== AYYUB ====================
    {
      'id': 'ayyub',
      'name': {'en': 'Prophet Ayub', 'ar': 'النبي أيوب', 'fr': 'Prophète Ayub'},
      'arabicName': 'أيوب',
      'title': {'en': 'The Patient One', 'ar': 'رمز الصبر', 'fr': 'Le Patient'},
      'speciality': {'en': 'The Patient One - Exemplar of patience', 'ar': 'رمز الصبر المطلق واليقين في الله', 'fr': 'L\'Exemple absolu de la patience'},
      'lifespan': {'en': 'Approx. 2000 BCE', 'ar': 'حوالي 2000 قبل الميلاد', 'fr': 'Env. 2000 av. J.-C.'},
      'birthPlace': {'en': 'Levant', 'ar': 'أرض الشام', 'fr': 'Levant'},
      'deathPlace': {'en': 'Levant', 'ar': 'أرض الشام', 'fr': 'Levant'},
      'tribe': {'en': 'Bani Israel', 'ar': 'بني إسرائيل', 'fr': "Banu Isra'il"},
      'quranicName': {'en': 'Ayyub', 'ar': 'أيوب', 'fr': 'Ayyub'},
      'ageAtDeath': 140,
      'mentionedInSurahs': 4,
      'isMajor': false,
      'imageUrl': 'assets/images/prophets/ayub.png',
      'description': {
        'en': 'A prophet of extraordinary patience, tested with the loss of everything he held dear.',
        'ar': 'نبي الصبر العظيم، ابتُلي بفقد كل ما يحب.',
        'fr': "Un prophète d'une patience extraordinaire, éprouvé par la perte de tout ce qu'il chérissait.",
      },
      'fullDescription': {
        'en': 'Early Life & Prosperity:\nProphet Ayub (Job) was initially blessed with immense wealth, expansive lands, and a large family. He was a highly respected leader known for his deep piety, extreme generosity to the poor, and constant gratitude to Allah.\n\nThe Great Trial:\nTo demonstrate the purity of Ayub\'s faith, Allah subjected him to a severe test. Ayub lost all his wealth, his property was destroyed, and his children perished. He was also afflicted with a painful illness that ravaged his body, causing his community to abandon him. His heart remained steadfastly attached to Allah.\n\nPatience & Sincerity:\nFor years, Ayub endured unimaginable suffering without a single complaint. He was abandoned by everyone except his devoted wife. When he finally called out to Allah, his prayer was remarkably humble: "Indeed, adversity has touched me, and You are the Most Merciful of the merciful."\n\nRestoration & Legacy:\nAllah answered his sincere supplication, commanding him to strike the ground with his foot. A miraculous spring gushed forth; washing in it cured him completely. Allah restored his youth, returned his wealth manifold, and granted him a new family. Ayub remains the eternal archetype of patience.',
        'ar': 'الرخاء والنعمة:\nأنعم الله على النبي أيوب في بداية حياته بثروة هائلة، ومساحات شاسعة من الأراضي، وأنعام كثيرة، وعائلة كبيرة وصالحة. كان زعيماً محترماً في منطقة بلاد الشام، وعُرف بتقواه الشديدة، وكرمه اللامحدود للفقراء والأيتام، وشكره الدائم لله على نعمه.\n\nالابتلاء العظيم:\nلإظهار نقاء وقوة إيمان أيوب، خضعه الله لأحد أشد الابتلاءات في تاريخ البشرية. في فترة قصيرة، فقد أيوب كل ثروته، وتُوفّي أبناؤه، وأُصيب بمرض جلدي مؤلم أهلك جسده، مما دفع مجتمعه إلى الابتعاد عنه وعزله تماماً. ورغم فقدانه لكل شيء ومعاناته الجسدية القاسية، ظل قلبه معلقاً بالله وحامداً له.\n\nالصبر واليقين:\nلسنوات طويلة (يُقال إنها 18 عاماً)، تحمل أيوب هذا الألم الذي لا يُطاق دون أن ينطق بكلمة شكوى واحدة ضد خالقه. هجره الجميع باستثناء زوجته المخلصة. وعندما دعا الله أخيراً، كان دعاؤه في قمة الأدب والتواضع: (أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ)، معبراً عن ضعفه البشري دون أن يشترط الشفاء.\n\nالشفاء والجزاء:\nاستجاب الله لدعائه الصادق والصابر، وأمره أن يضرب الأرض بقدمه. فنبعت عين ماء باردة، اغتسل منها وشرب فبرئ تماماً وعاد شاباً صحيحاً. وعوّضه الله أضعاف ما فقد من المال والولد. يظل أيوب عليه السلام النموذج الأبدي في الفكر الإسلامي للصبر المطلق والثقة التامة في رحمة الله أثناء المحن.',
        'fr': 'Prospérité Initiale:\nLe Prophète Ayub (Job) fut initialement béni par Allah d\'une immense richesse et d\'une grande famille. Il était un chef très respecté, connu pour sa profonde piété et sa générosité envers les pauvres.\n\nLa Grande Épreuve:\nPour démontrer la pureté de la foi d\'Ayub, Allah le soumit à une épreuve sévère. Ayub perdit toute sa richesse et ses enfants périrent. Il fut également affligé d\'une maladie douloureuse qui ravagea son corps, poussant sa communauté à l\'abandonner.\n\nPatience et Sincérité:\nPendant des années, Ayub endura cette souffrance inimaginable sans la moindre plainte. Seule sa femme dévouée resta à ses côtés. Lorsqu\'il fit appel à Allah, sa prière fut remarquablement humble : "Le mal m\'a touché, et Tu es le plus miséricordieux des miséricordieux."\n\nRestauration et Héritage:\nAllah répondit à sa supplication, lui ordonnant de frapper le sol de son pied. Une source miraculeuse jaillit, le guérissant complètement. Allah restaura sa jeunesse, sa richesse et sa famille. Ayub reste l\'archétype éternel de la patience.',
      },
      'keyAchievements': {
        'en': ['Remained patient through severe trials', 'Maintained faith despite loss of health and wealth', 'Received complete restoration after trials'],
        'ar': ['ضرب أروع الأمثلة في الصبر على أشد الابتلاءات في المال والولد والجسد', 'حافظ على إيمانه وشكره لله رغم فقدان كل شيء', 'نال الشفاء والتعويض الإلهي المضاعف جزاءً لصبره'],
        'fr': ['Est resté patient à travers de sévères épreuves', 'A maintenu sa foi malgré la perte de santé et de richesse', 'Modèle absolu de patience dans la tradition islamique'],
      },
      'miracles': {
        'en': ['A cool spring gushed forth from the ground when he struck it with his foot.', 'Complete healing from a long, severe illness.', 'Allah restored his family and doubled his wealth.'],
        'ar': ['عين باردة تفجرت من الأرض حين ضربها برجله.', 'شفاء تام من مرض طويل شديد.', 'أعاد الله له أهله وضاعف ماله.'],
        'fr': ['Une source fraîche jaillit du sol quand il le frappa du pied.', 'Guérison complète d\'une longue maladie grave.', 'Allah lui restaura sa famille et doubla sa richesse.'],
      },
      'lessons': {
        'en': ['Patience in adversity elevates the believer to the highest ranks.', 'Never complain against Allah — complain to Allah.', 'Health, wealth, and family are all tests, whether given or taken.', 'Allah\'s mercy comes at the moment of greatest need.', 'True gratitude is shown in hardship, not only in ease.'],
        'ar': ['الصبر على البلاء يرفع المؤمن إلى أعلى الدرجات.', 'لا تشكُ من الله، بل اشكُ إلى الله.', 'الصحة والمال والأهل كلها ابتلاء، عطاءً وأخذًا.', 'رحمة الله تأتي في أشد لحظات الحاجة.', 'الشكر الحقيقي يظهر في الشدة لا في الرخاء فقط.'],
        'fr': ['La patience dans l\'adversité élève le croyant aux plus hauts rangs.', 'Ne vous plaignez jamais d\'Allah — plaignez-vous à Allah.', 'La santé, la richesse et la famille sont toutes des épreuves.', 'La miséricorde d\'Allah vient au moment du plus grand besoin.', 'La vraie gratitude se manifeste dans l\'épreuve, pas seulement dans l\'aisance.'],
      },
      'timeline': {
        'en': [
          {'year': 'Early life', 'event': 'Blessed with wealth, children and health.'},
          {'year': 'Test begins', 'event': 'Loses livestock, wealth and children.'},
          {'year': 'Illness', 'event': 'Struck with a severe illness for many years.'},
          {'year': 'Patience', 'event': 'Remains steadfast; his wife stays loyal.'},
          {'year': 'Du\'a', 'event': 'Calls out to Allah: "Adversity has touched me."'},
          {'year': 'Healing', 'event': 'Strikes the ground; a spring gushes forth; healed.'},
          {'year': 'Restoration', 'event': 'Allah restores his family and doubles his wealth.'},
        ],
        'ar': [
          {'year': 'بداية حياته', 'event': 'أُنعم عليه بالمال والولد والصحة.'},
          {'year': 'بداية البلاء', 'event': 'فقد المواشي والمال والأولاد.'},
          {'year': 'المرض', 'event': 'ابتُلي بمرض شديد سنوات.'},
          {'year': 'الصبر', 'event': 'ثبت وصبرت زوجته معه.'},
          {'year': 'الدعاء', 'event': 'نادى ربه: أني مسني الضر.'},
          {'year': 'الشفاء', 'event': 'ضرب الأرض فانفجرت عين فشُفي.'},
          {'year': 'الإعادة', 'event': 'أعاد الله له أهله وضاعف ماله.'},
        ],
        'fr': [
          {'year': 'Début', 'event': 'Béni de richesse, d\'enfants et de santé.'},
          {'year': 'Début de l\'épreuve', 'event': 'Perd bétail, richesse et enfants.'},
          {'year': 'Maladie', 'event': 'Frappé d\'une maladie grave pendant des années.'},
          {'year': 'Patience', 'event': 'Reste ferme ; sa femme reste fidèle.'},
          {'year': 'Invocation', 'event': 'Appelle Allah : « L\'adversité m\'a touché. »'},
          {'year': 'Guérison', 'event': 'Frappe le sol ; une source jaillit ; guéri.'},
          {'year': 'Restauration', 'event': 'Allah restaure sa famille et double sa richesse.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'Al-Anbiya', 'surahArabic': 'الأنبياء', 'surahNumber': 21, 'verseNumber': 83, 'verseText': 'وَأَيُّوبَ إِذْ نَادَىٰ رَبَّهُ أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ', 'verseTranslation': 'And Ayub, when he called to his Lord: Indeed, adversity has touched me.'},
        ],
        'ar': [
          {'surahName': 'الأنبياء', 'surahArabic': 'الأنبياء', 'surahNumber': 21, 'verseNumber': 83, 'verseText': 'وَأَيُّوبَ إِذْ نَادَىٰ رَبَّهُ أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ', 'verseTranslation': 'وأيوب إذ نادى ربه أني مسني الضر وأنت أرحم الراحمين.'},
        ],
        'fr': [
          {'surahName': 'Al-Anbiya', 'surahArabic': 'الأنبياء', 'surahNumber': 21, 'verseNumber': 83, 'verseText': 'وَأَيُّوبَ إِذْ نَادَىٰ رَبَّهُ أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ', 'verseTranslation': 'Et Ayub, quand il implora son Seigneur: "Le mal m\'a touché. Mais Toi, Tu es le plus miséricordieux"'},
        ],
      },
      'relatedProphetIds': ['yaqub', 'yusuf', 'yunus'],
    },

    // ==================== YUSUF ====================
    {
      'id': 'yusuf',
      'name': {'en': 'Prophet Yusuf', 'ar': 'النبي يوسف', 'fr': 'Prophète Youssouf'},
      'arabicName': 'يوسف',
      'title': {'en': 'The Handsome One', 'ar': 'الكريم ابن الكريم', 'fr': 'Le Véridique'},
      'speciality': {'en': 'The Handsome One - Model of chastity', 'ar': 'الكريم والصديق - رمز العفة والعفو', 'fr': 'Le Beau - Modèle de chasteté et de pardon'},
      'lifespan': {'en': 'Approx. 2100-2000 BCE', 'ar': 'حوالي 2100-2000 قبل الميلاد', 'fr': 'Env. 2100-2000 av. J.-C.'},
      'birthPlace': {'en': 'Canaan', 'ar': 'أرض كنعان', 'fr': 'Canaan'},
      'deathPlace': {'en': 'Egypt', 'ar': 'مصر', 'fr': 'Égypte'},
      'tribe': {'en': 'Bani Israel', 'ar': 'بني إسرائيل', 'fr': "Banu Isra'il"},
      'quranicName': {'en': 'Yusuf', 'ar': 'يوسف', 'fr': 'Yusuf'},
      'ageAtDeath': 110,
      'mentionedInSurahs': 4,
      'isMajor': true,
      'imageUrl': 'assets/images/prophets/yusuf.png',
      'description': {
        'en': 'A prophet of beauty, patience and forgiveness — from the well to the palace of Egypt.',
        'ar': 'نبي الجمال والصبر والغفران — من الجب إلى قصر مصر.',
        'fr': "Un prophète de beauté, de patience et de pardon — du puits au palais d'Égypte.",
      },
      'fullDescription': {
        'en': 'Birth & Betrayal:\nProphet Yusuf (Joseph) was the beloved son of Prophet Yaqub (Jacob). Blessed with exceptional physical beauty and profound dreams, he became the target of his brothers\' jealousy. They maliciously threw him into a well. Rescued by a passing caravan, he was sold into slavery in Egypt.\n\nTrials & Imprisonment:\nPurchased by an Egyptian minister, Yusuf grew into a righteous man. The minister\'s wife attempted to seduce him, but Yusuf firmly resisted. To protect his honor, he chose unjust imprisonment, spending years in a dungeon where he continued to preach monotheism and accurately interpret dreams.\n\nRise to Power:\nYusuf\'s divinely inspired interpretation of the King\'s dream—about an impending seven-year famine—secured his release. Recognizing his administrative brilliance, the King appointed him as the chief minister of finance. Yusuf managed Egypt\'s resources, saving the region from starvation.\n\nReunion & Forgiveness:\nDuring the famine, his brothers traveled to Egypt seeking rations. After a series of tests, Yusuf revealed himself and forgave his brothers completely for their past betrayal. He reunited with his father, fulfilling his childhood dream.',
        'ar': 'الطفولة والمؤامرة:\nكان النبي يوسف الابن الأحب للنبي يعقوب عليهما السلام. رُزق بجمال جسدي فائق ورؤى نبوية صادقة منذ صغره، مما جعله هدفاً لغيرة إخوته غير الأشقاء. تآمروا عليه وألقوه في غيابة الجب (بئر عميق)، وعادوا إلى أبيهم بقميص ملطخ بدم كذب مدعين أن الذئب أكله. أنقذته قافلة مارة وباعوه كعبد في أسواق مصر بثمن بخس.\n\nمحنة الشباب والسجن:\nاشتراه عزيز مصر (وزير كبير)، ونشأ يوسف كشاب في غاية النبل والوسامة. شُغفت به زوجة العزيز وحاولت إغواءه، لكن يوسف اعتصم بإيمانه ورفض بشدة. ولحماية شرفه وعفته من هذه البيئة السامة، اختار السجن الظالم قائلاً (رب السجن أحب إلي مما يدعونني إليه). قضى بضع سنوات في السجن حيث استمر في دعوته للتوحيد وتفسير الرؤى بدقة.\n\nالصعود للسلطة:\nكان تفسيره الدقيق والملهم لرؤيا ملك مصر المقلقة - حول سبع سنوات من الرخاء تليها سبع سنوات من القحط والجفاف - هو سبب خروجه من السجن معززاً مكرماً. ولثقة الملك في حكمته وأمانته وكفاءته، عينه وزيراً للمالية (على خزائن الأرض). أدار يوسف موارد مصر بعبقرية وأنقذ المنطقة بأسرها من مجاعة محققة.\n\nاللقاء والعفو:\nخلال المجاعة، جاء إخوته إلى مصر يطلبون حصصاً من الطعام دون أن يعرفوه. وبعد سلسلة من التدابير الحكيمة لجمع شمل عائلته بأكملها، كشف يوسف عن هويته. وفي مشهد عظيم من التسامح النبوي، عفا عن إخوته عفواً شاملاً قائلاً (لا تثريب عليكم اليوم). التأم شمله بأبيه، وتحققت رؤياه القديمة، تاركاً إرثاً خالداً في العفة، والعفو، وحسن التوكل على الله.',
        'fr': 'Naissance et Trahison:\nLe Prophète Youssouf (Joseph) était le fils bien-aimé du Prophète Yaqub (Jacob). Doté d\'une beauté exceptionnelle et de rêves prophétiques, il devint la cible de la jalousie de ses frères, qui le jetèrent dans un puits. Secouru, il fut vendu comme esclave en Égypte.\n\nÉpreuves et Emprisonnement:\nAcheté par un ministre égyptien, Youssouf grandit en un homme juste. La femme du ministre tenta de le séduire, mais Youssouf résista fermement. Pour protéger son honneur, il choisit l\'emprisonnement, où il continua à prêcher le monothéisme.\n\nAscension au Pouvoir:\nL\'interprétation divinement inspirée par Youssouf du rêve du roi - concernant sept années de famine - lui assura sa libération. Le roi le nomma ministre des finances. Youssouf géra les ressources de l\'Égypte, sauvant la région de la famine.\n\nRetrouvailles et Pardon:\nPendant la famine, ses frères vinrent en Égypte. Après une série de tests, Youssouf se révéla et pardonna complètement à ses frères pour leur trahison passée. Il retrouva son père, réalisant son rêve d\'enfance.',
      },
      'keyAchievements': {
        'en': ['Maintained chastity despite temptation', 'Rose from slave to minister of Egypt', 'Forgave his brothers who betrayed him', 'Saved the region from a severe famine'],
        'ar': ['حافظ على عفته وطهارته رغم الإغراءات الشديدة', 'فسر الرؤى بفضل الله وأنقذ مصر والدول المجاورة من مجاعة طاحنة', 'ترقى من عبد مسجون إلى وزير نافذ في مصر', 'ضرب أروع أمثلة العفو عند المقدرة بمسامحة إخوته'],
        'fr': ['A maintenu sa chasteté malgré la tentation', 'Est passé d\'esclave à ministre d\'Égypte', 'A pardonné à ses frères qui l\'avaient trahi', 'A sauvé la région d\'une grave famine'],
      },
      'miracles': {
        'en': ['His dream of eleven stars, the sun and the moon — fulfilled decades later.', 'Accurate interpretation of dreams through divine knowledge.', 'His miraculous release from prison and rise to power.'],
        'ar': ['رؤياه أحد عشر كوكباً والشمس والقمر — تحققت بعد عقود.', 'تفسير الرؤى بدقة بعلم إلهي.', 'خروجه المعجز من السجن وارتفاعه للسلطة.'],
        'fr': ['Son rêve de onze étoiles, du soleil et de la lune — accompli des décennies plus tard.', 'Interprétation précise des rêves par une connaissance divine.', 'Sa libération miraculeuse de prison et son accession au pouvoir.'],
      },
      'lessons': {
        'en': ['Patience in the face of injustice and betrayal.', 'Chastity and self-control are treasures of the believer.', 'Forgiveness is more powerful than revenge.', 'Allah\'s plan unfolds over years — trust His timing.', 'Hardship often precedes elevation.'],
        'ar': ['الصبر أمام الظلم والغدر.', 'العفة وضبط النفس كنوز المؤمن.', 'العفو أقوى من الانتقام.', 'تدبير الله يتحقق على مدى سنوات، فثق بتوقيته.', 'الابتلاء غالباً يسبق الرفعة.'],
        'fr': ['Patience face à l\'injustice et à la trahison.', 'La chasteté et la maîtrise de soi sont des trésors du croyant.', 'Le pardon est plus puissant que la vengeance.', 'Le plan d\'Allah se déroule sur des années — faites confiance à Son timing.', 'L\'épreuve précède souvent l\'élévation.'],
      },
      'timeline': {
        'en': [
          {'year': 'Childhood', 'event': 'Sees the dream of eleven stars, the sun and the moon.'},
          {'year': 'Youth', 'event': 'Thrown into a well by his jealous brothers.'},
          {'year': 'Slavery', 'event': 'Sold into slavery in Egypt; serves the Aziz.'},
          {'year': 'Accusation', 'event': 'Falsely accused; imprisoned for years.'},
          {'year': 'Prison', 'event': 'Interprets dreams of fellow prisoners with accuracy.'},
          {'year': 'Famine', 'event': 'Interprets the king\'s dream and saves Egypt.'},
          {'year': 'Minister', 'event': 'Appointed high minister of Egypt.'},
          {'year': 'Reunion', 'event': 'Forgives his brothers; reunited with his father Yaqub.'},
          {'year': '~ 110 years', 'event': 'Passes away in Egypt as a prophet of Allah.'},
        ],
        'ar': [
          {'year': 'الطفولة', 'event': 'يرى رؤيا أحد عشر كوكباً والشمس والقمر.'},
          {'year': 'الشباب', 'event': 'يُلقى في الجب من إخوته الحاسدين.'},
          {'year': 'العبودية', 'event': 'يُباع عبداً في مصر ويخدم العزيز.'},
          {'year': 'الاتهام', 'event': 'يُتهم ظلماً ويُسجن سنوات.'},
          {'year': 'السجن', 'event': 'يفسر رؤى رفيقيه بدقة.'},
          {'year': 'المجاعة', 'event': 'يفسر رؤيا الملك وينقذ مصر.'},
          {'year': 'الوزارة', 'event': 'يُولى منصباً عالياً في مصر.'},
          {'year': 'اللقاء', 'event': 'يسامح إخوته ويلتقي بأبيه يعقوب.'},
          {'year': 'نحو ١١٠ سنة', 'event': 'يتوفى في مصر نبياً لله.'},
        ],
        'fr': [
          {'year': 'Enfance', 'event': 'Voit le rêve de onze étoiles, du soleil et de la lune.'},
          {'year': 'Jeunesse', 'event': 'Jeté dans un puits par ses frères jaloux.'},
          {'year': 'Esclavage', 'event': 'Vendu comme esclave en Égypte ; sert Al-Aziz.'},
          {'year': 'Accusation', 'event': 'Faussement accusé ; emprisonné pendant des années.'},
          {'year': 'Prison', 'event': 'Interprète les rêves de ses codétenus avec précision.'},
          {'year': 'Famine', 'event': 'Interprète le rêve du roi et sauve l\'Égypte.'},
          {'year': 'Ministre', 'event': 'Nommé haut ministre d\'Égypte.'},
          {'year': 'Réunion', 'event': 'Pardonne ses frères ; retrouve son père Yaqub.'},
          {'year': '~ 110 ans', 'event': 'Décède en Égypte comme prophète d\'Allah.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'Yusuf', 'surahArabic': 'يوسف', 'surahNumber': 12, 'verseNumber': 33, 'verseText': 'قَالَ رَبِّ السِّجْنُ أَحَبُّ إِلَيَّ مِمَّا يَدْعُونَنِي إِلَيْهِ', 'verseTranslation': 'He said: Prison is more preferable to me.'},
        ],
        'ar': [
          {'surahName': 'يوسف', 'surahArabic': 'يوسف', 'surahNumber': 12, 'verseNumber': 33, 'verseText': 'قَالَ رَبِّ السِّجْنُ أَحَبُّ إِلَيَّ مِمَّا يَدْعُونَنِي إِلَيْهِ', 'verseTranslation': 'قال رب السجن أحب إلي مما يدعونني إليه.'},
        ],
        'fr': [
          {'surahName': 'Youssouf', 'surahArabic': 'يوسف', 'surahNumber': 12, 'verseNumber': 33, 'verseText': 'قَالَ رَبِّ السِّجْنُ أَحَبُّ إِلَيَّ مِمَّا يَدْعُونَنِي إِلَيْهِ', 'verseTranslation': 'Il dit: Ô mon Seigneur, la prison m\'est préférable à ce à quoi elles m\'invitent.'},
        ],
      },
      'relatedProphetIds': ['yaqub', 'ishaq', 'ibrahim', 'musa'],
    },

    // ==================== YUNUS ====================
    {
      'id': 'yunus',
      'name': {'en': 'Prophet Yunus', 'ar': 'النبي يونس', 'fr': 'Prophète Younous'},
      'arabicName': 'يونس',
      'title': {'en': 'The Compassionate', 'ar': 'ذو النون', 'fr': 'L\'Homme à la Baleine'},
      'speciality': {'en': 'Preached to Nineveh - Entire nation believed', 'ar': 'ذو النون (صاحب الحوت) - النبي الذي آمن قومه جميعاً', 'fr': 'Seul prophète dont la nation entière a cru'},
      'lifespan': {'en': 'Approx. 800-700 BCE', 'ar': 'حوالي 800-700 قبل الميلاد', 'fr': 'Env. 800-700 av. J.-C.'},
      'birthPlace': {'en': 'Nineveh', 'ar': 'نينوى (العراق)', 'fr': 'Ninive'},
      'deathPlace': {'en': 'Nineveh', 'ar': 'منطقة نينوى', 'fr': 'Ninive'},
      'tribe': {'en': '', 'ar': '', 'fr': ''},
      'quranicName': {'en': 'Yunus', 'ar': 'يونس', 'fr': 'Yunus'},
      'ageAtDeath': 80,
      'mentionedInSurahs': 4,
      'isMajor': true,
      'imageUrl': 'assets/images/prophets/yunus.png',
      'description': {
        'en': 'Swallowed by a whale, he called to Allah from the depths — and his people were saved.',
        'ar': 'التقمه الحوت، فنادى ربه من الظلمات — ونجا قومه.',
        'fr': "Avale par une baleine, il appela Allah depuis les profondeurs — et son peuple fut sauvé.",
      },
      'fullDescription': {
        'en': 'Mission to Nineveh:\nProphet Yunus (Jonah) was sent to the corrupt city of Nineveh to call its inhabitants to worship Allah alone. However, the people stubbornly rejected his message and arrogantly mocked his warnings of impending divine punishment.\n\nDeparture & The Storm:\nDeeply frustrated with his people\'s refusal to listen, Yunus left the city before receiving explicit permission from Allah. He boarded a passenger ship. A fierce storm threatened to sink the vessel, and the superstitious crew drew lots to determine who was bringing bad luck. The lot fell on Yunus, leading to him being cast into the sea.\n\nThe Whale & Repentance:\nBy Allah\'s command, a massive whale swallowed Yunus whole. In the terrifying darkness of the whale\'s belly, Yunus realized his mistake. He turned to Allah in profound repentance: "There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers." Allah commanded the whale to safely eject him onto a shore.\n\nRedemption & Success:\nOnce recovered, he obediently returned to Nineveh. To his astonishment, the entire city had witnessed signs of the approaching punishment, repented en masse, and accepted faith. Allah spared them, making Yunus the only prophet whose entire nation believed and was saved.',
        'ar': 'الرسالة إلى نينوى:\nأُرسل النبي يونس (المُلقب بذي النون أي صاحب الحوت) إلى مدينة نينوى المزدهرة والفاسدة في آشور القديمة. دعا عشرات الآلاف من سكانها بحرارة لترك عبادة الأصنام والظلم، وعبادة الله وحده. لكن القوم رفضوا رسالته بعناد، وتمسكوا بضلالهم، واستهزأوا بتحذيراته من العذاب الإلهي القادم.\n\nالمغادرة والعاصفة:\nبسبب إحباطه الشديد وغضبه من رفض قومه، ارتكب يونس خطأً اجتهادياً حين غادر المدينة غاضباً قبل أن يتلقى الإذن الصريح من الله. استقل سفينة ركاب محملة، وسرعان ما هبت عاصفة هوجاء كادت أن تغرق السفينة. اقترح البحارة إجراء قرعة لتحديد الشخص "المشؤوم" الذي تسبب في هذه اللعنة، ووقعت القرعة على يونس ثلاث مرات، مما أدى إلى إلقائه في البحر الهائج.\n\nالحوت والتوبة:\nبأمر من الله، ابتلع حوت ضخم يونس عليه السلام دون أن يكسر له عظماً أو يخدش له لحماً. وفي ظلمات ثلاث (ظلمة الليل، وظلمة البحر، وظلمة بطن الحوت)، أدرك يونس خطأه. لجأ إلى الله بتوبة صادقة ودعاء عظيم: (لَّا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ). لصدق دعائه، أمر الله الحوت أن يلقيه على شاطئ مقفر بأمان.\n\nالنجاة والنجاح:\nكان يونس مريضاً وضعيفاً، فأنبت الله عليه شجرة من يقطين لتقيه وتغذيه. بعد تعافيه، عاد طائعاً إلى نينوى. ولدهشته الكبيرة، كان قومه قد رأوا بوادر العذاب فتابوا توبة جماعية وآمنوا إيماناً صادقاً. فكشف الله عنهم العذاب، ليكون يونس النبي الوحيد الذي آمن قومه بأكملهم، مما يبرز سعة رحمة الله وقوة التوبة الصادقة.',
        'fr': 'Mission à Ninive:\nLe Prophète Younous (Jonas) fut envoyé à la ville corrompue de Ninive pour appeler ses habitants à adorer Allah seul. Cependant, le peuple rejeta obstinément son message et se moqua de ses avertissements.\n\nDépart et la Tempête:\nFrustré par le refus de son peuple, Younous quitta la ville avant de recevoir la permission d\'Allah. Il embarqua sur un navire. Une violente tempête menaça de couler le vaisseau. L\'équipage tira au sort pour savoir qui portait malheur, et le sort tomba sur Younous, qui fut jeté à la mer.\n\nLa Baleine et le Repentir:\nSur l\'ordre d\'Allah, une énorme baleine avala Younous. Dans les ténèbres du ventre de la baleine, Younous réalisa son erreur. Il se tourna vers Allah avec un profond repentir : "Il n\'y a de divinité que Toi ; pureté à Toi. J\'ai été vraiment du nombre des injustes." Allah ordonna à la baleine de le rejeter en toute sécurité sur le rivage.\n\nRédemption et Succès:\nUne fois rétabli, il retourna à Ninive. À son grand étonnement, toute la ville avait vu les signes du châtiment, s\'était repentie en masse et avait accepté la foi. Allah les épargna, faisant de Younous le seul prophète dont la nation entière crut et fut sauvée.',
      },
      'keyAchievements': {
        'en': ['Called Nineveh to worship Allah', 'Repented sincerely during his trial in the whale', 'Succeeded in bringing his entire nation to belief'],
        'ar': ['دعا قوم نينوى لعبادة الله وحده', 'دعا بدعاء التوبة العظيم من بطن الحوت', 'أصبح النبي الوحيد الذي آمنت قريته بأكملها ونُزع عنهم العذاب', 'أظهر قوة الاستغفار في أشد الكروب'],
        'fr': ['A appelé Ninive à adorer Allah', 'S\'est repenti sincèrement lors de son épreuve', 'A réussi à amener toute sa nation à la foi'],
      },
      'miracles': {
        'en': ['Survived being swallowed by a great fish for three days.', 'His du\'a from the whale\'s belly was answered directly.', 'His entire nation believed and was saved from punishment.'],
        'ar': ['نجاته بعد أن التقمه حوت عظيم ثلاثة أيام.', 'استُجيب دعاؤه من بطن الحوت مباشرة.', 'آمن قومه جميعاً فنجوا من العذاب.'],
        'fr': ['Survécut après avoir été avalé par un grand poisson pendant trois jours.', 'Son invocation depuis le ventre de la baleine fut exaucée directement.', 'Toute sa nation crut et fut sauvée du châtiment.'],
      },
      'lessons': {
        'en': ['Never despair of Allah\'s mercy — help comes from the depths.', 'Do not abandon your duty out of frustration.', 'The du\'a of Yunus is a powerful remedy in times of distress.', 'Allah\'s mercy can reach a whole nation if they repent.', 'Even prophets make mistakes — return to Allah is always open.'],
        'ar': ['لا تيأس من رحمة الله، فالنصر يأتي من الأعماق.', 'لا تترك واجبك من الإحباط.', 'دعاء يونس دواء عظيم في أوقات الشدة.', 'رحمة الله تصل أمة كاملة إن تابت.', 'حتى الأنبياء يخطئون، والرجوع إلى الله مفتوح دائماً.'],
        'fr': ['Ne désespérez jamais de la miséricorde d\'Allah — l\'aide vient des profondeurs.', 'Ne pas abandonner son devoir par frustration.', 'L\'invocation de Yunus est un remède puissant dans la détresse.', 'La miséricorde d\'Allah peut atteindre toute une nation si elle se repent.', 'Même les prophètes font des erreurs — le retour à Allah est toujours ouvert.'],
      },
      'timeline': {
        'en': [
          {'year': 'Mission', 'event': 'Sent to the people of Nineveh.'},
          {'year': 'Da\'wah', 'event': 'Calls them to Tawheed for years; they reject.'},
          {'year': 'Departure', 'event': 'Leaves the city without Allah\'s permission.'},
          {'year': 'Ship', 'event': 'Storm arises; lots are drawn; thrown into the sea.'},
          {'year': 'Whale', 'event': 'Swallowed by a great fish; darkness of three layers.'},
          {'year': 'Du\'a', 'event': 'Calls out: "There is no deity except You."'},
          {'year': 'Rescue', 'event': 'Cast onto the shore; a gourd plant shades him.'},
          {'year': 'Return', 'event': 'Returns to Nineveh; his whole nation believed.'},
        ],
        'ar': [
          {'year': 'البعثة', 'event': 'يُرسل إلى أهل نينوى.'},
          {'year': 'الدعوة', 'event': 'يدعوهم للتوحيد سنوات فيرفضون.'},
          {'year': 'الخروج', 'event': 'يخرج من المدينة دون إذن الله.'},
          {'year': 'السفينة', 'event': 'تحدث العاصفة، وتُقترع، فيُلقى في البحر.'},
          {'year': 'الحوت', 'event': 'يلتقمه حوت عظيم، في ظلمات ثلاث.'},
          {'year': 'الدعاء', 'event': 'ينادي: لا إله إلا أنت سبحانك.'},
          {'year': 'النجاة', 'event': 'يُنبذ على الساحل وتظلله شجرة يقطين.'},
          {'year': 'العودة', 'event': 'يعود إلى نينوى فيؤمن قومه جميعاً.'},
        ],
        'fr': [
          {'year': 'Mission', 'event': 'Envoyé au peuple de Ninive.'},
          {'year': 'Da\'wah', 'event': 'Les appelle au Tawhid pendant des années ; ils rejettent.'},
          {'year': 'Départ', 'event': 'Quitte la ville sans la permission d\'Allah.'},
          {'year': 'Navire', 'event': 'Tempête ; tirage au sort ; jeté à la mer.'},
          {'year': 'Baleine', 'event': 'Avale par un grand poisson ; ténèbres de trois couches.'},
          {'year': 'Invocation', 'event': 'Appelle : « Il n\'y a de divinité que Toi. »'},
          {'year': 'Sauvetage', 'event': 'Rejeté sur le rivage ; une plante le couvre.'},
          {'year': 'Retour', 'event': 'Retourne à Ninive ; toute sa nation crut.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'As-Safat', 'surahArabic': 'الصافات', 'surahNumber': 37, 'verseNumber': 142, 'verseText': 'فَالْتَقَمَهُ الْحُوتُ وَهُوَ مُلِيمٌ', 'verseTranslation': 'So the fish took him while he was blaming himself.'},
        ],
        'ar': [
          {'surahName': 'الصافات', 'surahArabic': 'الصافات', 'surahNumber': 37, 'verseNumber': 142, 'verseText': 'فَالْتَقَمَهُ الْحُوتُ وَهُوَ مُلِيمٌ', 'verseTranslation': 'فالتقمه الحوت وهو مليم.'},
        ],
        'fr': [
          {'surahName': 'As-Safat', 'surahArabic': 'الصافات', 'surahNumber': 37, 'verseNumber': 142, 'verseText': 'فَالْتَقَمَهُ الْحُوتُ وَهُوَ مُلِيمٌ', 'verseTranslation': 'Le poisson l\'avala alors qu\'il était blâmable.'},
        ],
      },
      'relatedProphetIds': ['ayyub', 'musa', 'muhammad'],
    },

    // ==================== SULAYMAN ====================
    {
      'id': 'sulayman',
      'name': {'en': 'Prophet Sulaiman', 'ar': 'النبي سليمان', 'fr': 'Prophète Souleyman'},
      'arabicName': 'سليمان',
      'title': {'en': 'The Wise King', 'ar': 'الملك الحكيم', 'fr': 'Le Roi Sage'},
      'speciality': {'en': 'The Wise King - Understood languages of birds', 'ar': 'الملك الحكيم - سُخرت له الريح والجن', 'fr': 'Le Roi Sage - Comprenait les langages des animaux'},
      'lifespan': {'en': 'Approx. 970-935 BCE', 'ar': 'حوالي 970-935 قبل الميلاد', 'fr': 'Env. 970-935 av. J.-C.'},
      'birthPlace': {'en': 'Jerusalem', 'ar': 'القدس', 'fr': 'Jérusalem'},
      'deathPlace': {'en': 'Jerusalem', 'ar': 'القدس', 'fr': 'Jérusalem'},
      'tribe': {'en': 'Bani Israel', 'ar': 'بني إسرائيل', 'fr': "Banu Isra'il"},
      'quranicName': {'en': 'Sulaiman', 'ar': 'سليمان', 'fr': 'Sulayman'},
      'ageAtDeath': 53,
      'mentionedInSurahs': 16,
      'isMajor': true,
      'imageUrl': 'assets/images/prophets/sulaiman.png',
      'description': {
        'en': 'A prophet-king whose dominion extended over jinn, wind, birds and ants.',
        'ar': 'نبي ملك امتد ملكه على الجن والريح والطير والنمل.',
        'fr': "Un prophète-roi dont la domination s'étendait sur les djinns, le vent, les oiseaux et les fourmis.",
      },
      'fullDescription': {
        'en': 'Early Life & Ascension:\nProphet Sulaiman (Solomon) was the son and heir of Prophet Dawud (David). From a young age, he exhibited extraordinary wisdom and an exceptional sense of justice. Upon his father\'s passing, Sulaiman inherited both prophethood and the kingship of a vast empire.\n\nUnprecedented Kingdom & Miracles:\nSulaiman asked Allah for a kingdom that would never be granted to anyone after him. Allah answered this prayer, subjugating the forces of nature to his command. He was granted the ability to understand animals and birds. Allah placed the wind under his control and commanded legions of Jinn to serve him in constructing magnificent buildings.\n\nThe Queen of Sheba:\nOne of his famous encounters involved Bilqis, the sun-worshipping Queen of Sheba. Sulaiman sent her a letter inviting her to Islam. When she visited his majestic palace—featuring a brilliant floor of transparent glass—she was deeply humbled by his divinely granted power and submitted herself to Allah.\n\nLegacy & Passing:\nDespite his unimaginable wealth and power, Sulaiman remained a humble, grateful servant of Allah. His passing was a profound lesson: he died leaning on his staff observing the Jinn at work. They continued laboring for a year, unaware of his death until a termite ate through the staff.',
        'ar': 'النشأة وتولي المُلك:\nالنبي سليمان هو ابن ووريث النبي داود عليهما السلام. منذ صغره، أظهر حكمة استثنائية وحساً عميقاً بالعدل، وكثيراً ما كان يشارك والده في حل النزاعات القضائية المعقدة. بعد وفاة والده، ورث سليمان النبوة وملكاً عظيماً ومزدهراً.\n\nملك لا ينبغي لأحد من بعده:\nدعا سليمان ربه بدعاء فريد: (رَبِّ اغْفِرْ لِي وَهَبْ لِي مُلْكًا لَّا يَنبَغِي لِأَحَدٍ مِّن بَعْدِي). فاستجاب له الله، وسخّر له قوى الطبيعة وعالم الغيب. فقد مُنح معجزة فهم لغة الطيور والحيوانات والحشرات. وسخّر الله له الريح تحمله حيث يشاء، وسخّر له الجن والشياطين يبنون له القصور والمحاريب، ويغوصون في البحر لاستخراج اللآلئ.\n\nملكة سبأ (بلقيس):\nمن أشهر قصصه الدبلوماسية والدعوية لقاؤه ببلقيس، ملكة سبأ التي كان قومها يعبدون الشمس. بعد أن أبلغه طائر الهدهد عن مملكتها، أرسل لها كتاباً يدعوها للإسلام. وعندما زارت قصره المهيب - الذي تميز بصرح من قوارير (زجاج) يمر تحته الماء - أُذهلت بقوته وحكمته التي فاقت كل تصور بشري، وأعلنت إسلامها واستسلامها لله رب العالمين.\n\nإرث العدل والوفاة:\nرغم ثروته وقوته التي لم يسبق لها مثيل، ظل سليمان عبداً شكوراً وأواباً لله، مسخراً كل إمكانياته لإقامة العدل ونشر التوحيد. حتى وفاته كانت درساً عظيماً؛ فقد مات وهو متكئ على عصاه يراقب الجن وهم يعملون. استمروا في العمل الشاق لعام كامل وهم يظنونه حياً، حتى أكلت الأرضة (حشرة) عصاه فسقط، ليعلم الناس أن الجن لا يعلمون الغيب.',
        'fr': 'Ascension au Trône:\nLe Prophète Souleyman (Salomon) était le fils du Prophète Dawoud (David). Dès son jeune âge, il fit preuve d\'une sagesse extraordinaire et d\'un sens exceptionnel de la justice. À la mort de son père, il hérita à la fois de la prophétie et de la royauté.\n\nRoyaume Sans Précédent et Miracles:\nSouleyman demanda à Allah un royaume qui ne serait jamais accordé à personne après lui. Allah exauça cette prière, soumettant les forces de la nature à son commandement. Il reçut la capacité de comprendre les animaux et les oiseaux. Allah plaça le vent sous son contrôle et ordonna à des légions de djinns de le servir.\n\nLa Reine de Saba:\nL\'une de ses rencontres célèbres impliquait Bilqis, la reine de Saba, adoratrice du soleil. Souleyman l\'invita à l\'Islam. Lorsqu\'elle visita son majestueux palais, elle fut profondément humiliée par son pouvoir accordé par Dieu et se soumit à Allah.\n\nHéritage et Décès:\nMalgré sa richesse et son pouvoir inimaginables, Souleyman resta un serviteur humble d\'Allah. Son décès fut une profonde leçon : il mourut appuyé sur son bâton en observant les djinns au travail. Ils continuèrent à travailler pendant un an, ignorant sa mort jusqu\'à ce qu\'un termite ronge le bâton, prouvant que les djinns ne connaissent pas l\'invisible.',
      },
      'keyAchievements': {
        'en': ['Granted unprecedented kingdom and wisdom', 'Understood the language of birds and animals', 'Controlled the wind and Jinn by Allah\'s command', 'Brought the Queen of Sheba to Islam'],
        'ar': ['أُوتي ملكاً لم يؤته أحد من العالمين', 'عُلم منطق الطير ولغة الحيوانات', 'سُخرت له الرياح والجن بأمر الله', 'أقنع ملكة سبأ (بلقيس) وقومها بالتوحيد والإسلام', 'جمع بين السلطة الدنيوية المطلقة والعدل الإلهي'],
        'fr': ['A reçu un royaume et une sagesse sans précédent', 'Comprenait le langage des oiseaux et des animaux', 'Contrôlait le vent et les djinns par l\'ordre d\'Allah', 'A amené la Reine de Saba à l\'Islam'],
      },
      'miracles': {
        'en': ['Dominion over jinn, wind and animals by Allah\'s permission.', 'Understood the speech of birds and ants.', 'The wind carried him across great distances.', 'The jinn built for him palaces and grand structures.'],
        'ar': ['تسخير الجن والريح والحيوان بإذن الله.', 'فهم كلام الطير والنمل.', 'الريح تحمله مسافات بعيدة.', 'الجن يبنون له القصور والصروح.'],
        'fr': ['Domination sur les djinns, le vent et les animaux par permission d\'Allah.', 'Comprenait le langage des oiseaux et des fourmis.', 'Le vent le portait sur de grandes distances.', 'Les djinns lui construisaient des palais et de grandes structures.'],
      },
      'lessons': {
        'en': ['Great power and wealth are tests from Allah, not signs of His pleasure.', 'Every blessing should inspire gratitude, not arrogance.', 'Wisdom in judgement is a gift from Allah.', 'Even with immense power, Sulayman remained a humble servant.', 'The message of Tawheed reaches all — even queens and jinn.'],
        'ar': ['الملك العظيم والمال ابتلاء من الله لا دليل على رضاه.', 'كل نعمة يجب أن تُلهم الشكر لا الكبر.', 'الحكمة في القضاء هبة من الله.', 'رغم قوته الهائلة بقي سليمان عبداً متواضعاً.', 'رسالة التوحيد تصل للجميع — حتى الملوك والجن.'],
        'fr': ['Le grand pouvoir et la richesse sont des épreuves d\'Allah, non des signes de Son plaisir.', 'Chaque bénédiction doit inspirer la gratitude, non l\'orgueil.', 'La sagesse dans le jugement est un don d\'Allah.', 'Même avec un pouvoir immense, Sulayman resta un humble serviteur.', 'Le message du Tawhid atteint tous — même les reines et les djinns.'],
      },
      'timeline': {
        'en': [
          {'year': 'Youth', 'event': 'Son of Dawud; learns prophethood and kingship.'},
          {'year': 'Succession', 'event': 'Becomes prophet-king after his father\'s death.'},
          {'year': 'Du\'a', 'event': 'Asks Allah for an unmatched kingdom; it is granted.'},
          {'year': 'Reign', 'event': 'Rules over jinn, men, birds and wind.'},
          {'year': 'Bilqis', 'event': 'Invites the Queen of Sheba to Islam; she accepts.'},
          {'year': '~ 53 years', 'event': 'Passes away while leaning on his staff; jinn unaware.'},
        ],
        'ar': [
          {'year': 'الشباب', 'event': 'ابن داود يتعلم النبوة والملك.'},
          {'year': 'الخلافة', 'event': 'يصبح نبياً ملكاً بعد وفاة أبيه.'},
          {'year': 'الدعاء', 'event': 'يسأل الله ملكاً لا ينبغي لأحد، فيُعطاه.'},
          {'year': 'الحكم', 'event': 'يحكم على الجن والإنس والطير والريح.'},
          {'year': 'بلقيس', 'event': 'يدعو ملكة سبأ للإسلام فتُسلم.'},
          {'year': 'نحو ٥٣ سنة', 'event': 'يتوفى متكئاً على عصاه والجن لا تشعر.'},
        ],
        'fr': [
          {'year': 'Jeunesse', 'event': 'Fils de Dawud ; apprend la prophétie et la royauté.'},
          {'year': 'Succession', 'event': 'Devient prophète-roi après la mort de son père.'},
          {'year': 'Invocation', 'event': 'Demande à Allah un royaume inégalé ; il est accordé.'},
          {'year': 'Règne', 'event': 'Règne sur les djinns, les hommes, les oiseaux et le vent.'},
          {'year': 'Bilqis', 'event': 'Invite la Reine de Saba à l\'Islam ; elle accepte.'},
          {'year': '~ 53 ans', 'event': 'Décède appuyé sur son bâton ; les djinns ignorent.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'An-Naml', 'surahArabic': 'النمل', 'surahNumber': 27, 'verseNumber': 16, 'verseText': 'وَوَرِثَ سُلَيْمَانُ دَاوُودَ ۖ وَقَالَ يَا أَيُّهَا النَّاسُ عُلِّمْنَا مَنطِقَ الطَّيْرِ', 'verseTranslation': 'Sulaiman inherited from Dawud and said: We have been taught the language of birds.'},
        ],
        'ar': [
          {'surahName': 'النمل', 'surahArabic': 'النمل', 'surahNumber': 27, 'verseNumber': 16, 'verseText': 'وَوَرِثَ سُلَيْمَانُ دَاوُودَ ۖ وَقَالَ يَا أَيُّهَا النَّاسُ عُلِّمْنَا مَنطِقَ الطَّيْرِ', 'verseTranslation': 'وورث سليمان داود وقال يا أيها الناس علمنا منطق الطير.'},
        ],
        'fr': [
          {'surahName': 'An-Naml', 'surahArabic': 'النمل', 'surahNumber': 27, 'verseNumber': 16, 'verseText': 'وَوَرِثَ سُلَيْمَانُ دَاوُودَ ۖ وَقَالَ يَا أَيُّهَا النَّاسُ عُلِّمْنَا مَنطِقَ الطَّيْرِ', 'verseTranslation': 'Salomon hérita de David et dit: Ô hommes! On nous a appris le langage des oiseaux.'},
        ],
      },
      'relatedProphetIds': ['dawud', 'musa', 'isa'],
    },

    // ==================== LUQMAN ====================
    {
      'id': 'luqman',
      'name': {'en': 'Luqman', 'ar': 'لقمان الحكيم', 'fr': 'Luqman'},
      'arabicName': 'لقمان',
      'title': {'en': 'The Wise Man', 'ar': 'رمز الحكمة', 'fr': 'Le Sage'},
      'speciality': {'en': 'The Wise Man - Moral teacher', 'ar': 'الحكيم والمربي - صاحب الوصايا الخالدة', 'fr': 'Le Sage - Modèle d\'enseignant moral'},
      'lifespan': {'en': 'Approx. 750 BCE', 'ar': 'حوالي 750 قبل الميلاد', 'fr': 'Env. 750 av. J.-C.'},
      'birthPlace': {'en': 'Unknown', 'ar': 'غير محدد', 'fr': 'Inconnu'},
      'deathPlace': {'en': 'Unknown', 'ar': 'غير محدد', 'fr': 'Inconnu'},
      'tribe': {'en': '', 'ar': '', 'fr': ''},
      'quranicName': {'en': 'Luqman', 'ar': 'لقمان', 'fr': 'Luqman'},
      'ageAtDeath': 0,
      'mentionedInSurahs': 1,
      'isMajor': false,
      'imageUrl': 'assets/images/prophets/luqman.png',
      'description': {
        'en': 'A wise man whose timeless advice to his son is preserved in the Quran.',
        'ar': 'رجل حكيم خلد القرآن وصاياه الخالدة لابنه.',
        'fr': 'Un sage dont les conseils intemporels à son fils sont préservés dans le Coran.',
      },
      'fullDescription': {
        'en': 'Identity & Background:\nLuqman, known as Luqman the Wise, is a highly revered figure. While consensus leans towards him being a righteous sage rather than a formal prophet, his moral teachings are forever preserved in the Quran. Traditions suggest he was a humble man who worked as a carpenter or shepherd. His profound intellect elevated him far above his worldly status.\n\nThe Gift of Wisdom:\nThe Quran states that Allah bestowed "Hikmah" (profound wisdom) upon Luqman. This divine wisdom was characterized by a deep understanding of life\'s realities and constant gratitude to the Creator. He was known for his highly eloquent speech and impeccable character.\n\nTeachings to His Son:\nLuqman\'s enduring legacy is immortalized in the 31st chapter of the Quran. He imparted beautiful, comprehensive advice to his son, beginning with a strict prohibition of Shirk (associating partners with Allah). He commanded his son to establish prayer, enjoin good, forbid evil, and bear life\'s trials with patience.\n\nSocial Ethics & Legacy:\nFurthermore, Luqman\'s advice laid out a perfect blueprint for social conduct. He warned against arrogance, advising his son to walk upon the earth with humility and to lower his voice. Luqman serves as the ultimate Quranic model for parenting and moral guidance.',
        'ar': 'الهوية والخلفية:\nلقمان الحكيم هو شخصية مبجلة جداً في التراث الإسلامي. يميل إجماع العلماء إلى أنه كان عبداً صالحاً وحكيماً وليس نبياً يتلقى الوحي بالمعنى التقليدي، إلا أن تعاليمه ومواعظه الأخلاقية خُلدت في القرآن الكريم. تشير الروايات إلى أنه كان رجلاً متواضعاً، ربما من أصول نوبية أو حبشية، عمل نجاراً أو راعياً. لكن رجاحة عقله وبصيرته الروحية رفعته فوق أي مكانة دنيوية.\n\nهبة الحكمة:\nينص القرآن صراحة على أن الله آتى لقمان "الحكمة". تجلت هذه الحكمة في الفهم العميق والراسخ لطبائع الأمور، والشكر الدائم للخالق، والقدرة الفذة على صياغة الحقائق الأخلاقية المعقدة بكلمات بسيطة ومؤثرة. عُرف بين قومه بكلامه البليغ، وصمته الطويل المتأمل، وأخلاقه التي لا تشوبها شائبة.\n\nوصاياه لابنه:\nيتجلى إرث لقمان الخالد في السورة القرآنية التي تحمل اسمه (سورة لقمان). السورة تستعرض الوصايا العظيمة والرحيمة التي وجهها لابنه. بدأ بالأصل الأهم للوجود: التحذير الشديد من الشرك بالله ووصفه بالظلم العظيم. ثم نسج ببراعة بين الأخلاق الروحية والاجتماعية، آمراً ابنه بإقامة الصلاة، والأمر بالمعروف، والنهي عن المنكر، والصبر على الشدائد.\n\nالأخلاق الاجتماعية والإرث:\nعلاوة على ذلك، وضعت وصايا لقمان خريطة طريق مثالية للسلوك الاجتماعي. حذر بشدة من التكبر، ناصحاً ابنه بعدم تصعير خده للناس (عدم التكبر عليهم)، والمشي في الأرض بتواضع، وخفض الصوت. من خلال هذه التوجيهات الخالدة، يمثل لقمان النموذج القرآني الأمثل للتربية، مؤكداً أن النجاح الحقيقي يكمن في تنشئة أجيال تتحلى بالتوحيد والتواضع وحسن الخلق.',
        'fr': 'Identité et Background:\nLuqman, connu sous le nom de Luqman le Sage, est une figure hautement vénérée. Bien que le consensus penche vers le fait qu\'il était un serviteur juste plutôt qu\'un prophète formel, ses enseignements moraux sont à jamais préservés dans le Coran.\n\nLe Don de la Sagesse:\nLe Coran déclare qu\'Allah a accordé "Hikmah" (la sagesse profonde) à Luqman. Cette sagesse divine se caractérisait par une compréhension profonde des réalités de la vie et une gratitude constante envers le Créateur.\n\nEnseignements à son Fils:\nL\'héritage durable de Luqman est immortalisé dans le 31e chapitre du Coran. Il a transmis des conseils magnifiques et complets à son fils, commençant par une stricte interdiction du Shirk (associer des partenaires à Allah). Il lui ordonna d\'établir la prière et d\'endurer les épreuves avec patience.\n\nÉthique Sociale:\nDe plus, les conseils de Luqman ont établi un modèle parfait de conduite sociale. Il a mis en garde contre l\'arrogance, conseillant à son fils de marcher sur terre avec humilité et de baisser la voix. Luqman sert de modèle coranique ultime pour la parentalité.',
      },
      'keyAchievements': {
        'en': ['Preserved moral teachings in the Quran', 'Provided exemplary parental guidance', 'Emphasized monotheism and gratitude', 'Advocated for justice and kindness'],
        'ar': ['خلد القرآن الكريم مواعظه وحكمته في سورة تحمل اسمه', 'قدم النموذج الأمثل لنصائح الآباء للأبناء', 'رسخ مبادئ التوحيد والشكر', 'دعا إلى مكارم الأخلاق كالتواضع وغض الصوت'],
        'fr': ['A préservé des enseignements moraux dans le Coran', 'A fourni une guidance parentale exemplaire', 'A mis l\'accent sur le monothéisme et la gratitude', 'A plaidé pour la justice et la gentillesse'],
      },
      'miracles': {
        'en': ['His wisdom itself was a gift from Allah, preserved forever in the Quran.'],
        'ar': ['حكمته نفسها كانت هبة من الله، محفوظة إلى الأبد في القرآن.'],
        'fr': ['Sa sagesse elle-même était un don d\'Allah, préservé à jamais dans le Coran.'],
      },
      'lessons': {
        'en': ['True wisdom lies in recognizing Allah and being grateful.', 'Parenting is a sacred duty that requires patience and wisdom.', 'Humility and soft speech are signs of true strength.', 'Avoiding Shirk is the foundation of all moral conduct.'],
        'ar': ['الحكمة الحقيقية تكمن في معرفة الله والشكر له.', 'التربية واجب مقدس يتطلب الصبر والحكمة.', 'التواضع وخفض الصوت من علامات القوة الحقيقية.', 'اجتناب الشرك هو أساس كل سلوك أخلاقي.'],
        'fr': ['La vraie sagesse réside dans la reconnaissance d\'Allah et la gratitude.', 'L\'éducation des enfants est un devoir sacré qui exige patience et sagesse.', 'L\'humilité et la douceur de la parole sont des signes de vraie force.', 'Éviter le Shirk est le fondement de toute conduite morale.'],
      },
      'timeline': {
        'en': [
          {'year': 'Early life', 'event': 'A humble carpenter or shepherd.'},
          {'year': 'Wisdom', 'event': 'Granted profound wisdom (Hikmah) by Allah.'},
          {'year': 'Teaching', 'event': 'Imparts timeless advice to his son.'},
          {'year': 'Legacy', 'event': 'His teachings are immortalized in Surah Luqman.'},
        ],
        'ar': [
          {'year': 'بداية حياته', 'event': 'نجار أو راعٍ متواضع.'},
          {'year': 'الحكمة', 'event': 'أُعطي الحكمة العظيمة من الله.'},
          {'year': 'التعليم', 'event': 'يقدم نصائح خالدة لابنه.'},
          {'year': 'الإرث', 'event': 'تخلد تعاليمه في سورة لقمان.'},
        ],
        'fr': [
          {'year': 'Début', 'event': 'Un humble charpentier ou berger.'},
          {'year': 'Sagesse', 'event': 'Reçoit une sagesse profonde (Hikmah) d\'Allah.'},
          {'year': 'Enseignement', 'event': 'Transmet des conseils intemporels à son fils.'},
          {'year': 'Héritage', 'event': 'Ses enseignements sont immortalisés dans la sourate Luqman.'},
        ],
      },
      'quranicMentions': {
        'en': [
          {'surahName': 'Luqman', 'surahArabic': 'لقمان', 'surahNumber': 31, 'verseNumber': 13, 'verseText': 'وَإِذْ قَالَ لُقْمَانُ لِابْنِهِ وَهُوَ يَعِظُهُ يَا بُنَيَّ لَا تُشْرِكْ بِاللَّهِ', 'verseTranslation': 'And when Luqman said to his son while he was instructing him: O my son, do not associate partners with Allah.'},
        ],
        'ar': [
          {'surahName': 'لقمان', 'surahArabic': 'لقمان', 'surahNumber': 31, 'verseNumber': 13, 'verseText': 'وَإِذْ قَالَ لُقْمَانُ لِابْنِهِ وَهُوَ يَعِظُهُ يَا بُنَيَّ لَا تُشْرِكْ بِاللَّهِ', 'verseTranslation': 'وإذ قال لقمان لابنه وهو يعظه يا بني لا تشرك بالله.'},
        ],
        'fr': [
          {'surahName': 'Luqman', 'surahArabic': 'لقمان', 'surahNumber': 31, 'verseNumber': 13, 'verseText': 'وَإِذْ قَالَ لُقْمَانُ لِابْنِهِ وَهُوَ يَعِظُهُ يَا بُنَيَّ لَا تُشْرِكْ بِاللَّهِ', 'verseTranslation': 'Et lorsque Luqman dit à son fils tout en l\'exhortant: Ô mon fils, ne donne pas d\'associé à Allah.'},
        ],
      },
      'relatedProphetIds': ['dawud', 'sulayman'],
    },
  ];
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}