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

  @override
  String get settings => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsAbout => 'About';

  @override
  String get language => 'Language';

  @override
  String get languageUpdated => 'Language updated.';

  @override
  String get changePin => 'Change code';

  @override
  String get changePinDescription =>
      'Update the code used to unlock after an alarm.';

  @override
  String get changePinCurrent => 'Current code';

  @override
  String get changePinCurrentHint => 'Enter your current 4-digit code.';

  @override
  String get changePinNew => 'New code';

  @override
  String get changePinNewHint => 'Choose a new 4-digit code.';

  @override
  String get pinChangedSuccess => 'Code updated successfully.';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get copyright => '© 2026 Alban M\'lan';

  @override
  String get settingsDetection => 'Detection';

  @override
  String get settingsPerformance => 'Performance';

  @override
  String get sensitivity => 'Sensitivity';

  @override
  String get sensitivityDescription =>
      'Low reduces false alarms. High detects smaller movements.';

  @override
  String get sensitivityLow => 'Low (fewer false alarms)';

  @override
  String get sensitivityMedium => 'Medium (balanced)';

  @override
  String get sensitivityHigh => 'High (more reactive)';

  @override
  String get recalibrate => 'Recalibrate sensors';

  @override
  String get recalibrateDescription =>
      'Place the phone flat, then recalibrate the baseline.';

  @override
  String get recalibrateSuccess => 'Sensors recalibrated.';

  @override
  String get recalibrateRequiresArmed =>
      'Enable protection first to recalibrate.';

  @override
  String get intrusionHistory => 'Intrusion history';

  @override
  String get intrusionHistoryDescription =>
      'View when the alarm was triggered.';

  @override
  String get intrusionHistoryEmpty => 'No intrusions recorded yet.';

  @override
  String intrusionHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count intrusions',
      one: '1 intrusion',
      zero: 'No intrusions',
    );
    return '$_temp0';
  }

  @override
  String get intrusionPhotoCaptured => 'Discrete photo captured';

  @override
  String get intrusionPhotoMissing => 'No photo captured';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get clearHistoryConfirm => 'Delete all intrusion records?';

  @override
  String get historyCleared => 'History cleared.';

  @override
  String get cancel => 'Cancel';

  @override
  String get batteryOptimization => 'Battery optimization';

  @override
  String get batteryOptimizationDescription =>
      'Prevent Android from stopping Dontach in the background.';

  @override
  String get batteryOptimizationEnabled =>
      'Battery restrictions disabled for Dontach.';

  @override
  String get batteryOptimizationDisabled =>
      'Dontach may be stopped in the background.';

  @override
  String get batteryGuideTitle => 'Battery guide';

  @override
  String get batteryGuideStep1 =>
      'Tap \"Allow Dontach\" below to request an exemption.';

  @override
  String get batteryGuideStep2 =>
      'If a popup appears, choose Allow or Don\'t optimize.';

  @override
  String get batteryGuideStep3 =>
      'On Pixel: Settings → Apps → Dontach → Battery → Unrestricted.';

  @override
  String get batteryGuideStep4 =>
      'Keep Dontach open or pinned while protection is active.';

  @override
  String get batteryOpenSettings => 'Open battery settings';

  @override
  String get batteryRequestExemption => 'Allow Dontach (no restriction)';

  @override
  String get protectionMode => 'Protection mode';

  @override
  String get modeTable => 'On table';

  @override
  String get modePocket => 'In pocket';

  @override
  String get modeTableDescription =>
      'Phone flat on a surface. Alarm triggers when lifted.';

  @override
  String get modePocketDescription =>
      'Phone in pocket or bag. Alarm triggers on snatch or extraction.';

  @override
  String get protectionActivePocket => 'Pocket protection active';

  @override
  String get calibratingPocket => 'Calibrating in pocket...';

  @override
  String get placePhoneInPocket =>
      'Keep the phone in your pocket.\nThe alarm triggers if it is removed.';

  @override
  String get recalibratePocketDescription =>
      'Keep the phone still in your pocket, then recalibrate.';

  @override
  String get settingsAlarm => 'Alarm';

  @override
  String get alarmVolume => 'Alarm volume';

  @override
  String get alarmVolumeDescription =>
      'Adjust the siren volume when an intrusion is detected.';

  @override
  String get testAlarmVolume => 'Test volume';

  @override
  String get volumeMin => '0%';

  @override
  String get volumeMax => '100%';

  @override
  String get volumeMuted => 'Muted';

  @override
  String get volumeKnobHint => 'Turn the knob or use − / +';

  @override
  String get pocketPlacementHint =>
      'Place the phone in your pocket or bag.\nCalibration starts in a few seconds…';

  @override
  String pocketPlacementCountdown(int seconds) {
    return 'Place in pocket… ${seconds}s';
  }

  @override
  String get tablePlacementHint =>
      'Place the phone flat on the table.\nCalibration starts in a few seconds…';

  @override
  String tablePlacementCountdown(int seconds) {
    return 'Place flat… ${seconds}s';
  }
}
