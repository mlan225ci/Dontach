import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/schedule_config.dart';

class ScheduleStorage {
  static const _key = 'schedule_config';

  Future<ScheduleConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const ScheduleConfig();

    try {
      return ScheduleConfig.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const ScheduleConfig();
    }
  }

  Future<void> save(ScheduleConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(config.toJson()));
  }
}
