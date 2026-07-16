// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dontach';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get continueButton => 'Continue';

  @override
  String get onLabel => 'ON';

  @override
  String get offLabel => 'OFF';

  @override
  String get protectionActive => 'Protection active';

  @override
  String get protectionInactive => 'Protection inactive';

  @override
  String get locked => 'Locked';

  @override
  String get calibrating => 'Calibrating...';

  @override
  String get schedulePending => 'Schedule pending';

  @override
  String get enterCodeToUnlock =>
      'Enter your Dontach code to access the phone.';

  @override
  String get placePhoneFlat =>
      'Place the phone flat.\nThe alarm triggers if it is lifted.';

  @override
  String scheduleAutoActivate(String timeRange, String days) {
    return 'Protection will activate automatically\n$timeRange · $days';
  }

  @override
  String get activateOrSchedule => 'Activate protection or schedule it below.';

  @override
  String get enterYourCode => 'Enter your code';

  @override
  String get incorrectCode => 'Incorrect code';

  @override
  String get dontachCode => 'Dontach code';

  @override
  String get confirmCode => 'Confirm code';

  @override
  String get confirmCodeHint => 'Enter your 4-digit code again.';

  @override
  String get setupCodeHint =>
      'Choose a code to unlock the phone after an alarm.';

  @override
  String get codesDoNotMatch => 'Codes do not match.';

  @override
  String get discretePhoto => 'Discrete photo';

  @override
  String get discretePhotoDescription =>
      'Takes a front camera photo when lifted and saves it to the Dontach album.';

  @override
  String get schedule => 'Schedule';

  @override
  String get scheduleAutoBetween => 'Automatically activate between:';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get days => 'Days';

  @override
  String get noDays => 'No days';

  @override
  String get everyDay => 'Every day';

  @override
  String get sensorsError => 'Unable to activate phone sensors.';

  @override
  String get cameraPermissionError =>
      'Allow camera and gallery access for discrete photo.';

  @override
  String get switchActiveLabel => 'Protection enabled';

  @override
  String get switchInactiveLabel => 'Protection disabled';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get phoneLockedNotification => 'Phone locked';

  @override
  String get lockdownChannelName => 'Dontach lockdown';

  @override
  String get lockdownChannelDescription =>
      'Notification shown while the phone is locked after an alarm.';

  @override
  String get pinSaveError => 'Unable to save the code. Please try again.';
}
