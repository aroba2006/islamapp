import 'app_localizations.dart';

class FrFR extends AppLocalizations {
  @override
  String get appTitle => 'Horaires de Prière';
  @override
  String get selectCountry => 'Sélectionnez votre pays';
  @override
  String get selectRegion => 'Sélectionnez votre région';
  @override
  String get searchCountries => 'Rechercher des pays...';
  @override
  String get noCountriesFound => 'Aucun pays ne correspond à votre recherche.';
  @override
  String get chooseYourState => 'Choisissez votre état / province';
  @override
  String get timeUntil => 'Temps restant avant'; // More natural than "Temps jusqu'à"
  @override
  String get fetchingPrayerTimes => 'Récupération des horaires de prière...';
  @override
  String get prayerTimes => 'Horaires de Prière';
  @override
  String get azkarTitle => 'Adhkar'; // Fixed from "Supplications - Duaa"
  @override
  String get quranTitle => 'Le Saint Coran';
  @override
  String get titleAr => 'Invocations - Douâa'; 
  @override
  String get settings => 'Paramètres';
  @override
  String get language => 'Langue';
  @override
  String get adhan => 'Adhan'; // Standard term instead of "Appel à la prière"
  @override
  String get selectAdhanReciter => 'Sélectionner le Muezzin'; // "Muezzin" is more accurate here
  @override
  String get adhanNotifications => 'Notifications de l\'Adhan';
  @override
  String get playAdhan => 'Écouter l\'Adhan';
  @override
  String get tryAgain => 'Réessayer';
  @override
  String get refresh => 'Actualiser';
  @override
  String get back => 'Retour';
  @override
  String get next => 'Suivant';
  @override
  String get sunrise => 'Chourouk'; // "Chourouk" matches Fajr, Dhohr, etc.
  @override
  String get errorMessage => 'Une erreur s\'est produite.';
  @override
  String get arabic => 'العربية';
  @override
  String get english => 'English';
  @override
  String get french => 'Français';
  @override
  String get misharyAfasi => 'Mishary Al-Afasi';
  @override
  String get nasserQattami => 'Nasser Al-Qattami';
  @override
  String get mohamedQassas => 'Mohamed Marawan Qassas';
  @override
  String get aliMala => 'Ali Al-Mala';
  @override
  String get abdelbassetAbdelsamad => 'Abdulbasit Abdulsamad';
  @override
  String get saoudShubayt => 'Saud Al-Shubait';
  @override
  String get save => 'Enregistrer';
  @override
  String get close => 'Fermer';
  @override
  String get prayerNotification => 'C\'est l\'heure de la prière'; // Much more natural phrasing

  @override
  String get quran => 'Le Saint Coran';
  @override
  String get quranSection => 'Section Coran';
  @override
  String get selectSurah => 'Sélectionnez une sourate';
  
  @override
  String get stop => 'Arrêter';
  @override
  String get errorLoadingPrayerTimes => 'Erreur lors du chargement des horaires de prière. Veuillez réessayer.';
  @override
  String get retry => 'Réessayer';
  
  @override
  String get fajr => 'Fajr';
  @override
  String get dhuhr => 'Dhohr';
  @override
  String get asr => 'Asr';
  @override
  String get maghrib => 'Maghrib';
  @override
  String get isha => 'Icha';

  @override
  String get prayerTimesDesc => 'Horaires de prière précis pour votre pays et région.'; // "Horaires" is masculine, so "précis"
  @override
  String get azkarDesc => 'Invocations du matin, du soir, de la prière et du sommeil.';
  @override
  String get quranDesc => 'Lisez le Saint Coran avec une navigation facile entre les sourates.';
  @override
  String get duaaTitle => 'Douâa';
  @override
  String get duaaDesc => 'Invocations choisies pour la guérison, la réussite et la protection.'; // "Réussite" is more accurate for Islamic context than "succès"
}