import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class BatteryOptimizationService {
  BatteryOptimizationService._();

  static final BatteryOptimizationService instance = BatteryOptimizationService._();

  static const _channel = MethodChannel('com.dontach.dontach/platform');

  Future<bool> isIgnoringOptimizations() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return true;

    try {
      final result = await _channel.invokeMethod<bool>('isIgnoringBatteryOptimizations');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> requestIgnoreOptimizations() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return true;

    try {
      final result = await _channel.invokeMethod<bool>('requestIgnoreBatteryOptimizations');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> openBatterySettings() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    try {
      await _channel.invokeMethod<void>('openBatteryOptimizationSettings');
    } on PlatformException {
      // Ignored on unsupported platforms.
    }
  }
}
