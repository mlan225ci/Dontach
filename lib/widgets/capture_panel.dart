import 'package:flutter/material.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../models/capture_settings.dart';

class CapturePanel extends StatelessWidget {
  const CapturePanel({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final CaptureSettings settings;
  final ValueChanged<CaptureSettings> onChanged;

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
                Icons.photo_camera_front_rounded,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.discretePhoto,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Switch.adaptive(
                value: settings.enabled,
                activeTrackColor: const Color(0xFF2E7D32),
                onChanged: (enabled) =>
                    onChanged(settings.copyWith(enabled: enabled)),
              ),
            ],
          ),
          if (settings.enabled) ...[
            const SizedBox(height: 12),
            Text(
              l10n.discretePhotoDescription,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
