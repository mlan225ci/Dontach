import 'package:flutter/material.dart';

class ScheduleConfig {
  const ScheduleConfig({
    this.enabled = false,
    this.startTime = const TimeOfDay(hour: 22, minute: 0),
    this.endTime = const TimeOfDay(hour: 7, minute: 0),
    this.days = const {1, 2, 3, 4, 5},
  });

  final bool enabled;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Set<int> days;

  ScheduleConfig copyWith({
    bool? enabled,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Set<int>? days,
  }) {
    return ScheduleConfig(
      enabled: enabled ?? this.enabled,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      days: days ?? this.days,
    );
  }

  bool isActiveAt(DateTime moment) {
    if (!enabled || days.isEmpty) return false;

    final current = moment.hour * 60 + moment.minute;
    final start = startTime.hour * 60 + startTime.minute;
    final end = endTime.hour * 60 + endTime.minute;

    if (start == end) {
      return days.contains(moment.weekday);
    }

    if (start < end) {
      if (!days.contains(moment.weekday)) return false;
      return current >= start && current < end;
    }

    if (days.contains(moment.weekday) && current >= start) {
      return true;
    }

    final previousDay = moment.weekday == 1 ? 7 : moment.weekday - 1;
    return days.contains(previousDay) && current < end;
  }

  String timeRangeLabel() {
    return '${_formatTime(startTime)} – ${_formatTime(endTime)}';
  }

  String daysLabel({
    required List<String> weekdayLabels,
    required String noDaysLabel,
    required String everyDayLabel,
  }) {
    if (days.isEmpty) return noDaysLabel;
    if (days.length == 7) return everyDayLabel;

    final sorted = days.toList()..sort();
    return sorted.map((day) => weekdayLabels[day - 1]).join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'startHour': startTime.hour,
      'startMinute': startTime.minute,
      'endHour': endTime.hour,
      'endMinute': endTime.minute,
      'days': days.toList(),
    };
  }

  factory ScheduleConfig.fromJson(Map<String, dynamic> json) {
    return ScheduleConfig(
      enabled: json['enabled'] as bool? ?? false,
      startTime: TimeOfDay(
        hour: json['startHour'] as int? ?? 22,
        minute: json['startMinute'] as int? ?? 0,
      ),
      endTime: TimeOfDay(
        hour: json['endHour'] as int? ?? 7,
        minute: json['endMinute'] as int? ?? 0,
      ),
      days: (json['days'] as List<dynamic>? ?? [1, 2, 3, 4, 5])
          .map((day) => day as int)
          .toSet(),
    );
  }

  static String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
