import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/theme_service.dart';
import '../widgets/islamic_pattern_background.dart';

/* ══════════════════════════════════════════════════════════════════════════
   GLOBAL STATE (shared between list screen & detail screen)
   ══════════════════════════════════════════════════════════════════════════ */

/// Favourite hadith ids — persisted in memory for the session.
final ValueNotifier<Set<String>> favoriteHadiths = ValueNotifier<Set<String>>({});

/// Reader font scale (1.0 = normal, 1.4 = large).
final ValueNotifier<double> hadithFontScale = ValueNotifier<double>(1.0);

/* ══════════════════════════════════════════════════════════════════════════
   MODELS
   ══════════════════════════════════════════════════════════════════════════ */

class HadithCategory {
  final String id;
  final String nameAr;
  final String nameEn;
  final String nameFr;
  final IconData icon;

  const HadithCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.nameFr,
    required this.icon,
  });
}

const List<HadithCategory> hadithCategories = [
  HadithCategory(
      id: 'all',
      nameAr: 'الكل',
      nameEn: 'All',
      nameFr: 'Tout',
      icon: Icons.all_inclusive_rounded),
  HadithCategory(
      id: 'worship',
      nameAr: 'العبادة والإيمان',
      nameEn: 'Worship & Faith',
      nameFr: 'Adoration et Foi',
      icon: Icons.mosque_rounded),
  HadithCategory(
      id: 'character',
      nameAr: 'الأخلاق والآداب',
      nameEn: 'Character & Manners',
      nameFr: 'Caractère et Manières',
      icon: Icons.favorite_rounded),
  HadithCategory(
      id: 'community',
      nameAr: 'المجتمع والأخوة',
      nameEn: 'Community & Brotherhood',
      nameFr: 'Communauté et Fraternité',
      icon: Icons.people_rounded),
  HadithCategory(
      id: 'family',
      nameAr: 'الأسرة والعلاقات',
      nameEn: 'Family & Relationships',
      nameFr: 'Famille et Relations',
      icon: Icons.family_restroom_rounded),
  HadithCategory(
      id: 'knowledge',
      nameAr: 'العلم',
      nameEn: 'Knowledge',
      nameFr: 'Savoir',
      icon: Icons.menu_book_rounded),
  HadithCategory(
      id: 'patience',
      nameAr: 'الصبر والابتلاء',
      nameEn: 'Patience & Trials',
      nameFr: 'Patience et Épreuves',
      icon: Icons.shield_rounded),
  HadithCategory(
      id: 'business',
      nameAr: 'التجارة والمال',
      nameEn: 'Business & Wealth',
      nameFr: 'Commerce et Richesse',
      icon: Icons.monetization_on_rounded),
];

class Hadith {
  final String id;
  final List<String> categories;

  final String titleAr;
  final String titleEn;
  final String titleFr;

  final String textAr;
  final String textEn;
  final String textFr;

  final String narratorAr;
  final String narratorEn;
  final String narratorFr;

  final String eventAr;
  final String eventEn;
  final String eventFr;

  final String meaningAr;
  final String meaningEn;
  final String meaningFr;

  final String sourceAr;
  final String sourceEn;
  final String sourceFr;

  final String gradeAr;
  final String gradeEn;
  final String gradeFr;

  final List<String> lessonsAr;
  final List<String> lessonsEn;
  final List<String> lessonsFr;

  const Hadith({
    required this.id,
    required this.categories,
    required this.titleAr,
    required this.titleEn,
    required this.titleFr,
    required this.textAr,
    required this.textEn,
    required this.textFr,
    required this.narratorAr,
    required this.narratorEn,
    required this.narratorFr,
    required this.eventAr,
    required this.eventEn,
    required this.eventFr,
    required this.meaningAr,
    required this.meaningEn,
    required this.meaningFr,
    required this.sourceAr,
    required this.sourceEn,
    required this.sourceFr,
    required this.gradeAr,
    required this.gradeEn,
    required this.gradeFr,
    required this.lessonsAr,
    required this.lessonsEn,
    required this.lessonsFr,
  });
}

/* ══════════════════════════════════════════════════════════════════════════
   MASTER HADITH LIBRARY
   ══════════════════════════════════════════════════════════════════════════ */

