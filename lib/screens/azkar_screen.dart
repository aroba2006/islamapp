import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart';
import '../utils/share_image_generator.dart';
import '../services/theme_service.dart';

// ── MODELS ──────────────────────────────────────────────────────

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
  final String translationFr;
  final int count;
  const _ZikrItem({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.translationFr,
    required this.count,
  });
}

// ── DATA ────────────────────────────────────────────────────────

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
  _AzkarCategory(
    titleAr: 'أذكار الاستيقاظ',
    titleEn: 'Upon Waking',
    titleFr: 'Au Réveil',
    emoji: '🌅',
    color: Color(0xFFD4A574),
    items: [
      _ZikrItem(
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        transliteration: 'Alhamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur.',
        translation: 'All praise is for Allah who gave us life after death and unto Him is the resurrection.',
        translationFr: 'Louange à Allah qui nous a ramenés à la vie après nous avoir fait mourir, et c\'est vers Lui que nous retournerons.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'أَصْبَحْنَا عَلَى فِطْرَةِ اللَّهِ، وَالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        transliteration: 'Asbahna ala fitratillah, walhamdu lillahi rabbi al-alamin.',
        translation: 'We have reached the morning upon Allah\'s natural way, and all praise is for Allah, Lord of all that exists.',
        translationFr: 'Nous sommes arrivés au matin sur la nature d\'Allah, et toute louange est à Allah, Seigneur des mondes.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَعَلَيْكَ تَوَكَّلْنَا وَإِلَيْكَ الْمَصِيرُ',
        transliteration: 'Allahumma bika asbahna wa bika amsayna wa alayaka tawakkaltu wa ilaykal-masir.',
        translation: 'O Allah, by You we have reached the morning and by You we reach the evening. In You we trust and unto You is the final return.',
        translationFr: 'Ô Allah, c\'est par Toi que nous arrivons au matin et au soir, en Toi nous mettons notre confiance et vers Toi est le destin.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار دخول المنزل',
    titleEn: 'Entering Home',
    titleFr: 'En Entrant à la Maison',
    emoji: '🏠',
    color: Color(0xFF8B4513),
    items: [
      _ZikrItem(
        arabic: 'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
        transliteration: 'Bismillahi walaj-na wa bismillahi kharaj-na wa alallahi rabbi tawakkal-na.',
        translation: 'In the name of Allah we enter, and in the name of Allah we exit, and upon Allah our Lord we place our trust.',
        translationFr: 'Au nom d\'Allah nous entrons, au nom d\'Allah nous sortons, et c\'est en Allah notre Seigneur que nous plaçons notre confiance.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَولَجِ وَخَيْرَ الْمَخْرَجِ',
        transliteration: 'Allahumma inni as\'aluka khayral-mawlaj wa khayral-makhraj.',
        translation: 'O Allah, I ask You for the best entrance and the best exit.',
        translationFr: 'Ô Allah, je Te demande de bénir mon entrée et ma sortie.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ بِاسْمِكَ دَخَلْتُ وَبِاسْمِكَ خَرَجْتُ وَعَلَيْكَ رَبِّي تَوَكَّلْتُ',
        transliteration: 'Allahumma bismika dakhalt wa bismika kharajt wa alaykar rabbi tawakkal-t.',
        translation: 'O Allah, in Your name I enter and in Your name I exit, and upon You my Lord, I place my trust.',
        translationFr: 'Ô Allah, c\'est en Ton nom que j\'entre et que je sors, c\'est en Toi que je mets ma confiance.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الخروج من المنزل',
    titleEn: 'Leaving Home',
    titleFr: 'En Quittant la Maison',
    emoji: '🚪',
    color: Color(0xFF2F4F4F),
    items: [
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أَضِلَّ أَوْ أُضَلَّ أَوْ أَزِلَّ أَوْ أُزَلَّ أَوْ أَظْلِمَ أَوْ أُظْلَمَ أَوْ أَجْهَلَ أَوْ يُجْهَلَ عَلَيَّ',
        transliteration: 'Allahumma inni a\'udhu bika an adilla aw udalla aw azilla aw uzalla aw azlim aw uzlam aw ajhal aw yujhal alayya.',
        translation: 'O Allah, I seek refuge in You lest I lead others astray or am led astray, lest I cause others to stumble or stumble, lest I treat others unjustly or be treated unjustly, or lest I act ignorantly or someone acts ignorantly towards me.',
        translationFr: 'Ô Allah, je cherche refuge en Toi contre les erreurs, les injustices et l\'ignorance.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'بِسْمِ اللَّهِ توَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
        transliteration: 'Bismillahi tawakkaltu alallah, wa la hawla wa la quwwata illa billah.',
        translation: 'In the name of Allah, I place my trust in Allah. There is no power and no might except with Allah.',
        translationFr: 'Au nom d\'Allah, je me fie à Allah. Il n\'y a de pouvoir ni de force sauf par Allah.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار المرحاض',
    titleEn: 'Bathroom',
    titleFr: 'Salle de Bain',
    emoji: '🚽',
    color: Color(0xFF6495ED),
    items: [
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
        transliteration: 'Allahumma inni a\'udhu bika minal-khubth wal-khabai\'th.',
        translation: 'O Allah, I seek refuge in You from male and female demons.',
        translationFr: 'Ô Allah, je cherche refuge en Toi contre les génies impurs, mâles et femelles.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'غُفْرَانَكَ',
        transliteration: 'Ghufranaka.',
        translation: 'Your forgiveness. (Said when leaving the bathroom)',
        translationFr: 'Ton pardon. (À dire en sortant des toilettes)',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الحزن والهم',
    titleEn: 'During Worry',
    titleFr: 'Pendant la Peine',
    emoji: '😔',
    color: Color(0xFF696969),
    items: [
      _ZikrItem(
        arabic: 'لَا إِلَهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ',
        transliteration: 'La ilaha illallahul-azimul-halim, la ilaha illallahu rabbul-arshil-azim, la ilaha illallahu rabbus-samawati wa rabbul-ardi wa rabbul-arshil-karim.',
        translation: 'None has the right to be worshipped except Allah, the Mighty, the Forbearing. None has the right to be worshipped except Allah, Lord of the Mighty Throne. None has the right to be worshipped except Allah, Lord of the heavens and earth and Lord of the Noble Throne.',
        translationFr: 'Il n\'y a de divinité qu\'Allah, l\'Immense, le Clément. Il n\'y a de divinité qu\'Allah, Seigneur du Trône immense.',
        count: 3,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ رَحْمَتَكَ أَرْجُو فَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ، وَأَصْلِحْ لِي شَأْنِي كُلَّهُ، لَا إِلَهَ إِلَّا أَنْتَ',
        transliteration: 'Allahumma rahmataka arjoo fa la takilni ila nafsi tarfata ayn, wa aslih li sha\'ni kullah, la ilaha illa ant.',
        translation: 'O Allah, Your mercy I hope for, so do not abandon me to myself for the duration of an eye\'s wink. Set all my affairs straight for me. There is none worthy of worship except You.',
        translationFr: 'Ô Allah, j\'espère Ta miséricorde, donc ne m\'abandonne pas à moi-même. Mets en ordre toutes mes affaires.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الغم والكرب',
    titleEn: 'During Distress',
    titleFr: 'Pendant la Détresse',
    emoji: '💔',
    color: Color(0xFF8B0000),
    items: [
      _ZikrItem(
        arabic: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
        transliteration: 'La ilaha illa anta subhanaka inni kuntu mina az-zalimin.',
        translation: 'None has the right to be worshipped except You (in Your perfection). Glory be to You. Surely, I have been among those who did wrong.',
        translationFr: 'Il n\'y a de divinité que Toi, exalté sois-Tu. Certes, j\'ai été du nombre des injustes.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
        transliteration: 'Allahumma inni a\'udhu bika minal-hammi wal-hazan.',
        translation: 'O Allah, I seek refuge in You from anxiety and sorrow.',
        translationFr: 'Ô Allah, je cherche refuge en Toi contre le souci et la tristesse.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ',
        transliteration: 'Allahumma inni a\'udhu bika minal-ajzi wal-kasali.',
        translation: 'O Allah, I seek refuge in You from inadequacy and laziness.',
        translationFr: 'Ô Allah, je cherche refuge en Toi contre l\'impuissance et la paresse.',
        count: 1,
      ),
    ],
  ),

    // ── NEW CATEGORIES ─────────────────────────────────────────────
  _AzkarCategory(
    titleAr: 'أذكار السفر',
    titleEn: 'Travel',
    titleFr: 'Voyage',
    emoji: '✈️',
    color: Color(0xFF00695C),
    items: [
      _ZikrItem(
        arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
        transliteration: 'Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila rabbina lamunqalibun.',
        translation: 'Glory to Him who has subjected this to us, and we could never have it by our own efforts. And indeed, to our Lord we will surely return.',
        translationFr: 'Gloire à Celui qui a mis ceci à notre service. Certes, c\'est vers notre Seigneur que nous retournerons.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى',
        transliteration: 'Allahumma inna nas\'aluka fi safarina hadhal-birra wat-taqwa, wa minal-amali ma tarda.',
        translation: 'O Allah, we ask You on this journey of ours for righteousness and piety, and for deeds that please You.',
        translationFr: 'Ô Allah, nous Te demandons, dans ce voyage, la bonté, la piété et les œuvres qui Te plaisent.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ',
        transliteration: 'Allahumma hawwin alayna safarana hadha watwi anna bu\'dah.',
        translation: 'O Allah, make this journey easy for us and shorten its distance.',
        translationFr: 'Ô Allah, facilite-nous ce voyage et raccourcis-en la distance.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
        transliteration: 'A\'udhu bikalimatillahit-tammati min sharri ma khalaq.',
        translation: 'I seek refuge in the perfect words of Allah from the evil of what He created.',
        translationFr: 'Je cherche refuge dans les paroles parfaites d\'Allah contre le mal de ce qu\'Il a créé.',
        count: 3,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار المرض والشفاء',
    titleEn: 'Sickness',
    titleFr: 'Maladie',
    emoji: '🩺',
    color: Color(0xFFAD1457),
    items: [
      _ZikrItem(
        arabic: 'اللَّهُمَّ رَبَّ النَّاسِ، أَذْهِبِ الْبَاسَ، اشْفِ أَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ',
        transliteration: 'Allahumma rabban-nas, adh-hibil-ba\'s, ishfi antash-shafi, la shifa\'a illa shifa\'uk.',
        translation: 'O Allah, Lord of mankind, remove the harm. Cure, for You are the Healer. There is no healing but Yours.',
        translationFr: 'Ô Allah, Seigneur des gens, ôte le mal. Guéris, Tu es le Guérisseur. Il n\'y a de guérison que la Tienne.',
        count: 3,
      ),
      _ZikrItem(
        arabic: 'بِسْمِ اللَّهِ أَرْقِيكَ، مِنْ كُلِّ دَاءٍ يُؤْذِيكَ، وَمِنْ شَرِّ كُلِّ نَفْسٍ أَوْ عَيْنِ حَاسِدٍ، اللَّهُ يَشْفِيكَ',
        transliteration: 'Bismillahi arqik, min kulli da\'in yu\'dhik, wa min sharri kulli nafsin aw ayni hasid, Allahu yashfik.',
        translation: 'In the name of Allah I recite over you, from every illness that harms you, from every soul and envious eye — may Allah cure you.',
        translationFr: 'Au nom d\'Allah je te récite, contre tout mal qui te nuit, contre toute âme et tout œil envieux. Qu\'Allah te guérisse.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'أَسْأَلُ اللَّهَ الْعَظِيمَ رَبَّ الْعَرْشِ الْعَظِيمِ أَنْ يَشْفِيَكَ',
        transliteration: 'As\'alullahal-azim, rabbal-arshil-azim, an yashfiyak.',
        translation: 'I ask Allah the Almighty, Lord of the Mighty Throne, to cure you. (Recited 7 times for the sick)',
        translationFr: 'Je demande à Allah l\'Immense, Seigneur du Trône immense, de te guérir. (7 fois)',
        count: 7,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الطقس والطبيعة',
    titleEn: 'Weather & Nature',
    titleFr: 'Météo et Nature',
    emoji: '🌧️',
    color: Color(0xFF1565C0),
    items: [
      _ZikrItem(
        arabic: 'اللَّهُمَّ صَيِّبًا نَافِعًا',
        transliteration: 'Allahumma sayyiban nafi\'a.',
        translation: 'O Allah, (make it) a beneficial rain.',
        translationFr: 'Ô Allah, (fais-en) une pluie bénéfique.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'مُطِرْنَا بِفَضْلِ اللَّهِ وَرَحْمَتِهِ',
        transliteration: 'Mutirna bifadlillahi wa rahmatih.',
        translation: 'We have been given rain by the grace and mercy of Allah.',
        translationFr: 'Nous avons reçu la pluie par la grâce et la miséricorde d\'Allah.',
        count: 1,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ مَا فِيهَا وَخَيْرَ مَا أُرْسِلَتْ بِهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَرِّ مَا فِيهَا وَشَرِّ مَا أُرْسِلَتْ بِهِ',
        transliteration: 'Allahumma inni as\'aluka khayraha wa khayra ma fiha wa khayra ma ursilat bih, wa a\'udhu bika min sharriha wa sharri ma fiha wa sharri ma ursilat bih.',
        translation: 'O Allah, I ask You for its good, the good in it, and the good with which it was sent. I seek refuge in You from its evil, the evil in it, and the evil with which it was sent. (Said at strong winds)',
        translationFr: 'Ô Allah, je Te demande son bien, le bien qu\'elle contient et le bien avec lequel elle est envoyée. Je cherche refuge en Toi contre son mal. (Vent fort)',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار يوم الجمعة',
    titleEn: 'Friday',
    titleFr: 'Vendredi',
    emoji: '🕌',
    color: Color(0xFF283593),
    items: [
      _ZikrItem(
        arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ',
        transliteration: 'Allahumma salli ala Muhammad wa ala ali Muhammad, kama sallayta ala Ibrahim wa ala ali Ibrahim.',
        translation: 'O Allah, send prayers upon Muhammad and the family of Muhammad, as You sent prayers upon Ibrahim and the family of Ibrahim.',
        translationFr: 'Ô Allah, prie sur Muhammad et sur la famille de Muhammad, comme Tu as prié sur Ibrahim et sa famille.',
        count: 10,
      ),
      _ZikrItem(
        arabic: 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
        transliteration: 'Subhan Allahi wal-hamdu lillahi wa la ilaha illallahu wallahu akbar.',
        translation: 'Glory be to Allah, all praise to Allah, there is no god but Allah, and Allah is the Greatest.',
        translationFr: 'Gloire à Allah, louange à Allah, il n\'y a de dieu qu\'Allah, et Allah est le plus Grand.',
        count: 100,
      ),
      _ZikrItem(
        arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
        transliteration: 'Astaghfirullaha wa atubu ilayh.',
        translation: 'I seek forgiveness from Allah and I repent to Him.',
        translationFr: 'Je demande pardon à Allah et je me repens à Lui.',
        count: 100,
      ),
      _ZikrItem(
        arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration: 'La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay\'in qadir.',
        translation: 'There is no god but Allah, alone without partner. His is the dominion and His is the praise, and He is capable of all things.',
        translationFr: 'Il n\'y a de dieu qu\'Allah, seul sans associé. À Lui la royauté, à Lui la louange, et Il est Omnipotent.',
        count: 100,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار التوبة والاستغفار',
    titleEn: 'Repentance',
    titleFr: 'Repentir',
    emoji: '🤲',
    color: Color(0xFF6A1B9A),
    items: [
      _ZikrItem(
        arabic: 'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
        transliteration: 'Rabbighfir li wa tub alayya innaka antat-tawwabur-rahim.',
        translation: 'My Lord, forgive me and accept my repentance. Truly You are the Ever-Relenting, Most Merciful.',
        translationFr: 'Mon Seigneur, pardonne-moi et accepte mon repentir. Tu es certes Le Très-Pardonnant, Le Miséricordieux.',
        count: 100,
      ),
      _ZikrItem(
        arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيَّ الْقَيُّومَ وَأَتُوبُ إِلَيْهِ',
        transliteration: 'Astaghfirullahal-azim, alladhi la ilaha illa huwal-hayyul-qayyum, wa atubu ilayh.',
        translation: 'I seek forgiveness from Allah the Almighty, besides whom there is no god, the Ever-Living, the Sustainer, and I turn to Him in repentance.',
        translationFr: 'Je demande pardon à Allah l\'Immense, en dehors duquel il n\'y a pas de dieu, Le Vivant, Le Subsistant, et je me repens à Lui.',
        count: 3,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي',
        transliteration: 'Allahumma anta rabbi la ilaha illa ant, khalaqtani wa ana abduk, wa ana ala ahdika wa wa\'dika mastata\'t, a\'udhu bika min sharri ma sana\'t, abu\'u laka bini\'matika alayya, wa abu\'u bidhanbi faghfir li.',
        translation: 'O Allah, You are my Lord. There is no god but You. You created me and I am Your servant. I keep Your covenant and promise as much as I am able. I seek refuge in You from the evil I have done. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me.',
        translationFr: 'Ô Allah, Tu es mon Seigneur. Il n\'y a de dieu que Toi. Tu m\'as créé et je suis Ton serviteur. Je cherche refuge en Toi contre le mal que j\'ai commis. Pardonne-moi.',
        count: 1,
      ),
    ],
  ),
  _AzkarCategory(
    titleAr: 'أذكار الحماية والأمان',
    titleEn: 'Protection',
    titleFr: 'Protection',
    emoji: '🛡️',
    color: Color(0xFF37474F),
    items: [
      _ZikrItem(
        arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
        transliteration: 'A\'udhu bikalimatillahit-tammati min sharri ma khalaq.',
        translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created. (Said 3x morning & evening — nothing will harm you)',
        translationFr: 'Je cherche refuge dans les paroles parfaites d\'Allah contre le mal de ce qu\'Il a créé. (3x matin et soir)',
        count: 3,
      ),
      _ZikrItem(
        arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        transliteration: 'Bismillahil-ladhi la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\'i wa huwas-sami\'ul-alim.',
        translation: 'In the name of Allah, with whose name nothing on earth or in heaven can cause harm. He is the All-Hearing, the All-Knowing. (3x morning & evening)',
        translationFr: 'Au nom d\'Allah, dont le nom protège de tout mal sur terre et au ciel. Il est L\'Audient, L\'Omniscient. (3x)',
        count: 3,
      ),
      _ZikrItem(
        arabic: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ، عَلَيْهِ تَوَكَّلْتُ، وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
        transliteration: 'Hasbiyallahu la ilaha illa huwa, alayhi tawakkaltu, wa huwa rabbul-arshil-azim.',
        translation: 'Allah is sufficient for me. There is no god but Him. In Him I put my trust, and He is Lord of the Mighty Throne. (7x)',
        translationFr: 'Allah me suffit. Il n\'y a de dieu que Lui. En Lui je place ma confiance. (7x)',
        count: 7,
      ),
      _ZikrItem(
        arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
        transliteration: 'Allahumma inni a\'udhu bika minal-hammi wal-hazan, wal-ajzi wal-kasal, wal-bukhli wal-jubn, wa dala\'id-dayni wa ghalabatir-rijal.',
        translation: 'O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debt and being overpowered by men.',
        translationFr: 'Ô Allah, je cherche refuge en Toi contre le souci et la tristesse, la faiblesse et la paresse, l\'avarice et la lâcheté, le poids de la dette.',
        count: 1,
      ),
    ],
  ),
];


// ── SHARED CONSTANTS ────────────────────────────────────────────

const Color _kGold = Color(0xFFD4AF37);

// ═══════════════════════════════════════════════════════════════
// MAIN SCREEN
// ═══════════════════════════════════════════════════════════════

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  bool _isGridView = true;

  int get _totalAzkar =>
      _categories.fold<int>(0, (sum, cat) => sum + cat.items.length);

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final l10n = AppLocalizations.of(context);
        final lang = Localizations.localeOf(context).languageCode;
        final isArabic = lang == 'ar';
        final isFrench = lang == 'fr';
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context, isArabic, l10n, () {
                    setState(() => _isGridView = !_isGridView);
                  }, _isGridView),
                  _buildHeroHeader(
                    context,
                    lang,
                    isArabic,
                    isFrench,
                    isDarkMode,
                    themeService,
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: FadeTransition(
                          opacity: _entranceCtrl,
                          child: _isGridView
                              ? _buildGrid(context, lang, themeService)
                              : _buildList(context, lang, themeService),
                        ),
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

  // ── TOP BAR ──────────────────────────────────────────────────

  Widget _buildTopBar(
    BuildContext context,
    bool isArabic,
    AppLocalizations? l10n,
    VoidCallback onToggleView,
    bool isGrid,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            tooltip: isArabic ? 'رجوع' : 'Back',
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          _GlassIconButton(
            icon: isGrid
                ? Icons.view_agenda_rounded
                : Icons.grid_view_rounded,
            tooltip: isGrid
                ? (isArabic ? 'عرض قائمة' : 'List view')
                : (isArabic ? 'عرض شبكة' : 'Grid view'),
            onTap: onToggleView,
          ),
          const SizedBox(width: 8),
          _GlassIconButton(
            icon: Icons.share_outlined,
            tooltip: isArabic ? 'مشاركة' : 'Share',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── HERO HEADER ──────────────────────────────────────────────

  Widget _buildHeroHeader(
    BuildContext context,
    String lang,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final title = isArabic
        ? 'الأذكار اليومية'
        : (isFrench ? 'Rappels Quotidiens' : 'Daily Remembrances');
    final subtitle = isArabic
        ? 'مجموعة من الأذكار والأدعية المأثورة من الكتاب والسنة، مرتّبة بحسب المناسبات اليومية مع عدّاد تفاعلي لمتابعة كل ذكر.'
        : (isFrench
            ? 'Une collection authentique d\'invocations du Coran et de la Sunna, organisée par thème, avec un compteur interactif.'
            : 'An authentic collection of remembrances from the Quran and Sunnah, organized by theme, with an interactive counter.');

    final catLabel =
        isArabic ? 'فئة' : (isFrench ? 'catégories' : 'categories');
    final zikrLabel =
        isArabic ? 'ذكر' : (isFrench ? 'rappels' : 'remembrances');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF1A5F3E).withValues(alpha: 0.78),
                    const Color(0xFF0E3824).withValues(alpha: 0.62),
                  ]
                : [
                    const Color(0xFFF7EFD3).withValues(alpha: 0.92),
                    const Color(0xFFEADAA0).withValues(alpha: 0.68),
                  ],
          ),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: _kGold.withValues(alpha: 0.55),
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: _kGold.withValues(alpha: 0.18),
              blurRadius: 22,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── BIG HERO LOGO ──
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [_kGold, Color(0xFFE6C200)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _kGold.withValues(alpha: 0.5),
                        blurRadius: 22,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF3A2E0E),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: themeService.getTextStyle(
                          fontSize: 12.5,
                          height: 1.55,
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.78)
                              : Colors.black.withValues(alpha: 0.68),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _StatPill(
                    icon: Icons.category_rounded,
                    value: '${_categories.length}',
                    label: catLabel,
                    themeService: themeService,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatPill(
                    icon: Icons.format_quote_rounded,
                    value: '$_totalAzkar',
                    label: zikrLabel,
                    themeService: themeService,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatPill(
                    icon: Icons.verified_rounded,
                    value: isArabic
                        ? 'موثّق'
                        : (isFrench ? 'Authentique' : 'Authentic'),
                    label: isArabic
                        ? 'المصادر'
                        : (isFrench ? 'Sources' : 'Sources'),
                    themeService: themeService,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── GRID ────────────────────────────────────────────────────

  Widget _buildGrid(
      BuildContext context, String lang, ThemeService themeService) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 200,
      ),
      itemBuilder: (context, index) {
        final cat = _categories[index];
        return TweenAnimationBuilder<double>(
          duration:
              Duration(milliseconds: 300 + (index * 55).clamp(0, 500)),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 26 * (1 - value)),
              child: child,
            ),
          ),
          child: _CategoryGlassCard(
            category: cat,
            lang: lang,
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 420),
                pageBuilder: (_, animation, __) =>
                    _AzkarDetailScreen(category: cat, lang: lang),
                transitionsBuilder: (_, animation, __, child) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  );
                  return FadeTransition(
                    opacity: curved,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(curved),
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ── LIST ────────────────────────────────────────────────────

  Widget _buildList(
      BuildContext context, String lang, ThemeService themeService) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        return TweenAnimationBuilder<double>(
          duration:
              Duration(milliseconds: 260 + (index * 45).clamp(0, 400)),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          ),
          child: _CategoryListRow(
            category: cat,
            lang: lang,
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 420),
                pageBuilder: (_, __, ___) =>
                    _AzkarDetailScreen(category: cat, lang: lang),
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// GRID CATEGORY CARD
// ═══════════════════════════════════════════════════════════════

class _CategoryGlassCard extends StatefulWidget {
  final _AzkarCategory category;
  final String lang;
  final VoidCallback onTap;

  const _CategoryGlassCard({
    required this.category,
    required this.lang,
    required this.onTap,
  });

  @override
  State<_CategoryGlassCard> createState() => _CategoryGlassCardState();
}

class _CategoryGlassCardState extends State<_CategoryGlassCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isArabic = widget.lang == 'ar';
    final isFrench = widget.lang == 'fr';
    final title = isArabic
        ? cat.titleAr
        : (isFrench ? cat.titleFr : cat.titleEn);
    final countLabel = isArabic
        ? '${cat.items.length} ذكر'
        : '${cat.items.length} remembrance${cat.items.length > 1 ? 's' : ''}';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _scale = 0.96),
            onTapUp: (_) => setState(() => _scale = 1.0),
            onTapCancel: () => setState(() => _scale = 1.0),
            onTap: widget.onTap,
            child: AnimatedScale(
              scale: _isHovered ? 1.035 : _scale,
              duration: const Duration(milliseconds: 160),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode
                            ? [
                                cat.color.withValues(alpha: 0.35),
                                const Color(0xFF0B3D2E)
                                    .withValues(alpha: 0.55),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.9),
                                cat.color.withValues(alpha: 0.08),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isHovered
                            ? _kGold.withValues(alpha: 0.85)
                            : _kGold.withValues(alpha: 0.32),
                        width: _isHovered ? 2 : 1.3,
                      ),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: _kGold.withValues(alpha: 0.25),
                                blurRadius: 18,
                                spreadRadius: 1,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // BIG EMOJI TILE
                            Container(
                              width: 56,
                              height: 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    cat.color.withValues(alpha: 0.85),
                                    cat.color.withValues(alpha: 0.55),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        cat.color.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                cat.emoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _kGold.withValues(alpha: 0.15),
                              ),
                              child: Icon(
                                isArabic
                                    ? Icons.arrow_back_rounded
                                    : Icons.arrow_forward_rounded,
                                size: 16,
                                color: _kGold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: themeService.getTextStyle(
                            fontSize: 16,
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF3A2E0E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _kGold.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _kGold.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            countLabel,
                            style: themeService.getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _kGold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// LIST CATEGORY ROW
// ═══════════════════════════════════════════════════════════════

class _CategoryListRow extends StatefulWidget {
  final _AzkarCategory category;
  final String lang;
  final VoidCallback onTap;

  const _CategoryListRow({
    required this.category,
    required this.lang,
    required this.onTap,
  });

  @override
  State<_CategoryListRow> createState() => _CategoryListRowState();
}

class _CategoryListRowState extends State<_CategoryListRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isArabic = widget.lang == 'ar';
    final isFrench = widget.lang == 'fr';
    final title = isArabic
        ? cat.titleAr
        : (isFrench ? cat.titleFr : cat.titleEn);

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [
                          cat.color.withValues(alpha: 0.3),
                          const Color(0xFF0B3D2E).withValues(alpha: 0.5),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.9),
                          cat.color.withValues(alpha: 0.06),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _hover
                      ? _kGold.withValues(alpha: 0.8)
                      : _kGold.withValues(alpha: 0.3),
                  width: _hover ? 2 : 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          cat.color.withValues(alpha: 0.85),
                          cat.color.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                    child: Text(cat.emoji,
                        style: const TextStyle(fontSize: 26)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign:
                              isArabic ? TextAlign.right : TextAlign.left,
                          style: themeService.getTextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF3A2E0E),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isArabic
                              ? '${cat.items.length} أذكار'
                              : '${cat.items.length} remembrance${cat.items.length > 1 ? 's' : ''}',
                          textAlign:
                              isArabic ? TextAlign.right : TextAlign.left,
                          style: themeService.getTextStyle(
                            fontSize: 12,
                            color: _kGold.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isArabic
                        ? Icons.arrow_back_ios_new_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: _kGold.withValues(alpha: 0.7),
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

// ═══════════════════════════════════════════════════════════════
// DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════

class _AzkarDetailScreen extends StatefulWidget {
  final _AzkarCategory category;
  final String lang;
  const _AzkarDetailScreen({required this.category, required this.lang});

  @override
  State<_AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<_AzkarDetailScreen>
    with SingleTickerProviderStateMixin {
  late List<int> _counts;
  bool _showTransliteration = true;
  late AnimationController _entranceCtrl;

  @override
  void initState() {
    super.initState();
    _counts = List.filled(widget.category.items.length, 0);
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _increment(int index) {
    final max = widget.category.items[index].count;
    if (_counts[index] >= max) return;
    HapticFeedback.lightImpact();
    setState(() => _counts[index]++);
  }

  void _reset(int index) => setState(() => _counts[index] = 0);
  void _resetAll() =>
      setState(() => _counts = List.filled(widget.category.items.length, 0));

  bool get _allDone => _counts.asMap().entries.every(
      (e) => e.value >= widget.category.items[e.key].count);

  int get _doneCount => _counts.asMap().entries
      .where((e) => e.value >= widget.category.items[e.key].count)
      .length;

  double get _progressValue => widget.category.items.isEmpty
      ? 0
      : _doneCount / widget.category.items.length;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final isArabic = widget.lang == 'ar';
    final isFrench = widget.lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final title = isArabic
        ? cat.titleAr
        : (isFrench ? cat.titleFr : cat.titleEn);

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(
                    context,
                    isArabic,
                    isFrench,
                    isDarkMode,
                    title,
                    cat.emoji,
                    themeService,
                  ),
                  _buildStickyProgress(
                    context,
                    isArabic,
                    isFrench,
                    isDarkMode,
                    themeService,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: FadeTransition(
                          opacity: _entranceCtrl,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.fromLTRB(20, 8, 20, 32),
                            itemCount: cat.items.length,
                            itemBuilder: (context, index) {
                              final zikr = cat.items[index];
                              final progress = _counts[index];
                              final isDone = progress >= zikr.count;

                              return TweenAnimationBuilder<double>(
                                duration: Duration(
                                    milliseconds:
                                        220 + (index * 60).clamp(0, 500)),
                                tween: Tween(begin: 0, end: 1),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) => Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - value) * 18),
                                    child: child,
                                  ),
                                ),
                                child: _ZikrGlassCard(
                                  zikr: zikr,
                                  index: index,
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
                      ),
                    ),
                  ),
                  _buildBottomBar(
                      context, isArabic, isFrench, isDarkMode, themeService),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    String title,
    String emoji,
    ThemeService themeService,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            tooltip: isArabic ? 'رجوع' : 'Back',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_kGold, Color(0xFFE6C200)],
              ),
              boxShadow: [
                BoxShadow(
                  color: _kGold.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: themeService.getTextStyle(
                color: _kGold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _GlassIconButton(
            icon: _showTransliteration
                ? Icons.translate_rounded
                : Icons.translate_outlined,
            tooltip: isArabic
                ? 'إظهار/إخفاء النقل الصوتي'
                : 'Toggle transliteration',
            onTap: () => setState(
                () => _showTransliteration = !_showTransliteration),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyProgress(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final doneLabel = isArabic
        ? 'منجز'
        : (isFrench ? 'Terminé' : 'Done');
    final completedLabel =
        isArabic ? '✓ اكتمل' : (isFrench ? '✓ Terminé' : '✓ Completed');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF144D32).withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _kGold.withValues(alpha: 0.35),
            width: 1.3,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_doneCount / ${widget.category.items.length} $doneLabel',
                  style: themeService.getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.85)
                        : Colors.black.withValues(alpha: 0.75),
                  ),
                ),
                if (_allDone)
                  Text(
                    completedLabel,
                    style: themeService.getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _kGold,
                    ),
                  )
                else
                  Text(
                    '${(_progressValue * 100).toStringAsFixed(0)}%',
                    style: themeService.getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _kGold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _progressValue,
                backgroundColor: isDarkMode
                    ? Colors.black.withValues(alpha: 0.35)
                    : Colors.black12,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(_kGold),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    ThemeService themeService,
  ) {
    final label = isArabic
        ? 'إعادة ضبط الكل'
        : (isFrench ? 'Tout réinitialiser' : 'Reset all');

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 8, 16, 8 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.85),
        border: Border(
          top: BorderSide(color: _kGold.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: _resetAll,
            icon: Icon(
              Icons.refresh_rounded,
              color: isDarkMode ? Colors.white60 : Colors.black54,
              size: 18,
            ),
            label: Text(
              label,
              style: themeService.getTextStyle(
                color: isDarkMode ? Colors.white60 : Colors.black54,
                fontSize: 14.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ZIKR CARD
// ═══════════════════════════════════════════════════════════════

class _ZikrGlassCard extends StatefulWidget {
  final _ZikrItem zikr;
  final int index;
  final int progress;
  final bool isDone;
  final bool showTransliteration;
  final String lang;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const _ZikrGlassCard({
    required this.zikr,
    required this.index,
    required this.progress,
    required this.isDone,
    required this.showTransliteration,
    required this.lang,
    required this.onTap,
    required this.onReset,
  });

  @override
  State<_ZikrGlassCard> createState() => _ZikrGlassCardState();
}

class _ZikrGlassCardState extends State<_ZikrGlassCard> {
  bool _isSharing = false;
  bool _isHovered = false;
  double _scale = 1.0;

  Future<void> _shareAsImage() async {
    setState(() => _isSharing = true);
    try {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      final translationText = widget.lang == 'fr'
          ? widget.zikr.translationFr
          : widget.zikr.translation;

      await ShareImageGenerator.generateAndShareImageWithWidget(
        title: widget.zikr.arabic,
        subtitle: translationText,
        isDarkMode: isDarkMode,
        lang: widget.lang,
        context: context,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              widget.lang == 'ar' ? 'تم إنشاء الصورة' : 'Image created'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFF0B3D2E),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.lang == 'ar' ? 'خطأ: $e' : 'Error: $e'),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.zikr.arabic));
    if (!mounted) return;
    final isArabic = widget.lang == 'ar';
    final isFrench = widget.lang == 'fr';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isArabic
                    ? 'تم النسخ إلى الحافظة'
                    : (isFrench ? 'Copié' : 'Copied to clipboard'),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF0B3D2E),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isArabic = widget.lang == 'ar';
    final isFrench = widget.lang == 'fr';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _scale = 0.985),
            onTapUp: (_) => setState(() => _scale = 1.0),
            onTapCancel: () => setState(() => _scale = 1.0),
            onTap: widget.onTap,
            child: AnimatedScale(
              scale: _isHovered ? 1.008 : _scale,
              duration: const Duration(milliseconds: 140),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: widget.isDone
                            ? LinearGradient(
                                colors: isDarkMode
                                    ? [
                                        const Color(0xFF1B5E3F)
                                            .withValues(alpha: 0.88),
                                        const Color(0xFF0F3D28)
                                            .withValues(alpha: 0.85),
                                      ]
                                    : [
                                        const Color(0xFFE8F5E9),
                                        const Color(0xFFD4EED8),
                                      ],
                              )
                            : null,
                        color: widget.isDone
                            ? null
                            : (isDarkMode
                                ? Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withValues(alpha: 0.68)
                                : Colors.white.withValues(alpha: 0.82)),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: widget.isDone
                              ? _kGold
                              : _kGold.withValues(alpha: 0.32),
                          width: widget.isDone ? 2 : 1.2,
                        ),
                        boxShadow: widget.isDone
                            ? [
                                BoxShadow(
                                  color: _kGold.withValues(alpha: 0.2),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header: number + counter
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: widget.isDone
                                        ? [_kGold, const Color(0xFFE6C200)]
                                        : [
                                            _kGold.withValues(alpha: 0.65),
                                            const Color(0xFFE6C200)
                                                .withValues(alpha: 0.45),
                                          ],
                                  ),
                                ),
                                child: Text(
                                  '${widget.index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: widget.isDone
                                      ? _kGold
                                      : _kGold.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: _kGold.withValues(
                                        alpha: widget.isDone ? 1 : 0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${widget.progress} / ${widget.zikr.count}',
                                      style: themeService.getTextStyle(
                                        color: widget.isDone
                                            ? Colors.white
                                            : _kGold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      widget.isDone
                                          ? Icons.check_circle_rounded
                                          : Icons.touch_app_rounded,
                                      size: 15,
                                      color: widget.isDone
                                          ? Colors.white
                                          : _kGold.withValues(alpha: 0.8),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Arabic
                          Text(
                            widget.zikr.arabic,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: themeService.getTextStyle(
                              color: widget.isDone
                                  ? (isDarkMode
                                      ? _kGold
                                      : const Color(0xFF1B5E3F))
                                  : (isDarkMode
                                      ? Colors.white
                                      : Colors.black87),
                              fontSize: 22,
                              height: 2.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Transliteration
                          if (widget.showTransliteration) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _kGold.withValues(
                                    alpha: isDarkMode ? 0.08 : 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                widget.zikr.transliteration,
                                style: themeService.getTextStyle(
                                  color: isDarkMode
                                      ? _kGold.withValues(alpha: 0.85)
                                      : const Color(0xFFB8860B),
                                  fontSize: 13.5,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 12),

                          // Translation
                          Text(
                            isFrench
                                ? widget.zikr.translationFr
                                : widget.zikr.translation,
                            style: themeService.getTextStyle(
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.7)
                                  : Colors.black.withValues(alpha: 0.65),
                              fontSize: 14.5,
                              height: 1.55,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Action row
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: isArabic
                                ? WrapAlignment.end
                                : WrapAlignment.start,
                            children: [
                              _PillButton(
                                icon: Icons.copy_rounded,
                                label: isArabic
                                    ? 'نسخ'
                                    : (isFrench ? 'Copier' : 'Copy'),
                                onTap: _copy,
                                isDarkMode: isDarkMode,
                              ),
                              _PillButton(
                                icon: Icons.share_rounded,
                                label: isArabic
                                    ? 'مشاركة'
                                    : (isFrench ? 'Partager' : 'Share'),
                                onTap: _isSharing ? null : _shareAsImage,
                                isDarkMode: isDarkMode,
                                primary: true,
                                loading: _isSharing,
                              ),
                              if (widget.progress > 0)
                                _PillButton(
                                  icon: Icons.refresh_rounded,
                                  label: isArabic
                                      ? 'إعادة'
                                      : (isFrench ? 'Réinit.' : 'Reset'),
                                  onTap: widget.onReset,
                                  isDarkMode: isDarkMode,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

class _GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final button = MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _hover
                ? _kGold.withValues(alpha: 0.2)
                : (isDark
                    ? const Color(0xFF144D32).withValues(alpha: 0.55)
                    : Colors.white.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _kGold.withValues(alpha: _hover ? 0.6 : 0.3),
            ),
          ),
          child: Icon(widget.icon, color: _kGold, size: 20),
        ),
      ),
    );
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: _kGold.withValues(alpha: isDarkMode ? 0.15 : 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kGold.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Icon(icon, color: _kGold, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: themeService.getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF3A2E0E),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: themeService.getTextStyle(
              fontSize: 10,
              letterSpacing: 0.3,
              color: _kGold.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDarkMode;
  final bool primary;
  final bool loading;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDarkMode,
    this.primary = false,
    this.loading = false,
  });

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.primary
        ? (_hover ? const Color(0xFFE6C200) : _kGold)
        : (_hover
            ? _kGold.withValues(alpha: 0.18)
            : _kGold.withValues(alpha: 0.08));
    final fg = widget.primary ? Colors.white : _kGold;
    final enabled = widget.onTap != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: enabled ? bg : bg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.primary
                  ? Colors.transparent
                  : _kGold.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.loading)
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(fg),
                  ),
                )
              else
                Icon(widget.icon, size: 14, color: fg),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}