import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../models/alarm_settings.dart';
import '../models/capture_settings.dart';
import '../models/intrusion_event.dart';
import '../models/schedule_config.dart';
import '../models/sensitivity_settings.dart';
import 'alarm_service.dart';
import 'alarm_settings_storage.dart';
import 'capture_settings_storage.dart';
import 'intruder_capture_service.dart';
import 'intrusion_history_storage.dart';
import 'lockdown_service.dart';
import 'motion_detector.dart';
import 'schedule_storage.dart';
import 'sensitivity_storage.dart';

class ProtectionCoordinator extends ChangeNotifier {
  ProtectionCoordinator._();

  static final ProtectionCoordinator instance = ProtectionCoordinator._();

  final MotionDetector detector = MotionDetector();
  final IntruderCaptureService intruderCapture = IntruderCaptureService();
  final ScheduleStorage scheduleStorage = ScheduleStorage();
  final CaptureSettingsStorage captureSettingsStorage = CaptureSettingsStorage();
  final SensitivityStorage sensitivityStorage = SensitivityStorage();
  final IntrusionHistoryStorage intrusionHistoryStorage = IntrusionHistoryStorage();
  final AlarmSettingsStorage alarmSettingsStorage = AlarmSettingsStorage();

  bool isArmed = false;
  bool isCalibrating = false;
  bool isAlarmRinging = false;
  bool isRecalibrating = false;
  bool isPlacementPending = false;
  int placementCountdown = 0;
  ScheduleConfig schedule = const ScheduleConfig();
  CaptureSettings captureSettings = const CaptureSettings();
  SensitivitySettings sensitivitySettings = const SensitivitySettings();
  AlarmSettings alarmSettings = const AlarmSettings();
  List<IntrusionEvent> intrusionHistory = [];

  Timer? _scheduleTimer;
  Timer? _placementTimer;
  bool _handlingIntrusion = false;
  bool _unlockInProgress = false;
  bool _lockSessionActive = false;
  String? _activeIntrusionId;

  bool get requiresUnlock => _lockSessionActive;

  Future<void> initialize() async {
    schedule = await scheduleStorage.load();
    captureSettings = await captureSettingsStorage.load();
    sensitivitySettings = await sensitivityStorage.load();
    alarmSettings = await alarmSettingsStorage.load();
    intrusionHistory = await intrusionHistoryStorage.load();
    AlarmService.instance.setVolume(alarmSettings.volume);
    _applySensitivityToDetector();
    _startScheduleMonitor();
    LockdownService.instance.onUnlocked = _handleUnlock;
    notifyListeners();
  }

  void _applySensitivityToDetector() {
    detector.applySettings(sensitivitySettings);
  }

