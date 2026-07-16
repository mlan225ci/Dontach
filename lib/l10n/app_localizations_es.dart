// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Dontach';

  @override
  String get chooseLanguage => 'Elige tu idioma';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get continueButton => 'Continuar';

  @override
  String get onLabel => 'ON';

  @override
  String get offLabel => 'OFF';

  @override
  String get protectionActive => 'Protección activa';

  @override
  String get protectionInactive => 'Protección inactiva';

  @override
  String get locked => 'Bloqueado';

  @override
  String get calibrating => 'Calibrando...';

  @override
  String get schedulePending => 'Programación en curso';

  @override
  String get enterCodeToUnlock =>
      'Introduce tu código Dontach para acceder al teléfono.';

  @override
  String get placePhoneFlat =>
      'Coloca el teléfono en plano.\nLa alarma se activa si se levanta.';

  @override
  String scheduleAutoActivate(String timeRange, String days) {
    return 'La protección se activará automáticamente\n$timeRange · $days';
  }

  @override
  String get activateOrSchedule => 'Activa la protección o prográmala abajo.';

  @override
  String get enterYourCode => 'Introduce tu código';

  @override
  String get incorrectCode => 'Código incorrecto';

  @override
  String get dontachCode => 'Código Dontach';

  @override
  String get confirmCode => 'Confirma el código';

  @override
  String get confirmCodeHint => 'Introduce de nuevo tu código de 4 dígitos.';

  @override
  String get setupCodeHint =>
      'Elige un código para desbloquear el teléfono tras una alarma.';

  @override
  String get codesDoNotMatch => 'Los códigos no coinciden.';

  @override
  String get discretePhoto => 'Foto discreta';

  @override
  String get discretePhotoDescription =>
      'Toma una foto con la cámara frontal al levantarlo y la guarda en el álbum Dontach.';

  @override
  String get schedule => 'Programación';

  @override
  String get scheduleAutoBetween => 'Activar automáticamente entre:';

  @override
  String get start => 'Inicio';

  @override
  String get end => 'Fin';

  @override
  String get days => 'Días';

  @override
  String get noDays => 'Ningún día';

  @override
  String get everyDay => 'Todos los días';

  @override
  String get sensorsError => 'No se pueden activar los sensores del teléfono.';

  @override
  String get cameraPermissionError =>
      'Permite el acceso a la cámara y la galería para la foto discreta.';

  @override
  String get switchActiveLabel => 'Protección activada';

  @override
  String get switchInactiveLabel => 'Protección desactivada';

  @override
  String get weekdayMon => 'Lun';

  @override
  String get weekdayTue => 'Mar';

  @override
  String get weekdayWed => 'Mié';

  @override
  String get weekdayThu => 'Jue';

  @override
  String get weekdayFri => 'Vie';

  @override
  String get weekdaySat => 'Sáb';

  @override
  String get weekdaySun => 'Dom';

  @override
  String get phoneLockedNotification => 'Teléfono bloqueado';

  @override
  String get lockdownChannelName => 'Bloqueo Dontach';

  @override
  String get lockdownChannelDescription =>
      'Notificación mostrada mientras el teléfono está bloqueado tras una alarma.';

  @override
  String get pinSaveError =>
      'No se pudo guardar el código. Inténtalo de nuevo.';
}
