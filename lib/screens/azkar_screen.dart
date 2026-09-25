import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../l10n/app_localizations.dart'; 
import '../utils/share_image_generator.dart';
import '../services/theme_service.dart';

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
];

// ── SCREENS ─────────────────────────────────────────────────────

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
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final l10n = AppLocalizations.of(context);
        final lang = Localizations.localeOf(context).languageCode;

        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            l10n.azkarTitle, 
                            textAlign: TextAlign.center,
                            style: themeService.getTextStyle(
                              color: const Color(0xFFD4AF37),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: FadeTransition(
                          opacity: _fadeCtrl,
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                            itemCount: _categories.length,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              crossAxisSpacing: 16, 
                              mainAxisSpacing: 16,
                              mainAxisExtent: 160,
                            ),
                            itemBuilder: (context, index) {
                              final cat = _categories[index];
                              return TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 250 + (index * 80).clamp(0, 400)),
                                tween: Tween(begin: 0, end: 1),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) => Opacity(
                                  opacity: value,
                                  child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
                                ),
                                child: _CategoryGlassCard(
                                  category: cat,
                                  lang: lang,
                                  onTap: () => Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 400),
                                      pageBuilder: (_, animation, __) => _AzkarDetailScreen(category: cat, lang: lang),
                                      transitionsBuilder: (_, animation, __, child) {
                                        return FadeTransition(opacity: animation, child: child);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
}

class _CategoryGlassCard extends StatefulWidget {
  final _AzkarCategory category;
  final String lang;
  final VoidCallback onTap;
  
