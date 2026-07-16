import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/capture_settings.dart';

class CaptureSettingsStorage {
  static const _key = 'capture_settings';

  Future<CaptureSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const CaptureSettings();

    try {
      return CaptureSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const CaptureSettings();
    }
  }

  Future<void> save(CaptureSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}
