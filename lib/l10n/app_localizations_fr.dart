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

  @override
  String get settings => 'Réglages';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsSecurity => 'Sécurité';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get language => 'Langue';

  @override
  String get languageUpdated => 'Langue mise à jour.';

  @override
  String get changePin => 'Modifier le code';

  @override
  String get changePinDescription =>
      'Change le code utilisé pour déverrouiller après une alarme.';

  @override
  String get changePinCurrent => 'Code actuel';

  @override
  String get changePinCurrentHint => 'Entrez votre code actuel à 4 chiffres.';

  @override
  String get changePinNew => 'Nouveau code';

  @override
  String get changePinNewHint => 'Choisissez un nouveau code à 4 chiffres.';

  @override
  String get pinChangedSuccess => 'Code modifié avec succès.';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get copyright => '© 2026 Alban M\'lan';

  @override
  String get settingsDetection => 'Détection';

  @override
  String get settingsPerformance => 'Performance';

  @override
  String get sensitivity => 'Sensibilité';

  @override
  String get sensitivityDescription =>
      'Faible réduit les fausses alarmes. Élevée détecte les petits mouvements.';

  @override
  String get sensitivityLow => 'Faible (moins de faux positifs)';

  @override
  String get sensitivityMedium => 'Moyenne (équilibrée)';

  @override
  String get sensitivityHigh => 'Élevée (plus réactive)';

  @override
  String get recalibrate => 'Recalibrer les capteurs';

  @override
  String get recalibrateDescription =>
      'Posez le téléphone à plat, puis recalibrez la base.';

  @override
  String get recalibrateSuccess => 'Capteurs recalibrés.';

  @override
  String get recalibrateRequiresArmed =>
      'Activez d\'abord la protection pour recalibrer.';

  @override
  String get intrusionHistory => 'Historique des intrusions';

  @override
  String get intrusionHistoryDescription =>
      'Voir quand l\'alarme s\'est déclenchée.';

  @override
  String get intrusionHistoryEmpty => 'Aucune intrusion enregistrée.';

  @override
  String intrusionHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count intrusions',
      one: '1 intrusion',
      zero: 'Aucune intrusion',
    );
    return '$_temp0';
  }

  @override
  String get intrusionPhotoCaptured => 'Photo discrète capturée';

  @override
  String get intrusionPhotoMissing => 'Aucune photo capturée';

  @override
  String get clearHistory => 'Effacer l\'historique';

  @override
  String get clearHistoryConfirm =>
      'Supprimer tous les enregistrements d\'intrusion ?';

  @override
  String get historyCleared => 'Historique effacé.';

  @override
  String get cancel => 'Annuler';

  @override
  String get batteryOptimization => 'Optimisation batterie';

  @override
  String get batteryOptimizationDescription =>
      'Empêche Android d\'arrêter Dontach en arrière-plan.';

  @override
  String get batteryOptimizationEnabled =>
      'Restrictions batterie désactivées pour Dontach.';

  @override
  String get batteryOptimizationDisabled =>
      'Dontach peut être arrêté en arrière-plan.';

  @override
  String get batteryGuideTitle => 'Guide batterie';

  @override
  String get batteryGuideStep1 =>
      'Appuyez sur « Autoriser Dontach » ci-dessous pour demander une exemption.';

  @override
  String get batteryGuideStep2 =>
      'Si une fenêtre s\'ouvre, choisissez Autoriser ou Ne pas optimiser.';

  @override
  String get batteryGuideStep3 =>
      'Sur Pixel : Paramètres → Apps → Dontach → Batterie → Sans restriction.';

  @override
  String get batteryGuideStep4 =>
      'Gardez Dontach ouvert pendant que la protection est active.';

  @override
  String get batteryOpenSettings => 'Ouvrir les paramètres batterie';

  @override
  String get batteryRequestExemption => 'Autoriser Dontach (sans restriction)';
}
