import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../widgets/islamic_pattern_background.dart';
import '../services/theme_service.dart';
import 'package:share_plus/share_plus.dart';

class HadithsScreen extends StatefulWidget {
  const HadithsScreen({super.key});

  @override
  State<HadithsScreen> createState() => _HadithsScreenState();
}

class _HadithsScreenState extends State<HadithsScreen> {
  final List<Hadith> hadiths = const [
    Hadith(
      titleAr: 'حديث النية',
      titleEn: 'Hadith of Intention',
      titleFr: 'Hadith de l\'Intention',
      textAr: 'إنما الأعمال بالنيات، وإنما لكل امرئ ما نوى',
      textEn: 'Indeed, all deeds are by intention, and every person will have only what they intended',
      textFr: 'Les actions ne sont jugées que par les intentions, et chacun n\'aura que ce qu\'il a eu l\'intention de faire',
      narratorAr: 'عن عمر بن الخطاب رضي الله عنه',
      narratorEn: 'Narrated by Umar ibn Al-Khattab',
      narratorFr: 'Rapporté par Umar ibn Al-Khattab',
      eventAr: 'بداية الهجرة إلى المدينة',
      eventEn: 'Beginning of the Migration to Medina',
      eventFr: 'Début de l\'Hégire vers Médine',
      meaningAr: 'تصحيح النية والعزم هو أساس العمل الصالح',
      meaningEn: 'Purifying intention and resolve is the foundation of all righteous deeds',
      meaningFr: 'Purifier l\'intention est la base de toute action pieuse',
    ),
    Hadith(
      titleAr: 'حديث الرحمة',
      titleEn: 'Hadith of Mercy',
      titleFr: 'Hadith de la Miséricorde',
      textAr: 'الراحمون يرحمهم الرحمن، ارحموا من في الأرض يرحمكم من في السماء',
      textEn: 'The merciful will be shown mercy by the Merciful. Be merciful to those on earth, and the One in the heavens will have mercy upon you',
      textFr: 'Les miséricordieux seront traités avec miséricorde par le Miséricordieux. Ayez de la miséricorde envers ceux sur terre et celui du ciel vous montrera de la miséricorde',
      narratorAr: 'عن عبد الله بن عمرو رضي الله عنهما',
      narratorEn: 'Narrated by Abdullah ibn Amr',
      narratorFr: 'Rapporté par Abdullah ibn Amr',
      eventAr: 'تعليم النبي صلى الله عليه وسلم للرحمة',
      eventEn: 'Teaching about compassion and mercy',
      eventFr: 'Enseignement sur la compassion et la miséricorde',
      meaningAr: 'الرحمة بالناس سبب لنيل رحمة الله تعالى',
      meaningEn: 'Showing kindness to people leads to receiving Allah\'s mercy',
      meaningFr: 'La bonté envers les gens mène à la miséricorde d\'Allah',
    ),
    Hadith(
      titleAr: 'حديث طلب العلم',
      titleEn: 'Hadith of Seeking Knowledge',
      titleFr: 'Hadith de la Quête du Savoir',
      textAr: 'طلب العلم فريضة على كل مسلم ومسلمة',
      textEn: 'Seeking knowledge is an obligation upon every Muslim, male and female',
      textFr: 'La quête du savoir est une obligation pour tout musulman et toute musulmane',
      narratorAr: 'عن أنس بن مالك رضي الله عنه',
      narratorEn: 'Narrated by Anas ibn Malik',
      narratorFr: 'Rapporté par Anas ibn Malik',
      eventAr: 'تشجيع النبي على العلم والتعلم',
      eventEn: 'The Prophet\'s encouragement to seek knowledge',
      eventFr: 'L\'encouragement du Prophète à chercher le savoir',
      meaningAr: 'العلم فريضة دينية على كل مسلم لا يجوز تركها',
      meaningEn: 'Knowledge is a religious duty that no Muslim should abandon',
      meaningFr: 'Le savoir est un devoir religieux qu\'aucun musulman ne doit abandonner',
    ),
    Hadith(
      titleAr: 'حديث حسن الخلق',
      titleEn: 'Hadith of Good Character',
      titleFr: 'Hadith du Bon Caractère',
      textAr: 'إن من أحبكم إلي وأقربكم مني مجلسا يوم القيامة أحاسنكم أخلاقا',
      textEn: 'Indeed, the most beloved of you to me and the nearest to me on the Day of Judgment are those with the best character',
      textFr: 'En vérité, les plus aimés de moi et les plus proches de moi le Jour de la Résurrection sont ceux d\'entre vous qui ont le meilleur caractère',
      narratorAr: 'عن أبي هريرة رضي الله عنه',
      narratorEn: 'Narrated by Abu Hurairah',
      narratorFr: 'Rapporté par Abu Hurairah',
      eventAr: 'وصف المؤمن الحقيقي',
      eventEn: 'Description of the true believer',
      eventFr: 'Description du vrai croyant',
      meaningAr: 'الأخلاق الحسنة من أفضل الأعمال عند الله تعالى',
      meaningEn: 'Good character is among the best deeds in the sight of Allah',
      meaningFr: 'Un bon caractère est parmi les meilleures actions aux yeux d\'Allah',
    ),
    Hadith(
      titleAr: 'حديث الصدق',
      titleEn: 'Hadith of Truthfulness',
      titleFr: 'Hadith de l\'Honnêteté',
      textAr: 'عليكم بالصدق، فإن الصدق يهدي إلى البر، وإن البر يهدي إلى الجنة',
      textEn: 'You must be truthful, for truthfulness leads to righteousness, and righteousness leads to Paradise',
      textFr: 'Soyez honnêtes, car l\'honnêteté mène à la vertu, et la vertu mène au Paradis',
      narratorAr: 'عن عبد الله بن مسعود رضي الله عنه',
      narratorEn: 'Narrated by Abdullah ibn Masud',
      narratorFr: 'Rapporté par Abdullah ibn Masud',
      eventAr: 'تحذير من الكذب ودعوة إلى الصدق',
      eventEn: 'Warning against lying and call to truthfulness',
      eventFr: 'Mise en garde contre les mensonges et appel à l\'honnêteté',
      meaningAr: 'الصدق يقود إلى الأعمال الصالحة والجنة',
      meaningEn: 'Truth leads to good deeds and Paradise',
      meaningFr: 'La vérité mène aux bonnes actions et au Paradis',
    ),
    Hadith(
      titleAr: 'حديث الصبر',
      titleEn: 'Hadith of Patience',
      titleFr: 'Hadith de la Patience',
      textAr: 'الصبر ضياء - ما أُعطي أحد عطاء خيراً وأوسع من الصبر',
      textEn: 'Patience is light. No one has been given something better and more vast than patience',
      textFr: 'La patience est une lumière. Personne n\'a reçu quelque chose de meilleur et plus vaste que la patience',
      narratorAr: 'عن أبي سعيد الخدري رضي الله عنه',
      narratorEn: 'Narrated by Abu Said Al-Khudri',
      narratorFr: 'Rapporté par Abu Said Al-Khudri',
      eventAr: 'فضل الصبر والتحمل',
      eventEn: 'Virtue of patience and endurance',
      eventFr: 'Vertu de la patience et de la persévérance',
      meaningAr: 'الصبر من أعظم الفضائل الدينية وينير طريق المؤمن',
      meaningEn: 'Patience is one of the greatest virtues that illuminates the believer\'s path',
      meaningFr: 'La patience est l\'une des plus grandes vertus qui éclairent le chemin du croyant',
    ),
    Hadith(
      titleAr: 'حديث نصرة الأخ',
      titleEn: 'Hadith of Helping Your Brother',
      titleFr: 'Hadith d\'Aider Votre Frère',
      textAr: 'انصر أخاك ظالماً أو مظلوماً، فقيل يا رسول الله أنصره إذا كان مظلوماً فكيف إذا كان ظالماً؟ قال: تمنعه من الظلم',
      textEn: 'Help your brother whether he is an oppressor or oppressed. If asked how to help an oppressor, he said: Prevent him from committing injustice',
      textFr: 'Aidez votre frère qu\'il soit oppresseur ou opprimé. On dit: ô Messager d\'Allah, comment l\'aider s\'il est oppresseur? Il dit: Empêchez-le de faire l\'injustice',
      narratorAr: 'عن أنس بن مالك رضي الله عنه',
      narratorEn: 'Narrated by Anas ibn Malik',
      narratorFr: 'Rapporté par Anas ibn Malik',
      eventAr: 'الحث على التعاون والنصرة بين المسلمين',
      eventEn: 'Encouragement of mutual support among Muslims',
      eventFr: 'Encouragement du soutien mutuel entre musulmans',
      meaningAr: 'الأخوة الإسلامية تقتضي النصرة لكن بالعدل والحكمة',
      meaningEn: 'Islamic brotherhood requires support through justice and wisdom',
      meaningFr: 'La fraternité islamique exige le soutien par la justice et la sagesse',
    ),
    Hadith(
      titleAr: 'حديث الوالدين',
      titleEn: 'Hadith of Parents',
      titleFr: 'Hadith des Parents',
      textAr: 'الوالد أوسط أبواب الجنة، فإن شئت فضيّع ذلك الباب أو احفظه',
      textEn: 'Your parent is the middle gate to Paradise. If you wish, you may lose access to it, or preserve it',
      textFr: 'Votre parent est la porte centrale du Paradis. Si vous voulez, vous pouvez perdre l\'accès à cette porte, ou la préserver',
      narratorAr: 'عن عبد الله بن عمر رضي الله عنهما',
      narratorEn: 'Narrated by Abdullah ibn Umar',
      narratorFr: 'Rapporté par Abdullah ibn Umar',
      eventAr: 'فضل بر الوالدين',
      eventEn: 'Virtue of honoring parents',
      eventFr: 'Vertu du respect des parents',
      meaningAr: 'بر الوالدين من أعظم الأسباب لدخول الجنة',
      meaningEn: 'Honoring parents is one of the greatest means to enter Paradise',
      meaningFr: 'Honorer les parents est l\'un des plus grands moyens d\'entrer au Paradis',
    ),
    Hadith(
      titleAr: 'حديث كظم الغيظ',
      titleEn: 'Hadith of Controlling Anger',
      titleFr: 'Hadith de la Maîtrise de la Colère',
      textAr: 'من كظم غيظاً وهو قادر على أن ينفذه، دعاه الله على رؤوس الخلائق يوم القيامة',
      textEn: 'Whoever suppresses anger while able to vent it, Allah will call him before all creatures on the Day of Judgment to offer him his choice of rewards',
      textFr: 'Celui qui maîtrise sa colère alors qu\'il en a le pouvoir, Allah l\'appellera devant toutes les créatures le Jour de la Résurrection',
      narratorAr: 'عن أبي هريرة رضي الله عنه',
      narratorEn: 'Narrated by Abu Hurairah',
      narratorFr: 'Rapporté par Abu Hurairah',
      eventAr: 'التحكم بالنفس والعاطفة',
      eventEn: 'Self-control and emotional management',
      eventFr: 'Maîtrise de soi et gestion émotionnelle',
      meaningAr: 'السيطرة على الغضب دليل قوة النفس وعلو الأخلاق',
      meaningEn: 'Controlling anger shows strength of character and noble morals',
      meaningFr: 'Maîtriser la colère montre la force du caractère et la noblesse morale',
    ),
    Hadith(
      titleAr: 'حديث الصدقة',
      titleEn: 'Hadith of Charity',
      titleFr: 'Hadith de l\'Aumône',
      textAr: 'الصدقة تطفئ غضب الرب وتدفع ميتة السوء',
      textEn: 'Charity extinguishes the wrath of Allah and prevents a bad death',
      textFr: 'L\'aumône éteint la colère d\'Allah et prévient une mauvaise mort',
      narratorAr: 'عن أنس بن مالك رضي الله عنه',
      narratorEn: 'Narrated by Anas ibn Malik',
      narratorFr: 'Rapporté par Anas ibn Malik',
      eventAr: 'فضل الإنفاق والعطاء',
      eventEn: 'Virtue of giving and spending',
      eventFr: 'Vertu du don et de la générosité',
      meaningAr: 'الصدقة حماية من العذاب وسبب للرحمة الإلهية',
      meaningEn: 'Charity is protection from punishment and a means of Allah\'s mercy',
      meaningFr: 'L\'aumône est une protection contre le châtiment et un moyen de la miséricorde d\'Allah',
    ),
    Hadith(
      titleAr: 'حديث عيادة المريض',
      titleEn: 'Hadith of Visiting the Sick',
      titleFr: 'Hadith de la Visite aux Malades',
      textAr: 'من عاد مريضاً لم يزل يخوض في الرحمة حتى يجلس، فإذا جلس فقد دخلها',
      textEn: 'Whoever visits a sick person, he will remain wading through mercy until he sits. When he sits, he has entered it completely',
      textFr: 'Celui qui visite un malade reste immergé dans la miséricorde jusqu\'à ce qu\'il s\'asseie. S\'il s\'assied, il y est entré complètement',
      narratorAr: 'عن علي بن أبي طالب رضي الله عنه',
      narratorEn: 'Narrated by Ali ibn Abi Talib',
      narratorFr: 'Rapporté par Ali ibn Abi Talib',
      eventAr: 'رعاية المريض والدعاء له',
      eventEn: 'Caring for the sick and praying for them',
      eventFr: 'Prendre soin des malades et prier pour eux',
      meaningAr: 'عيادة المريض عمل من أعمال الرحمة والبر',
      meaningEn: 'Visiting the sick is an act of mercy and kindness',
      meaningFr: 'Visiter le malade est un acte de miséricorde et de bonté',
    ),
    Hadith(
      titleAr: 'حديث البسمة',
      titleEn: 'Hadith of Smiling',
      titleFr: 'Hadith du Sourire',
      textAr: 'تبسمك في وجه أخيك لك صدقة',
      textEn: 'Your smile to your brother is an act of charity',
      textFr: 'Votre sourire à votre frère est une aumône',
      narratorAr: 'عن أبي ذر الغفاري رضي الله عنه',
      narratorEn: 'Narrated by Abu Dharr Al-Ghifari',
      narratorFr: 'Rapporté par Abu Dharr Al-Ghifari',
      eventAr: 'فضل الأخلاق الحسنة البسيطة',
      eventEn: 'Virtue of simple good manners',
      eventFr: 'Vertu des simples bonnes manières',
      meaningAr: 'أبسط أعمال الخير لها أجر عظيم عند الله',
      meaningEn: 'Even the simplest acts of goodness have great reward with Allah',
      meaningFr: 'Même les actes de bonté les plus simples ont une grande récompense chez Allah',
    ),
    Hadith(
      titleAr: 'حديث الأخوة الإسلامية',
      titleEn: 'Hadith of Islamic Brotherhood',
      titleFr: 'Hadith de la Fraternité Islamique',
      textAr: 'المسلم أخو المسلم لا يظلمه ولا يسلمه، من كان في حاجة أخيه كان الله في حاجته',
      textEn: 'A Muslim is the brother of another Muslim. He does not wrong him, nor does he abandon him. Whoever fulfills the needs of his brother, Allah will fulfill his needs',
      textFr: 'Un musulman est le frère d\'un autre musulman. Il ne le lèse pas et ne l\'abandonne pas. Celui qui satisfait les besoins de son frère, Allah satisfera ses besoins',
      narratorAr: 'عن أبي هريرة رضي الله عنه',
      narratorEn: 'Narrated by Abu Hurairah',
      narratorFr: 'Rapporté par Abu Hurairah',
      eventAr: 'تعميق أواصر الأخوة بين المسلمين',
      eventEn: 'Strengthening bonds of brotherhood among Muslims',
      eventFr: 'Renforcement des liens de fraternité entre musulmans',
      meaningAr: 'الأخوة الإسلامية عقد مقدس يقتضي الوفاء والعطف',
      meaningEn: 'Islamic brotherhood is a sacred bond that requires loyalty and compassion',
      meaningFr: 'La fraternité islamique est un lien sacré qui exige la loyauté et la compassion',
    ),
    Hadith(
      titleAr: 'حديث الصدق في التجارة',
      titleEn: 'Hadith of Honesty in Trade',
      titleFr: 'Hadith de l\'Honnêteté dans le Commerce',
      textAr: 'البيعان بالخيار ما لم يتفرقا، فإن صدقا وبيّنا بُورك لهما في بيعهما، وإن كتما وكذبا محقت البركة من بيعهما',
      textEn: 'The buyer and seller have the right to return goods before they separate. If they are truthful and transparent, they will be blessed in their transaction. If they conceal and lie, the blessing of their transaction will be erased',
      textFr: 'L\'acheteur et le vendeur ont le droit de retourner les marchandises avant de se séparer. S\'ils sont honnêtes et transparents, leur transaction sera bénie. S\'ils dissimulent et mentent, la bénédiction sera effacée',
      narratorAr: 'عن عبد الله بن عمر رضي الله عنهما',
      narratorEn: 'Narrated by Abdullah ibn Umar',
      narratorFr: 'Rapporté par Abdullah ibn Umar',
      eventAr: 'أحكام البيع والشراء',
      eventEn: 'Rules of buying and selling',
      eventFr: 'Règles de l\'achat et de la vente',
      meaningAr: 'الصدق في المعاملات سبب البركة والرزق',
      meaningEn: 'Honesty in dealings is a source of blessing and prosperity',
      meaningFr: 'L\'honnêteté dans les transactions est source de bénédiction et de prospérité',
    ),
    Hadith(
      titleAr: 'حديث حفظ اللسان',
      titleEn: 'Hadith of Guarding the Tongue',
      titleFr: 'Hadith de la Garde de la Langue',
      textAr: 'من يضمن لي ما بين لحييه وما بين رجليه أضمن له الجنة',
      textEn: 'Whoever can guarantee me what is between his jaws and what is between his legs, I guarantee him Paradise',
      textFr: 'Celui qui peut me garantir ce qui est entre ses mâchoires et ce qui est entre ses jambes, je lui garantis le Paradis',
      narratorAr: 'عن سهل بن سعد رضي الله عنه',
      narratorEn: 'Narrated by Sahl ibn Saad',
      narratorFr: 'Rapporté par Sahl ibn Saad',
      eventAr: 'التحكم في الكلام والسلوك',
      eventEn: 'Control of speech and behavior',
      eventFr: 'Maîtrise de la parole et du comportement',
      meaningAr: 'حفظ اللسان من الآثام يؤدي إلى دخول الجنة',
      meaningEn: 'Guarding the tongue from sin leads to entering Paradise',
      meaningFr: 'Garder la langue du péché mène à entrer au Paradis',
    ),
    Hadith(
      titleAr: 'حديث النهي عن الحسد',
      titleEn: 'Hadith Against Envy',
      titleFr: 'Hadith Contre l\'Envie',
      textAr: 'لا تحاسدوا ولا تناجشوا ولا تباغضوا ولا تدابروا، وكونوا عباد الله إخواناً',
      textEn: 'Do not envy one another, do not inflate prices artificially, do not hate one another, do not turn away from one another, and be servants of Allah as brothers',
      textFr: 'Ne vous enviez pas, ne pratiquez pas d\'enchères artificielles, ne vous haïssez pas, ne vous tournez pas le dos les uns aux autres, et soyez des serviteurs d\'Allah comme des frères',
      narratorAr: 'عن أبي هريرة رضي الله عنه',
      narratorEn: 'Narrated by Abu Hurairah',
      narratorFr: 'Rapporté par Abu Hurairah',
      eventAr: 'النهي عن الحسد والبغضاء',
      eventEn: 'Prohibition of envy and hatred',
      eventFr: 'Interdiction de l\'envie et de la haine',
      meaningAr: 'الحسد يفسد العلاقات بين المسلمين والأخوة الإسلامية',
      meaningEn: 'Envy corrupts relationships among Muslims and Islamic brotherhood',
      meaningFr: 'L\'envie corrompt les relations entre musulmans et la fraternité islamique',
    ),
  ];

