import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../models/capture_settings.dart';
import '../models/intrusion_event.dart';
import '../models/schedule_config.dart';
import '../models/sensitivity_settings.dart';
import 'alarm_service.dart';
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

  bool isArmed = false;
  bool isCalibrating = false;
  bool isAlarmRinging = false;
  bool isRecalibrating = false;
  ScheduleConfig schedule = const ScheduleConfig();
  CaptureSettings captureSettings = const CaptureSettings();
  SensitivitySettings sensitivitySettings = const SensitivitySettings();
  List<IntrusionEvent> intrusionHistory = [];

  Timer? _scheduleTimer;
  bool _handlingIntrusion = false;
  bool _unlockInProgress = false;
  String? _activeIntrusionId;

  bool get requiresUnlock => isAlarmRinging || LockdownService.instance.isActive;

  Future<void> initialize() async {
    schedule = await scheduleStorage.load();
    captureSettings = await captureSettingsStorage.load();
    sensitivitySettings = await sensitivityStorage.load();
    intrusionHistory = await intrusionHistoryStorage.load();
    _applySensitivityToDetector();
    _startScheduleMonitor();
    LockdownService.instance.onUnlocked = _handleUnlock;
    notifyListeners();
  }

  void _applySensitivityToDetector() {
    detector.applyThresholds(
      rotationThreshold: sensitivitySettings.level.rotationThreshold,
      angleThreshold: sensitivitySettings.level.angleThreshold,
    );
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

    if (isArmed && !isCalibrating && !isRecalibrating) {
      await recalibrateSensors();
    }
    notifyListeners();
  }

  Future<void> recalibrateSensors() async {
    if (!isArmed || isCalibrating || isRecalibrating) return;

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
    if (isCalibrating) return;

    if (!armed) {
      await _disarm();
      notifyListeners();
      return;
    }

    isCalibrating = true;
    notifyListeners();

    try {
      _applySensitivityToDetector();
      await detector.calibrate();
      await prepareCapture();
      await detector.start(onPickup: _handleIntrusion);
      await WakelockPlus.enable();
      isArmed = true;
      isCalibrating = false;
      notifyListeners();
    } catch (error) {
      debugPrint('ProtectionCoordinator.setArmed failed: $error');
      await _disarm();
      isCalibrating = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _disarm() async {
    await _silenceAlarmCompletely();
    await detector.stop();
    if (LockdownService.instance.isActive) {
      await LockdownService.instance.deactivate(invokeCallback: false);
    }
    await intruderCapture.release();
    await WakelockPlus.disable();
    isArmed = false;
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

  void stopAlarmImmediately() {
    isAlarmRinging = false;
    AlarmService.instance.stopImmediate();
    notifyListeners();
  }

  Future<void> resumeAlarmIfLocked() async {
    if (_unlockInProgress || !LockdownService.instance.isActive || isAlarmRinging) {
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
    if (shouldArm && !isArmed && !isCalibrating && !isAlarmRinging) {
      await setArmed(true, fromSchedule: autoOnly);
    } else if (!shouldArm && isArmed && autoOnly) {
      await setArmed(false, fromSchedule: true);
    }
  }

  Future<void> _handleIntrusion() async {
    if (_unlockInProgress || _handlingIntrusion || isAlarmRinging) return;
    _handlingIntrusion = true;
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
      if (_unlockInProgress || !isAlarmRinging) {
        await AlarmService.instance.stop();
        return;
      }
      notifyListeners();
      unawaited(LockdownService.instance.activate());
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
    super.dispose();
  }
}
