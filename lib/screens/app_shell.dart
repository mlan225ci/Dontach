import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/language_selection_screen.dart';
import '../screens/lock_screen.dart';
import '../screens/setup_pin_screen.dart';
import '../services/locale_storage.dart';
import '../services/lockdown_notification_service.dart';
import '../services/lockdown_service.dart';
import '../services/pin_service.dart';
import '../services/protection_coordinator.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.localeStorage,
    required this.onLocaleChanged,
  });

  final LocaleStorage localeStorage;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  final PinService _pinService = PinService.instance;
  final LockdownService _lockdown = LockdownService.instance;
  final ProtectionCoordinator _coordinator = ProtectionCoordinator.instance;

  bool _loading = true;
  bool _hasLocale = false;
  bool _hasPin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lockdown.addListener(_onStateChanged);
    _coordinator.addListener(_onStateChanged);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final minSplash = Future<void>.delayed(const Duration(milliseconds: 1600));
      await LockdownNotificationService.instance.initialize();
      final locale = await widget.localeStorage.load();
      final hasPin = await _pinService.hasPin().timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
      await minSplash;
      if (!mounted) return;
      if (locale != null) {
        widget.onLocaleChanged(locale);
        await LockdownNotificationService.instance.setLocale(locale);
      }
      setState(() {
        _hasLocale = locale != null;
        _hasPin = hasPin;
        _loading = false;
      });
      if (hasPin && locale != null) {
        await ProtectionCoordinator.instance.initialize();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasLocale = false;
        _hasPin = false;
        _loading = false;
      });
    }
  }

  Future<void> _updateLocale(Locale locale) async {
    await widget.localeStorage.save(locale);
    widget.onLocaleChanged(locale);
    await LockdownNotificationService.instance.setLocale(locale);
  }

  Future<void> _handleLocaleSelected(Locale locale) async {
    await _updateLocale(locale);
    setState(() => _hasLocale = true);
    if (_hasPin) {
      await ProtectionCoordinator.instance.initialize();
    }
  }

  void _handlePinConfigured() {
    setState(() => _hasPin = true);
    ProtectionCoordinator.instance.initialize();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _coordinator.requiresUnlock) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lockdown.removeListener(_onStateChanged);
    _coordinator.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SplashScreen();
    }

    if (!_hasLocale) {
      return LanguageSelectionScreen(onSelected: _handleLocaleSelected);
    }

    if (!_hasPin) {
      return SetupPinScreen(onConfigured: _handlePinConfigured);
    }

    if (_coordinator.requiresUnlock) {
      return const LockScreen();
    }

    return HomeScreen(
      onLocaleChanged: _updateLocale,
    );
  }
}
