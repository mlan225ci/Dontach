import 'package:flutter/material.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../models/sensitivity_settings.dart';

class DetectionModePanel extends StatelessWidget {
  const DetectionModePanel({
    super.key,
    required this.settings,
    required this.enabled,
    required this.onChanged,
  });

  final SensitivitySettings settings;
  final bool enabled;
  final ValueChanged<ProtectionMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_moon_rounded,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.protectionMode,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ModeChip(
                  label: l10n.modeTable,
                  icon: Icons.table_restaurant_rounded,
                  selected: settings.mode == ProtectionMode.table,
                  enabled: enabled,
                  onTap: () => onChanged(ProtectionMode.table),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeChip(
                  label: l10n.modePocket,
                  icon: Icons.back_hand_rounded,
                  selected: settings.mode == ProtectionMode.pocket,
                  enabled: enabled,
                  onTap: () => onChanged(ProtectionMode.pocket),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            settings.mode == ProtectionMode.pocket
                ? l10n.modePocketDescription
                : l10n.modeTableDescription,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.58),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF2E7D32) : Colors.white.withValues(alpha: 0.08);

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : Colors.white.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
