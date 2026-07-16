import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/sensitivity_settings.dart';

class SensitivityStorage {
  static const _key = 'sensitivity_settings';

  Future<SensitivitySettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const SensitivitySettings();

    try {
      return SensitivitySettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const SensitivitySettings();
    }
  }

  Future<void> save(SensitivitySettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}
