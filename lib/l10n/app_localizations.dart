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

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language updated.'**
  String get languageUpdated;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change code'**
  String get changePin;

  /// No description provided for @changePinDescription.
  ///
  /// In en, this message translates to:
  /// **'Update the code used to unlock after an alarm.'**
  String get changePinDescription;

  /// No description provided for @changePinCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current code'**
  String get changePinCurrent;

  /// No description provided for @changePinCurrentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current 4-digit code.'**
  String get changePinCurrentHint;

  /// No description provided for @changePinNew.
  ///
  /// In en, this message translates to:
  /// **'New code'**
  String get changePinNew;

  /// No description provided for @changePinNewHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a new 4-digit code.'**
  String get changePinNewHint;

  /// No description provided for @pinChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Code updated successfully.'**
  String get pinChangedSuccess;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Alban M\'lan'**
  String get copyright;

  /// No description provided for @settingsDetection.
  ///
  /// In en, this message translates to:
  /// **'Detection'**
  String get settingsDetection;

  /// No description provided for @settingsPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get settingsPerformance;

  /// No description provided for @sensitivity.
  ///
  /// In en, this message translates to:
  /// **'Sensitivity'**
  String get sensitivity;

  /// No description provided for @sensitivityDescription.
  ///
  /// In en, this message translates to:
  /// **'Low reduces false alarms. High detects smaller movements.'**
  String get sensitivityDescription;

  /// No description provided for @sensitivityLow.
  ///
  /// In en, this message translates to:
  /// **'Low (fewer false alarms)'**
  String get sensitivityLow;

  /// No description provided for @sensitivityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium (balanced)'**
  String get sensitivityMedium;

  /// No description provided for @sensitivityHigh.
  ///
  /// In en, this message translates to:
  /// **'High (more reactive)'**
  String get sensitivityHigh;

  /// No description provided for @recalibrate.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate sensors'**
  String get recalibrate;

  /// No description provided for @recalibrateDescription.
  ///
  /// In en, this message translates to:
  /// **'Place the phone flat, then recalibrate the baseline.'**
  String get recalibrateDescription;

  /// No description provided for @recalibrateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sensors recalibrated.'**
  String get recalibrateSuccess;

  /// No description provided for @recalibrateRequiresArmed.
  ///
  /// In en, this message translates to:
  /// **'Enable protection first to recalibrate.'**
  String get recalibrateRequiresArmed;

  /// No description provided for @intrusionHistory.
  ///
  /// In en, this message translates to:
  /// **'Intrusion history'**
  String get intrusionHistory;

  /// No description provided for @intrusionHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'View when the alarm was triggered.'**
  String get intrusionHistoryDescription;

  /// No description provided for @intrusionHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No intrusions recorded yet.'**
  String get intrusionHistoryEmpty;

  /// No description provided for @intrusionHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No intrusions} =1{1 intrusion} other{{count} intrusions}}'**
  String intrusionHistoryCount(int count);

  /// No description provided for @intrusionPhotoCaptured.
  ///
  /// In en, this message translates to:
  /// **'Discrete photo captured'**
  String get intrusionPhotoCaptured;

  /// No description provided for @intrusionPhotoMissing.
  ///
  /// In en, this message translates to:
  /// **'No photo captured'**
  String get intrusionPhotoMissing;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all intrusion records?'**
  String get clearHistoryConfirm;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared.'**
  String get historyCleared;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @batteryOptimization.
  ///
  /// In en, this message translates to:
  /// **'Battery optimization'**
  String get batteryOptimization;

  /// No description provided for @batteryOptimizationDescription.
  ///
  /// In en, this message translates to:
  /// **'Prevent Android from stopping Dontach in the background.'**
  String get batteryOptimizationDescription;

  /// No description provided for @batteryOptimizationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Battery restrictions disabled for Dontach.'**
  String get batteryOptimizationEnabled;

  /// No description provided for @batteryOptimizationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Dontach may be stopped in the background.'**
  String get batteryOptimizationDisabled;

  /// No description provided for @batteryGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery guide'**
  String get batteryGuideTitle;

  /// No description provided for @batteryGuideStep1.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Allow Dontach\" below to request an exemption.'**
  String get batteryGuideStep1;

  /// No description provided for @batteryGuideStep2.
  ///
  /// In en, this message translates to:
  /// **'If a popup appears, choose Allow or Don\'t optimize.'**
  String get batteryGuideStep2;

  /// No description provided for @batteryGuideStep3.
  ///
  /// In en, this message translates to:
  /// **'On Pixel: Settings → Apps → Dontach → Battery → Unrestricted.'**
  String get batteryGuideStep3;

  /// No description provided for @batteryGuideStep4.
  ///
  /// In en, this message translates to:
  /// **'Keep Dontach open or pinned while protection is active.'**
  String get batteryGuideStep4;

  /// No description provided for @batteryOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open battery settings'**
  String get batteryOpenSettings;

  /// No description provided for @batteryRequestExemption.
  ///
  /// In en, this message translates to:
  /// **'Allow Dontach (no restriction)'**
  String get batteryRequestExemption;

  /// No description provided for @protectionMode.
  ///
  /// In en, this message translates to:
  /// **'Protection mode'**
  String get protectionMode;

  /// No description provided for @modeTable.
  ///
  /// In en, this message translates to:
  /// **'On table'**
  String get modeTable;

  /// No description provided for @modePocket.
  ///
  /// In en, this message translates to:
  /// **'In pocket'**
  String get modePocket;

  /// No description provided for @modeTableDescription.
  ///
  /// In en, this message translates to:
  /// **'Phone flat on a surface. Alarm triggers when lifted.'**
  String get modeTableDescription;

  /// No description provided for @modePocketDescription.
  ///
  /// In en, this message translates to:
  /// **'Phone in pocket or bag. Alarm triggers on snatch or extraction.'**
  String get modePocketDescription;

  /// No description provided for @protectionActivePocket.
  ///
  /// In en, this message translates to:
  /// **'Pocket protection active'**
  String get protectionActivePocket;

  /// No description provided for @calibratingPocket.
  ///
  /// In en, this message translates to:
  /// **'Calibrating in pocket...'**
  String get calibratingPocket;

  /// No description provided for @placePhoneInPocket.
  ///
  /// In en, this message translates to:
  /// **'Keep the phone in your pocket.\nThe alarm triggers if it is removed.'**
  String get placePhoneInPocket;

  /// No description provided for @recalibratePocketDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep the phone still in your pocket, then recalibrate.'**
  String get recalibratePocketDescription;

  /// No description provided for @settingsAlarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get settingsAlarm;

  /// No description provided for @alarmVolume.
  ///
  /// In en, this message translates to:
  /// **'Alarm volume'**
  String get alarmVolume;

  /// No description provided for @alarmVolumeDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust the siren volume when an intrusion is detected.'**
  String get alarmVolumeDescription;

  /// No description provided for @testAlarmVolume.
  ///
  /// In en, this message translates to:
  /// **'Test volume'**
  String get testAlarmVolume;

  /// No description provided for @volumeMin.
  ///
  /// In en, this message translates to:
  /// **'0%'**
  String get volumeMin;

  /// No description provided for @volumeMax.
  ///
  /// In en, this message translates to:
  /// **'100%'**
  String get volumeMax;

  /// No description provided for @volumeMuted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get volumeMuted;

  /// No description provided for @volumeKnobHint.
  ///
  /// In en, this message translates to:
  /// **'Turn the knob or use − / +'**
  String get volumeKnobHint;

  /// No description provided for @pocketPlacementHint.
  ///
  /// In en, this message translates to:
  /// **'Place the phone in your pocket or bag.\nCalibration starts in a few seconds…'**
  String get pocketPlacementHint;

  /// No description provided for @pocketPlacementCountdown.
  ///
  /// In en, this message translates to:
  /// **'Place in pocket… {seconds}s'**
  String pocketPlacementCountdown(int seconds);

  /// No description provided for @tablePlacementHint.
  ///
  /// In en, this message translates to:
  /// **'Place the phone flat on the table.\nCalibration starts in a few seconds…'**
  String get tablePlacementHint;

  /// No description provided for @tablePlacementCountdown.
  ///
  /// In en, this message translates to:
  /// **'Place flat… {seconds}s'**
  String tablePlacementCountdown(int seconds);
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
