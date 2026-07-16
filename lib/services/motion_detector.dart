import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class MotionDetector {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  void Function()? _onPickup;

  double _baselineX = 0;
  double _baselineY = 0;
  double _baselineZ = 0;
  bool _triggered = false;

  double _rotationThreshold = 2.5;
  double _angleThreshold = 25.0;

  void applyThresholds({
    required double rotationThreshold,
    required double angleThreshold,
  }) {
    _rotationThreshold = rotationThreshold;
    _angleThreshold = angleThreshold;
  }

  Future<void> calibrate() async {
    _triggered = false;
    final samples = <AccelerometerEvent>[];

    final sub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(samples.add);

    await Future<void>.delayed(const Duration(milliseconds: 500));
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
      if (angle > _angleThreshold) {
        _fire();
      }
    });
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
    _onPickup?.call();
  }

  Future<void> resetTrigger() async {
    _triggered = false;
  }

  Future<void> stop() async {
    await _accelSub?.cancel();
    await _gyroSub?.cancel();
    _accelSub = null;
    _gyroSub = null;
  }
}
