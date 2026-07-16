import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dontach/models/schedule_config.dart';

void main() {
  group('ScheduleConfig', () {
    test('is active during same-day range', () {
      const config = ScheduleConfig(
        enabled: true,
        startTime: TimeOfDay(hour: 9, minute: 0),
        endTime: TimeOfDay(hour: 17, minute: 0),
        days: {1},
      );

      expect(
        config.isActiveAt(DateTime(2026, 7, 13, 10, 0)),
        isTrue,
      );
      expect(
        config.isActiveAt(DateTime(2026, 7, 13, 18, 0)),
        isFalse,
      );
    });

    test('is active during overnight range', () {
      const config = ScheduleConfig(
        enabled: true,
        startTime: TimeOfDay(hour: 22, minute: 0),
        endTime: TimeOfDay(hour: 7, minute: 0),
        days: {1},
      );

      expect(
        config.isActiveAt(DateTime(2026, 7, 13, 23, 0)),
        isTrue,
      );
      expect(
        config.isActiveAt(DateTime(2026, 7, 14, 6, 30)),
        isTrue,
      );
      expect(
        config.isActiveAt(DateTime(2026, 7, 14, 12, 0)),
        isFalse,
      );
      expect(
        config.isActiveAt(DateTime(2026, 7, 15, 6, 30)),
        isFalse,
      );
    });
  });
}
