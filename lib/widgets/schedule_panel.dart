import 'package:flutter/material.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../models/schedule_config.dart';

class SchedulePanel extends StatelessWidget {
  const SchedulePanel({
    super.key,
    required this.config,
    required this.onChanged,
  });

  final ScheduleConfig config;
  final ValueChanged<ScheduleConfig> onChanged;

  List<String> _weekdayLabels(AppLocalizations l10n) => [
        l10n.weekdayMon,
        l10n.weekdayTue,
        l10n.weekdayWed,
        l10n.weekdayThu,
        l10n.weekdayFri,
        l10n.weekdaySat,
        l10n.weekdaySun,
      ];

  Future<void> _pickTime(
    BuildContext context, {
    required TimeOfDay initial,
    required ValueChanged<TimeOfDay> onSelected,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2E7D32),
              surface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onSelected(picked);
  }

  void _toggleDay(int day) {
    final days = Set<int>.from(config.days);
    if (days.contains(day)) {
      days.remove(day);
    } else {
      days.add(day);
    }
    onChanged(config.copyWith(days: days));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weekdays = _weekdayLabels(l10n);

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
                Icons.schedule_rounded,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.schedule,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Switch.adaptive(
                value: config.enabled,
                activeTrackColor: const Color(0xFF2E7D32),
                onChanged: (enabled) => onChanged(config.copyWith(enabled: enabled)),
              ),
            ],
          ),
          if (config.enabled) ...[
            const SizedBox(height: 18),
            Text(
              l10n.scheduleAutoBetween,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TimeTile(
                    label: l10n.start,
                    time: config.startTime,
                    onTap: () => _pickTime(
                      context,
                      initial: config.startTime,
                      onSelected: (time) =>
                          onChanged(config.copyWith(startTime: time)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
                Expanded(
                  child: _TimeTile(
                    label: l10n.end,
                    time: config.endTime,
                    onTap: () => _pickTime(
                      context,
                      initial: config.endTime,
                      onSelected: (time) =>
                          onChanged(config.copyWith(endTime: time)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              l10n.days,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(7, (index) {
                final day = index + 1;
                final selected = config.days.contains(day);
                return FilterChip(
                  label: Text(weekdays[index]),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: const Color(0xFF2E7D32),
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color: selected
                        ? const Color(0xFF2E7D32)
                        : Colors.white.withValues(alpha: 0.12),
                  ),
                  onSelected: (_) => _toggleDay(day),
                );
              }),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                '${config.timeRangeLabel()} · ${config.daysLabel(
                  weekdayLabels: weekdays,
                  noDaysLabel: l10n.noDays,
                  everyDayLabel: l10n.everyDay,
                )}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                formatted,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
