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

  // Basic app strings
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
  String get notifications;
  String get enableNotifications;
  
  // The 5 prayers
  String get fajr;
  String get dhuhr;
  String get asr;
  String get maghrib;
  String get isha;

  // Screen titles and descriptions
  String get azkarTitle;
  String get quranTitle;
  String get titleAr;
  String get prayerTimesDesc;
  String get azkarDesc;
  String get quranDesc;
  String get duaaTitle;
  String get duaaDesc;

  // Good Deeds & Islamic Goals
  String get goodDeedsTitle;
  String get goodDeedsDesc;
  String get islamicGoalsTitle;
  String get islamicGoalsDesc;

  // Quick access cards
  String get qiblaTitle;
  String get qiblaDesc;
  String get goalsTitle;
  String get goalsDesc;
  String get quizTitle;
  String get quizDesc;
  String get prophetBioTitle;
  String get prophetBioDesc;
  String get hadithsTitle;
  String get hadithsDesc;

  // Feature screens
  String get qiblahFinderTitle;
  String get qiblahFinderDesc;
  String get nearestMosqueTitle;
  String get nearestMosqueDesc;

  // Good Deeds screen
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
  
  // Islamic Goals screen
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

  // Authentication
  String get login;
  String get signup;
  String get email;
  String get username;
  String get emailOrUsername;
  String get password;
  String get confirmPassword;
  String get selectBirthday;
  String get genderMale;
  String get genderFemale;
  String get fillAllFields;
  String get loginFailed;
  String get signupFailed;

  // Bookmarks
  String get bookmarkPage;
  String get goToBookmark;
  String get pageBookmarked;

  // Ramadan
  String get ramadan;
  String get ramadanActiveDesc;
  String get ramadanInactiveDesc;
  String get ramadanNotAvailable;

  // Hijri Calendar
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