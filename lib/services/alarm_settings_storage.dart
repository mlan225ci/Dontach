import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/alarm_settings.dart';

class AlarmSettingsStorage {
  static const _key = 'alarm_settings';

  Future<AlarmSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const AlarmSettings();

    try {
      return AlarmSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const AlarmSettings();
    }
  }

  Future<void> save(AlarmSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}