  void _startScheduleMonitor() {
    _scheduleTimer?.cancel();
    _scheduleTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => applySchedule(autoOnly: true),
    );
  }

  Future<void> updateSchedule(ScheduleConfig config) async {
    schedule = config;
    await scheduleStorage.save(config);
    await applySchedule(autoOnly: true);
    notifyListeners();
  }

  Future<void> updateCaptureSettings(CaptureSettings settings) async {
    captureSettings = settings;
    await captureSettingsStorage.save(settings);

    if (isArmed) {
      if (settings.enabled) {
        await prepareCapture();
      } else {
        await intruderCapture.release();
      }
    }
    notifyListeners();
  }

  Future<void> updateSensitivity(SensitivitySettings settings) async {
    sensitivitySettings = settings;
    await sensitivityStorage.save(settings);
    _applySensitivityToDetector();

    if (isArmed && !isCalibrating && !isRecalibrating && !isPlacementPending) {
      await recalibrateSensors();
    }
    notifyListeners();
  }

  Future<void> updateAlarmSettings(AlarmSettings settings) async {
    alarmSettings = settings;
    AlarmService.instance.setVolume(settings.volume);
    await alarmSettingsStorage.save(settings);
    notifyListeners();
  }

  Future<void> previewAlarmVolume() async {
    await AlarmService.instance.preview();
  }

  Future<void> updateProtectionMode(ProtectionMode mode) async {
    if (isArmed || isCalibrating || isAlarmRinging || isPlacementPending) return;
    await updateSensitivity(sensitivitySettings.copyWith(mode: mode));
  }

  Future<void> recalibrateSensors() async {
    if (!isArmed || isCalibrating || isRecalibrating || isPlacementPending) return;

    isRecalibrating = true;
    notifyListeners();

    try {
      await detector.stop();
      await detector.calibrate();
      await detector.start(onPickup: _handleIntrusion);
    } catch (error) {
      debugPrint('ProtectionCoordinator.recalibrateSensors failed: $error');
    } finally {
      isRecalibrating = false;
      notifyListeners();
    }
  }

  Future<void> refreshIntrusionHistory() async {
    intrusionHistory = await intrusionHistoryStorage.load();
    notifyListeners();
  }

  Future<void> clearIntrusionHistory() async {
    await intrusionHistoryStorage.clear();
    intrusionHistory = [];
    notifyListeners();
  }

  Future<void> prepareCapture() async {
    if (!captureSettings.enabled) return;
    await intruderCapture.prepare();
  }

  Future<void> setArmed(bool armed, {bool fromSchedule = false}) async {
    if (!armed) {
      await _disarm();
      notifyListeners();
      return;
    }

    if (isCalibrating || isPlacementPending) return;

    await _startPlacementCountdown();
  }

  int _placementSecondsForMode(ProtectionMode mode) {
    return mode == ProtectionMode.pocket ? 4 : 3;
  }

  Future<void> _startPlacementCountdown() async {
    _cancelPlacementTimer();
    isPlacementPending = true;
    placementCountdown = _placementSecondsForMode(sensitivitySettings.mode);
    notifyListeners();

    final completer = Completer<void>();
    _placementTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      placementCountdown--;
      notifyListeners();

      if (placementCountdown <= 0) {
        timer.cancel();
        _placementTimer = null;
        if (!completer.isCompleted) completer.complete();
      }
    });

    await completer.future;
    if (!isPlacementPending) return;

    isPlacementPending = false;
    placementCountdown = 0;

    try {
      await _finishArming();
    } catch (error) {
      debugPrint('ProtectionCoordinator._startPlacementCountdown failed: $error');
      await _disarm();
      isCalibrating = false;
      notifyListeners();
      rethrow;
    }
  }

  void _cancelPlacementTimer() {
    _placementTimer?.cancel();
    _placementTimer = null;
  }

  Future<void> _finishArming() async {
    isCalibrating = true;
    notifyListeners();

    try {
      _applySensitivityToDetector();
      await detector.calibrate();
      await prepareCapture();
      await detector.start(onPickup: _handleIntrusion);
      await WakelockPlus.enable();
      isArmed = true;
    } catch (error) {
      debugPrint('ProtectionCoordinator._finishArming failed: $error');
      rethrow;
    } finally {
      isCalibrating = false;
      notifyListeners();
    }
  }

  Future<void> _disarm() async {
    _cancelPlacementTimer();
    isPlacementPending = false;
    placementCountdown = 0;
    await _silenceAlarmCompletely();
    await detector.stop();
    if (LockdownService.instance.isActive) {
      await LockdownService.instance.deactivate(invokeCallback: false);
    }
    await intruderCapture.release();
    await WakelockPlus.disable();
    isArmed = false;
    _lockSessionActive = false;
    _unlockInProgress = false;
    _activeIntrusionId = null;
    notifyListeners();
  }

  Future<void> _silenceAlarmCompletely() async {
    isAlarmRinging = false;
    _handlingIntrusion = false;
    AlarmService.instance.stopImmediate();
    await AlarmService.instance.stop();
  }

  void stopAlarmAudioOnly() {
    isAlarmRinging = false;
    AlarmService.instance.stopImmediate();
    notifyListeners();
  }

  Future<void> resumeAlarmIfLocked() async {
    if (_unlockInProgress || !_lockSessionActive || isAlarmRinging) {
      return;
    }
    isAlarmRinging = true;
    _handlingIntrusion = true;
    notifyListeners();
    await AlarmService.instance.play();
    notifyListeners();
  }

  Future<void> applySchedule({required bool autoOnly}) async {
    if (!schedule.enabled) return;

    final shouldArm = schedule.isActiveAt(DateTime.now());
    if (shouldArm && !isArmed && !isCalibrating && !isAlarmRinging && !isPlacementPending) {
      await setArmed(true, fromSchedule: autoOnly);
    } else if (!shouldArm && isArmed && autoOnly) {
      await setArmed(false, fromSchedule: true);
    }
  }

  Future<void> _handleIntrusion() async {
    if (_unlockInProgress || _handlingIntrusion || isAlarmRinging) return;
    _handlingIntrusion = true;
    _lockSessionActive = true;
    isAlarmRinging = true;

    final event = IntrusionEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
    );
    _activeIntrusionId = event.id;
    await intrusionHistoryStorage.add(event);
    intrusionHistory = await intrusionHistoryStorage.load();

    notifyListeners();

    try {
      await AlarmService.instance.play();
      if (_unlockInProgress || !_lockSessionActive) {
        await AlarmService.instance.stop();
        return;
      }
      notifyListeners();
      await LockdownService.instance.activate();
      if (_unlockInProgress || !_lockSessionActive) return;
      unawaited(_captureIntruderPhoto());
    } catch (error, stackTrace) {
      debugPrint('ProtectionCoordinator._handleIntrusion failed: $error');
      debugPrint('$stackTrace');
      isAlarmRinging = false;
      _handlingIntrusion = false;
      notifyListeners();
    }
  }

  Future<void> _handleUnlock() async {
    await _silenceAlarmCompletely();
    notifyListeners();
  }

  Future<void> completeUnlock() async {
    if (_unlockInProgress) return;
    _unlockInProgress = true;
    _handlingIntrusion = true;
    isAlarmRinging = false;
    notifyListeners();

    await detector.stop();
    await _silenceAlarmCompletely();

    if (LockdownService.instance.isActive) {
      await LockdownService.instance.deactivate(invokeCallback: false);
    }
    await intruderCapture.release();
    await WakelockPlus.disable();

    isArmed = false;
    _lockSessionActive = false;
    _handlingIntrusion = false;
    _unlockInProgress = false;
    _activeIntrusionId = null;
    notifyListeners();
  }

  Future<void> _captureIntruderPhoto() async {
    if (!captureSettings.enabled || _unlockInProgress) return;
    await Future<void>.delayed(const Duration(seconds: 1));
    if (_unlockInProgress) return;
    try {
      await intruderCapture.captureAndSave();
      final id = _activeIntrusionId;
      if (id != null) {
        await intrusionHistoryStorage.markPhotoCaptured(id);
        intrusionHistory = await intrusionHistoryStorage.load();
        notifyListeners();
      }
    } catch (error) {
      debugPrint('ProtectionCoordinator photo capture failed: $error');
    }
  }

  @override
  void dispose() {
    _scheduleTimer?.cancel();
    _cancelPlacementTimer();
    super.dispose();
  }
}
