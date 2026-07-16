import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Dontach'**
  String get appTitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @onLabel.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get onLabel;

  /// No description provided for @offLabel.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get offLabel;

  /// No description provided for @protectionActive.
  ///
  /// In en, this message translates to:
  /// **'Protection active'**
  String get protectionActive;

  /// No description provided for @protectionInactive.
  ///
  /// In en, this message translates to:
  /// **'Protection inactive'**
  String get protectionInactive;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @calibrating.
  ///
  /// In en, this message translates to:
  /// **'Calibrating...'**
  String get calibrating;

  /// No description provided for @schedulePending.
  ///
  /// In en, this message translates to:
  /// **'Schedule pending'**
  String get schedulePending;

  /// No description provided for @enterCodeToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Enter your Dontach code to access the phone.'**
  String get enterCodeToUnlock;

  /// No description provided for @placePhoneFlat.
  ///
  /// In en, this message translates to:
  /// **'Place the phone flat.\nThe alarm triggers if it is lifted.'**
  String get placePhoneFlat;

  /// No description provided for @scheduleAutoActivate.
  ///
  /// In en, this message translates to:
  /// **'Protection will activate automatically\n{timeRange} · {days}'**
  String scheduleAutoActivate(String timeRange, String days);

  /// No description provided for @activateOrSchedule.
  ///
  /// In en, this message translates to:
  /// **'Activate protection or schedule it below.'**
  String get activateOrSchedule;

  /// No description provided for @enterYourCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your code'**
  String get enterYourCode;

  /// No description provided for @incorrectCode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code'**
  String get incorrectCode;

  /// No description provided for @dontachCode.
  ///
  /// In en, this message translates to:
  /// **'Dontach code'**
  String get dontachCode;

  /// No description provided for @confirmCode.
  ///
  /// In en, this message translates to:
  /// **'Confirm code'**
  String get confirmCode;

  /// No description provided for @confirmCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit code again.'**
  String get confirmCodeHint;

  /// No description provided for @setupCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a code to unlock the phone after an alarm.'**
  String get setupCodeHint;

  /// No description provided for @codesDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Codes do not match.'**
  String get codesDoNotMatch;

  /// No description provided for @discretePhoto.
  ///
  /// In en, this message translates to:
  /// **'Discrete photo'**
  String get discretePhoto;

  /// No description provided for @discretePhotoDescription.
  ///
  /// In en, this message translates to:
  /// **'Takes a front camera photo when lifted and saves it to the Dontach album.'**
  String get discretePhotoDescription;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @scheduleAutoBetween.
  ///
  /// In en, this message translates to:
  /// **'Automatically activate between:'**
  String get scheduleAutoBetween;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @noDays.
  ///
  /// In en, this message translates to:
  /// **'No days'**
  String get noDays;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @sensorsError.
  ///
  /// In en, this message translates to:
  /// **'Unable to activate phone sensors.'**
  String get sensorsError;

  /// No description provided for @cameraPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Allow camera and gallery access for discrete photo.'**
  String get cameraPermissionError;

  /// No description provided for @switchActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Protection enabled'**
  String get switchActiveLabel;

  /// No description provided for @switchInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Protection disabled'**
  String get switchInactiveLabel;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @phoneLockedNotification.
  ///
  /// In en, this message translates to:
  /// **'Phone locked'**
  String get phoneLockedNotification;

  /// No description provided for @lockdownChannelName.
  ///
  /// In en, this message translates to:
  /// **'Dontach lockdown'**
  String get lockdownChannelName;

  /// No description provided for @lockdownChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Notification shown while the phone is locked after an alarm.'**
  String get lockdownChannelDescription;

  /// No description provided for @pinSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save the code. Please try again.'**
  String get pinSaveError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
