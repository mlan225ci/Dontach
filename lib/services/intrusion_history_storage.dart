import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/intrusion_event.dart';

class IntrusionHistoryStorage {
  static const _key = 'intrusion_history';
  static const maxEntries = 100;

  Future<List<IntrusionEvent>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => IntrusionEvent.fromJson(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (_) {
      return [];
    }
  }

  Future<void> add(IntrusionEvent event) async {
    final events = await load();
    events.insert(0, event);
    if (events.length > maxEntries) {
      events.removeRange(maxEntries, events.length);
    }
    await _save(events);
  }

  Future<void> markPhotoCaptured(String id) async {
    final events = await load();
    final index = events.indexWhere((event) => event.id == id);
    if (index == -1) return;

    events[index] = IntrusionEvent(
      id: events[index].id,
      timestamp: events[index].timestamp,
      photoCaptured: true,
    );
    await _save(events);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> _save(List<IntrusionEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(events.map((event) => event.toJson()).toList()),
    );
  }
}
