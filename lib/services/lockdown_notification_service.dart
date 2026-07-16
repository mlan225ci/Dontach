import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dontach/l10n/app_localizations.dart';

class LockdownNotificationService {
  LockdownNotificationService._();

  static final LockdownNotificationService instance =
      LockdownNotificationService._();

  static const _channelId = 'dontach_lockdown';
  static const _notificationId = 9001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  Locale _locale = const Locale('en');

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
  }

  AppLocalizations get _l10n => lookupAppLocalizations(_locale);

  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      _initialized = true;
      return;
    }

    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const settings = InitializationSettings(android: androidSettings);

      await _plugin.initialize(settings: settings);
      await _ensureChannel();
    } catch (_) {
      // Notifications indisponibles (tests, plateforme non supportée).
    }

    _initialized = true;
  }

  Future<void> _ensureChannel() async {
    final l10n = _l10n;
    final channel = AndroidNotificationChannel(
      _channelId,
      l10n.lockdownChannelName,
      description: l10n.lockdownChannelDescription,
      importance: Importance.high,
      playSound: false,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showLockdownNotification() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    await initialize();
    await _ensureChannel();

    final l10n = _l10n;
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        l10n.lockdownChannelName,
        channelDescription: l10n.lockdownChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        ongoing: true,
        autoCancel: false,
        category: AndroidNotificationCategory.status,
        visibility: NotificationVisibility.public,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await _plugin.show(
      id: _notificationId,
      title: l10n.appTitle,
      body: l10n.phoneLockedNotification,
      notificationDetails: details,
    );
  }

  Future<void> cancelLockdownNotification() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _plugin.cancel(id: _notificationId);
    } catch (_) {
      // Ignored when notifications are unavailable.
    }
  }
}
