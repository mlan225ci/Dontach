// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Dontach';

  @override
  String get chooseLanguage => 'Choisissez votre langue';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get continueButton => 'Continuer';

  @override
  String get onLabel => 'ON';

  @override
  String get offLabel => 'OFF';

  @override
  String get protectionActive => 'Protection active';

  @override
  String get protectionInactive => 'Protection inactive';

  @override
  String get locked => 'Verrouillé';

  @override
  String get calibrating => 'Calibration...';

  @override
  String get schedulePending => 'Programmation en cours';

  @override
  String get enterCodeToUnlock =>
      'Entrez votre code Dontach pour accéder au téléphone.';

  @override
  String get placePhoneFlat =>
      'Posez le téléphone à plat.\nL\'alarme se déclenche s\'il est soulevé.';

  @override
  String scheduleAutoActivate(String timeRange, String days) {
    return 'La protection s\'activera automatiquement\n$timeRange · $days';
  }

  @override
  String get activateOrSchedule =>
      'Activez la protection ou programmez-la ci-dessous.';

  @override
  String get enterYourCode => 'Entrez votre code';

  @override
  String get incorrectCode => 'Code incorrect';

  @override
  String get dontachCode => 'Code Dontach';

  @override
  String get confirmCode => 'Confirmez le code';

  @override
  String get confirmCodeHint => 'Saisissez à nouveau votre code à 4 chiffres.';

  @override
  String get setupCodeHint =>
      'Choisissez un code pour déverrouiller le téléphone après une alarme.';

  @override
  String get codesDoNotMatch => 'Les codes ne correspondent pas.';

  @override
  String get discretePhoto => 'Photo discrète';

  @override
  String get discretePhotoDescription =>
      'Prend une photo avec la caméra frontale au moment du soulèvement et l\'enregistre dans l\'album Dontach.';

  @override
  String get schedule => 'Programmation';

  @override
  String get scheduleAutoBetween => 'Activer automatiquement entre :';

  @override
  String get start => 'Début';

  @override
  String get end => 'Fin';

  @override
  String get days => 'Jours';

  @override
  String get noDays => 'Aucun jour';

  @override
  String get everyDay => 'Tous les jours';

  @override
  String get sensorsError => 'Impossible d\'activer les capteurs du téléphone.';

  @override
  String get cameraPermissionError =>
      'Autorisez la caméra et la galerie pour la photo discrète.';

  @override
  String get switchActiveLabel => 'Protection activée';

  @override
  String get switchInactiveLabel => 'Protection désactivée';

  @override
  String get weekdayMon => 'Lun';

  @override
  String get weekdayTue => 'Mar';

  @override
  String get weekdayWed => 'Mer';

  @override
  String get weekdayThu => 'Jeu';

  @override
  String get weekdayFri => 'Ven';

  @override
  String get weekdaySat => 'Sam';

  @override
  String get weekdaySun => 'Dim';

  @override
  String get phoneLockedNotification => 'Téléphone verrouillé';

  @override
  String get lockdownChannelName => 'Verrouillage Dontach';

  @override
  String get lockdownChannelDescription =>
      'Notification affichée pendant le verrouillage après une alarme.';

  @override
  String get pinSaveError => 'Impossible d\'enregistrer le code. Réessayez.';
}