const List<Hadith> allHadiths = [
  /* ─────────────────────────── 1 ─────────────────────────── */
  Hadith(
    id: 'h_intention',
    categories: ['worship', 'character'],
    titleAr: 'حديث النية',
    titleEn: 'Hadith of Intention',
    titleFr: 'Hadith de l\'Intention',
    textAr:
        'إنما الأعمال بالنيات، وإنما لكل امرئ ما نوى، فمن كانت هجرته إلى الله ورسوله فهجرته إلى الله ورسوله، ومن كانت هجرته لدنيا يصيبها أو امرأة ينكحها فهجرته إلى ما هاجر إليه',
    textEn:
        'Indeed, all deeds are judged by intention, and every person will have only what they intended. So whoever migrated for the sake of Allah and His Messenger, his migration is for Allah and His Messenger. And whoever migrated for a worldly gain or a woman to marry, his migration is for what he migrated for',
    textFr:
        'Les actions ne sont jugées que par les intentions, et chacun n\'aura que ce qu\'il a eu l\'intention de faire. Celui qui émigre pour Allah et Son Messager, son émigration est pour Allah et Son Messager. Et celui qui émigre pour un gain mondain ou pour épouser une femme, son émigration est pour ce pour quoi il a émigré',
    narratorAr: 'عن عمر بن الخطاب رضي الله عنه',
    narratorEn: 'Narrated by Umar ibn Al-Khattab (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Umar ibn Al-Khattab (qu\'Allah l\'agrée)',
    eventAr:
        'أول حديث في صحيح البخاري، قاله النبي ﷺ على المنبر في بداية الهجرة إلى المدينة، ليربّي أصحابه على تصحيح المقاصد قبل الأعمال',
    eventEn:
        'The very first hadith in Sahih al-Bukhari, delivered by the Prophet ﷺ on the pulpit at the beginning of the migration to Medina, to train his companions to purify their motives before their deeds',
    eventFr:
        'Le tout premier hadith du Sahih al-Bukhari, prononcé par le Prophète ﷺ depuis la chaire au début de l\'Hégire vers Médine, afin d\'éduquer ses compagnons à purifier leurs intentions avant leurs actes',
    meaningAr:
        'هذا الحديث أصل عظيم في الدين، فهو يقرر أن ظاهر العمل لا قيمة له دون نية صحيحة، وأن قيمة الأعمال عند الله تتفاوت بتفاوت ما يقوم في القلب من إخلاص وصدق وقصد. ولذلك كان السلف يتعلمون النية كما يتعلمون العمل، لأن النية هي روح العبادة التي بدونها تصبح حركة جسد بلا معنى',
    meaningEn:
        'This hadith is a great foundation of the religion. It establishes that the outward form of a deed is worthless without a sound intention, and that the value of deeds with Allah varies according to the sincerity, truthfulness and purpose that reside in the heart. For this reason the early scholars used to study intention just as they studied the deed itself, because intention is the soul of worship — without it, worship becomes a meaningless movement of the body',
    meaningFr:
        'Ce hadith est un fondement majeur de la religion. Il établit que l\'apparence extérieure d\'un acte est sans valeur sans une intention saine, et que la valeur des actes auprès d\'Allah varie selon la sincérité, la véracité et le but qui habitent le cœur. C\'est pourquoi les premiers savants étudiaient l\'intention autant que l\'acte lui-même, car l\'intention est l\'âme de l\'adoration — sans elle, l\'adoration devient un simple mouvement du corps',
    sourceAr: 'صحيح البخاري (١) وصحيح مسلم (١٩٠٧)',
    sourceEn: 'Sahih al-Bukhari (1) & Sahih Muslim (1907)',
    sourceFr: 'Sahih al-Bukhari (1) et Sahih Muslim (1907)',
    gradeAr: 'متفق عليه',
    gradeEn: 'Authentic — unanimously agreed upon',
    gradeFr: 'Authentique — unanimement reconnu',
    lessonsAr: [
      'النية شرط أساسي لصحة العمل وقبوله عند الله',
      'الأعمال تتفاضل بحسب ما يقوم في القلب من إخلاص',
      'المسلم يجدد نيته عند كل عمل صغير أو كبير',
      'الإخلاص يحوّل العادات اليومية إلى عبادات مأجورة',
      'الحذر من الرياء فإنه يحبط العمل ولو كان عظيماً',
    ],
    lessonsEn: [
      'Intention is an essential condition for a deed to be valid and accepted',
      'Deeds differ in rank according to the sincerity in the heart',
      'A Muslim renews his intention before every deed, small or great',
      'Sincerity turns everyday habits into rewarded acts of worship',
      'Beware of showing off — it cancels a deed even if it was great',
    ],
    lessonsFr: [
      'L\'intention est une condition essentielle de validité et d\'acceptation',
      'Les actes diffèrent de rang selon la sincérité du cœur',
      'Le musulman renouvelle son intention avant chaque acte, petit ou grand',
      'La sincérité transforme les habitudes quotidiennes en actes récompensés',
      'Prenez garde à l\'ostentation — elle annule l\'acte même s\'il est grand',
    ],
  ),

  /* ─────────────────────────── 2 ─────────────────────────── */
  Hadith(
    id: 'h_mercy',
    categories: ['character', 'community'],
    titleAr: 'حديث الرحمة',
    titleEn: 'Hadith of Mercy',
    titleFr: 'Hadith de la Miséricorde',
    textAr:
        'الراحمون يرحمهم الرحمن، ارحموا من في الأرض يرحمكم من في السماء',
    textEn:
        'The merciful will be shown mercy by the Merciful. Be merciful to those on earth, and the One in the heavens will have mercy upon you',
    textFr:
        'Les miséricordieux seront traités avec miséricorde par le Miséricordieux. Ayez de la miséricorde envers ceux sur terre et Celui qui est au ciel vous montrera de la miséricorde',
    narratorAr: 'عن عبد الله بن عمرو بن العاص رضي الله عنهما',
    narratorEn: 'Narrated by Abdullah ibn Amr ibn al-As (may Allah be pleased with them)',
    narratorFr: 'Rapporté par Abdullah ibn Amr ibn al-As (qu\'Allah les agrée)',
    eventAr:
        'قاله النبي ﷺ تعليماً لأصحابه أن الرحمة ليست عاطفة عابرة، بل منهج حياة يشمل الإنسان والحيوان والطير، وكل ما يقع تحت يد الإنسان',
    eventEn:
        'The Prophet ﷺ taught his companions that mercy is not a passing emotion but a whole way of life that embraces humans, animals, birds, and everything under a person\'s care',
    eventFr:
        'Le Prophète ﷺ enseigna à ses compagnons que la miséricorde n\'est pas une émotion passagère mais un mode de vie qui englobe les humains, les animaux, les oiseaux et tout ce qui est confié à l\'homme',
    meaningAr:
        'يقرر الحديث قاعدة الجزاء من جنس العمل: من رحم الناس رحمه الله، ومن قسا عليهم حُرم الرحمة. والرحمة المطلوبة ليست ضعفاً ولا تفريطاً في الحق، بل هي رقة في القلب مع حزم في الحق، تشمل الصغير والكبير والمسلم وغير المسلم، بل والحيوان الأعجم',
    meaningEn:
        'The hadith lays down the rule that the reward matches the deed: whoever shows mercy to people will be shown mercy by Allah, and whoever is harsh to them will be deprived of mercy. The required mercy is neither weakness nor negligence of the truth; it is tenderness of heart combined with firmness upon the truth, covering the young and the old, the Muslim and the non-Muslim, and even the voiceless animal',
    meaningFr:
        'Le hadith pose la règle selon laquelle la récompense correspond à l\'acte : celui qui fait miséricorde aux gens recevra la miséricorde d\'Allah, et celui qui est dur envers eux en sera privé. La miséricorde requise n\'est ni faiblesse ni négligence de la vérité ; c\'est une tendresse du cœur alliée à la fermeté sur la vérité, englobant le petit et le grand, le musulman et le non-musulman, et même l\'animal sans parole',
    sourceAr: 'سنن الترمذي (١٩٢٤) وسنن أبي داود (٤٩٤١)',
    sourceEn: 'Sunan al-Tirmidhi (1924) & Sunan Abu Dawud (4941)',
    sourceFr: 'Sunan al-Tirmidhi (1924) et Sunan Abu Dawud (4941)',
    gradeAr: 'صحيح',
    gradeEn: 'Authentic (Sahih)',
    gradeFr: 'Authentique (Sahih)',
    lessonsAr: [
      'الرحمة بالخلق سبب لنيل رحمة الله تعالى',
      'الرحمة تشمل الإنسان والحيوان والبيئة من حولنا',
      'القسوة على الناس علامة على حرمان القلب من الخير',
      'الرحمة لا تعني التهاون في الحقوق والحدود',
      'أعظم الرحمة رحمة العالم بعلمه ودعوته وإرشاده',
    ],
    lessonsEn: [
      'Showing mercy to creation is a reason to obtain Allah\'s mercy',
      'Mercy covers people, animals and the environment around us',
      'Harshness toward people is a sign that the heart is deprived of good',
      'Mercy does not mean neglecting rights and boundaries',
      'The greatest mercy is that of a scholar who teaches and guides',
    ],
    lessonsFr: [
      'Faire miséricorde à la création est une cause d\'obtention de la miséricorde d\'Allah',
      'La miséricorde englobe les gens, les animaux et l\'environnement',
      'La dureté envers les gens est le signe d\'un cœur privé de bien',
      'La miséricorde ne signifie pas négliger les droits et les limites',
      'La plus grande miséricorde est celle du savant qui enseigne et guide',
    ],
  ),

  /* ─────────────────────────── 3 ─────────────────────────── */
  Hadith(
    id: 'h_knowledge',
    categories: ['knowledge'],
    titleAr: 'حديث طلب العلم',
    titleEn: 'Hadith of Seeking Knowledge',
    titleFr: 'Hadith de la Quête du Savoir',
    textAr: 'طلب العلم فريضة على كل مسلم ومسلمة',
    textEn:
        'Seeking knowledge is an obligation upon every Muslim, male and female',
    textFr:
        'La quête du savoir est une obligation pour tout musulman et toute musulmane',
    narratorAr: 'عن أنس بن مالك رضي الله عنه',
    narratorEn: 'Narrated by Anas ibn Malik (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Anas ibn Malik (qu\'Allah l\'agrée)',
    eventAr:
        'حثّ النبي ﷺ أصحابه على العلم في كل وقت، وجعل طلبه فريضة لا تسقط عن المسلم مهما كان عمره أو مكانته أو انشغاله',
    eventEn:
        'The Prophet ﷺ urged his companions to seek knowledge at all times, and made it an obligation that never falls away from a Muslim regardless of age, status or occupation',
    eventFr:
        'Le Prophète ﷺ encouragea ses compagnons à chercher le savoir en tout temps, et en fit une obligation qui ne quitte jamais le musulman, quel que soit son âge, son rang ou ses occupations',
    meaningAr:
        'العلم في الإسلام ليس ترفاً فكرياً ولا رفاهية ثقافية، بل هو فريضة تُمكّن المسلم من أداء عبادته على وجهها الصحيح، ومن التعامل مع دنياه بالحكمة والعدل. والفرض منه ما يتوقف عليه صحة الإيمان والعبادة، والزائد عليه نافلة يرفع الله بها الدرجات ويفتح بها أبواب الخير للأمة كلها',
    meaningEn:
        'In Islam, knowledge is neither intellectual luxury nor cultural leisure; it is an obligation that enables a Muslim to perform worship correctly and to deal with worldly life with wisdom and justice. The obligatory portion is whatever a person\'s faith and worship depend upon, and whatever exceeds that is a voluntary good through which Allah raises ranks and opens the doors of goodness for the whole nation',
    meaningFr:
        'En Islam, le savoir n\'est ni un luxe intellectuel ni un loisir culturel ; c\'est une obligation qui permet au musulman d\'accomplir correctement son adoration et d\'aborder sa vie mondaine avec sagesse et justice. La part obligatoire est ce dont dépendent sa foi et son adoration ; au-delà, c\'est un surplus par lequel Allah élève les rangs et ouvre les portes du bien à toute la communauté',
    sourceAr: 'سنن ابن ماجه (٢٢٤)',
    sourceEn: 'Sunan Ibn Majah (224)',
    sourceFr: 'Sunan Ibn Majah (224)',
    gradeAr: 'حسن',
    gradeEn: 'Good (Hasan)',
    gradeFr: 'Bon (Hasan)',
    lessonsAr: [
      'العلم فريضة على الرجال والنساء على حد سواء',
      'أول ما يجب تعلمه ما تصح به العقيدة والعبادة',
      'العلم النافع يُعمَل به ويُعلَّم ولا يُكتَم',
      'طلب العلم لا ينتهي عند سن معيّنة بل يستمر مدى الحياة',
      'الجهل بالدين سبب رئيسي في الانحراف والبدع',
    ],
    lessonsEn: [
      'Knowledge is an obligation on men and women alike',
      'The first thing to learn is what makes belief and worship valid',
      'Beneficial knowledge must be acted upon and taught, not concealed',
      'Seeking knowledge does not end at a certain age — it lasts a lifetime',
      'Ignorance of the religion is a major cause of deviation and innovation',
    ],
    lessonsFr: [
      'Le savoir est une obligation pour les hommes comme pour les femmes',
      'La première chose à apprendre est ce qui rend valides la foi et l\'adoration',
      'Le savoir utile doit être pratiqué et enseigné, non dissimulé',
      'La quête du savoir ne s\'arrête pas à un âge donné — elle dure toute la vie',
      'L\'ignorance de la religion est une cause majeure de déviation',
    ],
  ),

  /* ─────────────────────────── 4 ─────────────────────────── */
  Hadith(
    id: 'h_character',
    categories: ['character'],
    titleAr: 'حديث حسن الخلق',
    titleEn: 'Hadith of Good Character',
    titleFr: 'Hadith du Bon Caractère',
    textAr:
        'إن من أحبكم إليّ وأقربكم مني مجلساً يوم القيامة أحاسنكم أخلاقاً، وإن أبغضكم إليّ وأبعدكم مني مجلساً يوم القيامة الثرثارون والمتشدقون والمتفيهقون',
    textEn:
        'The most beloved of you to me and the nearest to me on the Day of Resurrection are those with the best character. The most hateful of you to me and the farthest from me on that Day are the loud talkers, the boastful and the arrogant',
    textFr:
        'Les plus aimés de moi et les plus proches de moi le Jour de la Résurrection sont ceux qui ont le meilleur caractère. Les plus détestés de moi et les plus éloignés de moi ce Jour-là sont les grands parleurs, les vantards et les orgueilleux',
    narratorAr: 'عن أبي هريرة رضي الله عنه',
    narratorEn: 'Narrated by Abu Hurairah (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Abu Hurairah (qu\'Allah l\'agrée)',
    eventAr:
        'بيّن النبي ﷺ معيار القرب منه يوم القيامة، فجعله الأخلاق لا المظاهر، ليعلم الصحابة أن أثقل ما يوضع في الميزان هو حسن الخلق',
    eventEn:
        'The Prophet ﷺ explained the criterion of nearness to him on the Day of Resurrection, making it good character rather than appearances, so the companions would know that nothing is heavier on the scales than good manners',
    eventFr:
        'Le Prophète ﷺ expliqua le critère de la proximité de lui au Jour de la Résurrection : le bon caractère, et non les apparences, afin que les compagnons sachent que rien n\'est plus lourd dans la balance que les bonnes manières',
    meaningAr:
        'حسن الخلق ليس مجرد بشاشة في الوجه، بل هو منظومة كاملة: صبر على الأذى، وكفّ عن البذاءة، ولين في القول، وإنصاف في المعاملة، وعفو عند المقدرة. وهو من أثقل الأعمال في الميزان، لأنه يترجم الإيمان إلى سلوك يومي يراه الناس ويقتدون به',
    meaningEn:
        'Good character is not merely a smiling face; it is a complete system: patience under harm, restraint from foul speech, gentleness in words, fairness in dealings, and forgiveness when one has power. It is among the heaviest deeds on the scales, because it translates faith into daily conduct that people can see and imitate',
    meaningFr:
        'Le bon caractère n\'est pas seulement un visage souriant ; c\'est un système complet : patience face au tort, retenue de la grossièreté, douceur dans les paroles, équité dans les transactions et pardon quand on a le pouvoir. C\'est l\'un des actes les plus lourds dans la balance, car il traduit la foi en conduite quotidienne que les gens voient et imitent',
    sourceAr: 'سنن الترمذي (٢٠١٨)',
    sourceEn: 'Sunan al-Tirmidhi (2018)',
    sourceFr: 'Sunan al-Tirmidhi (2018)',
    gradeAr: 'صحيح',
    gradeEn: 'Authentic (Sahih)',
    gradeFr: 'Authentique (Sahih)',
    lessonsAr: [
      'الأخلاق الحسنة من أعظم أسباب القرب من النبي ﷺ يوم القيامة',
      'الثرثرة والتفاخر والغرور تُبعد صاحبها عن النبي ﷺ',
      'الخلق الحسن يُثقل الميزان ولو قلّ العمل',
      'القدوة العملية أنفع في الدعوة من الكلام الكثير',
      'المؤمن يجمع بين العبادة الصحيحة والمعاملة الطيبة',
    ],
    lessonsEn: [
      'Good character is among the greatest means of nearness to the Prophet ﷺ',
      'Loud talk, boasting and arrogance drive a person far from the Prophet ﷺ',
      'Good character weighs heavy on the scales even with few deeds',
      'A practical example is more effective in calling to Allah than many words',
      'A believer combines sound worship with excellent dealings',
    ],
    lessonsFr: [
      'Le bon caractère est l\'un des plus grands moyens de proximité du Prophète ﷺ',
      'Le bavardage, la vantardise et l\'orgueil éloignent du Prophète ﷺ',
      'Le bon caractère pèse lourd dans la balance même avec peu d\'actes',
      'L\'exemple pratique est plus efficace que beaucoup de paroles',
      'Le croyant allie une adoration correcte à d\'excellents rapports',
    ],
  ),

  /* ─────────────────────────── 5 ─────────────────────────── */
  Hadith(
    id: 'h_truth',
    categories: ['character', 'worship'],
    titleAr: 'حديث الصدق',
    titleEn: 'Hadith of Truthfulness',
    titleFr: 'Hadith de l\'Honnêteté',
    textAr:
        'عليكم بالصدق، فإن الصدق يهدي إلى البر، وإن البر يهدي إلى الجنة، وما يزال الرجل يصدق ويتحرى الصدق حتى يُكتب عند الله صدّيقاً',
    textEn:
        'You must be truthful, for truthfulness leads to righteousness, and righteousness leads to Paradise. A man keeps speaking the truth and seeking the truth until he is recorded with Allah as a truthful one',
    textFr:
        'Soyez honnêtes, car l\'honnêteté mène à la vertu, et la vertu mène au Paradis. L\'homme ne cesse de dire la vérité et de la rechercher jusqu\'à ce qu\'il soit inscrit auprès d\'Allah comme véridique',
    narratorAr: 'عن عبد الله بن مسعود رضي الله عنه',
    narratorEn: 'Narrated by Abdullah ibn Masud (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Abdullah ibn Masud (qu\'Allah l\'agrée)',
    eventAr:
        'وصية جامعة من النبي ﷺ لأصحابه بالتزام الصدق في القول والعمل والنية، لأن الصدق أساس كل خير في الدنيا والآخرة',
    eventEn:
        'A comprehensive instruction from the Prophet ﷺ to his companions to adhere to truthfulness in speech, deed and intention, because truthfulness is the foundation of all good in this life and the next',
    eventFr:
        'Une instruction complète du Prophète ﷺ à ses compagnons d\'adhérer à la véracité dans la parole, l\'acte et l\'intention, car la véracité est le fondement de tout bien ici-bas et dans l\'au-delà',
    meaningAr:
        'الصدق في الإسلام شامل: صدق مع الله في النية، وصدق مع الناس في القول، وصدق مع النفس في العمل. وهو ليس خُلُقاً اجتماعياً فقط بل عبادة قلبية تُثمر البرّ، والبرّ جماع كل الطاعات. أما الكذب فهو أمّ الفواحش لأنه يجرّ إلى النار ويفسد الثقة بين الناس',
    meaningEn:
        'Truthfulness in Islam is comprehensive: truthfulness with Allah in intention, truthfulness with people in speech, and truthfulness with oneself in action. It is not merely a social virtue but an act of worship of the heart that yields righteousness, and righteousness gathers all forms of obedience. Lying, by contrast, is the mother of vices — it drags its companion to the Fire and destroys trust among people',
    meaningFr:
        'La véracité en Islam est globale : véracité avec Allah dans l\'intention, véracité avec les gens dans la parole, et véracité avec soi-même dans l\'acte. Ce n\'est pas seulement une vertu sociale mais une adoration du cœur qui produit la piété, et la piété rassemble toutes les obéissances. Le mensonge, à l\'inverse, est la mère des vices — il conduit au Feu et détruit la confiance entre les gens',
    sourceAr: 'صحيح البخاري (٦٠٩٤) وصحيح مسلم (٢٦٠٧)',
    sourceEn: 'Sahih al-Bukhari (6094) & Sahih Muslim (2607)',
    sourceFr: 'Sahih al-Bukhari (6094) et Sahih Muslim (2607)',
    gradeAr: 'متفق عليه',
    gradeEn: 'Authentic — unanimously agreed upon',
    gradeFr: 'Authentique — unanimement reconnu',
    lessonsAr: [
      'الصدق يهدي إلى البر، والبر يهدي إلى الجنة',
      'المداومة على الصدق ترفع العبد إلى درجة الصديقين',
      'الكذب يهدي إلى الفجور، والفجور يهدي إلى النار',
      'الصدق يشمل القول والفعل والنية جميعاً',
      'صدق الإنسان مع نفسه أول خطوات الاستقامة',
    ],
    lessonsEn: [
      'Truthfulness leads to righteousness, and righteousness leads to Paradise',
      'Persisting in truthfulness raises a servant to the rank of the truthful',
      'Lying leads to wickedness, and wickedness leads to the Fire',
      'Truthfulness covers speech, action and intention together',
      'Being truthful with oneself is the first step of steadfastness',
    ],
    lessonsFr: [
      'La véracité mène à la piété, et la piété mène au Paradis',
      'Persévérer dans la véracité élève le serviteur au rang des véridiques',
      'Le mensonge mène à la perversité, et la perversité au Feu',
      'La véracité englobe la parole, l\'acte et l\'intention',
      'Être véridique avec soi-même est le premier pas de la droiture',
    ],
  ),

  /* ─────────────────────────── 6 ─────────────────────────── */
  Hadith(
    id: 'h_patience',
    categories: ['patience', 'character'],
    titleAr: 'حديث الصبر',
    titleEn: 'Hadith of Patience',
    titleFr: 'Hadith de la Patience',
    textAr:
        'وما أُعطي أحدٌ عطاءً خيراً وأوسع من الصبر، ومن يتصبّر يصبّره الله، وما أحدٌ أوسع الله عليه في الدنيا إلا كان الصبر خيراً له',
    textEn:
        'No one has been given a gift better and more vast than patience. Whoever tries to be patient, Allah will grant him patience. And no one has been given abundance in this world except that patience was better for him',
    textFr:
        'Personne n\'a reçu un don meilleur et plus vaste que la patience. Celui qui s\'efforce d\'être patient, Allah lui accorde la patience. Et personne n\'a reçu l\'abondance ici-bas sans que la patience ne soit meilleure pour lui',
    narratorAr: 'عن أبي سعيد الخدري رضي الله عنه',
    narratorEn: 'Narrated by Abu Said al-Khudri (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Abu Said al-Khudri (qu\'Allah l\'agrée)',
    eventAr:
        'قاله النبي ﷺ في سياق تربية الصحابة على مواجهة الشدائد، وبيان أن الصبر ليس استسلاماً للضعف بل قوة نفسية تُستمد من التوكل على الله',
    eventEn:
        'The Prophet ﷺ said this while training his companions to face hardships, clarifying that patience is not surrender to weakness but a strength of the soul drawn from reliance upon Allah',
    eventFr:
        'Le Prophète ﷺ le dit en formant ses compagnons à affronter les épreuves, précisant que la patience n\'est pas une soumission à la faiblesse mais une force de l\'âme puisée dans la confiance en Allah',
    meaningAr:
        'الصبر ثلاث درجات: صبر على الطاعة، وصبر عن المعصية، وصبر على البلاء. وهو من أوسع عطايا الله لأنه يحفظ صاحبه من الجزع ويفتح له أبواب الرضا. ومن تصبّر وتكلّف الصبر في بدايته، منحه الله صبراً حقيقياً في نهايته، فالصبر مكابدة أولاً ثم يصير طبعاً وسكينة',
    meaningEn:
        'Patience has three levels: patience in obeying Allah, patience in abstaining from sin, and patience under calamity. It is among Allah\'s most expansive gifts, because it protects its owner from panic and opens the doors of contentment. Whoever forces himself to be patient at the beginning, Allah grants him true patience in the end — patience is first a struggle, then it becomes a trait and a calm',
    meaningFr:
        'La patience a trois degrés : patience dans l\'obéissance, patience dans l\'abstention du péché, et patience dans l\'épreuve. Elle est l\'un des dons les plus vastes d\'Allah, car elle protège son détenteur de la panique et ouvre les portes de la satisfaction. Celui qui s\'impose la patience au début, Allah lui accorde une patience véritable à la fin — la patience est d\'abord un effort, puis elle devient un trait de caractère et une sérénité',
    sourceAr: 'صحيح البخاري (١٤٦٩) وصحيح مسلم (١٠٥٣)',
    sourceEn: 'Sahih al-Bukhari (1469) & Sahih Muslim (1053)',
    sourceFr: 'Sahih al-Bukhari (1469) et Sahih Muslim (1053)',
    gradeAr: 'متفق عليه',
    gradeEn: 'Authentic — unanimously agreed upon',
    gradeFr: 'Authentique — unanimement reconnu',
    lessonsAr: [
      'الصبر من أوسع عطايا الله للإنسان المؤمن',
      'من يتكلف الصبر يمنحه الله صبراً حقيقياً',
      'الصبر ثلاثة أنواع: على الطاعة، وعن المعصية، وعلى البلاء',
      'الصبر لا يعني الرضا بالذل بل هو قوة مع التوكل',
      'أجر الصبر لا يُحدّ ولا يُعدّ لأنه بغير حساب',
    ],
    lessonsEn: [
      'Patience is among the most expansive gifts Allah gives the believer',
      'Whoever forces himself to be patient, Allah grants him real patience',
      'Patience has three types: in obedience, from sin, and under trial',
      'Patience is not accepting humiliation; it is strength combined with reliance',
      'The reward of patience is limitless because it is given without measure',
    ],
    lessonsFr: [
      'La patience est l\'un des dons les plus vastes d\'Allah au croyant',
      'Celui qui s\'impose la patience, Allah lui accorde une patience réelle',
      'La patience a trois types : dans l\'obéissance, loin du péché, dans l\'épreuve',
      'La patience n\'est pas accepter l\'humiliation ; c\'est une force avec la confiance',
      'La récompense de la patience est sans limite car elle est donnée sans mesure',
    ],
  ),

  /* ─────────────────────────── 7 ─────────────────────────── */
  Hadith(
    id: 'h_brother',
    categories: ['community'],
    titleAr: 'حديث نصرة الأخ',
    titleEn: 'Hadith of Helping Your Brother',
    titleFr: 'Hadith d\'Aider Votre Frère',
    textAr:
        'انصر أخاك ظالماً أو مظلوماً، فقال رجل: يا رسول الله أنصره إذا كان مظلوماً، أفرأيت إذا كان ظالماً كيف أنصره؟ قال: تحجزه أو تمنعه من الظلم، فإن ذلك نصره',
    textEn:
        'Help your brother whether he is an oppressor or oppressed. A man asked: O Messenger of Allah, I help him when he is oppressed, but how do I help him when he is an oppressor? He said: Prevent him or stop him from injustice — that is how you help him',
    textFr:
        'Aidez votre frère, qu\'il soit oppresseur ou opprimé. Un homme dit : ô Messager d\'Allah, je l\'aide quand il est opprimé, mais comment l\'aider quand il est oppresseur ? Il dit : Empêchez-le de commettre l\'injustice — voilà comment vous l\'aidez',
    narratorAr: 'عن أنس بن مالك رضي الله عنه',
    narratorEn: 'Narrated by Anas ibn Malik (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Anas ibn Malik (qu\'Allah l\'agrée)',
    eventAr:
        'سؤال الصحابة عن معنى النصرة، فبيّن النبي ﷺ أن نصرة الظالم تكون بمنعه من ظلمه لا بتأييده، وهي أعظم نصرة لأنها تنجيه من النار',
    eventEn:
        'The companions asked about the meaning of support, and the Prophet ﷺ clarified that supporting an oppressor means preventing him from his injustice, not backing him — and that is the greatest support because it saves him from the Fire',
    eventFr:
        'Les compagnons interrogèrent le sens du soutien, et le Prophète ﷺ précisa que soutenir un oppresseur consiste à l\'empêcher d\'opprimer, non à le soutenir — c\'est le plus grand soutien car cela le sauve du Feu',
    meaningAr:
        'الأخوة الإسلامية ليست تعصباً لطائفة أو قبيلة، بل هي التزام بالحق والعدل. فمن رأى أخاه يظلم فسكت فقد خانه، ومن منعه من الظلم فقد نصره وحفظه من عذاب الله. وهذا يبيّن أن الولاء الحقيقي ليس مع الشخص بل مع الحق',
    meaningEn:
        'Islamic brotherhood is not blind partisanship to a group or tribe; it is a commitment to truth and justice. Whoever sees his brother committing injustice and stays silent has betrayed him, and whoever stops him from injustice has truly supported him and saved him from Allah\'s punishment. This shows that true loyalty is to the truth, not merely to the person',
    meaningFr:
        'La fraternité islamique n\'est pas un partisanat aveugle envers un groupe ou une tribu ; c\'est un engagement envers la vérité et la justice. Celui qui voit son frère opprimer et se tait l\'a trahi, et celui qui l\'empêche d\'opprimer l\'a vraiment soutenu et sauvé du châtiment d\'Allah. Cela montre que la loyauté véritable est envers la vérité, non simplement envers la personne',
    sourceAr: 'صحيح البخاري (٢٤٤٣)',
    sourceEn: 'Sahih al-Bukhari (2443)',
    sourceFr: 'Sahih al-Bukhari (2443)',
    gradeAr: 'صحيح',
    gradeEn: 'Authentic (Sahih)',
    gradeFr: 'Authentique (Sahih)',
    lessonsAr: [
      'نصرة الظالم تكون بمنعه من الظلم لا بتأييده',
      'السكوت عن الظلم خيانة للأخوة الإسلامية',
      'الولاء الحقيقي للمسلم يكون مع الحق لا مع الأشخاص',
      'الأمر بالمعروف والنهي عن المنكر من أعظم صور النصرة',
      'حفظ الأخ من النار أولى من مجاملته على حساب الدين',
    ],
    lessonsEn: [
      'Supporting an oppressor means stopping him, not backing him',
      'Silence about injustice is a betrayal of Islamic brotherhood',
      'True loyalty for a Muslim is with the truth, not with individuals',
      'Enjoining good and forbidding evil is among the greatest forms of support',
      'Saving a brother from the Fire takes priority over pleasing him at the cost of religion',
    ],
    lessonsFr: [
      'Soutenir un oppresseur c\'est l\'arrêter, non l\'appuyer',
      'Le silence face à l\'injustice est une trahison de la fraternité islamique',
      'La loyauté véritable du musulman est à la vérité, non aux personnes',
      'Ordonner le bien et interdire le mal est l\'une des plus grandes formes de soutien',
      'Sauver un frère du Feu prime sur lui plaire au détriment de la religion',
    ],
  ),

  /* ─────────────────────────── 8 ─────────────────────────── */
  Hadith(
    id: 'h_parents',
    categories: ['family', 'character'],
    titleAr: 'حديث الوالدين',
    titleEn: 'Hadith of Parents',
    titleFr: 'Hadith des Parents',
    textAr:
        'الوالد أوسط أبواب الجنة، فإن شئت فأضع ذلك الباب أو احفظه',
    textEn:
        'The parent is the middle gate of Paradise. If you wish, you may lose that gate, or you may preserve it',
    textFr:
        'Le parent est la porte centrale du Paradis. Si vous voulez, vous pouvez perdre cette porte, ou vous pouvez la préserver',
    narratorAr: 'عن عبد الله بن عمر رضي الله عنهما',
    narratorEn: 'Narrated by Abdullah ibn Umar (may Allah be pleased with them)',
    narratorFr: 'Rapporté par Abdullah ibn Umar (qu\'Allah les agrée)',
    eventAr:
        'قاله النبي ﷺ لرجل جاءه يطلب الجهاد، فأمره بخدمة والديه وبرهما، وبيّن أن هذا الباب من أعظم أبواب الجنة',
    eventEn:
        'The Prophet ﷺ said this to a man who came asking to go to battle, and he ordered him to serve and honour his parents, clarifying that this is one of the greatest gates of Paradise',
    eventFr:
        'Le Prophète ﷺ le dit à un homme venu demander à partir au combat ; il lui ordonna de servir et d\'honorer ses parents, précisant que c\'est l\'une des plus grandes portes du Paradis',
    meaningAr:
        'البِرّ بالوالدين ليس مجاملة اجتماعية، بل عبادة عظيمة قرنها الله بتوحيده في القرآن. وباب الجنة هنا استعارة عن أقرب الطرق الموصلة إليها وأوسطها، أي أعدلها وأسهلها. وإضاعة هذا الباب تكون بالعقوق والجفاء والإهمال، وحفظه يكون بالطاعة والخدمة والدعاء والإنفاق',
    meaningEn:
        'Honouring parents is not a social courtesy but a great act of worship that Allah joined with His own oneness in the Qur\'an. The gate of Paradise here is a metaphor for the nearest and most balanced of paths leading to it. Losing this gate happens through disobedience, harshness and neglect; preserving it happens through obedience, service, supplication and spending',
    meaningFr:
        'Honorer ses parents n\'est pas une politesse sociale mais une grande adoration qu\'Allah a associée à Son unicité dans le Coran. La porte du Paradis est ici une métaphore du plus proche et du plus équilibré des chemins y conduisant. Perdre cette porte se fait par la désobéissance, la dureté et la négligence ; la préserver se fait par l\'obéissance, le service, l\'invocation et la dépense',
    sourceAr: 'سنن الترمذي (١٨٩٩) وسنن ابن ماجه (٢٧٨١)',
    sourceEn: 'Sunan al-Tirmidhi (1899) & Sunan Ibn Majah (2781)',
    sourceFr: 'Sunan al-Tirmidhi (1899) et Sunan Ibn Majah (2781)',
    gradeAr: 'صحيح',
    gradeEn: 'Authentic (Sahih)',
    gradeFr: 'Authentique (Sahih)',
    lessonsAr: [
      'بر الوالدين من أعظم أسباب دخول الجنة',
      'طاعة الوالدين مقدمة على نوافل الجهاد والطاعات',
      'العقوق يُغلق باباً عظيماً من أبواب الخير',
      'خدمة الوالدين عبادة تُؤجر عليها في كل لحظة',
      'الدعاء للوالدين بعد موتهما من أعظم صور البر',
    ],
    lessonsEn: [
      'Honouring parents is among the greatest means of entering Paradise',
      'Obeying parents takes precedence over voluntary acts of worship',
      'Disobedience closes a great gate of goodness',
      'Serving one\'s parents is worship rewarded in every moment',
      'Praying for one\'s parents after their death is among the greatest forms of honouring them',
    ],
    lessonsFr: [
      'Honorer ses parents est l\'un des plus grands moyens d\'entrer au Paradis',
      'Obéir aux parents prime sur les actes surérogatoires',
      'La désobéissance ferme une grande porte de bien',
      'Servir ses parents est une adoration récompensée à chaque instant',
      'Invoquer Allah pour ses parents après leur mort est une grande forme de piété filiale',
    ],
  ),

  /* ─────────────────────────── 9 ─────────────────────────── */
  Hadith(
    id: 'h_anger',
    categories: ['character', 'patience'],
    titleAr: 'حديث كظم الغيظ',
    titleEn: 'Hadith of Controlling Anger',
    titleFr: 'Hadith de la Maîtrise de la Colère',
    textAr:
        'من كظم غيظاً وهو قادر على أن ينفذه، دعاه الله عز وجل على رؤوس الخلائق يوم القيامة حتى يخيّره من الحور العين ما شاء',
    textEn:
        'Whoever suppresses his anger while being able to act upon it, Allah will call him before all creation on the Day of Resurrection and let him choose whichever of the fair maidens he wishes',
    textFr:
        'Celui qui maîtrise sa colère alors qu\'il est capable de l\'exercer, Allah l\'appellera devant toute la création au Jour de la Résurrection et lui laissera choisir parmi les houris ce qu\'il voudra',
    narratorAr: 'عن أبي هريرة رضي الله عنه',
    narratorEn: 'Narrated by Abu Hurairah (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Abu Hurairah (qu\'Allah l\'agrée)',
    eventAr:
        'تربية نبوية على ضبط النفس، حيث جعل النبي ﷺ كظم الغيظ مع القدرة على الانتقام من أعظم الأعمال التي تُرفع بها الدرجات يوم القيامة',
    eventEn:
        'Prophetic training in self-control: the Prophet ﷺ made suppressing anger while capable of revenge one of the greatest deeds by which ranks are raised on the Day of Resurrection',
    eventFr:
        'Une éducation prophétique à la maîtrise de soi : le Prophète ﷺ fit de la maîtrise de la colère, avec la capacité de se venger, l\'un des plus grands actes élevants au Jour de la Résurrection',
    meaningAr:
        'الغضب جمرة في القلب، والقوة الحقيقية ليست في الانتقام بل في ضبط النفس عند أشد لحظات الاشتعال. وكظم الغيظ لا يعني كبت الحقوق، بل يعني تأخير رد الفعل حتى يصدر عن عقل وحكمة لا عن انفعال. ولذلك جعل الله جزاءه تشريفاً علنياً أمام الخلائق كلها',
    meaningEn:
        'Anger is a burning ember in the heart, and true strength is not in revenge but in self-control at the most heated moment. Suppressing anger does not mean suppressing one\'s rights; it means delaying reaction so that it comes from reason and wisdom rather than impulse. That is why Allah made its reward a public honour before all creation',
    meaningFr:
        'La colère est une braise dans le cœur, et la vraie force n\'est pas la vengeance mais la maîtrise de soi au moment le plus brûlant. Maîtriser sa colère ne signifie pas étouffer ses droits, mais retarder la réaction pour qu\'elle procède de la raison et de la sagesse et non de l\'impulsion. C\'est pourquoi Allah en fit une récompense d\'honneur public devant toute la création',
    sourceAr: 'سنن أبي داود (٤٧٧٧) وسنن الترمذي (٢٠٢١)',
    sourceEn: 'Sunan Abu Dawud (4777) & Sunan al-Tirmidhi (2021)',
    sourceFr: 'Sunan Abu Dawud (4777) et Sunan al-Tirmidhi (2021)',
    gradeAr: 'حسن',
    gradeEn: 'Good (Hasan)',
    gradeFr: 'Bon (Hasan)',
    lessonsAr: [
      'القوة الحقيقية هي ضبط النفس عند الغضب',
      'كظم الغيظ مع القدرة على الانتقام من أعظم الأعمال',
      'الغضب يفتح أبواب الشيطان ويُفسد العلاقات',
      'التأني في رد الفعل يمنع الندم لاحقاً',
      'من ملك نفسه عند الغضب ملك عقله وقراره',
    ],
    lessonsEn: [
      'True strength is self-control when angry',
      'Suppressing anger while able to retaliate is among the greatest deeds',
      'Anger opens the doors of Satan and ruins relationships',
      'Delaying one\'s reaction prevents later regret',
      'Whoever masters himself in anger masters his mind and decisions',
    ],
    lessonsFr: [
      'La vraie force est la maîtrise de soi dans la colère',
      'Maîtriser sa colère en pouvant se venger est un des plus grands actes',
      'La colère ouvre les portes de Satan et ruine les relations',
      'Différer sa réaction évite les regrets ultérieurs',
      'Celui qui se maîtrise dans la colère maîtrise son esprit et ses décisions',
    ],
  ),

  /* ─────────────────────────── 10 ─────────────────────────── */
  Hadith(
    id: 'h_charity',
    categories: ['worship', 'business'],
    titleAr: 'حديث الصدقة',
    titleEn: 'Hadith of Charity',
    titleFr: 'Hadith de l\'Aumône',
    textAr:
        'الصدقة تطفئ غضب الرب، وتدفع ميتة السوء، وتبطل الخطيئة كما يبطل الماء النار',
    textEn:
        'Charity extinguishes the wrath of the Lord, prevents a bad death, and erases sin just as water extinguishes fire',
    textFr:
        'L\'aumône éteint la colère du Seigneur, prévient une mauvaise mort, et efface le péché comme l\'eau éteint le feu',
    narratorAr: 'عن أنس بن مالك رضي الله عنه',
    narratorEn: 'Narrated by Anas ibn Malik (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Anas ibn Malik (qu\'Allah l\'agrée)',
    eventAr:
        'حثّ النبي ﷺ أصحابه على الإنفاق في كل حال، وبيّن أن الصدقة ليست نقصاً في المال بل وقاية من غضب الله وسوء الخاتمة',
    eventEn:
        'The Prophet ﷺ urged his companions to give in every circumstance, clarifying that charity does not decrease wealth but rather protects from Allah\'s wrath and a bad end',
    eventFr:
        'Le Prophète ﷺ encouragea ses compagnons à donner en toute circonstance, précisant que l\'aumône ne diminue pas la richesse mais protège de la colère d\'Allah et d\'une mauvaise fin',
    meaningAr:
        'الصدقة في الإسلام ليست تبرعاً موسمياً، بل نظام حياة يعيد توزيع الخير ويربط الغني بالفقير. وهي تطفئ غضب الله لأنها دليل على رحمة القلب وطهارة النفس من الشح، وتدفع ميتة السوء لأن صاحبها يُحسن فيُحسن الله إليه في خاتمته',
    meaningEn:
        'In Islam, charity is not a seasonal donation but a way of life that redistributes goodness and binds the rich to the poor. It extinguishes Allah\'s wrath because it proves the mercy of the heart and purifies the soul from greed, and it prevents a bad death because whoever does good is treated with good in his final moments',
    meaningFr:
        'En Islam, l\'aumône n\'est pas un don saisonnier mais un mode de vie qui redistribue le bien et lie le riche au pauvre. Elle éteint la colère d\'Allah car elle prouve la miséricorde du cœur et purifie l\'âme de l\'avarice, et elle prévient une mauvaise mort car celui qui fait le bien est traité avec bonté à ses derniers instants',
    sourceAr: 'سنن الترمذي (٦٦٤) وسنن ابن ماجه (٢٤٤٤)',
    sourceEn: 'Sunan al-Tirmidhi (664) & Sunan Ibn Majah (2444)',
    sourceFr: 'Sunan al-Tirmidhi (664) et Sunan Ibn Majah (2444)',
    gradeAr: 'حسن',
    gradeEn: 'Good (Hasan)',
    gradeFr: 'Bon (Hasan)',
    lessonsAr: [
      'الصدقة وقاية من غضب الله ومن سوء الخاتمة',
      'الصدقة لا تنقص المال بل تبارك فيه',
      'أفضل الصدقة ما كانت عن ظهر غنى وبإخلاص',
      'الصدقة تكفّر الخطايا كما يطفئ الماء النار',
      'صدقة السر أرفع درجة عند الله وأبعد عن الرياء',
    ],
    lessonsEn: [
      'Charity protects from Allah\'s wrath and from a bad end',
      'Charity does not decrease wealth — it blesses it',
      'The best charity is given out of sufficiency and with sincerity',
      'Charity expiates sins just as water extinguishes fire',
      'Secret charity is higher with Allah and further from showing off',
    ],
    lessonsFr: [
      'L\'aumône protège de la colère d\'Allah et d\'une mauvaise fin',
      'L\'aumône ne diminue pas la richesse — elle la bénit',
      'La meilleure aumône est donnée dans l\'aisance et avec sincérité',
      'L\'aumône expie les péchés comme l\'eau éteint le feu',
      'L\'aumône secrète est plus élevée auprès d\'Allah et loin de l\'ostentation',
    ],
  ),

  /* ─────────────────────────── 11 ─────────────────────────── */
  Hadith(
    id: 'h_sick',
    categories: ['community', 'character'],
    titleAr: 'حديث عيادة المريض',
    titleEn: 'Hadith of Visiting the Sick',
    titleFr: 'Hadith de la Visite aux Malades',
    textAr:
        'من عاد مريضاً لم يزل يخوض في الرحمة حتى يجلس، فإذا جلس فقد دخل فيها',
    textEn:
        'Whoever visits a sick person remains wading through mercy until he sits, and when he sits he has entered fully into it',
    textFr:
        'Celui qui visite un malade reste immergé dans la miséricorde jusqu\'à ce qu\'il s\'asseye, et lorsqu\'il s\'assoit il y est entré complètement',
    narratorAr: 'عن علي بن أبي طالب رضي الله عنه',
    narratorEn: 'Narrated by Ali ibn Abi Talib (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Ali ibn Abi Talib (qu\'Allah l\'agrée)',
    eventAr:
        'بيّن النبي ﷺ الأجر العظيم لعيادة المريض، فجعل الطريق إلى المريض طريقاً في الرحمة، والجلوس عنده دخولاً كاملاً فيها',
    eventEn:
        'The Prophet ﷺ explained the great reward of visiting the sick, making the road to the patient a road through mercy, and sitting with him a full entry into it',
    eventFr:
        'Le Prophète ﷺ expliqua l\'immense récompense de la visite au malade : le chemin vers le patient est un chemin dans la miséricorde, et s\'asseoir auprès de lui y entrer pleinement',
    meaningAr:
        'عيادة المريض عبادة اجتماعية عظيمة تجمع بين رحمة القلب، وصلة الرحم، ورفع المعنويات. وهي تذكير للإنسان بضعفه وافتقاره إلى الله، وتذكير له بنعمة الصحة التي يغفل عنها. وأعظم ما يقدّمه العائد للمريض بعد الدعاء هو حضوره الإنساني الذي يخفف الوحدة والألم',
    meaningEn:
        'Visiting the sick is a great social act of worship that combines the mercy of the heart, maintaining ties, and lifting morale. It reminds a person of his weakness and need of Allah, and of the blessing of health he so often overlooks. The greatest thing a visitor offers after supplication is his human presence, which lightens loneliness and pain',
    meaningFr:
        'La visite au malade est une grande adoration sociale qui allie miséricorde du cœur, maintien des liens et soutien moral. Elle rappelle à l\'homme sa faiblesse et son besoin d\'Allah, ainsi que le bienfait de la santé qu\'il oublie souvent. Le plus grand don du visiteur, après l\'invocation, est sa présence humaine qui allège la solitude et la douleur',
    sourceAr: 'مسند أحمد (٨٣٤) وسنن ابن ماجه (١٤٤٢)',
    sourceEn: 'Musnad Ahmad (834) & Sunan Ibn Majah (1442)',
    sourceFr: 'Musnad Ahmad (834) et Sunan Ibn Majah (1442)',
    gradeAr: 'صحيح',
    gradeEn: 'Authentic (Sahih)',
    gradeFr: 'Authentique (Sahih)',
    lessonsAr: [
      'عيادة المريض عمل من أعظم أعمال الرحمة والبر',
      'الدعاء للمريض من أعظم ما يُهدى إليه',
      'زيارة المريض تذكّر الإنسان بنعمة الصحة',
      'الجلوس عند المريض وطول المكث عنده زيادة في الأجر',
      'من حق المسلم على أخيه زيارته في مرضه',
    ],
    lessonsEn: [
      'Visiting the sick is among the greatest acts of mercy and kindness',
      'Supplicating for the sick is among the greatest gifts you can offer',
      'Visiting the sick reminds a person of the blessing of health',
      'Sitting longer with the patient increases the reward',
      'It is a Muslim\'s right upon his brother to be visited in illness',
    ],
    lessonsFr: [
      'Visiter le malade est l\'un des plus grands actes de miséricorde',
      'Invoquer Allah pour le malade est l\'un des plus grands dons',
      'Visiter le malade rappelle le bienfait de la santé',
      'Rester plus longtemps auprès du malade augmente la récompense',
      'C\'est un droit du musulman sur son frère d\'être visité en maladie',
    ],
  ),

  /* ─────────────────────────── 12 ─────────────────────────── */
  Hadith(
    id: 'h_smile',
    categories: ['character', 'community'],
    titleAr: 'حديث البسمة',
    titleEn: 'Hadith of Smiling',
    titleFr: 'Hadith du Sourire',
    textAr:
        'تبسّمك في وجه أخيك لك صدقة، وأمرك بالمعروف ونهيك عن المنكر صدقة',
    textEn:
        'Your smile to your brother is an act of charity, and your enjoining good and forbidding evil is an act of charity',
    textFr:
        'Votre sourire à votre frère est une aumône, et votre ordre du bien et votre interdiction du mal sont une aumône',
    narratorAr: 'عن أبي ذر الغفاري رضي الله عنه',
    narratorEn: 'Narrated by Abu Dharr al-Ghifari (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Abu Dharr al-Ghifari (qu\'Allah l\'agrée)',
    eventAr:
        'علّم النبي ﷺ أصحابه أن أبواب الخير كثيرة وأنها لا تقتصر على المال، فحتى البسمة تدخل في باب الصدقة وتُثقل الميزان',
    eventEn:
        'The Prophet ﷺ taught his companions that the doors of good are many and not limited to money — even a smile enters the category of charity and weighs heavy on the scales',
    eventFr:
        'Le Prophète ﷺ enseigna à ses compagnons que les portes du bien sont nombreuses et ne se limitent pas à l\'argent — même un sourire entre dans la catégorie de l\'aumône et pèse lourd dans la balance',
    meaningAr:
        'توسيع مفهوم الصدقة ليشمل كل عمل نافع هو من تيسير الإسلام على الناس، حتى لا يظن الفقير أنه محروم من الأجر لأنه لا يملك مالاً. والبسمة صدقة لأنها تُدخل السرور على القلب وتفتح باب التواصل والمحبة بين الناس بلا تكلفة ولا منّة',
    meaningEn:
        'Broadening the concept of charity to include every beneficial act is part of Islam\'s ease upon people, so that the poor do not think themselves deprived of reward for lacking money. A smile is charity because it brings joy to the heart and opens the door of connection and love among people at no cost and with no favour to boast of',
    meaningFr:
        'Élargir le concept d\'aumône à tout acte utile fait partie de la facilité de l\'Islam, afin que le pauvre ne se croie pas privé de récompense faute d\'argent. Le sourire est une aumône car il apporte la joie au cœur et ouvre la porte du lien et de l\'amour entre les gens, sans coût ni faveur à se vanter',
    sourceAr: 'سنن الترمذي (١٩٥٦)',
    sourceEn: 'Sunan al-Tirmidhi (1956)',
    sourceFr: 'Sunan al-Tirmidhi (1956)',
    gradeAr: 'حسن',
    gradeEn: 'Good (Hasan)',
    gradeFr: 'Bon (Hasan)',
    lessonsAr: [
      'أبسط أعمال الخير لها أجر عظيم عند الله',
      'الصدقة ليست مقصورة على المال بل تشمل كل نفع',
      'البسمة تُدخل السرور وتفتح قلوب الناس',
      'الفقير يستطيع أن يصدق بعمله وخلقه وكلامه',
      'الإسلام دين يسر لا يُضيّق على الناس',
    ],
    lessonsEn: [
      'Even the simplest good deeds have a great reward with Allah',
      'Charity is not limited to money but includes every benefit',
      'A smile brings joy and opens people\'s hearts',
      'A poor person can give charity through deeds, character and words',
      'Islam is a religion of ease that does not burden people',
    ],
    lessonsFr: [
      'Même les actes de bonté les plus simples ont une grande récompense',
      'L\'aumône ne se limite pas à l\'argent mais inclut tout bienfait',
      'Le sourire apporte la joie et ouvre les cœurs',
      'Le pauvre peut faire l\'aumône par ses actes, son caractère et ses paroles',
      'L\'Islam est une religion de facilité qui ne charge pas les gens',
    ],
  ),

  /* ─────────────────────────── 13 ─────────────────────────── */
  Hadith(
    id: 'h_brotherhood',
    categories: ['community'],
    titleAr: 'حديث الأخوة الإسلامية',
    titleEn: 'Hadith of Islamic Brotherhood',
    titleFr: 'Hadith de la Fraternité Islamique',
    textAr:
        'المسلم أخو المسلم، لا يظلمه ولا يخذله ولا يحقره، من كان في حاجة أخيه كان الله في حاجته، ومن فرّج عن مسلم كربة فرّج الله عنه كربة من كرب يوم القيامة',
    textEn:
        'A Muslim is the brother of a Muslim: he does not wrong him, does not abandon him, and does not despise him. Whoever fulfils the need of his brother, Allah will fulfil his need. And whoever relieves a Muslim of a hardship, Allah will relieve him of a hardship on the Day of Resurrection',
    textFr:
        'Le musulman est le frère du musulman : il ne le lèse pas, ne l\'abandonne pas et ne le méprise pas. Celui qui satisfait le besoin de son frère, Allah satisfera son besoin. Et celui qui soulage un musulman d\'une détresse, Allah le soulagera d\'une détresse au Jour de la Résurrection',
    narratorAr: 'عن أبي هريرة رضي الله عنه',
    narratorEn: 'Narrated by Abu Hurairah (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Abu Hurairah (qu\'Allah l\'agrée)',
    eventAr:
        'بيان شامل لحقوق المسلم على أخيه، وتأصيل قاعدة الجزاء من جنس العمل: من فرّج عن أخيه فرّج الله عنه، ومن ستره ستره الله',
    eventEn:
        'A comprehensive statement of a Muslim\'s rights upon his brother, and the establishment of the rule that the reward matches the deed: whoever relieves his brother, Allah relieves him; whoever conceals his brother\'s fault, Allah conceals his',
    eventFr:
        'Un exposé complet des droits du musulman sur son frère, et l\'établissement de la règle selon laquelle la récompense correspond à l\'acte : qui soulage son frère, Allah le soulage ; qui couvre sa faute, Allah le couvre',
    meaningAr:
        'الأخوة الإسلامية عقد مقدس لا يقوم على القرابة وحدها بل على الإيمان، ومن مقتضياتها: عدم الظلم، وعدم الخذلان، وعدم الاحتقار. والمعادلة الإلهية واضحة: كل ما تقدمه لأخيك يعود إليك مضاعفاً عند الله، فمن أعان مسلماً أعانه الله في الدنيا والآخرة',
    meaningEn:
        'Islamic brotherhood is a sacred covenant founded not on kinship alone but on faith. Its requirements include: not wronging, not abandoning, and not despising. The divine equation is clear: whatever you offer your brother returns to you multiplied with Allah. Whoever helps a Muslim, Allah helps him in this world and the next',
    meaningFr:
        'La fraternité islamique est une alliance sacrée fondée non seulement sur la parenté mais sur la foi. Ses exigences incluent : ne pas léser, ne pas abandonner et ne pas mépriser. L\'équation divine est claire : tout ce que vous offrez à votre frère vous revient multiplié auprès d\'Allah. Qui aide un musulman, Allah l\'aide ici-bas et dans l\'au-delà',
    sourceAr: 'صحيح البخاري (٢٤٤٢) وصحيح مسلم (٢٥٨٠)',
    sourceEn: 'Sahih al-Bukhari (2442) & Sahih Muslim (2580)',
    sourceFr: 'Sahih al-Bukhari (2442) et Sahih Muslim (2580)',
    gradeAr: 'متفق عليه',
    gradeEn: 'Authentic — unanimously agreed upon',
    gradeFr: 'Authentique — unanimement reconnu',
    lessonsAr: [
      'الأخوة الإسلامية تقتضي الوفاء والعطف والنصرة',
      'من فرّج عن أخيه كربة فرّج الله عنه كربة يوم القيامة',
      'ستر عيوب المسلم من أعظم أبواب الأجر',
      'الاحتقار والسخرية يناقضان الإيمان والأخوة',
      'قضاء حوائج الناس من أفضل القربات إلى الله',
    ],
    lessonsEn: [
      'Islamic brotherhood requires loyalty, compassion and support',
      'Whoever relieves a brother\'s hardship, Allah relieves his on the Day of Resurrection',
      'Concealing a Muslim\'s faults is among the greatest doors of reward',
      'Despising and mocking contradict faith and brotherhood',
      'Fulfilling people\'s needs is among the best ways of drawing near to Allah',
    ],
    lessonsFr: [
      'La fraternité islamique exige loyauté, compassion et soutien',
      'Qui soulage la détresse de son frère, Allah soulagera la sienne au Jour de la Résurrection',
      'Couvrir les défauts d\'un musulman est une des plus grandes portes de récompense',
      'Mépriser et se moquer contredisent la foi et la fraternité',
      'Satisfaire les besoins des gens est parmi les meilleurs rapprochements à Allah',
    ],
  ),

  /* ─────────────────────────── 14 ─────────────────────────── */
  Hadith(
    id: 'h_trade',
    categories: ['business', 'character'],
    titleAr: 'حديث الصدق في التجارة',
    titleEn: 'Hadith of Honesty in Trade',
    titleFr: 'Hadith de l\'Honnêteté dans le Commerce',
    textAr:
        'البيعان بالخيار ما لم يتفرقا، فإن صدقا وبيّنا بُورك لهما في بيعهما، وإن كتما وكذبا مُحقت بركة بيعهما',
    textEn:
        'The buyer and the seller have the option to cancel as long as they have not separated. If they are truthful and transparent, their transaction is blessed. If they conceal and lie, the blessing of their transaction is erased',
    textFr:
        'L\'acheteur et le vendeur ont la faculté d\'annuler tant qu\'ils ne se sont pas séparés. S\'ils sont honnêtes et transparents, leur transaction est bénie. S\'ils dissimulent et mentent, la bénédiction de leur transaction est effacée',
    narratorAr: 'عن عبد الله بن عمر رضي الله عنهما',
    narratorEn: 'Narrated by Abdullah ibn Umar (may Allah be pleased with them)',
    narratorFr: 'Rapporté par Abdullah ibn Umar (qu\'Allah les agrée)',
    eventAr:
        'تأصيل نبوي لأخلاقيات السوق، حيث ربط النبي ﷺ بين صدق التاجر وبيانه للعيوب وبين البركة في الرزق',
    eventEn:
        'A prophetic foundation for market ethics, where the Prophet ﷺ linked the trader\'s truthfulness and disclosure of defects with blessing in his provision',
    eventFr:
        'Un fondement prophétique de l\'éthique du marché, où le Prophète ﷺ lia la véracité du commerçant et la divulgation des défauts à la bénédiction dans sa subsistance',
    meaningAr:
        'البركة في التجارة ليست في كثرة الربح فقط، بل في حِلّه وطِيبِه ودوامه. والكتمان والكذب وإن جلبا ربحاً سريعاً فإنهما يمحقان البركة ويُذهبان بالمال والثقة معاً. والتاجر الصادق الذي يبيّن عيوب سلعته يحفظ دينه وسمعته ويكسب دعاء الناس',
    meaningEn:
        'Blessing in trade is not only in the size of profit but in its lawfulness, purity and continuity. Concealment and lying, even if they bring quick profit, erase the blessing and take away both the wealth and the trust. The honest trader who discloses the defects of his goods preserves his religion and his reputation and earns people\'s prayers',
    meaningFr:
        'La bénédiction dans le commerce ne réside pas seulement dans l\'ampleur du profit mais dans sa licéité, sa pureté et sa continuité. La dissimulation et le mensonge, même s\'ils apportent un profit rapide, effacent la bénédiction et emportent à la fois la richesse et la confiance. Le commerçant honnête qui révèle les défauts de sa marchandise préserve sa religion et sa réputation et gagne les invocations des gens',
    sourceAr: 'صحيح البخاري (٢٠٧٩) وصحيح مسلم (١٥٣٢)',
    sourceEn: 'Sahih al-Bukhari (2079) & Sahih Muslim (1532)',
    sourceFr: 'Sahih al-Bukhari (2079) et Sahih Muslim (1532)',
    gradeAr: 'متفق عليه',
    gradeEn: 'Authentic — unanimously agreed upon',
    gradeFr: 'Authentique — unanimement reconnu',
    lessonsAr: [
      'الصدق في البيع والشراء سبب لحلول البركة',
      'بيان عيوب السلعة أمانة دينية لا مجاملة تجارية',
      'الكذب والغش يمحقان البركة ويُفسدان الثقة',
      'التاجر المسلم يراعي الحلال قبل الربح',
      'السمعة الطيبة رأس مال لا يُقدّر بثمن',
    ],
    lessonsEn: [
      'Truthfulness in buying and selling is a cause of blessing',
      'Disclosing the defects of goods is a religious trust, not commercial courtesy',
      'Lying and cheating erase blessing and destroy trust',
      'A Muslim trader considers what is lawful before profit',
      'A good reputation is capital beyond price',
    ],
    lessonsFr: [
      'La véracité dans l\'achat et la vente est une cause de bénédiction',
      'Révéler les défauts d\'une marchandise est une confiance religieuse, non une politesse',
      'Le mensonge et la tromperie effacent la bénédiction et détruisent la confiance',
      'Le commerçant musulman considère le licite avant le profit',
      'Une bonne réputation est un capital inestimable',
    ],
  ),

  /* ─────────────────────────── 15 ─────────────────────────── */
  Hadith(
    id: 'h_tongue',
    categories: ['character', 'worship'],
    titleAr: 'حديث حفظ اللسان',
    titleEn: 'Hadith of Guarding the Tongue',
    titleFr: 'Hadith de la Garde de la Langue',
    textAr:
        'من يضمن لي ما بين لحييه وما بين رجليه أضمن له الجنة',
    textEn:
        'Whoever guarantees me what is between his jaws and what is between his legs, I guarantee him Paradise',
    textFr:
        'Celui qui me garantit ce qui est entre ses mâchoires et ce qui est entre ses jambes, je lui garantis le Paradis',
    narratorAr: 'عن سهل بن سعد الساعدي رضي الله عنه',
    narratorEn: 'Narrated by Sahl ibn Saad al-Saidi (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Sahl ibn Saad al-Saidi (qu\'Allah l\'agrée)',
    eventAr:
        'ضمان نبوي عظيم، حيث جعل النبي ﷺ حفظ اللسان وحفظ الفرج مفتاحاً للجنة، لأنهما أصل عامة الذنوب والفواحش',
    eventEn:
        'A great prophetic guarantee: the Prophet ﷺ made guarding the tongue and guarding chastity the key to Paradise, because they are the root of most sins and vices',
    eventFr:
        'Une grande garantie prophétique : le Prophète ﷺ fit de la garde de la langue et de la chasteté la clé du Paradis, car elles sont la racine de la plupart des péchés et des vices',
    meaningAr:
        'اللسان صغير حجمه عظيم أثره، به يدخل الإنسان الجنة أو النار. وكثير من الخصومات والفتن والقطائع أصلها كلمة قيلت في لحظة غفلة. وحفظ اللسان يعني التفكير قبل الكلام، وترك الغيبة والنميمة والكذب والسخرية، وعدم الخوض فيما لا يعني',
    meaningEn:
        'The tongue is small in size yet immense in impact — by it a person enters Paradise or the Fire. Many disputes, trials and severed ties begin with a word spoken in a moment of heedlessness. Guarding the tongue means thinking before speaking, abandoning backbiting, gossip, lying and mockery, and not engaging in what does not concern you',
    meaningFr:
        'La langue est petite par sa taille mais immense par son effet — par elle l\'homme entre au Paradis ou au Feu. Beaucoup de disputes, de troubles et de ruptures commencent par une parole prononcée dans un moment d\'inattention. Garder sa langue signifie réfléchir avant de parler, abandonner la médisance, la calomnie, le mensonge et la moquerie, et ne pas s\'occuper de ce qui ne nous concerne pas',
    sourceAr: 'صحيح البخاري (٦٤٧٤)',
    sourceEn: 'Sahih al-Bukhari (6474)',
    sourceFr: 'Sahih al-Bukhari (6474)',
    gradeAr: 'صحيح',
    gradeEn: 'Authentic (Sahih)',
    gradeFr: 'Authentique (Sahih)',
    lessonsAr: [
      'حفظ اللسان من أعظم أسباب دخول الجنة',
      'أكثر ذنوب الإنسان تأتي من كلمة لم يتفكر فيها',
      'الغيبة والنميمة تفسدان المجتمع وتقطعان الأرحام',
      'الصمت عن الكلام الذي لا نفع فيه حكمة',
      'من حفظ لسانه حفظ عرضه ودينه وعلاقاته',
    ],
    lessonsEn: [
      'Guarding the tongue is among the greatest causes of entering Paradise',
      'Most of a person\'s sins come from a word he did not think about',
      'Backbiting and gossip corrupt society and sever kinship ties',
      'Silence about speech that brings no benefit is wisdom',
      'Whoever guards his tongue protects his honour, his religion and his relationships',
    ],
    lessonsFr: [
      'Garder sa langue est l\'une des plus grandes causes d\'entrer au Paradis',
      'La plupart des péchés viennent d\'une parole non réfléchie',
      'La médisance et la calomnie corrompent la société et rompent les liens',
      'Se taire sur des paroles inutiles est une sagesse',
      'Celui qui garde sa langue protège son honneur, sa religion et ses relations',
    ],
  ),

  /* ─────────────────────────── 16 ─────────────────────────── */
  Hadith(
    id: 'h_envy',
    categories: ['character', 'community'],
    titleAr: 'حديث النهي عن الحسد',
    titleEn: 'Hadith Against Envy',
    titleFr: 'Hadith Contre l\'Envie',
    textAr:
        'لا تحاسدوا، ولا تناجشوا، ولا تباغضوا، ولا تدابروا، ولا يبع بعضكم على بيع بعض، وكونوا عباد الله إخواناً',
    textEn:
        'Do not envy one another, do not inflate prices artificially, do not hate one another, do not turn your backs on one another, do not undercut one another in trade — and be, O servants of Allah, brothers',
    textFr:
        'Ne vous enviez pas, ne pratiquez pas d\'enchères artificielles, ne vous haïssez pas, ne vous tournez pas le dos, ne vendez pas au détriment les uns des autres — et soyez, ô serviteurs d\'Allah, des frères',
    narratorAr: 'عن أبي هريرة رضي الله عنه',
    narratorEn: 'Narrated by Abu Hurairah (may Allah be pleased with him)',
    narratorFr: 'Rapporté par Abu Hurairah (qu\'Allah l\'agrée)',
    eventAr:
        'قائمة نبوية شاملة بالمحرّمات التي تُفسد العلاقات الاجتماعية والاقتصادية، ودعوة صريحة إلى الأخوة الصادقة بين المسلمين',
    eventEn:
        'A comprehensive prophetic list of prohibitions that corrupt social and economic relationships, with an explicit call to sincere brotherhood among Muslims',
    eventFr:
        'Une liste prophétique complète des interdits qui corrompent les relations sociales et économiques, avec un appel explicite à une fraternité sincère entre musulmans',
    meaningAr:
        'الحسد مرض قلبي يتمنى صاحبه زوال نعمة غيره، وهو أول ذنب عُصي الله به في السماء. والنهي عن البغضاء والتدابر والنجش يهدف إلى بناء مجتمع متعاون لا متنافس على الباطل. والجامع لكل ذلك: العبودية لله والأخوة في الدين، وهما الأساس الذي تقوم عليه العلاقات السليمة',
    meaningEn:
        'Envy is a disease of the heart in which a person wishes the removal of another\'s blessing; it was the first sin by which Allah was disobeyed in the heavens. The prohibition of hatred, turning away, and artificial bidding aims to build a cooperative society rather than one competing in falsehood. What gathers all of this is: servitude to Allah and brotherhood in religion — the foundation upon which sound relationships stand',
    meaningFr:
        'L\'envie est une maladie du cœur où l\'on souhaite la disparition du bienfait d\'autrui ; ce fut le premier péché par lequel Allah fut désobéi dans les cieux. L\'interdiction de la haine, du fait de se tourner le dos et des enchères artificielles vise à bâtir une société coopérative plutôt qu\'une société en compétition dans le faux. Ce qui rassemble tout cela : la servitude envers Allah et la fraternité en religion — le fondement des relations saines',
    sourceAr: 'صحيح مسلم (٢٥٦٤)',
    sourceEn: 'Sahih Muslim (2564)',
    sourceFr: 'Sahih Muslim (2564)',
    gradeAr: 'صحيح',
    gradeEn: 'Authentic (Sahih)',
    gradeFr: 'Authentique (Sahih)',
    lessonsAr: [
      'الحسد يفسد القلوب ويقطع أواصر الأخوة الإسلامية',
      'البغضاء والتدابر من كبائر ما يُفسد المجتمع',
      'النجش وخداع البائع للمشتري محرّم شرعاً',
      'المسلم يسعى في نفع أخيه لا في الإضرار به',
      'العبودية لله والأخوة في الدين أساس كل علاقة سليمة',
    ],
    lessonsEn: [
      'Envy corrupts hearts and severs the bonds of Islamic brotherhood',
      'Hatred and turning away from one another are major social corruptions',
      'Artificial bidding and deceiving the buyer are religiously forbidden',
      'A Muslim seeks his brother\'s benefit, not his harm',
      'Servitude to Allah and brotherhood in faith are the basis of every sound relationship',
    ],
    lessonsFr: [
      'L\'envie corrompt les cœurs et rompt les liens de la fraternité islamique',
      'La haine et le fait de se tourner le dos sont de graves corruptions sociales',
      'Les enchères artificielles et la tromperie de l\'acheteur sont interdites',
      'Le musulman cherche le bien de son frère, non son mal',
      'La servitude envers Allah et la fraternité en foi sont la base de toute relation saine',
    ],
  ),
];

