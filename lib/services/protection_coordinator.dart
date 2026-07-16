import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../models/capture_settings.dart';
import '../models/schedule_config.dart';
import 'alarm_service.dart';
import 'capture_settings_storage.dart';
import 'intruder_capture_service.dart';
import 'lockdown_service.dart';
import 'motion_detector.dart';
import 'schedule_storage.dart';

class ProtectionCoordinator extends ChangeNotifier {
  ProtectionCoordinator._();

  static final ProtectionCoordinator instance = ProtectionCoordinator._();

  final MotionDetector detector = MotionDetector();
  final IntruderCaptureService intruderCapture = IntruderCaptureService();
  final ScheduleStorage scheduleStorage = ScheduleStorage();
  final CaptureSettingsStorage captureSettingsStorage = CaptureSettingsStorage();

  bool isArmed = false;
  bool isCalibrating = false;
  bool isAlarmRinging = false;
  ScheduleConfig schedule = const ScheduleConfig();
  CaptureSettings captureSettings = const CaptureSettings();

  Timer? _scheduleTimer;
  bool _handlingIntrusion = false;

  bool get requiresUnlock => isAlarmRinging || LockdownService.instance.isActive;

  Future<void> initialize() async {
    schedule = await scheduleStorage.load();
    captureSettings = await captureSettingsStorage.load();
    _startScheduleMonitor();
    LockdownService.instance.onUnlocked = _handleUnlock;
    notifyListeners();
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
    stopAlarmImmediately();
    await detector.stop();
    if (LockdownService.instance.isActive) {
      await LockdownService.instance.deactivate(invokeCallback: false);
    }
    await intruderCapture.release();
    await WakelockPlus.disable();
    isArmed = false;
    notifyListeners();
  }

  void stopAlarmImmediately() {
    if (!isAlarmRinging && !AlarmService.instance.isPlaying) return;
    isAlarmRinging = false;
    _handlingIntrusion = false;
    AlarmService.instance.stopImmediate();
    notifyListeners();
  }

  Future<void> resumeAlarmIfLocked() async {
    if (!LockdownService.instance.isActive || isAlarmRinging) return;
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
    if (_handlingIntrusion || isAlarmRinging) return;
    _handlingIntrusion = true;
    isAlarmRinging = true;
    notifyListeners();

    try {
      await AlarmService.instance.play();
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
    await _silenceAlarm();
    notifyListeners();
  }

  Future<void> completeUnlock() async {
    stopAlarmImmediately();
    unawaited(_finishUnlock());
  }

  Future<void> _finishUnlock() async {
    await detector.stop();
    if (LockdownService.instance.isActive) {
      await LockdownService.instance.deactivate(invokeCallback: false);
    }
    await intruderCapture.release();
    await WakelockPlus.disable();
    isArmed = false;
    notifyListeners();
  }

  Future<void> _silenceAlarm() async {
    stopAlarmImmediately();
    if (LockdownService.instance.isActive) {
      await LockdownService.instance.deactivate(invokeCallback: false);
    }
  }

  Future<void> _captureIntruderPhoto() async {
    if (!captureSettings.enabled) return;
    await Future<void>.delayed(const Duration(seconds: 1));
    try {
      await intruderCapture.captureAndSave();
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
