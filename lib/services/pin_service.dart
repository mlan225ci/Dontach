import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  PinService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _hashKey = 'dontach_pin_hash';
  static const _saltKey = 'dontach_pin_salt';

  final FlutterSecureStorage _storage;

  Future<bool> hasPin() async {
    final hash = await _storage.read(key: _hashKey);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    _validatePin(pin);
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await _storage.write(key: _hashKey, value: hash);
    await _storage.write(key: _saltKey, value: salt);
  }

  Future<bool> verifyPin(String pin) async {
    final hash = await _storage.read(key: _hashKey);
    final salt = await _storage.read(key: _saltKey);
    if (hash == null || salt == null) return false;
    return hash == _hashPin(pin, salt);
  }

  void _validatePin(String pin) {
    if (!RegExp(r'^\d{4,6}$').hasMatch(pin)) {
      throw ArgumentError('invalid_pin');
    }
  }

  String _generateSalt() {
    final random = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    return sha256.convert(utf8.encode(random)).toString();
  }

  String _hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt:$pin')).toString();
  }
}
