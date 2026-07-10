class ProphetBiography {
  final String name;
  final String arabicName;
  final String title;
  final String lifespan;
  final String birthPlace;
  final String deathPlace;
  final String description; 
  final List<String> keyAchievements;
  final List<QuranicMention> quranicMentions;
  final String speciality; 
  final String imageUrl; 
  final int mentionedInSurahs; 

  ProphetBiography({
    required this.name, required this.arabicName, required this.title, required this.lifespan,
    required this.birthPlace, required this.deathPlace, required this.description,
    required this.keyAchievements, required this.quranicMentions, required this.speciality,
    required this.imageUrl, required this.mentionedInSurahs,
  });
}

class QuranicMention {
  final String surahName;
  final String surahArabic;
  final int surahNumber;
  final int verseNumber;
  final String verseText;
  final String verseTranslation;

  QuranicMention({
    required this.surahName, required this.surahArabic, required this.surahNumber,
    required this.verseNumber, required this.verseText, required this.verseTranslation,
  });
}

class ProphetBiographyService {
  static final ProphetBiographyService _instance = ProphetBiographyService._internal();
  factory ProphetBiographyService() => _instance;
  ProphetBiographyService._internal();

  List<ProphetBiography> getAllProphets(String langCode) {
    if (langCode == 'ar') return _getProphetsAr();
    if (langCode == 'fr') return _getProphetsFr();
    return _getProphetsEn();
  }

  ProphetBiography? getProphetByName(String name, String langCode) {
    try {
      return getAllProphets(langCode).firstWhere((p) => p.name.toLowerCase() == name.toLowerCase());
    } catch (e) { return null; }
  }

