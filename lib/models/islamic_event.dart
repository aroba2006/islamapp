import '../services/hijri_calendar_service.dart';

enum IslamicEventType {
  eidAlFitr,
  eidAlAdha,
  islamicNewYear,
  ashuraDay,
  milladNabi,
  arafatDay,
  ramadanStart,
  ramadanEnd,
  nightOfPower,
}

class IslamicEvent {
  final IslamicEventType type;
  final int hijriMonth;
  final int hijriDay;
  final String nameEn;
  final String nameAr;
  final String nameFr; // Added French name
  final String descriptionEn;
  final String descriptionAr;
  final String descriptionFr; // Added French description
  final bool isHoliday;

  IslamicEvent({
    required this.type,
    required this.hijriMonth,
    required this.hijriDay,
    required this.nameEn,
    required this.nameAr,
    required this.nameFr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.descriptionFr,
    required this.isHoliday,
  });

  int daysUntil() {
    return HijriCalendarService.getNextHijriDate(hijriMonth, hijriDay)
        .difference(DateTime.now())
        .inDays;
  }

  bool isToday() {
    final nextDate = HijriCalendarService.getNextHijriDate(hijriMonth, hijriDay);
    final now = DateTime.now();
    return nextDate.year == now.year &&
        nextDate.month == now.month &&
        nextDate.day == now.day;
  }

  String getName(String languageCode) {
    if (languageCode == 'ar') return nameAr;
    if (languageCode == 'fr') return nameFr;
    return nameEn;
  }

  String getDescription(String languageCode) {
    if (languageCode == 'ar') return descriptionAr;
    if (languageCode == 'fr') return descriptionFr;
    return descriptionEn;
  }
}