  String _getScreenTitle(String langCode) {
    switch (langCode) {
      case 'ar':
        return 'أحاديث النبي محمد';
      case 'fr':
        return 'Hadiths du Prophète Muhammad';
      default:
        return 'Hadiths of Prophet Muhammad';
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final isArabic = langCode == 'ar';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFD4AF37)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _getScreenTitle(langCode),
                            style: themeService.getTextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      itemCount: hadiths.length,
                      itemBuilder: (context, index) {
                        final hadith = hadiths[index];
                        return HadithCard(
                          hadith: hadith,
                          isArabic: isArabic,
                          themeService: themeService,
                        );
                      },
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

class Hadith {
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

  const Hadith({
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
  });
}

class HadithCard extends StatelessWidget {
  final Hadith hadith;
  final bool isArabic;
  final ThemeService themeService;

  const HadithCard({
    super.key, 
    required this.hadith,
    required this.isArabic,
    required this.themeService,
  });

  String _getLanguage(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  String _getText(String ar, String en, String fr, String lang) {
    switch (lang) {
      case 'ar':
        return ar;
      case 'fr':
        return fr;
      default:
        return en;
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? 'تم النسخ إلى الحافظة' : 'Copied to clipboard',
            style: themeService.getTextStyle(fontSize: 14),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFFD4AF37).withValues(alpha: 0.9),
        ),
      );
    });
  }

  void _shareHadith(BuildContext context, String title, String text, String narrator) {
    final shareText = '$title\n\n$text\n\n$narrator';
    
    // Triggers the native OS share dialog
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final lang = _getLanguage(context);
    final isAr = lang == 'ar';
    final isFr = lang == 'fr';

    final hadithText = _getText(hadith.textAr, hadith.textEn, hadith.textFr, lang);
    final narratorText = _getText(hadith.narratorAr, hadith.narratorEn, hadith.narratorFr, lang);
    final titleText = _getText(hadith.titleAr, hadith.titleEn, hadith.titleFr, lang);

    // Adaptive text color for high contrast in both light/dark themes
    final bodyTextColor = AppTheme.getOnBackgroundColor(context); 

    // Brightened accent colors for borders, backgrounds, and headers
    const eventAccent = Color(0xFFCBB28A); // Lighter brown/tan
    const narratorAccent = Color(0xFFD4AF37); // Kept original gold
    const meaningAccent = Color(0xFF81C784); // Lighter green

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: narratorAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            titleText,
            style: themeService.getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: narratorAccent,
            ),
            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
          ),
          const SizedBox(height: 12),
          Text(
            hadithText,
            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
            style: themeService.getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: bodyTextColor,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          
          // Event Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: eventAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: eventAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isAr ? 'المناسبة:' : (isFr ? 'Contexte:' : 'Event:'),
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: eventAccent,
                  ),
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                ),
                const SizedBox(height: 4),
                Text(
                  _getText(hadith.eventAr, hadith.eventEn, hadith.eventFr, lang),
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                  style: themeService.getTextStyle(
                    fontSize: 13,
                    color: bodyTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          // Narrator Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: narratorAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: narratorAccent.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isAr ? 'الراوي:' : (isFr ? 'Narrateur:' : 'Narrator:'),
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: narratorAccent,
                  ),
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                ),
                const SizedBox(height: 4),
                Text(
                  narratorText,
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                  style: themeService.getTextStyle(
                    fontSize: 13,
                    color: bodyTextColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          // Meaning & Benefit Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: meaningAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: meaningAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isAr ? 'المعنى والفائدة:' : (isFr ? 'Sens et Bénéfice:' : 'Meaning & Benefit:'),
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: meaningAccent,
                  ),
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                ),
                const SizedBox(height: 4),
                Text(
                  _getText(hadith.meaningAr, hadith.meaningEn, hadith.meaningFr, lang),
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                  style: themeService.getTextStyle(
                    fontSize: 13,
                    color: bodyTextColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _copyToClipboard(context, hadithText),
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: Text(
                    isAr ? 'نسخ' : (isFr ? 'Copier' : 'Copy'),
                    style: themeService.getTextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: narratorAccent.withValues(alpha: 0.2),
                    foregroundColor: narratorAccent,
                    elevation: 0,
                    side: const BorderSide(
                      color: narratorAccent,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareHadith(context, titleText, hadithText, narratorText),
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: Text(
                    isAr ? 'مشاركة' : (isFr ? 'Partager' : 'Share'),
                    style: themeService.getTextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: narratorAccent.withValues(alpha: 0.2),
                    foregroundColor: narratorAccent,
                    elevation: 0,
                    side: const BorderSide(
                      color: narratorAccent,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}