  List<ProphetBiography> searchProphets(String query, String langCode) {
    return getAllProphets(langCode).where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase()) ||
      p.arabicName.contains(query) || p.speciality.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // ==========================================
  // ENGLISH TRANSLATIONS
  // ==========================================
  List<ProphetBiography> _getProphetsEn() {
    return [
      ProphetBiography(
        name: 'Prophet Muhammad', arabicName: 'محمد', title: 'The Final Messenger', lifespan: '570 - 632 CE', birthPlace: 'Mecca', deathPlace: 'Medina',
        description: 'Early Life & Background:\nBorn in Mecca in the Year of the Elephant (570 CE), Prophet Muhammad (peace be upon him) was orphaned at a young age. Raised by his grandfather Abdul Muttalib and later his uncle Abu Talib, he became known throughout Mecca for his impeccable honesty, earning the titles Al-Amin (The Trustworthy) and As-Sadiq (The Truthful).\n\nProphethood & Revelation:\nAt the age of 40, while seeking spiritual retreat in the Cave of Hira, he received the first revelation of the Quran through the Angel Jibreel (Gabriel). For 13 years in Mecca, he faced severe persecution, physical abuse, and social boycotts from the Quraysh elite as he tirelessly called people to monotheism (Tawhid), social justice, and moral uprightness.\n\nMigration & Establishment:\nIn 622 CE, following divine instruction, he migrated to Medina (the Hijra), an event that marks the beginning of the Islamic calendar. In Medina, he established a just and unified Islamic society, bringing together warring tribes under a groundbreaking constitution of peace.\n\nLegacy & Passing:\nOver 23 years, the complete Quran was revealed. Before his passing in 632 CE, he performed the Farewell Pilgrimage, delivering a timeless sermon emphasizing equality, human rights, and piety. He left behind the Quran and his Sunnah, completing the religion of Islam as the final messenger to mankind.',
        keyAchievements: ['Received the complete Quran over 23 years', 'Established the Islamic state in Medina', 'United the Arabian tribes under Islam', 'Set the example for Islamic life through Sunnah', 'Performed the Farewell Hajj'],
        quranicMentions: [
          QuranicMention(surahName: 'Al-Ahzab', surahArabic: 'الأحزاب', surahNumber: 33, verseNumber: 40, verseText: 'ما كان محمد أبا أحد من رجالكم', verseTranslation: 'Muhammad is not the father of any of your men'),
          QuranicMention(surahName: 'Al-Anbiya', surahArabic: 'الأنبياء', surahNumber: 21, verseNumber: 107, verseText: 'وما أرسلناك إلا رحمة للعالمين', verseTranslation: 'We have sent you not but as a mercy to the worlds'),
        ],
        speciality: 'The Seal of the Prophets - Final messenger of Allah', imageUrl: 'assets/images/prophets/muhammad.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'Prophet Ibrahim', arabicName: 'إبراهيم', title: 'The Friend of Allah', lifespan: 'Approx. 2165 - 2040 BCE', birthPlace: 'Ur of the Chaldees', deathPlace: 'Canaan',
        description: 'Early Life & Background:\nProphet Ibrahim (Abraham) was born in a society deeply rooted in idolatry and polytheism. Despite his father Azar being a renowned sculptor of idols, Ibrahim was blessed with innate reasoning and divine guidance from a young age. He rejected the worship of celestial bodies and statues, recognizing that the true Creator must be eternal.\n\nProphetic Mission & Trials:\nHe dedicated his life to calling his people to the absolute oneness of Allah (Tawhid). When he boldly destroyed their temple idols, he was sentenced to be cast into a blazing fire by King Nimrod. However, Allah miraculously commanded the fire to be cool and peaceful for him, saving him entirely.\n\nThe Ultimate Sacrifice & Legacy:\nHis greatest test came years later when Allah commanded him in a dream to sacrifice his beloved son Ismail. Both father and son submitted willingly. Just as he was about to fulfill the command, Allah replaced Ismail with a ram, establishing the tradition of Udhiyah and Hajj. Along with Ismail, he later rebuilt the Kaaba.\n\nStatus in Islam:\nRevered as "Khalil-ullah" (The Friend of Allah) and the patriarch of monotheism, his profound submission makes him one of the greatest prophets in Islam.',
        keyAchievements: ['Called people to monotheism', 'Built the Kaaba with his son Ismail', 'Established the tradition of Hajj', 'Demonstrated perfect submission to Allah', 'Passed all of Allah\'s trials'],
        quranicMentions: [
          QuranicMention(surahName: 'Al-Baqarah', surahArabic: 'البقرة', surahNumber: 2, verseNumber: 124, verseText: 'وإذ ابتلى إبراهيم ربه بكلمات فأتمهن', verseTranslation: 'And when Ibrahim was tested by his Lord with commands, he fulfilled them'),
        ],
        speciality: 'Friend of Allah - Built the Kaaba', imageUrl: 'assets/images/prophets/ibrahim.png', mentionedInSurahs: 25,
      ),
      ProphetBiography(
        name: 'Prophet Musa', arabicName: 'موسى', title: 'The Interlocutor', lifespan: 'Approx. 1393 - 1273 BCE', birthPlace: 'Egypt', deathPlace: 'Mount Sinai area',
        description: 'Birth & Early Life:\nProphet Musa (Moses) was born in Egypt during a brutal era when the Pharaoh ordered the execution of newborn Israelite boys. His mother was divinely inspired to place him in a basket on the Nile. Miraculously, he was adopted by Pharaoh\'s own righteous wife, Asiya, allowing him to be raised in the royal palace.\n\nProphethood & The Divine Call:\nAfter fleeing to Midian for several years, Musa experienced a profound divine encounter at Mount Tur (Sinai). Allah spoke directly to him from a burning bush, granting him prophethood and monumental miracles—such as his staff turning into a serpent. He was commanded to return to Egypt to liberate the Children of Israel.\n\nConfrontation & Exodus:\nMusa fiercely confronted Pharaoh\'s tyranny and defeated his greatest magicians. When Pharaoh rejected multiple plagues sent as warnings, Musa led the Israelites in a midnight exodus. Pursued by Pharaoh\'s army, Allah parted the Red Sea, saving Musa while drowning the tyrannical ruler.\n\nGuidance & Legacy:\nMusa received the Tawrat (Torah) containing divine laws on Mount Sinai. Known as "Kalim-ullah" (The One who spoke directly to Allah), he remains the most frequently mentioned prophet in the entire Quran.',
        keyAchievements: ['Received the Torah with divine commandments', 'Performed miraculous signs before Pharaoh', 'Led the Israelites out of Egypt', 'Communicated directly with Allah'],
        quranicMentions: [
          QuranicMention(surahName: 'Al-Qasas', surahArabic: 'القصص', surahNumber: 28, verseNumber: 30, verseText: 'يا موسى إني أنا الله رب العالمين', verseTranslation: 'O Musa! Indeed, I am Allah, the Lord of the worlds'),
        ],
        speciality: 'The Interlocutor - Spoke directly with Allah', imageUrl: 'assets/images/prophets/musa.png', mentionedInSurahs: 36,
      ),
      ProphetBiography(
        name: 'Prophet Isa', arabicName: 'عيسى', title: 'The Spirit of Allah', lifespan: 'Approx. 1 - 33 CE', birthPlace: 'Bethlehem', deathPlace: 'Heavens',
        description: 'Miraculous Birth:\nProphet Isa (Jesus) was conceived through a profound miracle, born to the deeply righteous and virgin Maryam (Mary) without a human father. The Quran details that he was created by the direct command of Allah. As a newborn infant, he miraculously spoke from the cradle to defend his mother\'s honor.\n\nProphetic Mission & Miracles:\nIsa was sent to the Children of Israel to confirm the Torah and bring a new scripture, the Injil (Gospel). By Allah\'s explicit permission, he healed the blind, cured lepers, and raised the dead. He called people back to pure monotheism, emphasizing spiritual sincerity.\n\nChallenges & Ascension:\nDespite his clear signs, he faced severe opposition from the religious elite. When they conspired to crucify him, the Quran explicitly states that they neither killed him nor crucified him. Instead, Allah made it appear so to them, and raised Isa up to Himself.\n\nIslamic Perspective & Return:\nIsa is highly revered in Islam as "Ruh-ullah" (The Spirit of Allah). The Quran completely rejects the notion of his divinity. Islamic eschatology holds that he will physically return to earth before the Day of Judgment to restore justice and defeat the false messiah.',
        keyAchievements: ['Born miraculously without a father', 'Performed miraculous signs by Allah\'s permission', 'Received the Gospel (Injil)', 'Called people to worship Allah alone'],
        quranicMentions: [
          QuranicMention(surahName: 'Maryam', surahArabic: 'مريم', surahNumber: 19, verseNumber: 34, verseText: 'ذلك عيسى ابن مريم قول الحق الذي فيه يمترون', verseTranslation: 'That is Isa, son of Maryam, concerning whom they dispute'),
        ],
        speciality: 'Born miraculously - The Spirit of Allah', imageUrl: 'assets/images/prophets/isa.png', mentionedInSurahs: 15,
      ),
      ProphetBiography(
        name: 'Prophet Nuh', arabicName: 'نوح', title: 'The First Messenger', lifespan: 'Approx. 2900+ years', birthPlace: 'Unknown', deathPlace: 'Unknown',
        description: 'Early Life & Society:\nProphet Nuh (Noah) was one of the earliest messengers sent by Allah. He lived in a time when people had deviated far from monotheism, falling into the worship of idols. His society was deeply entrenched in ignorance and polytheism.\n\nUnwavering Mission:\nFor an astonishing 950 years, Nuh tirelessly called his people back to the worship of the One True God. Despite his immense patience and centuries of dedication, only a very small group of people believed in his message, while the tribal elite relentlessly mocked and threatened him.\n\nThe Ark & The Great Flood:\nWhen it became clear that no one else would believe, Allah commanded Nuh to construct a massive Ark. As he built it, his people continued to ridicule him. Upon Allah\'s command, pairs of animals and the devoted believers boarded the ship. A global flood ensued, drowning all the disbelievers.\n\nLegacy & Status:\nTragically, among those who drowned was Nuh\'s own son, who refused to join the believers. Nuh is recognized as the first of the "Ulul-Azm" (Prophets of Strong Resolve). His life stands as the ultimate symbol of perseverance.',
        keyAchievements: ['First messenger sent to mankind', 'Preached for 950 years without success', 'Built the ark on Allah\'s command', 'Saved believers from the Great Flood'],
        quranicMentions: [
          QuranicMention(surahName: 'Nuh', surahArabic: 'نوح', surahNumber: 71, verseNumber: 1, verseText: 'إنا أرسلنا نوحا إلى قومه أن أنذر قومك', verseTranslation: 'Indeed, We sent Nuh to his people saying: Warn your people'),
        ],
        speciality: 'First Messenger - Preached 950 years', imageUrl: 'assets/images/prophets/nuh.png', mentionedInSurahs: 28,
      ),
      ProphetBiography(
        name: 'Prophet Ayub', arabicName: 'أيوب', title: 'The Patient One', lifespan: 'Approx. 2000 BCE', birthPlace: 'Levant', deathPlace: 'Levant',
        description: 'Early Life & Prosperity:\nProphet Ayub (Job) was initially blessed with immense wealth, expansive lands, and a large family. He was a highly respected leader known for his deep piety, extreme generosity to the poor, and constant gratitude to Allah.\n\nThe Great Trial:\nTo demonstrate the purity of Ayub\'s faith, Allah subjected him to a severe test. Ayub lost all his wealth, his property was destroyed, and his children perished. He was also afflicted with a painful illness that ravaged his body, causing his community to abandon him. His heart remained steadfastly attached to Allah.\n\nPatience & Sincerity:\nFor years, Ayub endured unimaginable suffering without a single complaint. He was abandoned by everyone except his devoted wife. When he finally called out to Allah, his prayer was remarkably humble: "Indeed, adversity has touched me, and You are the Most Merciful of the merciful."\n\nRestoration & Legacy:\nAllah answered his sincere supplication, commanding him to strike the ground with his foot. A miraculous spring gushed forth; washing in it cured him completely. Allah restored his youth, returned his wealth manifold, and granted him a new family. Ayub remains the eternal archetype of patience.',
        keyAchievements: ['Remained patient through severe trials', 'Maintained faith despite loss of health and wealth', 'Received complete restoration after trials'],
        quranicMentions: [
          QuranicMention(surahName: 'Al-Anbiya', surahArabic: 'الأنبياء', surahNumber: 21, verseNumber: 83, verseText: 'وأيوب إذ نادى ربه أني مسني الضر وأنت أرحم الراحمين', verseTranslation: 'And Ayub, when he called to his Lord: Indeed, adversity has touched me'),
        ],
        speciality: 'The Patient One - Exemplar of patience', imageUrl: 'assets/images/prophets/ayub.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'Prophet Yusuf', arabicName: 'يوسف', title: 'The Handsome One', lifespan: 'Approx. 2100-2000 BCE', birthPlace: 'Canaan', deathPlace: 'Egypt',
        description: 'Birth & Betrayal:\nProphet Yusuf (Joseph) was the beloved son of Prophet Yaqub (Jacob). Blessed with exceptional physical beauty and profound dreams, he became the target of his brothers\' jealousy. They maliciously threw him into a well. Rescued by a passing caravan, he was sold into slavery in Egypt.\n\nTrials & Imprisonment:\nPurchased by an Egyptian minister, Yusuf grew into a righteous man. The minister\'s wife attempted to seduce him, but Yusuf firmly resisted. To protect his honor, he chose unjust imprisonment, spending years in a dungeon where he continued to preach monotheism and accurately interpret dreams.\n\nRise to Power:\nYusuf\'s divinely inspired interpretation of the King\'s dream—about an impending seven-year famine—secured his release. Recognizing his administrative brilliance, the King appointed him as the chief minister of finance. Yusuf managed Egypt\'s resources, saving the region from starvation.\n\nReunion & Forgiveness:\nDuring the famine, his brothers traveled to Egypt seeking rations. After a series of tests, Yusuf revealed himself and forgave his brothers completely for their past betrayal. He reunited with his father, fulfilling his childhood dream.',
        keyAchievements: ['Maintained chastity despite temptation', 'Rose from slave to minister of Egypt', 'Forgave his brothers who betrayed him', 'Saved the region from a severe famine'],
        quranicMentions: [
          QuranicMention(surahName: 'Yusuf', surahArabic: 'يوسف', surahNumber: 12, verseNumber: 33, verseText: 'قال رب السجن أحب إلي', verseTranslation: 'He said: Prison is more preferable to me'),
        ],
        speciality: 'The Handsome One - Model of chastity', imageUrl: 'assets/images/prophets/yusuf.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'Prophet Yunus', arabicName: 'يونس', title: 'The Compassionate', lifespan: 'Approx. 800-700 BCE', birthPlace: 'Nineveh', deathPlace: 'Nineveh',
        description: 'Mission to Nineveh:\nProphet Yunus (Jonah) was sent to the corrupt city of Nineveh to call its inhabitants to worship Allah alone. However, the people stubbornly rejected his message and arrogantly mocked his warnings of impending divine punishment.\n\nDeparture & The Storm:\nDeeply frustrated with his people\'s refusal to listen, Yunus left the city before receiving explicit permission from Allah. He boarded a passenger ship. A fierce storm threatened to sink the vessel, and the superstitious crew drew lots to determine who was bringing bad luck. The lot fell on Yunus, leading to him being cast into the sea.\n\nThe Whale & Repentance:\nBy Allah\'s command, a massive whale swallowed Yunus whole. In the terrifying darkness of the whale\'s belly, Yunus realized his mistake. He turned to Allah in profound repentance: "There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers." Allah commanded the whale to safely eject him onto a shore.\n\nRedemption & Success:\nOnce recovered, he obediently returned to Nineveh. To his astonishment, the entire city had witnessed signs of the approaching punishment, repented en masse, and accepted faith. Allah spared them, making Yunus the only prophet whose entire nation believed and was saved.',
        keyAchievements: ['Called Nineveh to worship Allah', 'Repented sincerely during his trial in the whale', 'Succeeded in bringing his entire nation to belief'],
        quranicMentions: [
          QuranicMention(surahName: 'As-Safat', surahArabic: 'الصافات', surahNumber: 37, verseNumber: 142, verseText: 'فالتقمه الحوت وهو مليم', verseTranslation: 'So the fish took him while he was blaming himself'),
        ],
        speciality: 'Preached to Nineveh - Entire nation believed', imageUrl: 'assets/images/prophets/yunus.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'Prophet Sulaiman', arabicName: 'سليمان', title: 'The Wise King', lifespan: 'Approx. 970-935 BCE', birthPlace: 'Jerusalem', deathPlace: 'Jerusalem',
        description: 'Early Life & Ascension:\nProphet Sulaiman (Solomon) was the son and heir of Prophet Dawud (David). From a young age, he exhibited extraordinary wisdom and an exceptional sense of justice. Upon his father\'s passing, Sulaiman inherited both prophethood and the kingship of a vast empire.\n\nUnprecedented Kingdom & Miracles:\nSulaiman asked Allah for a kingdom that would never be granted to anyone after him. Allah answered this prayer, subjugating the forces of nature to his command. He was granted the ability to understand animals and birds. Allah placed the wind under his control and commanded legions of Jinn to serve him in constructing magnificent buildings.\n\nThe Queen of Sheba:\nOne of his famous encounters involved Bilqis, the sun-worshipping Queen of Sheba. Sulaiman sent her a letter inviting her to Islam. When she visited his majestic palace—featuring a brilliant floor of transparent glass—she was deeply humbled by his divinely granted power and submitted herself to Allah.\n\nLegacy & Passing:\nDespite his unimaginable wealth and power, Sulaiman remained a humble, grateful servant of Allah. His passing was a profound lesson: he died leaning on his staff observing the Jinn at work. They continued laboring for a year, unaware of his death until a termite ate through the staff.',
        keyAchievements: ['Granted unprecedented kingdom and wisdom', 'Understood the language of birds and animals', 'Controlled the wind and Jinn by Allah\'s command', 'Brought the Queen of Sheba to Islam'],
        quranicMentions: [
          QuranicMention(surahName: 'An-Naml', surahArabic: 'النمل', surahNumber: 27, verseNumber: 16, verseText: 'وورث سليمان داود وقال يا أيها الناس علمنا منطق الطير', verseTranslation: 'Sulaiman inherited from Dawud and said: We have been taught the language of birds'),
        ],
        speciality: 'The Wise King - Understood languages of birds', imageUrl: 'assets/images/prophets/sulaiman.png', mentionedInSurahs: 16,
      ),
      ProphetBiography(
        name: 'Luqman', arabicName: 'لقمان', title: 'The Wise Man', lifespan: 'Approx. 750 BCE', birthPlace: 'Unknown', deathPlace: 'Unknown',
        description: 'Identity & Background:\nLuqman, known as Luqman the Wise, is a highly revered figure. While consensus leans towards him being a righteous sage rather than a formal prophet, his moral teachings are forever preserved in the Quran. Traditions suggest he was a humble man who worked as a carpenter or shepherd. His profound intellect elevated him far above his worldly status.\n\nThe Gift of Wisdom:\nThe Quran states that Allah bestowed "Hikmah" (profound wisdom) upon Luqman. This divine wisdom was characterized by a deep understanding of life\'s realities and constant gratitude to the Creator. He was known for his highly eloquent speech and impeccable character.\n\nTeachings to His Son:\nLuqman\'s enduring legacy is immortalized in the 31st chapter of the Quran. He imparted beautiful, comprehensive advice to his son, beginning with a strict prohibition of Shirk (associating partners with Allah). He commanded his son to establish prayer, enjoin good, forbid evil, and bear life\'s trials with patience.\n\nSocial Ethics & Legacy:\nFurthermore, Luqman\'s advice laid out a perfect blueprint for social conduct. He warned against arrogance, advising his son to walk upon the earth with humility and to lower his voice. Luqman serves as the ultimate Quranic model for parenting and moral guidance.',
        keyAchievements: ['Preserved moral teachings in the Quran', 'Provided exemplary parental guidance', 'Emphasized monotheism and gratitude', 'Advocated for justice and kindness'],
        quranicMentions: [
          QuranicMention(surahName: 'Luqman', surahArabic: 'لقمان', surahNumber: 31, verseNumber: 13, verseText: 'وإذ قال لقمان لابنه وهو يعظه يا بني لا تشرك بالله', verseTranslation: 'And remember when Luqman said to his son while admonishing him: O my son, do not associate partners with Allah'),
        ],
        speciality: 'The Wise Man - Moral teacher', imageUrl: 'assets/images/prophets/luqman.png', mentionedInSurahs: 1,
      ),
    ];
  }

