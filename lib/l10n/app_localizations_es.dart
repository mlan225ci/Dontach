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

  @override
  String get settings => 'Ajustes';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsSecurity => 'Seguridad';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get language => 'Idioma';

  @override
  String get languageUpdated => 'Idioma actualizado.';

  @override
  String get changePin => 'Cambiar código';

  @override
  String get changePinDescription =>
      'Actualiza el código para desbloquear tras una alarma.';

  @override
  String get changePinCurrent => 'Código actual';

  @override
  String get changePinCurrentHint => 'Introduce tu código actual de 4 dígitos.';

  @override
  String get changePinNew => 'Nuevo código';

  @override
  String get changePinNewHint => 'Elige un nuevo código de 4 dígitos.';

  @override
  String get pinChangedSuccess => 'Código actualizado correctamente.';

  @override
  String versionLabel(String version) {
    return 'Versión $version';
  }

  @override
  String get copyright => '© 2026 Alban M\'lan';

  @override
  String get settingsDetection => 'Detección';

  @override
  String get settingsPerformance => 'Rendimiento';

  @override
  String get sensitivity => 'Sensibilidad';

  @override
  String get sensitivityDescription =>
      'Baja reduce falsas alarmas. Alta detecta movimientos pequeños.';

  @override
  String get sensitivityLow => 'Baja (menos falsos positivos)';

  @override
  String get sensitivityMedium => 'Media (equilibrada)';

  @override
  String get sensitivityHigh => 'Alta (más reactiva)';

  @override
  String get recalibrate => 'Recalibrar sensores';

  @override
  String get recalibrateDescription =>
      'Coloca el teléfono en plano y recalibra la base.';

  @override
  String get recalibrateSuccess => 'Sensores recalibrados.';

  @override
  String get recalibrateRequiresArmed =>
      'Activa primero la protección para recalibrar.';

  @override
  String get intrusionHistory => 'Historial de intrusiones';

  @override
  String get intrusionHistoryDescription => 'Ver cuándo se activó la alarma.';

  @override
  String get intrusionHistoryEmpty => 'Ninguna intrusión registrada.';

  @override
  String intrusionHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count intrusiones',
      one: '1 intrusión',
      zero: 'Sin intrusiones',
    );
    return '$_temp0';
  }

  @override
  String get intrusionPhotoCaptured => 'Foto discreta capturada';

  @override
  String get intrusionPhotoMissing => 'Sin foto capturada';

  @override
  String get clearHistory => 'Borrar historial';

  @override
  String get clearHistoryConfirm =>
      '¿Eliminar todos los registros de intrusión?';

  @override
  String get historyCleared => 'Historial borrado.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get batteryOptimization => 'Optimización de batería';

  @override
  String get batteryOptimizationDescription =>
      'Evita que Android detenga Dontach en segundo plano.';

  @override
  String get batteryOptimizationEnabled =>
      'Restricciones de batería desactivadas para Dontach.';

  @override
  String get batteryOptimizationDisabled =>
      'Dontach puede detenerse en segundo plano.';

  @override
  String get batteryGuideTitle => 'Guía de batería';

  @override
  String get batteryGuideStep1 =>
      'Pulsa « Permitir Dontach » abajo para solicitar una exención.';

  @override
  String get batteryGuideStep2 =>
      'Si aparece un popup, elige Permitir o No optimizar.';

  @override
  String get batteryGuideStep3 =>
      'En Pixel: Ajustes → Apps → Dontach → Batería → Sin restricciones.';

  @override
  String get batteryGuideStep4 =>
      'Mantén Dontach abierto mientras la protección esté activa.';

  @override
  String get batteryOpenSettings => 'Abrir ajustes de batería';

  @override
  String get batteryRequestExemption => 'Permitir Dontach (sin restricción)';

  @override
  String get protectionMode => 'Modo de protección';

  @override
  String get modeTable => 'En mesa';

  @override
  String get modePocket => 'En bolsillo';

  @override
  String get modeTableDescription =>
      'Teléfono en plano sobre una superficie. La alarma se activa si se levanta.';

  @override
  String get modePocketDescription =>
      'Teléfono en bolsillo o bolso. La alarma se activa si lo arrancan o lo sacan.';

  @override
  String get protectionActivePocket => 'Protección de bolsillo activa';

  @override
  String get calibratingPocket => 'Calibrando en bolsillo...';

  @override
  String get placePhoneInPocket =>
      'Mantén el teléfono en el bolsillo.\nLa alarma se activa si lo sacan.';

  @override
  String get recalibratePocketDescription =>
      'Mantén el teléfono quieto en el bolsillo y recalibra.';

  @override
  String get settingsAlarm => 'Alarma';

  @override
  String get alarmVolume => 'Volumen de la alarma';

  @override
  String get alarmVolumeDescription =>
      'Ajusta el volumen de la sirena cuando se detecta una intrusión.';

  @override
  String get testAlarmVolume => 'Probar volumen';

  @override
  String get volumeMin => '0 %';

  @override
  String get volumeMax => '100 %';

  @override
  String get volumeMuted => 'Silencio';

  @override
  String get volumeKnobHint => 'Gira el mando o usa − / +';

  @override
  String get pocketPlacementHint =>
      'Coloca el teléfono en el bolsillo o bolso.\nLa calibración empieza en unos segundos…';

  @override
  String pocketPlacementCountdown(int seconds) {
    return 'Coloca en bolsillo… $seconds s';
  }

  @override
  String get tablePlacementHint =>
      'Coloca el teléfono en plano sobre la mesa.\nLa calibración empieza en unos segundos…';

  @override
  String tablePlacementCountdown(int seconds) {
    return 'Coloca en plano… $seconds s';
  }
}
