import 'package:flutter/services.dart';

class PlatformLockService {
  PlatformLockService._();

  static final PlatformLockService instance = PlatformLockService._();

  static const _channel = MethodChannel('com.dontach.dontach/platform');

  Future<void> activateLockdown() async {
    try {
      await _channel.invokeMethod<void>('activateLockdown');
    } on PlatformException {
      // Ignored on unsupported platforms.
    }
  }

  Future<void> deactivateLockdown() async {
    try {
      await _channel.invokeMethod<void>('deactivateLockdown');
    } on PlatformException {
      // Ignored on unsupported platforms.
    }
  }
}