  // ==========================================
  // ARABIC TRANSLATIONS
  // ==========================================
  List<ProphetBiography> _getProphetsAr() {
    return [
      ProphetBiography(
        name: 'النبي محمد', arabicName: 'محمد', title: 'خاتم الأنبياء والمرسلين', lifespan: '570 - 632 م', birthPlace: 'مكة المكرمة', deathPlace: 'المدينة المنورة',
        description: 'النشأة والخلفية:\nولد النبي محمد (صلى الله عليه وسلم) في مكة في عام الفيل (570 م) يتيماً. نشأ في رعاية جده عبد المطلب ثم عمه أبي طالب. عُرف في مكة بأمانته المطلقة وصدقه، حتى لُقب بـ "الصادق الأمين". قبل النبوة، عمل راعياً للغنم ثم تاجراً، وبنى سمعة لا مثيل لها في النزاهة.\n\nالنبوة ونزول الوحي:\nفي سن الأربعين، وأثناء اعتكافه في غار حراء للعبادة والتأمل، نزل عليه الوحي لأول مرة عن طريق الملاك جبريل. كان هذا الحدث العظيم بداية لرسالته النبوية. طوال 13 عاماً في مكة، واجه اضطهاداً شديداً وأذى جسدياً ومقاطعة اجتماعية من سادة قريش، بينما كان يدعو الناس بلا كلل إلى التوحيد والعدالة الاجتماعية والأخلاق الكريمة.\n\nالهجرة وبناء الدولة:\nفي عام 622 م، وبأمر إلهي لتجنب مؤامرة اغتياله، هاجر إلى المدينة المنورة (يثرب)، وهو الحدث الذي يمثل بداية التقويم الهجري. في المدينة، أسس مجتمعاً إسلامياً عادلاً وموحداً، وجمع بين القبائل المتناحرة تحت دستور سلام غير مسبوق. أثبت قيادة فذة كرجل دولة، وقاضٍ، ومعلم، وقائد عسكري يدافع عن المجتمع المسلم الناشئ.\n\nالإرث والوفاة:\nعلى مدار 23 عاماً، اكتمل نزول القرآن الكريم ليكون دليلاً شاملاً للبشرية. قبل وفاته في عام 632 م، أدى حجة الوداع وألقى خطبة تاريخية أكدت على المساواة وحقوق الإنسان والتقوى. ترك وراءه القرآن الكريم وسنته النبوية الشريفة، مُكملاً رسالة الإسلام كخاتم للأنبياء والمرسلين.',
        keyAchievements: ['تلقى القرآن الكريم كاملاً على مدار 23 عاماً', 'أسس الدولة الإسلامية الأولى في المدينة المنورة', 'وحد القبائل العربية تحت راية الإسلام', 'أرسى دعائم الحياة الإسلامية من خلال السنة النبوية', 'أدى حجة الوداع ووضع خطبة حقوق الإنسان'],
        quranicMentions: [
          QuranicMention(surahName: 'الأحزاب', surahArabic: 'الأحزاب', surahNumber: 33, verseNumber: 40, verseText: 'مَّا كَانَ مُحَمَّدٌ أَبَا أَحَدٍ مِّن رِّجَالِكُمْ وَلَٰكِن رَّسُولَ اللَّهِ وَخَاتَمَ النَّبِيِّينَ', verseTranslation: 'Muhammad is not the father of [any] one of your men, but [he is] the Messenger of Allah and last of the prophets'),
          QuranicMention(surahName: 'الأنبياء', surahArabic: 'الأنبياء', surahNumber: 21, verseNumber: 107, verseText: 'وَمَا أَرْسَلْنَاكَ إِلَّا رَحْمَةً لِّلْعَالَمِينَ', verseTranslation: 'And We have not sent you, [O Muhammad], except as a mercy to the worlds'),
        ],
        speciality: 'خاتم الأنبياء - آخر رسول من الله', imageUrl: 'assets/images/prophets/muhammad.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'النبي إبراهيم', arabicName: 'إبراهيم', title: 'خليل الله', lifespan: 'حوالي 2165 - 2040 قبل الميلاد', birthPlace: 'أور (العراق القديم)', deathPlace: 'أرض كنعان (فلسطين)',
        description: 'النشأة والخلفية:\nولد النبي إبراهيم عليه السلام في مجتمع غارق في عبادة الأصنام وتعدد الآلهة. بالرغم من أن والده (أو عمه) آزر كان نحاتاً شهيراً للأصنام، إلا أن الله وهب إبراهيم العقل والفطرة السليمة منذ صغره. رفض عبادة الكواكب والتماثيل، وأدرك من خلال التأمل أن الخالق الحقيقي يجب أن يكون أبدياً لا يزول.\n\nالرسالة النبوية والابتلاءات:\nكرس حياته لدعوة قومه إلى التوحيد المطلق لله. عندما قام بشجاعة بتحطيم أصنام معبدهم ليثبت لهم عجزها، حُكم عليه بالإلقاء في نار عظيمة بأمر من الملك الطاغية النمرود. لكن الله أمر النار بمعجزة أن تكون برداً وسلاماً عليه. بعد ذلك، واجه إبراهيم سلسلة من الابتلاءات الشاقة، منها الأمر بترك زوجته هاجر وابنه الرضيع إسماعيل في وادٍ غير ذي زرع في مكة.\n\nالتضحية العظمى والإرث:\nجاء أعظم ابتلاء له بعد سنوات عندما أمره الله في رؤيا أن يذبح ابنه الحبيب إسماعيل الذي جاءه بعد شوق طويل. استسلم الأب والابن طواعية لأمر الله. وفي لحظة التنفيذ، فداه الله بكبش عظيم، مما أسس شعيرة الأضحية ومناسك الحج. قام لاحقاً مع ابنه إسماعيل برفع قواعد الكعبة المشرفة.\n\nمكانته في الإسلام:\nيُبجل في الإسلام بلقب "خليل الله"، وهو أبو الأنبياء. استسلامه العميق وإيمانه الراسخ جعله من أعظم الأنبياء (أولو العزم). وقد أمر القرآن المسلمين باتباع "ملة إبراهيم حنيفاً".',
        keyAchievements: ['دعا قومه للتوحيد في مجتمع وثني', 'بنى الكعبة المشرفة مع ابنه إسماعيل', 'أرسى مناسك الحج', 'أظهر استسلاماً مطلقاً لأمر الله في قصة الذبح', 'اجتاز جميع الابتلاءات الإلهية بنجاح باهر'],
        quranicMentions: [
          QuranicMention(surahName: 'البقرة', surahArabic: 'البقرة', surahNumber: 2, verseNumber: 124, verseText: 'وَإِذِ ابْتَلَىٰ إِبْرَاهِيمَ رَبُّهُ بِكَلِمَاتٍ فَأَتَمَّهُنَّ', verseTranslation: 'And [mention, O Muhammad], when Abraham was tried by his Lord with commands and he fulfilled them'),
        ],
        speciality: 'خليل الله - باني الكعبة وأبو الأنبياء', imageUrl: 'assets/images/prophets/ibrahim.png', mentionedInSurahs: 25,
      ),
      ProphetBiography(
        name: 'النبي موسى', arabicName: 'موسى', title: 'كليم الله', lifespan: 'حوالي 1393 - 1273 قبل الميلاد', birthPlace: 'مصر', deathPlace: 'منطقة جبل الطور (سيناء)',
        description: 'الولادة والنشأة:\nولد النبي موسى عليه السلام في مصر خلال فترة قاسية أمر فيها فرعون بقتل كل المواليد الذكور من بني إسرائيل. لإنقاذه، أوحى الله إلى أمه أن تضعه في تابوت وتلقيه في نهر النيل. وبمعجزة إلهية، وصل التابوت إلى قصر فرعون، حيث التقطته زوجة فرعون الصالحة (آسية) وربته كابن لها، مما أتاح له النشوء في القصر الملكي.\n\nالنبوة والنداء الإلهي:\nبعد فراره إلى مدين لعدة سنوات إثر حادثة قتل خطأ، شهد موسى تجربة إلهية عظيمة عند جبل الطور (سيناء). كلمه الله تعالى مباشرة من شجرة مشتعلة، واصطفاه للنبوة ومنحه معجزات كبرى، كتحول عصاه إلى ثعبان ضخم وخروج يده بيضاء من غير سوء. أمره الله بالعودة إلى مصر لمواجهة فرعون وتحرير بني إسرائيل.\n\nالمواجهة والخروج:\nواجه موسى طغيان فرعون بشجاعة وهزم كبار سحرته، الذين آمنوا فور رؤيتهم للحق. وعندما استمر فرعون في عناده رغم الآيات والضربات، قاد موسى بني إسرائيل في خروج تاريخي ليلاً. ولما طاردهم جيش فرعون، شق الله البحر الأحمر، فنجا موسى وقومه وغرق فرعون وجنوده.\n\nالتوجيه والإرث:\nصعد موسى جبل سيناء لأربعين ليلة حيث تلقى "التوراة" التي تضمنت الأحكام الإلهية. بالرغم من صبره وتفانيه، عانى كثيراً من تمرد بني إسرائيل وعبادتهم للعجل أثناء تيههم في الصحراء. عُرف بلقب "كليم الله"، وهو النبي الأكثر ذكراً بالاسم في القرآن الكريم.',
        keyAchievements: ['تلقى التوراة والألواح التي تحمل الوصايا الإلهية', 'أظهر آيات ومعجزات كبرى أمام فرعون وسحرته', 'قاد بني إسرائيل وأنقذهم من الاستعباد في مصر', 'تكلم مع الله عز وجل مباشرة بدون حجاب'],
        quranicMentions: [
          QuranicMention(surahName: 'القصص', surahArabic: 'القصص', surahNumber: 28, verseNumber: 30, verseText: 'يَا مُوسَىٰ إِنِّي أَنَا اللَّهُ رَبُّ الْعَالَمِينَ', verseTranslation: 'O Moses, indeed it is I, Allah, Lord of the worlds'),
        ],
        speciality: 'كليم الله - من أولي العزم من الرسل', imageUrl: 'assets/images/prophets/musa.png', mentionedInSurahs: 36,
      ),
      ProphetBiography(
        name: 'النبي عيسى', arabicName: 'عيسى', title: 'روح الله وكلمته', lifespan: 'حوالي 1 - 33 ميلادي', birthPlace: 'بيت لحم (فلسطين)', deathPlace: 'رُفع إلى السماء',
        description: 'الولادة المعجزة:\nحُمل بالنبي عيسى (المسيح) بمعجزة إلهية عظيمة، حيث وُلد للسيدة العذراء مريم عليها السلام دون أب بشري. يوضح القرآن أنه خُلق بكلمة الله المباشرة "كُن فيكون"، تماماً كخلق آدم. وفي المهد، نطق رضيعاً بمعجزة ليدافع عن طهارة أمه أمام اتهامات قومها، معلناً نبوته وعبوديته لله.\n\nالرسالة النبوية والمعجزات:\nأُرسل عيسى إلى بني إسرائيل ليصدق ما بين يديه من التوراة ويأتيهم بكتاب جديد هو "الإنجيل" يحمل الهداية والنور. لإثبات نبوته، أيده الله بمعجزات باهرة؛ فكان يُبرئ الأكمه (الأعمى) والأبرص، ويخلق من الطين كهيئة الطير فينفخ فيه فيكون طيراً، ويحيي الموتى، كل ذلك "بإذن الله". دعا الناس إلى التوحيد الخالص والروحانية الصادقة.\n\nالتحديات والرفع إلى السماء:\nرغم آياته الواضحة ورسالته الرحيمة، واجه معارضة شديدة ومؤامرات من النخبة الدينية التي شعرت بتهديد لتعاليمه. وعندما تآمروا لقتله وصلبه، ينص القرآن بوضوح قاطع أنهم (وما قتلوه وما صلبوه ولكن شبه لهم). بل رفعه الله إليه وأنقذه من أعدائه.\n\nالمنظور الإسلامي والعودة:\nيُعظم عيسى في الإسلام كـ "روح الله" و"كلمته" التي ألقاها إلى مريم. لكن القرآن يرفض رفضاً قاطعاً فكرة ألوهيته أو بنوته لله، مؤكداً بشريته كرسول كريم. وتؤكد العقيدة الإسلامية أنه سيعود إلى الأرض قبل يوم القيامة ليقيم العدل ويهزم المسيح الدجال ويملأ الأرض سلاماً.',
        keyAchievements: ['وُلد بمعجزة إلهية دون أب بشري', 'أبرأ المرضى وأحيا الموتى بإذن الله', 'تلقى كتاب الإنجيل هدى ونوراً', 'تكلم في المهد صبياً ليدافع عن أمه', 'أحد أنبياء أولي العزم الخمسة'],
        quranicMentions: [
          QuranicMention(surahName: 'مريم', surahArabic: 'مريم', surahNumber: 19, verseNumber: 34, verseText: 'ذَٰلِكَ عِيسَى ابْنُ مَرْيَمَ ۚ قَوْلَ الْحَقِّ الَّذِي فِيهِ يَمْتَرُونَ', verseTranslation: 'That is Jesus, the son of Mary - the word of truth about which they are in dispute'),
        ],
        speciality: 'روح الله وكلمته - وُلد بمعجزة', imageUrl: 'assets/images/prophets/isa.png', mentionedInSurahs: 15,
      ),
      ProphetBiography(
        name: 'النبي نوح', arabicName: 'نوح', title: 'أول رسول إلى أهل الأرض', lifespan: 'أكثر من 2900 سنة', birthPlace: 'غير محدد', deathPlace: 'غير محدد',
        description: 'النشأة والمجتمع:\nيُعد النبي نوح عليه السلام من أوائل الرسل الذين بعثهم الله للبشرية. عاش في حقبة انحرف فيها الناس عن التوحيد الصافي الذي جاء به آدم، وسقطوا في مستنقع عبادة الأصنام التي كانت في الأصل تماثيل لرجال صالحين. كان مجتمعه غارقاً في الجهل والشرك والتكبر.\n\nالمهمة الثابتة والصبر:\nلمدة مذهلة بلغت 950 عاماً، دعا نوح قومه بلا كلل أو ملل للعودة إلى عبادة الله الواحد. وعظهم ليلاً ونهاراً، سراً وجهاراً، مستخدماً كل أساليب الترغيب والترهيب والحجة المنطقية. ورغم صبره الهائل، لم يؤمن معه إلا قلة قليلة جداً، بينما استمرت النخبة في السخرية منه وإيذائه واتهامه بالجنون والضلال.\n\nالسفينة والطوفان العظيم:\nعندما أوحى الله إليه أنه لن يؤمن من قومه إلا من قد آمن، أمره الله ببناء سفينة ضخمة. وبينما كان يصنع الفلك على اليابسة، كان قومه يمرون به ويسخرون منه. وبأمر إلهي، حمل في السفينة من كل زوجين اثنين مع المؤمنين القلائل. ثم انفجرت الأرض عيوناً وانهمرت السماء بماء منهمر، ليحدث طوفان عالمي أغرق كل الكافرين.\n\nالإرث والمكانة:\nمن أشد اللحظات حزناً كان غرق ابن نوح، الذي رفض بعناد الانضمام للمؤمنين ولجأ إلى جبل ظناً أنه سيعصمه من الماء. يُعرف نوح بأنه أول أنبياء "أولو العزم". وحياته هي الرمز الأسمى للمثابرة، مؤكدة أن واجب النبي هو التبليغ بصبر، بينما الهداية بيد الله وحده.',
        keyAchievements: ['أول رسول يُبعث لأهل الأرض لمحاربة الشرك', 'دعا قومه لمدة 950 عاماً دون يأس', 'بنى السفينة بوحي من الله لإنقاذ المؤمنين', 'ضرب أروع الأمثلة في الصبر على إيذاء القوم'],
        quranicMentions: [
          QuranicMention(surahName: 'العنكبوت', surahArabic: 'العنكبوت', surahNumber: 29, verseNumber: 14, verseText: 'وَلَقَدْ أَرْسَلْنَا نُوحًا إِلَىٰ قَوْمِهِ فَلَبِثَ فِيهِمْ أَلْفَ سَنَةٍ إِلَّا خَمْسِينَ عَامًا', verseTranslation: 'And We certainly sent Noah to his people, and he remained among them a thousand years minus fifty years'),
        ],
        speciality: 'شيخ المرسلين - صاحب معجزة الطوفان', imageUrl: 'assets/images/prophets/nuh.png', mentionedInSurahs: 28,
      ),
      ProphetBiography(
        name: 'النبي أيوب', arabicName: 'أيوب', title: 'رمز الصبر', lifespan: 'حوالي 2000 قبل الميلاد', birthPlace: 'أرض الشام', deathPlace: 'أرض الشام',
        description: 'الرخاء والنعمة:\nأنعم الله على النبي أيوب في بداية حياته بثروة هائلة، ومساحات شاسعة من الأراضي، وأنعام كثيرة، وعائلة كبيرة وصالحة. كان زعيماً محترماً في منطقة بلاد الشام، وعُرف بتقواه الشديدة، وكرمه اللامحدود للفقراء والأيتام، وشكره الدائم لله على نعمه.\n\nالابتلاء العظيم:\nلإظهار نقاء وقوة إيمان أيوب، خضعه الله لأحد أشد الابتلاءات في تاريخ البشرية. في فترة قصيرة، فقد أيوب كل ثروته، وتُوفّي أبناؤه، وأُصيب بمرض جلدي مؤلم أهلك جسده، مما دفع مجتمعه إلى الابتعاد عنه وعزله تماماً. ورغم فقدانه لكل شيء ومعاناته الجسدية القاسية، ظل قلبه معلقاً بالله وحامداً له.\n\nالصبر واليقين:\nلسنوات طويلة (يُقال إنها 18 عاماً)، تحمل أيوب هذا الألم الذي لا يُطاق دون أن ينطق بكلمة شكوى واحدة ضد خالقه. هجره الجميع باستثناء زوجته المخلصة. وعندما دعا الله أخيراً، كان دعاؤه في قمة الأدب والتواضع: (أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ)، معبراً عن ضعفه البشري دون أن يشترط الشفاء.\n\nالشفاء والجزاء:\nاستجاب الله لدعائه الصادق والصابر، وأمره أن يضرب الأرض بقدمه. فنبعت عين ماء باردة، اغتسل منها وشرب فبرئ تماماً وعاد شاباً صحيحاً. وعوّضه الله أضعاف ما فقد من المال والولد. يظل أيوب عليه السلام النموذج الأبدي في الفكر الإسلامي للصبر المطلق والثقة التامة في رحمة الله أثناء المحن.',
        keyAchievements: ['ضرب أروع الأمثلة في الصبر على أشد الابتلاءات في المال والولد والجسد', 'حافظ على إيمانه وشكره لله رغم فقدان كل شيء', 'نال الشفاء والتعويض الإلهي المضاعف جزاءً لصبره'],
        quranicMentions: [
          QuranicMention(surahName: 'الأنبياء', surahArabic: 'الأنبياء', surahNumber: 21, verseNumber: 83, verseText: 'وَأَيُّوبَ إِذْ نَادَىٰ رَبَّهُ أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ', verseTranslation: 'And [mention] Job, when he called to his Lord, "Indeed, adversity has touched me, and you are the Most Merciful of the merciful."'),
        ],
        speciality: 'رمز الصبر المطلق واليقين في الله', imageUrl: 'assets/images/prophets/ayub.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'النبي يوسف', arabicName: 'يوسف', title: 'الكريم ابن الكريم', lifespan: 'حوالي 2100-2000 قبل الميلاد', birthPlace: 'أرض كنعان', deathPlace: 'مصر',
        description: 'الطفولة والمؤامرة:\nكان النبي يوسف الابن الأحب للنبي يعقوب عليهما السلام. رُزق بجمال جسدي فائق ورؤى نبوية صادقة منذ صغره، مما جعله هدفاً لغيرة إخوته غير الأشقاء. تآمروا عليه وألقوه في غيابة الجب (بئر عميق)، وعادوا إلى أبيهم بقميص ملطخ بدم كذب مدعين أن الذئب أكله. أنقذته قافلة مارة وباعوه كعبد في أسواق مصر بثمن بخس.\n\nمحنة الشباب والسجن:\nاشتراه عزيز مصر (وزير كبير)، ونشأ يوسف كشاب في غاية النبل والوسامة. شُغفت به زوجة العزيز وحاولت إغواءه، لكن يوسف اعتصم بإيمانه ورفض بشدة. ولحماية شرفه وعفته من هذه البيئة السامة، اختار السجن الظالم قائلاً (رب السجن أحب إلي مما يدعونني إليه). قضى بضع سنوات في السجن حيث استمر في دعوته للتوحيد وتفسير الرؤى بدقة.\n\nالصعود للسلطة:\nكان تفسيره الدقيق والملهم لرؤيا ملك مصر المقلقة - حول سبع سنوات من الرخاء تليها سبع سنوات من القحط والجفاف - هو سبب خروجه من السجن معززاً مكرماً. ولثقة الملك في حكمته وأمانته وكفاءته، عينه وزيراً للمالية (على خزائن الأرض). أدار يوسف موارد مصر بعبقرية وأنقذ المنطقة بأسرها من مجاعة محققة.\n\nاللقاء والعفو:\nخلال المجاعة، جاء إخوته إلى مصر يطلبون حصصاً من الطعام دون أن يعرفوه. وبعد سلسلة من التدابير الحكيمة لجمع شمل عائلته بأكملها، كشف يوسف عن هويته. وفي مشهد عظيم من التسامح النبوي، عفا عن إخوته عفواً شاملاً قائلاً (لا تثريب عليكم اليوم). التأم شمله بأبيه، وتحققت رؤياه القديمة، تاركاً إرثاً خالداً في العفة، والعفو، وحسن التوكل على الله.',
        keyAchievements: ['حافظ على عفته وطهارته رغم الإغراءات الشديدة', 'فسر الرؤى بفضل الله وأنقذ مصر والدول المجاورة من مجاعة طاحنة', 'ترقى من عبد مسجون إلى وزير نافذ في مصر', 'ضرب أروع أمثلة العفو عند المقدرة بمسامحة إخوته'],
        quranicMentions: [
          QuranicMention(surahName: 'يوسف', surahArabic: 'يوسف', surahNumber: 12, verseNumber: 33, verseText: 'قَالَ رَبِّ السِّجْنُ أَحَبُّ إِلَيَّ مِمَّا يَدْعُونَنِي إِلَيْهِ', verseTranslation: 'He said, "My Lord, prison is more to my liking than that to which they invite me"'),
        ],
        speciality: 'الكريم والصديق - رمز العفة والعفو', imageUrl: 'assets/images/prophets/yusuf.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'النبي يونس', arabicName: 'يونس', title: 'ذو النون', lifespan: 'حوالي 800-700 قبل الميلاد', birthPlace: 'نينوى (العراق)', deathPlace: 'منطقة نينوى',
        description: 'الرسالة إلى نينوى:\nأُرسل النبي يونس (المُلقب بذي النون أي صاحب الحوت) إلى مدينة نينوى المزدهرة والفاسدة في آشور القديمة. دعا عشرات الآلاف من سكانها بحرارة لترك عبادة الأصنام والظلم، وعبادة الله وحده. لكن القوم رفضوا رسالته بعناد، وتمسكوا بضلالهم، واستهزأوا بتحذيراته من العذاب الإلهي القادم.\n\nالمغادرة والعاصفة:\nبسبب إحباطه الشديد وغضبه من رفض قومه، ارتكب يونس خطأً اجتهادياً حين غادر المدينة غاضباً قبل أن يتلقى الإذن الصريح من الله. استقل سفينة ركاب محملة، وسرعان ما هبت عاصفة هوجاء كادت أن تغرق السفينة. اقترح البحارة إجراء قرعة لتحديد الشخص "المشؤوم" الذي تسبب في هذه اللعنة، ووقعت القرعة على يونس ثلاث مرات، مما أدى إلى إلقائه في البحر الهائج.\n\nالحوت والتوبة:\nبأمر من الله، ابتلع حوت ضخم يونس عليه السلام دون أن يكسر له عظماً أو يخدش له لحماً. وفي ظلمات ثلاث (ظلمة الليل، وظلمة البحر، وظلمة بطن الحوت)، أدرك يونس خطأه. لجأ إلى الله بتوبة صادقة ودعاء عظيم: (لَّا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ). لصدق دعائه، أمر الله الحوت أن يلقيه على شاطئ مقفر بأمان.\n\nالنجاة والنجاح:\nكان يونس مريضاً وضعيفاً، فأنبت الله عليه شجرة من يقطين لتقيه وتغذيه. بعد تعافيه، عاد طائعاً إلى نينوى. ولدهشته الكبيرة، كان قومه قد رأوا بوادر العذاب فتابوا توبة جماعية وآمنوا إيماناً صادقاً. فكشف الله عنهم العذاب، ليكون يونس النبي الوحيد الذي آمن قومه بأكملهم، مما يبرز سعة رحمة الله وقوة التوبة الصادقة.',
        keyAchievements: ['دعا قوم نينوى لعبادة الله وحده', 'دعا بدعاء التوبة العظيم من بطن الحوت', 'أصبح النبي الوحيد الذي آمنت قريته بأكملها ونُزع عنهم العذاب', 'أظهر قوة الاستغفار في أشد الكروب'],
        quranicMentions: [
          QuranicMention(surahName: 'الأنبياء', surahArabic: 'الأنبياء', surahNumber: 21, verseNumber: 87, verseText: 'فَنَادَىٰ فِي الظُّلُمَاتِ أَن لَّا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ', verseTranslation: 'And he called out within the darknesses, "There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers."'),
        ],
        speciality: 'ذو النون (صاحب الحوت) - النبي الذي آمن قومه جميعاً', imageUrl: 'assets/images/prophets/yunus.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'النبي سليمان', arabicName: 'سليمان', title: 'الملك الحكيم', lifespan: 'حوالي 970-935 قبل الميلاد', birthPlace: 'القدس', deathPlace: 'القدس',
        description: 'النشأة وتولي المُلك:\nالنبي سليمان هو ابن ووريث النبي داود عليهما السلام. منذ صغره، أظهر حكمة استثنائية وحساً عميقاً بالعدل، وكثيراً ما كان يشارك والده في حل النزاعات القضائية المعقدة. بعد وفاة والده، ورث سليمان النبوة وملكاً عظيماً ومزدهراً.\n\nملك لا ينبغي لأحد من بعده:\nدعا سليمان ربه بدعاء فريد: (رَبِّ اغْفِرْ لِي وَهَبْ لِي مُلْكًا لَّا يَنبَغِي لِأَحَدٍ مِّن بَعْدِي). فاستجاب له الله، وسخّر له قوى الطبيعة وعالم الغيب. فقد مُنح معجزة فهم لغة الطيور والحيوانات والحشرات. وسخّر الله له الريح تحمله حيث يشاء، وسخّر له الجن والشياطين يبنون له القصور والمحاريب، ويغوصون في البحر لاستخراج اللآلئ.\n\nملكة سبأ (بلقيس):\nمن أشهر قصصه الدبلوماسية والدعوية لقاؤه ببلقيس، ملكة سبأ التي كان قومها يعبدون الشمس. بعد أن أبلغه طائر الهدهد عن مملكتها، أرسل لها كتاباً يدعوها للإسلام. وعندما زارت قصره المهيب - الذي تميز بصرح من قوارير (زجاج) يمر تحته الماء - أُذهلت بقوته وحكمته التي فاقت كل تصور بشري، وأعلنت إسلامها واستسلامها لله رب العالمين.\n\nإرث العدل والوفاة:\nرغم ثروته وقوته التي لم يسبق لها مثيل، ظل سليمان عبداً شكوراً وأواباً لله، مسخراً كل إمكانياته لإقامة العدل ونشر التوحيد. حتى وفاته كانت درساً عظيماً؛ فقد مات وهو متكئ على عصاه يراقب الجن وهم يعملون. استمروا في العمل الشاق لعام كامل وهم يظنونه حياً، حتى أكلت الأرضة (حشرة) عصاه فسقط، ليعلم الناس أن الجن لا يعلمون الغيب.',
        keyAchievements: ['أُوتي ملكاً لم يؤته أحد من العالمين', 'عُلم منطق الطير ولغة الحيوانات', 'سُخرت له الرياح والجن بأمر الله', 'أقنع ملكة سبأ (بلقيس) وقومها بالتوحيد والإسلام', 'جمع بين السلطة الدنيوية المطلقة والعدل الإلهي'],
        quranicMentions: [
          QuranicMention(surahName: 'النمل', surahArabic: 'النمل', surahNumber: 27, verseNumber: 16, verseText: 'وَوَرِثَ سُلَيْمَانُ دَاوُودَ ۖ وَقَالَ يَا أَيُّهَا النَّاسُ عُلِّمْنَا مَنطِقَ الطَّيْرِ', verseTranslation: 'And Solomon inherited David. He said, "O people, we have been taught the language of birds"'),
        ],
        speciality: 'الملك الحكيم - سُخرت له الريح والجن', imageUrl: 'assets/images/prophets/sulaiman.png', mentionedInSurahs: 16,
      ),
      // Luqman
      ProphetBiography(
        name: 'لقمان الحكيم', 
        arabicName: 'لقمان', 
        title: 'رمز الحكمة', 
        lifespan: 'حوالي 750 قبل الميلاد', 
        birthPlace: 'غير محدد', 
        deathPlace: 'غير محدد',
        description: 'الهوية والخلفية:\nلقمان الحكيم هو شخصية مبجلة جداً في التراث الإسلامي. يميل إجماع العلماء إلى أنه كان عبداً صالحاً وحكيماً وليس نبياً يتلقى الوحي بالمعنى التقليدي، إلا أن تعاليمه ومواعظه الأخلاقية خُلدت في القرآن الكريم. تشير الروايات إلى أنه كان رجلاً متواضعاً، ربما من أصول نوبية أو حبشية، عمل نجاراً أو راعياً. لكن رجاحة عقله وبصيرته الروحية رفعته فوق أي مكانة دنيوية.\n\nهبة الحكمة:\nينص القرآن صراحة على أن الله آتى لقمان "الحكمة". تجلت هذه الحكمة في الفهم العميق والراسخ لطبائع الأمور، والشكر الدائم للخالق، والقدرة الفذة على صياغة الحقائق الأخلاقية المعقدة بكلمات بسيطة ومؤثرة. عُرف بين قومه بكلامه البليغ، وصمته الطويل المتأمل، وأخلاقه التي لا تشوبها شائبة.\n\nوصاياه لابنه:\nيتجلى إرث لقمان الخالد في السورة القرآنية التي تحمل اسمه (سورة لقمان). السورة تستعرض الوصايا العظيمة والرحيمة التي وجهها لابنه. بدأ بالأصل الأهم للوجود: التحذير الشديد من الشرك بالله ووصفه بالظلم العظيم. ثم نسج ببراعة بين الأخلاق الروحية والاجتماعية، آمراً ابنه بإقامة الصلاة، والأمر بالمعروف، والنهي عن المنكر، والصبر على الشدائد.\n\nالأخلاق الاجتماعية والإرث:\nعلاوة على ذلك، وضعت وصايا لقمان خريطة طريق مثالية للسلوك الاجتماعي. حذر بشدة من التكبر، ناصحاً ابنه بعدم تصعير خده للناس (عدم التكبر عليهم)، والمشي في الأرض بتواضع، وخفض الصوت. من خلال هذه التوجيهات الخالدة، يمثل لقمان النموذج القرآني الأمثل للتربية، مؤكداً أن النجاح الحقيقي يكمن في تنشئة أجيال تتحلى بالتوحيد والتواضع وحسن الخلق.',
        keyAchievements: [ // <--- Bracket added here
          'خلد القرآن الكريم مواعظه وحكمته في سورة تحمل اسمه', 
          'قدم النموذج الأمثل لنصائح الآباء للأبناء', 
          'رسخ مبادئ التوحيد والشكر', 
          'دعا إلى مكارم الأخلاق كالتواضع وغض الصوت'
        ], // <--- Bracket added here
        quranicMentions: [
          QuranicMention(
            surahName: 'لقمان', 
            surahArabic: 'لقمان', 
            surahNumber: 31, 
            verseNumber: 13, 
            verseText: 'وَإِذْ قَالَ لُقْمَانُ لِابْنِهِ وَهُوَ يَعِظُهُ يَا بُنَيَّ لَا تُشْرِكْ بِاللَّهِ ۖ إِنَّ الشِّرْكَ لَظُلْمٌ عَظِيمٌ', 
            verseTranslation: 'And [mention, O Muhammad], when Luqman said to his son while he was instructing him, "O my son, do not associate [anything] with Allah. Indeed, association [with him] is great injustice."'
          ),
        ],
        speciality: 'الحكيم والمربي - صاحب الوصايا الخالدة', 
        imageUrl: 'assets/images/prophets/luqman.png', 
        mentionedInSurahs: 1,
      ),
    ];
  }