/* ══════════════════════════════════════════════════════════════════════════
   HELPERS
   ══════════════════════════════════════════════════════════════════════════ */

String localized(String ar, String en, String fr, String lang) {
  switch (lang) {
    case 'ar':
      return ar;
    case 'fr':
      return fr;
    default:
      return en;
  }
}

const Color kGold = Color(0xFFD4AF37);
const Color kGoldSoft = Color(0xFFCBB28A);
const Color kGreen = Color(0xFF0B3D2E);
const Color kGreenLight = Color(0xFF1E6B52);
const Color kMint = Color(0xFF81C784);

void showCopiedSnack(BuildContext context, ThemeService ts, bool isArabic) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              isArabic ? 'تم النسخ إلى الحافظة' : 'Copied to clipboard',
              style: ts.getTextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: kGreenLight,
      ),
    );
}

/* ══════════════════════════════════════════════════════════════════════════
   MAIN SCREEN
   ══════════════════════════════════════════════════════════════════════════ */

class HadithsScreen extends StatefulWidget {
  const HadithsScreen({super.key});

  @override
  State<HadithsScreen> createState() => _HadithsScreenState();
}

class _HadithsScreenState extends State<HadithsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  bool _onlyFavorites = false;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _listController = ScrollController();

  late final AnimationController _introController;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _bodyFade;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
    ));
    _bodyFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _searchController.dispose();
    _listController.dispose();
    super.dispose();
  }

  String _getScreenTitle(String langCode) {
    switch (langCode) {
      case 'ar':
        return 'أحاديث النبي ﷺ';
      case 'fr':
        return 'Hadiths du Prophète ﷺ';
      default:
        return 'Prophet ﷺ Quotes';
    }
  }

  String _getScreenSubtitle(String langCode) {
    switch (langCode) {
      case 'ar':
        return 'موسوعة مختارة من الأحاديث النبوية الصحيحة مع الشرح والفوائد';
      case 'fr':
        return 'Une sélection de hadiths authentiques avec explications et bienfaits';
      default:
        return 'A curated collection of authentic hadiths with explanation and lessons';
    }
  }

  List<Hadith> get _filteredHadiths {
    final favs = favoriteHadiths.value;
    return allHadiths.where((hadith) {
      // Category filter
      final matchesCategory = _selectedCategoryId == 'all' ||
          hadith.categories.contains(_selectedCategoryId);
      if (!matchesCategory) return false;

      // Favourites filter
      if (_onlyFavorites && !favs.contains(hadith.id)) return false;

      // Search filter
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();

      final haystack = <String>[
        hadith.titleAr, hadith.titleEn, hadith.titleFr,
        hadith.textAr, hadith.textEn, hadith.textFr,
        hadith.narratorAr, hadith.narratorEn, hadith.narratorFr,
        hadith.eventAr, hadith.eventEn, hadith.eventFr,
        hadith.meaningAr, hadith.meaningEn, hadith.meaningFr,
        hadith.sourceAr, hadith.sourceEn, hadith.sourceFr,
        ...hadith.lessonsAr, ...hadith.lessonsEn, ...hadith.lessonsFr,
      ].join(' ').toLowerCase();

      return haystack.contains(q);
    }).toList();
  }

  void _openDetail(Hadith hadith) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 480),
        reverseTransitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, __, ___) => HadithDetailScreen(hadith: hadith),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.07),
                end: Offset.zero,
              ).animate(curved),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.97, end: 1.0).animate(curved),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final isArabic = langCode == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* ───────── Header with big emblem ───────── */
                  FadeTransition(
                    opacity: _headerFade,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: _HadithsHeader(
                        title: _getScreenTitle(langCode),
                        subtitle: _getScreenSubtitle(langCode),
                        themeService: themeService,
                        isDarkMode: isDarkMode,
                        isArabic: isArabic,
                        hadithCount: allHadiths.length,
                        categoryCount: hadithCategories.length - 1,
                        onBack: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  /* ───────── Search + favourites toggle ───────── */
                  FadeTransition(
                    opacity: _bodyFade,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 10),
                      child: _SearchField(
                        controller: _searchController,
                        isArabic: isArabic,
                        langCode: langCode,
                        isDarkMode: isDarkMode,
                        themeService: themeService,
                        query: _searchQuery,
                        onlyFavorites: _onlyFavorites,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        onClear: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        onToggleFavorites: () =>
                            setState(() => _onlyFavorites = !_onlyFavorites),
                      ),
                    ),
                  ),

                  /* ───────── Category chips ───────── */
                  FadeTransition(
                    opacity: _bodyFade,
                    child: _CategoryBar(
                      isArabic: isArabic,
                      langCode: langCode,
                      isDarkMode: isDarkMode,
                      themeService: themeService,
                      selectedId: _selectedCategoryId,
                      onSelected: (id) =>
                          setState(() => _selectedCategoryId = id),
                    ),
                  ),

                  /* ───────── Result counter ───────── */
                  FadeTransition(
                    opacity: _bodyFade,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 4, 28, 6),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          key: ValueKey(
                              '${_filteredHadiths.length}-$_selectedCategoryId-$_onlyFavorites'),
                          isArabic
                              ? '${_filteredHadiths.length} حديث'
                              : (langCode == 'fr'
                                  ? '${_filteredHadiths.length} hadith(s)'
                                  : '${_filteredHadiths.length} hadith(s)'),
                          style: themeService.getTextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.55)
                                : Colors.black.withValues(alpha: 0.5),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /* ───────── List ───────── */
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: _filteredHadiths.isEmpty
                          ? _EmptyState(
                              key: const ValueKey('empty'),
                              isArabic: isArabic,
                              langCode: langCode,
                              themeService: themeService,
                              isDarkMode: isDarkMode,
                            )
                          : ListView.builder(
                              key: ValueKey(
                                  'list-$_selectedCategoryId-$_onlyFavorites'),
                              controller: _listController,
                              padding:
                                  const EdgeInsets.fromLTRB(24, 4, 24, 32),
                              physics: const BouncingScrollPhysics(),
                              itemCount: _filteredHadiths.length,
                              itemBuilder: (context, index) {
                                final hadith = _filteredHadiths[index];
                                return _StaggeredEntrance(
                                  index: index,
                                  child: HadithCard(
                                    hadith: hadith,
                                    isArabic: isArabic,
                                    themeService: themeService,
                                    onTap: () => _openDetail(hadith),
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
      },
    );
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   HEADER
   ══════════════════════════════════════════════════════════════════════════ */

class _HadithsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final ThemeService themeService;
  final bool isDarkMode;
  final bool isArabic;
  final int hadithCount;
  final int categoryCount;
  final VoidCallback onBack;

  const _HadithsHeader({
    required this.title,
    required this.subtitle,
    required this.themeService,
    required this.isDarkMode,
    required this.isArabic,
    required this.hadithCount,
    required this.categoryCount,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.fromLTRB(14, 16, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  kGreen.withValues(alpha: 0.85),
                  kGreenLight.withValues(alpha: 0.55),
                ]
              : [
                  Colors.white.withValues(alpha: 0.85),
                  kGold.withValues(alpha: 0.12),
                ],
        ),
        border: Border.all(color: kGold.withValues(alpha: 0.45), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: kGold.withValues(alpha: isDarkMode ? 0.10 : 0.18),
            blurRadius: 26,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: kGold,
                iconSize: 26,
                tooltip: isArabic ? 'رجوع' : 'Back',
              ),
              const SizedBox(width: 4),

              /// BIG EMBLEM
              const _IslamicEmblem(size: 92),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      style: themeService.getTextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : kGreen,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      style: themeService.getTextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.65)
                            : Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  icon: Icons.auto_stories_rounded,
                  value: '$hadithCount',
                  label: isArabic
                      ? 'حديث'
                      : (Localizations.localeOf(context).languageCode == 'fr'
                          ? 'Hadiths'
                          : 'Hadiths'),
                  themeService: themeService,
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatPill(
                  icon: Icons.category_rounded,
                  value: '$categoryCount',
                  label: isArabic
                      ? 'تصنيف'
                      : (Localizations.localeOf(context).languageCode == 'fr'
                          ? 'Catégories'
                          : 'Categories'),
                  themeService: themeService,
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ValueListenableBuilder<Set<String>>(
                  valueListenable: favoriteHadiths,
                  builder: (context, favs, _) {
                    return _StatPill(
                      icon: Icons.bookmark_rounded,
                      value: '${favs.length}',
                      label: isArabic
                          ? 'مفضلة'
                          : (Localizations.localeOf(context).languageCode ==
                                  'fr'
                              ? 'Favoris'
                              : 'Saved'),
                      themeService: themeService,
                      isDarkMode: isDarkMode,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final ThemeService themeService;
  final bool isDarkMode;

  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.themeService,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withValues(alpha: 0.22)
            : Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGold.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: kGold),
          const SizedBox(height: 5),
          Text(
            value,
            style: themeService.getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : kGreen,
            ),
          ),
          Text(
            label,
            style: themeService.getTextStyle(
              fontSize: 10.5,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.55)
                  : Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   ISLAMIC EMBLEM (large animated logo)
   ══════════════════════════════════════════════════════════════════════════ */

class _IslamicEmblem extends StatefulWidget {
  final double size;
  const _IslamicEmblem({this.size = 96});

  @override
  State<_IslamicEmblem> createState() => _IslamicEmblemState();
}

class _IslamicEmblemState extends State<_IslamicEmblem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _controller,
            child: CustomPaint(
              size: Size.square(widget.size),
              painter: _EmblemRingPainter(),
            ),
          ),
          Container(
            width: widget.size * 0.74,
            height: widget.size * 0.74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kGreenLight, kGreen],
              ),
              border: Border.all(color: kGold, width: 2),
              boxShadow: [
                BoxShadow(
                  color: kGold.withValues(alpha: 0.4),
                  blurRadius: 22,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.mosque_rounded,
                size: widget.size * 0.34,
                color: kGold,
              ),
            ),
          ),
          Positioned(
            bottom: widget.size * 0.06,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: kGold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'ﷺ',
                style: TextStyle(
                  fontSize: 12,
                  color: kGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmblemRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    const count = 28;

    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final isMajor = i % 4 == 0;
      final paint = Paint()
        ..color = kGold.withValues(alpha: isMajor ? 0.75 : 0.35);

      final r = isMajor ? 2.3 : 1.2;
      final dist = radius * (isMajor ? 0.94 : 0.86);

      canvas.drawCircle(
        Offset(
          center.dx + dist * math.cos(angle),
          center.dy + dist * math.sin(angle),
        ),
        r,
        paint,
      );
    }

    // outer thin arc
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = kGold.withValues(alpha: 0.35);
    canvas.drawCircle(center, radius * 0.99, arcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* ══════════════════════════════════════════════════════════════════════════
   SEARCH FIELD
   ══════════════════════════════════════════════════════════════════════════ */

class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final bool isArabic;
  final String langCode;
  final bool isDarkMode;
  final ThemeService themeService;
  final String query;
  final bool onlyFavorites;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onToggleFavorites;

  const _SearchField({
    required this.controller,
    required this.isArabic,
    required this.langCode,
    required this.isDarkMode,
    required this.themeService,
    required this.query,
    required this.onlyFavorites,
    required this.onChanged,
    required this.onClear,
    required this.onToggleFavorites,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String get _hint {
    if (widget.isArabic) return 'ابحث في النصوص والرواة والفوائد...';
    if (widget.langCode == 'fr') {
      return 'Rechercher textes, narrateurs, bienfaits...';
    }
    return 'Search texts, narrators, lessons...';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? Colors.black.withValues(alpha: 0.24)
                  : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _focused
                    ? kGold
                    : kGold.withValues(alpha: 0.28),
                width: _focused ? 1.6 : 1,
              ),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: kGold.withValues(alpha: 0.22),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              style: widget.themeService.getTextStyle(
                fontSize: 15,
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
              textDirection:
                  widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
              decoration: InputDecoration(
                hintText: _hint,
                hintStyle: TextStyle(
                  color: widget.isDarkMode
                      ? Colors.grey[600]
                      : Colors.black.withValues(alpha: 0.42),
                  fontSize: 13.5,
                ),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: kGold, size: 22),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                suffixIcon: widget.query.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          size: 20,
                          color: widget.isDarkMode
                              ? Colors.white54
                              : Colors.black54,
                        ),
                        onPressed: widget.onClear,
                      )
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: widget.onlyFavorites
                ? kGold
                : (widget.isDarkMode
                    ? Colors.black.withValues(alpha: 0.24)
                    : Colors.white.withValues(alpha: 0.7)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.onlyFavorites
                  ? kGold
                  : kGold.withValues(alpha: 0.28),
            ),
          ),
          child: IconButton(
            onPressed: widget.onToggleFavorites,
            tooltip: widget.isArabic ? 'المفضلة فقط' : 'Favourites only',
            icon: Icon(
              widget.onlyFavorites
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: widget.onlyFavorites
                  ? kGreen
                  : (widget.isDarkMode ? Colors.white70 : kGold),
            ),
          ),
        ),
      ],
    );
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   CATEGORY BAR
   ══════════════════════════════════════════════════════════════════════════ */

class _CategoryBar extends StatelessWidget {
  final bool isArabic;
  final String langCode;
  final bool isDarkMode;
  final ThemeService themeService;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const _CategoryBar({
    required this.isArabic,
    required this.langCode,
    required this.isDarkMode,
    required this.themeService,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: hadithCategories.length,
        itemBuilder: (context, index) {
          final category = hadithCategories[index];
          final isSelected = category.id == selectedId;

          final name = isArabic
              ? category.nameAr
              : (langCode == 'fr' ? category.nameFr : category.nameEn);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: GestureDetector(
              onTap: () => onSelected(category.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? kGold
                      : (isDarkMode
                          ? Colors.black.withValues(alpha: 0.28)
                          : Colors.white.withValues(alpha: 0.6)),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? kGold
                        : kGold.withValues(alpha: 0.28),
                    width: isSelected ? 1.6 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: kGold.withValues(alpha: 0.35),
                            blurRadius: 14,
                            spreadRadius: 0.5,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (category.id != 'all') ...[
                      Icon(
                        category.icon,
                        size: 16,
                        color: isSelected
                            ? kGreen
                            : (isDarkMode ? Colors.white70 : kGold),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      name,
                      style: themeService.getTextStyle(
                        fontSize: 13.5,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? kGreen
                            : (isDarkMode ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   EMPTY STATE
   ══════════════════════════════════════════════════════════════════════════ */

class _EmptyState extends StatelessWidget {
  final bool isArabic;
  final String langCode;
  final ThemeService themeService;
  final bool isDarkMode;

  const _EmptyState({
    super.key,
    required this.isArabic,
    required this.langCode,
    required this.themeService,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final msg = isArabic
        ? 'لم يتم العثور على أحاديث مطابقة'
        : (langCode == 'fr'
            ? 'Aucun hadith correspondant trouvé'
            : 'No matching hadiths found');

    final hint = isArabic
        ? 'جرّب تغيير التصنيف أو كلمة البحث'
        : (langCode == 'fr'
            ? 'Essayez de changer la catégorie ou le mot-clé'
            : 'Try changing the category or keyword');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGold.withValues(alpha: 0.1),
                border: Border.all(color: kGold.withValues(alpha: 0.35)),
              ),
              child: const Icon(Icons.search_off_rounded,
                  size: 44, color: kGold),
            ),
            const SizedBox(height: 18),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: themeService.getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey[300] : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: themeService.getTextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.grey[500] : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   STAGGERED ENTRANCE
   ══════════════════════════════════════════════════════════════════════════ */

class _StaggeredEntrance extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredEntrance({required this.index, required this.child});

  @override
  State<_StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<_StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    final delayMs = (widget.index.clamp(0, 10)) * 55;
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   HADITH CARD (list item)
   ══════════════════════════════════════════════════════════════════════════ */

class HadithCard extends StatefulWidget {
  final Hadith hadith;
  final bool isArabic;
  final ThemeService themeService;
  final VoidCallback onTap;

  const HadithCard({
    super.key,
    required this.hadith,
    required this.isArabic,
    required this.themeService,
    required this.onTap,
  });

  @override
  State<HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends State<HadithCard> {
  bool _pressed = false;

  String _catLabel(String id, String lang) {
    final cat = hadithCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => hadithCategories.first,
    );
    if (lang == 'ar') return cat.nameAr;
    if (lang == 'fr') return cat.nameFr;
    return cat.nameEn;
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final isAr = lang == 'ar';
    final isFr = lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final hadith = widget.hadith;
    final titleText =
        localized(hadith.titleAr, hadith.titleEn, hadith.titleFr, lang);
    final hadithText =
        localized(hadith.textAr, hadith.textEn, hadith.textFr, lang);
    final narratorText = localized(
        hadith.narratorAr, hadith.narratorEn, hadith.narratorFr, lang);
    final gradeText =
        localized(hadith.gradeAr, hadith.gradeEn, hadith.gradeFr, lang);

    final bodyTextColor = isDarkMode ? Colors.white : Colors.black87;

    return ValueListenableBuilder<Set<String>>(
      valueListenable: favoriteHadiths,
      builder: (context, favs, _) {
        final isFav = favs.contains(hadith.id);

        return GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.977 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.black.withValues(alpha: 0.28)
                    : Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isFav
                      ? kGold.withValues(alpha: 0.75)
                      : kGold.withValues(alpha: 0.26),
                  width: isFav ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kGold.withValues(alpha: isDarkMode ? 0.06 : 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /* Title row + favourite */
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: kGold.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: kGold.withValues(alpha: 0.3)),
                        ),
                        child: const Icon(Icons.menu_book_rounded,
                            size: 15, color: kGold),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          titleText,
                          textDirection:
                              isAr ? TextDirection.rtl : TextDirection.ltr,
                          style: widget.themeService.getTextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? kGold : kGreen,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final set = Set<String>.from(favoriteHadiths.value);
                          if (set.contains(hadith.id)) {
                            set.remove(hadith.id);
                          } else {
                            set.add(hadith.id);
                          }
                          favoriteHadiths.value = set;
                          HapticFeedback.selectionClick();
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            isFav
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            key: ValueKey(isFav),
                            size: 21,
                            color: isFav
                                ? kGold
                                : (isDarkMode
                                    ? Colors.white38
                                    : Colors.black38),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /* Hadith text */
                  Text(
                    hadithText,
                    textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: widget.themeService.getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: bodyTextColor,
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /* Category chips */
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    textDirection:
                        isAr ? TextDirection.rtl : TextDirection.ltr,
                    children: hadith.categories
                        .map(
                          (c) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: kMint.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: kMint.withValues(alpha: 0.35)),
                            ),
                            child: Text(
                              _catLabel(c, lang),
                              style: widget.themeService.getTextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? kMint : kGreenLight,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),

                  /* Narrator + grade */
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                    decoration: BoxDecoration(
                      color: kGold.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(11),
                      border:
                          Border.all(color: kGold.withValues(alpha: 0.22)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.record_voice_over_rounded,
                            size: 14, color: kGold),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            narratorText,
                            textDirection: isAr
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.themeService.getTextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: bodyTextColor.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: kMint.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            gradeText,
                            style: widget.themeService.getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? kMint : kGreenLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  /* Read more */
                  Row(
                    mainAxisAlignment: isAr
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      Text(
                        isAr
                            ? 'اقرأ الشرح والفوائد'
                            : (isFr
                                ? 'Lire l\'explication et les bienfaits'
                                : 'Read explanation & lessons'),
                        style: widget.themeService.getTextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: kGold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isAr
                            ? Icons.arrow_back_rounded
                            : Icons.arrow_forward_rounded,
                        size: 16,
                        color: kGold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   DETAIL SCREEN
   ══════════════════════════════════════════════════════════════════════════ */

class HadithDetailScreen extends StatefulWidget {
  final Hadith hadith;
  const HadithDetailScreen({super.key, required this.hadith});

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _copyText(BuildContext context, ThemeService ts, bool isAr, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      if (!context.mounted) return;
      showCopiedSnack(context, ts, isAr);
    });
  }

  void _shareHadith(
    BuildContext context,
    String title,
    String text,
    String narrator,
    String source,
    String grade,
  ) {
    final shareText = '$title\n\n$text\n\n$narrator\n$source\n$grade';
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      shareText,
      subject: title,
      sharePositionOrigin:
          box != null ? box.localToGlobal(Offset.zero) & box.size : null,
    );
  }

  void _openFontSizeSheet(BuildContext context, ThemeService ts, bool isAr) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
          decoration: BoxDecoration(
            color: isDarkMode ? kGreen : Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(26)),
            border: Border.all(color: kGold.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: kGold.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.format_size_rounded, color: kGold),
                  const SizedBox(width: 10),
                  Text(
                    isAr ? 'حجم الخط' : 'Font size',
                    style: ts.getTextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : kGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<double>(
                valueListenable: hadithFontScale,
                builder: (context, scale, _) {
                  return Row(
                    children: [
                      const Text('A',
                          style: TextStyle(fontSize: 13, color: kGold)),
                      Expanded(
                        child: Slider(
                          value: scale,
                          min: 0.85,
                          max: 1.6,
                          divisions: 15,
                          activeColor: kGold,
                          inactiveColor: kGold.withValues(alpha: 0.25),
                          onChanged: (v) => hadithFontScale.value = v,
                        ),
                      ),
                      const Text('A',
                          style: TextStyle(fontSize: 22, color: kGold)),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final lang = Localizations.localeOf(context).languageCode;
        final isAr = lang == 'ar';
        final isFr = lang == 'fr';
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        final h = widget.hadith;

        final titleText = localized(h.titleAr, h.titleEn, h.titleFr, lang);
        final hadithText = localized(h.textAr, h.textEn, h.textFr, lang);
        final narratorText =
            localized(h.narratorAr, h.narratorEn, h.narratorFr, lang);
        final eventText = localized(h.eventAr, h.eventEn, h.eventFr, lang);
        final meaningText =
            localized(h.meaningAr, h.meaningEn, h.meaningFr, lang);
        final sourceText = localized(h.sourceAr, h.sourceEn, h.sourceFr, lang);
        final gradeText = localized(h.gradeAr, h.gradeEn, h.gradeFr, lang);
        final lessons = isAr
            ? h.lessonsAr
            : (isFr ? h.lessonsFr : h.lessonsEn);

        final bodyTextColor = isDarkMode ? Colors.white : Colors.black87;

        final shareText =
            '$titleText\n\n$hadithText\n\n$narratorText\n$sourceText ($gradeText)';

        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  /* ───────── Top bar ───────── */
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 16, 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: kGold, size: 26),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            isAr ? 'تفاصيل الحديث' : 'Hadith details',
                            textAlign:
                                isAr ? TextAlign.right : TextAlign.left,
                            style: themeService.getTextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),
                        ),
                        ValueListenableBuilder<Set<String>>(
                          valueListenable: favoriteHadiths,
                          builder: (context, favs, _) {
                            final isFav = favs.contains(h.id);
                            return IconButton(
                              tooltip:
                                  isAr ? 'إضافة للمفضلة' : 'Add to favourites',
                              onPressed: () {
                                final set =
                                    Set<String>.from(favoriteHadiths.value);
                                if (set.contains(h.id)) {
                                  set.remove(h.id);
                                } else {
                                  set.add(h.id);
                                }
                                favoriteHadiths.value = set;
                                HapticFeedback.selectionClick();
                              },
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 240),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(scale: anim, child: child),
                                child: Icon(
                                  isFav
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  key: ValueKey(isFav),
                                  color: isFav ? kGold : Colors.grey,
                                  size: 24,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          tooltip: isAr ? 'حجم الخط' : 'Font size',
                          onPressed: () =>
                              _openFontSizeSheet(context, themeService, isAr),
                          icon: const Icon(Icons.format_size_rounded,
                              color: kGold, size: 24),
                        ),
                      ],
                    ),
                  ),

                  /* ───────── Content ───────── */
                  Expanded(
                    child: FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 6, 20, 110),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            /* Hero header card */
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDarkMode
                                      ? [
                                          kGreen.withValues(alpha: 0.9),
                                          kGreenLight.withValues(alpha: 0.6),
                                        ]
                                      : [
                                          Colors.white.withValues(alpha: 0.9),
                                          kGold.withValues(alpha: 0.14),
                                        ],
                                ),
                                border: Border.all(
                                    color: kGold.withValues(alpha: 0.45),
                                    width: 1.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: kGold
                                        .withValues(alpha: isDarkMode ? 0.1 : 0.18),
                                    blurRadius: 24,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const _IslamicEmblem(size: 84),
                                  const SizedBox(height: 14),
                                  Text(
                                    titleText,
                                    textAlign: TextAlign.center,
                                    style: themeService.getTextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? kGold : kGreen,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    runSpacing: 6,
                                    children: [
                                      _Pill(
                                        icon: Icons.verified_rounded,
                                        text: gradeText,
                                        color: kMint,
                                        themeService: themeService,
                                        isDarkMode: isDarkMode,
                                      ),
                                      ...h.categories.map(
                                        (c) => _Pill(
                                          icon: Icons.label_rounded,
                                          text: hadithCategories
                                              .firstWhere(
                                                (cat) => cat.id == c,
                                                orElse: () =>
                                                    hadithCategories.first,
                                              )
                                              .nameAr,
                                          color: kGold,
                                          themeService: themeService,
                                          isDarkMode: isDarkMode,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            /* Hadith text */
                            _DetailSection(
                              icon: Icons.format_quote_rounded,
                              title: isAr
                                  ? 'نص الحديث'
                                  : (isFr ? 'Texte du hadith' : 'Hadith text'),
                              accent: kGold,
                              themeService: themeService,
                              isDarkMode: isDarkMode,
                              child: ValueListenableBuilder<double>(
                                valueListenable: hadithFontScale,
                                builder: (context, scale, _) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: kGold.withValues(alpha: 0.07),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: kGold.withValues(alpha: 0.35),
                                      ),
                                    ),
                                    child: Text(
                                      '« $hadithText »',
                                      textDirection: isAr
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      style: themeService.getTextStyle(
                                        fontSize: 17 * scale,
                                        fontWeight: FontWeight.w600,
                                        color: bodyTextColor,
                                        height: 1.85,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            /* Narrator */
                            _DetailSection(
                              icon: Icons.record_voice_over_rounded,
                              title: isAr
                                  ? 'الراوي'
                                  : (isFr ? 'Narrateur' : 'Narrator'),
                              accent: kGoldSoft,
                              themeService: themeService,
                              isDarkMode: isDarkMode,
                              child: Text(
                                narratorText,
                                textDirection: isAr
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                style: themeService.getTextStyle(
                                  fontSize: 14.5,
                                  fontStyle: FontStyle.italic,
                                  color: bodyTextColor,
                                  height: 1.6,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            /* Event */
                            _DetailSection(
                              icon: Icons.history_edu_rounded,
                              title: isAr
                                  ? 'المناسبة والسياق'
                                  : (isFr
                                      ? 'Contexte et occasion'
                                      : 'Context & occasion'),
                              accent: kGoldSoft,
                              themeService: themeService,
                              isDarkMode: isDarkMode,
                              child: Text(
                                eventText,
                                textDirection: isAr
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                style: themeService.getTextStyle(
                                  fontSize: 14,
                                  color: bodyTextColor,
                                  height: 1.7,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            /* Meaning */
                            _DetailSection(
                              icon: Icons.lightbulb_rounded,
                              title: isAr
                                  ? 'المعنى والفائدة'
                                  : (isFr
                                      ? 'Sens et bienfait'
                                      : 'Meaning & benefit'),
                              accent: kMint,
                              themeService: themeService,
                              isDarkMode: isDarkMode,
                              child: ValueListenableBuilder<double>(
                                valueListenable: hadithFontScale,
                                builder: (context, scale, _) {
                                  return Text(
                                    meaningText,
                                    textDirection: isAr
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    style: themeService.getTextStyle(
                                      fontSize: 14.5 * scale,
                                      color: bodyTextColor,
                                      height: 1.8,
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            /* Lessons */
                            _DetailSection(
                              icon: Icons.checklist_rounded,
                              title: isAr
                                  ? 'الدروس المستفادة'
                                  : (isFr
                                      ? 'Leçons à retenir'
                                      : 'Lessons to learn'),
                              accent: kMint,
                              themeService: themeService,
                              isDarkMode: isDarkMode,
                              child: Column(
                                crossAxisAlignment: isAr
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: List.generate(lessons.length, (i) {
                                  return TweenAnimationBuilder<double>(
                                    key: ValueKey('$i-${lessons.length}'),
                                    tween: Tween(begin: 0, end: 1),
                                    duration: Duration(
                                        milliseconds: 300 + (i * 90)),
                                    curve: Curves.easeOut,
                                    builder: (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Transform.translate(
                                          offset: Offset(
                                              isAr ? 18 * (1 - value) : -18 * (1 - value),
                                              0),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        textDirection: isAr
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 5, left: 2, right: 2),
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: kMint,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kMint.withValues(
                                                      alpha: 0.5),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              lessons[i],
                                              textDirection: isAr
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              style:
                                                  themeService.getTextStyle(
                                                fontSize: 14,
                                                color: bodyTextColor,
                                                height: 1.65,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),

                            const SizedBox(height: 16),

                            /* Source & grade */
                            _DetailSection(
                              icon: Icons.library_books_rounded,
                              title: isAr
                                  ? 'المصدر والدرجة'
                                  : (isFr
                                      ? 'Source et degré'
                                      : 'Source & authenticity'),
                              accent: kGold,
                              themeService: themeService,
                              isDarkMode: isDarkMode,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _InfoRow(
                                    label: isAr
                                        ? 'المصدر'
                                        : (isFr ? 'Source' : 'Source'),
                                    value: sourceText,
                                    isAr: isAr,
                                    themeService: themeService,
                                    isDarkMode: isDarkMode,
                                  ),
                                  const SizedBox(height: 10),
                                  _InfoRow(
                                    label: isAr
                                        ? 'الدرجة'
                                        : (isFr ? 'Degré' : 'Grade'),
                                    value: gradeText,
                                    isAr: isAr,
                                    themeService: themeService,
                                    isDarkMode: isDarkMode,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /* ───────── Floating action bar ───────── */
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? kGreen.withValues(alpha: 0.96)
                  : Colors.white.withValues(alpha: 0.96),
              border: Border(
                top: BorderSide(color: kGold.withValues(alpha: 0.35)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.copy_rounded,
                      label: isAr ? 'نسخ' : (isFr ? 'Copier' : 'Copy'),
                      themeService: themeService,
                      onTap: () =>
                          _copyText(context, themeService, isAr, shareText),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.share_rounded,
                      label: isAr ? 'مشاركة' : (isFr ? 'Partager' : 'Share'),
                      themeService: themeService,
                      onTap: () => _shareHadith(
                        context,
                        titleText,
                        hadithText,
                        narratorText,
                        sourceText,
                        gradeText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.text_fields_rounded,
                      label: isAr ? 'الخط' : (isFr ? 'Police' : 'Font'),
                      themeService: themeService,
                      onTap: () =>
                          _openFontSizeSheet(context, themeService, isAr),
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
}

/* ══════════════════════════════════════════════════════════════════════════
   DETAIL SUB-WIDGETS
   ══════════════════════════════════════════════════════════════════════════ */

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accent;
  final ThemeService themeService;
  final bool isDarkMode;
  final Widget child;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.accent,
    required this.themeService,
    required this.isDarkMode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withValues(alpha: 0.24)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 15, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: themeService.getTextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: accent,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final ThemeService themeService;
  final bool isDarkMode;

  const _Pill({
    required this.icon,
    required this.text,
    required this.color,
    required this.themeService,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: themeService.getTextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isAr;
  final ThemeService themeService;
  final bool isDarkMode;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.isAr,
    required this.themeService,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: themeService.getTextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: kGold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
            style: themeService.getTextStyle(
              fontSize: 13.5,
              color: isDarkMode ? Colors.white : Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final ThemeService themeService;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.themeService,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: kGold.withValues(alpha: _pressed ? 0.28 : 0.16),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kGold.withValues(alpha: 0.6), width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 19, color: kGold),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: widget.themeService.getTextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: kGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}