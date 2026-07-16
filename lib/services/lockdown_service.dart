import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'lockdown_notification_service.dart';
import 'platform_lock_service.dart';

typedef LockdownCallback = Future<void> Function();

class LockdownService extends ChangeNotifier {
  LockdownService._();

  static final LockdownService instance = LockdownService._();

  bool _isActive = false;
  LockdownCallback? onUnlocked;

  bool get isActive => _isActive;

  Future<void> activate() async {
    if (_isActive) return;
    _isActive = true;
    notifyListeners();

    try {
      await PlatformLockService.instance.activateLockdown();
      await LockdownNotificationService.instance.showLockdownNotification();
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (error) {
      debugPrint('LockdownService.activate failed: $error');
    }
  }

  Future<void> deactivate({bool invokeCallback = true}) async {
    final wasActive = _isActive;
    _isActive = false;
    notifyListeners();

    try {
      await LockdownNotificationService.instance.cancelLockdownNotification();
      await PlatformLockService.instance.deactivateLockdown();
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (error) {
      debugPrint('LockdownService.deactivate failed: $error');
    }

    if (invokeCallback && wasActive) {
      await onUnlocked?.call();
    }
  }
}
