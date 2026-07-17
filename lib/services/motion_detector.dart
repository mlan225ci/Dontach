import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

import '../models/sensitivity_settings.dart';

class MotionDetector {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  StreamSubscription<UserAccelerometerEvent>? _userAccelSub;
  void Function()? _onPickup;

  double _baselineX = 0;
  double _baselineY = 0;
  double _baselineZ = 0;
  bool _triggered = false;

  ProtectionMode _mode = ProtectionMode.table;
  double _rotationThreshold = 2.5;
  double _extractionAngle = 50.0;
  double _snatchThreshold = 7.0;
  double _snatchAngleMin = 40.0;
  double _walkingTolerance = 38.0;
  Duration _sustainDuration = Duration.zero;
  Duration _walkingGrace = Duration.zero;

  // Pocket-mode state
  DateTime? _monitoringStartedAt;
  double _smoothedAngle = 0;
  DateTime? _extractionStartedAt;
  final List<_AccelSample> _recentUserAccel = [];

  Timer? _sustainTimer;
  bool _sustainActive = false;

  void applySettings(SensitivitySettings settings) {
    _mode = settings.mode;
    final level = settings.level;
    _rotationThreshold = level.rotationThreshold(settings.mode);
    _extractionAngle = level.extractionAngle(settings.mode);
    _snatchThreshold = level.snatchThreshold(settings.mode);
    _snatchAngleMin = level.snatchAngleMin(settings.mode);
    _walkingTolerance = level.walkingTolerance(settings.mode);
    _sustainDuration = level.sustainDuration(settings.mode);
    _walkingGrace = level.walkingGrace(settings.mode);
  }

  Future<void> calibrate({Duration sampleDuration = const Duration(milliseconds: 800)}) async {
    _triggered = false;
    _resetPocketState();
    _resetSustain();
    final samples = <AccelerometerEvent>[];

    final sub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(samples.add);

    await Future<void>.delayed(sampleDuration);
    await sub.cancel();

    if (samples.isEmpty) return;

    _baselineX =
        samples.map((event) => event.x).reduce((a, b) => a + b) / samples.length;
    _baselineY =
        samples.map((event) => event.y).reduce((a, b) => a + b) / samples.length;
    _baselineZ =
        samples.map((event) => event.z).reduce((a, b) => a + b) / samples.length;
  }

  Future<void> start({required void Function() onPickup}) async {
    _onPickup = onPickup;
    _triggered = false;
    _resetPocketState();
    _resetSustain();

    if (_mode == ProtectionMode.pocket) {
      _monitoringStartedAt = DateTime.now();

      _userAccelSub = userAccelerometerEventStream(
        samplingPeriod: SensorInterval.gameInterval,
      ).listen(_onPocketUserAccel);

      _accelSub = accelerometerEventStream(
        samplingPeriod: SensorInterval.gameInterval,
      ).listen(_onPocketAccel);
      return;
    }

    _gyroSub = gyroscopeEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      if (magnitude > _rotationThreshold) {
        _fire();
      }
    });

    _accelSub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen((event) {
      final angle = _angleFromBaseline(event.x, event.y, event.z);
      if (angle > _extractionAngle) {
        _fire();
      }
    });
  }

  bool get _inWalkingGrace {
    final started = _monitoringStartedAt;
    if (started == null) return true;
    return DateTime.now().difference(started) < _walkingGrace;
  }

  void _onPocketUserAccel(UserAccelerometerEvent event) {
    if (_triggered || _inWalkingGrace) return;

    final now = DateTime.now();
    final magnitude = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    _recentUserAccel.add(_AccelSample(now, magnitude));
    _recentUserAccel.removeWhere(
      (sample) => now.difference(sample.time) > const Duration(milliseconds: 300),
    );

    final peak = _recentUserAccel.fold(0.0, (max, s) => max > s.magnitude ? max : s.magnitude);

    // Snatch = violent pull WHILE orientation is already shifting out of pocket.
    if (peak >= _snatchThreshold && _smoothedAngle >= _snatchAngleMin) {
      _fire();
    }
  }

  void _onPocketAccel(AccelerometerEvent event) {
    if (_triggered || _inWalkingGrace) return;

    final rawAngle = _angleFromBaseline(event.x, event.y, event.z);
    _smoothedAngle = _smoothedAngle == 0
        ? rawAngle
        : _smoothedAngle * 0.86 + rawAngle * 0.14;

    // Walking zone — orientation wobbles but returns; never alarm here.
    if (_smoothedAngle <= _walkingTolerance) {
      _resetExtractionSustain();
      return;
    }

    // Between tolerance and extraction — still in pocket, possibly walking faster.
    if (_smoothedAngle < _extractionAngle) {
      _resetExtractionSustain();
      return;
    }

    // Extraction zone — phone orientation has clearly left the pocket baseline.
    _registerExtractionSustain();
  }

  void _registerExtractionSustain() {
    if (_triggered) return;

    final now = DateTime.now();
    _extractionStartedAt ??= now;

    if (_sustainDuration == Duration.zero) {
      _fire();
      return;
    }

    if (!_sustainActive) {
      _sustainActive = true;
      _sustainTimer = Timer(_sustainDuration, () {
        if (!_triggered &&
            _sustainActive &&
            _smoothedAngle >= _extractionAngle) {
          _fire();
        }
      });
    }
  }

  void _resetExtractionSustain() {
    _extractionStartedAt = null;
    _resetSustain();
  }

  void _resetPocketState() {
    _monitoringStartedAt = null;
    _smoothedAngle = 0;
    _extractionStartedAt = null;
    _recentUserAccel.clear();
  }

  void _resetSustain() {
    _sustainTimer?.cancel();
    _sustainTimer = null;
    _sustainActive = false;
  }

  double _angleFromBaseline(double x, double y, double z) {
    final dot = x * _baselineX + y * _baselineY + z * _baselineZ;
    final magA = sqrt(x * x + y * y + z * z);
    final magB = sqrt(
      _baselineX * _baselineX + _baselineY * _baselineY + _baselineZ * _baselineZ,
    );
    if (magA == 0 || magB == 0) return 0;

    final cosAngle = (dot / (magA * magB)).clamp(-1.0, 1.0);
    return acos(cosAngle) * 180 / pi;
  }

  void _fire() {
    if (_triggered) return;
    _triggered = true;
    _resetExtractionSustain();
    _onPickup?.call();
  }

  Future<void> resetTrigger() async {
    _triggered = false;
    _resetExtractionSustain();
  }

  Future<void> stop() async {
    _resetExtractionSustain();
    _resetPocketState();
    await _accelSub?.cancel();
    await _gyroSub?.cancel();
    await _userAccelSub?.cancel();
    _accelSub = null;
    _gyroSub = null;
    _userAccelSub = null;
  }
}

class _AccelSample {
  _AccelSample(this.time, this.magnitude);

  final DateTime time;
  final double magnitude;
}
