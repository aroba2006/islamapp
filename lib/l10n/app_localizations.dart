import 'package:flutter/material.dart';
import 'ar_ar.dart';
import 'en_us.dart';
import 'fr_fr.dart';

abstract class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        EnUS();
  }

  String get appTitle;
  String get selectCountry;
  String get selectRegion;
  String get searchCountries;
  String get noCountriesFound;
  String get chooseYourState;
  String get timeUntil;
  String get fetchingPrayerTimes;
  String get prayerTimes;
  String get settings;
  String get language;
  String get adhan;
  String get selectAdhanReciter;
  String get adhanNotifications;
  String get playAdhan;
  String get tryAgain;
  String get refresh;
  String get back;
  String get next;
  String get sunrise;
  String get errorMessage;
  String get arabic;
  String get english;
  String get french;
  String get misharyAfasi;
  String get nasserQattami;
  String get aliMala;
  String get abdelbassetAbdelsamad;
  String get saoudShubayt;
  String get save;
  String get close;
  String get prayerNotification;
  String get mohamedQassas;
  String get moRefaat;
  String get nasTobar;
  String get quran;
  String get quranSection;
  String get selectSurah;
  String get stop;
  String get errorLoadingPrayerTimes;
  String get retry;
  
  // The 5 prayer getters
  String get fajr;
  String get dhuhr;
  String get asr;
  String get maghrib;
  String get isha;

  // === NEW ADDITIONS TO FIX OVERRIDE WARNINGS ===
  String get azkarTitle;
  String get quranTitle;
  String get titleAr;
  String get prayerTimesDesc;
  String get azkarDesc;
  String get quranDesc;
  String get duaaTitle;
  String get duaaDesc;

  // === ADD THESE 4 NEW GETTERS FOR YOUR NEW SCREENS ===
  String get goodDeedsTitle;
  String get goodDeedsDesc;
  String get islamicGoalsTitle;
  String get islamicGoalsDesc;

  // === SCREENS TRANSLATIONS ===
  String get cancelBtn;
  String get recordDeedTitle;
  String get deedTitleLabel;
  String get deedTitleHint;
  String get categoryLabel;
  String get notesLabel;
  String get notesHint;
  String get recordBtn;
  String get streakLabel;
  String get todayLabel;
  String get totalLabel;
  String get allFilter;
  String get noDeedsTitle;
  String get noDeedsDesc;
  String get catPrayer;
  String get catCharity;
  String get catLearning;
  String get catFamily;
  String get catOther;
  
  String get addGoalTitle;
  String get goalTypeLabel;
  String get goalTypeQuran;
  String get goalTypeSurah;
  String get goalTypePrayer;
  String get goalTitleLabel;
  String get goalTitleHint;
  String get surahNumberLabel;
  String get numberOfDaysLabel;
  String get createGoalBtn;
  String get noGoalsTitle;
  String get noGoalsDesc;
  String get activeGoals;
  String get completedGoals;
  String get updateProgressBtn;
  String get deleteBtn;
  String get deleteGoalTitle;
  String get deleteGoalDesc;
  String get updateDialogTitle;
  String get progressLabel;
  String get updateBtn;

  String get qiblahFinderTitle;
  String get qiblahFinderDesc;

  String get nearestMosqueTitle;
  String get nearestMosqueDesc;

  // === QUICK ACCESS NAMES (for home screen cards) ===
  String get qiblaTitle;
  String get qiblaDesc;
  String get goalsTitle;
  String get goalsDesc;
  String get quizTitle;
  String get quizDesc;
  String get prophetBioTitle;
  String get prophetBioDesc;

  // === BOOKMARK TRANSLATIONS ===
  String get bookmarkPage;
  String get goToBookmark;
  String get pageBookmarked;

  // === RAMADAN TRANSLATIONS ===
  String get ramadan;
  String get ramadanActiveDesc;
  String get ramadanInactiveDesc;
  String get ramadanNotAvailable;

  // === HIJRI CALENDAR ===
  String get hijriCalendarTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ar':
        return ArAR();
      case 'en':
        return EnUS();
      case 'fr':
        return FrFR();
      default:
        return EnUS();
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}