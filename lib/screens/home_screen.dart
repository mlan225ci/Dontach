import 'package:flutter/material.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../models/capture_settings.dart';
import '../services/protection_coordinator.dart';
import '../widgets/capture_panel.dart';
import '../widgets/power_switch.dart';
import '../widgets/schedule_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProtectionCoordinator _coordinator = ProtectionCoordinator.instance;

  @override
  void initState() {
    super.initState();
    _coordinator.addListener(_onCoordinatorChanged);
  }

  void _onCoordinatorChanged() {
    if (mounted) setState(() {});
  }

  List<String> _weekdayLabels(AppLocalizations l10n) => [
        l10n.weekdayMon,
        l10n.weekdayTue,
        l10n.weekdayWed,
        l10n.weekdayThu,
        l10n.weekdayFri,
        l10n.weekdaySat,
        l10n.weekdaySun,
      ];

  Future<void> _onSwitchChanged(bool value) async {
    try {
      await _coordinator.setArmed(value);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.sensorsError)),
      );
    }
  }

  Future<void> _updateCaptureSettings(CaptureSettings settings) async {
    await _coordinator.updateCaptureSettings(settings);
    if (!_coordinator.intruderCapture.isReady &&
        _coordinator.captureSettings.enabled &&
        _coordinator.isArmed &&
        mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cameraPermissionError),
        ),
      );
    }
  }

  @override
  void dispose() {
    _coordinator.removeListener(_onCoordinatorChanged);
    super.dispose();
  }

  String _statusText(AppLocalizations l10n) {
    if (_coordinator.isCalibrating) return l10n.calibrating;
    if (_coordinator.isAlarmRinging) return l10n.locked;
    if (_coordinator.isArmed) return l10n.protectionActive;
    if (_coordinator.schedule.enabled &&
        _coordinator.schedule.isActiveAt(DateTime.now())) {
      return l10n.schedulePending;
    }
    return l10n.protectionInactive;
  }

  String _helperText(AppLocalizations l10n) {
    if (_coordinator.isAlarmRinging) {
      return l10n.enterCodeToUnlock;
    }
    if (_coordinator.isArmed) {
      return l10n.placePhoneFlat;
    }
    if (_coordinator.schedule.enabled) {
      final weekdays = _weekdayLabels(l10n);
      return l10n.scheduleAutoActivate(
        _coordinator.schedule.timeRangeLabel(),
        _coordinator.schedule.daysLabel(
          weekdayLabels: weekdays,
          noDaysLabel: l10n.noDays,
          everyDayLabel: l10n.everyDay,
        ),
      );
    }
    return l10n.activateOrSchedule;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backgroundColor = _coordinator.isArmed
        ? const Color(0xFF042A04)
        : const Color(0xFF121212);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                    maxWidth: 420,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        l10n.appTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          _statusText(l10n),
                          key: ValueKey(_statusText(l10n)),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.78),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: PowerSwitch(
                          value: _coordinator.isArmed || _coordinator.isAlarmRinging,
                          isLoading: _coordinator.isCalibrating,
                          onChanged: _onSwitchChanged,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        _helperText(l10n),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.58),
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 16),
                      CapturePanel(
                        settings: _coordinator.captureSettings,
                        onChanged: _updateCaptureSettings,
                      ),
                      const SizedBox(height: 16),
                      SchedulePanel(
                        config: _coordinator.schedule,
                        onChanged: _coordinator.updateSchedule,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
