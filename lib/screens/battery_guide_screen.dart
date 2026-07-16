import 'package:flutter/material.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../services/battery_optimization_service.dart';

class BatteryGuideScreen extends StatefulWidget {
  const BatteryGuideScreen({super.key});

  @override
  State<BatteryGuideScreen> createState() => _BatteryGuideScreenState();
}

class _BatteryGuideScreenState extends State<BatteryGuideScreen> {
  final BatteryOptimizationService _batteryService =
      BatteryOptimizationService.instance;

  bool _isIgnoring = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  Future<void> _refreshStatus() async {
    setState(() => _loading = true);
    final ignoring = await _batteryService.isIgnoringOptimizations();
    if (!mounted) return;
    setState(() {
      _isIgnoring = ignoring;
      _loading = false;
    });
  }

  Future<void> _requestExemption() async {
    await _batteryService.requestIgnoreOptimizations();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await _refreshStatus();
  }

  Future<void> _openSettings() async {
    await _batteryService.openBatterySettings();
    await Future<void>.delayed(const Duration(seconds: 1));
    await _refreshStatus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: Text(l10n.batteryGuideTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (_isIgnoring ? const Color(0xFF2E7D32) : const Color(0xFFE53935))
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (_isIgnoring ? const Color(0xFF2E7D32) : const Color(0xFFE53935))
                    .withValues(alpha: 0.35),
              ),
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : Row(
                    children: [
                      Icon(
                        _isIgnoring ? Icons.check_circle_rounded : Icons.warning_rounded,
                        color: _isIgnoring ? const Color(0xFF2E7D32) : const Color(0xFFE53935),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isIgnoring
                              ? l10n.batteryOptimizationEnabled
                              : l10n.batteryOptimizationDisabled,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.batteryOptimizationDescription,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), height: 1.5),
          ),
          const SizedBox(height: 24),
          _StepCard(number: 1, text: l10n.batteryGuideStep1),
          const SizedBox(height: 12),
          _StepCard(number: 2, text: l10n.batteryGuideStep2),
          const SizedBox(height: 12),
          _StepCard(number: 3, text: l10n.batteryGuideStep3),
          const SizedBox(height: 12),
          _StepCard(number: 4, text: l10n.batteryGuideStep4),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _requestExemption,
              icon: const Icon(Icons.battery_charging_full_rounded),
              label: Text(l10n.batteryRequestExemption),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openSettings,
              icon: const Icon(Icons.settings_rounded),
              label: Text(l10n.batteryOpenSettings),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF2E7D32),
            child: Text('$number', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
