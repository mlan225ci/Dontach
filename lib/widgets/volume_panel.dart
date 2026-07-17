import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../models/alarm_settings.dart';
import '../services/protection_coordinator.dart';
import 'volume_knob_3d.dart';

class VolumePanel extends StatefulWidget {
  const VolumePanel({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final AlarmSettings settings;
  final ValueChanged<AlarmSettings> onChanged;

  @override
  State<VolumePanel> createState() => _VolumePanelState();
}

class _VolumePanelState extends State<VolumePanel> {
  final ProtectionCoordinator _coordinator = ProtectionCoordinator.instance;
  bool _previewing = false;

  static const _step = 0.05;

  Future<void> _preview() async {
    if (_previewing || widget.settings.volume <= 0) return;
    setState(() => _previewing = true);
    HapticFeedback.lightImpact();
    await _coordinator.previewAlarmVolume();
    if (mounted) setState(() => _previewing = false);
  }

  void _setVolume(double value) {
    widget.onChanged(widget.settings.copyWith(volume: value.clamp(0.0, 1.0)));
  }

  void _nudge(double delta) {
    HapticFeedback.selectionClick();
    _setVolume(widget.settings.volume + delta);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMuted = widget.settings.volume <= 0.01;
    final atMin = widget.settings.volume <= 0.01;
    final atMax = widget.settings.volume >= 0.99;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF252525), Color(0xFF141414), Color(0xFF080808)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.65),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: const Color(0xFF00775B).withValues(alpha: 0.15),
            blurRadius: 48,
            spreadRadius: -6,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SpeakerBadge(isMuted: isMuted),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.alarmVolume,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.alarmVolumeDescription,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _StepButton(
                icon: Icons.remove_rounded,
                enabled: !atMin,
                onPressed: () => _nudge(-_step),
              ),
              Expanded(
                child: Center(
                  child: VolumeKnob3D(
                    value: widget.settings.volume,
                    onChanged: (v) {
                      HapticFeedback.selectionClick();
                      _setVolume(v);
                    },
                    minLabel: l10n.volumeMin,
                    maxLabel: l10n.volumeMax,
                  ),
                ),
              ),
              _StepButton(
                icon: Icons.add_rounded,
                enabled: !atMax,
                onPressed: () => _nudge(_step),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isMuted ? l10n.volumeMuted : l10n.volumeKnobHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _PreviewButton(
            previewing: _previewing,
            enabled: !isMuted,
            label: l10n.testAlarmVolume,
            onPressed: _preview,
          ),
        ],
      ),
    );
  }
}

class _SpeakerBadge extends StatelessWidget {
  const _SpeakerBadge({required this.isMuted});

  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isMuted
              ? [const Color(0xFF3A3A3A), const Color(0xFF222222)]
              : [const Color(0xFF00775B), const Color(0xFF2E7D32)],
        ),
        boxShadow: [
          BoxShadow(
            color: (isMuted ? Colors.black : const Color(0xFF00775B))
                .withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: enabled
                  ? [const Color(0xFF383838), const Color(0xFF1E1E1E)]
                  : [const Color(0xFF222222), const Color(0xFF161616)],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: enabled ? 0.12 : 0.05),
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.05),
                      blurRadius: 0,
                      offset: const Offset(0, -1),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: Colors.white.withValues(alpha: enabled ? 0.9 : 0.25),
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  const _PreviewButton({
    required this.previewing,
    required this.enabled,
    required this.label,
    required this.onPressed,
  });

  final bool previewing;
  final bool enabled;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled && !previewing ? onPressed : null,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: enabled
                  ? [const Color(0xFF333333), const Color(0xFF1A1A1A)]
                  : [const Color(0xFF1A1A1A), const Color(0xFF121212)],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: enabled ? 0.14 : 0.06),
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.06),
                      blurRadius: 0,
                      offset: const Offset(0, -1),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (previewing)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  )
                else
                  Icon(
                    Icons.play_circle_filled_rounded,
                    size: 22,
                    color: Colors.white.withValues(alpha: enabled ? 0.9 : 0.3),
                  ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: enabled ? 0.9 : 0.3),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