  const _CategoryGlassCard({required this.category, required this.lang, required this.onTap});

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
              scale: _isHovered ? 1.04 : _scale,
              duration: const Duration(milliseconds: 150),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: _isHovered 
                          ? (isDarkMode 
                              ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.8) 
                              : Colors.white.withValues(alpha: 0.9))
                          : (isDarkMode 
                              ? Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6) 
                              : Colors.white.withValues(alpha: 0.65)),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isHovered 
                            ? const Color(0xFFD4AF37).withValues(alpha: 0.8)
                            : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                        width: _isHovered ? 2 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat.emoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            widget.lang == 'ar' ? cat.titleAr : (widget.lang == 'fr' ? cat.titleFr : cat.titleEn),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: themeService.getTextStyle(
                              color: _isHovered 
                                  ? (isDarkMode ? Colors.white : const Color(0xFFD4AF37)) 
                                  : const Color(0xFFD4AF37),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${cat.items.length} ${widget.lang == 'ar' ? 'أذكار' : '...' }',
                            style: themeService.getTextStyle(
                              color: const Color(0xFFD4AF37),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
    final isArabic = widget.lang == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 20, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                              Text(
                                isArabic ? cat.titleAr : (widget.lang == 'fr' ? cat.titleFr : cat.titleEn),
                                style: themeService.getTextStyle(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.black.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _showTransliteration ? Icons.translate : Icons.translate_outlined,
                              color: _showTransliteration ? const Color(0xFFD4AF37) : (isDarkMode ? Colors.white54 : Colors.black54),
                              size: 22,
                            ),
                            onPressed: () => setState(() => _showTransliteration = !_showTransliteration),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_counts.where((c) => c > 0).length} / ${cat.items.length}',
                              style: themeService.getTextStyle(
                                color: isDarkMode ? Colors.white.withValues(alpha: 0.7) : Colors.black87, 
                                fontSize: 14,
                              ),
                            ),
                            if (_allDone)
                              Text(
                                isArabic ? '✓ اكتمل' : (widget.lang == 'fr' ? '✓ Terminé' : '✓ Done'),
                                style: themeService.getTextStyle(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: cat.items.isEmpty ? 0 : _counts.asMap().entries.where((e) => e.value >= cat.items[e.key].count).length / cat.items.length,
                            backgroundColor: isDarkMode ? Colors.black.withValues(alpha: 0.4) : Colors.black12,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
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
                              child: _ZikrGlassCard(
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
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: TextButton.icon(
                      onPressed: _resetAll,
                      icon: Icon(Icons.refresh_rounded, color: isDarkMode ? Colors.white54 : Colors.black54, size: 20),
                      label: Text(
                        isArabic ? 'إعادة ضبط الكل' : (widget.lang == 'fr' ? 'Tout réinitialiser' : 'Reset All'),
                        style: themeService.getTextStyle(
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                          fontSize: 16,
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
}

// ── FROSTED GLASS ZIKR CARD (THEME AWARE) ──────────────────
class _ZikrGlassCard extends StatefulWidget {
  final _ZikrItem zikr;
  final int progress;
  final bool isDone;
  final bool showTransliteration;
  final String lang;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const _ZikrGlassCard({
    required this.zikr,
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
      
      String translationText;
      if (widget.lang == 'fr') {
        translationText = widget.zikr.translationFr;
      } else {
        translationText = widget.zikr.translation;
      }

      await ShareImageGenerator.generateAndShareImageWithWidget(
        title: widget.zikr.arabic,
        subtitle: translationText,
        isDarkMode: isDarkMode,
        lang: widget.lang,
        context: context,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.lang == 'ar' ? 'تم إنشاء الصورة' : 'Image created'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.lang == 'ar' ? 'خطأ: $e' : 'Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _scale = 0.98),
            onTapUp: (_) => setState(() => _scale = 1.0),
            onTapCancel: () => setState(() => _scale = 1.0),
            onTap: widget.onTap,
            child: AnimatedScale(
              scale: _isHovered ? 1.02 : _scale,
              duration: const Duration(milliseconds: 150),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: widget.isDone 
                            ? (isDarkMode ? const Color(0xFF1B5E3F).withValues(alpha: 0.85) : const Color(0xFFE8F5E9).withValues(alpha: 0.9))
                            : (isDarkMode ? Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.65) : Colors.white.withValues(alpha: 0.75)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.isDone 
                              ? const Color(0xFFD4AF37).withValues(alpha: 0.8)
                              : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                          width: widget.isDone ? 2 : 1,
                        ),
                        boxShadow: widget.isDone
                            ? [BoxShadow(color: const Color(0xFFD4AF37).withValues(alpha: 0.15), blurRadius: 12, spreadRadius: 2)]
                            : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.zikr.arabic,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: themeService.getTextStyle(
                              color: widget.isDone 
                                  ? (isDarkMode ? const Color(0xFFD4AF37) : const Color(0xFF1B5E3F)) 
                                  : (isDarkMode ? Colors.white : Colors.black87),
                              fontSize: 24,
                              height: 2.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.showTransliteration) ...[
                            const SizedBox(height: 12),
                            Text(
                              widget.zikr.transliteration,
                              style: themeService.getTextStyle(
                                color: isDarkMode ? const Color(0xFFD4AF37).withValues(alpha: 0.8) : const Color(0xFFB8860B),
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Text(
                            widget.lang == 'fr' ? widget.zikr.translationFr : widget.zikr.translation,
                            style: themeService.getTextStyle(
                              color: isDarkMode ? Colors.white.withValues(alpha: 0.65) : Colors.black54,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: widget.progress > 0 ? widget.onReset : null,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.refresh_rounded,
                                          size: 18,
                                          color: widget.progress > 0 
                                              ? (isDarkMode ? Colors.white54 : Colors.black45) 
                                              : Colors.transparent,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          widget.lang == 'ar' ? 'إعادة' : (widget.lang == 'fr' ? 'Réinit.' : 'Reset'),
                                          style: themeService.getTextStyle(
                                            color: widget.progress > 0 
                                                ? (isDarkMode ? Colors.white54 : Colors.black45) 
                                                : Colors.transparent,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: _shareAsImage,
                                    child: Row(
                                      children: [
                                        Icon(Icons.share_rounded, size: 18, color: isDarkMode ? Colors.white54 : Colors.black45),
                                        const SizedBox(width: 6),
                                        Text(
                                          widget.lang == 'ar' ? 'مشاركة' : (widget.lang == 'fr' ? 'Partager' : 'Share'),
                                          style: themeService.getTextStyle(
                                            color: isDarkMode ? Colors.white54 : Colors.black45,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: widget.isDone 
                                      ? const Color(0xFFD4AF37) 
                                      : (isDarkMode ? Colors.black.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.5)),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: widget.isDone 
                                        ? const Color(0xFFD4AF37) 
                                        : const Color(0xFFD4AF37).withValues(alpha: 0.5)
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${widget.progress} / ${widget.zikr.count}',
                                      style: themeService.getTextStyle(
                                        color: widget.isDone 
                                            ? (isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white) 
                                            : const Color(0xFFD4AF37),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      widget.isDone ? Icons.check_circle_rounded : Icons.touch_app_rounded,
                                      size: 18,
                                      color: widget.isDone 
                                          ? (isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white) 
                                          : const Color(0xFFD4AF37).withValues(alpha: 0.8),
                                    ),
                                  ],
                                ),
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