  // ==========================================
  // FRENCH TRANSLATIONS
  // ==========================================
  List<ProphetBiography> _getProphetsFr() {
    return [
      ProphetBiography(
        name: 'Prophète Muhammad', arabicName: 'محمد', title: 'Le Dernier Messager', lifespan: '570 - 632 È.C.', birthPlace: 'La Mecque', deathPlace: 'Médine',
        description: 'Jeunesse et Origines:\nNé à La Mecque l\'Année de l\'Éléphant (570 È.C.), le Prophète Muhammad (paix soit sur lui) est devenu orphelin très jeune. Élevé par son grand-père puis son oncle, il fut connu pour son honnêteté irréprochable, gagnant les titres d\'Al-Amin (Le Digne de Confiance) et As-Sadiq (Le Véridique).\n\nProphétie et Révélation:\nÀ l\'âge de 40 ans, lors d\'une retraite spirituelle dans la grotte de Hira, il reçut la première révélation du Coran via l\'Ange Jibril (Gabriel). Pendant 13 ans à La Mecque, il fit face à de sévères persécutions tout en appelant inlassablement au monothéisme (Tawhid) et à la justice sociale.\n\nMigration et Établissement:\nEn 622 È.C., il émigra vers Médine (l\'Hégire), marquant le début du calendrier islamique. À Médine, il établit une société islamique juste et unifiée, rassemblant des tribus en guerre sous une constitution de paix sans précédent.\n\nHéritage et Décès:\nSur 23 ans, le Coran complet fut révélé. Avant son décès en 632 È.C., il accomplit le Pèlerinage d\'Adieu, délivrant un sermon intemporel sur l\'égalité et les droits humains. Il laissa derrière lui le Coran et sa Sunnah, achevant la religion de l\'Islam en tant que dernier messager de l\'humanité.',
        keyAchievements: ['A reçu le Coran complet sur 23 ans', 'A établi l\'État islamique à Médine', 'A unifié les tribus arabes sous l\'Islam', 'A établi l\'exemple de la vie islamique par la Sunnah', 'A accompli le Hajj d\'Adieu'],
        quranicMentions: [
          QuranicMention(surahName: 'Al-Ahzab', surahArabic: 'الأحزاب', surahNumber: 33, verseNumber: 40, verseText: 'ما كان محمد أبا أحد من رجالكم', verseTranslation: 'Muhammad n\'est le père d\'aucun de vos hommes'),
          QuranicMention(surahName: 'Al-Anbiya', surahArabic: 'الأنبياء', surahNumber: 21, verseNumber: 107, verseText: 'وما أرسلناك إلا رحمة للعالمين', verseTranslation: 'Et Nous ne t\'avons envoyé que comme miséricorde pour les mondes'),
        ],
        speciality: 'Le Sceau des Prophètes - Dernier messager d\'Allah', imageUrl: 'assets/images/prophets/muhammad.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'Prophète Ibrahim', arabicName: 'إبراهيم', title: 'L\'Ami d\'Allah', lifespan: 'Env. 2165 - 2040 av. J.-C.', birthPlace: 'Ur des Chaldéens', deathPlace: 'Canaan',
        description: 'Jeunesse et Origines:\nLe Prophète Ibrahim (Abraham) est né dans une société profondément polythéiste. Bien que son père soit un célèbre sculpteur d\'idoles, Ibrahim rejeta l\'adoration des corps célestes et des statues, reconnaissant que le véritable Créateur doit être éternel.\n\nMission Prophétique et Épreuves:\nIl consacra sa vie à appeler son peuple à l\'unicité absolue d\'Allah. Lorsqu\'il détruisit leurs idoles, il fut condamné à être jeté dans un feu ardent par le roi Nimrod. Cependant, Allah ordonna miraculeusement au feu d\'être fraîcheur et paix pour lui.\n\nLe Sacrifice Ultime et Héritage:\nSon plus grand test fut lorsqu\'Allah lui ordonna en rêve de sacrifier son fils bien-aimé Ismail. Tous deux se soumirent. Juste avant d\'accomplir l\'acte, Allah remplaça Ismail par un bélier, établissant la tradition du sacrifice (Udhiyah) et du Hajj. Il reconstruisit plus tard la Kaaba avec Ismail.\n\nStatut en Islam:\nVénéré comme "Khalil-ullah" (L\'Ami d\'Allah) et le patriarche du monothéisme, sa soumission profonde fait de lui l\'un des plus grands prophètes.',
        keyAchievements: ['A appelé au monothéisme dans une société polythéiste', 'A construit la Kaaba avec son fils Ismail', 'A établi la tradition du Hajj', 'A démontré une soumission parfaite à Allah', 'A réussi toutes les épreuves divines'],
        quranicMentions: [
          QuranicMention(surahName: 'Al-Baqarah', surahArabic: 'البقرة', surahNumber: 2, verseNumber: 124, verseText: 'وإذ ابتلى إبراهيم ربه بكلمات فأتمهن', verseTranslation: 'Et quand Ibrahim fut éprouvé par son Seigneur par certains commandements, et qu\'il les accomplit'),
        ],
        speciality: 'Ami d\'Allah - Bâtisseur de la Kaaba', imageUrl: 'assets/images/prophets/ibrahim.png', mentionedInSurahs: 25,
      ),
      ProphetBiography(
        name: 'Prophète Moussa', arabicName: 'موسى', title: 'L\'Interlocuteur d\'Allah', lifespan: 'Env. 1393 - 1273 av. J.-C.', birthPlace: 'Égypte', deathPlace: 'Mont Sinaï',
        description: 'Naissance et Jeunesse:\nLe Prophète Moussa (Moïse) est né en Égypte à une époque où Pharaon ordonnait l\'exécution des garçons nouveau-nés. Sa mère, divinement inspirée, le plaça dans un panier sur le Nil. Miraculeusement, il fut adopté par la femme vertueuse de Pharaon, Asiya.\n\nProphétie et Appel Divin:\nAprès avoir fui vers Madyan, Moussa vécut une rencontre divine profonde au Mont Sinaï. Allah lui parla directement depuis un buisson ardent, lui accordant la prophétie et des miracles majeurs, comme son bâton se transformant en serpent. Il reçut l\'ordre de retourner affronter Pharaon.\n\nConfrontation et Exode:\nMoussa affronta la tyrannie de Pharaon et vainquit ses magiciens. Face au refus de Pharaon, Moussa mena les Israélites lors d\'un exode nocturne. Poursuivis par l\'armée, Allah fendit la mer Rouge, sauvant Moussa et noyant le tyran.\n\nGuidance et Héritage:\nMoussa reçut la Tawrat (Torah) sur le mont Sinaï. Connu sous le nom de "Kalim-ullah" (Celui qui a parlé directement à Allah), il est le prophète le plus fréquemment mentionné dans le Coran.',
        keyAchievements: ['A reçu la Torah avec les commandements divins', 'A accompli des signes miraculeux devant Pharaon', 'A mené les Israélites hors d\'Égypte', 'A communiqué directement avec Allah'],
        quranicMentions: [
          QuranicMention(surahName: 'Al-Qasas', surahArabic: 'القصص', surahNumber: 28, verseNumber: 30, verseText: 'يا موسى إني أنا الله رب العالمين', verseTranslation: 'Ô Moussa! C\'est Moi, Allah, le Seigneur de l\'univers'),
        ],
        speciality: 'L\'Interlocuteur - A parlé directement avec Allah', imageUrl: 'assets/images/prophets/musa.png', mentionedInSurahs: 36,
      ),
      ProphetBiography(
        name: 'Prophète Isa', arabicName: 'عيسى', title: 'L\'Esprit d\'Allah', lifespan: 'Env. 1 - 33 È.C.', birthPlace: 'Bethléem', deathPlace: 'Cieux',
        description: 'Naissance Miraculeuse:\nLe Prophète Isa (Jésus) fut conçu par un miracle profond, né de la Vierge Marie (Maryam) sans père humain. Le Coran précise qu\'il a été créé par l\'ordre direct d\'Allah. Nouveau-né, il parla miraculeusement depuis son berceau pour défendre l\'honneur de sa mère.\n\nMission Prophétique et Miracles:\nIsa fut envoyé aux Enfants d\'Israël pour confirmer la Torah et apporter une nouvelle Écriture, l\'Injil (Évangile). Par la permission d\'Allah, il guérit les aveugles, les lépreux et ressuscita les morts. Il appela au monothéisme pur.\n\nDéfis et Ascension:\nMalgré ses signes clairs, il fit face à une sévère opposition de l\'élite religieuse. Lorsqu\'ils conspirèrent pour le crucifier, le Coran affirme qu\'ils ne l\'ont ni tué ni crucifié. Allah l\'a élevé vers Lui, le sauvant de ses ennemis.\n\nPerspective Islamique et Retour:\nIsa est vénéré comme "Ruh-ullah" (L\'Esprit d\'Allah). Le Coran rejette la notion de sa divinité. L\'eschatologie islamique soutient qu\'il reviendra physiquement sur terre avant le Jour du Jugement pour restaurer la justice.',
        keyAchievements: ['Né miraculeusement sans père', 'A accompli des miracles par la permission d\'Allah', 'A reçu l\'Évangile (Injil)', 'Fait partie des cinq plus grands prophètes (Ouloul Azm)'],
        quranicMentions: [
          QuranicMention(surahName: 'Maryam', surahArabic: 'مريم', surahNumber: 19, verseNumber: 34, verseText: 'ذلك عيسى ابن مريم قول الحق الذي فيه يمترون', verseTranslation: 'Tel est Isa, fils de Maryam, parole de vérité dont ils doutent'),
        ],
        speciality: 'Né miraculeusement - L\'Esprit d\'Allah', imageUrl: 'assets/images/prophets/isa.png', mentionedInSurahs: 15,
      ),
      ProphetBiography(
        name: 'Prophète Nouh', arabicName: 'نوح', title: 'Le Premier Messager', lifespan: 'Env. 2900+ ans', birthPlace: 'Inconnu', deathPlace: 'Inconnu',
        description: 'Jeunesse et Société:\nLe Prophète Nouh (Noé) est l\'un des premiers messagers envoyés par Allah. Il vécut à une époque où les gens s\'étaient éloignés du monothéisme pour tomber dans l\'idolâtrie.\n\nMission Inébranlable:\nPendant 950 ans, Nouh appela inlassablement son peuple à n\'adorer que le Dieu Unique. Malgré sa patience immense, seul un très petit groupe de personnes crut en son message, tandis que l\'élite tribale se moquait de lui.\n\nL\'Arche et le Grand Déluge:\nLorsqu\'il devint clair que personne d\'autre ne croirait, Allah ordonna à Nouh de construire une arche massive. Sur ordre d\'Allah, des couples d\'animaux et les croyants dévoués embarquèrent. Un déluge mondial s\'ensuivit, noyant tous les mécréants.\n\nHéritage et Statut:\nParmi ceux qui se noyèrent se trouvait le propre fils de Nouh, qui refusa de rejoindre les croyants. Nouh est reconnu comme le premier des "Ouloul Azm" (Prophètes de Forte Résolution). Sa vie est le symbole ultime de la persévérance.',
        keyAchievements: ['Premier messager envoyé à l\'humanité', 'A prêché pendant 950 ans sans succès', 'A construit l\'arche sur ordre d\'Allah', 'A sauvé les croyants du Grand Déluge'],
        quranicMentions: [
          QuranicMention(surahName: 'Nouh', surahArabic: 'نوح', surahNumber: 71, verseNumber: 1, verseText: 'إنا أرسلنا نوحا إلى قومه أن أنذر قومك', verseTranslation: 'Nous avons envoyé Nouh vers son peuple: "Avertis ton peuple"'),
        ],
        speciality: 'Premier Messager - A prêché 950 ans', imageUrl: 'assets/images/prophets/nuh.png', mentionedInSurahs: 28,
      ),
      ProphetBiography(
        name: 'Prophète Ayub', arabicName: 'أيوب', title: 'Le Patient', lifespan: 'Env. 2000 av. J.-C.', birthPlace: 'Levant', deathPlace: 'Levant',
        description: 'Prospérité Initiale:\nLe Prophète Ayub (Job) fut initialement béni par Allah d\'une immense richesse et d\'une grande famille. Il était un chef très respecté, connu pour sa profonde piété et sa générosité envers les pauvres.\n\nLa Grande Épreuve:\nPour démontrer la pureté de la foi d\'Ayub, Allah le soumit à une épreuve sévère. Ayub perdit toute sa richesse et ses enfants périrent. Il fut également affligé d\'une maladie douloureuse qui ravagea son corps, poussant sa communauté à l\'abandonner.\n\nPatience et Sincérité:\nPendant des années, Ayub endura cette souffrance inimaginable sans la moindre plainte. Seule sa femme dévouée resta à ses côtés. Lorsqu\'il fit appel à Allah, sa prière fut remarquablement humble : "Le mal m\'a touché, et Tu es le plus miséricordieux des miséricordieux."\n\nRestauration et Héritage:\nAllah répondit à sa supplication, lui ordonnant de frapper le sol de son pied. Une source miraculeuse jaillit, le guérissant complètement. Allah restaura sa jeunesse, sa richesse et sa famille. Ayub reste l\'archétype éternel de la patience.',
        keyAchievements: ['Est resté patient à travers de sévères épreuves', 'A maintenu sa foi malgré la perte de santé et de richesse', 'Modèle absolu de patience dans la tradition islamique'],
        quranicMentions: [
          QuranicMention(surahName: 'Al-Anbiya', surahArabic: 'الأنبياء', surahNumber: 21, verseNumber: 83, verseText: 'وأيوب إذ نادى ربه أني مسني الضر وأنت أرحم الراحمين', verseTranslation: 'Et Ayub, quand il implora son Seigneur: "Le mal m\'a touché. Mais Toi, Tu es le plus miséricordieux"'),
        ],
        speciality: 'L\'Exemple absolu de la patience', imageUrl: 'assets/images/prophets/ayub.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'Prophète Youssouf', arabicName: 'يوسف', title: 'Le Véridique', lifespan: 'Env. 2100-2000 av. J.-C.', birthPlace: 'Canaan', deathPlace: 'Égypte',
        description: 'Naissance et Trahison:\nLe Prophète Youssouf (Joseph) était le fils bien-aimé du Prophète Yaqub (Jacob). Doté d\'une beauté exceptionnelle et de rêves prophétiques, il devint la cible de la jalousie de ses frères, qui le jetèrent dans un puits. Secouru, il fut vendu comme esclave en Égypte.\n\nÉpreuves et Emprisonnement:\nAcheté par un ministre égyptien, Youssouf grandit en un homme juste. La femme du ministre tenta de le séduire, mais Youssouf résista fermement. Pour protéger son honneur, il choisit l\'emprisonnement, où il continua à prêcher le monothéisme.\n\nAscension au Pouvoir:\nL\'interprétation divinement inspirée par Youssouf du rêve du roi - concernant sept années de famine - lui assura sa libération. Le roi le nomma ministre des finances. Youssouf géra les ressources de l\'Égypte, sauvant la région de la famine.\n\nRetrouvailles et Pardon:\nPendant la famine, ses frères vinrent en Égypte. Après une série de tests, Youssouf se révéla et pardonna complètement à ses frères pour leur trahison passée. Il retrouva son père, réalisant son rêve d\'enfance.',
        keyAchievements: ['A maintenu sa chasteté malgré la tentation', 'Est passé d\'esclave à ministre d\'Égypte', 'A pardonné à ses frères qui l\'avaient trahi', 'A sauvé la région d\'une grave famine'],
        quranicMentions: [
          QuranicMention(surahName: 'Youssouf', surahArabic: 'يوسف', surahNumber: 12, verseNumber: 33, verseText: 'قال رب السجن أحب إلي', verseTranslation: 'Il dit: Ô mon Seigneur, la prison m\'est préférable à ce à quoi elles m\'invitent'),
        ],
        speciality: 'Le Beau - Modèle de chasteté et de pardon', imageUrl: 'assets/images/prophets/yusuf.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'Prophète Younous', arabicName: 'يونس', title: 'L\'Homme à la Baleine', lifespan: 'Env. 800-700 av. J.-C.', birthPlace: 'Ninive', deathPlace: 'Ninive',
        description: 'Mission à Ninive:\nLe Prophète Younous (Jonas) fut envoyé à la ville corrompue de Ninive pour appeler ses habitants à adorer Allah seul. Cependant, le peuple rejeta obstinément son message et se moqua de ses avertissements.\n\nDépart et la Tempête:\nFrustré par le refus de son peuple, Younous quitta la ville avant de recevoir la permission d\'Allah. Il embarqua sur un navire. Une violente tempête menaça de couler le vaisseau. L\'équipage tira au sort pour savoir qui portait malheur, et le sort tomba sur Younous, qui fut jeté à la mer.\n\nLa Baleine et le Repentir:\nSur l\'ordre d\'Allah, une énorme baleine avala Younous. Dans les ténèbres du ventre de la baleine, Younous réalisa son erreur. Il se tourna vers Allah avec un profond repentir : "Il n\'y a de divinité que Toi ; pureté à Toi. J\'ai été vraiment du nombre des injustes." Allah ordonna à la baleine de le rejeter en toute sécurité sur le rivage.\n\nRédemption et Succès:\nUne fois rétabli, il retourna à Ninive. À son grand étonnement, toute la ville avait vu les signes du châtiment, s\'était repentie en masse et avait accepté la foi. Allah les épargna, faisant de Younous le seul prophète dont la nation entière crut et fut sauvée.',
        keyAchievements: ['A appelé Ninive à adorer Allah', 'S\'est repenti sincèrement lors de son épreuve', 'A réussi à amener toute sa nation à la foi'],
        quranicMentions: [
          QuranicMention(surahName: 'As-Safat', surahArabic: 'الصافات', surahNumber: 37, verseNumber: 142, verseText: 'فالتقمه الحوت وهو مليم', verseTranslation: 'Le poisson l\'avala alors qu\'il était blâmable'),
        ],
        speciality: 'Seul prophète dont la nation entière a cru', imageUrl: 'assets/images/prophets/yunus.png', mentionedInSurahs: 4,
      ),
      ProphetBiography(
        name: 'Prophète Souleyman', arabicName: 'سليمان', title: 'Le Roi Sage', lifespan: 'Env. 970-935 av. J.-C.', birthPlace: 'Jérusalem', deathPlace: 'Jérusalem',
        description: 'Ascension au Trône:\nLe Prophète Souleyman (Salomon) était le fils du Prophète Dawoud (David). Dès son jeune âge, il fit preuve d\'une sagesse extraordinaire et d\'un sens exceptionnel de la justice. À la mort de son père, il hérita à la fois de la prophétie et de la royauté.\n\nRoyaume Sans Précédent et Miracles:\nSouleyman demanda à Allah un royaume qui ne serait jamais accordé à personne après lui. Allah exauça cette prière, soumettant les forces de la nature à son commandement. Il reçut la capacité de comprendre les animaux et les oiseaux. Allah plaça le vent sous son contrôle et ordonna à des légions de djinns de le servir.\n\nLa Reine de Saba:\nL\'une de ses rencontres célèbres impliquait Bilqis, la reine de Saba, adoratrice du soleil. Souleyman l\'invita à l\'Islam. Lorsqu\'elle visita son majestueux palais, elle fut profondément humiliée par son pouvoir accordé par Dieu et se soumit à Allah.\n\nHéritage et Décès:\nMalgré sa richesse et son pouvoir inimaginables, Souleyman resta un serviteur humble d\'Allah. Son décès fut une profonde leçon : il mourut appuyé sur son bâton en observant les djinns au travail. Ils continuèrent à travailler pendant un an, ignorant sa mort jusqu\'à ce qu\'un termite ronge le bâton, prouvant que les djinns ne connaissent pas l\'invisible.',
        keyAchievements: ['A reçu un royaume et une sagesse sans précédent', 'Comprenait le langage des oiseaux et des animaux', 'Contrôlait le vent et les djinns par l\'ordre d\'Allah', 'A amené la Reine de Saba à l\'Islam'],
        quranicMentions: [
          QuranicMention(surahName: 'An-Naml', surahArabic: 'النمل', surahNumber: 27, verseNumber: 16, verseText: 'وورث سليمان داود وقال يا أيها الناس علمنا منطق الطير', verseTranslation: 'Salomon hérita de David et dit: Ô hommes! On nous a appris le langage des oiseaux'),
        ],
        speciality: 'Le Roi Sage - Comprenait les langages des animaux', imageUrl: 'assets/images/prophets/sulaiman.png', mentionedInSurahs: 16,
      ),
      ProphetBiography(
        name: 'Luqman', arabicName: 'لقمان', title: 'Le Sage', lifespan: 'Env. 750 av. J.-C.', birthPlace: 'Inconnu', deathPlace: 'Inconnu',
        description: 'Identité et Background:\nLuqman, connu sous le nom de Luqman le Sage, est une figure hautement vénérée. Bien que le consensus penche vers le fait qu\'il était un serviteur juste plutôt qu\'un prophète formel, ses enseignements moraux sont à jamais préservés dans le Coran.\n\nLe Don de la Sagesse:\nLe Coran déclare qu\'Allah a accordé "Hikmah" (la sagesse profonde) à Luqman. Cette sagesse divine se caractérisait par une compréhension profonde des réalités de la vie et une gratitude constante envers le Créateur.\n\nEnseignements à son Fils:\nL\'héritage durable de Luqman est immortalisé dans le 31e chapitre du Coran. Il a transmis des conseils magnifiques et complets à son fils, commençant par une stricte interdiction du Shirk (associer des partenaires à Allah). Il lui ordonna d\'établir la prière et d\'endurer les épreuves avec patience.\n\nÉthique Sociale:\nDe plus, les conseils de Luqman ont établi un modèle parfait de conduite sociale. Il a mis en garde contre l\'arrogance, conseillant à son fils de marcher sur terre avec humilité et de baisser la voix. Luqman sert de modèle coranique ultime pour la parentalité.',
        keyAchievements: ['A préservé des enseignements moraux dans le Coran', 'A fourni une guidance parentale exemplaire', 'A mis l\'accent sur le monothéisme et la gratitude', 'A plaidé pour la justice et la gentillesse'],
        quranicMentions: [
          QuranicMention(surahName: 'Luqman', surahArabic: 'لقمان', surahNumber: 31, verseNumber: 13, verseText: 'وإذ قال لقمان لابنه وهو يعظه يا بني لا تشرك بالله', verseTranslation: 'Et lorsque Luqman dit à son fils tout en l\'exhortant: Ô mon fils, ne donne pas d\'associé à Allah'),
        ],
        speciality: 'Le Sage - Modèle d\'enseignant moral', imageUrl: 'assets/images/prophets/luqman.png', mentionedInSurahs: 1,
      ),
    ];
  }
}