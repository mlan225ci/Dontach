import 'package:flutter/material.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../models/sensitivity_settings.dart';
import '../services/protection_coordinator.dart';
import '../widgets/volume_panel.dart';
import 'battery_guide_screen.dart';
import 'change_pin_screen.dart';
import 'intrusion_history_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.onLocaleChanged,
  });

  final Future<void> Function(Locale) onLocaleChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ProtectionCoordinator _coordinator = ProtectionCoordinator.instance;

  static const _supportedLocales = [
    Locale('fr'),
    Locale('es'),
    Locale('en'),
  ];

  @override
  void initState() {
    super.initState();
    _coordinator.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _coordinator.removeListener(_onChanged);
    super.dispose();
  }

  String _languageLabel(AppLocalizations l10n, String code) {
    switch (code) {
      case 'fr':
        return l10n.languageFrench;
      case 'es':
        return l10n.languageSpanish;
      case 'en':
        return l10n.languageEnglish;
      default:
        return code;
    }
  }

  String _sensitivityLabel(AppLocalizations l10n, SensitivityLevel level) {
    switch (level) {
      case SensitivityLevel.low:
        return l10n.sensitivityLow;
      case SensitivityLevel.medium:
        return l10n.sensitivityMedium;
      case SensitivityLevel.high:
        return l10n.sensitivityHigh;
    }
  }

  Future<void> _selectLanguage(BuildContext context, Locale locale) async {
    final current = Localizations.localeOf(context);
    if (locale.languageCode == current.languageCode) return;
    await widget.onLocaleChanged(locale);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.languageUpdated)),
      );
    }
  }

  Future<void> _selectSensitivity(SensitivityLevel level) async {
    await _coordinator.updateSensitivity(
      _coordinator.sensitivitySettings.copyWith(level: level),
    );
  }

  Future<void> _selectMode(ProtectionMode mode) async {
    await _coordinator.updateProtectionMode(mode);
  }

  String _modeLabel(AppLocalizations l10n, ProtectionMode mode) {
    switch (mode) {
      case ProtectionMode.table:
        return l10n.modeTable;
      case ProtectionMode.pocket:
        return l10n.modePocket;
    }
  }

  Future<void> _recalibrate(AppLocalizations l10n) async {
    if (!_coordinator.isArmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.recalibrateRequiresArmed)),
      );
      return;
    }

    await _coordinator.recalibrateSensors();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.recalibrateSuccess)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final currentSensitivity = _coordinator.sensitivitySettings.level;
    final currentMode = _coordinator.sensitivitySettings.mode;
    final canEditDetection = !_coordinator.isArmed &&
        !_coordinator.isCalibrating &&
        !_coordinator.isAlarmRinging &&
        !_coordinator.isPlacementPending;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _SectionHeader(title: l10n.settingsAlarm),
          VolumePanel(
            settings: _coordinator.alarmSettings,
            onChanged: _coordinator.updateAlarmSettings,
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: l10n.settingsGeneral),
          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.language_rounded, color: Colors.white.withValues(alpha: 0.85)),
                      const SizedBox(width: 12),
                      Text(
                        l10n.language,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ..._supportedLocales.map((locale) {
                  final selected = locale.languageCode == currentLocale.languageCode;
                  return ListTile(
                    title: Text(
                      _languageLabel(l10n, locale.languageCode),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.92)),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_rounded, color: Color(0xFF2E7D32))
                        : null,
                    onTap: () => _selectLanguage(context, locale),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: l10n.settingsDetection),
          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    l10n.protectionMode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    currentMode == ProtectionMode.pocket
                        ? l10n.modePocketDescription
                        : l10n.modeTableDescription,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.4),
                  ),
                ),
                ...ProtectionMode.values.map((mode) {
                  final selected = mode == currentMode;
                  return ListTile(
                    enabled: canEditDetection,
                    title: Text(
                      _modeLabel(l10n, mode),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.92)),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_rounded, color: Color(0xFF2E7D32))
                        : null,
                    onTap: canEditDetection ? () => _selectMode(mode) : null,
                  );
                }),
                const Divider(height: 1, color: Color(0x22FFFFFF)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    l10n.sensitivity,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    l10n.sensitivityDescription,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.4),
                  ),
                ),
                ...SensitivityLevel.values.map((level) {
                  final selected = level == currentSensitivity;
                  return ListTile(
                    title: Text(
                      _sensitivityLabel(l10n, level),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.92)),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_rounded, color: Color(0xFF2E7D32))
                        : null,
                    onTap: () => _selectSensitivity(level),
                  );
                }),
                const Divider(height: 1, color: Color(0x22FFFFFF)),
                ListTile(
                  leading: Icon(Icons.center_focus_strong_rounded,
                      color: Colors.white.withValues(alpha: 0.85)),
                  title: Text(
                    l10n.recalibrate,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    currentMode == ProtectionMode.pocket
                        ? l10n.recalibratePocketDescription
                        : l10n.recalibrateDescription,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
                  ),
                  trailing: _coordinator.isRecalibrating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(Icons.refresh_rounded, color: Colors.white.withValues(alpha: 0.45)),
                  onTap: _coordinator.isRecalibrating ? null : () => _recalibrate(l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: l10n.settingsSecurity),
          _SettingsCard(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.pin_rounded, color: Colors.white.withValues(alpha: 0.85)),
                  title: Text(
                    l10n.changePin,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    l10n.changePinDescription,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded,
                      color: Colors.white.withValues(alpha: 0.45)),
                  onTap: () async {
                    final changed = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(builder: (_) => const ChangePinScreen()),
                    );
                    if (changed == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.pinChangedSuccess)),
                      );
                    }
                  },
                ),
                const Divider(height: 1, color: Color(0x22FFFFFF)),
                ListTile(
                  leading: Icon(Icons.history_rounded, color: Colors.white.withValues(alpha: 0.85)),
                  title: Text(
                    l10n.intrusionHistory,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    l10n.intrusionHistoryDescription,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded,
                      color: Colors.white.withValues(alpha: 0.45)),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const IntrusionHistoryScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: l10n.settingsPerformance),
          _SettingsCard(
            child: ListTile(
              leading: Icon(Icons.battery_alert_rounded,
                  color: Colors.white.withValues(alpha: 0.85)),
              title: Text(
                l10n.batteryOptimization,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                l10n.batteryOptimizationDescription,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
              ),
              trailing: Icon(Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.45)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BatteryGuideScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: l10n.settingsAbout),
          _SettingsCard(
            child: ListTile(
              leading: Icon(Icons.info_outline_rounded,
                  color: Colors.white.withValues(alpha: 0.85)),
              title: Text(
                l10n.appTitle,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.versionLabel('1.0.0'),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.copyright,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
