import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorage {
  static const _key = 'app_locale';

  Future<Locale?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null) return null;
    return Locale(code);
  }

  Future<void> save(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