class IslamicEventsService {
  static final List<IslamicEvent> allEvents = [
    IslamicEvent(
      type: IslamicEventType.ramadanStart,
      hijriMonth: 9,
      hijriDay: 1,
      nameEn: 'Ramadan Begins',
      nameAr: 'بداية شهر رمضان',
      nameFr: 'Début du Ramadan',
      descriptionEn: 'The beginning of the blessed month of fasting and worship',
      descriptionAr: 'بداية شهر الصيام والتقوى والعبادة المباركة',
      descriptionFr: 'Le début du mois béni de jeûne et de culte',
      isHoliday: true,
    ),
    IslamicEvent(
      type: IslamicEventType.nightOfPower,
      hijriMonth: 9,
      hijriDay: 27,
      nameEn: 'Laylat al-Qadr (Night of Power)',
      nameAr: 'ليلة القدر',
      nameFr: 'Laylat al-Qadr (Nuit du Destin)',
      descriptionEn: 'The night when the Quran was first revealed - better than 1000 months',
      descriptionAr: 'الليلة التي أنزل فيها القرآن - وهي خير من ألف شهر',
      descriptionFr: 'La nuit où le Coran a été révélé pour la première fois - meilleure que 1000 mois',
      isHoliday: false,
    ),
    IslamicEvent(
      type: IslamicEventType.ramadanEnd,
      hijriMonth: 9,
      hijriDay: 30,
      nameEn: 'Last Day of Ramadan',
      nameAr: 'آخر يوم في رمضان',
      nameFr: 'Dernier jour du Ramadan',
      descriptionEn: 'The final day of the blessed month of Ramadan',
      descriptionAr: 'اليوم الأخير من شهر رمضان المبارك',
      descriptionFr: 'Le dernier jour du mois béni du Ramadan',
      isHoliday: false,
    ),
    IslamicEvent(
      type: IslamicEventType.eidAlFitr,
      hijriMonth: 10,
      hijriDay: 1,
      nameEn: 'Eid al-Fitr (Day 1)',
      nameAr: 'عيد الفطر - اليوم الأول',
      nameFr: 'Aïd el-Fitr (Jour 1)',
      descriptionEn: 'Celebration marking the end of Ramadan fasting',
      descriptionAr: 'عيد المسلمين الأول، يحتفل به المسلمون بنهاية شهر الصيام',
      descriptionFr: 'Célébration marquant la fin du jeûne du Ramadan',
      isHoliday: true,
    ),
    IslamicEvent(
      type: IslamicEventType.eidAlFitr,
      hijriMonth: 10,
      hijriDay: 2,
      nameEn: 'Eid al-Fitr (Day 2)',
      nameAr: 'عيد الفطر - اليوم الثاني',
      nameFr: 'Aïd el-Fitr (Jour 2)',
      descriptionEn: 'Second day of Eid al-Fitr celebration',
      descriptionAr: 'اليوم الثاني من عيد الفطر المبارك',
      descriptionFr: 'Deuxième jour de la célébration de l\'Aïd el-Fitr',
      isHoliday: true,
    ),
    IslamicEvent(
      type: IslamicEventType.eidAlFitr,
      hijriMonth: 10,
      hijriDay: 3,
      nameEn: 'Eid al-Fitr (Day 3)',
      nameAr: 'عيد الفطر - اليوم الثالث',
      nameFr: 'Aïd el-Fitr (Jour 3)',
      descriptionEn: 'Third day of Eid al-Fitr celebration',
      descriptionAr: 'اليوم الثالث من عيد الفطر المبارك',
      descriptionFr: 'Troisième jour de la célébration de l\'Aïd el-Fitr',
      isHoliday: true,
    ),
    IslamicEvent(
      type: IslamicEventType.arafatDay,
      hijriMonth: 12,
      hijriDay: 9,
      nameEn: 'Day of Arafat',
      nameAr: 'يوم عرفة',
      nameFr: 'Jour d\'Arafat',
      descriptionEn: 'The holiest day of Hajj when pilgrims gather at Mount Arafat',
      descriptionAr: 'يوم وقفة عرفة - أعظم أيام الحج',
      descriptionFr: 'Le jour le plus saint du Hajj où les pèlerins se rassemblent au mont Arafat',
      isHoliday: false,
    ),
    IslamicEvent(
      type: IslamicEventType.eidAlAdha,
      hijriMonth: 12,
      hijriDay: 10,
      nameEn: 'Eid al-Adha (Festival of Sacrifice)',
      nameAr: 'عيد الأضحى',
      nameFr: 'Aïd al-Adha (Fête du Sacrifice)',
      descriptionEn: 'Major Islamic celebration commemorating Prophet Ibrahim\'s willingness to sacrifice',
      descriptionAr: 'عيد المسلمين الأكبر، يحتفل به بذكرى استعداد إبراهيم للتضحية',
      descriptionFr: 'Grande fête islamique commémorant la volonté d\'Abraham de sacrifier',
      isHoliday: true,
    ),
    IslamicEvent(
      type: IslamicEventType.islamicNewYear,
      hijriMonth: 1,
      hijriDay: 1,
      nameEn: 'Islamic New Year',
      nameAr: 'رأس السنة الهجرية',
      nameFr: 'Nouvel An Islamique',
      descriptionEn: 'The beginning of the Islamic calendar year',
      descriptionAr: 'بداية السنة الهجرية الإسلامية',
      descriptionFr: 'Le début de l\'année du calendrier islamique',
      isHoliday: false,
    ),
    IslamicEvent(
      type: IslamicEventType.ashuraDay,
      hijriMonth: 1,
      hijriDay: 10,
      nameEn: 'Day of Ashura',
      nameAr: 'يوم عاشوراء',
      nameFr: 'Jour d\'Achoura',
      descriptionEn: 'Day of historical and spiritual significance in Islam',
      descriptionAr: 'يوم له أهمية روحية وتاريخية في الإسلام',
      descriptionFr: 'Jour d\'importance historique et spirituelle dans l\'Islam',
      isHoliday: false,
    ),
    IslamicEvent(
      type: IslamicEventType.milladNabi,
      hijriMonth: 3,
      hijriDay: 12,
      nameEn: 'Mawlid al-Nabi (Prophet Muhammad\'s Birthday)',
      nameAr: 'مولد النبي محمد صلى الله عليه وسلم',
      nameFr: 'Mawlid (Naissance du Prophète)',
      descriptionEn: 'Commemoration of the birth of Prophet Muhammad',
      descriptionAr: 'ذكرى ميلاد النبي محمد صلى الله عليه وسلم',
      descriptionFr: 'Commémoration de la naissance du Prophète Mahomet',
      isHoliday: false,
    ),
  ];

  static List<IslamicEvent> getEventsOnDate(int month, int day) {
    return allEvents.where((event) {
      return event.hijriMonth == month && event.hijriDay == day;
    }).toList();
  }

  static IslamicEvent? getNearestEvent() {
    IslamicEvent? nearest;
    int? minDays;
    for (final event in allEvents) {
      final days = event.daysUntil();
      if (minDays == null || days < minDays) {
        minDays = days;
        nearest = event;
      }
    }
    return nearest;
  }

  static List<IslamicEvent> getUpcomingEvents(int daysAhead) {
    return allEvents
        .where((event) => event.daysUntil() <= daysAhead)
        .toList()
      ..sort((a, b) => a.daysUntil().compareTo(b.daysUntil()));
  }

  static List<IslamicEvent> getEventsThisMonth() {
    final now = HijriCalendarService.gregorianToHijri(DateTime.now());
    return allEvents
        .where((event) => event.hijriMonth == now.month)
        .toList();
  }

  static bool hasEventSoon() {
    return getUpcomingEvents(7).isNotEmpty;
  }
}